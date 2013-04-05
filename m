Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172Ab3DEBxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:53:47 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:43316 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161153Ab3DEBxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:53:43 -0400
X-AuditID: 85900ec0-d4ccab900000151e-75-515e2e1effe7
Subject: [PATCH 2/2] trace-cmd: Support trace_clock extraction
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 05 Apr 2013 10:54:44 +0900
Message-ID: <20130405015444.19807.91495.stgit@yunodevel>
In-Reply-To: <20130405015439.19807.43932.stgit@yunodevel>
References: <20130405015439.19807.43932.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, trace-cmd reads trace_clock on debugfs in the report/extract
modes and outputs the data to trace.dat file. Then, in the report mode,
trace-cmd reads trace_clock data from the file and switches outputting format
of timestamp for each trace_clock.

Note that by applying this patch, the binary format of trace.data is changed
as follows:

<Current binary format>
...
[size of saved_cmdlines]
[saved_cmdlines contents]
[total cpu number]
...

<Changed binary format>
...
[size of saved_cmdlines]
[saved_cmdlines contents]
[size of trace_clock]  <== add
[trace_clock contents] <== add
[total cpu number]
...

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 event-parse.c  |   44 ++++++++++++++++++++++++++++++++++----------
 event-parse.h  |    3 +++
 trace-cmd.h    |    1 +
 trace-input.c  |   16 ++++++++++++++++
 trace-output.c |    6 ++++++
 trace-util.c   |   26 ++++++++++++++++++++++++++
 6 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/event-parse.c b/event-parse.c
index 05c1412..ff39d63 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -23,6 +23,7 @@
  *  Frederic Weisbecker gave his permission to relicense the code to
  *  the Lesser General Public License.
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -305,6 +306,11 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
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
@@ -4404,6 +4410,15 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
 	trace_seq_terminate(s);
 }
 
+static bool is_timestamp_in_ns(char *trace_clock)
+{
+	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global"))
+		return true;
+
+	/* trace_clock is setting in tsc or counter mode */
+	return false;
+}
+
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 			struct pevent_record *record)
 {
@@ -4418,9 +4433,13 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	int pid;
 	int len;
 	int p;
+	bool use_sec_format;
 
-	secs = record->ts / NSECS_PER_SEC;
-	nsecs = record->ts - secs * NSECS_PER_SEC;
+	use_sec_format = is_timestamp_in_ns(pevent->trace_clock);
+	if (use_sec_format) {
+		secs = record->ts / NSECS_PER_SEC;
+		nsecs = record->ts - secs * NSECS_PER_SEC;
+	}
 
 	if (record->size < 0) {
 		do_warning("ug! negative record size %d", record->size);
@@ -4445,15 +4464,20 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	} else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 
-	if (pevent->flags & PEVENT_NSEC_OUTPUT) {
-		usecs = nsecs;
-		p = 9;
-	} else {
-		usecs = (nsecs + 500) / NSECS_PER_USEC;
-		p = 6;
-	}
+	if (use_sec_format) {
+		if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+			usecs = nsecs;
+			p = 9;
+		} else {
+			usecs = (nsecs + 500) / NSECS_PER_USEC;
+			p = 6;
+		}
 
-	trace_seq_printf(s, " %5lu.%0*lu: %s: ", secs, p, usecs, event->name);
+		trace_seq_printf(s, " %5lu.%0*lu: %s: ",
+						secs, p, usecs, event->name);
+	} else
+		trace_seq_printf(s, " %12llu: %s: ",
+						record->ts, event->name);
 
 	/* Space out the event names evenly. */
 	len = strlen(event->name);
diff --git a/event-parse.h b/event-parse.h
index de31909..540095f 100644
--- a/event-parse.h
+++ b/event-parse.h
@@ -456,6 +456,8 @@ struct pevent {
 
 	/* cache */
 	struct event_format *last_event;
+
+	char *trace_clock;
 };
 
 static inline void pevent_set_flag(struct pevent *pevent, int flag)
@@ -533,6 +535,7 @@ enum trace_flag_type {
 };
 
 int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
+void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock);
 int pevent_register_function(struct pevent *pevent, char *name,
 			     unsigned long long addr, char *mod);
 int pevent_register_print_string(struct pevent *pevent, char *fmt,
diff --git a/trace-cmd.h b/trace-cmd.h
index 37c037e..29cce65 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -30,6 +30,7 @@
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
 void parse_cmdlines(struct pevent *pevent, char *file, int size);
+void parse_trace_clock(struct pevent *pevent, char *file, int size);
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
 
diff --git a/trace-input.c b/trace-input.c
index ba3a21e..92791d8 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1789,6 +1789,20 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle,
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
@@ -1807,6 +1821,8 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 
 	if (read_and_parse_cmdlines(handle, pevent) < 0)
 		return -1;
+	if (read_and_parse_trace_clock(handle, pevent) < 0)
+		return -1;	
 
 	handle->cpus = read4(handle);
 	if (handle->cpus < 0)
diff --git a/trace-output.c b/trace-output.c
index e0d4ff4..0d858a9 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -804,6 +804,12 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
 		goto out_free;
 
+	/*
+	 * Save the current timestamp mode;
+	 */
+	if (save_tracing_file_data(handle, "trace_clock") < 0)
+		goto out_free;
+
 	return handle;
 
  out_free:
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

