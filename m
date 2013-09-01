Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab3IAKwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab3IAKuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 20/24] tools list traceevent: Change pevent_parse_event to return event format
Date: Sun,  1 Sep 2013 12:48:45 +0200
Message-Id: <1378032529-18498-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing pevent_parse_event to return 'struct event_format',
for the parsed event if the return pointer is specified.

This way we can remove pevent_parse_format which does the
same stuff just without 'struct pevent' object. We will
need this change in following patches.

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
 tools/lib/traceevent/event-parse.c  | 28 +++++++---------------------
 tools/lib/traceevent/event-parse.h  |  7 ++++---
 tools/perf/util/evsel.c             |  2 +-
 tools/perf/util/trace-event-parse.c |  4 ++--
 4 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7bc75d6..4a2f223 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5044,25 +5044,6 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
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
  * @buf: the buffer storing the event format string
@@ -5076,7 +5057,9 @@ enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *
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
@@ -5085,7 +5068,7 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (event == NULL)
 		return ret;
 
-	if (add_event(pevent, event)) {
+	if (pevent && add_event(pevent, event)) {
 		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
 	}
@@ -5094,6 +5077,9 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (PRINT_ARGS && event->print_fmt.args)
 		print_args(event->print_fmt.args);
 
+	if (format)
+		*format = event;
+
 	return 0;
 
 event_add_failed:
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a2d6306..aa002fb 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -557,10 +557,11 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
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
index e8745fb..45a2a83 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -207,7 +207,7 @@ struct event_format *event_format__new(const char *sys, const char *name)
 		size += n;
 	} while (n > 0);
 
-	pevent_parse_format(&format, bf, size, sys);
+	pevent_parse_event(NULL, &format, bf, size, sys);
 
 out_free_bf:
 	free(bf);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index da28065..02eeea45 100644
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
1.7.11.7

