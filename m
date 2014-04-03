Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaDCJq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:46:26 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:36681 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbaDCJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:46:24 -0400
X-Greylist: delayed 2906 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 05:46:23 EDT
Message-ID: <533D2283.3090703@tu-dresden.de>
Date: Thu, 03 Apr 2014 10:57:39 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Provide additional sample information to Python scripts
References: <53031D2C.2050009@tu-dresden.de> <20140307141857.GA3153@ghostprotocols.net>
In-Reply-To: <20140307141857.GA3153@ghostprotocols.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070202060605040507040702"
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070202060605040507040702
Content-Type: multipart/mixed;
 boundary="------------070607010409010904000502"

This is a multi-part message in MIME format.
--------------070607010409010904000502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07.03.2014 15:18, Arnaldo Carvalho de Melo wrote:
> Can you please resend, against the perf/core branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git, and as an=

> attachement or making sure that the patch is not mangled?

Arnaldo,

Please find attached our changes. I am sending you two patches since I
came across possible memory leaks while working on the original patch.
The first patch (perf_python_retval_decref.patch) adds calls to
Py_DECREF for the references returned by PyObject_CallObject().

The second patch (perf_python_add_sample.patch) contains our changes to
hand down the sample information for generic events. In addition, the
call-chain of the samples are constructed into a list and passed on. In
the case of generic events, this is just another entry in the dictionary
that is passed to the script as sole argument. For tracepoint events,
this adds another argument and hence changes the scripting interface.
Please feel free to remove these lines in python_process_tracepoint() if
you think that this is problematic.

I hope it is no problem that I am sending you two patches in one mail.
The patches are based on the git repository you pointed out, last
updated on April 2nd (commit 675b44bdf5f2a245f4479c5a8c40abf591007f36).

Please let me know if you have any questions.

Thanks,
Joseph

--------------070607010409010904000502
Content-Type: text/x-patch;
 name="perf_python_add_sample.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="perf_python_add_sample.patch"

Perf: Provide sample information and call-chain to Python script

Provide additional sample information on generic events to Python
scripts, including pid, tid, and cpu for which the event was recorded.
Additionally, provide the call-chain recorded at each event with
resolved symbols (for both generic and tracepoint events).=20
At the moment, the pointer to the sample struct is passed to scripts,=20
which seems to be of little use. The patch puts this information in=20
dictionaries for easy access by Python scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index a7c8932..255d451 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -32,6 +32,7 @@
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../machine.h"
=20
 PyMODINIT_FUNC initperf_trace_context(void);
=20
@@ -234,12 +235,90 @@ static inline struct event_format *find_cache_event=
(struct perf_evsel *evsel)
 	return event;
 }
