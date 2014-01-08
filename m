Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaAHIsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:48:23 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61879 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbaAHIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:42 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-09-52cd106e9ce9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 08/28] perf hists: Accumulate hist entry stat based on the callchain
Date: Wed,  8 Jan 2014 17:46:13 +0900
Message-Id: <1389170793-21926-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __hists__add_entry() for each callchain node to get an
accumulated stat for an entry.  Introduce new cumulative_iter ops to
process them properly.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 95 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 80c50f243f34..27e477df0730 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,7 +79,11 @@ static int report__resolve_callchain(struct report *rep, struct symbol **parent,
 				     struct perf_evsel *evsel, struct addr_location *al,
 				     struct perf_sample *sample)
 {
-	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
+	if (sample->callchain == NULL)
+		return 0;
+
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
 		return machine__resolve_callchain(al->machine, evsel, al->thread, sample,
 						  parent, al, rep->max_stack);
 	}
@@ -355,6 +359,85 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 	return hist_entry__append_callchain(he, sample);
 }
 
+static int
+iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
+			      struct addr_location *al __maybe_unused)
+{
+	callchain_cursor_commit(&callchain_cursor);
+	return 0;
+}
+
+static int
+iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
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
+	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+}
+
+static int
+iter_next_cumulative_entry(struct hist_entry_iter *iter,
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
+iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
+iter_finish_cumulative_entry(struct hist_entry_iter *iter,
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
 static struct hist_entry_iter mem_iter = {
 	.prepare_entry 		= iter_prepare_mem_entry,
 	.add_single_entry 	= iter_add_single_mem_entry,
@@ -379,6 +462,14 @@ static struct hist_entry_iter normal_iter = {
 	.finish_entry 		= iter_finish_normal_entry,
 };
 
+static struct hist_entry_iter cumulative_iter = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
 static int
 iter_add_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
@@ -438,6 +529,8 @@ static int process_sample_event(struct perf_tool *tool,
 		iter = &branch_iter;
 	else if (rep->mem_mode == 1)
 		iter = &mem_iter;
+	else if (symbol_conf.cumulate_callchain)
+		iter = &cumulative_iter;
 	else
 		iter = &normal_iter;
 
-- 
1.7.11.7

