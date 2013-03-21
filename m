Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab3CUHTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:19:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45112 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3CUHTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:19:00 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-33-514ab461883f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/9] perf util: Handle failure case in trace_report()
Date: Thu, 21 Mar 2013 16:18:48 +0900
Message-Id: <1363850332-25297-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If pevent allocation in read_trace_init() fails, trace_report() will
return -1 and *ppevent is set to NULL.  Its callers should check this
case and handle it properly.

This is also a preparation for the removal of *die() calls.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c           |  9 +++++++--
 tools/perf/util/trace-event-read.c | 41 ++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a9b7349f7c5f..ebef10973965 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1672,8 +1672,8 @@ static int process_tracing_data(struct perf_file_section *section __maybe_unused
 				struct perf_header *ph __maybe_unused,
 				int fd, void *data)
 {
-	trace_report(fd, data, false);
-	return 0;
+	ssize_t ret = trace_report(fd, data, false);
+	return ret < 0 ? -1 : 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
@@ -2752,6 +2752,11 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 	if (evsel->tp_format)
 		return 0;
 
+	if (pevent == NULL) {
+		pr_debug("broken or missing trace data\n");
+		return -1;
+	}
+
 	event = pevent_find_event(pevent, evsel->attr.config);
 	if (event == NULL)
 		return -1;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 7cb24635adf2..9bf64986a968 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -293,7 +293,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
-	ssize_t size;
+	ssize_t size = -1;
+	struct pevent *pevent;
+
+	*ppevent = NULL;
 
 	calc_data_size = 1;
 	repipe = __repipe;
@@ -317,34 +320,38 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
-	*ppevent = read_trace_init(file_bigendian, host_bigendian);
-	if (*ppevent == NULL)
-		die("read_trace_init failed");
+	pevent = read_trace_init(file_bigendian, host_bigendian);
+	if (pevent == NULL) {
+		pr_debug("read_trace_init failed");
+		goto out;
+	}
 
 	read_or_die(buf, 1);
 	long_size = buf[0];
 
-	page_size = read4(*ppevent);
-
-	read_header_files(*ppevent);
+	page_size = read4(pevent);
 
-	read_ftrace_files(*ppevent);
-	read_event_files(*ppevent);
-	read_proc_kallsyms(*ppevent);
-	read_ftrace_printk(*ppevent);
+	read_header_files(pevent);
+	read_ftrace_files(pevent);
+	read_event_files(pevent);
+	read_proc_kallsyms(pevent);
+	read_ftrace_printk(pevent);
 
 	size = calc_data_size - 1;
 	calc_data_size = 0;
 	repipe = false;
 
 	if (show_funcs) {
-		pevent_print_funcs(*ppevent);
-		return size;
-	}
-	if (show_printk) {
-		pevent_print_printk(*ppevent);
-		return size;
+		pevent_print_funcs(pevent);
+	} else if (show_printk) {
+		pevent_print_printk(pevent);
 	}
 
+	*ppevent = pevent;
+	pevent = NULL;
+
+out:
+	if (pevent)
+		pevent_free(pevent);
 	return size;
 }
-- 
1.7.11.7

