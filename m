Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3JID1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:27:13 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53154 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JID1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:27:08 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf trace: Add summary option to dump syscall statistics
Date: Tue,  8 Oct 2013 21:26:53 -0600
Message-Id: <1381289214-24885-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabled dumps a summary of all syscalls by task with the usual
statistics -- min, max, average and relative stddev. For example,

make - 26341 :       3344   [ 17.4% ]      0.000 ms

                read :   52    0.000     4.802     0.644   30.08
               write :   20    0.004     0.036     0.010   21.72
                open :   24    0.003     0.046     0.014   23.68
               close :   64    0.002     0.055     0.008   22.53
                stat : 2714    0.002     0.222     0.004    4.47
               fstat :   18    0.001     0.041     0.006   46.26
                mmap :   30    0.003     0.009     0.006    5.71
            mprotect :    8    0.006     0.039     0.016   32.16
              munmap :   12    0.007     0.077     0.020   38.25
                 brk :   48    0.002     0.014     0.004   10.18
        rt_sigaction :   18    0.002     0.002     0.002    2.11
      rt_sigprocmask :   60    0.002     0.128     0.010   32.88
              access :    2    0.006     0.006     0.006    0.00
                pipe :   12    0.004     0.048     0.013   35.98
               vfork :   34    0.448     0.980     0.692    3.04
              execve :   20    0.000     0.387     0.046   56.66
               wait4 :   34    0.017  9923.287   593.221   68.45
               fcntl :    8    0.001     0.041     0.013   48.79
            getdents :   48    0.002     0.079     0.013   19.62
              getcwd :    2    0.005     0.005     0.005    0.00
               chdir :    2    0.070     0.070     0.070    0.00
           getrlimit :    2    0.045     0.045     0.045    0.00
          arch_prctl :    2    0.002     0.002     0.002    0.00
           setrlimit :    2    0.002     0.002     0.002    0.00
              openat :   94    0.003     0.005     0.003    2.11

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-trace.txt |    4 ++
 tools/perf/builtin-trace.c              |  110 +++++++++++++++++++++++++++----
 2 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 1a224862118f..54139c6457f8 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -93,6 +93,10 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --comm::
         Show process COMM right beside its ID, on by default, disable with --no-comm.
 
+--summary::
+	Show a summary of syscalls by thread with min, max, and average times (in
+    msec) and relative stddev.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 27c4269b7fe3..8a3f0bdb0f79 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -10,6 +10,7 @@
 #include "util/strlist.h"
 #include "util/intlist.h"
 #include "util/thread_map.h"
+#include "util/stat.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
@@ -892,6 +893,8 @@ struct thread_trace {
 		int	  max;
 		char	  **table;
 	} paths;
+
+	struct intlist *syscall_stats;
 };
 
 static struct thread_trace *thread_trace__new(void)
@@ -901,6 +904,8 @@ static struct thread_trace *thread_trace__new(void)
 	if (ttrace)
 		ttrace->paths.max = -1;
 
+	ttrace->syscall_stats = intlist__new(NULL);
+
 	return ttrace;
 }
 
