Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbbALQsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:48:09 -0500
Received: from mail.kernel.org ([198.145.29.136]:36065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbbALQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:48:04 -0500
Date: Mon, 12 Jan 2015 13:39:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Pass struct perf_hpp_fmt to its callbacks
Message-ID: <20150112163916.GA29743@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
 <1420677949-6719-6-git-send-email-namhyung@kernel.org>
 <20150112162140.GK12406@kernel.org>
 <20150112162736.GL12406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150112162736.GL12406@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 12, 2015 at 01:27:36PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Jan 12, 2015 at 01:21:40PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Jan 08, 2015 at 09:45:46AM +0900, Namhyung Kim escreveu:
> > > Currently ->cmp, ->collapse and ->sort callbacks doesn't pass
> > > corresponding fmt.  But it'll be needed by upcoming changes in
> > > perf diff command.
> > > 
> > > Suggested-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > 
> >   CC       /tmp/build/perf/builtin-evlist.o
> > builtin-diff.c: In function ‘data__hpp_register’:
> > builtin-diff.c:1036:11: error: assignment from incompatible pointer type [-Werror]
> >   fmt->cmp    = hist_entry__cmp_nop;
> >            ^
> > builtin-diff.c:1037:16: error: assignment from incompatible pointer type [-Werror]
> >   fmt->collapse = hist_entry__cmp_nop;
> >                 ^
> > builtin-diff.c:1043:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_baseline;
> >              ^
> > builtin-diff.c:1047:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_delta;
> >              ^
> > builtin-diff.c:1051:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_ratio;
> >              ^
> > builtin-diff.c:1055:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_wdiff;
> >              ^
> > builtin-diff.c:1058:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_nop;
> >              ^
> > cc1: all warnings being treated as errors
> >   LINK     plugin_kvm.so
> > make[1]: *** [/tmp/build/perf/builtin-diff.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> >   LINK     plugin_mac80211.so
> 
> Am I missing something? Lemme continue trying applying the rest of the
> kit...

Ok, the fix came in the next patch in your kit, I fixed things up to
make it fully bisectable, this is how the next patch ended up:


commit 444002b1bb093419bfd383b20959ef6e9c0c7d3e
Author: Namhyung Kim <namhyung@kernel.org>
Date:   Thu Jan 8 09:45:47 2015 +0900

    perf diff: Fix output ordering to honor next column
    
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
