Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3AaK5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:57:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3AaK5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:57:15 -0500
Date: Thu, 31 Jan 2013 02:56:46 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-13370a9b5bb88f7aa90e5be68972d95096b20a6d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1359460064-3060-3-git-send-email-eranian@google.com>
References: <1359460064-3060-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add interval printing
Git-Commit-ID: 13370a9b5bb88f7aa90e5be68972d95096b20a6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:56:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13370a9b5bb88f7aa90e5be68972d95096b20a6d
Gitweb:     http://git.kernel.org/tip/13370a9b5bb88f7aa90e5be68972d95096b20a6d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 29 Jan 2013 12:47:44 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:36:53 -0300

perf stat: Add interval printing

This patch adds a new printing mode for perf stat.  It allows interval
printing. That means perf stat can now print event deltas at regular
time interval.  This is useful to detect phases in programs.

The -I option enables interval printing. It expects an interval duration
in milliseconds. Minimum is 100ms. Once, activated perf stat prints
events deltas since last printout. All modes are supported.

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

The output format makes it easy to feed into a plotting program such as
gnuplot when the -I option is used in combination with the -x option:

$ perf stat -x, -I 1000 -e cycles noploop 10
noploop for 10 seconds
1.000084113,2378775498,cycles
2.000245798,2391056897,cycles
3.000354445,2392089414,cycles
4.000459115,2390936603,cycles
5.000565341,2392108173,cycles

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359460064-3060-3-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |   4 +
 tools/perf/builtin-stat.c              | 157 +++++++++++++++++++++++++++++----
 2 files changed, 146 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index cf0c310..5289da3 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -114,6 +114,10 @@ with it.  --append may be used here.  Examples:
 
 perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' -- make -s -j64 O=defconfig-build/ bzImage
 
+-I msecs::
+--interval-print msecs::
+	print count deltas every N milliseconds (minimum: 100ms)
+	example: perf stat -I 1000 -e cycles -a sleep 5
 
 EXAMPLES
 --------
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1c2ac14..493043a 100644
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
@@ -245,16 +286,69 @@ static int read_counter(struct perf_evsel *counter)
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
 	char msg[512];
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
@@ -347,14 +441,25 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
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
@@ -440,7 +545,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
 
-	if (csv_output)
+	if (csv_output || interval)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
@@ -654,12 +759,11 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
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
 
@@ -753,12 +857,15 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
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
@@ -801,7 +908,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
  * Print out the results of a single counter:
  * does not use aggregated count in system-wide
  */
-static void print_counter(struct perf_evsel *counter)
+static void print_counter(struct perf_evsel *counter, char *prefix)
 {
 	u64 ena, run, val;
 	int cpu;
@@ -810,6 +917,10 @@ static void print_counter(struct perf_evsel *counter)
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
@@ -871,10 +982,10 @@ static void print_stat(int argc, const char **argv)
 
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter);
+			print_counter(counter, NULL);
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter_aggr(counter);
+			print_counter_aggr(counter, NULL);
 	}
 
 	if (!csv_output) {
@@ -895,7 +1006,7 @@ static volatile int signr = -1;
 
 static void skip_signal(int signo)
 {
-	if(child_pid == -1)
+	if ((child_pid == -1) || interval)
 		done = 1;
 
 	signr = signo;
@@ -1115,6 +1226,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run prior to the measured command"),
 	OPT_STRING(0, "post", &post_cmd, "command",
 			"command to run after to the measured command"),
+	OPT_UINTEGER('I', "interval-print", &interval,
+		    "print counts at regular interval in ms (>= 100)"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1215,12 +1328,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1230,6 +1354,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	 */
 	atexit(sig_atexit);
 	signal(SIGINT,  skip_signal);
+	signal(SIGCHLD, skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
@@ -1242,11 +1367,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
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
