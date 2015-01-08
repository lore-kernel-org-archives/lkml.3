Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbbAHArz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:47:55 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42444 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbAHArx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:47:53 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH 7/7] perf diff: Fix -o/--order option behavior
Date: Thu,  8 Jan 2015 09:45:48 +0900
Message-Id: <1420677949-6719-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-diff.c | 101 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 98444561d9b4..74aada554b12 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -558,6 +558,37 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
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
 hist_entry__cmp_nop(struct perf_hpp_fmt *fmt __maybe_unused,
 		    struct hist_entry *left __maybe_unused,
 		    struct hist_entry *right __maybe_unused)
@@ -601,6 +632,30 @@ hist_entry__cmp_wdiff(struct perf_hpp_fmt *fmt,
 	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF, d->idx);
 }
 
+static int64_t
+hist_entry__cmp_delta_idx(struct perf_hpp_fmt *fmt __maybe_unused,
+			  struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_DELTA,
+					   sort_compute);
+}
+
+static int64_t
+hist_entry__cmp_ratio_idx(struct perf_hpp_fmt *fmt __maybe_unused,
+			  struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_RATIO,
+					   sort_compute);
+}
+
+static int64_t
+hist_entry__cmp_wdiff_idx(struct perf_hpp_fmt *fmt __maybe_unused,
+			  struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute_idx(right, left, COMPUTE_WEIGHTED_DIFF,
+					   sort_compute);
+}
+
 static void hists__process(struct hists *hists)
 {
 	if (show_baseline_only)
@@ -1074,9 +1129,10 @@ static void data__hpp_register(struct data__file *d, int idx)
 	perf_hpp__register_sort_field(fmt);
 }
 
-static void ui_init(void)
+static int ui_init(void)
 {
 	struct data__file *d;
+	struct perf_hpp_fmt *fmt;
 	int i;
 
 	data__for_each_file(i, d) {
@@ -1106,6 +1162,46 @@ static void ui_init(void)
 			data__hpp_register(d, i ? PERF_HPP_DIFF__PERIOD :
 						  PERF_HPP_DIFF__PERIOD_BASELINE);
 	}
+
+	if (!sort_compute)
+		return 0;
+
+	/*
+	 * Prepend an fmt to sort on columns at 'sort_compute' first.
+	 * This fmt is added only to the sort list but not to the
+	 * output fields list.
+	 *
+	 * Note that this column (data) can be compared twice - one
+	 * for this 'sort_compute' fmt and another for the normal
+	 * diff_hpp_fmt.  But it shouldn't a problem as most entries
+	 * will be sorted out by first try or baseline and comparing
+	 * is not a costly operation.
+	 */
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
@@ -1171,7 +1267,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (data_init(argc, argv) < 0)
 		return -1;
 
-	ui_init();
+	if (ui_init() < 0)
+		return -1;
 
 	sort__mode = SORT_MODE__DIFF;
 
-- 
2.1.3

