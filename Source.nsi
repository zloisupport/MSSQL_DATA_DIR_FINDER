
RequestExecutionLevel user
Name "MSSQL_DATA_DIR_FINDER"

; General Symbol Definitions
!define MUI_UI "./modern.exe"

!define COMPANY       "zloisupport"
!define AppName       "MSSQLSERVER DB Dir "
!define AppVersion    "0.0.3.0"
!define URL           "http://coolsoft.altervista.org/nsisdialogdesigner"
!define AppDev         "Zloiupport"
!define MUI_ICON "AppIcon.ico"
!include "Sections.nsh"
!include "MUI2.nsh"
!include "x64.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "Registry.nsh"

VIProductVersion "0.0.0.0"
VIAddVersionKey ProductName "${AppName}"
VIAddVersionKey ProductVersion "0.0.0.0"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "0.0.0.0"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""

; installer properties
XPStyle on

; The file to write
OutFile "${AppName}-${AppVersion}.exe"

SetOverwrite on

; MUI Symbol Definitions
!include Sections.nsh
!include MUI2.nsh
!insertmacro MUI_LANGUAGE English

; =========================================================
; dialog script begins here
; =========================================================

  Page custom fnc_REG_GET_MSSQL_path_Show

; handle variables
Var hCtl_REG_GET_MSSQL_path
Var hCtl_REG_GET_MSSQL_path_Bitmap1
Var hCtl_REG_GET_MSSQL_path_Bitmap1_hImage
Var hCtl_REG_GET_MSSQL_path_HLine1
Var hCtl_REG_GET_MSSQL_path_Lbl_ver_app
Var hCtl_REG_GET_MSSQL_path_Label2
Var hCtl_REG_GET_MSSQL_path_Label1
Var hCtl_REG_GET_MSSQL_path_ListBox1
Var hCtl_REG_GET_MSSQL_path_Btn_Open_Dir
Var hCtl_REG_GET_MSSQL_path_ListBox_Iteam
Var hCtl_REG_GET_MSSQL_path_Button_Search
Var GetRegVer_MSSQLSERVER
Var GetRegVer_SQLEXPRESS
Var Curr_RegVer_MSSQLSERVER
Var Curr_RegVer_MSSQLSERVER_Type
Var Curr_RegVer_SQLEXPRESS
Var Curr_RegVer_SQLEXPRESS_Type

; dialog create function
Function fnc_REG_GET_MSSQL_path_Create

  ; === REG_GET_MSSQL_path (type: Dialog) ===
  nsDialogs::Create 1018
  Pop $hCtl_REG_GET_MSSQL_path
  ${If} $hCtl_REG_GET_MSSQL_path == error
    Abort
  ${EndIf}
  !insertmacro MUI_HEADER_TEXT "Dialog title..." "Dialog subtitle..."

  ; === Bitmap1 (type: Bitmap) ===
  ${NSD_CreateBitmap} 8u 1u 287u 22u ""
  Pop $hCtl_REG_GET_MSSQL_path_Bitmap1
  File "/oname=$PLUGINSDIR\lofgo.bmp" "image.bmp"
  ${NSD_SetImage} $hCtl_REG_GET_MSSQL_path_Bitmap1 "$PLUGINSDIR\lofgo.bmp" $hCtl_REG_GET_MSSQL_path_Bitmap1_hImage

  ; === HLine1 (type: HLine) ===
  ${NSD_CreateHLine} 8u 48u 278u 1u ""
  Pop $hCtl_REG_GET_MSSQL_path_HLine1

  ; === Lbl_ver_app (type: Label) ===
  ${NSD_CreateLabel} 111u 117u 59u 14u "0.00.3"
  Pop $hCtl_REG_GET_MSSQL_path_Lbl_ver_app
  ${NSD_OnClick} $hCtl_REG_GET_MSSQL_path_Lbl_ver_app funcAbout

  ; === Label2 (type: Label) ===
  ${NSD_CreateLabel} 21u 51u 236u 8u "Found directories"
  Pop $hCtl_REG_GET_MSSQL_path_Label2

  ; === Label1 (type: Label) ===
  ${NSD_CreateLabel} 21u 28u 104u 18u "MSSQLSERVER version"
  Pop $hCtl_REG_GET_MSSQL_path_Label1

  ; === ListBox1 (type: ListBox) ===
  ${NSD_CreateListBox} 135u 26u 122u 23u ""
  StrCpy $GetRegVer_MSSQLSERVER $Curr_RegVer_MSSQLSERVER
  StrCpy $GetRegVer_SQLEXPRESS $Curr_RegVer_SQLEXPRESS
  Pop $hCtl_REG_GET_MSSQL_path_ListBox1
  ${NSD_AddStyle} $hCtl_REG_GET_MSSQL_path_ListBox1 ${WS_TABSTOP}|${WS_VISIBLE}
  ${NSD_AddExStyle} $hCtl_REG_GET_MSSQL_path_ListBox1 ${WS_EX_TRANSPARENT}
  ${NSD_LB_AddString} $hCtl_REG_GET_MSSQL_path_ListBox1 "$GetRegVer_MSSQLSERVER"
  ${NSD_LB_AddString} $hCtl_REG_GET_MSSQL_path_ListBox1 "$GetRegVer_SQLEXPRESS"
  ${NSD_SetState} $hCtl_REG_GET_MSSQL_path_ListBox1 0

  ; === Btn_Open_Dir (type: Button) ===
  ${NSD_CreateButton} 174u 114u 76u 17u "Open Dir"
  Pop $hCtl_REG_GET_MSSQL_path_Btn_Open_Dir
