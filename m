Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3KLQbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:31:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38444 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3KLQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:31:20 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf trace: Add summary only option
Date: Tue, 12 Nov 2013 09:31:15 -0700
Message-Id: <1384273875-3751-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per request from Pekka make --summary a summary only option meaning do not
show the individual system calls. Add another option to see all syscalls
along with the summary. In addition use 's' and 'S' as shortcuts for the
options.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-trace.txt | 10 ++++++++--
 tools/perf/builtin-trace.c              | 16 +++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 7b0497f95a75..fae38d9a44a4 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -93,9 +93,15 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --comm::
         Show process COMM right beside its ID, on by default, disable with --no-comm.
 
+-s::
 --summary::
-	Show a summary of syscalls by thread with min, max, and average times (in
-    msec) and relative stddev.
+	Show only a summary of syscalls by thread with min, max, and average times
+    (in msec) and relative stddev.
+
+-S::
+--with-summary::
+	Show all syscalls followed by a summary by thread with min, max, and
+    average times (in msec) and relative stddev.
 
 --tool_stats::
 	Show tool stats such as number of times fd->pathname was discovered thru
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c3008b1c369c..9da374cdc23a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1155,6 +1155,7 @@ struct trace {
 	bool			sched;
 	bool			multiple_threads;
 	bool			summary;
+	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
 	double			duration_filter;
@@ -1598,7 +1599,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 					   args, trace, thread);
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
-		if (!trace->duration_filter) {
+		if (!trace->duration_filter && !trace->summary_only) {
 			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
 			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
 		}
@@ -1651,6 +1652,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	} else if (trace->duration_filter)
 		goto out;
 
+	if (trace->summary_only)
+		goto out;
+
 	trace__fprintf_entry_head(trace, thread, duration, sample->time, trace->output);
 
 	if (ttrace->entry_pending) {
@@ -2265,8 +2269,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_BOOLEAN('T', "time", &trace.full_time,
 		    "Show full timestamp, not time relative to first start"),
-	OPT_BOOLEAN(0, "summary", &trace.summary,
-		    "Show syscall summary with statistics"),
+	OPT_BOOLEAN('s', "summary", &trace.summary_only,
+		    "Show only syscall summary with statistics"),
+	OPT_BOOLEAN('S', "with-summary", &trace.summary,
+		    "Show all syscalls and summary with statistics"),
 	OPT_END()
 	};
 	int err;
@@ -2277,6 +2283,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (trace.summary_only)
+		trace.summary = trace.summary_only;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
-- 
1.8.3.4 (Apple Git-47)

