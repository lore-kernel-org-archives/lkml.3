Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3JaG6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:58:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42171 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3JaG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:23 -0400
X-AuditID: 9c930197-b7b3eae00000122e-d0-5271ff132ac7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 06/14] perf hists: Accumulate hist entry stat based on the callchain
Date: Thu, 31 Oct 2013 15:56:08 +0900
Message-Id: <1383202576-28141-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Call __hists__add_entry() for each callchain node to get an
accumulated stat for an entry.  However skip nodes which do not have
symbol info as they caused subtle problems.

AFAICS the current sort methods cannot distinguish entries with NULL
dso/sym well so that processing a callchian for an entry that doesn't
have symbol info might add a period to a same entry multiple times.
It ended up with an entry that have more than 100% of accumulated
period value which is not good.  So just stop processing when those
entries are met.

Introduce new cumulative_iter ops to process them properly.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 142 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d171f4d18b67..92cbd5cd1ab1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -386,6 +386,138 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
 	return err;
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
+	/*
+	 * The first callchain node always contains same information
+	 * as a hist entry itself.  So skip it in order to prevent
+	 * double accounting.
+	 */
+	callchain_cursor_advance(&callchain_cursor);
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
+	int err = 0;
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
+	/*
+	 * Only in the TUI browser we are doing integrated annotation,
+	 * so we don't allocated the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	if (he->ms.sym != NULL && use_browser == 1 && sort__has_sym) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			return -ENOMEM;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	}
+
+	return err;
+}
+
+static int
+iter_next_cumulative_entry(struct add_entry_iter *iter __maybe_unused,
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
+	al->addr = node->ip;
+
+	/*
+	 * XXX: Adding an entry without symbol info caused subtle
+	 * problems.  Stop it.
+	 */
+	if (al->sym == NULL)
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
+	int err = 0;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, false);
+	if (he == NULL)
+		return -ENOMEM;
+
+	/*
+	 * Only in the TUI browser we are doing integrated annotation,
+	 * so we don't allocated the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	if (he->ms.sym != NULL && use_browser == 1 && sort__has_sym) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			return -ENOMEM;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	}
+	return err;
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
@@ -410,6 +542,14 @@ static struct add_entry_iter normal_iter = {
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
@@ -471,6 +611,8 @@ static int process_sample_event(struct perf_tool *tool,
 		iter = &branch_iter;
 	else if (rep->mem_mode == 1)
 		iter = &mem_iter;
+	else if (callchain_param.mode == CHAIN_CUMULATIVE)
+		iter = &cumulative_iter;
 	else
 		iter = &normal_iter;
 
-- 
1.7.11.7

