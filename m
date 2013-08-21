Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3HUXsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:48:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:25869 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3HUXrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="285074785"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] perf, tools: Add perf stat --transaction v5
Date: Wed, 21 Aug 2013 16:47:26 -0700
Message-Id: <1377128846-977-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377128846-977-1-git-send-email-andi@firstfloor.org>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to perf stat to print the basic transactional execution statistics:
Total cycles, Cycles in Transaction, Cycles in aborted transsactions
using the in_tx and in_tx_checkpoint qualifiers.
Transaction Starts and Elision Starts, to compute the average transaction
length.

This is a reasonable overview over the success of the transactions.

Also support architectures that have a transaction aborted cycles
counter like POWER8. Since that is awkward to handle in the kernel
abstract handle both cases here.

Enable with a new --transaction / -T option.

This requires measuring these events in a group, since they depend on each
other.

This is implemented by using TM sysfs events exported by the kernel

v2: Only print the extended statistics when the option is enabled.
This avoids negative output when the user specifies the -T events
in separate groups.
v3: Port to latest tree
v4: Remove merge error. Avoid linear walks for comparisons. Check
transaction_run earlier. Minor fixes.
v5: Move option to avoid conflict. Improve description.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-stat.txt |   5 ++
 tools/perf/builtin-stat.c              | 144 ++++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.h                |   6 ++
 tools/perf/util/pmu.c                  |  16 ++++
 tools/perf/util/pmu.h                  |   1 +
 5 files changed, 171 insertions(+), 1 deletion(-)

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
index 352fbd7..6bd90e4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -46,6 +46,7 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/pmu.h"
 #include "util/event.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
@@ -70,6 +71,41 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
 static void print_counter(struct perf_evsel *counter, char *prefix);
 static void print_aggr(char *prefix);
 
+/* Default events used for perf stat -T */
+static const char * const transaction_attrs[] = {
+	"task-clock",
+	"{"
+	"instructions,"
+	"cycles,"
+	"cpu/cycles-t/,"
+	"cpu/tx-start/,"
+	"cpu/el-start/,"
+	"cpu/cycles-ct/"
+	"}"
+};
+
+/* More limited version when the CPU does not have all events. */
+static const char * const transaction_limited_attrs[] = {
+	"task-clock",
+	"{"
+	"instructions,"
+	"cycles,"
+	"cpu/cycles-t/,"
+	"cpu/tx-start/"
+	"}"
+};
+
+/* must match transaction_attrs and the beginning limited_attrs */
+enum {
+	T_TASK_CLOCK,
+	T_INSTRUCTIONS,
+	T_CYCLES,
+	T_CYCLES_IN_TX,
+	T_TRANSACTION_START,
+	T_ELISION_START,
+	T_CYCLES_IN_TX_CP,
+};
+
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
@@ -90,6 +126,7 @@ static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
 static volatile pid_t		child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
+static bool			transaction_run;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
@@ -213,7 +250,10 @@ static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
 static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_in_tx_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
+static struct stats runtime_transaction_stats[MAX_NR_CPUS];
+static struct stats runtime_elision_stats[MAX_NR_CPUS];
 
 static void perf_stat__reset_stats(struct perf_evlist *evlist)
 {
@@ -235,6 +275,11 @@ static void perf_stat__reset_stats(struct perf_evlist *evlist)
 	memset(runtime_ll_cache_stats, 0, sizeof(runtime_ll_cache_stats));
 	memset(runtime_itlb_cache_stats, 0, sizeof(runtime_itlb_cache_stats));
 	memset(runtime_dtlb_cache_stats, 0, sizeof(runtime_dtlb_cache_stats));
+	memset(runtime_cycles_in_tx_stats, 0,
+			sizeof(runtime_cycles_in_tx_stats));
+	memset(runtime_transaction_stats, 0,
+		sizeof(runtime_transaction_stats));
+	memset(runtime_elision_stats, 0, sizeof(runtime_elision_stats));
 	memset(&walltime_nsecs_stats, 0, sizeof(walltime_nsecs_stats));
 }
 
@@ -272,6 +317,29 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 	return 0;
 }
 
