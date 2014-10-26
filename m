Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaJZWon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 18:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaJZWol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 18:44:41 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] perf script perl: Removing event cache as it's no longer needed
Date: Sun, 26 Oct 2014 23:44:04 +0100
Message-Id: <1414363445-22370-2-git-send-email-jolsa@kernel.org>
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
 .../perf/util/scripting-engines/trace-event-perl.c | 29 +++++-----------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 0a01bac4ce02..22ebc46226e7 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../util.h"
 #include <EXTERN.h>
@@ -57,7 +58,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 extern struct scripting_context *scripting_context;
 
@@ -238,35 +239,15 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
-{
-	static char ev_name[256];
-	struct event_format *event;
-	int type = evsel->attr.config;
-
-	if (events[type])
-		return events[type];
-
-	events[type] = event = evsel->tp_format;
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s::%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
 static void perl_process_tracepoint(struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct thread *thread)
 {
+	struct event_format *event = evsel->tp_format;
 	struct format_field *field;
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event_format *event;
 	int pid;
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -278,7 +259,6 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 		return;
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
@@ -286,6 +266,9 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler, "%s::%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler, event->print_fmt.args);
+
 	s = nsecs / NSECS_PER_SEC;
 	ns = nsecs - s * NSECS_PER_SEC;
 
-- 
1.9.3

