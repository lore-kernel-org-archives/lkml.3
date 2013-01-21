Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3AUOJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:09:20 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40163 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3AUOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:09:10 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 2/2] perf stat: add interval printing
Date: Mon, 21 Jan 2013 15:06:54 +0100
Message-Id: <1358777214-14220-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358777214-14220-1-git-send-email-eranian@google.com>
References: <1358777214-14220-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new printing mode for perf stat.
It allows internval printing. That means perf stat
can now print event deltas at regular time interval.
This is useful to detect phases in programs.

The -I option enables interval printing. It expects
an interval duration in milliseconds. Minimum is
100ms. Once, activated perf stat prints events deltas
since last printout. All modes are supported.

$ perf stat -I 1000 -e cycles noploop 10
noploop for 10 seconds
 #           time             counts events
      1.000109853      2,388,560,546 cycles
      2.000262846      2,393,332,358 cycles
      3.000354131      2,393,176,537 cycles
      4.000439503      2,393,203,790 cycles
      5.000527075      2,393,167,675 cycles
      6.000609052      2,393,203,670 cycles
      7.000691082      2,393,175,678 cycles

The output format makes it easy to feed into a plotting program
such as gnuplot when the -I option is used in combination with the -x
option:

$ perf stat -x, -I 1000 -e cycles noploop 10
noploop for 10 seconds
1.000084113,2378775498,cycles
2.000245798,2391056897,cycles
3.000354445,2392089414,cycles
4.000459115,2390936603,cycles
5.000565341,2392108173,cycles

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-stat.txt |    4 +
 tools/perf/builtin-stat.c              |  165 +++++++++++++++++++++++++++++---
 2 files changed, 154 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index cf0c310..5289da3 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -114,6 +114,10 @@ Log output to fd, instead of stderr.  Complementary to --output, and mutually ex
 
 perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' -- make -s -j64 O=defconfig-build/ bzImage
 
+-I msecs::
+--interval-print msecs::
+	print count deltas every N milliseconds (minimum: 100ms)
+	example: perf stat -I 1000 -e cycles -a sleep 5
 
 EXAMPLES
 --------
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c247fac..8ab3095 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -65,6 +65,10 @@
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
 
+static void print_stat(int argc, const char **argv);
+static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
+static void print_counter(struct perf_evsel *counter, char *prefix);
+
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
@@ -87,6 +91,8 @@ static FILE			*output				= NULL;
 static const char		*pre_cmd			= NULL;
 static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
+static unsigned int		interval			= 0;
+static struct timespec		ref_time;
 
 static volatile int done = 0;
 
@@ -94,6 +100,28 @@ struct perf_stat {
 	struct stats	  res_stats[3];
 };
 
+static inline void diff_timespec(struct timespec *r, struct timespec *a,
+				 struct timespec *b)
+{
+	r->tv_sec = a->tv_sec - b->tv_sec;
+	if (a->tv_nsec < b->tv_nsec) {
+		r->tv_nsec = a->tv_nsec + 1000000000L - b->tv_nsec;
+		r->tv_sec--;
+	} else {
+		r->tv_nsec = a->tv_nsec - b->tv_nsec ;
+	}
+}
+
+static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
+{
+	return (evsel->cpus && !target.cpu_list) ? evsel->cpus : evsel_list->cpus;
+}
+
+static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
+{
+	return perf_evsel__cpus(evsel)->nr;
+}
+
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
@@ -106,14 +134,27 @@ static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
 	evsel->priv = NULL;
 }
 
-static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
+static int perf_evsel__alloc_prev_raw_counts(struct perf_evsel *evsel)
 {
-	return (evsel->cpus && !target.cpu_list) ? evsel->cpus : evsel_list->cpus;
+	void *addr;
+	size_t sz;
+
+	sz = sizeof(*evsel->counts) +
+	     (perf_evsel__nr_cpus(evsel) * sizeof(struct perf_counts_values));
+
+	addr = zalloc(sz);
+	if (!addr)
+		return -ENOMEM;
+
+	evsel->prev_raw_counts =  addr;
+
+	return 0;
 }
 
-static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
+static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 {
-	return perf_evsel__cpus(evsel)->nr;
+	free(evsel->prev_raw_counts);
+	evsel->prev_raw_counts = NULL;
 }
 
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
@@ -269,15 +310,68 @@ static int read_counter(struct perf_evsel *counter)
 	return 0;
 }
 