+static struct perf_evsel *nth_evsel(int n)
+{
+	static struct perf_evsel **array;
+	static int array_len;
+	struct perf_evsel *ev;
+	int j;
+
+	/* Assumes this only called when evsel_list does not change anymore. */
+	if (!array) {
+		list_for_each_entry(ev, &evsel_list->entries, node)
+			array_len++;
+		array = malloc(array_len * sizeof(void *));
+		if (!array)
+			exit(ENOMEM);
+		j = 0;
+		list_for_each_entry(ev, &evsel_list->entries, node)
+			array[j++] = ev;
+	}
+	if (n < array_len)
+		return array[n];
+	return NULL;
+}
+
 /*
  * Update various tracking values we maintain to print
  * more semantic information such as miss/hit ratios,
@@ -283,6 +351,15 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
+	else if (transaction_run &&
+		 perf_evsel__cmp(counter, nth_evsel(T_CYCLES_IN_TX)))
+		update_stats(&runtime_cycles_in_tx_stats[0], count[0]);
+	else if (transaction_run &&
+		 perf_evsel__cmp(counter, nth_evsel(T_TRANSACTION_START)))
+		update_stats(&runtime_transaction_stats[0], count[0]);
+	else if (transaction_run &&
+		 perf_evsel__cmp(counter, nth_evsel(T_ELISION_START)))
+		update_stats(&runtime_elision_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
 		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
@@ -807,7 +884,7 @@ static void print_ll_cache_misses(int cpu,
 
 static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
-	double total, ratio = 0.0;
+	double total, ratio = 0.0, total2;
 	const char *fmt;
 
 	if (csv_output)
@@ -903,6 +980,43 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 			ratio = 1.0 * avg / total;
 
 		fprintf(output, " # %8.3f GHz                    ", ratio);
+	} else if (transaction_run &&
+		   perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX))) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% transactional cycles   ",
+				100.0 * (avg / total));
+	} else if (transaction_run &&
+		   perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX_CP))) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		total2 = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+		if (total2 < avg)
+			total2 = avg;
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% aborted cycles         ",
+				100.0 * ((total2-avg) / total));
+	} else if (transaction_run &&
+		   perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_in_tx_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / transaction   ", ratio);
+	} else if (transaction_run &&
+		   perf_evsel__cmp(evsel, nth_evsel(T_ELISION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_in_tx_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / elision       ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		char unit = 'M';
 
@@ -1216,6 +1330,16 @@ static int perf_stat_init_aggr_mode(void)
 	return 0;
 }
 
+static int setup_events(const char * const *attrs, unsigned len)
+{
+	unsigned i;
+
+	for (i = 0; i < len; i++) {
+		if (parse_events(evsel_list, attrs[i]))
+			return -1;
+	}
+	return 0;
+}
 
 /*
  * Add default attributes, if there were no attributes specified or
@@ -1334,6 +1458,22 @@ static int add_default_attributes(void)
 	if (null_run)
 		return 0;
 
+	if (transaction_run) {
+		int err;
+		if (pmu_have_event("cpu", "cycles-ct") &&
+		    pmu_have_event("cpu", "el-start"))
+			err = setup_events(transaction_attrs,
+					ARRAY_SIZE(transaction_attrs));
+		else
+			err = setup_events(transaction_limited_attrs,
+				 ARRAY_SIZE(transaction_limited_attrs));
+		if (err < 0) {
+			fprintf(stderr, "Cannot set up transaction events\n");
+			return -1;
+		}
+		return 0;
+	}
+
 	if (!evsel_list->nr_entries) {
 		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
@@ -1368,6 +1508,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	int output_fd = 0;
 	const char *output_name	= NULL;
 	const struct option options[] = {
+	OPT_BOOLEAN('T', "transaction", &transaction_run,
+		    "hardware transaction statistics"),
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
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
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bc9d806..64362fe 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -637,3 +637,19 @@ void print_pmu_events(const char *event_glob, bool name_only)
 		printf("\n");
 	free(aliases);
 }
+
+bool pmu_have_event(const char *pname, const char *name)
+{
+	struct perf_pmu *pmu;
+	struct perf_pmu_alias *alias;
+
+	pmu = NULL;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
+		if (strcmp(pname, pmu->name))
+			continue;
+		list_for_each_entry(alias, &pmu->aliases, list)
+			if (!strcmp(alias->name, name))
+				return true;
+	}
+	return false;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 6b2cbe2..1179b26 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -42,6 +42,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
 void print_pmu_events(const char *event_glob, bool name_only);
+bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.8.3.1

