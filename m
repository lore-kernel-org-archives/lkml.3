Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3JaG67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:58:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42171 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3JaG4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:22 -0400
X-AuditID: 9c930197-b7b3eae00000122e-c3-5271ff123552
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 02/14] perf tools: Introduce struct add_entry_iter
Date: Thu, 31 Oct 2013 15:56:04 +0900
Message-Id: <1383202576-28141-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There're some duplicate code when adding hist entries.  They are
different in that some have branch info or mem info but generally do
same thing.  So introduce new struct add_entry_iter and add callbacks
to customize each case in general way.

The new perf_evsel__add_entry() function will look like:

  iter->prepare_entry();
  iter->add_single_entry();

  while (iter->next_entry())
    iter->add_next_entry();

  iter->finish_entry();

This will help further work like the cumulative callchain patchset.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 435 +++++++++++++++++++++++++++++---------------
 1 file changed, 284 insertions(+), 151 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a7a8f7769629..f18cd43687d9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -73,38 +73,74 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
-					   struct addr_location *al,
-					   struct perf_sample *sample,
-					   struct perf_evsel *evsel,
-					   struct machine *machine,
-					   union perf_event *event)
-{
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
-	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	int err = 0;
+struct add_entry_iter {
+	int total;
+	int curr;
+
+	struct perf_report *rep;
+	struct perf_evsel *evsel;
+	struct perf_sample *sample;
 	struct hist_entry *he;
-	struct mem_info *mi, *mx;
-	uint64_t cost;
+	struct symbol *parent;
+	void *priv;
+
+	int (*prepare_entry)(struct add_entry_iter *, struct machine *,
+			     struct perf_evsel *, struct addr_location *,
+			     struct perf_sample *);
+	int (*add_single_entry)(struct add_entry_iter *, struct addr_location *);
+	int (*next_entry)(struct add_entry_iter *, struct addr_location *);
+	int (*add_next_entry)(struct add_entry_iter *, struct addr_location *);
+	int (*finish_entry)(struct add_entry_iter *, struct addr_location *);
+};
 
-	if ((sort__has_parent || symbol_conf.use_callchain) &&
-	    sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
-		if (err)
-			return err;
-	}
+static int
+iter_next_nop_entry(struct add_entry_iter *iter __maybe_unused,
+		    struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_add_next_nop_entry(struct add_entry_iter *iter __maybe_unused,
+			struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_prepare_mem_entry(struct add_entry_iter *iter, struct machine *machine,
+		       struct perf_evsel *evsel, struct addr_location *al,
+		       struct perf_sample *sample)
+{
+	union perf_event *event = iter->priv;
+	struct mem_info *mi;
+	u8 cpumode;
+
+	BUG_ON(event == NULL);
+
+	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
-	if (!mi)
+	if (mi == NULL)
 		return -ENOMEM;
 
-	if (rep->hide_unresolved && !al->sym)
+	iter->evsel = evsel;
+	iter->sample = sample;
+	iter->priv = mi;
+	return 0;
+}
+
+static int
+iter_add_single_mem_entry(struct add_entry_iter *iter, struct addr_location *al)
+{
+	u64 cost;
+	struct mem_info *mi = iter->priv;
+	struct hist_entry *he;
+
+	if (iter->rep->hide_unresolved && !al->sym)
 		return 0;
 
-	cost = sample->weight;
+	cost = iter->sample->weight;
 	if (!cost)
 		cost = 1;
 
@@ -115,11 +151,24 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
+	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
 				cost, cost, 0);
 	if (!he)
 		return -ENOMEM;
 
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_mem_entry(struct add_entry_iter *iter, struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct hist_entry *he = iter->he;
+	struct mem_info *mi = iter->priv;
+	int err = -ENOMEM;
+	u64 cost;
+
 	/*
 	 * In the TUI browser, we are doing integrated annotation,
 	 * so we don't allocate the extra space needed because the stdio
@@ -138,152 +187,179 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 			goto out;
 	}
 
-	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {
+	if (sort__has_sym && mi->daddr.sym && use_browser > 0) {
 		struct annotation *notes;
 
-		mx = he->mem_info;
-
-		notes = symbol__annotation(mx->daddr.sym);
-		if (notes->src == NULL && symbol__alloc_hist(mx->daddr.sym) < 0)
+		notes = symbol__annotation(mi->daddr.sym);
+		if (notes->src == NULL && symbol__alloc_hist(mi->daddr.sym) < 0)
 			goto out;
 
-		err = symbol__inc_addr_samples(mx->daddr.sym,
-					       mx->daddr.map,
-					       evsel->idx,
-					       mx->daddr.al_addr);
+		err = symbol__inc_addr_samples(mi->daddr.sym, mi->daddr.map,
+					       evsel->idx, mi->daddr.al_addr);
 		if (err)
 			goto out;
 	}
 
+	cost = iter->sample->weight;
+	if (!cost)
+		cost = 1;
+
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	err = 0;
 
 	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &callchain_cursor,
-				       sample->period);
+		err = callchain_append(he->callchain, &callchain_cursor,
+				       iter->sample->period);
 	}
+
 out:
 	return err;
 }
 
-static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
-					struct addr_location *al,
-					struct perf_sample *sample,
-					struct perf_evsel *evsel,
-				      struct machine *machine)
+static int
+iter_prepare_branch_entry(struct add_entry_iter *iter, struct machine *machine,
+			  struct perf_evsel *evsel, struct addr_location *al,
+			  struct perf_sample *sample)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
-	struct symbol *parent = NULL;
-	int err = 0;
-	unsigned i;
-	struct hist_entry *he;
-	struct branch_info *bi, *bx;
-
-	if ((sort__has_parent || symbol_conf.use_callchain)
-	    && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
-		if (err)
-			return err;
-	}
+	struct branch_info *bi;
 
 	bi = machine__resolve_bstack(machine, al->thread,
 				     sample->branch_stack);
 	if (!bi)
 		return -ENOMEM;
 
-	for (i = 0; i < sample->branch_stack->nr; i++) {
-		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
-			continue;
+	iter->curr = 0;
+	iter->total = sample->branch_stack->nr;
 
-		err = -ENOMEM;
+	iter->evsel = evsel;
+	iter->sample = sample;
+	iter->priv = bi;
+	return 0;
+}
 
-		/* overwrite the 'al' to branch-to info */
-		al->map = bi[i].to.map;
-		al->sym = bi[i].to.sym;
-		al->addr = bi[i].to.addr;
-		/*
-		 * The report shows the percentage of total branches captured
-		 * and not events sampled. Thus we use a pseudo period of 1.
-		 */
-		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
-					1, 1, 0);
-		if (he) {
-			struct annotation *notes;
-			bx = he->branch_info;
-			if (bx->from.sym && use_browser == 1 && sort__has_sym) {
-				notes = symbol__annotation(bx->from.sym);
-				if (!notes->src
-				    && symbol__alloc_hist(bx->from.sym) < 0)
-					goto out;
-
-				err = symbol__inc_addr_samples(bx->from.sym,
-							       bx->from.map,
-							       evsel->idx,
-							       bx->from.al_addr);
-				if (err)
-					goto out;
-			}
+static int
+iter_add_single_branch_entry(struct add_entry_iter *iter __maybe_unused,
+			     struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
 
-			if (bx->to.sym && use_browser == 1 && sort__has_sym) {
-				notes = symbol__annotation(bx->to.sym);
-				if (!notes->src
-				    && symbol__alloc_hist(bx->to.sym) < 0)
-					goto out;
-
-				err = symbol__inc_addr_samples(bx->to.sym,
-							       bx->to.map,
-							       evsel->idx,
-							       bx->to.al_addr);
-				if (err)
-					goto out;
-			}
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-		} else
-			goto out;
-	}
-	err = 0;
-out:
-	free(bi);
-	return err;
+static int
+iter_next_branch_entry(struct add_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi = iter->priv;
+	int i = iter->curr;
+
+	if (iter->curr >= iter->total)
+		return 0;
+
+	al->map = bi[i].to.map;
+	al->sym = bi[i].to.sym;
+	al->addr = bi[i].to.addr;
+	return 1;
 }
 
-static int perf_evsel__add_hist_entry(struct perf_tool *tool,
-				      struct perf_evsel *evsel,
-				      struct addr_location *al,
-				      struct perf_sample *sample,
-				      struct machine *machine)
+static int
+iter_add_next_branch_entry(struct add_entry_iter *iter, struct addr_location *al)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
-	struct symbol *parent = NULL;
-	int err = 0;
+	struct branch_info *bi, *bx;
+	struct annotation *notes;
+	struct perf_evsel *evsel = iter->evsel;
 	struct hist_entry *he;
+	int i = iter->curr;
+	int err;
 
-	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
+	bi = iter->priv;
+
+	if (iter->rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
+		goto out;
+
+	/*
+	 * The report shows the percentage of total branches captured
+	 * and not events sampled. Thus we use a pseudo period of 1.
+	 */
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+				1, 1, 0);
+	if (he == NULL)
+		return -ENOMEM;
+
+	bx = he->branch_info;
+	if (bx->from.sym && use_browser == 1 && sort__has_sym) {
+		notes = symbol__annotation(bx->from.sym);
+		if (!notes->src && symbol__alloc_hist(bx->from.sym) < 0)
+			return -ENOMEM;
+
+		err = symbol__inc_addr_samples(bx->from.sym, bx->from.map,
+					       evsel->idx, bx->from.al_addr);
+		if (err)
+			return err;
+	}
+
+	if (bx->to.sym && use_browser == 1 && sort__has_sym) {
+		notes = symbol__annotation(bx->to.sym);
+		if (!notes->src && symbol__alloc_hist(bx->to.sym) < 0)
+			return -ENOMEM;
+
+		err = symbol__inc_addr_samples(bx->to.sym, bx->to.map,
+					       evsel->idx, bx->to.al_addr);
 		if (err)
 			return err;
 	}
+	evsel->hists.stats.total_period += 1;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+out:
+	iter->curr++;
+	return 0;
+}
+
+static int
+iter_finish_branch_entry(struct add_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
+{
+	free(iter->priv);
+
+	return iter->curr >= iter->total ? 0 : -1;
+}
+
+static int
+iter_prepare_normal_entry(struct add_entry_iter *iter,
+			  struct machine *machine __maybe_unused,
+			  struct perf_evsel *evsel,
+			  struct addr_location *al __maybe_unused,
+			  struct perf_sample *sample)
+{
+	iter->evsel = evsel;
+	iter->sample = sample;
+	return 0;
+}
+
+static int
+iter_add_single_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &callchain_cursor,
-				       sample->period);
-		if (err)
-			return err;
-	}
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
+{
+	int err = 0;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
@@ -294,19 +370,79 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 
 		assert(evsel != NULL);
 
-		err = -ENOMEM;
 		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
-			goto out;
+			return -ENOMEM;
 
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	}
 
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-out:
+
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain, &callchain_cursor,
+				       sample->period);
+	}
 	return err;
 }
 