@@ -947,6 +952,7 @@ struct trace {
 	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
+	bool			summary;
 	bool			show_comm;
 	double			duration_filter;
 	double			runtime_ms;
@@ -1274,10 +1280,8 @@ typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
-					   struct perf_evsel *evsel,
-					   struct perf_sample *sample)
+					   struct perf_evsel *evsel, int id)
 {
-	int id = perf_evsel__intval(evsel, sample, "id");
 
 	if (id < 0) {
 
@@ -1318,6 +1322,32 @@ out_cant_read:
 	return NULL;
 }
 
+static void thread__update_stats(struct thread_trace *ttrace,
+				 int id, struct perf_sample *sample)
+{
+	struct int_node *inode;
+	struct stats *stats;
+	u64 duration = 0;
+
+	inode = intlist__findnew(ttrace->syscall_stats, id);
+	if (inode == NULL)
+		return;
+
+	stats = inode->priv;
+	if (stats == NULL) {
+		stats = malloc(sizeof(struct stats));
+		if (stats == NULL)
+			return;
+		init_stats(stats);
+		inode->priv = stats;
+	}
+
+	if (ttrace->entry_time && sample->time > ttrace->entry_time)
+		duration = sample->time - ttrace->entry_time;
+
+	update_stats(stats, duration);
+}
+
 static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 			    struct perf_sample *sample)
 {
@@ -1325,7 +1355,8 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	void *args;
 	size_t printed = 0;
 	struct thread *thread;
-	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	int id = perf_evsel__intval(evsel, sample, "id");
+	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
 	if (sc == NULL)
@@ -1377,7 +1408,8 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	int ret;
 	u64 duration = 0;
 	struct thread *thread;
-	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	int id = perf_evsel__intval(evsel, sample, "id");
+	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
 	if (sc == NULL)
@@ -1391,6 +1423,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (ttrace == NULL)
 		return -1;
 
+	if (trace->summary)
+		thread__update_stats(ttrace, id, sample);
+
 	ret = perf_evsel__intval(evsel, sample, "ret");
 
 	ttrace = thread->priv;
@@ -1557,6 +1592,8 @@ static int trace__record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1690,6 +1727,9 @@ again:
 	goto again;
 
 out_unmap_evlist:
+	if (!err && trace->summary)
+		trace__fprintf_thread_summary(trace, trace->output);
+
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
@@ -1762,6 +1802,9 @@ static int trace__replay(struct trace *trace)
 	if (err)
 		pr_err("Failed to process events, error %d", err);
 
+	else if (trace->summary)
+		trace__fprintf_thread_summary(trace, trace->output);
+
 out:
 	perf_session__delete(session);
 
@@ -1772,10 +1815,53 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 {
 	size_t printed;
 
-	printed  = fprintf(fp, "\n _____________________________________________________________________\n");
-	printed += fprintf(fp," __)    Summary of events    (__\n\n");
-	printed += fprintf(fp,"              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
-	printed += fprintf(fp," _____________________________________________________________________\n\n");
+	printed  = fprintf(fp, "\n _____________________________________________________________________________\n");
+	printed += fprintf(fp, " __)    Summary of events    (__\n\n");
+	printed += fprintf(fp, "              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
+	printed += fprintf(fp, "                                  syscall  count    min     max    avg  stddev\n");
+	printed += fprintf(fp, "                                                   msec    msec   msec     %%\n");
+	printed += fprintf(fp, " _____________________________________________________________________________\n\n");
+
+	return printed;
+}
+
+static size_t thread__dump_stats(struct thread_trace *ttrace,
+				 struct trace *trace, FILE *fp)
+{
+	struct stats *stats;
+	size_t printed = 0;
+	struct syscall *sc;
+	struct int_node *inode = intlist__first(ttrace->syscall_stats);
+
+	if (inode == NULL)
+		return 0;
+
+	printed += fprintf(fp, "\n");
+
+	/* each int_node is a syscall */
+	while (inode) {
+		stats = inode->priv;
+		if (stats) {
+			double min = (double)(stats->min) / NSEC_PER_MSEC;
+			double max = (double)(stats->max) / NSEC_PER_MSEC;
+			double avg = avg_stats(stats);
+			double pct;
+			u64 n = (u64) stats->n;
+
+			pct = avg ? 100.0 * stddev_stats(stats)/avg : 0.0;
+			avg /= NSEC_PER_MSEC;
+
+			sc = &trace->syscalls.table[inode->i];
+			printed += fprintf(fp, "%24s  %14s : ", "", sc->name);
+			printed += fprintf(fp, "%5" PRIu64 "  %8.3f  %8.3f",
+					   n, min, max);
+			printed += fprintf(fp, "  %8.3f  %6.2f\n", avg, pct);
+		}
+
+		inode = intlist__next(inode);
+	}
+
+	printed += fprintf(fp, "\n\n");
 
 	return printed;
 }
@@ -1814,6 +1900,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+	printed += thread__dump_stats(ttrace, trace, fp);
 
 	data->printed += printed;
 
@@ -1917,6 +2004,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_BOOLEAN('T', "time", &trace.full_time,
 		    "Show full timestamp, not time relative to first start"),
+	OPT_BOOLEAN(0, "summary", &trace.summary,
+		    "Show syscall summary with statistics"),
 	OPT_END()
 	};
 	int err;
@@ -1972,9 +2061,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	else
 		err = trace__run(&trace, argc, argv);
 
-	if (trace.sched && !err)
-		trace__fprintf_thread_summary(&trace, trace.output);
-
 out_close:
 	if (output_name != NULL)
 		fclose(trace.output);
-- 
1.7.10.1

