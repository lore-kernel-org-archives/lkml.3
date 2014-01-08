Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaAHItU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:49:20 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48061 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaAHIqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:52 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-30-52cd1071c2f2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 23/28] perf tools: Factor out hist_entry_iter code
Date: Wed,  8 Jan 2014 17:46:28 +0900
Message-Id: <1389170793-21926-24-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the hist_entry_iter code will be shared with perf top code base.
So move it to util/hist.c and do some necessary cleanups and renames.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 468 +-------------------------------------------
 tools/perf/util/hist.c      | 441 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |  30 +++
 3 files changed, 477 insertions(+), 462 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ef9c67ff9e32..2d603304e779 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,458 +79,6 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-struct hist_entry_iter {
-	int total;
-	int curr;
-
-	struct report *rep;
-	union perf_event *event;
-	struct perf_evsel *evsel;
-	struct perf_sample *sample;
-	struct hist_entry *he;
-	struct symbol *parent;
-	void *priv;
-
-	int (*prepare_entry)(struct hist_entry_iter *, struct addr_location *);
-	int (*add_single_entry)(struct hist_entry_iter *, struct addr_location *);
-	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
-	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
-	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
-};
-
-static int
-iter_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
-		    struct addr_location *al __maybe_unused)
-{
-	return 0;
-}
-
-static int
-iter_add_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
-			struct addr_location *al __maybe_unused)
-{
-	return 0;
-}
-
-static int
-iter_prepare_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	union perf_event *event = iter->event;
-	struct perf_sample *sample = iter->sample;
-	struct mem_info *mi;
-	u8 cpumode;
-
-	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
-	if (mi == NULL)
-		return -ENOMEM;
-
-	iter->priv = mi;
-	return 0;
-}
-
-static int
-iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	u64 cost;
-	struct mem_info *mi = iter->priv;
-	struct hist_entry *he;
-
-	if (mi == NULL)
-		return -EINVAL;
-
-	cost = iter->sample->weight;
-	if (!cost)
-		cost = 1;
-
-	/*
-	 * must pass period=weight in order to get the correct
-	 * sorting from hists__collapse_resort() which is solely
-	 * based on periods. We want sorting be done on nr_events * weight
-	 * and this is indirectly achieved by passing period=weight here
-	 * and the he_stat__add_period() function.
-	 */
-	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
-				cost, cost, 0, true);
-	if (!he)
-		return -ENOMEM;
-
-	iter->he = he;
-	return 0;
-}
-
-static int
-iter_finish_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	struct perf_evsel *evsel = iter->evsel;
-	struct hist_entry *he = iter->he;
-	struct mem_info *mx;
-	int err = -EINVAL;
-	u64 cost;
-
-	if (he == NULL)
-		goto out;
-
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		goto out;
-
-	mx = he->mem_info;
-	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-	if (err)
-		goto out;
-
-	cost = iter->sample->weight;
-	if (!cost)
-		cost = 1;
-
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
-	err = hist_entry__append_callchain(he, iter->sample);
-
-out:
-	/*
-	 * We don't need to free iter->priv (mem_info) here since
-	 * the mem info was either already freed in add_hist_entry() or
-	 * passed to a new hist entry by hist_entry__new().
-	 */
-	iter->priv = NULL;
-
-	iter->he = NULL;
-	return err;
-}
-
-static int
-iter_prepare_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	struct branch_info *bi;
-	struct perf_sample *sample = iter->sample;
-
-	bi = machine__resolve_bstack(al->machine, al->thread,
-				     sample->branch_stack);
-	if (!bi)
-		return -ENOMEM;
-
-	iter->curr = 0;
-	iter->total = sample->branch_stack->nr;
-
-	iter->priv = bi;
-	return 0;
-}
-
-static int
-iter_add_single_branch_entry(struct hist_entry_iter *iter __maybe_unused,
-			     struct addr_location *al __maybe_unused)
-{
-	return 0;
-}
-
-static int
-iter_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	struct branch_info *bi = iter->priv;
-	int i = iter->curr;
-
-	if (bi == NULL)
-		return 0;
-
-	if (iter->curr >= iter->total)
-		return 0;
-
-	al->map = bi[i].to.map;
-	al->sym = bi[i].to.sym;
-	al->addr = bi[i].to.addr;
-	return 1;
-}
-
-static int
-iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	struct branch_info *bi, *bx;
-	struct perf_evsel *evsel = iter->evsel;
-	struct hist_entry *he;
-	int i = iter->curr;
-	int err = 0;
-
-	bi = iter->priv;
-
-	if (iter->rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
-		goto out;
-
-	/*
-	 * The report shows the percentage of total branches captured
-	 * and not events sampled. Thus we use a pseudo period of 1.
-	 */
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
-				1, 1, 0, true);
-	if (he == NULL)
-		return -ENOMEM;
-
-	bx = he->branch_info;
-	err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-	if (err)
-		goto out;
-
-	err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-	if (err)
-		goto out;
-
-	evsel->hists.stats.total_period += 1;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
-out:
-	iter->curr++;
-	return err;
-}
-
-static int
-iter_finish_branch_entry(struct hist_entry_iter *iter,
-			 struct addr_location *al __maybe_unused)
-{
-	zfree(&iter->priv);
-
-	return iter->curr >= iter->total ? 0 : -1;
-}
-
-static int
-iter_prepare_normal_entry(struct hist_entry_iter *iter __maybe_unused,
-			  struct addr_location *al __maybe_unused)
-{
-	return 0;
-}
-
-static int
-iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-	struct hist_entry *he;
-
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction, true);
-	if (he == NULL)
-		return -ENOMEM;
-
-	iter->he = he;
-	return 0;
-}
-
-static int
-iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	int err;
-	struct hist_entry *he = iter->he;
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-
-	if (he == NULL)
-		return 0;
-
-	iter->he = NULL;
-
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		return err;
-
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
-	return hist_entry__append_callchain(he, sample);
-}
-
-static int
-iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
-			      struct addr_location *al __maybe_unused)
-{
-	struct hist_entry **he_cache;
-
-	callchain_cursor_commit(&callchain_cursor);
-
-	/*
-	 * This is for detecting cycles or recursions so that they're
-	 * cumulated only one time to prevent entries more than 100%
-	 * overhead.
-	 */
-	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
-	if (he_cache == NULL)
-		return -ENOMEM;
-
-	iter->priv = he_cache;
-	iter->curr = 0;
-
-	return 0;
-}
-
-static int
-iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
-				 struct addr_location *al)
-{
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-	struct hist_entry **he_cache = iter->priv;
-	struct hist_entry *he;
-
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction, true);
-	if (he == NULL)
-		return -ENOMEM;
-
-	he_cache[iter->curr++] = he;
-
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
-
-	/*
-	 * We need to re-initialize the cursor since callchain_append()
-	 * advanced the cursor to the end.
-	 */
-	callchain_cursor_commit(&callchain_cursor);
-
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-}
-
-static int
-iter_next_cumulative_entry(struct hist_entry_iter *iter,
-			   struct addr_location *al)
-{
-	struct callchain_cursor_node *node;
-
-	node = callchain_cursor_current(&callchain_cursor);
-	if (node == NULL)
-		return 0;
-
-	return fill_callchain_info(al, node, iter->rep->hide_unresolved);
-}
-
-static int
-iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
-			       struct addr_location *al)
-{
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-	struct hist_entry **he_cache = iter->priv;
-	struct hist_entry *he;
-	struct hist_entry he_tmp = {
-		.cpu = al->cpu,
-		.thread = al->thread,
-		.comm = thread__comm(al->thread),
-		.ip = al->addr,
-		.ms = {
-			.map = al->map,
-			.sym = al->sym,
-		},
-		.parent = iter->parent,
-	};
-	int i;
-	struct callchain_cursor cursor;
-
-	callchain_cursor_snapshot(&cursor, &callchain_cursor);
-
-	callchain_cursor_advance(&callchain_cursor);
-
-	/*
-	 * Check if there's duplicate entries in the callchain.
-	 * It's possible that it has cycles or recursive calls.
-	 */
-	for (i = 0; i < iter->curr; i++) {
-		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
-			return 0;
-	}
-
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction, false);
-	if (he == NULL)
-		return -ENOMEM;
-
-	he_cache[iter->curr++] = he;
-
-	callchain_append(he->callchain, &cursor, sample->period);
-
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-}
-
-static int
-iter_finish_cumulative_entry(struct hist_entry_iter *iter,
-			     struct addr_location *al __maybe_unused)
-{
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
-	zfree(&iter->priv);
-	return 0;
-}
-
-static struct hist_entry_iter mem_iter = {
-	.prepare_entry 		= iter_prepare_mem_entry,
-	.add_single_entry 	= iter_add_single_mem_entry,
-	.next_entry 		= iter_next_nop_entry,
-	.add_next_entry 	= iter_add_next_nop_entry,
-	.finish_entry 		= iter_finish_mem_entry,
-};
-
-static struct hist_entry_iter branch_iter = {
-	.prepare_entry 		= iter_prepare_branch_entry,
-	.add_single_entry 	= iter_add_single_branch_entry,
-	.next_entry 		= iter_next_branch_entry,
-	.add_next_entry 	= iter_add_next_branch_entry,
-	.finish_entry 		= iter_finish_branch_entry,
-};
-
-static struct hist_entry_iter normal_iter = {
-	.prepare_entry 		= iter_prepare_normal_entry,
-	.add_single_entry 	= iter_add_single_normal_entry,
-	.next_entry 		= iter_next_nop_entry,
-	.add_next_entry 	= iter_add_next_nop_entry,
-	.finish_entry 		= iter_finish_normal_entry,
-};
-
-static struct hist_entry_iter cumulative_iter = {
-	.prepare_entry 		= iter_prepare_cumulative_entry,
-	.add_single_entry 	= iter_add_single_cumulative_entry,
-	.next_entry 		= iter_next_cumulative_entry,
-	.add_next_entry 	= iter_add_next_cumulative_entry,
-	.finish_entry 		= iter_finish_cumulative_entry,
-};
-
-static int
-iter_add_entry(struct hist_entry_iter *iter, struct addr_location *al)
-{
-	int err, err2;
-
-	err = sample__resolve_callchain(iter->sample, &iter->parent,
-					iter->evsel, al, iter->rep->max_stack);
-	if (err)
-		return err;
-
-	err = iter->prepare_entry(iter, al);
-	if (err)
-		goto out;
-
-	err = iter->add_single_entry(iter, al);
-	if (err)
-		goto out;
-
-	while (iter->next_entry(iter, al)) {
-		err = iter->add_next_entry(iter, al);
-		if (err)
-			break;
-	}
-
-out:
-	err2 = iter->finish_entry(iter, al);
-	if (!err)
-		err = err2;
-
-	return err;
-}
-
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -555,23 +103,19 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH)
-		iter = &branch_iter;
+		iter = &hist_iter_branch;
 	else if (rep->mem_mode == 1)