+static void print_interval(void)
+{
+	static int num_print_interval;
+	struct perf_evsel *counter;
+	struct perf_stat *ps;
+	struct timespec ts, rs;
+	char prefix[64];
+
+	if (no_aggr) {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			ps = counter->priv;
+			memset(ps->res_stats, 0, sizeof(ps->res_stats));
+			read_counter(counter);
+		}
+	} else {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			ps = counter->priv;
+			memset(ps->res_stats, 0, sizeof(ps->res_stats));
+			read_counter_aggr(counter);
+		}
+	}
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	diff_timespec(&rs, &ts, &ref_time);
+	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
+
+	if (num_print_interval == 0 && !csv_output) {
+		if (no_aggr)
+			fprintf(output, "#           time CPU                 counts events\n");
+		else
+			fprintf(output, "#           time             counts events\n");
+	}
+
+	if (++num_print_interval == 25)
+		num_print_interval = 0;
+
+	if (no_aggr) {
+		list_for_each_entry(counter, &evsel_list->entries, node)
+			print_counter(counter, prefix);
+	} else {
+		list_for_each_entry(counter, &evsel_list->entries, node)
+			print_counter_aggr(counter, prefix);
+	}
+}
+
 static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 {
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
+	struct timespec ts;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
 	char buf;
 
+	if (interval) {
+		ts.tv_sec  = interval / 1000;
+		ts.tv_nsec = (interval % 1000) * 1000000;
+	} else {
+		ts.tv_sec  = 1;
+		ts.tv_nsec = 0;
+	}
+
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		return -1;
@@ -377,14 +471,25 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	 * Enable counters and exec the command:
 	 */
 	t0 = rdclock();
+	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
 		close(go_pipe[1]);
+		if (interval) {
+			while (!waitpid(child_pid, &status, WNOHANG)) {
+				nanosleep(&ts, NULL);
+				print_interval();
+			}
+		}
 		wait(&status);
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
-		while(!done) sleep(1);
+		while (!done) {
+			nanosleep(&ts, NULL);
+			if (interval)
+				print_interval();
+		}
 	}
 
 	t1 = rdclock();
@@ -470,7 +575,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
 
-	if (csv_output)
+	if (csv_output || interval)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
@@ -684,12 +789,11 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
 
-	if (csv_output)
+	if (csv_output || interval)
 		return;
 
 	if (perf_evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS)) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
-
 		if (total)
 			ratio = avg / total;
 
@@ -783,12 +887,15 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
  * Print out the results of a single counter:
  * aggregated counts in system-wide mode
  */
-static void print_counter_aggr(struct perf_evsel *counter)
+static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 {
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
 
+	if (prefix)
+		fprintf(output, "%s", prefix);
+
 	if (scaled == -1) {
 		fprintf(output, "%*s%s%*s",
 			csv_output ? 0 : 18,
@@ -831,7 +938,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
  * Print out the results of a single counter:
  * does not use aggregated count in system-wide
  */
-static void print_counter(struct perf_evsel *counter)
+static void print_counter(struct perf_evsel *counter, char *prefix)
 {
 	u64 ena, run, val;
 	int cpu;
@@ -840,6 +947,10 @@ static void print_counter(struct perf_evsel *counter)
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
+
+		if (prefix)
+			fprintf(output, "%s", prefix);
+
 		if (run == 0 || ena == 0) {
 			fprintf(output, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
@@ -877,6 +988,8 @@ static void print_counter(struct perf_evsel *counter)
 static void print_stat(int argc, const char **argv)
 {
 	struct perf_evsel *counter;
+	struct timespec ts, rs;
+	char prefix[64] = { 0, };
 	int i;
 
 	fflush(stdout);
@@ -899,12 +1012,18 @@ static void print_stat(int argc, const char **argv)
 		fprintf(output, ":\n\n");
 	}
 
+	if (interval) {
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		diff_timespec(&rs, &ts, &ref_time);
+		sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
+	}
+
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter);
+			print_counter(counter, prefix);
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter_aggr(counter);
+			print_counter_aggr(counter, prefix);
 	}
 
 	if (!csv_output) {
@@ -925,7 +1044,7 @@ static volatile int signr = -1;
 
 static void skip_signal(int signo)
 {
-	if(child_pid == -1)
+	if ((child_pid == -1) || interval)
 		done = 1;
 
 	signr = signo;
@@ -1145,6 +1264,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run prior to the measured command"),
 	OPT_STRING(0, "post", &post_cmd, "command",
 			"command to run after to the measured command"),
+	OPT_UINTEGER('I', "interval-print", &interval,
+		    "print counts at regular interval in ms (>= 100)"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1245,12 +1366,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(stat_usage, options);
 		return -1;
 	}
+	if (interval && interval < 100) {
+		pr_err("print interval must be >= 100ms\n");
+		usage_with_options(stat_usage, options);
+		return -1;
+	}
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
 		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
 			goto out_free_fd;
 	}
+	if (interval) {
+		list_for_each_entry(pos, &evsel_list->entries, node) {
+			if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
+				goto out_free_fd;
+		}
+	}
 
 	/*
 	 * We dont want to block the signals - that would cause
@@ -1260,6 +1392,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	 */
 	atexit(sig_atexit);
 	signal(SIGINT,  skip_signal);
+	signal(SIGCHLD, skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
@@ -1272,11 +1405,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		status = run_perf_stat(argc, argv);
 	}
 
-	if (status != -1)
+	if (status != -1 && !interval)
 		print_stat(argc, argv);
 out_free_fd:
-	list_for_each_entry(pos, &evsel_list->entries, node)
+	list_for_each_entry(pos, &evsel_list->entries, node) {
 		perf_evsel__free_stat_priv(pos);
+		perf_evsel__free_prev_raw_counts(pos);
+	}
 	perf_evlist__delete_maps(evsel_list);
 out:
 	perf_evlist__delete(evsel_list);
-- 
1.7.9.5

