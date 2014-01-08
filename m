Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaAHIrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:47:51 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48017 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaAHIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:46 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-0e-52cd106eb6e8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 10/28] perf report: Cache cumulative callchains
Date: Wed,  8 Jan 2014 17:46:15 +0900
Message-Id: <1389170793-21926-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possble that a callchain has cycles or recursive calls.  In that
case it'll end up having entries more than 100% overhead in the
output.  In order to prevent such entries, cache each callchain node
and skip if same entry already cumulated.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 54 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 06330736485b..087d01cac1aa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -363,7 +363,27 @@ static int
 iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
 			      struct addr_location *al __maybe_unused)
 {
+	struct callchain_cursor_node *node;
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
+	node = callchain_cursor_current(&callchain_cursor);
+	if (node == NULL)
+		return 0;
+
 	return 0;
 }
 
@@ -373,6 +393,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
@@ -381,6 +402,8 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	he_cache[iter->curr++] = he;
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
@@ -408,8 +431,8 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 			goto out;
 	}
 
-	if (al->map->groups == &iter->machine->kmaps) {
-		if (machine__is_host(iter->machine)) {
+	if (al->map->groups == &al->machine->kmaps) {
+		if (machine__is_host(al->machine)) {
 			al->cpumode = PERF_RECORD_MISC_KERNEL;
 			al->level = 'k';
 		} else {
@@ -417,7 +440,7 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 			al->level = 'g';
 		}
 	} else {
-		if (machine__is_host(iter->machine)) {
+		if (machine__is_host(al->machine)) {
 			al->cpumode = PERF_RECORD_MISC_USER;
 			al->level = '.';
 		} else if (perf_guest) {
@@ -440,7 +463,29 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -448,6 +493,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	he_cache[iter->curr++] = he;
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
@@ -461,6 +508,7 @@ iter_finish_cumulative_entry(struct hist_entry_iter *iter,
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
+	zfree(&iter->priv);
 	return 0;
 }
 
-- 
1.7.11.7

