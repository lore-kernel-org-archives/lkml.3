Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbaGQQXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:23:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:52128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934790AbaGQQNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:12 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/33] perf script: Add missing calls to Py_DECREF for return values
Date: Thu, 17 Jul 2014 13:12:07 -0300
Message-Id: <1405613555-23380-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Link: http://lkml.kernel.org/r/53BD4EBF.5050407@tu-dresden.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index e55b65a65558..b6c1a69f2b18 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -50,10 +50,14 @@ static int zero_flag_atom;
 
 static PyObject *main_module, *main_dict;
 
+static void handler_call_die(const char *handler_name) NORETURN;
 static void handler_call_die(const char *handler_name)
 {
 	PyErr_Print();
 	Py_FatalError("problem in Python trace event handler");
+	// Py_FatalError does not return
+	// but we have to make the compiler happy
+	abort();
 }
 
 /*
@@ -97,6 +101,7 @@ static void define_value(enum print_arg_type field_type,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
 
 	Py_DECREF(t);
@@ -143,6 +148,7 @@ static void define_field(enum print_arg_type field_type,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
 
 	Py_DECREF(t);
@@ -361,6 +367,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	} else {
 		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
@@ -368,6 +375,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 			retval = PyObject_CallObject(handler, t);
 			if (retval == NULL)
 				handler_call_die("trace_unhandled");
+			Py_DECREF(retval);
 		}
 		Py_DECREF(dict);
 	}
@@ -427,6 +435,7 @@ static void python_process_general_event(struct perf_sample *sample,
 	retval = PyObject_CallObject(handler, t);
 	if (retval == NULL)
 		handler_call_die(handler_name);
+	Py_DECREF(retval);
 exit:
 	Py_DECREF(dict);
 	Py_DECREF(t);
@@ -548,8 +557,7 @@ static int python_stop_script(void)
 	retval = PyObject_CallObject(handler, NULL);
 	if (retval == NULL)
 		handler_call_die("trace_end");
-	else
-		Py_DECREF(retval);
+	Py_DECREF(retval);
 out:
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
-- 
1.9.3

