Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3KAVzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:55:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754197Ab3KAVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:01 -0400
Message-Id: <20131101215500.312487697@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 1/8] tools lib traceevent: Add support for extracting trace_clock in
 report
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0001-tools-lib-traceevent-Add-support-for-extracting-trac.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

If trace-cmd extracts trace_clock, trace-cmd reads trace_clock data from
the trace.dat and switches outputting format of timestamp for each trace_clock.

Link: http://lkml.kernel.org/r/20130424231305.14877.86147.stgit@yunodevel

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 50 +++++++++++++++++++++++++++++---------
 tools/lib/traceevent/event-parse.h |  6 ++++-
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d1c2a6a..deedff9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -305,6 +305,11 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
 	return 0;
 }
 
+void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock)
+{
+	pevent->trace_clock = trace_clock;
+}
+
 struct func_map {
 	unsigned long long		addr;
 	char				*func;
@@ -4443,8 +4448,21 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
 	trace_seq_terminate(s);
 }
 
+static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
+{
+	if (!use_trace_clock)
+		return true;
+
+	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")
+	    || !strcmp(trace_clock, "uptime") || !strcmp(trace_clock, "perf"))
+		return true;
+
+	/* trace_clock is setting in tsc or counter mode */
+	return false;
+}
+
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
-			struct pevent_record *record)
+			struct pevent_record *record, bool use_trace_clock)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
 	struct event_format *event;
@@ -4457,9 +4475,14 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	int pid;
 	int len;
 	int p;
+	bool use_usec_format;
 
-	secs = record->ts / NSECS_PER_SEC;
-	nsecs = record->ts - secs * NSECS_PER_SEC;
+	use_usec_format = is_timestamp_in_us(pevent->trace_clock,
+							use_trace_clock);
+	if (use_usec_format) {
+		secs = record->ts / NSECS_PER_SEC;
+		nsecs = record->ts - secs * NSECS_PER_SEC;
+	}
 
 	if (record->size < 0) {
 		do_warning("ug! negative record size %d", record->size);
@@ -4484,15 +4507,20 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	} else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 
-	if (pevent->flags & PEVENT_NSEC_OUTPUT) {
-		usecs = nsecs;
-		p = 9;
-	} else {
-		usecs = (nsecs + 500) / NSECS_PER_USEC;
-		p = 6;
-	}
+	if (use_usec_format) {
+		if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+			usecs = nsecs;
+			p = 9;
+		} else {
+			usecs = (nsecs + 500) / NSECS_PER_USEC;
+			p = 6;
+		}
 
-	trace_seq_printf(s, " %5lu.%0*lu: %s: ", secs, p, usecs, event->name);
+		trace_seq_printf(s, " %5lu.%0*lu: %s: ",
+					secs, p, usecs, event->name);
+	} else
+		trace_seq_printf(s, " %12llu: %s: ",
+					record->ts, event->name);
 
 	/* Space out the event names evenly. */
 	len = strlen(event->name);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c37b202..7503edf 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -20,6 +20,7 @@
 #ifndef _PARSE_EVENTS_H
 #define _PARSE_EVENTS_H
 
+#include <stdbool.h>
 #include <stdarg.h>
 #include <regex.h>
 
@@ -450,6 +451,8 @@ struct pevent {
 
 	/* cache */
 	struct event_format *last_event;
+
+	char *trace_clock;
 };
 
 static inline void pevent_set_flag(struct pevent *pevent, int flag)
@@ -527,6 +530,7 @@ enum trace_flag_type {
 };
 
 int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
+void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock);
 int pevent_register_function(struct pevent *pevent, char *name,
 			     unsigned long long addr, char *mod);
 int pevent_register_print_string(struct pevent *pevent, char *fmt,
@@ -534,7 +538,7 @@ int pevent_register_print_string(struct pevent *pevent, char *fmt,
 int pevent_pid_is_registered(struct pevent *pevent, int pid);
 
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
-			struct pevent_record *record);
+			struct pevent_record *record, bool use_trace_clock);
 
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
-- 
1.8.4.rc3


