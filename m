Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJZWpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 18:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaJZWom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 18:44:42 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] perf script python: Removing event cache as it's no longer needed
Date: Sun, 26 Oct 2014 23:44:05 +0100
Message-Id: <1414363445-22370-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1414363445-22370-1-git-send-email-jolsa@kernel.org>
References: <1414363445-22370-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to maintain cache of 'struct event_format'
objects. Currently the 'struct perf_evsel' holds this
reference already.

Adding events_defined bitmap to keep track of defined events,
which is much cheaper than array of pointers.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../util/scripting-engines/trace-event-python.c    | 34 ++++------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 2fd7ee8f18c7..04417b282e5b 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -26,6 +26,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../../perf.h"
 #include "../debug.h"
@@ -45,7 +46,7 @@ PyMODINIT_FUNC initperf_trace_context(void);
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 #define MAX_FIELDS	64
 #define N_COMMON_FIELDS	7
@@ -251,31 +252,6 @@ static void define_event_symbols(struct event_format *event,
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
@@ -399,12 +375,12 @@ static void python_process_tracepoint(struct perf_sample *sample,
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
@@ -416,7 +392,6 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %d", (int)evsel->attr.config);
 
@@ -424,6 +399,9 @@ static void python_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler_name, event->print_fmt.args);
+
 	handler = get_handler(handler_name);
 	if (!handler) {
 		dict = PyDict_New();
-- 
1.9.3

