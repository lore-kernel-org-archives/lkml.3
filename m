Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3LRFVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:55 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54370 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LRFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:32 -0500
X-AuditID: 9c93017d-b7c5eae000004296-2c-52b130d98e88
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 10/18] perf report: Cache cumulative callchains
Date: Wed, 18 Dec 2013 14:21:18 +0900
Message-Id: <1387344086-12744-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It is possble that a callchain has cycles or recursive calls.  In that
case it'll end up having entries more than 100% overhead in the
output.  In order to prevent such entries, cache each callchain node
and skip if same entry already cumulated.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 48 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80c774615287..4ec1a090d1a3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -406,8 +406,27 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
 			      struct addr_location *al __maybe_unused,
 			      struct perf_sample *sample)
 {
+	struct callchain_cursor_node *node;
+	struct hist_entry **he_cache;
+
 	callchain_cursor_commit(&callchain_cursor);
 
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
 	iter->evsel = evsel;
 	iter->sample = sample;
 	iter->machine = machine;
@@ -420,6 +439,7 @@ iter_add_single_cumulative_entry(struct add_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
 
@@ -429,6 +449,8 @@ iter_add_single_cumulative_entry(struct add_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	he_cache[iter->curr++] = he;
+
 	/*
 	 * This is for putting parents upward during output resort iff
 	 * only a child gets sampled.  See hist_entry__sort_on_period().
@@ -510,8 +532,30 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
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
 	int err = 0;
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
@@ -519,6 +563,8 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	he_cache[iter->curr++] = he;
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
@@ -547,6 +593,8 @@ iter_finish_cumulative_entry(struct add_entry_iter *iter,
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
+	free(iter->priv);
+	iter->priv = NULL;
 	return 0;
 }
 
-- 
1.7.11.7

