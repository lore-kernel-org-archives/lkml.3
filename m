Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbbAZRvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:51:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:53062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbbAZRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Kan Liang <kan.liang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/26] perf diff: Fix output ordering to honor next column
Date: Mon, 26 Jan 2015 14:47:20 -0300
Message-Id: <1422294449-12735-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf diff prints output, it sorts the entries using baseline field
by default, but entries which don't have baseline are not sorted
properly.  This patch makes it sorted by values of next column.

Before:

  # Baseline/0  Delta/1  Delta/2  Shared Object      Symbol
  # ..........  .......  .......  .................  ..........................................
  #
        32.75%   +0.28%   -0.83%  libc-2.20.so       [.] malloc
        31.50%   -0.74%   -0.23%  libc-2.20.so       [.] _int_free
        22.98%   +0.51%   +0.52%  libc-2.20.so       [.] _int_malloc
         5.70%   +0.28%   +0.30%  libc-2.20.so       [.] free
         4.38%   -0.21%   +0.25%  a.out              [.] main
         1.32%   -0.15%   +0.05%  a.out              [.] free@plt
         1.31%   +0.03%   -0.06%  a.out              [.] malloc@plt
         0.01%   -0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
         0.01%                    [kernel.kallsyms]  [k] scheduler_tick
         0.01%            -0.00%  [kernel.kallsyms]  [k] native_read_msr_safe
                          +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
                 +0.01%   +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
                          +0.01%  [kernel.kallsyms]  [k] intel_pstate_timer_func
                 +0.01%           [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context.part.82
                 +0.01%           [kernel.kallsyms]  [k] read_tsc
                          +0.01%  [kernel.kallsyms]  [k] timekeeping_update.constprop.8

After:

  # Baseline/0  Delta/1  Delta/2  Shared Object      Symbol
  # ..........  .......  .......  .................  ..........................................
  #
        32.75%   +0.28%   -0.83%  libc-2.20.so       [.] malloc
        31.50%   -0.74%   -0.23%  libc-2.20.so       [.] _int_free
        22.98%   +0.51%   +0.52%  libc-2.20.so       [.] _int_malloc
         5.70%   +0.28%   +0.30%  libc-2.20.so       [.] free
         4.38%   -0.21%   +0.25%  a.out              [.] main
         1.32%   -0.15%   +0.05%  a.out              [.] free@plt
         1.31%   +0.03%   -0.06%  a.out              [.] malloc@plt
         0.01%   -0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
         0.01%                    [kernel.kallsyms]  [k] scheduler_tick
         0.01%            -0.00%  [kernel.kallsyms]  [k] native_read_msr_safe
                 +0.01%   +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
                 +0.01%           [kernel.kallsyms]  [k] read_tsc
                 +0.01%           [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context.part.82
                          +0.01%  [kernel.kallsyms]  [k] intel_pstate_timer_func
                          +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
                          +0.01%  [kernel.kallsyms]  [k] timekeeping_update.constprop.8

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420677949-6719-7-git-send-email-namhyung@kernel.org
[ Fixed up hist_entry__cmp_ method signatures, fallout from making previous cset buildable ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 65 +++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4816989a84b0..98444561d9b4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -456,26 +456,30 @@ static void hists__precompute(struct hists *hists)
 	next = rb_first(root);
 	while (next != NULL) {
 		struct hist_entry *he, *pair;
+		struct data__file *d;
+		int i;
 
 		he   = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&he->rb_node_in);
 
-		pair = get_pair_data(he, &data__files[sort_compute]);
-		if (!pair)
-			continue;
+		data__for_each_file_new(i, d) {
+			pair = get_pair_data(he, d);
+			if (!pair)
+				continue;
 
-		switch (compute) {
-		case COMPUTE_DELTA:
-			compute_delta(he, pair);
-			break;
-		case COMPUTE_RATIO:
-			compute_ratio(he, pair);
-			break;
-		case COMPUTE_WEIGHTED_DIFF:
-			compute_wdiff(he, pair);
-			break;
-		default:
-			BUG_ON(1);
+			switch (compute) {
+			case COMPUTE_DELTA:
+				compute_delta(he, pair);
+				break;
+			case COMPUTE_RATIO:
+				compute_ratio(he, pair);
+				break;
+			case COMPUTE_WEIGHTED_DIFF:
+				compute_wdiff(he, pair);
+				break;
+			default:
+				BUG_ON(1);
+			}
 		}
 	}
 }
@@ -525,7 +529,7 @@ __hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 
 static int64_t
 hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
-			int c)
+			int c, int sort_idx)
 {
 	bool pairs_left  = hist_entry__has_pairs(left);
 	bool pairs_right = hist_entry__has_pairs(right);
@@ -537,8 +541,8 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 	if (!pairs_left || !pairs_right)
 		return pairs_left ? -1 : 1;
 
-	p_left  = get_pair_data(left,  &data__files[sort_compute]);
-	p_right = get_pair_data(right, &data__files[sort_compute]);
+	p_left  = get_pair_data(left,  &data__files[sort_idx]);
+	p_right = get_pair_data(right, &data__files[sort_idx]);
 
 	if (!p_left && !p_right)
 		return 0;
@@ -565,33 +569,36 @@ static int64_t
 hist_entry__cmp_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 			 struct hist_entry *left, struct hist_entry *right)
 {
-	if (sort_compute)
-		return 0;
-
 	if (left->stat.period == right->stat.period)
 		return 0;
 	return left->stat.period > right->stat.period ? 1 : -1;
 }
 
 static int64_t
-hist_entry__cmp_delta(struct perf_hpp_fmt *fmt __maybe_unused,
+hist_entry__cmp_delta(struct perf_hpp_fmt *fmt,
 		      struct hist_entry *left, struct hist_entry *right)
 {
-	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA);
+	struct data__file *d = fmt_to_data_file(fmt);
+
+	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA, d->idx);
 }
 
 static int64_t
-hist_entry__cmp_ratio(struct perf_hpp_fmt *fmt __maybe_unused,
+hist_entry__cmp_ratio(struct perf_hpp_fmt *fmt,
 		      struct hist_entry *left, struct hist_entry *right)
 {
-	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO);
+	struct data__file *d = fmt_to_data_file(fmt);
+
+	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO, d->idx);
 }
 
 static int64_t
-hist_entry__cmp_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
+hist_entry__cmp_wdiff(struct perf_hpp_fmt *fmt,
 		      struct hist_entry *left, struct hist_entry *right)
 {
-	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
+	struct data__file *d = fmt_to_data_file(fmt);
+
+	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF, d->idx);
 }
 
 static void hists__process(struct hists *hists)
@@ -599,9 +606,7 @@ static void hists__process(struct hists *hists)
 	if (show_baseline_only)
 		hists__baseline_only(hists);
 
-	if (sort_compute)
-		hists__precompute(hists);
-
+	hists__precompute(hists);
 	hists__output_resort(hists, NULL);
 
 	hists__fprintf(hists, true, 0, 0, 0, stdout);
-- 
1.9.3

