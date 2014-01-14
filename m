Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaANFbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:31:10 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44860 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaANF0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:04 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-88-52d4ca670c4e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/24] perf tools: Introduce struct hist_entry_iter
Date: Tue, 14 Jan 2014 14:25:36 +0900
Message-Id: <1389677157-30513-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
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
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 172 +++----------------------
 tools/perf/util/hist.c      | 304 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |  34 +++++
 3 files changed, 356 insertions(+), 154 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7ddea46594ae..b6618ecb474a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -85,144 +85,6 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      union perf_event *event)
-{
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct hist_entry *he;
-	struct mem_info *mi, *mx;
-	uint64_t cost;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
-
-	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
-	if (!mi)
-		return -ENOMEM;
-
-	if (rep->hide_unresolved && !al->sym)
-		return 0;
-
-	cost = sample->weight;
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
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
-				cost, cost, 0);
-	if (!he)
-		return -ENOMEM;
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
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	err = hist_entry__append_callchain(he, sample);
-out:
-	return err;
-}
-
-static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
-					 struct perf_sample *sample, struct perf_evsel *evsel)
-{
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
-	unsigned i;
-	struct hist_entry *he;
-	struct branch_info *bi, *bx;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
-
-	bi = machine__resolve_bstack(al->machine, al->thread,
-				     sample->branch_stack);
-	if (!bi)
-		return -ENOMEM;
-
-	for (i = 0; i < sample->branch_stack->nr; i++) {
-		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
-			continue;
-
-		err = -ENOMEM;
-
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
-}
-
-static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
-				  struct addr_location *al, struct perf_sample *sample)
-{
-	struct report *rep = container_of(tool, struct report, tool);
-	struct symbol *parent = NULL;
-	struct hist_entry *he;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
-
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction);
-	if (he == NULL)
-		return -ENOMEM;
-
-	err = hist_entry__append_callchain(he, sample);
-	if (err)
-		goto out;
-
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-out:
-	return err;
-}
-
-
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -231,6 +93,9 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
+	struct hist_entry_iter iter = {
+		.hide_unresolved = rep->hide_unresolved,
+	};
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -245,22 +110,21 @@ static int process_sample_event(struct perf_tool *tool,
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
+		iter.ops = &hist_iter_branch;
+	else if (rep->mem_mode == 1)
+		iter.ops = &hist_iter_mem;
+	else
+		iter.ops = &hist_iter_normal;
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	ret = hist_entry_iter__add(&iter, &al, evsel, event, sample,
+				   rep->max_stack);
+	if (ret < 0)
+		pr_debug("problem adding hist entry, skipping event\n");
+
 	return ret;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 58c799d9b689..81565b6bf828 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "session.h"
 #include "sort.h"
 #include "evsel.h"
+#include "annotate.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -433,6 +434,309 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 	return add_hist_entry(hists, &entry, al);
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
+				cost, cost, 0);
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
+				1, 1, 0);
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
+				sample->transaction);
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
+const struct hist_iter_ops hist_iter_mem = {
+	.prepare_entry 		= iter_prepare_mem_entry,
+	.add_single_entry 	= iter_add_single_mem_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_mem_entry,
+};
+
+const struct hist_iter_ops hist_iter_branch = {
+	.prepare_entry 		= iter_prepare_branch_entry,
+	.add_single_entry 	= iter_add_single_branch_entry,
+	.next_entry 		= iter_next_branch_entry,
+	.add_next_entry 	= iter_add_next_branch_entry,
+	.finish_entry 		= iter_finish_branch_entry,
+};
+
+const struct hist_iter_ops hist_iter_normal = {
+	.prepare_entry 		= iter_prepare_normal_entry,
+	.add_single_entry 	= iter_add_single_normal_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_normal_entry,
+};
+
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, const union perf_event *event,
+			 struct perf_sample *sample, int max_stack_depth)
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
+
+	err = iter->ops->prepare_entry(iter, al);
+	if (err)
+		goto out;
+
+	err = iter->ops->add_single_entry(iter, al);
+	if (err)
+		goto out;
+
+	while (iter->ops->next_entry(iter, al)) {
+		err = iter->ops->add_next_entry(iter, al);
+		if (err)
+			break;
+	}
+
+out:
+	err2 = iter->ops->finish_entry(iter, al);
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
index 7d1d973d9a39..8182cb51d218 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -91,12 +91,46 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 };
 
+struct hist_entry_iter;
+
+struct hist_iter_ops {
+	int (*prepare_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_single_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
+};
+
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
+	const struct hist_iter_ops *ops;
+};
+
+extern const struct hist_iter_ops hist_iter_normal;
+extern const struct hist_iter_ops hist_iter_branch;
+extern const struct hist_iter_ops hist_iter_mem;
+
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction);
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, const union perf_event *event,
+			 struct perf_sample *sample, int max_stack_depth);
+
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
-- 
1.7.11.7