${NSD_OnClick} $hCtl_REG_GET_MSSQL_path_Btn_Open_Dir OpenDir

  ; === ListBox_Iteam (type: ListBox) ===
  ${NSD_CreateListBox} 8u 61u 267u 50u ""
  Pop $hCtl_REG_GET_MSSQL_path_ListBox_Iteam


  ; === Button_Search (type: Button) ===
  ${NSD_CreateButton} 21u 114u 78u 17u "Search"
  Pop $hCtl_REG_GET_MSSQL_path_Button_Search
  ${NSD_OnClick} $hCtl_REG_GET_MSSQL_path_Button_Search SearchReg
Call SearchReg
FunctionEnd


Function funcAbout
MessageBox MB_OK 'Author: zloisupport $\n Date 03-jun-2020'
FunctionEnd

; dialog show function
Function fnc_REG_GET_MSSQL_path_Show
  Call fnc_REG_GET_MSSQL_path_Create
  nsDialogs::Show
FunctionEnd

Function OpenDir
  ${NSD_LB_GetSelection} $hCtl_REG_GET_MSSQL_path_ListBox_Iteam $0
  Exec 'explorer $0\DATA'
FunctionEnd
Function SearchReg
  SetRegView 64
  ${registry::Open} "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" "/K=0 /V=1 /T=REG_SZ /S=0 /B=1 /N='SQLPath'"  $0
  StrCmp $0 0 0 loop
  MessageBox MB_OK "Error" IDOK close
  loop:
  ${registry::Find} "$0" $1 $2 $3 $4
  StrCmp $4 '' close
  StrCmp $4 'REG_KEY' 0 +3
  goto +1
  IfFileExists "$3\DATA" 0 NotFiles
  SendMessage $hCtl_REG_GET_MSSQL_path_ListBox_Iteam  ${LB_ADDSTRING} 1 "STR:$3"

  Goto loop
  NotFiles:
  close:
  ${registry::Close} "$0"
  ${registry::Unload}
FunctionEnd


Function Mssqlser_ver
  SetRegView 64
  ${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" "MSSQLSERVER" $Curr_RegVer_MSSQLSERVER $Curr_RegVer_MSSQLSERVER_Type
  ${if}  $Curr_RegVer_MSSQLSERVER == ""
   ${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" "MS_SQL_SERVER" $Curr_RegVer_MSSQLSERVER $Curr_RegVer_MSSQLSERVER_Type
   StrCpy $Curr_RegVer_MSSQLSERVER $Curr_RegVer_MSSQLSERVER
  ${endif}

  ${registry::Read} "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" "SQLEXPRESS" $Curr_RegVer_SQLEXPRESS $Curr_RegVer_SQLEXPRESS_Type
FunctionEnd


Section main
SectionEnd

Function .onInit
	InitPluginsDir
  Call Mssqlser_ver
     File /oname=$PLUGINSDIR\Glossy.vsf "Glossy.vsf"
   ;Load the skin using the LoadVCLStyleA function
   NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\Glossy.vsf
FunctionEnd
