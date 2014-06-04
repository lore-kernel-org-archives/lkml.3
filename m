Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaFDMbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:31:12 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:35959 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbaFDMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:31:10 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 08:31:09 EDT
Message-ID: <538F0BF6.9070904@tu-dresden.de>
Date: Wed, 04 Jun 2014 14:07:18 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Provide additional sample information on generic events
References: <53031D2C.2050009@tu-dresden.de>	<20140307141857.GA3153@ghostprotocols.net>	<533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqd5f7j5.fsf@sejong.aot.lge.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090805000306010900010207"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090805000306010900010207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Provide additional sample information on generic events
to Python scripts, including pid, tid, and cpu for which the event was
recorded. At the moment, the pointer to the sample struct is passed to
scripts, which seems to be of little use. The patch puts this information=
 in
a dictionary for easy access by Python scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
---
 .../util/scripting-engines/trace-event-python.c     | 21 +++++++++++++++=
+++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index 4f81dc7..c8d148b 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -445,7 +445,7 @@ static void python_process_general_event(struct perf_=
sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict, *callchain;
+	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
 	static char handler_name[64];
 	unsigned n =3D 0;
=20
@@ -461,6 +461,10 @@ static void python_process_general_event(struct perf=
_sample *sample,
 	if (!dict)
 		Py_FatalError("couldn't create Python dictionary");
=20
+	dict_sample =3D PyDict_New();
+	if (!dict_sample)
+		Py_FatalError("couldn't create Python dictionary");
+
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
=20
 	handler =3D PyDict_GetItemString(main_dict, handler_name);
@@ -470,8 +474,19 @@ static void python_process_general_event(struct perf=
_sample *sample,
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf=
_evsel__name(evsel)));
 	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(=

 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSiz=
e(
-			(const char *)sample, sizeof(*sample)));
+
+	pydict_set_item_string_decref(dict_sample, "pid",
+			PyInt_FromLong(sample->pid));
+	pydict_set_item_string_decref(dict_sample, "tid",
+			PyInt_FromLong(sample->tid));
+	pydict_set_item_string_decref(dict_sample, "cpu",
+			PyInt_FromLong(sample->cpu));
+	pydict_set_item_string_decref(dict_sample, "time",
+			PyLong_FromUnsignedLongLong(sample->time));
+	pydict_set_item_string_decref(dict_sample, "period",
+			PyLong_FromUnsignedLongLong(sample->period));
+	pydict_set_item_string_decref(dict, "sample", dict_sample);
+
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSi=
ze(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
--=20
1.8.1.2



--------------ms090805000306010900010207
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
hkiG9w0BCQUxDxcNMTQwNjA0MTIwNzE4WjAjBgkqhkiG9w0BCQQxFgQUcVBCzACgBODu9358
h4aT9qRlJIowbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQswCQYDVQQGEwJERTEoMCYGA1UE
ChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYD
VQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rl
bi5kZQIHFr0+Fq4AGTCBpAYLKoZIhvcNAQkQAgsxgZSggZEwgYUxCzAJBgNVBAYTAkRFMSgw
JgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgx
HDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1k
cmVzZGVuLmRlAgcWvT4WrgAZMA0GCSqGSIb3DQEBAQUABIIBADnp39OaS9gfmrJf4raegZrj
iG7TR4byz3Ej8fnoC6IEJMf4Tdfyt6YaZUbiVsE4Ev2IHT6V21jKKn5ZA3s+pQUE3rQAbXKF
EKE8hTLDw4MofoLfMpdwGnI47U06L20w/SNjW/Yul6swvjpoG+qNW/kBclDB3bHyzuPgrziR
ezqYp/VDlQhudS9B60VzHn4SdfX/XsTcZ+/3kHbFRM4QdjggLKUTDVt1HBnPwqF7/ZHDVeWt
BFAc4nq7XM2Rxh3we1n5bRtLLZhJyTPG3Emo2pBIZp3CFWl9ZTjoDKn6jw6e/IrhBxzNKQNU
N/NoHFktrPS/TT/JsAIJnktaobsiSS8AAAAAAAA=
--------------ms090805000306010900010207--
