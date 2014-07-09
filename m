Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaGIOQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:16:54 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:50958 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616AbaGIOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:16:52 -0400
Message-ID: <53BD4EC4.1050304@tu-dresden.de>
Date: Wed, 09 Jul 2014 16:16:36 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3]  perf script: Provide additional sample information on
 generic events
References: <53031D2C.2050009@tu-dresden.de> <20140307141857.GA3153@ghostprotocols.net> <533D2283.3090703@tu-dresden.de> <87wqd5f7j5.fsf@sejong.aot.lge.com> <538F0BF2.1010806@tu-dresden.de> <20140707171706.GA20752@krava.redhat.com> <53BCF1F2.70100@tu-dresden.de> <20140709112721.GC1814@krava.redhat.com> <53BD2AD6.6020309@tu-dresden.de> <20140709114903.GA5767@krava.redhat.com>
In-Reply-To: <20140709114903.GA5767@krava.redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010008070007030105060903"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010008070007030105060903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


 perf script: Provide additional sample information on
 generic events  to Python scripts, including pid, tid, and cpu for which=
 the
 event was  recorded. At the moment, the pointer to the sample struct is
 passed to  scripts, which seems to be of little use. The patch puts this=

 information in  dictionaries for easy access by Python scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
---
 .../util/scripting-engines/trace-event-python.c    | 23 ++++++++++++++++=
