Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3KLV5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3KLV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:14 -0500
Date: Tue, 12 Nov 2013 13:56:57 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-fd2eabaf16984bc75695e43f4b76e6f20ed4ea41@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1384273875-3751-1-git-send-email-dsahern@gmail.com>
References: <1384273875-3751-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Add summary only option
Git-Commit-ID: fd2eabaf16984bc75695e43f4b76e6f20ed4ea41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd2eabaf16984bc75695e43f4b76e6f20ed4ea41
Gitweb:     http://git.kernel.org/tip/fd2eabaf16984bc75695e43f4b76e6f20ed4ea41
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Nov 2013 09:31:15 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 16:24:38 -0300

perf trace: Add summary only option

Per request from Pekka make --summary a summary only option meaning do
not show the individual system calls. Add another option to see all
syscalls along with the summary. In addition use 's' and 'S' as
shortcuts for the options.

Requested-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Pekka Enberg <penberg@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1384273875-3751-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt | 10 ++++++++--
 tools/perf/builtin-trace.c              | 16 +++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 7b0497f..fae38d9 100644
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
index 0964c0c..aa5702f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1168,6 +1168,7 @@ struct trace {
 	bool			sched;
 	bool			multiple_threads;
 	bool			summary;
+	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
 	double			duration_filter;
@@ -1611,7 +1612,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 					   args, trace, thread);
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
-		if (!trace->duration_filter) {
+		if (!trace->duration_filter && !trace->summary_only) {
 			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
 			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
 		}
@@ -1664,6 +1665,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	} else if (trace->duration_filter)
 		goto out;
 
+	if (trace->summary_only)
+		goto out;
+
 	trace__fprintf_entry_head(trace, thread, duration, sample->time, trace->output);
 
 	if (ttrace->entry_pending) {
@@ -2282,8 +2286,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -2294,6 +2300,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (trace.summary_only)
+		trace.summary = trace.summary_only;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
