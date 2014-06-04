Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaFDMbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:31:22 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:35972 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbaFDMbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:31:20 -0400
Message-ID: <538F0BEE.7070703@tu-dresden.de>
Date: Wed, 04 Jun 2014 14:07:10 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add missing calls to Py_DECREF
References: <53031D2C.2050009@tu-dresden.de>	<20140307141857.GA3153@ghostprotocols.net>	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqd5f7j5.fsf@sejong.aot.lge.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020001060905000103020803"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020001060905000103020803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Add missing calls to Py_DECREF.

The function PyObject_CallObject() returns a new PyObject reference=20
on which Py_DECREF has to be called to avoid memory leaks.
This patch adds these calls where necessary.

It also marks handler_call_die() as NORETURN to make this clear and to=20
avoid unnecessary else statements. Note that the abort() is necessary=20
since Py_FatalError() does not return but seems to be missing the=20
__noretun__ attribute in Python versions <=3D2.7

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

---
 tools/perf/util/scripting-engines/trace-event-python.c | 12 ++++++++++--=

 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index cd9774d..8454dc9 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -50,10 +50,14 @@ static int zero_flag_atom;
=20
 static PyObject *main_module, *main_dict;
=20
+static void handler_call_die(const char *handler_name) NORETURN;
 static void handler_call_die(const char *handler_name)
 {
 	PyErr_Print();
 	Py_FatalError("problem in Python trace event handler");
+	// Py_FatalError does not return
+	// but we have to make the compiler happy
+	abort();
 }