+++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index dae78e4..64923cd 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -446,7 +446,7 @@ static void python_process_general_event(struct perf_=
sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict, *callchain;
+	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
 	static char handler_name[64];
 	unsigned n =3D 0;
=20
@@ -462,6 +462,10 @@ static void python_process_general_event(struct perf=
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
@@ -471,8 +475,21 @@ static void python_process_general_event(struct perf=
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
+	pydict_set_item_string_decref(dict_sample, "ip",
+			PyLong_FromUnsignedLongLong(sample->ip));
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



--------------ms010008070007030105060903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPizCC
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
PEkihYfub48wggVhMIIESaADAgECAgcXpCR5aFyOMA0GCSqGSIb3DQEBCwUAMFoxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQD
ExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMTQwNTI3MTQ1MzI5WhcNMTkwNzA5
MjM1OTAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0
YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcw
MjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCg
JeIPQmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8
OdgvD4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA
5Q5E4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoO
enVItm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3sn
AgMBAAGjggH+MIIB+jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjARBgNV
HSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFMUrU5MXg8n1RkLtQ2rftoCmR/LgMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEXBraUB0dS1kcmVzZGVuLmRl
MIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcowgccwMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCJ
hMBD4Oh4PXhRwECrWgomDDnELDDFh4FN1e2g0gYbKLg/kA0gw6RKImh4GhTRAbENxW2My+tH
aKFjtwQdBaanilk4DN581jqxjo37jPEwDmNNzT8U4ssiwmkMD2bWM2vTcc7lDj2g7w+sRzIJ
8zi1AtCV43bJT8xBVj0PQpFuqYVvYzgMq+KNtGn4YyiBAMyDY1EzPEgtOovN7sqXb3jGDa71
gqdHWIKf9orfDWCZ/Y8d+Y+rSqtBAHj0fnAzjnIgtJvUIif+Afx/4Rvxy0MHj3q6uHhPFcZ9
QBPm+vxX2nWXEMlJcf1A/Igdah5hUpkmAQIUUJso8QbE4gXBS/BPMIIFqjCCBJKgAwIBAgIH
Fr0+Fq4AGTANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2hu
aXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUg
RHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcN
MTMxMjAzMTEyOTEwWhcNMTYxMjAyMTEyOTEwWjBgMQswCQYDVQQGEwJERTEoMCYGA1UEChMf
VGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRkwFwYDVQQD
ExBKb3NlcGggU2NodWNoYXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtp78
4m+f4qwkmx2yLZT4xVDtjvN3WXBRI53CmFu6lm/3cMyj32EHPE/PLs/J2yYqSI2dUPUNQpg+
PX1rbofQcxXCEYCAErs/p7ynofEeJoQf5BF0BbtXBqD+1PaHXOALbk51lWFbyDDaLsCEh15r
uOC60HRTdRz8ztDf+jQDeidqZBijFjU7cUIShnxOCxnCOna11aiamDqCZDatlwE/9bj5C8JN
YQLmMNo2AHaQLF4e3e9DtcGdCPRDjwwrL+Dl/EmyEyQTy4CljQjSjlKS4jtW+uFNOffU2t7R
fBeNJx8xgQe+JxZK2tzlPWh72JM96AiPHpHAY2X2cUhpheqPdQIDAQABo4ICQTCCAj0wLwYD
VR0gBCgwJjARBg8rBgEEAYGtIYIsAQEEAwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQC
MAAwCwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4E
FgQU2IlmQWpeOkXl+dw+0arfnVk2FEkwHwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH
8uAwKQYDVR0RBCIwIIEeam9zZXBoLnNjaHVjaGFydEB0dS1kcmVzZGVuLmRlMIGLBgNVHR8E
gYMwgYAwPqA8oDqGOGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIv
Y3JsL2dfY2FjcmwuY3JsMD6gPKA6hjhodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNk
ZW4tY2EvcHViL2NybC9nX2NhY3JsLmNybDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUH
MAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcw
AoY8aHR0cDovL2NkcDEucGNhLmRmbi5kZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19j
YWNlcnQuY3J0MEgGCCsGAQUFBzAChjxodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNk
ZW4tY2EvcHViL2NhY2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBACoeSNfg
yIAGxawrnghOIhIaD3xIsPvZP7ZFMV1aQ9ltzHiZgUxnnaEUJEV0f+ASblYavp+0T/up0Nre
+fKqm9/VMNyYG8068m6jNC+72NywQD9BKWCTWgDZ3RqChwzrfBq7URSqNJhLSKj/Q7e+k7mC
FIqwpnhMeFCZhAkORPUNiuMbyFYO9ahtbuIujiF4c3FYDQJZFf83HWZ4neG4ioc8qhsOuXaB
lN0AtExPw1KfpHqw1kwMaxZ10Yin8M4k8gOPNIbm6vl1F8yFCHQka2ZnaDBueswhj+ntj1WU
jqHED1hovfievMMW7Fd3njo+T9RODMi3kNC7VObz0hu0cs0xggPUMIID0AIBATCBkTCBhTEL
MAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4x
DDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3
DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCBxa9PhauABkwCQYFKw4DAhoFAKCCAhcwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNzA5MTQxNjM2WjAjBgkq
hkiG9w0BCQQxFgQURHFW+c9IqUbQXgUKx+w/gdpWmiMwbAYJKoZIhvcNAQkPMV8wXTALBglg
hkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggq
hkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGR
MIGFMQswCQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJl
c2RlbjEMMAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJ
KoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIHFr0+Fq4AGTCBpAYLKoZIhvcNAQkQAgsx
gZSggZEwgYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFl
dCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIx
IDAeBgkqhkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlAgcWvT4WrgAZMA0GCSqGSIb3DQEB
AQUABIIBALSw1hmA897iR1D8nm++JjBy+RwH6etBtErTeEgKqiXZ8ZlHps84CnkIUM8Eyy6z
Kvo92eVJR/QZLS4IdrELqm59QvWV1UM+Xqr6zXyFrJI0UaIj1rbVQrZlr5wDV8uYwjHmeU1y
632azrb8hM2K1h6cfN6triNqGvlyO+KkZRhFF2Rlw20ODT8KJEMWFdbbEk8nlX6/V9/8BSyB
+73ZuirydlUfiM7DPvOlCzadhJVardG+/5iY3+oUVrg5XcLWt2bF4G0w3CVKwk2c8QfH34+a
YckJAFHGIBUz7vEMoqhO1j3nxhr7yTmXLcFEqLRb/1hxCsb2jQ0uJb/WpfjtzUQAAAAAAAA=
--------------ms010008070007030105060903--
