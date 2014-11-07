Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaKGFdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:33:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaKGFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:33:05 -0500
Date: Thu, 6 Nov 2014 21:32:13 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-adf5bcf39583c4db1bf30069f8957400e61ccb18@git.kernel.org>
Cc: mingo@kernel.org, jolsa@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, acme@redhat.com, dsahern@gmail.com,
        peterz@infradead.org, paulus@samba.org, mingo@redhat.com,
        namhyung@gmail.com, fweisbec@gmail.com
Reply-To: paulus@samba.org, mingo@redhat.com, namhyung@gmail.com,
        fweisbec@gmail.com, mingo@kernel.org, hpa@zytor.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        adrian.hunter@intel.com, acme@redhat.com, dsahern@gmail.com,
        peterz@infradead.org
In-Reply-To: <1414363445-22370-3-git-send-email-jolsa@kernel.org>
References: <1414363445-22370-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script python: Removing event cache as it'
 s no longer needed
Git-Commit-ID: adf5bcf39583c4db1bf30069f8957400e61ccb18
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

Commit-ID:  adf5bcf39583c4db1bf30069f8957400e61ccb18
Gitweb:     http://git.kernel.org/tip/adf5bcf39583c4db1bf30069f8957400e61ccb18
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 26 Oct 2014 23:44:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Nov 2014 17:44:06 -0300

perf script python: Removing event cache as it's no longer needed

We don't need to maintain cache of 'struct event_format' objects.
Currently the 'struct perf_evsel' holds this reference already.

Adding events_defined bitmap to keep track of defined events, which is
much cheaper than array of pointers.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1414363445-22370-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    | 34 ++++------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 118bc62..d808a32 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -26,6 +26,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../../perf.h"
 #include "../debug.h"
@@ -46,7 +47,7 @@ PyMODINIT_FUNC initperf_trace_context(void);
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 #define MAX_FIELDS	64
 #define N_COMMON_FIELDS	7
@@ -255,31 +256,6 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
-{
-	static char ev_name[256];
-	struct event_format *event;
-	int type = evsel->attr.config;
-
-	/*
- 	 * XXX: Do we really need to cache this since now we have evsel->tp_format
- 	 * cached already? Need to re-read this "cache" routine that as well calls
- 	 * define_event_symbols() :-\
- 	 */
-	if (events[type])
-		return events[type];
-
-	events[type] = event = evsel->tp_format;
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s__%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
 static PyObject *get_field_numeric_entry(struct event_format *event,
 		struct format_field *field, void *data)
 {
@@ -403,12 +379,12 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
+	struct event_format *event = evsel->tp_format;
 	PyObject *handler, *context, *t, *obj, *callchain;
 	PyObject *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long s, ns;
-	struct event_format *event;
 	unsigned n = 0;
 	int pid;
 	int cpu = sample->cpu;
@@ -420,7 +396,6 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %d", (int)evsel->attr.config);
 
@@ -428,6 +403,9 @@ static void python_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler_name, event->print_fmt.args);
+
 	handler = get_handler(handler_name);
 	if (!handler) {
 		dict = PyDict_New();
