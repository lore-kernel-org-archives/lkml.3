Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3EUGOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:14:44 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46119 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3EUGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:42 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-86-519b10d14011
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 1/7] perf hists: Basic support of hierarchical view
Date: Tue, 21 May 2013 15:14:32 +0900
Message-Id: <1369116878-12489-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In a hierarchical view, the events sorted and grouped on first key,
and then second key, and so on.  Now each hist entry has 3 of hroots
to save it's children entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   | 325 +++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/sort.h   |   3 +
 tools/perf/util/symbol.h |   3 +-
 3 files changed, 291 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 72b4eec820c3..80b981d52582 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -348,7 +348,7 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-static struct hist_entry *add_hist_entry(struct hists *hists,
+static struct hist_entry *__add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
 				      u64 period,
@@ -417,6 +417,96 @@ out_unlock:
 	return he;
 }
 
+static struct hist_entry *__add_hist_entry_hierarchy(struct hists *hists,
+						     struct hist_entry *entry,
+						     struct addr_location *al,
+						     u64 period, u64 weight)
+{
+	struct rb_root *root;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hist_entry *he = NULL;
+	struct sort_entry *se;
+	int cmp;
+
+	pthread_mutex_lock(&hists->lock);
+
+	root = hists->entries_in;
+	p = &root->rb_node;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		while (*p != NULL) {
+			parent = *p;
+			he = rb_entry(parent, struct hist_entry, rb_node_in);
+
+			/*
+			 * Make sure that it receives arguments in a same order as
+			 * hist_entry__collapse() so that we can use an appropriate
+			 * function when searching an entry regardless which sort
+			 * keys were used.
+			 */
+			cmp = se->se_cmp(he, entry);
+
+			if (!cmp) {
+				he_stat__add_period(&he->stat, period, weight);
+
+				/*
+				 * This mem info was allocated from machine__resolve_mem
+				 * and will not be used anymore.
+				 */
+				free(entry->mem_info);
+
+				/* If the map of an existing hist_entry has
+				 * become out-of-date due to an exec() or
+				 * similar, update it.  Otherwise we will
+				 * mis-adjust symbol addresses when computing
+				 * the history counter to increment.
+				 */
+				if (he->ms.map != entry->ms.map) {
+					he->ms.map = entry->ms.map;
+					if (he->ms.map)
+						he->ms.map->referenced = true;
+				}
+				goto next;
+			}
+
+			if (cmp < 0)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+		}
+
+		he = hist_entry__new(entry);
+		if (!he)
+			goto out_unlock;
+
+		rb_link_node(&he->rb_node_in, parent, p);
+		rb_insert_color(&he->rb_node_in, root);
+next:
+		hist_entry__add_cpumode_period(he, al->cpumode, period);
+
+		root = &he->rb_hroot_in;
+		p = &root->rb_node;
+		parent = NULL;
+	}
+
+out_unlock:
+	pthread_mutex_unlock(&hists->lock);
+	return he;
+}
+
+static struct hist_entry *add_hist_entry(struct hists *hists,
+				      struct hist_entry *entry,
+				      struct addr_location *al,
+				      u64 period,
+				      u64 weight)
+{
+	if (!symbol_conf.hierarchy)
+		return __add_hist_entry(hists, entry, al, period, weight);
+
+	return __add_hist_entry_hierarchy(hists, entry, al, period, weight);
+}
+
 struct hist_entry *__hists__add_mem_entry(struct hists *self,
 					  struct addr_location *al,
 					  struct symbol *sym_parent,
@@ -548,6 +638,8 @@ void hist_entry__free(struct hist_entry *he)
 	free(he);
 }
 
+static void hists__apply_filters(struct hists *hists, struct hist_entry *he);
+
 /*
  * collapse the histogram
  */
@@ -591,56 +683,148 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 	return true;
 }
 
-static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
+static void hists__collapse_resort_entries(struct hists *hists,
+					   struct rb_root *root_in,
+					   struct rb_root *root)
 {
-	struct rb_root *root;
-
-	pthread_mutex_lock(&hists->lock);
+	struct rb_node *next;
+	struct hist_entry *he;
 
-	root = hists->entries_in;
-	if (++hists->entries_in > &hists->entries_in_array[1])
-		hists->entries_in = &hists->entries_in_array[0];
+	next = rb_first(root_in);
 
-	pthread_mutex_unlock(&hists->lock);
+	while (next) {
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-	return root;
+		rb_erase(&he->rb_node_in, root_in);
+		if (hists__collapse_insert_entry(hists, root, he)) {
+			/*
+			 * If it wasn't combined with one of the entries already
+			 * collapsed, we need to apply the filters that may have
+			 * been set by, say, the hist_browser.
+			 */
+			hists__apply_filters(hists, he);
+		}
+	}
 }
 
-static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
+static struct hist_entry *
+__collapse_insert_entry_hierarchy(struct rb_root *root, struct hist_entry *he,
+				  struct sort_entry *se)
 {
-	hists__filter_entry_by_dso(hists, he);
-	hists__filter_entry_by_thread(hists, he);
-	hists__filter_entry_by_symbol(hists, he);
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+	int64_t cmp;
+
+	while (*p != NULL) {
+		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+		f = se->se_collapse ?: se->se_cmp;
+
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node_in);
+
+		cmp = f(iter, he);
+
+		if (!cmp) {
+			he_stat__add_stat(&iter->stat, &he->stat);
+
+			if (symbol_conf.use_callchain) {
+				callchain_cursor_reset(&callchain_cursor);
+				callchain_merge(&callchain_cursor,
+						iter->callchain,
+						he->callchain);
+			}
+			return iter;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node_in, parent, p);
+	rb_insert_color(&he->rb_node_in, root);
+	return he;
 }
 
-static void __hists__collapse_resort(struct hists *hists, bool threaded)
+static void
+hists__collapse_resort_entries_hierarchy(struct hists *hists,
+					 struct rb_root *root_in,
+					 struct rb_root *root,
+					 struct sort_entry *se)
 {
-	struct rb_root *root;
 	struct rb_node *next;
-	struct hist_entry *n;
+	struct hist_entry *he;
+	struct sort_entry *se_next;
 
-	if (!sort__need_collapse && !threaded)
+	next = rb_first(root_in);
+	if (next == NULL)
 		return;
 
-	root = hists__get_rotate_entries_in(hists);
-	next = rb_first(root);
+	BUG_ON(&se->list == &hist_entry__sort_list);
+	se_next = list_entry(se->list.next, struct sort_entry, list);
 
 	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&n->rb_node_in);
+		struct hist_entry *he_new;
+
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-		rb_erase(&n->rb_node_in, root);
-		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n)) {
+		rb_erase(&he->rb_node_in, root_in);
+		he_new = __collapse_insert_entry_hierarchy(root, he, se);
+		if (he == he_new) {
 			/*
 			 * If it wasn't combined with one of the entries already
 			 * collapsed, we need to apply the filters that may have
 			 * been set by, say, the hist_browser.
 			 */
-			hists__apply_filters(hists, n);
+			hists__apply_filters(hists, he);
 		}
+
+		hists__collapse_resort_entries_hierarchy(hists, &he->rb_hroot_in,
+					&he_new->rb_hroot_collapsed, se_next);
+
+		if (he != he_new)
+			hist_entry__free(he);
 	}
 }
 
+static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
+{
+	struct rb_root *root;
+
+	pthread_mutex_lock(&hists->lock);
+
+	root = hists->entries_in;
+	if (++hists->entries_in > &hists->entries_in_array[1])
+		hists->entries_in = &hists->entries_in_array[0];
+
+	pthread_mutex_unlock(&hists->lock);
+
+	return root;
+}
+
+static void __hists__collapse_resort(struct hists *hists, bool threaded)
+{
+	struct rb_root *root_in;
+	struct rb_root *root;
+	struct sort_entry *se;
+
+	if (!sort__need_collapse && !threaded)
+		return;
+
+	root_in = hists__get_rotate_entries_in(hists);
+	root = &hists->entries_collapsed;
+
+	if (!symbol_conf.hierarchy)
+		return hists__collapse_resort_entries(hists, root_in, root);
+
+	se = list_first_entry(&hist_entry__sort_list, struct sort_entry, list);
+	hists__collapse_resort_entries_hierarchy(hists, root_in, root, se);
+}
+
 void hists__collapse_resort(struct hists *hists)
 {
 	return __hists__collapse_resort(hists, false);
@@ -711,11 +895,11 @@ out:
 	return ret;
 }
 
