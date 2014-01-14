Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaANF0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:26:16 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46794 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaANF0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:04 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-96-52d4ca6798ec
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/24] perf hists: Accumulate hist entry stat based on the callchain
Date: Tue, 14 Jan 2014 14:25:40 +0900
Message-Id: <1389677157-30513-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c |  2 ++
 tools/perf/util/hist.c      | 87 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |  1 +
 3 files changed, 90 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b6618ecb474a..3ed0669d7620 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -114,6 +114,8 @@ static int process_sample_event(struct perf_tool *tool,
 		iter.ops = &hist_iter_branch;
 	else if (rep->mem_mode == 1)
 		iter.ops = &hist_iter_mem;
+	else if (symbol_conf.cumulate_callchain)
+		iter.ops = &hist_iter_cumulative;
 	else
 		iter.ops = &hist_iter_normal;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2e9dd5d4ca1d..46402fbf4c0e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -704,6 +704,85 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
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
+	if (iter->hide_unresolved && al->sym == NULL)
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
 const struct hist_iter_ops hist_iter_mem = {
 	.prepare_entry 		= iter_prepare_mem_entry,
 	.add_single_entry 	= iter_add_single_mem_entry,
@@ -728,6 +807,14 @@ const struct hist_iter_ops hist_iter_normal = {
 	.finish_entry 		= iter_finish_normal_entry,
 };
 
+const struct hist_iter_ops hist_iter_cumulative = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
 			 struct perf_sample *sample, int max_stack_depth)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d482e673ecf5..091bf81df8c3 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -120,6 +120,7 @@ struct hist_entry_iter {
 extern const struct hist_iter_ops hist_iter_normal;
 extern const struct hist_iter_ops hist_iter_branch;
 extern const struct hist_iter_ops hist_iter_mem;
+extern const struct hist_iter_ops hist_iter_cumulative;
 
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
-- 
1.7.11.7

