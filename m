Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbbA1UuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934465AbbA1Uty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:54 -0500
Date: Wed, 28 Jan 2015 07:07:10 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ec3d07cb630da5da3ccfdf2b2f5472cadedb9470@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, jolsa@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de,
        jolsa@redhat.com, namhyung@kernel.org, hpa@zytor.com
Reply-To: mingo@kernel.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, tglx@linutronix.de, namhyung@kernel.org,
        hpa@zytor.com, a.p.zijlstra@chello.nl, jolsa@kernel.org
In-Reply-To: <1419656793-32756-3-git-send-email-namhyung@kernel.org>
References: <1419656793-32756-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Print diff result more precisely
Git-Commit-ID: ec3d07cb630da5da3ccfdf2b2f5472cadedb9470
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec3d07cb630da5da3ccfdf2b2f5472cadedb9470
Gitweb:     http://git.kernel.org/tip/ec3d07cb630da5da3ccfdf2b2f5472cadedb9470
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 27 Dec 2014 14:06:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:34 -0300

perf diff: Print diff result more precisely

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1419656793-32756-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 72c718e..3f86737 100644
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
