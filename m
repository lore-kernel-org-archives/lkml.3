Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3KULCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:02:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3KULCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:02:32 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/22] tools lib traceevent: Change pevent_parse_event to return event format
Date: Thu, 21 Nov 2013 12:01:13 +0100
Message-Id: <1385031680-9014-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing pevent_parse_event to return 'struct event_format',
for the parsed event if the return pointer is specified.

This way we can remove pevent_parse_format which does the
same stuff just without 'struct pevent' object.

The ultimate goal is to always use pevent object when dealing
with traceevent library. The reason is that we might need
additional processing (like plugins), which is not possible
otherwise.

Patches follow to make this happen completely.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 32 +++++++++++---------------------
 tools/lib/traceevent/event-parse.h  |  7 ++++---
 tools/perf/util/evsel.c             |  2 +-
 tools/perf/util/trace-event-parse.c |  4 ++--
 4 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 74007ab..4baa0a9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5130,27 +5130,9 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 }
 
 /**
- * pevent_parse_format - parse the event format
- * @buf: the buffer storing the event format string
- * @size: the size of @buf
- * @sys: the system the event belongs to
- *
- * This parses the event format and creates an event structure
- * to quickly parse raw data for a given event.
- *
- * These files currently come from:
- *
- * /sys/kernel/debug/tracing/events/.../.../format
- */
-enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
-				      unsigned long size, const char *sys)
-{
-	return __pevent_parse_format(eventp, NULL, buf, size, sys);
-}
-
-/**
  * pevent_parse_event - parse the event format
  * @pevent: the handle to the pevent
+ * @format: event format object for passed format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -5158,11 +5140,16 @@ enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *
  * This parses the event format and creates an event structure
  * to quickly parse raw data for a given event.
  *
+ * Returns  event format object in @format parameter if
+ * specified.
+ *
  * These files currently come from:
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+enum pevent_errno pevent_parse_event(struct pevent *pevent,
+				     struct event_format **format,
+				     const char *buf,
 				     unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
@@ -5171,7 +5158,7 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (event == NULL)
 		return ret;
 
-	if (add_event(pevent, event)) {
+	if (pevent && add_event(pevent, event)) {
 		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
 	}
@@ -5180,6 +5167,9 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (PRINT_ARGS && event->print_fmt.args)
 		print_args(event->print_fmt.args);
 
+	if (format)
+		*format = event;
+
 	return 0;
 
 event_add_failed:
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 0ad7f6b..daafb70 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -559,10 +559,11 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
 
-enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+enum pevent_errno pevent_parse_event(struct pevent *pevent,
+				     struct event_format **format,
+				     const char *buf,
 				     unsigned long size, const char *sys);
-enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
-				      unsigned long size, const char *sys);
+
 void pevent_free_format(struct event_format *event);
 
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 77e38ff..599d1780 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -208,7 +208,7 @@ struct event_format *event_format__new(const char *sys, const char *name)
 		size += n;
 	} while (n > 0);
 
-	pevent_parse_format(&format, bf, size, sys);
+	pevent_parse_event(NULL, &format, bf, size, sys);
 
 out_free_bf:
 	free(bf);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6681f71..c8dae72 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -198,13 +198,13 @@ void parse_ftrace_printk(struct pevent *pevent,
 
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size)
 {
-	return pevent_parse_event(pevent, buf, size, "ftrace");
+	return pevent_parse_event(pevent, NULL, buf, size, "ftrace");
 }
 
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys)
 {
-	return pevent_parse_event(pevent, buf, size, sys);
+	return pevent_parse_event(pevent, NULL, buf, size, sys);
 }
 
 struct event_format *trace_find_next_event(struct pevent *pevent,
-- 
1.8.3.1

