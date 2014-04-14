Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaDNOVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbaDNOST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/17] perf tools: Fix metrics calculation with event qualifiers
Date: Mon, 14 Apr 2014 16:17:38 +0200
Message-Id: <1397485061-17215-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
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
Link: http://lkml.kernel.org/r/1395778047-23111-1-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-stat.c | 129 +++++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 52 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 65a151e..6687dab 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -246,21 +246,35 @@ out_free:
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
@@ -354,37 +368,39 @@ static struct perf_evsel *nth_evsel(int n)
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
@@ -801,8 +817,9 @@ static void print_stalled_cycles_frontend(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_cycles_stats[cpu]);
+	total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -820,8 +837,9 @@ static void print_stalled_cycles_backend(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_cycles_stats[cpu]);
+	total = avg_stats(&runtime_cycles_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -839,8 +857,9 @@ static void print_branch_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_branches_stats[cpu]);
+	total = avg_stats(&runtime_branches_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -858,8 +877,9 @@ static void print_l1_dcache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_l1_dcache_stats[cpu]);
+	total = avg_stats(&runtime_l1_dcache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -877,8 +897,9 @@ static void print_l1_icache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_l1_icache_stats[cpu]);
+	total = avg_stats(&runtime_l1_icache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -896,8 +917,9 @@ static void print_dtlb_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_dtlb_cache_stats[cpu]);
+	total = avg_stats(&runtime_dtlb_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -915,8 +937,9 @@ static void print_itlb_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_itlb_cache_stats[cpu]);
+	total = avg_stats(&runtime_itlb_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -934,8 +957,9 @@ static void print_ll_cache_misses(int cpu,
 {
 	double total, ratio = 0.0;
 	const char *color;
+	int ctx = evsel_context(evsel);
 
-	total = avg_stats(&runtime_ll_cache_stats[cpu]);
+	total = avg_stats(&runtime_ll_cache_stats[ctx][cpu]);
 
 	if (total)
 		ratio = avg / total * 100.0;
@@ -952,6 +976,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	double total, ratio = 0.0, total2;
 	double sc =  evsel->scale;
 	const char *fmt;
+	int ctx = evsel_context(evsel);
 
 	if (csv_output) {
 		fmt = sc != 1.0 ?  "%.2f%s" : "%.0f%s";
@@ -983,13 +1008,13 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
@@ -1000,46 +1025,46 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
@@ -1059,15 +1084,15 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
@@ -1077,8 +1102,8 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&
 		   avg > 0 &&
-		   runtime_cycles_in_tx_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
+		   runtime_cycles_in_tx_stats[ctx][cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_in_tx_stats[ctx][cpu]);
 
 		if (total)
 			ratio = total / avg;
@@ -1087,8 +1112,8 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
1.8.3.1

