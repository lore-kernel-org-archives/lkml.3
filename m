Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124Ab3GRTwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:52:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab3GRTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 61/76] perf diff: Making compute functions static
Date: Thu, 18 Jul 2013 16:49:48 -0300
Message-Id: <1374177003-3706-62-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

All compute functions are now local to the diff command, making them
static.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-mpmm8l71mnlp7139voba3aak@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 30 +++++++++++++++---------------
 tools/perf/util/hist.h    |  7 -------
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index cc7bf4f..f2fbf69 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -224,23 +224,23 @@ static int setup_compute(const struct option *opt, const char *str,
 	return -EINVAL;
 }
 
-double perf_diff__period_percent(struct hist_entry *he, u64 period)
+static double period_percent(struct hist_entry *he, u64 period)
 {
 	u64 total = he->hists->stats.total_period;
 	return (period * 100.0) / total;
 }
 
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
+static double compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
-	double old_percent = perf_diff__period_percent(he, he->stat.period);
-	double new_percent = perf_diff__period_percent(pair, pair->stat.period);
+	double old_percent = period_percent(he, he->stat.period);
+	double new_percent = period_percent(pair, pair->stat.period);
 
 	pair->diff.period_ratio_delta = new_percent - old_percent;
 	pair->diff.computed = true;
 	return pair->diff.period_ratio_delta;
 }
 
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
+static double compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
 	double old_period = he->stat.period ?: 1;
 	double new_period = pair->stat.period;
@@ -250,7 +250,7 @@ double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 	return pair->diff.period_ratio;
 }
 
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
+static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
 	u64 old_period = he->stat.period;
 	u64 new_period = pair->stat.period;
@@ -292,8 +292,8 @@ static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
 		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
 }
 
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size)
+static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
+			   char *buf, size_t size)
 {
 	switch (compute) {
 	case COMPUTE_DELTA:
@@ -421,13 +421,13 @@ static void hists__precompute(struct hists *hists)
 
 		switch (compute) {
 		case COMPUTE_DELTA:
-			perf_diff__compute_delta(he, pair);
+			compute_delta(he, pair);
 			break;
 		case COMPUTE_RATIO:
-			perf_diff__compute_ratio(he, pair);
+			compute_ratio(he, pair);
 			break;
 		case COMPUTE_WEIGHTED_DIFF:
-			perf_diff__compute_wdiff(he, pair);
+			compute_wdiff(he, pair);
 			break;
 		default:
 			BUG_ON(1);
@@ -744,7 +744,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			diff = pair->diff.period_ratio_delta;
 		else
-			diff = perf_diff__compute_delta(he, pair);
+			diff = compute_delta(he, pair);
 
 		if (fabs(diff) >= 0.01)
 			scnprintf(buf, size, "%+4.2F%%", diff);
@@ -758,7 +758,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			ratio = pair->diff.period_ratio;
 		else
-			ratio = perf_diff__compute_ratio(he, pair);
+			ratio = compute_ratio(he, pair);
 
 		if (ratio > 0.0)
 			scnprintf(buf, size, "%14.6F", ratio);
@@ -772,14 +772,14 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			wdiff = pair->diff.wdiff;
 		else
-			wdiff = perf_diff__compute_wdiff(he, pair);
+			wdiff = compute_wdiff(he, pair);
 
 		if (wdiff != 0)
 			scnprintf(buf, size, "%14ld", wdiff);
 		break;
 
 	case PERF_HPP_DIFF__FORMULA:
-		perf_diff__formula(he, pair, buf, size);
+		formula_fprintf(he, pair, buf, size);
 		break;
 
 	case PERF_HPP_DIFF__PERIOD:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 79681f6..bfcbb11 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -242,11 +242,4 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size);
-double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
-- 
1.8.1.4

