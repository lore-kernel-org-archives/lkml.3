Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaEVMV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaEVMV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:26 -0400
Date: Thu, 22 May 2014 05:21:15 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-043ca389a3181565b5c19d43a55eae111977d13d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-6-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use hpp formats to sort final output
Git-Commit-ID: 043ca389a3181565b5c19d43a55eae111977d13d
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

Commit-ID:  043ca389a3181565b5c19d43a55eae111977d13d
Gitweb:     http://git.kernel.org/tip/043ca389a3181565b5c19d43a55eae111977d13d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 14:18:00 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:34 +0200

perf tools: Use hpp formats to sort final output

Convert output sorting function to use ->sort hpp functions.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-6-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 62 +++++++-------------------------------------------
 1 file changed, 8 insertions(+), 54 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 38373c9..c99ae4d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -564,64 +564,18 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	}
 }
 
-/*
- * reverse the map, sort on period.
- */
-
-static int period_cmp(u64 period_a, u64 period_b)
+static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
-	if (period_a > period_b)
-		return 1;
-	if (period_a < period_b)
-		return -1;
-	return 0;
-}
-
-static int hist_entry__sort_on_period(struct hist_entry *a,
-				      struct hist_entry *b)
-{
-	int ret;
-	int i, nr_members;
-	struct perf_evsel *evsel;
-	struct hist_entry *pair;
-	u64 *periods_a, *periods_b;
-
-	ret = period_cmp(a->stat.period, b->stat.period);
-	if (ret || !symbol_conf.event_group)
-		return ret;
-
-	evsel = hists_to_evsel(a->hists);
-	nr_members = evsel->nr_members;
-	if (nr_members <= 1)
-		return ret;
-
-	periods_a = zalloc(sizeof(periods_a) * nr_members);
-	periods_b = zalloc(sizeof(periods_b) * nr_members);
-
-	if (!periods_a || !periods_b)
-		goto out;
-
-	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
-		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
-	}
-
-	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
-		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
-	}
+	struct perf_hpp_fmt *fmt;
+	int64_t cmp = 0;
 
-	for (i = 1; i < nr_members; i++) {
-		ret = period_cmp(periods_a[i], periods_b[i]);
-		if (ret)
+	perf_hpp__for_each_format(fmt) {
+		cmp = fmt->sort(a, b);
+		if (cmp)
 			break;
 	}
 
-out:
-	free(periods_a);
-	free(periods_b);
-
-	return ret;
+	return cmp;
 }
 
 static void hists__reset_filter_stats(struct hists *hists)
@@ -669,7 +623,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (hist_entry__sort_on_period(he, iter) > 0)
+		if (hist_entry__sort(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
