Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3LXIWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:22:38 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50238 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3LXIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:22:33 -0500
X-AuditID: 9c930179-b7c89ae000006438-e9-52b94446d83c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 05/21] perf hists: Accumulate hist entry stat based on the callchain
Date: Tue, 24 Dec 2013 17:22:11 +0900
Message-Id: <1387873347-28838-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Call __hists__add_entry() for each callchain node to get an
accumulated stat for an entry.  Introduce new cumulative_iter ops to
process them properly.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 103 +++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/stdio/hist.c  |   2 +-
 2 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 29fe19071d24..4fde0ab82498 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -360,6 +360,97 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
 	return hist_entry__append_callchain(he, sample);
 }
 
+static int
+iter_prepare_cumulative_entry(struct add_entry_iter *iter,
+			      struct machine *machine __maybe_unused,
+			      struct perf_evsel *evsel,
+			      struct addr_location *al __maybe_unused,
+			      struct perf_sample *sample)
+{
+	callchain_cursor_commit(&callchain_cursor);
+
+	iter->evsel = evsel;
+	iter->sample = sample;
+	return 0;
+}
+
+static int
+iter_add_single_cumulative_entry(struct add_entry_iter *iter,
+				 struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	/*
+	 * This is for putting parents upward during output resort iff
+	 * only a child gets sampled.  See hist_entry__sort_on_period().
+	 */
+	he->callchain->max_depth = PERF_MAX_STACK_DEPTH + 1;
+
+	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+}
+
+static int
+iter_next_cumulative_entry(struct add_entry_iter *iter,
+			   struct addr_location *al)
+{
+	struct callchain_cursor_node *node;
+
+	node = callchain_cursor_current(&callchain_cursor);
+	if (node == NULL)
+		return 0;
+
+	al->map = node->map;
+	al->sym = node->sym;
+	if (node->map)
+		al->addr = node->map->map_ip(node->map, node->ip);
+	else
+		al->addr = node->ip;
+
+	if (iter->rep->hide_unresolved && al->sym == NULL)
+		return 0;
+
+	callchain_cursor_advance(&callchain_cursor);
+	return 1;
+}
+
+static int
+iter_add_next_cumulative_entry(struct add_entry_iter *iter,
+			       struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, false);
+	if (he == NULL)
+		return -ENOMEM;
+
+	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+}
+
+static int
+iter_finish_cumulative_entry(struct add_entry_iter *iter,
+			     struct addr_location *al __maybe_unused)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	return 0;
+}
+
 static struct add_entry_iter mem_iter = {
 	.prepare_entry 		= iter_prepare_mem_entry,
 	.add_single_entry 	= iter_add_single_mem_entry,
@@ -384,6 +475,14 @@ static struct add_entry_iter normal_iter = {
 	.finish_entry 		= iter_finish_normal_entry,
 };
 
+static struct add_entry_iter cumulative_iter = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
 static int
 perf_evsel__add_entry(struct perf_evsel *evsel, struct addr_location *al,
 		      struct perf_sample *sample, struct machine *machine,
@@ -446,7 +545,9 @@ static int process_sample_event(struct perf_tool *tool,
 	else if (rep->mem_mode == 1) {
 		iter = &mem_iter;
 		iter->priv = event;
-	} else
+	} else if (symbol_conf.cumulate_callchain)
+		iter = &cumulative_iter;
+	else
 		iter = &normal_iter;
 
 	if (al.map != NULL)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index c244cb524ef2..4c4986e809d8 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -364,7 +364,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 
 	ret = fprintf(fp, "%s\n", bf);
 
-	if (symbol_conf.use_callchain)
+	if (symbol_conf.use_callchain && !symbol_conf.cumulate_callchain)
 		ret += hist_entry__callchain_fprintf(he, hists, fp);
 
 	return ret;
-- 
1.7.11.7

