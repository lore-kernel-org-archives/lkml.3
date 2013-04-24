Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab3DXXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:09:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38515 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3DXXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:09:42 -0400
X-AuditID: 85900ec0-d38c8b900000151e-4f-51786634c2c1
Subject: [PATCH V3 3/3] trace-cmd: Add support for extracting trace_clock in
 report
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Thu, 25 Apr 2013 08:13:05 +0900
Message-ID: <20130424231305.14877.86147.stgit@yunodevel>
In-Reply-To: <20130424231257.14877.77172.stgit@yunodevel>
References: <20130424231257.14877.77172.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If trace-cmd extracts trace_clock, trace-cmd reads trace_clock data from
the trace.dat and switches outputting format of timestamp for each trace_clock.

Changed in v2:
 - Check whether TRACECMD_OPTION_TRACECLOCK exists or not in trace.dat

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 event-parse.c |   50 +++++++++++++++++++++++++++++++++++++++-----------
 event-parse.h |    6 +++++-
 trace-cmd.h   |    2 ++
 trace-input.c |   33 +++++++++++++++++++++++++++++++++
 trace-read.c  |    4 +++-
 trace-util.c  |   26 ++++++++++++++++++++++++++
 6 files changed, 108 insertions(+), 13 deletions(-)

diff --git a/event-parse.c b/event-parse.c
index a18a493..a188c0e 100644
--- a/event-parse.c
+++ b/event-parse.c
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
@@ -4409,8 +4414,21 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
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
 	static char *spaces = "                    "; /* 20 spaces */
 	struct event_format *event;
@@ -4423,9 +4441,14 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
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
@@ -4450,15 +4473,20 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
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
diff --git a/event-parse.h b/event-parse.h
index 05e99fa..cd9f244 100644
--- a/event-parse.h
+++ b/event-parse.h
@@ -20,6 +20,7 @@
 #ifndef _PARSE_EVENTS_H
 #define _PARSE_EVENTS_H
 
+#include <stdbool.h>
 #include <stdarg.h>
 #include <regex.h>
 
@@ -456,6 +457,8 @@ struct pevent {
 
 	/* cache */
 	struct event_format *last_event;
+
+	char *trace_clock;
 };
 
 static inline void pevent_set_flag(struct pevent *pevent, int flag)
@@ -533,6 +536,7 @@ enum trace_flag_type {
 };
 
 int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
+void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock);
 int pevent_register_function(struct pevent *pevent, char *name,
 			     unsigned long long addr, char *mod);
 int pevent_register_print_string(struct pevent *pevent, const char *fmt,
@@ -540,7 +544,7 @@ int pevent_register_print_string(struct pevent *pevent, const char *fmt,
 int pevent_pid_is_registered(struct pevent *pevent, int pid);
 
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
-			struct pevent_record *record);
+			struct pevent_record *record, bool use_trace_clock);
 
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
diff --git a/trace-cmd.h b/trace-cmd.h
index 0745dad..bae4cc1 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -30,6 +30,7 @@
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
 void parse_cmdlines(struct pevent *pevent, char *file, int size);
+void parse_trace_clock(struct pevent *pevent, char *file, int size);
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
 
@@ -171,6 +172,7 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 struct pevent *tracecmd_get_pevent(struct tracecmd_input *handle);
+bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 
 char *tracecmd_get_tracing_file(const char *name);
 void tracecmd_put_tracing_file(char *name);
diff --git a/trace-input.c b/trace-input.c
index 232015a..369ad58 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -19,6 +19,7 @@
  */
 #define _LARGEFILE64_SOURCE
 #include <dirent.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -89,6 +90,7 @@ struct tracecmd_input {
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
+	bool			use_trace_clock;
 	struct cpu_data 	*cpu_data;
 	unsigned long long	ts_offset;
 	char *			cpustats;
@@ -1767,6 +1769,9 @@ static int handle_options(struct tracecmd_input *handle)
 			offset = *(unsigned long long *)buf;
 			buffer->offset = __data2host8(handle->pevent, offset);
 			break;
+		case TRACECMD_OPTION_TRACECLOCK:
+			handle->use_trace_clock = true;
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -1901,6 +1906,20 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle,
 	return 0;
 }
 
+static int read_and_parse_trace_clock(struct tracecmd_input *handle,
+							struct pevent *pevent)
+{
+	unsigned long long size;
+	char *trace_clock;
+
+	if (read_data_and_size(handle, &trace_clock, &size) < 0)
+		return -1;
+	trace_clock[size] = 0;
+	parse_trace_clock(pevent, trace_clock, size);
+	free(trace_clock);
+	return 0;
+}
+
 /**
  * tracecmd_init_data - prepare reading the data from trace.dat
  * @handle: input handle for the trace.dat file
@@ -1927,6 +1946,11 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 	if (ret < 0)
 		return ret;
 
+	if (handle->use_trace_clock) {
+		if (read_and_parse_trace_clock(handle, pevent) < 0)
+			return -1;
+	}
+
 	tracecmd_blk_hack(handle);
 
 	return ret;
@@ -2563,3 +2587,12 @@ struct pevent *tracecmd_get_pevent(struct tracecmd_input *handle)
 {
 	return handle->pevent;
 }
+
+/**
+ * tracecmd_get_use_trace_clock - return use_trace_clock
+ * @handle: input handle for the trace.dat file
+ */
+bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle)
+{
+	return handle->use_trace_clock;
+}
diff --git a/trace-read.c b/trace-read.c
index 7fc9a7f..2e84d78 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -655,6 +655,7 @@ static void show_data(struct tracecmd_input *handle,
 {
 	struct pevent *pevent;
 	struct trace_seq s;
+	bool use_trace_clock;
 
 	if (filter_record(handle, record))
 		return;
@@ -674,7 +675,8 @@ static void show_data(struct tracecmd_input *handle,
 		trace_seq_printf(&s, "CPU:%d [SUBBUFFER START]\n",
 				 record->cpu);
 
-	pevent_print_event(pevent, &s, record);
+	use_trace_clock = tracecmd_get_use_trace_clock(handle);
+	pevent_print_event(pevent, &s, record, use_trace_clock);
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
 		s.len--;
 	trace_seq_do_printf(&s);
diff --git a/trace-util.c b/trace-util.c
index 9b26d1f..d6c1e29 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -375,6 +375,32 @@ void parse_cmdlines(struct pevent *pevent,
 	}
 }
 
+static void extract_trace_clock(struct pevent *pevent, char *line)
+{
+	char *data;
+	char *clock;
+	char *next = NULL;
+
+	data = strtok_r(line, "[]", &next);
+	sscanf(data, "%ms", &clock);
+	pevent_register_trace_clock(pevent, clock);
+}
+
+void parse_trace_clock(struct pevent *pevent,
+			char *file, int size __maybe_unused)
+{
+	char *line;
+	char *next = NULL;
+
+	line = strtok_r(file, " ", &next);
+	while (line) {
+		/* current trace_clock is shown as "[local]". */
+		if (*line == '[')
+			return extract_trace_clock(pevent, line);
+		line = strtok_r(NULL, " ", &next);
+	}
+}
+
 void parse_proc_kallsyms(struct pevent *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {

