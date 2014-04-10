Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595AbaDJULh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbaDJULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 4/5] perf:  Switch to using hist_entry_group
Date: Thu, 10 Apr 2014 16:11:00 -0400
Message-Id: <1397160661-33395-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fully conversion to using hist_entry_group and having it compile.
The patch is huge because of all the little changes here and there required.

I have only implemented single group, so the output should look identical
to what is currently shown on the perf tool.  The next patch adds group
output.

I added a core set of macros to iterate through each group attached
to the hists rb_tree.  So a bunch of changes looks like:

	hists__for_each_entry_in(....) {

to
	struct hist_entry_group *g;

	hists__for_each_group_in(...) {
		hists_group__for_each_entry_in(...) {

		<tab everything over>

I tried to minimize all the subtle changes for better review, but some could
not be changed without breaking the compile.

A bunch of functions have:

	if (sort__has_group)
		return;

because it wasn't obvious to me how to traverse the group list and entry
list and still fulfill the spirit of the function (most of it was my lack of
understanding how the function works).

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-annotate.c  |  11 +-
 tools/perf/builtin-diff.c      |  77 ++++++----
 tools/perf/builtin-top.c       |  12 +-
 tools/perf/tests/hists_link.c  |  69 +++++----
 tools/perf/ui/browsers/hists.c |  37 ++++-
 tools/perf/ui/gtk/hists.c      |  67 +++++----
 tools/perf/ui/hist.c           |  10 +-
 tools/perf/ui/stdio/hist.c     |  33 +++--
 tools/perf/util/evsel.c        |   7 +-
 tools/perf/util/hist.c         | 325 +++++++++++++++++++++++++----------------
 tools/perf/util/hist.h         |  12 +-
 tools/perf/util/sort.h         |  89 ++++++++---
 12 files changed, 471 insertions(+), 278 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0157787..98abdd2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -114,9 +114,18 @@ static void hists__find_annotations(struct hists *hists,
 				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	struct rb_node *nd = rb_first(&hists->entries), *next;
+	struct rb_node *gnd = rb_first(&hists->groups);
+	struct rb_node *nd, *next;
+	struct hist_entry_group *hg;
 	int key = K_RIGHT;
 
+	/* only single group supported */
+	if (sort__has_group)
+		return;
+
+	hg = rb_entry(gnd, struct hist_entry_group, rb_node);
+	nd = rb_first(&hg->entries);
+
 	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct annotation *notes;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 837d0e2..79fd62e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -220,7 +220,7 @@ static int setup_compute(const struct option *opt, const char *str,
 
 static double period_percent(struct hist_entry *he, u64 period)
 {
-	u64 total = he->hists->stats.total_period;
+	u64 total = he->groups->hists->stats.total_period;
 	return (period * 100.0) / total;
 }
 
@@ -262,8 +262,8 @@ static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
-			  pair->stat.period, pair->hists->stats.total_period,
-			  he->stat.period, he->hists->stats.total_period);
+			  pair->stat.period, pair->groups->hists->stats.total_period,
+			  he->stat.period, he->groups->hists->stats.total_period);
 }
 
 static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
@@ -382,7 +382,7 @@ get_pair_data(struct hist_entry *he, struct data__file *d)
 		struct hist_entry *pair;
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node)
-			if (pair->hists == d->hists)
+			if (pair->groups->hists == d->hists)
 				return pair;
 	}
 
@@ -401,11 +401,14 @@ get_pair_fmt(struct hist_entry *he, struct diff_hpp_fmt *dfmt)
 static void hists__baseline_only(struct hists *hists)
 {
 	struct hist_entry *he, *next;
-
-	hist__for_each_entry_in_safe(he, next, hists) {
-		if (!hist_entry__next_pair(he)) {
-			rb_erase(&he->rb_node_in, hists__get_root(hists));
-			hist_entry__free(he);
+	struct hist_entry_group *hg, *gnext;
+
+	hist__for_each_group_in_safe(hg, gnext, hists) {
+		hist_group__for_each_entry_in_safe(he, next, hg) {
+			if (!hist_entry__next_pair(he)) {
+				rb_erase(&he->rb_node_in, hists__get_root(hg));
+				hist_entry__free(he);
+			}
 		}
 	}
 }
@@ -413,26 +416,29 @@ static void hists__baseline_only(struct hists *hists)
 static void hists__precompute(struct hists *hists)
 {
 	struct hist_entry *he;
+	struct hist_entry_group *hg;
 
-	hist__for_each_entry_in(he, hists) {
-		struct hist_entry *pair;
-
-		pair = get_pair_data(he, &data__files[sort_compute]);
-		if (!pair)
-			continue;
+	hist__for_each_group_in(hg, hists) {
+		hist_group__for_each_entry_in(he, hg) {
+			struct hist_entry *pair;
 
-		switch (compute) {
-		case COMPUTE_DELTA:
-			compute_delta(he, pair);
-			break;
-		case COMPUTE_RATIO:
-			compute_ratio(he, pair);
-			break;
-		case COMPUTE_WEIGHTED_DIFF:
-			compute_wdiff(he, pair);
-			break;
-		default:
-			BUG_ON(1);
+			pair = get_pair_data(he, &data__files[sort_compute]);
+			if (!pair)
+				continue;
+	
+			switch (compute) {
+			case COMPUTE_DELTA:
+				compute_delta(he, pair);
+				break;
+			case COMPUTE_RATIO:
+				compute_ratio(he, pair);
+				break;
+			case COMPUTE_WEIGHTED_DIFF:
+				compute_wdiff(he, pair);
+				break;
+			default:
+					BUG_ON(1);
+			}
 		}
 	}
 }
@@ -534,16 +540,23 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 static void hists__compute_resort(struct hists *hists)
 {
 	struct hist_entry *he;
+	struct hist_entry_group *hg;
 
-	hists->entries = RB_ROOT;
+	hists->groups = RB_ROOT;
 
 	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
-	hist__for_each_entry_in(he, hists) {
-		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_nr_entries(hists, he);
+	hist__for_each_group_in(hg, hists) {
+		hg->entries = RB_ROOT;
+		hg->nr_entries = 0;
+		hg->entry.stat.period = 0;
+
+		hist_group__for_each_entry_in(he, hg) {
+			insert_hist_entry_by_compute(&hg->entries, he, compute);
+			hists__inc_nr_entries(hg, he);
+		}
 	}
 }
 
@@ -705,7 +718,7 @@ static const struct option options[] = {
 
 static double baseline_percent(struct hist_entry *he)
 {
-	struct hists *hists = he->hists;
+	struct hists *hists = he->groups->hists;
 	return 100.0 * he->stat.period / hists->stats.total_period;
 }
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 427f2e2..eda5df3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -338,6 +338,7 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 {
 	char *buf = malloc(0), *p;
 	struct hist_entry *syme = top->sym_filter_entry, *n, *found = NULL;
+	struct hist_entry_group *g;
 	size_t dummy = 0;
 
 	/* zero counters of active symbol */
@@ -354,13 +355,16 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (p)
 		*p = 0;
 
-	hist__for_each_entry_out(n, (&top->sym_evsel->hists)) {
-		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
-			found = n;
-			break;
+	hist__for_each_group_out(g, (&top->sym_evsel->hists)) {
+		hist_group__for_each_entry_out(n, g) {
+			if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
+				found = n;
+				goto found;
+			}
 		}
 	}
 
+found:
 	if (!found) {
 		fprintf(stderr, "Sorry, %s is not active.\n", buf);
 		sleep(1);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index a0def6b..8796e1f 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -281,16 +281,19 @@ static int __validate_match(struct hists *hists)
 {
 	size_t count = 0;
 	struct hist_entry *he;
-
-	hist__for_each_entry_in(he, hists) {
-		if (hist_entry__has_pairs(he)) {
-			if (find_sample(fake_common_samples,
-					ARRAY_SIZE(fake_common_samples),
-					he->thread, he->ms.map, he->ms.sym)) {
-				count++;
-			} else {
-				pr_debug("Can't find the matched entry\n");
-				return -1;
+	struct hist_entry_group *hg;
+
+	hist__for_each_group_in(hg, hists) {
+		hist_group__for_each_entry_in(he, hg) {
+			if (hist_entry__has_pairs(he)) {
+				if (find_sample(fake_common_samples,
+						ARRAY_SIZE(fake_common_samples),
+						he->thread, he->ms.map, he->ms.sym)) {
+					count++;
+				} else {
+					pr_debug("Can't find the matched entry\n");
+					return -1;
+				}
 			}
 		}
 	}
@@ -315,6 +318,7 @@ static int __validate_link(struct hists *hists, int idx)
 	size_t count_pair = 0;
 	size_t count_dummy = 0;
 	struct hist_entry *he;
+	struct hist_entry_group *hg;
 
 	/*
 	 * Leader hists (idx = 0) will have dummy entries from other,
@@ -322,23 +326,25 @@ static int __validate_link(struct hists *hists, int idx)
 	 * in other hists should have (dummy) pair.
 	 */
 
-	hist__for_each_entry_in(he, hists) {
-		if (hist_entry__has_pairs(he)) {
-			if (!find_sample(fake_common_samples,
-					 ARRAY_SIZE(fake_common_samples),
-					 he->thread, he->ms.map, he->ms.sym) &&
-			    !find_sample(fake_samples[idx],
-					 ARRAY_SIZE(fake_samples[idx]),
-					 he->thread, he->ms.map, he->ms.sym)) {
-				count_dummy++;
+	hist__for_each_group_in(hg, hists) {
+		hist_group__for_each_entry_in(he, hg) {
+			if (hist_entry__has_pairs(he)) {
+				if (!find_sample(fake_common_samples,
+						 ARRAY_SIZE(fake_common_samples),
+						 he->thread, he->ms.map, he->ms.sym) &&
+						 !find_sample(fake_samples[idx],
+						 ARRAY_SIZE(fake_samples[idx]),
+						 he->thread, he->ms.map, he->ms.sym)) {
+					count_dummy++;
+				}
+				count_pair++;
+			} else if (idx) {
+				pr_debug("A entry from the other hists should have pair\n");
+				return -1;
 			}
-			count_pair++;
-		} else if (idx) {
-			pr_debug("A entry from the other hists should have pair\n");
-			return -1;
-		}
 
-		count++;
+			count++;
+		}
 	}
 
 	/*
@@ -380,14 +386,17 @@ static void print_hists(struct hists *hists)
 {
 	int i = 0;
 	struct hist_entry *he;
+	struct hist_entry_group *hg;
 
 	pr_info("----- %s --------\n", __func__);
-	hist__for_each_entry_in(he, hists) {
-		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-			i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
-			he->ms.sym->name, he->stat.period);
+	hist__for_each_group_in(hg, hists) {
+		hist_group__for_each_entry_in(he, hg) {
+			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
 
-		i++;
+			i++;
+		}
 	}
 }
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index f2693f3..d1d0658 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -283,12 +283,15 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
 static void hists__set_folding(struct hists *hists, bool unfold)
 {
 	struct hist_entry *he;
+	struct hist_entry_group *hg;
 
 	hists->nr_entries = 0;
 
-	hist__for_each_entry_out(he, hists) {
-		hist_entry__set_folding(he, unfold);
-		hists->nr_entries += 1 + he->nr_rows;
+	hist__for_each_group_out(hg, hists) {
+		hist_group__for_each_entry_out(he, hg) {
+			hist_entry__set_folding(he, unfold);
+			hists->nr_entries += 1 + he->nr_rows;
+		}
 	}
 }
 
@@ -317,9 +320,15 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	int key;
 	char title[160];
 	int delay_secs = hbt ? hbt->refresh : 0;
+	struct hist_entry_group *g;
 
-	browser->b.entries = &browser->hists->entries;
-	browser->b.nr_entries = browser->hists->nr_entries;
+	if (sort__has_group)
+		return -1;
+
+	g = rb_entry_safe(rb_first(&browser->hists->groups), struct hist_entry_group, rb_node);
+
+	browser->b.entries = &g->entries;
+	browser->b.nr_entries = g->nr_entries;
 	if (browser->min_pcnt)
 		browser->b.nr_entries = browser->nr_pcnt_entries;
 
@@ -750,11 +759,17 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 static void ui_browser__hists_init_top(struct ui_browser *browser)
 {
+	if (sort__has_group)
+		return;
+
 	if (browser->top == NULL) {
 		struct hist_browser *hb;
+		struct hist_entry_group *g;
 
 		hb = container_of(browser, struct hist_browser, b);
-		browser->top = rb_first(&hb->hists->entries);
+		g = rb_entry_safe(rb_first(&hb->hists->groups),
+				  struct hist_entry_group, rb_node);
+		browser->top = rb_first(&g->entries);
 	}
 }
 
@@ -1326,7 +1341,15 @@ close_file_and_continue:
 static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 {
 	u64 nr_entries = 0;
-	struct rb_node *nd = rb_first(&hb->hists->entries);
+	struct hist_entry_group *g;
+	struct rb_node *nd;
+
+	if (sort__has_group)
+		return;
+
+	g = rb_entry_safe(rb_first(&hb->hists->groups),
+			  struct hist_entry_group, rb_node);
+	nd = rb_first(&g->entries);
 
 	while (nd) {
 		nr_entries++;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 3df6c00a..befbf3b 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -161,6 +161,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	int nr_cols;
 	char s[512];
 	struct hist_entry *h;
+	struct hist_entry_group *g;
 
 	struct perf_hpp hpp = {
 		.buf		= s,
@@ -225,50 +226,52 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 	g_object_unref(GTK_TREE_MODEL(store));
 
-	hist__for_each_entry_out(h, hists) {
-		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+	hist__for_each_group_out(g, hists) {
+		hist_group__for_each_entry_out(h, g) {
+			GtkTreeIter iter;
+			float percent = h->stat.period * 100.0 /
+						hists->stats.total_period;
 
-		if (h->filtered)
-			continue;
+			if (h->filtered)
+				continue;
 
-		if (percent < min_pcnt)
-			continue;
+			if (percent < min_pcnt)
+				continue;
 
-		gtk_tree_store_append(store, &iter, NULL);
+			gtk_tree_store_append(store, &iter, NULL);
 
-		col_idx = 0;
+			col_idx = 0;
 
-		perf_hpp__for_each_format(fmt) {
-			if (fmt->color)
-				fmt->color(fmt, &hpp, h);
-			else
-				fmt->entry(fmt, &hpp, h);
+			perf_hpp__for_each_format(fmt) {
+				if (fmt->color)
+					fmt->color(fmt, &hpp, h);
+				else
+					fmt->entry(fmt, &hpp, h);
 
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
+				gtk_tree_store_set(store, &iter, col_idx++, s, -1);
+			}
 
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
-			if (se->elide)
-				continue;
+			list_for_each_entry(se, &hist_entry__sort_list, list) {
+				if (se->elide)
+					continue;
 
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
-					hists__col_len(hists, se->se_width_idx));
+				se->se_snprintf(h, s, ARRAY_SIZE(s),
+						hists__col_len(hists, se->se_width_idx));
 
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
+				gtk_tree_store_set(store, &iter, col_idx++, s, -1);
+			}
 
-		if (symbol_conf.use_callchain && sort__has_sym) {
-			u64 total;
+			if (symbol_conf.use_callchain && sort__has_sym) {
+				u64 total;
 
-			if (callchain_param.mode == CHAIN_GRAPH_REL)
-				total = h->stat.period;
-			else
-				total = hists->stats.total_period;
+				if (callchain_param.mode == CHAIN_GRAPH_REL)
+					total = h->stat.period;
+				else
+					total = hists->stats.total_period;
 
-			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
-						sym_col, total);
+				perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
+							sym_col, total);
+			}
 		}
 	}
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0f403b8..21c4e5c 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -20,7 +20,7 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	int ret = 0;
-	struct hists *hists = he->hists;
+	struct hists *hists = he->groups->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
 	char *buf = hpp->buf;
 	size_t size = hpp->size;
@@ -33,9 +33,9 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (fmt_percent) {
 		double percent = 0.0;
 
-		if (hists->stats.total_period)
+		if (hpp->total_period)
 			percent = 100.0 * get_field(he) /
-				  hists->stats.total_period;
+				  hpp->total_period;
 
 		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
@@ -50,12 +50,12 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+			u64 total = hpp->total_period; //FIXME for pairs
 
 			if (!total)
 				continue;
 
-			evsel = hists_to_evsel(pair->hists);
+			evsel = hists_to_evsel(pair->groups->hists);
 			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
 
 			while (idx_delta--) {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 96defa8..6c1a85a 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -348,6 +348,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	struct perf_hpp hpp = {
 		.buf		= bf,
 		.size		= size,
+		.total_period	= he->groups->entry.stat.period,
 	};
 
 	if (size == 0 || size > bfsz)
@@ -383,6 +384,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	size_t linesz;
 	char *line = NULL;
 	struct hist_entry *h;
+	struct hist_entry_group *g;
 
 	init_rem_hits();
 
@@ -478,25 +480,28 @@ print_entries:
 		goto out;
 	}
 
-	hist__for_each_entry_out(h, hists) {
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+	hist__for_each_group_out(g, hists) {
+		hist_group__for_each_entry_out(h, g) {
 
-		if (h->filtered)
-			continue;
+			float percent = h->stat.period * 100.0 /
+					g->entry.stat.period;
 
-		if (percent < min_pcnt)
-			continue;
+			if (h->filtered)
+				continue;
+
+			if (percent < min_pcnt)
+				continue;
 
-		ret += hist_entry__fprintf(h, max_cols, hists, line, linesz, fp);
+			ret += hist_entry__fprintf(h, max_cols, hists, line, linesz, fp);
 
-		if (max_rows && ++nr_rows >= max_rows)
-			break;
+			if (max_rows && ++nr_rows >= max_rows)
+				break;
 
-		if (h->ms.map == NULL && verbose > 1) {
-			__map_groups__fprintf_maps(&h->thread->mg,
-						   MAP__FUNCTION, verbose, fp);
-			fprintf(fp, "%.10s end\n", graph_dotted_line);
+			if (h->ms.map == NULL && verbose > 1) {
+				__map_groups__fprintf_maps(&h->thread->mg,
+							   MAP__FUNCTION, verbose, fp);
+				fprintf(fp, "%.10s end\n", graph_dotted_line);
+			}
 		}
 	}
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5c28d82..16d46f2 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -118,10 +118,9 @@ void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
 void hists__init(struct hists *hists)
 {
 	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
+	hists->groups_in_array[0] = hists->groups_in_array[1] = RB_ROOT;
+	hists->groups_in = &hists->groups_in_array[0];
+	hists->groups = RB_ROOT;
 	pthread_mutex_init(&hists->lock, NULL);
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9b87a1f..32cdc7a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -160,17 +160,20 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 {
-	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
+	struct hist_entry_group *g;
 	int row = 0;
 
 	hists__reset_col_len(hists);
 
-	while (next && row++ < max_rows) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		if (!n->filtered)
-			hists__calc_col_len(hists, n);
-		next = rb_next(&n->rb_node);
+	hist__for_each_group_out(g, hists) {
+		hist_group__for_each_entry_out(n, g) {
+			if (!n->filtered)
+				hists__calc_col_len(hists, n);
+
+			if (row++ >= max_rows)
+				return;
+		}
 	}
 }
 
@@ -222,7 +225,7 @@ static void he_stat__decay(struct he_stat *he_stat)
 	/* XXX need decay for weight too? */
 }
 
-static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
+static bool hists__decay_entry(struct hist_entry_group *hg, struct hist_entry *he)
 {
 	u64 prev_period = he->stat.period;
 
@@ -232,35 +235,35 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	he_stat__decay(&he->stat);
 
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->stat.period;
+		hg->entry.stat.period -= prev_period - he->stat.period;
 
 	return he->stat.period == 0;
 }
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 {
-	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
+	struct hist_entry_group *g;
 
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-		/*
-		 * We may be annotating this, for instance, so keep it here in
-		 * case some it gets new samples, we'll eventually free it when
-		 * the user stops browsing and it agains gets fully decayed.
-		 */
-		if (((zap_user && n->level == '.') ||
-		     (zap_kernel && n->level != '.') ||
-		     hists__decay_entry(hists, n)) &&
-		    !n->used) {
-			rb_erase(&n->rb_node, &hists->entries);
-
-			if (sort__need_collapse)
-				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
-
-			hist_entry__free(n);
-			--hists->nr_entries;
+	hist__for_each_group_out(g, hists) {
+		hist_group__for_each_entry_out(n, g) {
+			/*
+			 * We may be annotating this, for instance, so keep it here in
+			 * case some it gets new samples, we'll eventually free it when
+			 * the user stops browsing and it agains gets fully decayed.
+			 */
+			if (((zap_user && n->level == '.') ||
+			     (zap_kernel && n->level != '.') ||
+			     hists__decay_entry(g, n)) &&
+			    !n->used) {
+				rb_erase(&n->rb_node, &g->entries);
+	
+				if (sort__need_collapse)
+					rb_erase(&n->rb_node_in, &g->entries_collapsed);
+	
+				hist_entry__free(n);
+				--g->nr_entries;
+			}
 		}
 	}
 }
@@ -334,15 +337,21 @@ static struct hist_entry_group *hist_group__new(struct hist_entry_group *templat
 	return hg;
 }
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
+void hists__inc_nr_entries(struct hist_entry_group *hg, struct hist_entry *h)
 {
 	if (!h->filtered) {
-		hists__calc_col_len(hists, h);
-		++hists->nr_entries;
-		hists->stats.total_period += h->stat.period;
+		hists__calc_col_len(hg->hists, h);
+		++hg->nr_entries;
+		hg->entry.stat.period += h->stat.period;
 	}
 }
 
+void hists__inc_nr_entry_groups(struct hists *hists, struct hist_entry_group *hg)
+{
+	++hists->nr_entries;
+	hists->stats.total_period += hg->entry.stat.period;
+}
+
 static u8 symbol__parent_filter(const struct symbol *parent)
 {
 	if (symbol_conf.exclude_other && parent == NULL)
@@ -350,7 +359,7 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-static struct hist_entry *add_hist_entry(struct hists *hists,
+static struct hist_entry *add_hist_entry(struct hist_entry_group *hg,
 					 struct hist_entry *entry,
 					 struct addr_location *al)
 {
@@ -361,7 +370,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	u64 period = entry->stat.period;
 	u64 weight = entry->stat.weight;
 
-	p = &hists->entries_in->rb_node;
+	p = &hg->entries_in->rb_node;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -408,15 +417,15 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
+	hg->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
-	rb_insert_color(&he->rb_node_in, hists->entries_in);
+	rb_insert_color(&he->rb_node_in, hg->entries_in);
 out:
 	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
 	return he;
 }
 
-static struct hist_entry_group *add_hist_group(struct hists *hists __maybe_unused,
+static struct hist_entry_group *add_hist_group(struct hists *hists,
 					       struct hist_entry_group *group)
 {
 	struct rb_node **p;
@@ -426,8 +435,7 @@ static struct hist_entry_group *add_hist_group(struct hists *hists __maybe_unuse
 	u64 period = group->entry.stat.period;
 	u64 weight = group->entry.stat.weight;
 
-	//p = &hists->groups_in->rb_node;
-	p = &parent;  //REMOVE when groups enabled
+	p = &hists->groups_in->rb_node;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -458,14 +466,14 @@ static struct hist_entry_group *add_hist_group(struct hists *hists __maybe_unuse
 	if (!hg)
 		return NULL;
 
-	//hists->nr_entries++;
+	hists->nr_entries++;
 	rb_link_node(&hg->rb_node_in, parent, p);
-	//rb_insert_color(&hg->rb_node_in, hists->groups_in);
+	rb_insert_color(&hg->rb_node_in, hists->groups_in);
 out:
 	return hg;
 };
 
-static struct hist_entry *__hists__add_entry(struct hists *hists,
+static struct hist_entry *__hists__add_entry(struct hist_entry_group *hg,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
@@ -490,13 +498,13 @@ static struct hist_entry *__hists__add_entry(struct hists *hists,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
-		.hists	= hists,
+		.groups = hg,
 		.branch_info = bi,
 		.mem_info = mi,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al);
+	return add_hist_entry(hg, &entry, al);
 }
 
 struct hist_entry *hists__add_entry(struct hists *hists,
@@ -542,7 +550,7 @@ struct hist_entry *hists__add_entry(struct hists *hists,
 	/* for outputing later */
 	hg->entry.groups = hg;
 
-	return __hists__add_entry(hists, al, sym_parent, bi, mi, period,
+	return __hists__add_entry(hg, al, sym_parent, bi, mi, period,
 				  weight, transaction);
 }
 
@@ -665,17 +673,17 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 	return true;
 }
 
-static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
+static struct rb_root *hists__get_rotate_entries_in(struct hist_entry_group *hg)
 {
 	struct rb_root *root;
 
-	pthread_mutex_lock(&hists->lock);
+	pthread_mutex_lock(&hg->hists->lock);
 
-	root = hists->entries_in;
-	if (++hists->entries_in > &hists->entries_in_array[1])
-		hists->entries_in = &hists->entries_in_array[0];
+	root = hg->entries_in;
+	if (++hg->entries_in > &hg->entries_in_array[1])
+		hg->entries_in = &hg->entries_in_array[0];
 
-	pthread_mutex_unlock(&hists->lock);
+	pthread_mutex_unlock(&hg->hists->lock);
 
 	return root;
 }
@@ -690,32 +698,31 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 {
 	struct rb_root *root;
-	struct rb_node *next;
-	struct hist_entry *n;
+	struct hist_entry *n, *next;
+	struct hist_entry_group *g;
 
 	if (!sort__need_collapse)
 		return;
 
-	root = hists__get_rotate_entries_in(hists);
-	next = rb_first(root);
-
-	while (next) {
-		if (session_done())
-			break;
-		n = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&n->rb_node_in);
-
-		rb_erase(&n->rb_node_in, root);
-		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n)) {
-			/*
-			 * If it wasn't combined with one of the entries already
-			 * collapsed, we need to apply the filters that may have
-			 * been set by, say, the hist_browser.
-			 */
-			hists__apply_filters(hists, n);
+	hist__for_each_group_in(g, hists) {
+		root = hists__get_rotate_entries_in(g);
+
+		__hist_group__for_each_entry_safe(n, next, root, rb_node_in) {
+			if (session_done())
+				break;
+
+			rb_erase(&n->rb_node_in, root);
+			if (hists__collapse_insert_entry(hists, &g->entries_collapsed, n)) {
+				/*
+				 * If it wasn't combined with one of the entries already
+				 * collapsed, we need to apply the filters that may have
+				 * been set by, say, the hist_browser.
+				 */
+				hists__apply_filters(hists, n);
+			}
+			if (prog)
+				ui_progress__update(prog, 1);
 		}
-		if (prog)
-			ui_progress__update(prog, 1);
 	}
 }
 
@@ -745,7 +752,7 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
 	if (ret || !symbol_conf.event_group)
 		return ret;
 
-	evsel = hists_to_evsel(a->hists);
+	evsel = hists_to_evsel(a->groups->hists);
 	nr_members = evsel->nr_members;
 	if (nr_members <= 1)
 		return ret;
@@ -757,12 +764,12 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
 		goto out;
 
 	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
+		evsel = hists_to_evsel(pair->groups->hists);
 		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
 	}
 
 	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
+		evsel = hists_to_evsel(pair->groups->hists);
 		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
 	}
 
@@ -805,40 +812,64 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
+static void __hists__insert_output_entry_group(struct rb_root *groups,
+					       struct hist_entry_group *hg)
+					       
+{
+	struct rb_node **p = &groups->rb_node;
+	struct rb_node *parent = NULL;
+
+	rb_link_node(&hg->rb_node, parent, p);
+	rb_insert_color(&hg->rb_node, groups);
+}
+
 void hists__output_resort(struct hists *hists)
 {
 	struct hist_entry *n;
+	struct hist_entry_group *g;
 	u64 min_callchain_hits;
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
-	hists->entries = RB_ROOT;
+	hists->groups = RB_ROOT;
 
 	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
-	hist__for_each_entry_in(n, hists) {
-		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+	hist__for_each_group_in(g, hists) {
+		g->entries = RB_ROOT;
+		g->nr_entries = 0;
+		g->entry.stat.period = 0;
+
+		hist_group__for_each_entry_in(n, g) {
+			__hists__insert_output_entry(&g->entries, n, min_callchain_hits);
+			hists__inc_nr_entries(g, n);
+		}
+
+		/* now that we recacluated entry stats, we can sort the group */ 
+		__hists__insert_output_entry_group(&hists->groups, g);
+		hists__inc_nr_entry_groups(hists, g);
 	}
 }
 
-static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
+static void hists__remove_entry_filter(struct hist_entry_group *hg,
+				       struct hist_entry *h,
 				       enum hist_filter filter)
 {
 	h->filtered &= ~(1 << filter);
 	if (h->filtered)
 		return;
 
-	++hists->nr_entries;
+	++hg->nr_entries;
 	if (h->ms.unfolded)
-		hists->nr_entries += h->nr_rows;
+		hg->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
+	hg->entry.stat.period += h->stat.period;
+	hg->hists->stats.total_period += h->stat.period;
+	hg->entry.stat.nr_events += h->stat.nr_events;
 
-	hists__calc_col_len(hists, h);
+	hists__calc_col_len(hg->hists, h);
 }
 
 
@@ -856,22 +887,28 @@ static bool hists__filter_entry_by_dso(struct hists *hists,
 
 void hists__filter_by_dso(struct hists *hists)
 {
-	struct rb_node *nd;
+	struct hist_entry *h;
+	struct hist_entry_group *g;
 
 	hists->nr_entries = hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_group_out(g, hists) {
 
-		if (symbol_conf.exclude_other && !h->parent)
-			continue;
+		g->nr_entries = g->entry.stat.period = 0;
+		g->entry.stat.nr_events = 0;
 
-		if (hists__filter_entry_by_dso(hists, h))
-			continue;
+		hist_group__for_each_entry_out(h, g) {
 
-		hists__remove_entry_filter(hists, h, HIST_FILTER__DSO);
+			if (symbol_conf.exclude_other && !h->parent)
+				continue;
+
+			if (hists__filter_entry_by_dso(hists, h))
+				continue;
+
+			hists__remove_entry_filter(g, h, HIST_FILTER__DSO);
+		}
 	}
 }
 
@@ -889,19 +926,28 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 
 void hists__filter_by_thread(struct hists *hists)
 {
-	struct rb_node *nd;
+	struct hist_entry *h;
+	struct hist_entry_group *g;
 
 	hists->nr_entries = hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_group_out(g, hists) {
+
+		g->nr_entries = g->entry.stat.period = 0;
+		g->entry.stat.nr_events = 0;
+
+		hist_group__for_each_entry_out(h, g) {
+
+			if (symbol_conf.exclude_other && !h->parent)
+				continue;
 
-		if (hists__filter_entry_by_thread(hists, h))
-			continue;
+			if (hists__filter_entry_by_thread(hists, h))
+				continue;
 
-		hists__remove_entry_filter(hists, h, HIST_FILTER__THREAD);
+			hists__remove_entry_filter(g, h, HIST_FILTER__THREAD);
+		}
 	}
 }
 
@@ -920,19 +966,28 @@ static bool hists__filter_entry_by_symbol(struct hists *hists,
 
 void hists__filter_by_symbol(struct hists *hists)
 {
-	struct rb_node *nd;
+	struct hist_entry *h;
+	struct hist_entry_group *g;
 
 	hists->nr_entries = hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_group_out(g, hists) {
+
+		g->nr_entries = g->entry.stat.period = 0;
+		g->entry.stat.nr_events = 0;
+
+		hist_group__for_each_entry_out(h, g) {
 
-		if (hists__filter_entry_by_symbol(hists, h))
-			continue;
+			if (symbol_conf.exclude_other && !h->parent)
+				continue;
 
-		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
+			if (hists__filter_entry_by_symbol(hists, h))
+				continue;
+
+			hists__remove_entry_filter(g, h, HIST_FILTER__SYMBOL);
+		}
 	}
 }
 
@@ -947,7 +1002,7 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	events_stats__inc(&hists->stats, type);
 }
 
-static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
+static struct hist_entry *hists__add_dummy_entry(struct hist_entry_group *groups,
 						 struct hist_entry *pair)
 {
 	struct rb_root *root;
@@ -957,9 +1012,9 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	int64_t cmp;
 
 	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
+		root = &groups->entries_collapsed;
 	else
-		root = hists->entries_in;
+		root = groups->entries_in;
 
 	p = &root->rb_node;
 
@@ -981,25 +1036,25 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	he = hist_entry__new(pair);
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
-		he->hists = hists;
+		he->groups = groups;
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_nr_entries(groups, he);
 		he->dummy = true;
 	}
 out:
 	return he;
 }
 
-static struct hist_entry *hists__find_entry(struct hists *hists,
+static struct hist_entry *hists__find_entry(struct hist_entry_group *hg,
 					    struct hist_entry *he)
 {
 	struct rb_node *n;
 
 	if (sort__need_collapse)
-		n = hists->entries_collapsed.rb_node;
+		n = hg->entries_collapsed.rb_node;
 	else
-		n = hists->entries_in->rb_node;
+		n = hg->entries_in->rb_node;
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node_in);
@@ -1022,12 +1077,23 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 void hists__match(struct hists *leader, struct hists *other)
 {
 	struct hist_entry *pos, *pair;
+	struct hist_entry_group *hg, *ohg;
+
+	/* only single group supported */
+	if (sort__has_group)
+		return;
+
+	ohg = rb_entry_safe(rb_first(other->groups_in), struct hist_entry_group, rb_node_in);
+	if (!ohg)
+		return;
 
-	hist__for_each_entry_in(pos, leader) {
-		pair = hists__find_entry(other, pos);
+	hist__for_each_group_in(hg, leader) {
+		hist_group__for_each_entry_in(pos, hg) {
+			pair = hists__find_entry(ohg, pos);
 
-		if (pair)
-			hist_entry__add_pair(pair, pos);
+			if (pair)
+				hist_entry__add_pair(pair, pos);
+		}
 	}
 }
 
@@ -1039,13 +1105,24 @@ void hists__match(struct hists *leader, struct hists *other)
 int hists__link(struct hists *leader, struct hists *other)
 {
 	struct hist_entry *pos, *pair;
-
-	hist__for_each_entry_in(pos, other) {
-		if (!hist_entry__has_pairs(pos)) {
-			pair = hists__add_dummy_entry(leader, pos);
-			if (pair == NULL)
-				return -1;
-			hist_entry__add_pair(pos, pair);
+	struct hist_entry_group *hg, *lhg;
+
+	/* only single group supported */
+	if (sort__has_group)
+		return -ENOTSUP;
+
+	lhg = rb_entry_safe(rb_first(leader->groups_in), struct hist_entry_group, rb_node_in);
+	if (!lhg)
+		return 0;
+
+	hist__for_each_group_in(hg, other) {
+		hist_group__for_each_entry_in(pos, hg) {
+			if (!hist_entry__has_pairs(pos)) {
+				pair = hists__add_dummy_entry(lhg, pos);
+				if (pair == NULL)
+					return -1;
+				hist_entry__add_pair(pos, pair);
+			}
 		}
 	}
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 618123b..1155397 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -11,6 +11,7 @@
 extern struct callchain_param callchain_param;
 
 struct hist_entry;
+struct hist_entry_group;
 struct addr_location;
 struct symbol;
 
@@ -78,10 +79,9 @@ struct thread;
 struct dso;
 
 struct hists {
-	struct rb_root		entries_in_array[2];
-	struct rb_root		*entries_in;
-	struct rb_root		entries;
-	struct rb_root		entries_collapsed;
+	struct rb_root		groups_in_array[2];
+	struct rb_root		*groups_in;
+	struct rb_root		groups;
 	u64			nr_entries;
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
@@ -114,7 +114,8 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
+void hists__inc_nr_entries(struct hist_entry_group *hg, struct hist_entry *h);
+void hists__inc_nr_entry_groups(struct hists *hists, struct hist_entry_group *hg);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
@@ -140,6 +141,7 @@ struct perf_hpp {
 	size_t size;
 	const char *sep;
 	void *ptr;
+	u64 total_period;
 };
 
 struct perf_hpp_fmt {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index a40e856..ff24050 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -110,7 +110,6 @@ struct hist_entry {
 	unsigned long		position;
 	struct rb_root		sorted_chain;
 	struct branch_info	*branch_info;
-	struct hists		*hists;
 	struct mem_info		*mem_info;
 	struct hist_entry_group	*groups;
 	struct callchain_root	callchain[0]; /* must be last member */
@@ -153,63 +152,113 @@ static inline void hist_entry__add_pair(struct hist_entry *pair,
 	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
-static inline struct rb_root *hists__get_root(struct hists *hists)
+static inline struct rb_root *hists__get_root(struct hist_entry_group *groups)
 {
 	if (sort__need_collapse)
-		return &hists->entries_collapsed;
+		return &groups->entries_collapsed;
 	else
-		return hists->entries_in;
+		return groups->entries_in;
 }
 
-
 /**
- * __hist__for_each_entry - iterate thru all the entries in hist
+ * __hist_group__for_each_entry - iterate thru all the entries in groups
  * @entry:	struct hist_entry to use as a loop cursor
  * @root:	struct rb_root that points to the top of an rbtree
  * @field:	the name of the rb_node within the struct
  */
-#define __hist__for_each_entry(entry, root, field)				\
-	for (entry = rb_entry_safe(rb_first(root), typeof(*entry), field);	\
-	     entry;								\
+#define __hist_group__for_each_entry(entry, root, field)					\
+	for (entry = rb_entry_safe(rb_first(root), typeof(*entry), field);			\
+	     entry;										\
 	     entry = rb_entry_safe(rb_next(&entry->field), typeof(*entry), field))
 
 /**
- * __hist__for_each_entry_safe - iterate thru all the entries in hist, safe against removal of entry
+ * __hist_group__for_each_entry_safe - iterate thru all the entries in groups,
+ * 				       safe against removal of entry
  * @entry:	struct hist_entry to use as a loop cursor
  * @next:	struct hist_entry to use as temporary storage
  * @root:	struct rb_root that points to the top of an rbtree
  * @field:	the name of the rb_node within the struct
  */
-#define __hist__for_each_entry_safe(entry, next, root, field)			\
+#define __hist_group__for_each_entry_safe(entry, next, root, field)			\
 	for (entry = rb_entry_safe(rb_first(root), typeof(*entry), field);	\
 	     entry && ({ next = rb_entry_safe(rb_next(&entry->field),		\
 			 typeof(*entry), field); 1; });				\
 	     entry = next)
 
 /**
- * hist__for_each_entry_in - iterate thru all the input entries in hist
+ * hist_group__for_each_entry_in - iterate thru all the input entries in groups
  * @entry:	struct hist_entry to use as a loop cursor
  * @hists:	struct hists entry that points to an rb_root tree
  */
-#define hist__for_each_entry_in(entry, hists)					\
-	__hist__for_each_entry(entry, hists__get_root(hists), rb_node_in)
+#define hist_group__for_each_entry_in(entry, groups)					\
+	__hist_group__for_each_entry(entry, hists__get_root(groups), rb_node_in)
 
 /**
- * hist__for_each_entry_in_safe - iterate thru all the input entries in hist, safe against removal of entry
+ * hist_group__for_each_entry_in_safe - iterate thru all the input entries in groups,
+ * 					safe against removal of entry
  * @entry:	struct hist_entry to use as a loop cursor
  * @next:	struct hist_entry to use as temporary storage
  * @hists:	struct hists entry that points to an rb_root tree
  */
-#define hist__for_each_entry_in_safe(entry, next, hists)			\
-	__hist__for_each_entry_safe(entry, next, hists__get_root(hists), rb_node_in)
+#define hist_group__for_each_entry_in_safe(entry, next, groups)			\
+	__hist_group__for_each_entry_safe(entry, next, hists__get_root(groups), rb_node_in)
 
 /**
- * hist__for_each_entry_out - iterate thru all the output entries in hist
+ * hist_group__for_each_entry_out - iterate thru all the output entries in groups
  * @entry:	struct hist_entry to use as a loop cursor
  * @hists:	struct hists entry that points to an rb_root tree
  */
-#define hist__for_each_entry_out(entry, hists)					\
-	__hist__for_each_entry(entry, (&hists->entries), rb_node)
+#define hist_group__for_each_entry_out(entry, groups)					\
+	__hist_group__for_each_entry(entry, (&groups->entries), rb_node)
+
+/**
+ * __hist__for_each_group - iterate thru all the groups in hist
+ * @group:	struct hist_entry_group to use as a loop cursor
+ * @root:	struct rb_root that points to the top of an rbtree
+ * @field:	the name of the rb_node within the struct
+ */
+#define __hist__for_each_group(group, root, field)					\
+	for (group = rb_entry_safe(rb_first(root), typeof(*group), field);			\
+	     group;										\
+	     group = rb_entry_safe(rb_next(&group->field), typeof(*group), field))
+
+/**
+ * __hist__for_each_group_safe - iterate thru all the groups in hist, safe against removal of group
+ * @group:	struct hist_entry_group to use as a loop cursor
+ * @next:	struct hist_entry_group to use as temporary storage
+ * @root:	struct rb_root that points to the top of an rbtree
+ * @field:	the name of the rb_node within the struct
+ */
+#define __hist__for_each_group_safe(group, next, root, field)			\
+	for (group = rb_entry_safe(rb_first(root), typeof(*group), field);	\
+	     group && ({ next = rb_entry_safe(rb_next(&group->field),		\
+			 typeof(*group), field); 1; });				\
+	     group = next)
+
+/**
+ * hist__for_each_group_in - iterate thru all the input groups in hist
+ * @group:	struct hist_entry_group to use as a loop cursor
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_group_in(group, hists)					\
+	__hist__for_each_group(group, hists->groups_in, rb_node_in)
+
+/**
+ * hist__for_each_group_in_safe - iterate thru all the input groups in hist, safe against removal of group
+ * @group:	struct hist_entry_group to use as a loop cursor
+ * @next:	struct hist_entry_group to use as temporary storage
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_group_in_safe(group, next, hists)			\
+	__hist__for_each_group_safe(group, next, hists->groups_in, rb_node_in)
+
+/**
+ * hist__for_each_group_in - iterate thru all the output groups in hist
+ * @group:	struct hist_entry_group to use as a loop cursor
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_group_out(group, hists)					\
+	__hist__for_each_group(group, (&hists->groups), rb_node)
 
 enum sort_mode {
 	SORT_MODE__NORMAL,
-- 
1.7.11.7

