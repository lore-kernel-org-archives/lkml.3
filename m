Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbaAHIxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:53:47 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48017 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaAHIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:41 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-f6-52cd106df913
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/28] perf tools: Introduce struct hist_entry_iter
Date: Wed,  8 Jan 2014 17:46:09 +0900
Message-Id: <1389170793-21926-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There're some duplicate code when adding hist entries.  They are
different in that some have branch info or mem info but generally do
same thing.  So introduce new struct hist_entry_iter and add callbacks
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
 tools/perf/builtin-report.c | 362 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 273 insertions(+), 89 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6bfcb83db8ff..c11c4e8493da 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -93,29 +93,68 @@ static int hist_entry__append_callchain(struct hist_entry *he, struct perf_sampl
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
 
-static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      union perf_event *event)
-{
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+struct hist_entry_iter {
+	int total;
+	int curr;
+
+	struct report *rep;
+	union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_sample *sample;
 	struct hist_entry *he;
-	struct mem_info *mi, *mx;
-	uint64_t cost;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	struct symbol *parent;
+	void *priv;
+
+	int (*prepare_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_single_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
+};
 
-	if (err)
-		return err;
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
+	union perf_event *event = iter->event;
+	struct perf_sample *sample = iter->sample;
+	struct mem_info *mi;
+	u8 cpumode;
+
+	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
-	if (!mi)
+	if (mi == NULL)
 		return -ENOMEM;
 
-	if (rep->hide_unresolved && !al->sym)
-		return 0;
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
 
-	cost = sample->weight;
+	cost = iter->sample->weight;
 	if (!cost)
 		cost = 1;
 
@@ -126,11 +165,27 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
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
 	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	if (err)
 		goto out;
@@ -140,97 +195,222 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		goto out;
 
+	cost = iter->sample->weight;
+	if (!cost)
+		cost = 1;
+
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	err = hist_entry__append_callchain(he, sample);
+
+	err = hist_entry__append_callchain(he, iter->sample);
+
 out:
+	/*
+	 * We don't need to free iter->priv (mem_info) here since
+	 * the mem info was either already freed in add_hist_entry() or
+	 * passed to a new hist entry by hist_entry__new().
+	 */
+	iter->priv = NULL;
+
+	iter->he = NULL;
 	return err;
 }
 
-static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
-					 struct perf_sample *sample, struct perf_evsel *evsel)
+static int
+iter_prepare_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
-	unsigned i;
-	struct hist_entry *he;
-	struct branch_info *bi, *bx;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
-
-	if (err)
-		return err;
+	struct branch_info *bi;
+	struct perf_sample *sample = iter->sample;
 
 	bi = machine__resolve_bstack(al->machine, al->thread,
 				     sample->branch_stack);
 	if (!bi)
 		return -ENOMEM;
 
-	for (i = 0; i < sample->branch_stack->nr; i++) {
-		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
-			continue;
+	iter->curr = 0;
+	iter->total = sample->branch_stack->nr;
 
-		err = -ENOMEM;
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
-			bx = he->branch_info;
-			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-			if (err)
-				goto out;
-
-			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-			if (err)
-				goto out;
-
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
+iter_add_single_branch_entry(struct hist_entry_iter *iter __maybe_unused,
+			     struct addr_location *al __maybe_unused)
+{
+	return 0;
 }
 
-static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
-				  struct addr_location *al, struct perf_sample *sample)
+static int
+iter_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
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
 	struct hist_entry *he;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int i = iter->curr;
+	int err = 0;
+
+	bi = iter->priv;
+
+	if (iter->rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
+		goto out;
 
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
+	err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
 	if (err)
-		return err;
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
 
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
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
 				sample->period, sample->weight,
 				sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
 
-	err = hist_entry__append_callchain(he, sample);
-	if (err)
-		goto out;
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
 
 	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (err)
+		return err;
+
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	return hist_entry__append_callchain(he, sample);
+}
+
+static struct hist_entry_iter mem_iter = {
+	.prepare_entry 		= iter_prepare_mem_entry,
+	.add_single_entry 	= iter_add_single_mem_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_mem_entry,
+};
+
+static struct hist_entry_iter branch_iter = {
+	.prepare_entry 		= iter_prepare_branch_entry,
+	.add_single_entry 	= iter_add_single_branch_entry,
+	.next_entry 		= iter_next_branch_entry,
+	.add_next_entry 	= iter_add_next_branch_entry,
+	.finish_entry 		= iter_finish_branch_entry,
+};
+
+static struct hist_entry_iter normal_iter = {
+	.prepare_entry 		= iter_prepare_normal_entry,
+	.add_single_entry 	= iter_add_single_normal_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_normal_entry,
+};
+
+static int
+iter_add_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	int err, err2;
+
+	err = report__resolve_callchain(iter->rep, &iter->parent, iter->evsel,
+					al, iter->sample);
+	if (err)
+		return err;
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
 out:
+	err2 = iter->finish_entry(iter, al);
+	if (!err)
+		err = err2;
+
 	return err;
 }
 
-
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -239,6 +419,7 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
+	struct hist_entry_iter *iter;
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -253,22 +434,25 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
-		if (ret < 0)
-			pr_debug("problem adding lbr entry, skipping event\n");
-	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
-		if (ret < 0)
-			pr_debug("problem adding mem entry, skipping event\n");
-	} else {
-		if (al.map != NULL)
-			al.map->dso->hit = 1;
-
-		ret = report__add_hist_entry(tool, evsel, &al, sample);
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
+	iter->evsel = evsel;
+	iter->event = event;
+	iter->sample = sample;
+
+	ret = iter_add_entry(iter, &al);
+	if (ret < 0)
+		pr_debug("problem adding hist entry, skipping event\n");
+
 	return ret;
 }
 
-- 
1.7.11.7

