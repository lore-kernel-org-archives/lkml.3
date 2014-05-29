Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaE2EE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:04:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53281 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaE2D6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:36 -0400
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
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 07/27] perf report: Cache cumulative callchains
Date: Thu, 29 May 2014 12:58:10 +0900
Message-Id: <1401335910-16832-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/hist.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 37c28fc13dc3..bf03db528db6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -700,7 +700,22 @@ static int
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
 
@@ -710,6 +725,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
 
@@ -720,6 +736,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 		return -ENOMEM;
 
 	iter->he = he;
+	he_cache[iter->curr++] = he;
 
 	/*
 	 * The iter->he will be over-written after ->add_next_entry()
@@ -754,7 +771,29 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -763,6 +802,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		return -ENOMEM;
 
 	iter->he = he;
+	he_cache[iter->curr++] = he;
 
 	return 0;
 }
@@ -771,7 +811,9 @@ static int
 iter_finish_cumulative_entry(struct hist_entry_iter *iter,
 			     struct addr_location *al __maybe_unused)
 {
+	zfree(&iter->priv);
 	iter->he = NULL;
+
 	return 0;
 }
 
-- 
1.9.2

