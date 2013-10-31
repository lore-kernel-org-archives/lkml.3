Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3JaG41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42171 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3JaG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:24 -0400
X-AuditID: 9c930197-b7b3eae00000122e-db-5271ff154147
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 08/14] perf report: Cache cumulative callchains
Date: Thu, 31 Oct 2013 15:56:10 +0900
Message-Id: <1383202576-28141-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c | 49 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1b152a8b7f51..1a0de9a4a568 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -387,6 +387,11 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
 	return err;
 }
 
+struct cumulative_cache {
+	struct dso *dso;
+	struct symbol *sym;
+};
+
 static int
 iter_prepare_cumulative_entry(struct add_entry_iter *iter,
 			      struct machine *machine,
@@ -394,9 +399,31 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
 			      struct addr_location *al __maybe_unused,
 			      struct perf_sample *sample)
 {
+	struct callchain_cursor_node *node;
+	struct cumulative_cache *ccache;
+
 	callchain_cursor_commit(&callchain_cursor);
 
 	/*
+	 * This is for detecting cycles or recursions so that they're
+	 * cumulated only one time to prevent entries more than 100%
+	 * overhead.
+	 */
+	ccache = malloc(sizeof(*ccache) * PERF_MAX_STACK_DEPTH);
+	if (ccache == NULL)
+		return -ENOMEM;
+
+	node = callchain_cursor_current(&callchain_cursor);
+	if (node == NULL)
+		return 0;
+
+	ccache[0].dso = node->map->dso;
+	ccache[0].sym = node->sym;
+
+	iter->priv = ccache;
+	iter->curr = 1;
+
+	/*
 	 * The first callchain node always contains same information
 	 * as a hist entry itself.  So skip it in order to prevent
 	 * double accounting.
@@ -501,8 +528,29 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct cumulative_cache *ccache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
+	int i;
+
+	/*
+	 * Check if there's duplicate entries in the callchain.
+	 * It's possible that it has cycles or recursive calls.
+	 */
+	for (i = 0; i < iter->curr; i++) {
+		if (sort__has_sym) {
+			if (ccache[i].sym == al->sym)
+				return 0;
+		} else {
+			/* Not much we can do - just compare the dso. */
+			if (ccache[i].dso == al->map->dso)
+				return 0;
+		}
+	}
+
+	ccache[i].dso = al->map->dso;
+	ccache[i].sym = al->sym;
+	iter->curr++;
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
@@ -538,6 +586,7 @@ iter_finish_cumulative_entry(struct add_entry_iter *iter,
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 
+	free(iter->priv);
 	return 0;
 }
 
-- 
1.7.11.7

