Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab3GRTy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:54:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab3GRTua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 55/76] perf hists: Marking dummy hists entries
Date: Thu, 18 Jul 2013 16:49:42 -0300
Message-Id: <1374177003-3706-56-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

It does not make sense to make some computation (ratio, wdiff), when the
hist_entry is 'dummy' - added via hists__link.

Adding dummy field to struct hist_entry which indicates that it was
added by hists__link and avoiding some of the processing for such
entries.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-g8bxml0n0pnqsrpyd98p0ird@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c   | 21 ++++++++++++++-------
 tools/perf/util/hist.c |  1 +
 tools/perf/util/sort.h |  3 +++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 02313a9..a359b75 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -187,8 +187,11 @@ static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 {
 	double percent = baseline_percent(he);
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%",
-				      percent);
+	if (!he->dummy)
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					      " %6.2f%%", percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
 static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
@@ -197,7 +200,10 @@ static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	if (!he->dummy)
+		return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
 static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
@@ -251,8 +257,7 @@ static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
 			diff = he->diff.period_ratio_delta;
 		else
 			diff = perf_diff__compute_delta(he, pair);
-	} else
-		diff = perf_diff__period_percent(he, he->stat.period);
+	}
 
 	if (fabs(diff) >= 0.01)
 		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
@@ -282,7 +287,8 @@ static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
 	char buf[32] = " ";
 	double ratio = 0.0;
 
-	if (pair) {
+	/* No point for ratio number if we are dummy.. */
+	if (!he->dummy && pair) {
 		if (he->diff.computed)
 			ratio = he->diff.period_ratio;
 		else
@@ -317,7 +323,8 @@ static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
 	char buf[32] = " ";
 	s64 wdiff = 0;
 
-	if (pair) {
+	/* No point for wdiff number if we are dummy.. */
+	if (!he->dummy && pair) {
 		if (he->diff.computed)
 			wdiff = he->diff.wdiff;
 		else
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b11a6cf..a9dd1b9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -912,6 +912,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
 		hists__inc_nr_entries(hists, he);
+		he->dummy = true;
 	}
 out:
 	return he;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index a4a6d0b..586022d 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -89,6 +89,9 @@ struct hist_entry {
 
 	struct hist_entry_diff	diff;
 
+	/* We are added by hists__add_dummy_entry. */
+	bool			dummy;
+
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
 	u16			nr_rows;
-- 
1.8.1.4

