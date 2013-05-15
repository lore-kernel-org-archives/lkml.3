Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab3EOQLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:11:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:63368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232Ab3EOQL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:11:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,678,1363158000"; 
   d="p7s'?scan'208";a="338069040"
From: "Wei, Gang" <gang.wei@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Topic: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Index: AQHOUXrRjECxqBr3YUqJGBNoMBDWsJkGZPqg
Date: Wed, 15 May 2013 16:10:37 +0000
Message-ID: <D0B11485C64D4B47B66902F8A4E901BEAD5592@SHSMSX101.ccr.corp.intel.com>
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
 <519257FC.8070708@zytor.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE9B851C@SHSMSX102.ccr.corp.intel.com>
 <7877c9de-aa56-4f66-9e51-97987e34cc39@email.android.com>
In-Reply-To: <7877c9de-aa56-4f66-9e51-97987e34cc39@email.android.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_01A1_01CE51C9.CA751470"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_01A1_01CE51C9.CA751470
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit

Oh, the question should be in what states all the AP CPU registers are. Do you 
think we need to define the case like what Intel SDM defined for 
getsec[SENTER]?

Jimmy

H. Peter Anvin wrote on 2013-05-15:
> No, this does not really answer the question of what the CPU state looks 
> like.
>
> "Ren, Qiaowei" <qiaowei.ren@intel.com> wrote:
>
>> On 2013-05-14, H. Peter Anvin wrote:
>>> On 05/14/2013 02:21 PM, Qiaowei Ren wrote:
>>>> tboot provides a better AP wakeup mechanism based on cpu MWAIT
>>>> feature for OS/VMM. With this mechanism, system will boot faster and
>>>> will NOT require VT to be enabled. But it requires that OS/VMM must
>>>> have support it, otherwise system can never boot up.
>>>>
>>>> Once this mechanism is enabled, tboot will put APs waiting in MWAIT
>>>> loops before launching kernel. kernel can check the new flag field
>>>> in
>>>> v6 tboot shared page for the hint. If the bit
>>>> TB_FLAG_AP_WAKE_SUPPORT in flag field is set, kernel BSP has to
>>>> write the monitored memory
>>>> (tboot->ap_wake_trigger) to bring APs out of MWAIT loops. The sipi
>>>> vector should be written in
>>>> tboot->ap_wake_addr before waking up APs.
>>>>
>>>
>>> This really needs a *detailed* specification about the state the CPU
>>> is parked in. Most BIOSes do in fact park the CPUs in an mwait loop,
>>> but we can't use it because the CPU state they are parked in is
>>> ill-defined.
>>>
>>> This is a good idea, but please write (or point to) a spec about what
>>> the parked CPU state looks like and how the OS gets control.  From the
>>> *looks* of the code I assume it is entered in 16-bit real mode but
>>> then it is important to know what parts of the register state are
>> well-defined.
>>
>> The following is how to do mwait for tboot & kernel:
>>
>> For bootstrap processor (BSP), "tboot TXT pre-launch" is executed after
>> BIOS. In this stage, tboot will issue GETSEC[SENTER], which broadcasts
>> messages to the chipset and other physical or logical processors in the
>> platform. In response, other logical processors perform basic cleanup
>> and other tasks, and then finally enter SENTER sleep state.
>>
>> Next, for BSP, SINIT will run and then enter "tboot post-launch", which
>> will start all sleeping APs. If tboot command line option "
>> ap_wake_mwait=true" is set, APs will do some work and then enter mwait
>> loop. Kernel will be launched in BSP by tboot post-launch, and bring
>> APs out of mwait loop.
>>
>> Tboot works in protected mode (but paging is disabled), and closes
>> interrupt. For APs, MONITOR and MWAIT related code in tboot is as
>> follows:
>>    while ( _tboot_shared.ap_wake_trigger != cpuid ) {
>>        cpu_monitor(&_tboot_shared.ap_wake_trigger, 0, 0);
>>        mb();
>>        if ( _tboot_shared.ap_wake_trigger == cpuid )
>>            break;
>>        cpu_mwait(0, 0);
>>    }
>> Their extension and hint are all 0. According Intel manual:
>> 	Extension=0: Treat interrupts as break events even if masked (e.g.,
>> even if EFLAGS.IF=0).
>> 	Hint=0: the preferred optimized state the processor should enter is
>> C0.
>> So, when "tboot->ap_wake_trigger" is set by kernel, APs can exit from
>> mwait loop.
>>
>> Peter, I don't know whether I explain your problem. What do you think
>> about it?
>>
>> Thanks,
>> Qiaowei
>



