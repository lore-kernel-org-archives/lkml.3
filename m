Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3GLXgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:36:48 -0400
Received: from mailout.scc.kit.edu ([129.13.185.202]:36468 "EHLO
	mailout.scc.kit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3GLXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:36:46 -0400
Message-ID: <51E092FC.1030200@student.kit.edu>
Date: Sat, 13 Jul 2013 01:36:28 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIFPDvG5rZW5iZXJn?= 
	<christian.suenkenberg@student.kit.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130702 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jonas Heinrich <onny@project-insanity.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
References: <20130218155439.GA902@onny> <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com> <20130223131856.GA682@onny> <51293A8B.5060107@zytor.com> <20130320143257.GA473@onny> <20130501170118.GB488@onny> <518151DD.106@zytor.com> <51DDC972.3010005@student.kit.edu> <51DDF4DF.4000902@zytor.com>
In-Reply-To: <51DDF4DF.4000902@zytor.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms060205060604080808000902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------ms060205060604080808000902
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On 07/11/2013 01:57 AM, H. Peter Anvin wrote:
> On 07/10/2013 01:52 PM, Christian S=C3=BCnkenberg wrote:
>> Hello,
>>
>> On 05/01/2013 07:33 PM, H. Peter Anvin wrote:
>>> On 05/01/2013 10:01 AM, Jonas Heinrich wrote:
>>>> Hello, I tried the newest kernel, 3.9 today but the bug is still
>>>> present. Applying the attached patch solves the bug for me.
>>>>
>>>> Best regards, Jonas Heinrich
>>>
>>> Okay... WTF is going on here?  Does pmode_behavior just not get set u=
p
>>> correctly?  Since it seems you can get it to wake up with your patch,=

>>> perhaps we can get read out the value of pmode_behavior and print it.=
=2E.
>>
>> indeed, arch/x86/kernel/acpi/sleep.c tries an rdmsr_safe(MSR_EFER, ...=
)
>> and sets WAKEUP_BEHAVIOR_RESTORE_EFER bit on success, however,
>> on 90 nm Pentium M (Family 6, Model 13), reading an invalid MSR
>> is not guaranteed to trap, see Erratum X4 in "Intel=C2=AE Pentium=C2=AE=
 M
>> Processor on 90 nm Process with 2-MB L2 Cache and Intel=C2=AE Processo=
r A100
>> and A110 on 90 nm process with 512-KB L2 Cache Specification Update".
>> On Jonas' T43, which has an affected Pentium M without EFER,
>> rdmsr_safe(MSR_EFER, ...) succeeds and WAKEUP_BEHAVIOR_RESTORE_EFER
>> gets set, while on resume the corresponding wrmsr traps and thus resum=
e
>> fails.
>>
>> The pre-3.7 code snippet incidentally catched this by not restoring
>> EFER when it would be restored to all 0s.
>>
>=20
> That does seem like a reasonable explanation.
>=20
> Does this patch fix the problem?  (Comment blatantly ripped off from
> your email message.)

Jonas tried your patch and it fixes suspend/resume on his T43, although
IMHO the safest approach would be to just add an exception for
Vendor=3D=3DIntel && Family=3D=3D6 && Model=3D=3D13, or more generally Ve=
ndor=3D=3DIntel
&& !supports_long_mode, as the same erratum also warns about wrmsr
possibly not triggering a GP either.
Anyways, at least on this specific MSR with the Pentium M Jonas tested,
it behaved correctly on every try, so I'd say your patch does the trick,
thank you very much!

As a side note, I found a similar erratum #33 in "Pentium=C2=AE Processor=

Specification Update" for Intel P54C (Family 5, Model 2), which would,
supposed there are P54C systems with ACPI sleep/resume support, result
in MSR 0 (P5_MC_ADDR) to be saved and restored instead of nonexistent EFE=
R.

Kind regards,
Christian


--------------ms060205060604080808000902
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIO0zCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFRjCCBC6gAwIBAgIEDM34pzAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA4MDgyMjA4Mzg0N1oXDTE5MDYzMDAwMDAwMFowgb8xCzAJBgNVBAYTAkRFMRswGQYDVQQI
ExJCYWRlbi1XdWVydHRlbWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMhS2Fy
bHNydWhlIEluc3RpdHV0ZSBvZiBUZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2ggQ2Vu
dHJlIGZvciBDb21wdXRpbmcxDzANBgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYKY2FA
a2l0LmVkdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMyyqIqJooBBUSkvbR08
HQh6NNE+tqNErubDBemoGj8A803wg+1xvXqkhO1vnBABp5U++7xgD5uLlTcOb/F4UFrJBBy9
QCnThzCb+eqG+94Iw6m8LjWqCKor9lKwNCUit7vzNAOCd0r0iNCYV2/xcK8tHSHw3mGXgvwf
Y0F9j14nUEg9nd5kPq0Aw9iQHDuYnOz3A8NVTpXpTCziQTCZJQYETDsC+nynQN2svAmAV3V1
HJRe/AD6idy/6HN0EtAIOPlE1px14NFS4SZqUk/F4vD8pxSz/YUwbCGK4IH37V9bcbQmA8NN
NKBtFLqX19ovuQn32lRwSW/Cz3Hj+zSRP3MCAwEAAaOCAawwggGoMBIGA1UdEwEB/wQIMAYB
Af8CAQEwCwYDVR0PBAQDAgEGMB0GA1UdDgQWBBQfdGX0mh169jHp32EbcysNbdAzSTAfBgNV
HSMEGDAWgBRJt8bP6D0ff+pEexMp9/EKcD7eZDAVBgNVHREEDjAMgQpjYUBraXQuZWR1MIGI
BgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1j
YS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9i
YWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCBogYIKwYBBQUHAQEEgZUwgZIwRwYIKwYB
BQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2Jh
bC1yb290LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEA3VY+
HB+O1KHl4DmkBIAUadE91YKUM8REbrN04c513wXPZVMZ5YBy/9qy1q/REmwAZP9dYLpnRWav
SoDxTBqzJ4EQcaCzQVY2HwowmoKCuP5u1XXUCwOOBzpxAcR+4OzgWi0tF2XKpqeCjH7B/KMa
tPreUfgtsMuTETS6RjYJU91B0Fz/wdSix5jF+0fLkkifsVhPz75IAWatkux3SxOpiYgPoTtj
+wCIbFpdjyzYCe+2L/Wr3DpdOnsDkff2oKnWTey7KXKH5wUkmFEihspVPIMRZkGGwGL34kL3
cF1TIEvlJhuiG6UFemtA+D8MQOocag8Od9DzUfBZacNWr0VDlzCCBWAwggRIoAMCAQICBBEO
BtswDQYJKoZIhvcNAQEFBQAwgb8xCzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRlbi1XdWVy
dHRlbWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMhS2FybHNydWhlIEluc3Rp
dHV0ZSBvZiBUZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2ggQ2VudHJlIGZvciBDb21w
dXRpbmcxDzANBgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYKY2FAa2l0LmVkdTAeFw0x
MDExMjUxNjA1MzJaFw0xMzExMjQxNjA1MzJaMFkxCzAJBgNVBAYTAkRFMSowKAYDVQQKEyFL
YXJsc3J1aGUgSW5zdGl0dXRlIG9mIFRlY2hub2xvZ3kxHjAcBgNVBAMTFUNocmlzdGlhbiBT
dWVua2VuYmVyZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN1YfA6Atgg7mzBh
9KC9KWejBOhCu2KOueOUw7WviE76LGze0lxaSyvXsO5rW/cUJ5Xxwc4bQkP/8vl1gId3lbXT
GwX8rlyZ7vT5YASRyzZ9VJse/YNwvoNZthp1CGCnrM+9PJtX27uXbRKTn9DKYnHsrFUWbWC7
lUX3NwZQ+/wyVGCjj8zzi7A7qnXHSK673jgV4P1K6hOen5f1slBfUVeM9fYfjxdKlSORfIuH
BqJ3yEtJWlBuC5l/w86kj45s3n5E5NOsYCyILwdMCoYCEIYh9dS6wz4Mlvvpts2+XUi5SMiN
4PfHcd7ibGqoJoy/u3MzctiSDOdw/EWSTuOJwucCAwEAAaOCAccwggHDMAkGA1UdEwQCMAAw
CwYDVR0PBAQDAgXgMCkGA1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQC
AjAdBgNVHQ4EFgQUDKYXE4QfTWOSSLOZeAiNubitbKQwHwYDVR0jBBgwFoAUH3Rl9JodevYx
6d9hG3MrDW3QM0kwMAYDVR0RBCkwJ4ElY2hyaXN0aWFuLnN1ZW5rZW5iZXJnQHN0dWRlbnQu
a2l0LmVkdTB3BgNVHR8EcDBuMDWgM6Axhi9odHRwOi8vY2RwMS5wY2EuZGZuLmRlL2tpdC1j
YS9wdWIvY3JsL2NhY3JsLmNybDA1oDOgMYYvaHR0cDovL2NkcDIucGNhLmRmbi5kZS9raXQt
Y2EvcHViL2NybC9jYWNybC5jcmwwgZIGCCsGAQUFBwEBBIGFMIGCMD8GCCsGAQUFBzAChjNo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2tpdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwPwYI
KwYBBQUHMAKGM2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUva2l0LWNhL3B1Yi9jYWNlcnQvY2Fj
ZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEAcQpxG3nq8fKYV9Jnkgn4MugbF8hoGZSJKugz
TQKFU1f+7vfmCG9mOhBgZgRWRWHohL1Jv28dfpbiVGNIFkZdFsn8596oM9Z9E9oiIRXRD3uH
mCAZ2xtaiU2KKuCjOdhSr79DqA7pypbPzk+/D6w2ixPRnFOud2fqrBWdCRXj/qWvz+9ZUWI4
2cSzs9YMt62xOBYGfAKFyTMkGniUPmzXjpP+mNjZcBLFjy+kdLk1tbM1o7gWeR/NiJJBJa31
425DQgBkLlIiE59JFwfVof16JdhAZMZd+JFU/1L4rgzFCogMtHE/vMHn/Oii5Hgp3NiLvRHG
2fdAOUv15goRpL1jEzGCBHkwggR1AgEBMIHIMIG/MQswCQYDVQQGEwJERTEbMBkGA1UECBMS
QmFkZW4tV3VlcnR0ZW1iZXJnMRIwEAYDVQQHEwlLYXJsc3J1aGUxKjAoBgNVBAoTIUthcmxz
cnVoZSBJbnN0aXR1dGUgb2YgVGVjaG5vbG9neTEnMCUGA1UECxMeU3RlaW5idWNoIENlbnRy
ZSBmb3IgQ29tcHV0aW5nMQ8wDQYDVQQDEwZLSVQtQ0ExGTAXBgkqhkiG9w0BCQEWCmNhQGtp
dC5lZHUCBBEOBtswCQYFKw4DAhoFAKCCAoUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMTMwNzEyMjMzNjI4WjAjBgkqhkiG9w0BCQQxFgQUiWVbkyEgutKp
HTmkT10cGFjyJ5YwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDCB2QYJKwYBBAGCNxAEMYHLMIHIMIG/MQswCQYDVQQGEwJERTEbMBkG
A1UECBMSQmFkZW4tV3VlcnR0ZW1iZXJnMRIwEAYDVQQHEwlLYXJsc3J1aGUxKjAoBgNVBAoT
IUthcmxzcnVoZSBJbnN0aXR1dGUgb2YgVGVjaG5vbG9neTEnMCUGA1UECxMeU3RlaW5idWNo
IENlbnRyZSBmb3IgQ29tcHV0aW5nMQ8wDQYDVQQDEwZLSVQtQ0ExGTAXBgkqhkiG9w0BCQEW
CmNhQGtpdC5lZHUCBBEOBtswgdsGCyqGSIb3DQEJEAILMYHLoIHIMIG/MQswCQYDVQQGEwJE
RTEbMBkGA1UECBMSQmFkZW4tV3VlcnR0ZW1iZXJnMRIwEAYDVQQHEwlLYXJsc3J1aGUxKjAo
BgNVBAoTIUthcmxzcnVoZSBJbnN0aXR1dGUgb2YgVGVjaG5vbG9neTEnMCUGA1UECxMeU3Rl
aW5idWNoIENlbnRyZSBmb3IgQ29tcHV0aW5nMQ8wDQYDVQQDEwZLSVQtQ0ExGTAXBgkqhkiG
9w0BCQEWCmNhQGtpdC5lZHUCBBEOBtswDQYJKoZIhvcNAQEBBQAEggEAAlgddFiyPkjHo0UK
069EEm6uc0OZhkAVKkvTw+TzLUSWN45YrKcwIvARn9HSaBCQ8nJAstncNnT+gmWwASdH95IC
Ma2105A1XAn7ECOf425+HmcRDbWYu3WNHNCa3klX098My4QwtFoX3/oq4BNYrsQ2gX6N+1yO
QtG59kh9wh3+L5IHEbfnB+Edyaf5Ci5cuLHvHpLCeoJ9LX8KadtE7KPswKs8HlSdpN1T2kmv
Asu6QHVquZJDSdpqiERk1sfEFQc2ZhB5avuFcr3K881LXVJ4pKaUnvKLjJBQNDAtwOdKSTG6
DZJfyE+QR2dJgBEG2JT2CUcxJJwCmmcc0/EGsgAAAAAAAA==
--------------ms060205060604080808000902--
