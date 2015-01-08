Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbbAHAt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:49:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42500 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbAHAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:47:57 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/7] perf diff: Print diff result more precisely
Date: Thu,  8 Jan 2015 09:45:44 +0900
Message-Id: <1420677949-6719-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current perf diff result is somewhat confusing since it sometimes hide
small result and sometimes there's no result.  So do not hide small
result (less than 0.01%) and print "N/A" if baseline is not
recorded (for ratio and wdiff only).  Blank means the baseline is
available but its pairs are not.

Before:

  # Baseline    Delta  Shared Object      Symbol
  # ........  .......  .................  .........................
  #
       ...
       0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
       0.01%           [kernel.kallsyms]  [k] scheduler_tick
       0.01%           [kernel.kallsyms]  [k] native_read_msr_safe
       0.00%           [kernel.kallsyms]  [k] __rcu_read_unlock
                       [kernel.kallsyms]  [k] _raw_spin_lock
               +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
                       [kernel.kallsyms]  [k] read_tsc

After:

  # Baseline    Delta  Shared Object      Symbol
  # ........  .......  .................  .........................
  #
       ...
       0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
       0.01%           [kernel.kallsyms]  [k] scheduler_tick
       0.01%           [kernel.kallsyms]  [k] native_read_msr_safe
       0.00%           [kernel.kallsyms]  [k] __rcu_read_unlock
               +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock
               +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
               +0.01%  [kernel.kallsyms]  [k] read_tsc

Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 72c718e6549c..3f86737da2c4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -788,7 +788,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 	char pfmt[20] = " ";
 
 	if (!pair)
-		goto dummy_print;
+		goto no_print;
 
 	switch (comparison_method) {
 	case COMPUTE_DELTA:
@@ -797,8 +797,6 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		else
 			diff = compute_delta(he, pair);
 
-		if (fabs(diff) < 0.01)
-			goto dummy_print;
 		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
 		return percent_color_snprintf(hpp->buf, hpp->size,
 					pfmt, diff);
@@ -830,6 +828,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 	}
 dummy_print:
 	return scnprintf(hpp->buf, hpp->size, "%*s",
+			dfmt->header_width, "N/A");
+no_print:
+	return scnprintf(hpp->buf, hpp->size, "%*s",
 			dfmt->header_width, pfmt);
 }
 
@@ -879,14 +880,15 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		else
 			diff = compute_delta(he, pair);
 
-		if (fabs(diff) >= 0.01)
-			scnprintf(buf, size, "%+4.2F%%", diff);
+		scnprintf(buf, size, "%+4.2F%%", diff);
 		break;
 
 	case PERF_HPP_DIFF__RATIO:
 		/* No point for ratio number if we are dummy.. */
-		if (he->dummy)
+		if (he->dummy) {
+			scnprintf(buf, size, "N/A");
 			break;
+		}
 
 		if (pair->diff.computed)
 			ratio = pair->diff.period_ratio;
@@ -899,8 +901,10 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 
 	case PERF_HPP_DIFF__WEIGHTED_DIFF:
 		/* No point for wdiff number if we are dummy.. */
-		if (he->dummy)
+		if (he->dummy) {
+			scnprintf(buf, size, "N/A");
 			break;
+		}
 
 		if (pair->diff.computed)
 			wdiff = pair->diff.wdiff;
-- 
2.1.3