-static void __hists__insert_output_entry(struct rb_root *entries,
+static void __hists__insert_output_entry(struct rb_root *root,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
 {
-	struct rb_node **p = &entries->rb_node;
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
@@ -734,37 +918,92 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, entries);
+	rb_insert_color(&he->rb_node, root);
+}
+
+static void hists__output_resort_entries(struct hists *hists,
+					 struct rb_root *root_in,
+					 struct rb_root *root,
+					 u64 min_callchain_hits)
+{
+	struct rb_node *next;
+	struct hist_entry *he;
+
+	next = rb_first(root_in);
+
+	while (next) {
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
+
+		__hists__insert_output_entry(root, he, min_callchain_hits);
+		hists__inc_nr_entries(hists, he);
+	}
+}
+
+static void hists__output_resort_entries_hierarchy(struct hists *hists,
+						   struct rb_root *root_in,
+						   struct rb_root *root,
+						   u64 min_callchain_hits,
+						   bool threaded)
+{
+	struct rb_node *next;
+	struct hist_entry *he;
+	struct rb_root *hroot_in;
+
+	next = rb_first(root_in);
+
+	if (next == NULL) {
+		he = list_entry(root, struct hist_entry, rb_hroot);
+		/* only count leaf nodes */
+		hists__inc_nr_entries(hists, he);
+		return;
+	}
+
+	while (next) {
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
+
+		__hists__insert_output_entry(root, he, min_callchain_hits);
+
+		if (sort__need_collapse || threaded)
+			hroot_in = &he->rb_hroot_collapsed;
+		else
+			hroot_in = &he->rb_hroot_in;
+
+		hists__output_resort_entries_hierarchy(hists, hroot_in,
+						       &he->rb_hroot,
+						       min_callchain_hits,
+						       threaded);
+	}
 }
 
 static void __hists__output_resort(struct hists *hists, bool threaded)
 {
+	struct rb_root *root_in;
 	struct rb_root *root;
-	struct rb_node *next;
-	struct hist_entry *n;
 	u64 min_callchain_hits;
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
 	if (sort__need_collapse || threaded)
-		root = &hists->entries_collapsed;
+		root_in = &hists->entries_collapsed;
 	else
-		root = hists->entries_in;
+		root_in = hists->entries_in;
 
-	next = rb_first(root);
 	hists->entries = RB_ROOT;
+	root = &hists->entries;
 
 	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&n->rb_node_in);
-
-		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+	if (!symbol_conf.hierarchy) {
+		return hists__output_resort_entries(hists, root_in, root,
+						    min_callchain_hits);
 	}
+
+	hists__output_resort_entries_hierarchy(hists, root_in, root,
+					       min_callchain_hits, threaded);
 }
 
 void hists__output_resort(struct hists *hists)
@@ -889,6 +1128,14 @@ void hists__filter_by_symbol(struct hists *hists)
 	}
 }
 
+static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
+{
+	hists__filter_entry_by_dso(hists, he);
+	hists__filter_entry_by_thread(hists, he);
+	hists__filter_entry_by_symbol(hists, he);
+}
+
+
 int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
 {
 	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 51f1b5a854e7..6c2ba362ca05 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -75,6 +75,9 @@ struct hist_entry_diff {
 struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
+	struct rb_root		rb_hroot_in;
+	struct rb_root		rb_hroot_collapsed;
+	struct rb_root		rb_hroot;
 	union {
 		struct list_head node;
 		struct list_head head;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5f720dc076da..ee0cfd8b785e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -98,7 +98,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			hierarchy;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