=20
 /*
@@ -97,6 +101,7 @@ static void define_value(enum print_arg_type field_typ=
e,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
=20
 	Py_DECREF(t);
@@ -143,6 +148,7 @@ static void define_field(enum print_arg_type field_ty=
pe,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
=20
 	Py_DECREF(t);
@@ -333,6 +339,7 @@ static void python_process_tracepoint(struct perf_sam=
ple *sample,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	} else {
 		handler =3D PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
@@ -340,6 +347,7 @@ static void python_process_tracepoint(struct perf_sam=
ple *sample,
 			retval =3D PyObject_CallObject(handler, t);
 			if (retval =3D=3D NULL)
 				handler_call_die("trace_unhandled");
+			Py_DECREF(retval);
 		}
 		Py_DECREF(dict);
 	}
@@ -399,6 +407,7 @@ static void python_process_general_event(struct perf_=
sample *sample,
 	retval =3D PyObject_CallObject(handler, t);
 	if (retval =3D=3D NULL)
 		handler_call_die(handler_name);
+	Py_DECREF(retval);
 exit:
 	Py_DECREF(dict);
 	Py_DECREF(t);
@@ -520,8 +529,7 @@ static int python_stop_script(void)
 	retval =3D PyObject_CallObject(handler, NULL);
 	if (retval =3D=3D NULL)
 		handler_call_die("trace_end");
-	else
-		Py_DECREF(retval);
+	Py_DECREF(retval);
 out:
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
--=20
1.8.1.2



--------------ms020001060905000103020803
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPPTCC
BHQwggNcoAMCAQICCQCJkBEVWD6HmzANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0
IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwMjEx
MTMxMTQ1WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZl
cmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFs
IC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1
PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXst
kEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QP
wQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz
2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXF
bOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgEG
MB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT1xfg
iXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweQYIKwYBBQUHAQEE
bTBrMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA7Bggr
BgEFBQcwAoYvaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0FfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBACwvqeBeQy8FcNxRlXVdgI47DMFjWFSBMIOcXalRh8m2
1w8runhIJGBCzPGi4jPhMh4ym1ETlXnGtazQJO0YFLwvKuovq7ITrEkdXgALBBhqmmXU6Ec1
vK7t33S22PGAUGWgxtojm41TR8psu0DJlV1OYHor5LtmQFWvtjPB6iMhbvxUnd0zQm5Ma9Xk
w/LqBrdaMmoyRXS2tW/+6v8cY6q7iNH4WK8gfo+///b3OHeLGrZQP609R3lGw1e0F2KHvZ6j
NiUHaCSqIvL2rynsN6UUma66AWCGdS1hFbp4loe1ks/hUJGeWToV7J5axob8KD5mutTZNa+t
PEkihYfub48wggUTMIID+6ADAgECAgQKlyQtMA0GCSqGSIb3DQEBBQUAMFoxCzAJBgNVBAYT
AkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtE
Rk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMDcwNjE5MDk0OTE4WhcNMTkwNjE4MDAw
MDAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0
IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEg
MB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCgJeIP
QmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8Odgv
D4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA5Q5E
4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoOenVI
tm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3snAgMB
AAGjggGzMIIBrzASBgNVHRMBAf8ECDAGAQH/AgEBMAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU
xStTkxeDyfVGQu1Dat+2gKZH8uAwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQw
HAYDVR0RBBUwE4ERcGtpQHR1LWRyZXNkZW4uZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRw
Oi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2g
O6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2Fj
cmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNh
LmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUH
MAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9j
YWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQDYoP/Eb/pk88i3a3VtkbGM676qLxkSwEcU
xbe6ZCldsKWY3xxXsqRiSt9MP9ATwVXRL4WjKap/Wr3MlfAyjnBcC+Go8NS4xyNxrsXugKrm
Y8mqsDT5h3W25BOfrfvuPy5ubi6QZTGEJPLYSKVCaiBS0LRv8A5m3Jw1zoyKr7007wm6jT3K
UYex/jbRuEILnu/pa5dE4Bq/ZdO2/McRQuGtIS/nuRHG2FMrl8TX3D86k+3NEb40O0UB2/Z0
+tWUOHCH5vuPUNMKaTcJ+S1XXM2xzzpU91yqU7QIFIDUv5dc8F6XTcOATMStJ3w8NynBn4o8
FitEtgHFzBvMqTFI+7KUMIIFqjCCBJKgAwIBAgIHFr0+Fq4AGTANBgkqhkiG9w0BAQUFADCB
hTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNk
ZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqG
SIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcNMTMxMjAzMTEyOTEwWhcNMTYxMjAyMTEy
OTEwWjBgMQswCQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQg
RHJlc2RlbjEMMAoGA1UECxMDWklIMRkwFwYDVQQDExBKb3NlcGggU2NodWNoYXJ0MIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtp784m+f4qwkmx2yLZT4xVDtjvN3WXBRI53C
mFu6lm/3cMyj32EHPE/PLs/J2yYqSI2dUPUNQpg+PX1rbofQcxXCEYCAErs/p7ynofEeJoQf
5BF0BbtXBqD+1PaHXOALbk51lWFbyDDaLsCEh15ruOC60HRTdRz8ztDf+jQDeidqZBijFjU7
cUIShnxOCxnCOna11aiamDqCZDatlwE/9bj5C8JNYQLmMNo2AHaQLF4e3e9DtcGdCPRDjwwr
L+Dl/EmyEyQTy4CljQjSjlKS4jtW+uFNOffU2t7RfBeNJx8xgQe+JxZK2tzlPWh72JM96AiP
HpHAY2X2cUhpheqPdQIDAQABo4ICQTCCAj0wLwYDVR0gBCgwJjARBg8rBgEEAYGtIYIsAQEE
AwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgXgMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU2IlmQWpeOkXl+dw+0arfnVk2FEkw
HwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH8uAwKQYDVR0RBCIwIIEeam9zZXBoLnNj
aHVjaGFydEB0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAwPqA8oDqGOGh0dHA6Ly9jZHAx
LnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2dfY2FjcmwuY3JsMD6gPKA6hjho
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NybC9nX2NhY3JsLmNy
bDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4u
ZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0cDovL2NkcDEucGNhLmRmbi5k
ZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MEgGCCsGAQUFBzAChjxo
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NhY2VydC9nX2NhY2Vy
dC5jcnQwDQYJKoZIhvcNAQEFBQADggEBACoeSNfgyIAGxawrnghOIhIaD3xIsPvZP7ZFMV1a
Q9ltzHiZgUxnnaEUJEV0f+ASblYavp+0T/up0Nre+fKqm9/VMNyYG8068m6jNC+72NywQD9B
KWCTWgDZ3RqChwzrfBq7URSqNJhLSKj/Q7e+k7mCFIqwpnhMeFCZhAkORPUNiuMbyFYO9aht
buIujiF4c3FYDQJZFf83HWZ4neG4ioc8qhsOuXaBlN0AtExPw1KfpHqw1kwMaxZ10Yin8M4k
8gOPNIbm6vl1F8yFCHQka2ZnaDBueswhj+ntj1WUjqHED1hovfievMMW7Fd3njo+T9RODMi3
kNC7VObz0hu0cs0xggPUMIID0AIBATCBkTCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1Rl
Y2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMT
VFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUC
Bxa9PhauABkwCQYFKw4DAhoFAKCCAhcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMTQwNjA0MTIwNzEwWjAjBgkqhkiG9w0BCQQxFgQU22uGJliS4z1iYyOw
fYSSaXOW64gwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQswCQYDVQQGEwJERTEoMCYGA1UE
ChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYD
VQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rl
bi5kZQIHFr0+Fq4AGTCBpAYLKoZIhvcNAQkQAgsxgZSggZEwgYUxCzAJBgNVBAYTAkRFMSgw
JgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgx
HDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1k
cmVzZGVuLmRlAgcWvT4WrgAZMA0GCSqGSIb3DQEBAQUABIIBADbga24V8Lk7pvT6T05Pyu5y
CszdxJ/pnHhd3iQINiJeTgqkbb/NJrIE61GA4+sYx4c+ubGod+/JWKL6BjBLL4AqDQnNGeFj
C8aUTgdHTydG54Ebo7Y5f6YzORbRb6iPSIYvpgISP3UTAzZ6FCvrZcKm02VD9A+g27fWjQTz
Gauy5oAK+/E8+GGY8iKy2bfDDPIoRj9tZpTLkcaK5DW70AwxK1YBS7dahF+icguQB6IaOz8H
n4VvpoO7lTAT63Cgpb4ZsU7I+91rJBklrLDHSQDJgZ1qjVDueTuvw9Nma/TX0TAF4KkcMJty
8ej0VD4UCiBnbitQEHHB769PIETYYeQAAAAAAAA=
--------------ms020001060905000103020803--
