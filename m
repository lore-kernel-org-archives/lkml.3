Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaEWKJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:09:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49034 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaEWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:35 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 06/26] perf report: Cache cumulative callchains
Date: Fri, 23 May 2014 19:04:03 +0900
Message-Id: <1400839463-21933-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possble that a callchain has cycles or recursive calls.  In that
case it'll end up having entries more than 100% overhead in the
output.  In order to prevent such entries, cache each callchain node
and skip if same entry already cumulated.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 802af8495f83..b3faabf3d2c2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -704,7 +704,22 @@ static int
 iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
 			      struct addr_location *al __maybe_unused)
 {
+	struct hist_entry **he_cache;
+
 	callchain_cursor_commit(&callchain_cursor);
+
+	/*
+	 * This is for detecting cycles or recursions so that they're
+	 * cumulated only one time to prevent entries more than 100%
+	 * overhead.
+	 */
+	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
+	if (he_cache == NULL)
+		return -ENOMEM;
+
+	iter->priv = he_cache;
+	iter->curr = 0;
+
 	return 0;
 }
 
@@ -714,6 +729,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
@@ -723,6 +739,8 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 		return -ENOMEM;
 
 	iter->he = he;
+	he_cache[iter->curr++] = he;
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
@@ -747,7 +765,29 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
+	struct hist_entry he_tmp = {
+		.cpu = al->cpu,
+		.thread = al->thread,
+		.comm = thread__comm(al->thread),
+		.ip = al->addr,
+		.ms = {
+			.map = al->map,
+			.sym = al->sym,
+		},
+		.parent = iter->parent,
+	};
+	int i;
+
+	/*
+	 * Check if there's duplicate entries in the callchain.
+	 * It's possible that it has cycles or recursive calls.
+	 */
+	for (i = 0; i < iter->curr; i++) {
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
+			return 0;
+	}
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
@@ -755,6 +795,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	he_cache[iter->curr++] = he;
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
@@ -765,6 +807,8 @@ iter_finish_cumulative_entry(struct hist_entry_iter *iter,
 	struct perf_evsel *evsel = iter->evsel;
 	struct hist_entry *he = iter->he;
 
+	zfree(&iter->priv);
+
 	if (he == NULL)
 		return 0;
 
-- 
1.9.2

