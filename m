Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3JNUGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:06:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab3JNUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 140/161] perf trace: Add summary option to dump syscall statistics
Date: Mon, 14 Oct 2013 17:02:09 -0300
Message-Id: <1381780950-25642-141-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381289214-24885-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |   4 ++
 tools/perf/builtin-trace.c              | 110 ++++++++++++++++++++++++++++----
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
index 5496546b7c5c..d0f91fe755a3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -10,6 +10,7 @@
 #include "util/strlist.h"
 #include "util/intlist.h"
 #include "util/thread_map.h"
+#include "util/stat.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
@@ -909,6 +910,8 @@ struct thread_trace {
 		int	  max;
 		char	  **table;
 	} paths;
+
+	struct intlist *syscall_stats;
 };
 
 static struct thread_trace *thread_trace__new(void)
@@ -918,6 +921,8 @@ static struct thread_trace *thread_trace__new(void)
 	if (ttrace)
 		ttrace->paths.max = -1;
 
+	ttrace->syscall_stats = intlist__new(NULL);
+
 	return ttrace;
 }
 
@@ -964,6 +969,7 @@ struct trace {
 	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
+	bool			summary;
 	bool			show_comm;
 	double			duration_filter;
 	double			runtime_ms;
@@ -1291,10 +1297,8 @@ typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
-					   struct perf_evsel *evsel,
-					   struct perf_sample *sample)
+					   struct perf_evsel *evsel, int id)
 {
-	int id = perf_evsel__intval(evsel, sample, "id");
 
 	if (id < 0) {
 
@@ -1335,6 +1339,32 @@ out_cant_read:
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
@@ -1342,7 +1372,8 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	void *args;
 	size_t printed = 0;
 	struct thread *thread;
-	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	int id = perf_evsel__intval(evsel, sample, "id");
+	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
 	if (sc == NULL)
@@ -1394,7 +1425,8 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	int ret;
 	u64 duration = 0;
 	struct thread *thread;
-	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	int id = perf_evsel__intval(evsel, sample, "id");
+	struct syscall *sc = trace__syscall_info(trace, evsel, id);
 	struct thread_trace *ttrace;
 
 	if (sc == NULL)
@@ -1408,6 +1440,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (ttrace == NULL)
 		return -1;
 
+	if (trace->summary)
+		thread__update_stats(ttrace, id, sample);
+
 	ret = perf_evsel__intval(evsel, sample, "ret");
 
 	ttrace = thread->priv;
@@ -1574,6 +1609,8 @@ static int trace__record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1703,6 +1740,9 @@ again:
 	goto again;
 
 out_unmap_evlist:
+	if (!err && trace->summary)
+		trace__fprintf_thread_summary(trace, trace->output);
+
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
@@ -1798,6 +1838,9 @@ static int trace__replay(struct trace *trace)
 	if (err)
 		pr_err("Failed to process events, error %d", err);
 
+	else if (trace->summary)
+		trace__fprintf_thread_summary(trace, trace->output);
+
 out:
 	perf_session__delete(session);
 
@@ -1808,10 +1851,53 @@ static size_t trace__fprintf_threads_header(FILE *fp)
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
@@ -1850,6 +1936,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+	printed += thread__dump_stats(ttrace, trace, fp);
 
 	data->printed += printed;
 
@@ -1953,6 +2040,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_BOOLEAN('T', "time", &trace.full_time,
 		    "Show full timestamp, not time relative to first start"),
+	OPT_BOOLEAN(0, "summary", &trace.summary,
+		    "Show syscall summary with statistics"),
 	OPT_END()
 	};
 	int err;
@@ -2008,9 +2097,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	else
 		err = trace__run(&trace, argc, argv);
 
-	if (trace.sched && !err)
-		trace__fprintf_thread_summary(&trace, trace.output);
-
 out_close:
 	if (output_name != NULL)
 		fclose(trace.output);
-- 
1.8.1.4