+static struct add_entry_iter mem_iter = {
+	.prepare_entry 		= iter_prepare_mem_entry,
+	.add_single_entry 	= iter_add_single_mem_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_mem_entry,
+};
+
+static struct add_entry_iter branch_iter = {
+	.prepare_entry 		= iter_prepare_branch_entry,
+	.add_single_entry 	= iter_add_single_branch_entry,
+	.next_entry 		= iter_next_branch_entry,
+	.add_next_entry 	= iter_add_next_branch_entry,
+	.finish_entry 		= iter_finish_branch_entry,
+};
+
+static struct add_entry_iter normal_iter = {
+	.prepare_entry 		= iter_prepare_normal_entry,
+	.add_single_entry 	= iter_add_single_normal_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_normal_entry,
+};
+
+static int
+perf_evsel__add_entry(struct perf_evsel *evsel, struct addr_location *al,
+		      struct perf_sample *sample, struct machine *machine,
+		      struct add_entry_iter *iter)
+{
+	int err;
+
+	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample, &iter->parent, al,
+						 iter->rep->max_stack);
+		if (err)
+			return err;
+	}
+
+	err = iter->prepare_entry(iter, machine, evsel, al, sample);
+	if (err)
+		return err;
+
+	err = iter->add_single_entry(iter, al);
+	if (err)
+		return err;
+
+	while (iter->next_entry(iter, al)) {
+		err = iter->add_next_entry(iter, al);
+		if (err)
+			break;
+	}
+
+	err = iter->finish_entry(iter, al);
+
+	return err;
+}
 
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
@@ -316,6 +452,7 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct addr_location al;
+	struct add_entry_iter *iter;
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -330,25 +467,21 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
-							 evsel, machine);
-		if (ret < 0)
-			pr_debug("problem adding lbr entry, skipping event\n");
-	} else if (rep->mem_mode == 1) {
-		ret = perf_report__add_mem_hist_entry(tool, &al, sample,
-						      evsel, machine, event);
-		if (ret < 0)
-			pr_debug("problem adding mem entry, skipping event\n");
-	} else {
-		if (al.map != NULL)
-			al.map->dso->hit = 1;
-
-		ret = perf_evsel__add_hist_entry(tool, evsel, &al, sample,
-						 machine);
-		if (ret < 0)
-			pr_debug("problem incrementing symbol period, skipping event\n");
-	}
+	if (sort__mode == SORT_MODE__BRANCH)
+		iter = &branch_iter;
+	else if (rep->mem_mode == 1)
+		iter = &mem_iter;
+	else
+		iter = &normal_iter;
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	iter->rep = rep;
+	ret = perf_evsel__add_entry(evsel, &al, sample, machine, iter);
+	if (ret < 0)
+		pr_debug("problem adding hist entry, skipping event\n");
+
 	return ret;
 }
 
-- 
1.7.11.7