Jimmy

------=_NextPart_000_01A1_01CE51C9.CA751470
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIdxjCCAyAw
ggKJoAMCAQICBDXe9M8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0Vx
dWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw05
ODA4MjIxNjQxNTFaFw0xODA4MjIxNjQxNTFaME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFcXVp
ZmF4MS0wKwYDVQQLEyRFcXVpZmF4IFNlY3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMFdsVhnCGLuoJotHwhtkRRomAoe/toEbxOEYiHD0XzOnwXg
uAHwTjTs4oqVBGSs8WtTXwWzy2eAv0ICjv7dAQns4QAUT/z78AzdQ7pbK+EfgHCZFVeTFvEPl2q3
wmgjHMxNWTCsUR47ryvW7mNFe8XZX1DS41APOojnvxT94Me5AgMBAAGjggEJMIIBBTBwBgNVHR8E
aTBnMGWgY6BhpF8wXTELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsTJEVx
dWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTENMAsGA1UEAxMEQ1JMMTAaBgNVHRAE
EzARgQ8yMDE4MDgyMjE2NDE1MVowCwYDVR0PBAQDAgEGMB8GA1UdIwQYMBaAFEjmaPkr0rKV10fY
IyAQTzOYkJ/UMB0GA1UdDgQWBBRI5mj5K9KylddH2CMgEE8zmJCf1DAMBgNVHRMEBTADAQH/MBoG
CSqGSIb2fQdBAAQNMAsbBVYzLjBjAwIGwDANBgkqhkiG9w0BAQUFAAOBgQBYzinq/Pfetc4CuRe1
hdG54+CVzCUxDQCmkm5/tpJjnlCV0Zpv5BHeY4VumO6o/1rI01WyZnFX3sAh6z0qpyNJAQSGQnv8
7n+iFlK1Z2fTQNs7JliyKHc9rhR3Ydb6KmYnoA36p3Nc6nDxlCFlRF/6/O8paKmih3nvee9PrAd3
ODCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoT
EUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATD
IsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUj
ZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZv
uSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4
lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+
iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0
Vgaj7TdUDDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3Nl
Y3VyZWNhLmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69
tOkIP4SgDJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3j
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFijCCBHKgAwIBAgIKYR6AtwAA
AAAABzANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUx
OTI1MTNaFw0xNTA1MTUxOTM1MTNaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMGPgGLnOO5IOzlHRfr1XfCVb97V4BR2QVpPZ7Cr
cIQ+FGa2KHD/6dPjwxOIrtFTdfW4BYikdFmxUZVBWRWZ5Vye2cCdGzFWqIEOE1e17nNx1jM8Z6GZ
EqbDUS+vBuPlBFHKQoVm5BaNIHpyn2XZxqwjV9j5/crIfPrCGstk+2ztUhVS8OHEgzO784PgD9pO
gBnnAbZHmEM1FYYmQ6ibS+gVCHzobDYG+YReRiHpFKWBxpUuP+X0WYFw/Ja1JW7N8pELAFDw0UFB
WFgiv1QIusdLvSy8mcsLJ5wy050OVcxShqoUxhw/wvyuuoQxvmEPjhRa1C2oSCmGN0003GMhQWMC
AwEAAaOCAlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFKoWZq+3PVZTYK4Nwu3z7gfL
UWB+MAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBTCKwhT
x+hdMsKCgOmWwLgjQsAV+TAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQa
xgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3kl
MjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0lu
dGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYw
gdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcw
AoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUA
A4IBAQCUY/1d0MS6VPTlIcOho1XWh193PD5kJDJSPdphLHQdM1oKA+whMdIBoY1VzTDDK+C+Ey4J
cyna7fpC8uVmn/Rz/i9MZtyc7qezPtZTn9UyORvJmddH+Ox/RycGwe3ags8jUdspECorYOkJyZks
nDIlTVUvbR7wyY+gGJYqxWXqrcVFEiMsWu8/OIlf7F2gAYMBw1kZ55dn4lWBIM0WqvReWpPvhYeN
7Y+3MKEdSMkQ7TZiNbfdZ5D/8KfWNMTJ4VHltOgCL1lA5tx/F4R1920skpL5eu3Sj650RUe3rOXs
aV5NyJzBwB31+1zsmleVdFD0k/Fw9HxXbAQE35ucN/7CMIIFijCCBHKgAwIBAgIKYSCKYgAAAAAA
CDANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRp
b24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUxOTI3
MjZaFw0xNTA1MTUxOTM3MjZaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3Jh
dGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKQEM1Wn9TU9vc9C+/Tc7KB+eiYElmrcEWE32WUdHvWG
+IcQHVQsikTmMyKKojNLw2B5s6Iekc8ivDo/wCfjZzX9JyftMnc+AArc0la87Olybzm8K9jXEfTB
vTnUSFSiI9ZYefITdiUgqlAFuljFZEHYKYtLuhrRacpmQfP4mV63NKdc2bT804HRf6YptZFa4k6Y
N94zlrGNrBuQQ74WFzz/jLBusbUpEkro6Mu/ZYFOFWQrV9lBhF9Ruk8yN+3N6n9fUo/qBigiF2kE
n9xVh1ykl7SCGL2jBUkXx4qgV27a6Si8lRRdgrHGtN/HWnSWlLXTH5l575H4Lq++77OFv38CAwEA
AaOCAlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFA7GKvdZsggQkCVvw939imYxMCvF
MAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQ5oFY2ekKQ
/5Ktim+VdMeSWb4QWTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQaxgxK
xEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3LmludGVs
LmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBD
QS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVs
JTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYwgdMw
YwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVz
L0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcwAoZg
aHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50
ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4IB
AQCxtQEHchVQhXyjEqtMVUMe6gkmPsIczHxSeqNbo9dsD+6xbT65JT+oYgpIAtfEsYXeUJu1cChq
pb22U5bMAz7eaQcW5bzefufWvA6lg2048B8oczBj/q+5P5NpYrUO8jOmN4jTjfJq3ElZ7yFWpy7r
B3Vm/aN6ATYqWfMbS/xfh+JCxmH3droUmMJI0/aZJHsLtjbjFnNsHDNrJZX1vxlM78Lb1hjskTEN
PmhbVbfTj5i/ZGnhv4tmI8QZPCNtcegXJrfhRl2D9bWpdTOPrWiLDUqzy1Z6KL7TcOS/PCl8RHCJ
XkPau/thTQCpIoDa2+c+3XA++gRTfAQ4svTO260NMIIF+zCCBOOgAwIBAgIKHtX06gABAACWPTAN
BgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24x
KzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0IwHhcNMTIwNjA4MDgw
NTExWhcNMTUwNTE1MTkzNzI2WjA3MRIwEAYDVQQDEwlXZWksIEdhbmcxITAfBgkqhkiG9w0BCQEW
Emdhbmcud2VpQGludGVsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALNyfS4y
C6aDo3DZ/oId96Dvi8CB5SJyDUcMhpKWZtzqPX2mMOqQNgv4qAtHUjt4ibyPSjGZ+0EM3r63384g
GcVR8+uxiuijBIOCkis6oGQ+TmBl1i28KobkE4jNnLCES0keisfNdzO8vAOxIFbT9KxQl1f1Mfvs
ZfyGfFYB53gHCh1VxdZ7a2XKaON+l2YYx2p5xGGZtDDb61ajXSGvdHK+qMIfo7LMoZmY42t5Nawg
izwcqBPUOLR+JXOtyGGiXZx3wZPeRmZx/eCMPBhSlfewpvUrK8W0kL591Lv0HeUVEJye2bOmlLo1
DeIp6KH9JujFB33KhHXvNsugc9IYUVMCAwEAAaOCAugwggLkMAsGA1UdDwQEAwIHgDA8BgkrBgEE
AYI3FQcELzAtBiUrBgEEAYI3FQiGw4x1hJnlUYP9gSiFjp9TgpHACWeB3r05lfBDAgFkAgEIMB0G
A1UdDgQWBBQYdG5bBKSgjlBUQ6dpUm2vjlkEKDAfBgNVHSMEGDAWgBQOxir3WbIIEJAlb8Pd/Ypm
MTArxTCBzwYDVR0fBIHHMIHEMIHBoIG+oIG7hldodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0
b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQigxKS5j
cmyGYGh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIw
RXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNybDCB9QYIKwYBBQUHAQEE
gegwgeUwbAYIKwYBBQUHMAKGYGh0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlm
aWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNy
dDB1BggrBgEFBQcwAoZpaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9j
ZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0Io
MSkuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMMMCkGCSsGAQQBgjcVCgQcMBow
CgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBBBgNVHREEOjA4oCIGCisGAQQBgjcUAgOgFAwSZ2Fu
Zy53ZWlAaW50ZWwuY29tgRJnYW5nLndlaUBpbnRlbC5jb20wDQYJKoZIhvcNAQEFBQADggEBAHuy
cX8AxjwfC5zmWDh0QpY8vDSgyLXaUDYKm2+ATDJDn5kALJgxAqaThvqGTH+oz73HQ7L8v7QxM0Yp
1IQd/k5GeqMzhuXEoPM4rcORlOlvRqxBJNZUuYwxvyYaUpLU1W8EsOB2zB31ykzdXH93b6ZpfJk7
8eqZuq00xHxU9mw4PXlWPnn1NDBYD1JH/ufCmpFk6sBE2bBf2u2miBEwHoRUyoH1nbu78aOs4mE6
fRC9NutIriNPI2790R3FAY8dLWl3nrpXs80TrUCptat61uNRJDH06KXe81QCtvDVlBGbZ4gqWR3P
ZGsnJKeOLOO38PQvFFm1Xjs4DVYiPVYyCTIwggZCMIIFKqADAgECAgoUmebGAAEAAFPVMA0GCSqG
SIb3DQEBBQUAMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkG
A1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTAeFw0xMDEyMDEwOTMxMzla
Fw0xMzExMTUwOTMxMzlaMDcxEjAQBgNVBAMTCVdlaSwgR2FuZzEhMB8GCSqGSIb3DQEJARYSZ2Fu
Zy53ZWlAaW50ZWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlkDjEHBe0Gg1
dZhmebTYRY4qWGcBCKuEGfp8DuoVXyv3gW6bXc8TcWRSXj0vxL/+/RKObwVc17Cu2XcO0MTU1EOo
ohTEl/QDnBvj0qeqKnkZGmAM0cCU7+m07N0ATPEzg0t2gJUA8dVO37iAo1KMQ72ovMJ1LU+x7tno
d6PhrgXLmbjkEjQZnHwLvuI2TdiKKDvJtd6xz6DQuIBSPyn4wYsckGQcb5NlEiQCkCaPM/ZtcKcm
Kxu0g1TfW7zIWuRhkPIOyin/bsN8RBTTq8lL74yFgTB4ybAMp13wtROVAN5FLYE31CAgJ69EBNix
xTBNsLtv+KM6sXsbDccp3H5JwQIDAQABo4IDLzCCAyswCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcV
BwQwMC4GJisGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgEMMEQGCSqG
SIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggq
hkiG9w0DBzAdBgNVHQ4EFgQUwmKbKrf26Ot7Acv/+2aZDzj7gaQwHwYDVR0jBBgwFoAUqhZmr7c9
VlNgrg3C7fPuB8tRYH4wgc8GA1UdHwSBxzCBxDCBwaCBvqCBu4ZXaHR0cDovL3d3dy5pbnRlbC5j
b20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwM0EoMSkuY3JshmBodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NS
TC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcmwwgfUG
CCsGAQUFBwEBBIHoMIHlMGwGCCsGAQUFBzAChmBodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0
b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0El
MjAzQSgxKS5jcnQwdQYIKwYBBQUHMAKGaWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3Vpbmcl
MjBDQSUyMDNBKDEpLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEE
AYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwQwQQYDVR0RBDowOKAiBgorBgEEAYI3
FAIDoBQMEmdhbmcud2VpQGludGVsLmNvbYESZ2FuZy53ZWlAaW50ZWwuY29tMA0GCSqGSIb3DQEB
BQUAA4IBAQAPFjqbkKIbnvnYwFG/QpKUm2yGzieys9IJny7PU2fVV4ksTL7emcpCfhFtlg7cPEgU
7Rx6gG4hO+ZBx9oojImSGWj44Pj3EzSyRRaN+UK1VVESHgE2HKmETsAnRN/wulP9ahPJNmEOklBg
oX6BJg9NYTqp8gDS6m1QBQoh/C2/51MGcmTecM4g5BuEpgmvxovlPDHlnSq390NXwXtdh1lM5qbo
V9FBWFCR1Q7mf7n2Y6b/9m9bn9gMzbdwjMrnpYIiC5rN5WBDQtuzAios8OheGSTX0A1npuGZ3cvP
NlPbRAoD7TVAdGhr+ZztVLA0+IFYmQqHV2C8q3TybgPnp1/uMYIDhjCCA4ICAQEwZDBWMQswCQYD
VQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVy
bmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ICCh7V9OoAAQAAlj0wCQYFKw4DAhoFAKCCAfcwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTMwNTE1MTYxMDM2WjAjBgkqhkiG
9w0BCQQxFgQUslxTi8XzcDkh5TIXh8DEaOuhsucwcwYJKwYBBAGCNxAEMWYwZDBWMQswCQYDVQQG
EwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFs
IEJhc2ljIElzc3VpbmcgQ0EgM0ECChSZ5sYAAQAAU9UwdQYLKoZIhvcNAQkQAgsxZqBkMFYxCzAJ
BgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0
ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQQIKFJnmxgABAABT1TCBqwYJKoZIhvcNAQkPMYGdMIGa
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAECMA4GCCqG
SIb3DQMCAgIAgDAHBgUrDgMCBzANBggqhkiG9w0DAgIBQDANBggqhkiG9w0DAgIBKDAHBgUrDgMC
GjALBglghkgBZQMEAgMwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASC
AQAqRI/CSwON25JvwZ90yzeoZMOX36tvq74D0PRg+kaUodljE5UyYQtIsANv/K6y46e7Hgv1pvPY
fqzh7LthV4XE0+VcbVjJT90bGIgrb8z0M62Y48h4HF5Sv0Nwg1v2loDf6OjfMbcow4LFRiPg6LTH
fbQUw0/yhxqDMZ95bolvuLNyH6CGKuN0X0eT4kzv/WCG1heliFpub3vpS0Pix8LHPfd3/MSw4asg
APRV//AnB9SQrrsC4igQmJB3qfBTbjovxrQJqTOUDchlAxBjX/WN6TCQkpJONsDBE1b+8WK0W+Xz
ES/ZAfnQkK1fN9ztRNxZhGFb5dlAA7ZSJ5G/syYLAAAAAAAA

------=_NextPart_000_01A1_01CE51C9.CA751470--
