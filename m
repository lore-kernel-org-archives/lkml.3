Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBGBkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:40:33 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43104 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:35:43 -0500
X-AuditID: 9c93017d-b7b1fae00000636d-ab-52f4386dcc9a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/21] perf hists: Accumulate hist entry stat based on the callchain
Date: Fri,  7 Feb 2014 10:35:06 +0900
Message-Id: <1391736923-30765-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __hists__add_entry() for each callchain node to get an
accumulated stat for an entry.  Introduce new cumulative_iter ops to
process them properly.

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  2 ++
 tools/perf/util/callchain.c |  3 +-
 tools/perf/util/hist.c      | 87 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |  1 +
 4 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 53b150fb9036..967ba75277fd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -104,6 +104,8 @@ static int process_sample_event(struct perf_tool *tool,
 		iter.ops = &hist_iter_branch;
 	else if (rep->mem_mode)
 		iter.ops = &hist_iter_mem;
+	else if (symbol_conf.cumulate_callchain)
+		iter.ops = &hist_iter_cumulative;
 	else
 		iter.ops = &hist_iter_normal;
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 8d9db454f1a9..35b12a06bc39 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -538,7 +538,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 	if (sample->callchain == NULL)
 		return 0;
 
-	if (symbol_conf.use_callchain || sort__has_parent) {
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
 		return machine__resolve_callchain(al->machine, evsel, al->thread,
 						  sample, parent, al, max_stack);
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index db474526ba66..4691313f8748 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -705,6 +705,85 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
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
@@ -729,6 +808,14 @@ const struct hist_iter_ops hist_iter_normal = {
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
 			 struct perf_evsel *evsel, struct perf_sample *sample,
 			 int max_stack_depth)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 348448d983ec..6da98cb2ee7e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -112,6 +112,7 @@ struct hist_entry_iter {
 extern const struct hist_iter_ops hist_iter_normal;
 extern const struct hist_iter_ops hist_iter_branch;
 extern const struct hist_iter_ops hist_iter_mem;
+extern const struct hist_iter_ops hist_iter_cumulative;
 
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
-- 
1.7.11.7

