Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3CULul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:50:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab3CULu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:50:29 -0400
Date: Thu, 21 Mar 2013 04:48:49 -0700
From: tip-bot for Frederik Deweerdt <tipbot@zytor.com>
Message-ID: <tip-a7e191c376fad084d9f3c7ac89a1f7c47462ebc8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, frederik.deweerdt@xprog.eu, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, frederik.deweerdt@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, frederik.deweerdt@xprog.eu,
        mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        frederik.deweerdt@gmail.com
In-Reply-To: <20130301180227.GA24385@ks398093.ip-192-95-24.net>
References: <20130301180227.GA24385@ks398093.ip-192-95-24.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Introduce --repeat forever
Git-Commit-ID: a7e191c376fad084d9f3c7ac89a1f7c47462ebc8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:49:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7e191c376fad084d9f3c7ac89a1f7c47462ebc8
Gitweb:     http://git.kernel.org/tip/a7e191c376fad084d9f3c7ac89a1f7c47462ebc8
Author:     Frederik Deweerdt <frederik.deweerdt@xprog.eu>
AuthorDate: Fri, 1 Mar 2013 13:02:27 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 14:01:26 -0300

perf stat: Introduce --repeat forever

The following patch causes 'perf stat --repeat 0' to be interpreted as
'forever', displaying the stats for every run.

We act as if a single run was asked, and reset the stats in each
iteration. In this mode SIGINT is passed to perf to be able to stop the
loop with Ctrl+C.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130301180227.GA24385@ks398093.ip-192-95-24.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |  2 +-
 tools/perf/builtin-stat.c              | 45 ++++++++++++++++++++++++++++++----
 tools/perf/util/evsel.c                |  6 +++++
 tools/perf/util/evsel.h                |  1 +
 4 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index faf4f4f..23e587a 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -52,7 +52,7 @@ OPTIONS
 
 -r::
 --repeat=<n>::
-	repeat command and print average + stddev (max: 100)
+	repeat command and print average + stddev (max: 100). 0 means forever.
 
 -B::
 --big-num::
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 69fe6ed..021783a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -94,6 +94,7 @@ static const char		*pre_cmd			= NULL;
 static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
+static bool			forever				= false;
 static struct timespec		ref_time;
 static struct cpu_map		*sock_map;
 
@@ -125,6 +126,11 @@ static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
 	return perf_evsel__cpus(evsel)->nr;
 }
 
+static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
+{
+	memset(evsel->priv, 0, sizeof(struct perf_stat));
+}
+
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
@@ -173,6 +179,22 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
+static void reset_stats(void)
+{
+	memset(runtime_nsecs_stats, 0, sizeof(runtime_nsecs_stats));
+	memset(runtime_cycles_stats, 0, sizeof(runtime_cycles_stats));
+	memset(runtime_stalled_cycles_front_stats, 0, sizeof(runtime_stalled_cycles_front_stats));
+	memset(runtime_stalled_cycles_back_stats, 0, sizeof(runtime_stalled_cycles_back_stats));
+	memset(runtime_branches_stats, 0, sizeof(runtime_branches_stats));
+	memset(runtime_cacherefs_stats, 0, sizeof(runtime_cacherefs_stats));
+	memset(runtime_l1_dcache_stats, 0, sizeof(runtime_l1_dcache_stats));
+	memset(runtime_l1_icache_stats, 0, sizeof(runtime_l1_icache_stats));
+	memset(runtime_ll_cache_stats, 0, sizeof(runtime_ll_cache_stats));
+	memset(runtime_itlb_cache_stats, 0, sizeof(runtime_itlb_cache_stats));
+	memset(runtime_dtlb_cache_stats, 0, sizeof(runtime_dtlb_cache_stats));
+	memset(&walltime_nsecs_stats, 0, sizeof(walltime_nsecs_stats));
+}
+
 static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -1252,7 +1274,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
-		    "repeat command and print average + stddev (max: 100)"),
+		    "repeat command and print average + stddev (max: 100, forever: 0)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
 	OPT_INCR('d', "detailed", &detailed_run,
@@ -1355,8 +1377,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (!argc && !perf_target__has_task(&target))
 		usage_with_options(stat_usage, options);
-	if (run_count <= 0)
+	if (run_count < 0) {
 		usage_with_options(stat_usage, options);
+	} else if (run_count == 0) {
+		forever = true;
+		run_count = 1;
+	}
 
 	/* no_aggr, cgroup are for system-wide only */
 	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
@@ -1413,21 +1439,30 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	 * task, but being ignored by perf stat itself:
 	 */
 	atexit(sig_atexit);
-	signal(SIGINT,  skip_signal);
+	if (!forever)
+		signal(SIGINT,  skip_signal);
 	signal(SIGCHLD, skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
 	status = 0;
-	for (run_idx = 0; run_idx < run_count; run_idx++) {
+	for (run_idx = 0; forever || run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
 		status = run_perf_stat(argc, argv);
+		if (forever && status != -1) {
+			print_stat(argc, argv);
+			list_for_each_entry(pos, &evsel_list->entries, node) {
+				perf_evsel__reset_stat_priv(pos);
+				perf_evsel__reset_counts(pos, perf_evsel__nr_cpus(pos));
+			}
+			reset_stats();
+		}
 	}
 
-	if (status != -1 && !interval)
+	if (!forever && status != -1 && !interval)
 		print_stat(argc, argv);
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list->entries, node) {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7fde9fb..1adb824 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -633,6 +633,12 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return 0;
 }
 
+void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus)
+{
+	memset(evsel->counts, 0, (sizeof(*evsel->counts) +
+				 (ncpus * sizeof(struct perf_counts_values))));
+}
+
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 {
 	evsel->counts = zalloc((sizeof(*evsel->counts) +
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index bf758e5..3f156cc 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -121,6 +121,7 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
+void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__free_counts(struct perf_evsel *evsel);
