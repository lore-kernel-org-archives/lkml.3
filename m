Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaCDCpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:45:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56433 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbaCDCmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:20 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 05/10] perf tools: Use hpp formats to sort final output
Date: Tue,  4 Mar 2014 11:42:11 +0900
Message-Id: <1393900936-22977-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert output sorting function to use ->sort hpp functions.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 62 +++++++-------------------------------------------
 1 file changed, 8 insertions(+), 54 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0d8f2ec6f94d..0a351f37223f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -569,64 +569,18 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
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
 
 static void __hists__insert_output_entry(struct rb_root *entries,
@@ -645,7 +599,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (hist_entry__sort_on_period(he, iter) > 0)
+		if (hist_entry__sort(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-- 
1.7.11.7

