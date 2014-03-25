Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaCYUI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:08:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:15293 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaCYUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="506581643"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        wcohen@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Fix metrics calculation with event qualifiers
Date: Tue, 25 Mar 2014 13:07:27 -0700
Message-Id: <1395778047-23111-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Currently in perf IPC and other metrics cannot be directly shown
separately for both user and kernel in a single run. The problem was
that the metrics matching code did not check event qualifiers.

With this patch the following case works correctly.

% perf stat -e cycles:k,cycles:u,instructions:k,instructions:u true

 Performance counter stats for 'true':

           531,718      cycles:k
           203,895      cycles:u
           338,151      instructions:k            #    0.64  insns per cycle
           105,961      instructions:u            #    0.52  insns per cycle

       0.002989739 seconds time elapsed

Previously it would misreport the ratios because they were matching
the wrong value.

The patch is fairly big, but quite mechanic as it just
adds context indexes everywhere.

I didn't support Hypervisor. It's not clear it's worth it.

Reported-by: William Cohen <wcohen@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c | 129 +++++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 52 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..57da752 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -239,21 +239,35 @@ out_free:
 	return -1;
 }
 
+#define NUM_CTX 3
+
+enum { CTX_USER, CTX_KERNEL, CTX_ALL };
+
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
-static struct stats runtime_cycles_stats[MAX_NR_CPUS];
-static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
-static struct stats runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
-static struct stats runtime_branches_stats[MAX_NR_CPUS];
-static struct stats runtime_cacherefs_stats[MAX_NR_CPUS];
-static struct stats runtime_l1_dcache_stats[MAX_NR_CPUS];
-static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
-static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
-static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
-static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
-static struct stats runtime_cycles_in_tx_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_stalled_cycles_front_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_stalled_cycles_back_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_branches_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_cacherefs_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_l1_dcache_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_l1_icache_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_ll_cache_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_itlb_cache_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_dtlb_cache_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_cycles_in_tx_stats[NUM_CTX][MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
-static struct stats runtime_transaction_stats[MAX_NR_CPUS];
-static struct stats runtime_elision_stats[MAX_NR_CPUS];
+static struct stats runtime_transaction_stats[NUM_CTX][MAX_NR_CPUS];
+static struct stats runtime_elision_stats[NUM_CTX][MAX_NR_CPUS];
+
+static int evsel_context(struct perf_evsel *evsel)
+{
+	if (evsel->attr.exclude_kernel)
+		return CTX_USER;
+	if (evsel->attr.exclude_user)
+		return CTX_KERNEL;
+	/* Handle hypervisor too? */
+	return CTX_ALL;
+}
 
 static void perf_stat__reset_stats(struct perf_evlist *evlist)
 {
@@ -347,37 +361,39 @@ static struct perf_evsel *nth_evsel(int n)
  */
 static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 {
+	int ctx = evsel_context(counter);
+
 	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-		update_stats(&runtime_cycles_stats[0], count[0]);
+		update_stats(&runtime_cycles_stats[ctx][0], count[0]);
 	else if (transaction_run &&
 		 perf_evsel__cmp(counter, nth_evsel(T_CYCLES_IN_TX)))
-		update_stats(&runtime_cycles_in_tx_stats[0], count[0]);
+		update_stats(&runtime_cycles_in_tx_stats[ctx][0], count[0]);
 	else if (transaction_run &&
 		 perf_evsel__cmp(counter, nth_evsel(T_TRANSACTION_START)))
-		update_stats(&runtime_transaction_stats[0], count[0]);
+		update_stats(&runtime_transaction_stats[ctx][0], count[0]);
 	else if (transaction_run &&
 		 perf_evsel__cmp(counter, nth_evsel(T_ELISION_START)))
-		update_stats(&runtime_elision_stats[0], count[0]);
+		update_stats(&runtime_elision_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
-		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
+		update_stats(&runtime_stalled_cycles_front_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
-		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
+		update_stats(&runtime_stalled_cycles_back_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
-		update_stats(&runtime_branches_stats[0], count[0]);
+		update_stats(&runtime_branches_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
-		update_stats(&runtime_cacherefs_stats[0], count[0]);
+		update_stats(&runtime_cacherefs_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1D))
-		update_stats(&runtime_l1_dcache_stats[0], count[0]);
+		update_stats(&runtime_l1_dcache_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1I))
-		update_stats(&runtime_l1_icache_stats[0], count[0]);
+		update_stats(&runtime_l1_icache_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_LL))
-		update_stats(&runtime_ll_cache_stats[0], count[0]);
+		update_stats(&runtime_ll_cache_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_DTLB))
-		update_stats(&runtime_dtlb_cache_stats[0], count[0]);
+		update_stats(&runtime_dtlb_cache_stats[ctx][0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_ITLB))
-		update_stats(&runtime_itlb_cache_stats[0], count[0]);
+		update_stats(&runtime_itlb_cache_stats[ctx][0], count[0]);
 }
 
 /*
@@ -794,8 +810,9 @@ static void print_stalled_cycles_frontend(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_cycles_stats[cpu]);
+	total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -813,8 +830,9 @@ static void print_stalled_cycles_backend(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_cycles_stats[cpu]);
+	total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -832,8 +850,9 @@ static void print_branch_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_branches_stats[cpu]);
+	total = avg_stats(&runtime_branches_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -851,8 +870,9 @@ static void print_l1_dcache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_l1_dcache_stats[cpu]);
+	total = avg_stats(&runtime_l1_dcache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -870,8 +890,9 @@ static void print_l1_icache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_l1_icache_stats[cpu]);
+	total = avg_stats(&runtime_l1_icache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -889,8 +910,9 @@ static void print_dtlb_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_dtlb_cache_stats[cpu]);
+	total = avg_stats(&runtime_dtlb_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -908,8 +930,9 @@ static void print_itlb_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_itlb_cache_stats[cpu]);
+	total = avg_stats(&runtime_itlb_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -927,8 +950,9 @@ static void print_ll_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_ll_cache_stats[cpu]);
+	total = avg_stats(&runtime_ll_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -945,6 +969,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	double total, ratio = 0.0, total2;
 	double sc =  evsel->scale;
 	const char *fmt;
+	int ctx = evsel_context(evsel);
 
 	if (csv_output) {
 		fmt = sc != 1.0 ?  "%.2f%s" : "%.0f%s";
@@ -976,13 +1001,13 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 		return;
 
 	if (perf_evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS)) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
+		total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 		if (total) {
 			ratio = avg / total;
 			fprintf(output, " #   %5.2f  insns per cycle        ", ratio);
 		}
-		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
-		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
+		total = avg_stats(&runtime_stalled_cycles_front_stats[ctx][cpu]);
+		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[ctx][cpu]));
 
 		if (total && avg) {
 			ratio = total / avg;
@@ -993,46 +1018,46 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 		}
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
-			runtime_branches_stats[cpu].n != 0) {
+			runtime_branches_stats[ctx][cpu].n != 0) {
 		print_branch_misses(cpu, evsel, avg);
 	} else if (
 		evsel->attr.type == PERF_TYPE_HW_CACHE &&
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1D |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_l1_dcache_stats[cpu].n != 0) {
+			runtime_l1_dcache_stats[ctx][cpu].n != 0) {
 		print_l1_dcache_misses(cpu, evsel, avg);
 	} else if (
 		evsel->attr.type == PERF_TYPE_HW_CACHE &&
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1I |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_l1_icache_stats[cpu].n != 0) {
+			runtime_l1_icache_stats[ctx][cpu].n != 0) {
 		print_l1_icache_misses(cpu, evsel, avg);
 	} else if (
 		evsel->attr.type == PERF_TYPE_HW_CACHE &&
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_DTLB |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_dtlb_cache_stats[cpu].n != 0) {
+			runtime_dtlb_cache_stats[ctx][cpu].n != 0) {
 		print_dtlb_cache_misses(cpu, evsel, avg);
 	} else if (
 		evsel->attr.type == PERF_TYPE_HW_CACHE &&
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_ITLB |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_itlb_cache_stats[cpu].n != 0) {
+			runtime_itlb_cache_stats[ctx][cpu].n != 0) {
 		print_itlb_cache_misses(cpu, evsel, avg);
 	} else if (
 		evsel->attr.type == PERF_TYPE_HW_CACHE &&
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_LL |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_ll_cache_stats[cpu].n != 0) {
+			runtime_ll_cache_stats[ctx][cpu].n != 0) {
 		print_ll_cache_misses(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
-			runtime_cacherefs_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_cacherefs_stats[cpu]);
+			runtime_cacherefs_stats[ctx][cpu].n != 0) {
+		total = avg_stats(&runtime_cacherefs_stats[ctx][cpu]);
 
 		if (total)
 			ratio = avg * 100 / total;
@@ -1052,15 +1077,15 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 		}
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX))) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
+		total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 		if (total)
 			fprintf(output,
 				" #   %5.2f%% transactional cycles   ",
 				100.0 * (avg / total));
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX_CP))) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
-		total2 = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+		total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
+		total2 = avg_stats(&runtime_cycles_in_tx_stats[ctx][cpu]);
 		if (total2 < avg)
 			total2 = avg;
 		if (total)
@@ -1070,8 +1095,8 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&
 		   avg > 0 &&
-		   runtime_cycles_in_tx_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+		   runtime_cycles_in_tx_stats[ctx][cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_in_tx_stats[ctx][cpu]);
 
 		if (total)
 			ratio = total / avg;
@@ -1080,8 +1105,8 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_ELISION_START)) &&
 		   avg > 0 &&
-		   runtime_cycles_in_tx_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+		   runtime_cycles_in_tx_stats[ctx][cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_in_tx_stats[ctx][cpu]);
 
 		if (total)
 			ratio = total / avg;
-- 
1.8.5.3

