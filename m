Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3DTTT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:19:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:3592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab3DTTT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="321467968"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/15] perf, tools: Add perf stat --transaction v3
Date: Sat, 20 Apr 2013 12:19:23 -0700
Message-Id: <1366485563-16209-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to perf stat to print the basic transactional execution statistics:
Total cycles, Cycles in Transaction, Cycles in aborted transsactions
using the intx and intx_checkpoint qualifiers.
Transaction Starts and Elision Starts, to compute the average transaction length.

This is a reasonable overview over the success of the transactions.

Enable with a new --transaction / -T option.

This requires measuring these events in a group, since they depend on each
other.

This is implemented by using TM sysfs events exported by the kernel

v2: Only print the extended statistics when the option is enabled.
This avoids negative output when the user specifies the -T events
in separate groups.
v3: Port to latest tree
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-stat.txt |    5 ++
 tools/perf/builtin-stat.c              |  103 +++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.h                |    6 ++
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fe87fb..40bc65a 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -132,6 +132,11 @@ is a useful mode to detect imbalance between physical cores.  To enable this mod
 use --per-core in addition to -a. (system-wide).  The output includes the
 core number and the number of online logical processors on that physical processor.
 
+-T::
+--transaction::
+
+Print statistics of transactional execution if supported.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..5053c1a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -70,6 +70,30 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
 static void print_counter(struct perf_evsel *counter, char *prefix);
 static void print_aggr(char *prefix);
 
+/* Default events used for perf stat -T */
+static const char * const transaction_attrs[] = {
+	"task-clock",
+	"{"
+	"instructions,"
+	"cycles,"
+	"cpu/cycles-t/,"
+	"cpu/cycles-ct/,"
+	"cpu/tx-start/,"
+	"cpu/el-start/"
+	"}"
+};
+
+/* must match the transaction_attrs above */
+enum {
+	T_TASK_CLOCK,
+	T_INSTRUCTIONS,
+	T_CYCLES,
+	T_CYCLES_INTX,
+	T_CYCLES_INTX_CP,
+	T_TRANSACTION_START,
+	T_ELISION_START
+};
+
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
@@ -90,6 +114,7 @@ static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
+static bool			transaction_run;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
@@ -213,7 +238,11 @@ static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
 static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_intx_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_intxcp_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
+static struct stats runtime_transaction_stats[MAX_NR_CPUS];
+static struct stats runtime_elision_stats[MAX_NR_CPUS];
 
 static void perf_stat__reset_stats(struct perf_evlist *evlist)
 {
@@ -272,6 +301,18 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 	return 0;
 }
 
+static struct perf_evsel *nth_evsel(int n)
+{
+	struct perf_evsel *ev;
+	int j;
+
+	j = 0;
+	list_for_each_entry(ev, &evsel_list->entries, node)
+		if (j++ == n)
+			return ev;
+	return NULL;
+}
+
 /*
  * Update various tracking values we maintain to print
  * more semantic information such as miss/hit ratios,
@@ -283,8 +324,14 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
-		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_INTX)))
+		update_stats(&runtime_cycles_intx_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_INTX_CP)))
+		update_stats(&runtime_cycles_intxcp_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_TRANSACTION_START)))
+		update_stats(&runtime_transaction_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_ELISION_START)))
+		update_stats(&runtime_elision_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
 		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
@@ -807,7 +854,7 @@ static void print_ll_cache_misses(int cpu,
 
 static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
-	double total, ratio = 0.0;
+	double total, ratio = 0.0, total2;
 	const char *fmt;
 
 	if (csv_output)
@@ -903,6 +950,41 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 			ratio = 1.0 * avg / total;
 
 		fprintf(output, " # %8.3f GHz                    ", ratio);
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_INTX)) &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% transactional cycles   ",
+				100.0 * (avg / total));
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_INTX_CP)) &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		total2 = avg_stats(&runtime_cycles_intx_stats[cpu]);
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% aborted cycles         ",
+				100.0 * ((total2-avg) / total));
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0 &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / transaction ", ratio);
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_ELISION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0 &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / elision     ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		char unit = 'M';
 
@@ -1312,6 +1394,19 @@ static int add_default_attributes(void)
 	if (null_run)
 		return 0;
 
+	if (transaction_run) {
+		unsigned i;
+
+		for (i = 0; i < ARRAY_SIZE(transaction_attrs); i++) {
+			if (parse_events(evsel_list, transaction_attrs[i])) {
+				fprintf(stderr,
+					"Cannot set up transaction events\n");
+				return -1;
+			}
+		}
+		return 0;
+	}
+
 	if (!evsel_list->nr_entries) {
 		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
@@ -1397,6 +1492,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_SET_UINT(0, "per-core", &aggr_mode,
 		     "aggregate counts per physical processor core", AGGR_CORE),
+	OPT_BOOLEAN('T', "transaction", &transaction_run,
+		    "hardware transaction statistics"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f156cc..2f3dc86 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -180,6 +180,12 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
 	       (e1->attr.config == e2->attr.config);
 }
 
+#define perf_evsel__cmp(a, b)			\
+	((a) &&					\
+	 (b) &&					\
+	 (a)->attr.type == (b)->attr.type &&	\
+	 (a)->attr.config == (b)->attr.config)
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 
-- 
1.7.7.6

