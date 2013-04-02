Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3DBJ1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:27:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3DBJ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:27:49 -0400
Date: Tue, 2 Apr 2013 02:27:29 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3dce2ce3cc40ece2562a5a83e879b4bfb451476c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-6-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle failure case in trace_report()
Git-Commit-ID: 3dce2ce3cc40ece2562a5a83e879b4bfb451476c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:27:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dce2ce3cc40ece2562a5a83e879b4bfb451476c
Gitweb:     http://git.kernel.org/tip/3dce2ce3cc40ece2562a5a83e879b4bfb451476c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:30:52 -0300

perf tools: Handle failure case in trace_report()

If pevent allocation in read_trace_init() fails, trace_report() will
return -1 and *ppevent is set to NULL.  Its callers should check this
case and handle it properly.

This is also a preparation for the removal of *die() calls.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c           |  9 +++++++--
 tools/perf/util/trace-event-read.c | 41 ++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 79e48c72..326068a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1670,8 +1670,8 @@ static int process_tracing_data(struct perf_file_section *section __maybe_unused
 				struct perf_header *ph __maybe_unused,
 				int fd, void *data)
 {
-	trace_report(fd, data, false);
-	return 0;
+	ssize_t ret = trace_report(fd, data, false);
+	return ret < 0 ? -1 : 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
@@ -2750,6 +2750,11 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
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
index 8c8181a..ba752d7 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -291,7 +291,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
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
@@ -315,34 +318,38 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
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