=20
+
+static PyObject *python_process_callchain(struct perf_sample *sample,
+					 struct perf_evsel *evsel,
+					 struct addr_location *al)
+{
+	PyObject *pylist;
+
+	pylist =3D PyList_New(0);
+	if (!pylist)
+		Py_FatalError("couldn't create Python list");
+
+	if (!symbol_conf.use_callchain || !sample->callchain)
+		goto exit;
+
+	if (machine__resolve_callchain(al->machine, evsel, al->thread,
+					   sample, NULL, NULL,
+					   PERF_MAX_STACK_DEPTH) !=3D 0) {
+		pr_err("Failed to resolve callchain. Skipping\n");
+		goto exit;
+	}
+	callchain_cursor_commit(&callchain_cursor);
+
+
+	while (1) {
+		PyObject *pyelem;
+		struct callchain_cursor_node *node;
+		node =3D callchain_cursor_current(&callchain_cursor);
+		if (!node)
+			break;
+
+		pyelem =3D PyDict_New();
+		if (!pyelem)
+			Py_FatalError("couldn't create Python dictionary");
+
+
+		pydict_set_item_string_decref(pyelem, "ip",
+				PyLong_FromUnsignedLongLong(node->ip));
+
+		if (node->sym) {
+			PyObject *pysym  =3D PyDict_New();
+			if (!pysym)
+				Py_FatalError("couldn't create Python dictionary");
+			pydict_set_item_string_decref(pysym, "start",
+					PyLong_FromUnsignedLongLong(node->sym->start));
+			pydict_set_item_string_decref(pysym, "end",
+					PyLong_FromUnsignedLongLong(node->sym->end));
+			pydict_set_item_string_decref(pysym, "binding",
+					PyInt_FromLong(node->sym->binding));
+			pydict_set_item_string_decref(pysym, "name",
+					PyString_FromStringAndSize(node->sym->name,
+							node->sym->namelen));
+			pydict_set_item_string_decref(pyelem, "sym", pysym);
+		}
+
+		if (node->map) {
+			struct map *map =3D node->map;
+			const char *dsoname =3D "[unknown]";
+			if (map && map->dso && (map->dso->name || map->dso->long_name)) {
+				if (symbol_conf.show_kernel_path && map->dso->long_name)
+					dsoname =3D map->dso->long_name;
+				else if (map->dso->name)
+					dsoname =3D map->dso->name;
+			}
+			pydict_set_item_string_decref(pyelem, "dso",
+					PyString_FromString(dsoname));
+		}
+
+		callchain_cursor_advance(&callchain_cursor);
+		PyList_Append(pylist, pyelem);
+		Py_DECREF(pyelem);
+	}
+
+exit:
+	return pylist;
+}
+
+
 static void python_process_tracepoint(struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
-	PyObject *handler, *retval, *context, *t, *obj, *dict =3D NULL;
+	PyObject *handler, *retval, *context, *t, *obj, *callchain;
+	PyObject *dict =3D NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -327,6 +406,14 @@ static void python_process_tracepoint(struct perf_sa=
mple *sample,
 			pydict_set_item_string_decref(dict, field->name, obj);
=20
 	}
+
+	/* ip unwinding */
+	callchain =3D python_process_callchain(sample, evsel, al);
+	if (handler)
+		PyTuple_SetItem(t, n++, callchain);
+	else
+		pydict_set_item_string_decref(dict, "callchain", callchain);
+
 	if (!handler)
 		PyTuple_SetItem(t, n++, dict);
=20
@@ -360,7 +447,7 @@ static void python_process_general_event(struct perf_=
sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict;
+	PyObject *handler, *retval, *t, *dict, *dict_sample, *callchain;
 	static char handler_name[64];
 	unsigned n =3D 0;
=20
@@ -376,6 +463,10 @@ static void python_process_general_event(struct perf=
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
@@ -385,15 +476,30 @@ static void python_process_general_event(struct per=
f_sample *sample,
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
+	/* ip unwinding */
+	callchain =3D python_process_callchain(sample, evsel, al);
+	pydict_set_item_string_decref(dict, "callchain", callchain);
+
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSi=
ze(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
 			PyString_FromString(thread__comm_str(thread)));
 	if (al->map) {
 		pydict_set_item_string_decref(dict, "dso",
-			PyString_FromString(al->map->dso->name));
+				PyString_FromString(al->map->dso->name));
 	}
 	if (al->sym) {
 		pydict_set_item_string_decref(dict, "symbol",

--------------070607010409010904000502
Content-Type: text/x-patch;
 name="perf_python_retval_decref.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="perf_python_retval_decref.patch"

Perf: Fix possible memory leaks in Python interface

The function PyObject_CallObject() returns a new PyObject reference=20
on which Py_DECREF has to be called to avoid memory leaks.
This patch adds these calls where necessary.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/too=
ls/perf/util/scripting-engines/trace-event-python.c
index cd9774d..ee17f64 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -97,6 +97,8 @@ static void define_value(enum print_arg_type field_type=
,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		else
+			Py_DECREF(retval);
 	}
=20
 	Py_DECREF(t);
@@ -143,6 +145,8 @@ static void define_field(enum print_arg_type field_ty=
pe,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		else
+			Py_DECREF(retval);
 	}
=20
 	Py_DECREF(t);
@@ -333,6 +337,8 @@ static void python_process_tracepoint(struct perf_sam=
ple *sample,
 		retval =3D PyObject_CallObject(handler, t);
 		if (retval =3D=3D NULL)
 			handler_call_die(handler_name);
+		else
+			Py_DECREF(retval);
 	} else {
 		handler =3D PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
@@ -340,6 +346,8 @@ static void python_process_tracepoint(struct perf_sam=
ple *sample,
 			retval =3D PyObject_CallObject(handler, t);
 			if (retval =3D=3D NULL)
 				handler_call_die("trace_unhandled");
+			else
+				Py_DECREF(retval);
 		}
 		Py_DECREF(dict);
 	}
@@ -399,6 +407,8 @@ static void python_process_general_event(struct perf_=
sample *sample,
 	retval =3D PyObject_CallObject(handler, t);
 	if (retval =3D=3D NULL)
 		handler_call_die(handler_name);
+	else
+		Py_DECREF(retval);
 exit:
 	Py_DECREF(dict);
 	Py_DECREF(t);
@@ -444,8 +454,8 @@ static int run_start_sub(void)
 	retval =3D PyObject_CallObject(handler, NULL);
 	if (retval =3D=3D NULL)
 		handler_call_die("trace_begin");
-
-	Py_DECREF(retval);
+	else
+		Py_DECREF(retval);
 	return err;
 error:
 	Py_XDECREF(main_dict);

--------------070607010409010904000502--

--------------ms070202060605040507040702
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
hkiG9w0BCQUxDxcNMTQwNDAzMDg1NzM5WjAjBgkqhkiG9w0BCQQxFgQUahQENQ5DmGObLe52
S0uFeqZpgowwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQswCQYDVQQGEwJERTEoMCYGA1UE
ChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYD
VQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rl
bi5kZQIHFr0+Fq4AGTCBpAYLKoZIhvcNAQkQAgsxgZSggZEwgYUxCzAJBgNVBAYTAkRFMSgw
JgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgx
HDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1k
cmVzZGVuLmRlAgcWvT4WrgAZMA0GCSqGSIb3DQEBAQUABIIBAEPAWH+R78rEar8Zqs273cur
bFYN74ftdoGbi2hQDhkWeOYrK4d++3NjI8W95DBZQY84F/nxopDkRTotS27agabqKgF1YpS3
PUdQzbx9y42bMF10C+LmaUxpUN0BE8SqEeG9CasNn/elqmamEhU0IMOPX03kAA0PahXl0Iy7
+Vbl/Jt8FXcWI9J5Cs1+hiLIiUjVI6GOgDLLawWYd9DIbonbbq4u8bREXkkDsywyAS+Pf5zq
ybfBQukzbjnxg/0AowO0WhRnmRaCfY8x+dsIZH0FJj0FxqDfAKjWh/cm7rJilsLntm8Hdi9/
fzuN7D/NACUFqEximYKDVELiN5HlbOYAAAAAAAA=
--------------ms070202060605040507040702--
