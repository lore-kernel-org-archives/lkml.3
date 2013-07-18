Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab3GRTxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:53:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497Ab3GRTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 54/76] perf diff: Switching the base hists to be pairs head
Date: Thu, 18 Jul 2013 16:49:41 -0300
Message-Id: <1374177003-3706-55-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Making the baseline hists to act as a pairs head.

So far we don't care which hists act as a pairs head, because we have
only 2 files to deal with and any of them is suitable to do the job.

But if we want to process more files, we need to pick up one hists to
act as pairs head, and the baseline hists is the most suitable.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-cklmt2o4j87i9viz900245ae@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 60 +++++++++++++++++++++++------------------------
 tools/perf/ui/hist.c      | 25 ++++----------------
 2 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 015ca2d..0cfe99e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -167,34 +167,34 @@ double perf_diff__period_percent(struct hist_entry *he, u64 period)
 
 double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
-	double new_percent = perf_diff__period_percent(he, he->stat.period);
-	double old_percent = perf_diff__period_percent(pair, pair->stat.period);
+	double old_percent = perf_diff__period_percent(he, he->stat.period);
+	double new_percent = perf_diff__period_percent(pair, pair->stat.period);
 
-	he->diff.period_ratio_delta = new_percent - old_percent;
-	he->diff.computed = true;
-	return he->diff.period_ratio_delta;
+	pair->diff.period_ratio_delta = new_percent - old_percent;
+	pair->diff.computed = true;
+	return pair->diff.period_ratio_delta;
 }
 
 double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
-	double new_period = he->stat.period;
-	double old_period = pair->stat.period;
+	double old_period = he->stat.period ?: 1;
+	double new_period = pair->stat.period;
 
-	he->diff.computed = true;
-	he->diff.period_ratio = new_period / old_period;
-	return he->diff.period_ratio;
+	pair->diff.computed = true;
+	pair->diff.period_ratio = new_period / old_period;
+	return pair->diff.period_ratio;
 }
 
 s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
-	u64 new_period = he->stat.period;
-	u64 old_period = pair->stat.period;
+	u64 old_period = he->stat.period;
+	u64 new_period = pair->stat.period;
 
-	he->diff.computed = true;
-	he->diff.wdiff = new_period * compute_wdiff_w2 -
-			 old_period * compute_wdiff_w1;
+	pair->diff.computed = true;
+	pair->diff.wdiff = new_period * compute_wdiff_w2 -
+			   old_period * compute_wdiff_w1;
 
-	return he->diff.wdiff;
+	return pair->diff.wdiff;
 }
 
 static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
@@ -203,15 +203,15 @@ static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
-			  he->stat.period, he->hists->stats.total_period,
-			  pair->stat.period, pair->hists->stats.total_period);
+			  pair->stat.period, pair->hists->stats.total_period,
+			  he->stat.period, he->hists->stats.total_period);
 }
 
 static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
 			 char *buf, size_t size)
 {
-	double new_period = he->stat.period;
-	double old_period = pair->stat.period;
+	double old_period = he->stat.period;
+	double new_period = pair->stat.period;
 
 	return scnprintf(buf, size, "%.0F / %.0F", new_period, old_period);
 }
@@ -219,8 +219,8 @@ static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
 static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
 			 char *buf, size_t size)
 {
-	u64 new_period = he->stat.period;
-	u64 old_period = pair->stat.period;
+	u64 old_period = he->stat.period;
+	u64 new_period = pair->stat.period;
 
 	return scnprintf(buf, size,
 		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
@@ -462,23 +462,23 @@ static void hists__compute_resort(struct hists *hists)
 	}
 }
 
-static void hists__process(struct hists *old, struct hists *new)
+static void hists__process(struct hists *base, struct hists *new)
 {
-	hists__match(new, old);
+	hists__match(base, new);
 
 	if (show_baseline_only)
-		hists__baseline_only(new);
+		hists__baseline_only(base);
 	else
-		hists__link(new, old);
+		hists__link(base, new);
 
 	if (sort_compute) {
-		hists__precompute(new);
-		hists__compute_resort(new);
+		hists__precompute(base);
+		hists__compute_resort(base);
 	} else {
-		hists__output_resort(new);
+		hists__output_resort(base);
 	}
 
-	hists__fprintf(new, true, 0, 0, 0, stdout);
+	hists__fprintf(base, true, 0, 0, 0, stdout);
 }
 
 static void data_process(void)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index f45c97f..02313a9 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -178,18 +178,8 @@ static int hpp__width_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 
 static double baseline_percent(struct hist_entry *he)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	struct hists *pair_hists = pair ? pair->hists : NULL;
-	double percent = 0.0;
-
-	if (pair) {
-		u64 total_period = pair_hists->stats.total_period;
-		u64 base_period  = pair->stat.period;
-
-		percent = 100.0 * base_period / total_period;
-	}
-
-	return percent;
+	struct hists *hists = he->hists;
+	return 100.0 * he->stat.period / hists->stats.total_period;
 }
 
 static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
@@ -197,10 +187,8 @@ static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 {
 	double percent = baseline_percent(he);
 
-	if (hist_entry__has_pairs(he) || symbol_conf.field_sep)
-		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
-	else
-		return scnprintf(hpp->buf, hpp->size, "        ");
+	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%",
+				      percent);
 }
 
 static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
@@ -209,10 +197,7 @@ static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	if (hist_entry__has_pairs(he) || symbol_conf.field_sep)
-		return scnprintf(hpp->buf, hpp->size, fmt, percent);
-	else
-		return scnprintf(hpp->buf, hpp->size, "            ");
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
 static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
-- 
1.8.1.4

