Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaHMWvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:55742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbaHMWvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:18 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/41] perf script python: Add helpers for calling Python objects
Date: Wed, 13 Aug 2014 19:48:23 -0300
Message-Id: <1407970107-24540-38-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The Python script API repeatedly uses the same lines of code to get and
call objects.  Make that into helper functions instead.

A side-effect is that some reference counting bugs disappear because the
new call_object() function always decrements the reference count of
'retval'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-19-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    | 114 +++++++++------------
 1 file changed, 47 insertions(+), 67 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cbce2545da45..26e5f14239ed 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -73,6 +73,35 @@ static void pydict_set_item_string_decref(PyObject *dict, const char *key, PyObj
 	Py_DECREF(val);
 }
 
+static PyObject *get_handler(const char *handler_name)
+{
+	PyObject *handler;
+
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && !PyCallable_Check(handler))
+		return NULL;
+	return handler;
+}
+
+static void call_object(PyObject *handler, PyObject *args, const char *die_msg)
+{
+	PyObject *retval;
+
+	retval = PyObject_CallObject(handler, args);
+	if (retval == NULL)
+		handler_call_die(die_msg);
+	Py_DECREF(retval);
+}
+
+static void try_call_object(const char *handler_name, PyObject *args)
+{
+	PyObject *handler;
+
+	handler = get_handler(handler_name);
+	if (handler)
+		call_object(handler, args, handler_name);
+}
+
 static void define_value(enum print_arg_type field_type,
 			 const char *ev_name,
 			 const char *field_name,
@@ -80,7 +109,7 @@ static void define_value(enum print_arg_type field_type,
 			 const char *field_str)
 {
 	const char *handler_name = "define_flag_value";
-	PyObject *handler, *t, *retval;
+	PyObject *t;
 	unsigned long long value;
 	unsigned n = 0;
 
@@ -98,13 +127,7 @@ static void define_value(enum print_arg_type field_type,
 	PyTuple_SetItem(t, n++, PyInt_FromLong(value));
 	PyTuple_SetItem(t, n++, PyString_FromString(field_str));
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && PyCallable_Check(handler)) {
-		retval = PyObject_CallObject(handler, t);
-		if (retval == NULL)
-			handler_call_die(handler_name);
-		Py_DECREF(retval);
-	}
+	try_call_object(handler_name, t);
 
 	Py_DECREF(t);
 }
@@ -127,7 +150,7 @@ static void define_field(enum print_arg_type field_type,
 			 const char *delim)
 {
 	const char *handler_name = "define_flag_field";
-	PyObject *handler, *t, *retval;
+	PyObject *t;
 	unsigned n = 0;
 
 	if (field_type == PRINT_SYMBOL)
@@ -145,13 +168,7 @@ static void define_field(enum print_arg_type field_type,
 	if (field_type == PRINT_FLAGS)
 		PyTuple_SetItem(t, n++, PyString_FromString(delim));
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && PyCallable_Check(handler)) {
-		retval = PyObject_CallObject(handler, t);
-		if (retval == NULL)
-			handler_call_die(handler_name);
-		Py_DECREF(retval);
-	}
+	try_call_object(handler_name, t);
 
 	Py_DECREF(t);
 }
@@ -362,7 +379,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
-	PyObject *handler, *retval, *context, *t, *obj, *callchain;
+	PyObject *handler, *context, *t, *obj, *callchain;
 	PyObject *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
@@ -387,9 +404,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && !PyCallable_Check(handler))
-		handler = NULL;
+	handler = get_handler(handler_name);
 	if (!handler) {
 		dict = PyDict_New();
 		if (!dict)
@@ -450,19 +465,9 @@ static void python_process_tracepoint(struct perf_sample *sample,
 		Py_FatalError("error resizing Python tuple");
 
 	if (handler) {
-		retval = PyObject_CallObject(handler, t);
-		if (retval == NULL)
-			handler_call_die(handler_name);
-		Py_DECREF(retval);
+		call_object(handler, t, handler_name);
 	} else {
-		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
-		if (handler && PyCallable_Check(handler)) {
-
-			retval = PyObject_CallObject(handler, t);
-			if (retval == NULL)
-				handler_call_die("trace_unhandled");
-			Py_DECREF(retval);
-		}
+		try_call_object("trace_unhandled", t);
 		Py_DECREF(dict);
 	}
 
@@ -474,7 +479,7 @@ static void python_process_general_event(struct perf_sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
+	PyObject *handler, *t, *dict, *callchain, *dict_sample;
 	static char handler_name[64];
 	unsigned n = 0;
 
@@ -496,8 +501,8 @@ static void python_process_general_event(struct perf_sample *sample,
 
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (!handler || !PyCallable_Check(handler))
+	handler = get_handler(handler_name);
+	if (!handler)
 		goto exit;
 
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
@@ -539,10 +544,7 @@ static void python_process_general_event(struct perf_sample *sample,
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
 
-	retval = PyObject_CallObject(handler, t);
-	if (retval == NULL)
-		handler_call_die(handler_name);
-	Py_DECREF(retval);
+	call_object(handler, t, handler_name);
 exit:
 	Py_DECREF(dict);
 	Py_DECREF(t);
@@ -566,36 +568,24 @@ static void python_process_event(union perf_event *event __maybe_unused,
 
 static int run_start_sub(void)
 {
-	PyObject *handler, *retval;
-	int err = 0;
-
 	main_module = PyImport_AddModule("__main__");
 	if (main_module == NULL)
 		return -1;
 	Py_INCREF(main_module);
 
 	main_dict = PyModule_GetDict(main_module);
-	if (main_dict == NULL) {
-		err = -1;
+	if (main_dict == NULL)
 		goto error;
-	}
 	Py_INCREF(main_dict);
 
-	handler = PyDict_GetItemString(main_dict, "trace_begin");
-	if (handler == NULL || !PyCallable_Check(handler))
-		goto out;
+	try_call_object("trace_begin", NULL);
 
-	retval = PyObject_CallObject(handler, NULL);
-	if (retval == NULL)
-		handler_call_die("trace_begin");
+	return 0;
 
-	Py_DECREF(retval);
-	return err;
 error:
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
-out:
-	return err;
+	return -1;
 }
 
 /*
@@ -654,23 +644,13 @@ error:
  */
 static int python_stop_script(void)
 {
-	PyObject *handler, *retval;
-	int err = 0;
+	try_call_object("trace_end", NULL);
 
-	handler = PyDict_GetItemString(main_dict, "trace_end");
-	if (handler == NULL || !PyCallable_Check(handler))
-		goto out;
-
-	retval = PyObject_CallObject(handler, NULL);
-	if (retval == NULL)
-		handler_call_die("trace_end");
-	Py_DECREF(retval);
-out:
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
 	Py_Finalize();
 
-	return err;
+	return 0;
 }
 
 static int python_generate_script(struct pevent *pevent, const char *outfile)
-- 
1.9.3