-		iter = &mem_iter;
+		iter = &hist_iter_mem;
 	else if (symbol_conf.cumulate_callchain)
-		iter = &cumulative_iter;
+		iter = &hist_iter_cumulative;
 	else
-		iter = &normal_iter;
+		iter = &hist_iter_normal;
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	iter->rep = rep;
-	iter->evsel = evsel;
-	iter->event = event;
-	iter->sample = sample;
-
-	ret = iter_add_entry(iter, &al);
+	ret = hist_entry_iter__add(iter, &al, evsel, event, sample,
+				   rep->hide_unresolved, rep->max_stack);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index daf39fc8fe33..c1f5b664545a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "session.h"
 #include "sort.h"
 #include "evsel.h"
+#include "annotate.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -460,6 +461,446 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 	return add_hist_entry(hists, &entry, al, sample_self);
 }
 
+static int
+iter_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
+		    struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_add_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
+			struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_prepare_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	const union perf_event *event = iter->event;
+	struct perf_sample *sample = iter->sample;
+	struct mem_info *mi;
+	u8 cpumode;
+
+	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
+	if (mi == NULL)
+		return -ENOMEM;
+
+	iter->priv = mi;
+	return 0;
+}
+
+static int
+iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	u64 cost;
+	struct mem_info *mi = iter->priv;
+	struct hist_entry *he;
+
+	if (mi == NULL)
+		return -EINVAL;
+
+	cost = iter->sample->weight;
+	if (!cost)
+		cost = 1;
+
+	/*
+	 * must pass period=weight in order to get the correct
+	 * sorting from hists__collapse_resort() which is solely
+	 * based on periods. We want sorting be done on nr_events * weight
+	 * and this is indirectly achieved by passing period=weight here
+	 * and the he_stat__add_period() function.
+	 */
+	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
+				cost, cost, 0, true);
+	if (!he)
+		return -ENOMEM;
+
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct hist_entry *he = iter->he;
+	struct mem_info *mx;
+	int err = -EINVAL;
+	u64 cost;
+
+	if (he == NULL)
+		goto out;
+
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (err)
+		goto out;
+
+	mx = he->mem_info;
+	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
+	if (err)
+		goto out;
+
+	cost = iter->sample->weight;
+	if (!cost)
+		cost = 1;
+
+	evsel->hists.stats.total_period += cost;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	err = hist_entry__append_callchain(he, iter->sample);
+
+out:
+	/*
+	 * We don't need to free iter->priv (mem_info) here since
+	 * the mem info was either already freed in add_hist_entry() or
+	 * passed to a new hist entry by hist_entry__new().
+	 */
+	iter->priv = NULL;
+
+	iter->he = NULL;
+	return err;
+}
+
+static int
+iter_prepare_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi;
+	struct perf_sample *sample = iter->sample;
+
+	bi = machine__resolve_bstack(al->machine, al->thread,
+				     sample->branch_stack);
+	if (!bi)
+		return -ENOMEM;
+
+	iter->curr = 0;
+	iter->total = sample->branch_stack->nr;
+
+	iter->priv = bi;
+	return 0;
+}
+
+static int
+iter_add_single_branch_entry(struct hist_entry_iter *iter __maybe_unused,
+			     struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi = iter->priv;
+	int i = iter->curr;
+
+	if (bi == NULL)
+		return 0;
+
+	if (iter->curr >= iter->total)
+		return 0;
+
+	al->map = bi[i].to.map;
+	al->sym = bi[i].to.sym;
+	al->addr = bi[i].to.addr;
+	return 1;
+}
+
+static int
+iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi, *bx;
+	struct perf_evsel *evsel = iter->evsel;
+	struct hist_entry *he;
+	int i = iter->curr;
+	int err = 0;
+
+	bi = iter->priv;
+
+	if (iter->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
+		goto out;
+
+	/*
+	 * The report shows the percentage of total branches captured
+	 * and not events sampled. Thus we use a pseudo period of 1.
+	 */
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+				1, 1, 0, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	bx = he->branch_info;
+	err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
+	if (err)
+		goto out;
+
+	err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
+	if (err)
+		goto out;
+
+	evsel->hists.stats.total_period += 1;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+out:
+	iter->curr++;
+	return err;
+}
+
+static int
+iter_finish_branch_entry(struct hist_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
+{
+	zfree(&iter->priv);
+
+	return iter->curr >= iter->total ? 0 : -1;
+}
+
+static int
+iter_prepare_normal_entry(struct hist_entry_iter *iter __maybe_unused,
+			  struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
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
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	int err;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
+	if (he == NULL)
+		return 0;
+
+	iter->he = NULL;
+
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (err)
+		return err;
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	return hist_entry__append_callchain(he, sample);
+}
+
+static int
+iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
+			      struct addr_location *al __maybe_unused)
+{
+	struct hist_entry **he_cache;
+
+	callchain_cursor_commit(&callchain_cursor);
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
+	return 0;
+}
+
+static int
+iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
+				 struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	he_cache[iter->curr++] = he;
+
+	callchain_append(he->callchain, &callchain_cursor, sample->period);
+
+	/*
+	 * We need to re-initialize the cursor since callchain_append()
+	 * advanced the cursor to the end.
+	 */
+	callchain_cursor_commit(&callchain_cursor);
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
+	return fill_callchain_info(al, node, iter->hide_unresolved);
+}
+
+static int
+iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
+			       struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
+	struct hist_entry *he;
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
+	struct callchain_cursor cursor;
+
+	callchain_cursor_snapshot(&cursor, &callchain_cursor);
+
+	callchain_cursor_advance(&callchain_cursor);
+
+	/*
+	 * Check if there's duplicate entries in the callchain.
+	 * It's possible that it has cycles or recursive calls.
+	 */
+	for (i = 0; i < iter->curr; i++) {
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
+			return 0;
+	}
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, false);
+	if (he == NULL)
+		return -ENOMEM;
+
+	he_cache[iter->curr++] = he;
+
+	callchain_append(he->callchain, &cursor, sample->period);
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
+	zfree(&iter->priv);
+	return 0;
+}
+
+struct hist_entry_iter hist_iter_mem = {
+	.prepare_entry 		= iter_prepare_mem_entry,
+	.add_single_entry 	= iter_add_single_mem_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_mem_entry,
+};
+
+struct hist_entry_iter hist_iter_branch = {
+	.prepare_entry 		= iter_prepare_branch_entry,
+	.add_single_entry 	= iter_add_single_branch_entry,
+	.next_entry 		= iter_next_branch_entry,
+	.add_next_entry 	= iter_add_next_branch_entry,
+	.finish_entry 		= iter_finish_branch_entry,
+};
+
+struct hist_entry_iter hist_iter_normal = {
+	.prepare_entry 		= iter_prepare_normal_entry,
+	.add_single_entry 	= iter_add_single_normal_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_normal_entry,
+};
+
+struct hist_entry_iter hist_iter_cumulative = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, const union perf_event *event,
+			 struct perf_sample *sample, bool hide_unresolved,
+			 int max_stack_depth)
+{
+	int err, err2;
+
+	err = sample__resolve_callchain(sample, &iter->parent, evsel, al,
+					max_stack_depth);
+	if (err)
+		return err;
+
+	iter->evsel = evsel;
+	iter->event = event;
+	iter->sample = sample;
+	iter->hide_unresolved = hide_unresolved;
+
+	err = iter->prepare_entry(iter, al);
+	if (err)
+		goto out;
+
+	err = iter->add_single_entry(iter, al);
+	if (err)
+		goto out;
+
+	while (iter->next_entry(iter, al)) {
+		err = iter->add_next_entry(iter, al);
+		if (err)
+			break;
+	}
+
+out:
+	err2 = iter->finish_entry(iter, al);
+	if (!err)
+		err = err2;
+
+	return err;
+}
+
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2f5db3a6562e..95fff1cd6727 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -91,6 +91,31 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 };
 
+struct hist_entry_iter {
+	int total;
+	int curr;
+
+	bool hide_unresolved;
+
+	const union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_sample *sample;
+	struct hist_entry *he;
+	struct symbol *parent;
+	void *priv;
+
+	int (*prepare_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_single_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
+};
+
+extern struct hist_entry_iter hist_iter_normal;
+extern struct hist_entry_iter hist_iter_branch;
+extern struct hist_entry_iter hist_iter_mem;
+extern struct hist_entry_iter hist_iter_cumulative;
+
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *parent,
@@ -98,6 +123,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction,
 				      bool sample_self);
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, const union perf_event *event,
+			 struct perf_sample *sample, bool hide_unresolved,
+			 int max_stack_depth);
+
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
-- 
1.7.11.7

