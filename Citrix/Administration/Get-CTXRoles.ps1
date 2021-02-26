﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Gets roles configured for this site
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires the library script CitrixLibrary.ps1
        Requires PSSnapIn Citrix*

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Citrix/Administration
        
    .Parameter SiteServer
        [sr-en] Specifies the address of a XenDesktop controller. 
        This can be provided as a host name or an IP address
        [sr-de] Name oder IP Adresse des XenDesktop Controllers

    .Parameter Name
        [sr-en] Roles with the specified name
        [sr-de] Name der Rolle
        Dieser Parameter unterstützt Wildcards am Anfang und/oder am Ende des Namens

    .Parameter Id
        [sr-en] Id of the role
        [sr-de] Identifier der Rolle

    .Parameter BuiltIn
        [sr-en] BuiltIn roles Y/N
        [sr-de] BuiltIn Rollen J/N

    .Parameter Description
        [sr-en] Roles with the specified description
        [sr-de] Beschreibung der Rolle

    .Parameter Permission
        [sr-en] Roles that contain a specific permission
        [sr-de] Rollen mit dieser Berechtigung

    .Parameter MaxRecordCount	
        [sr-en] Maximum number of records to return	
        [sr-de] Maximale Anzahl der Ergebnisse

    .Parameter Properties
        [sr-en] List of properties to expand. Use * for all properties
        [sr-de] Liste der zu anzuzeigenden Eigenschaften. Verwenden Sie * für alle Eigenschaften
#>

param(
    [string]$Name,
    [string]$Id,
    [string]$SiteServer,
    [bool]$BuiltIn,
    [string]$Description,
    [string]$Permission,
    [int]$MaxRecordCount = 250,
    [ValidateSet('*','Name','Description','BuiltIn','Id','IsHidden','Permissions','ExclusiveAccessPermissions')]
    [string[]]$Properties = @('Name','Description','BuiltIn','IsHidden','Permissions','Id')
)                                                            

try{ 
    StartCitrixSessionAdv -ServerName ([ref]$SiteServer)
    if($Properties -contains '*'){
        $Properties = @('*')
    }

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'AdminAddress' = $SiteServer
                            'MaxRecordCount' = $MaxRecordCount
                            }    
    
    if($PSBoundParameters.ContainsKey('Id') -eq $true){
        $cmdArgs.Add('Id',$Id)
    }
    if($PSBoundParameters.ContainsKey('Name') -eq $true){
        $cmdArgs.Add('Name',$Name)
    }
    if($PSBoundParameters.ContainsKey('BuiltIn') -eq $true){
        $cmdArgs.Add('BuiltIn',$BuiltIn)
    }
    if($PSBoundParameters.ContainsKey('Description') -eq $true){
        $cmdArgs.Add('Description',$Description)
    }
    if($PSBoundParameters.ContainsKey('Permission') -eq $true){
        $cmdArgs.Add('Permission',$Permission)
    }
    
    $ret = Get-AdminRole @cmdArgs | Select-Object $Properties
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw 
}
finally{
    CloseCitrixSession
}