Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaL0FHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:07:11 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62441 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaL0FG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:06:57 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/5] perf diff: Fix -o/--order option behavior
Date: Sat, 27 Dec 2014 14:06:33 +0900
Message-Id: <1419656793-32756-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prior change fixes default output ordering with each column but it
breaks -o/--order option.  This patch prepends a new hpp fmt struct to
sort list but not to output field list so that it can affect ordering
without adding a new output column.

The new hpp fmt uses its own compare functions which treats dummy
entries (which have no baseline) little differently - the delta field
can be computed without baseline but others (ratio and wdiff) are not.

The new output will look like below:

  $ perf diff -o 2 perf.data.{old,cur,new}
  ...
  # Baseline/0  Delta/1  Delta/2  Shared Object      Symbol
  # ..........  .......  .......  .................  ..........................................
        22.98%   +0.51%   +0.52%  libc-2.20.so       [.] _int_malloc
         5.70%   +0.28%   +0.30%  libc-2.20.so       [.] free
         4.38%   -0.21%   +0.25%  a.out              [.] main
         1.32%   -0.15%   +0.05%  a.out              [.] free@plt
                          +0.01%  [kernel.kallsyms]  [k] intel_pstate_timer_func
                          +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
                          +0.01%  [kernel.kallsyms]  [k] timekeeping_update.constprop.8
                 +0.01%   +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
         0.01%            -0.00%  [kernel.kallsyms]  [k] native_read_msr_safe
         0.01%   -0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
         1.31%   +0.03%   -0.06%  a.out              [.] malloc@plt
        31.50%   -0.74%   -0.23%  libc-2.20.so       [.] _int_free
        32.75%   +0.28%   -0.83%  libc-2.20.so       [.] malloc
         0.01%                    [kernel.kallsyms]  [k] scheduler_tick
                 +0.01%           [kernel.kallsyms]  [k] read_tsc
                 +0.01%           [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context.part.82

In above example, the output was sorted by 'Delta/2' column first, and
then 'Baseline/0' and finally 'Delta/1'.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 87 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f490e24e9477..8ccb48e77eab 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -551,6 +551,37 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 }
 
 static int64_t
+hist_entry__cmp_compute_idx(struct hist_entry *left, struct hist_entry *right,
+			    int c, int sort_idx)
+{
+	struct hist_entry *p_right, *p_left;
+
+	p_left  = get_pair_data(left,  &data__files[sort_idx]);
+	p_right = get_pair_data(right, &data__files[sort_idx]);
+
+	if (!p_left && !p_right)
+		return 0;
+
+	if (!p_left || !p_right)
+		return p_left ? -1 : 1;
+
+	if (c != COMPUTE_DELTA) {
+		/*
+		 * The delta can be computed without the baseline, but
+		 * others are not.  Put those entries which have no
+		 * values below.
+		 */
+		if (left->dummy && right->dummy)
+			return 0;
+
+		if (left->dummy || right->dummy)
+			return left->dummy ? 1 : -1;
+	}
+
+	return __hist_entry__cmp_compute(p_left, p_right, c);
+}
+
+static int64_t
 hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
 		    struct hist_entry *right __maybe_unused)
 {
@@ -591,6 +622,27 @@ hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
 	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF, ++data_idx);
 }
 
+static int64_t
+hist_entry__cmp_delta_idx(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_DELTA,
+					   sort_compute);
+}
+
+static int64_t
+hist_entry__cmp_ratio_idx(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_RATIO,
+					   sort_compute);
+}
+
+static int64_t
+hist_entry__cmp_wdiff_idx(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_WEIGHTED_DIFF,
+					   sort_compute);
+}
+
 static void hists__process(struct hists *hists)
 {
 	if (show_baseline_only)
@@ -1064,9 +1116,10 @@ static void data__hpp_register(struct data__file *d, int idx)
 	perf_hpp__register_sort_field(fmt);
 }
 
-static void ui_init(void)
+static int ui_init(void)
 {
 	struct data__file *d;
+	struct perf_hpp_fmt *fmt;
 	int i;
 
 	data__for_each_file(i, d) {
@@ -1096,6 +1149,35 @@ static void ui_init(void)
 			data__hpp_register(d, i ? PERF_HPP_DIFF__PERIOD :
 						  PERF_HPP_DIFF__PERIOD_BASELINE);
 	}
+
+	if (!sort_compute)
+		return 0;
+
+	fmt = zalloc(sizeof(*fmt));
+	if (fmt == NULL) {
+		pr_err("Memory allocation failed\n");
+		return -1;
+	}
+
+	fmt->cmp      = hist_entry__cmp_nop;
+	fmt->collapse = hist_entry__cmp_nop;
+
+	switch (compute) {
+	case COMPUTE_DELTA:
+		fmt->sort = hist_entry__cmp_delta_idx;
+		break;
+	case COMPUTE_RATIO:
+		fmt->sort = hist_entry__cmp_ratio_idx;
+		break;
+	case COMPUTE_WEIGHTED_DIFF:
+		fmt->sort = hist_entry__cmp_wdiff_idx;
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	list_add(&fmt->sort_list, &perf_hpp__sort_list);
+	return 0;
 }
 
 static int data_init(int argc, const char **argv)
@@ -1161,7 +1243,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (data_init(argc, argv) < 0)
 		return -1;
 
-	ui_init();
+	if (ui_init() < 0)
+		return -1;
 
 	sort__mode = SORT_MODE__DIFF;
 
-- 
2.2.1

