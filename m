Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbaGREW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:22:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaGREWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:22:54 -0400
Date: Thu, 17 Jul 2014 21:22:37 -0700
From: tip-bot for Joseph Schuchart <tipbot@zytor.com>
Message-ID: <tip-05f832e3a267d6e45d092595bdf9339d127ea137@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, thomas.ilsche@tu-dresden.de, jolsa@redhat.com,
        joseph.schuchart@tu-dresden.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, jolsa@redhat.com, thomas.ilsche@tu-dresden.de,
        joseph.schuchart@tu-dresden.de, tglx@linutronix.de
In-Reply-To: <53BD4EBF.5050407@tu-dresden.de>
References: <53BD4EBF.5050407@tu-dresden.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Add missing calls to Py_DECREF for return values
Git-Commit-ID: 05f832e3a267d6e45d092595bdf9339d127ea137
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05f832e3a267d6e45d092595bdf9339d127ea137
Gitweb:     http://git.kernel.org/tip/05f832e3a267d6e45d092595bdf9339d127ea137
Author:     Joseph Schuchart <joseph.schuchart@tu-dresden.de>
AuthorDate: Wed, 9 Jul 2014 16:16:31 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:33 -0300

perf script: Add missing calls to Py_DECREF for return values

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
index e55b65a..b6c1a69 100644
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
