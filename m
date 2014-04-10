Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030662AbaDJUN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128AbaDJULc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 2/5] perf: Use macros to walk hist entries
Date: Thu, 10 Apr 2014 16:10:58 -0400
Message-Id: <1397160661-33395-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is code copied everywhere to walk the hist entry list.  Turn this
into a macro to minimize errors later.  Also useful for converting to group
hist entries later.

New macros are:

hist__for_each_entry_in
hist__for_each_entry_in_safe
hist__for_each_entry_out

Most code that looks like this:

if (sort__neeed_collapse)
	root = &hists->entries_collapsed;
else
	root = hists->entries_in;

next = rb_first(root);
while (next != NULL) {
	struct hist_entry *he = rb_entry(....)
	next = rb_next(&he->rb_node_in);

and turns it into

hist__for_each_entry_in(he, hists) {

One advantage (besides smaller written code), is one doesn't have to remember
which struct fields are for input data or output data (entries_in vs. entries)
and their correspoding rb_node hook (rb_node_in vs. rb_node).

Most obvious places have been converted, some unusual cases stayed unchanged.

Should be a mostly mechanical change and nothing should change from a technical
perspective.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-diff.c      | 48 ++++++----------------------------
 tools/perf/builtin-top.c       |  6 +----
 tools/perf/tests/hists_link.c  | 51 +++++-------------------------------
 tools/perf/ui/browsers/hists.c |  5 ++--
 tools/perf/ui/gtk/hists.c      |  5 ++--
 tools/perf/ui/stdio/hist.c     |  5 ++--
 tools/perf/util/hist.c         | 34 +++---------------------
 tools/perf/util/sort.h         | 59 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 83 insertions(+), 130 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2e4857d..837d0e2 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -400,21 +400,11 @@ get_pair_fmt(struct hist_entry *he, struct diff_hpp_fmt *dfmt)
 
 static void hists__baseline_only(struct hists *hists)
 {
-	struct rb_root *root;
-	struct rb_node *next;
+	struct hist_entry *he, *next;
 
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	next = rb_first(root);
-	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
-
-		next = rb_next(&he->rb_node_in);
+	hist__for_each_entry_in_safe(he, next, hists) {
 		if (!hist_entry__next_pair(he)) {
-			rb_erase(&he->rb_node_in, root);
+			rb_erase(&he->rb_node_in, hists__get_root(hists));
 			hist_entry__free(he);
 		}
 	}
@@ -422,20 +412,10 @@ static void hists__baseline_only(struct hists *hists)
 
 static void hists__precompute(struct hists *hists)
 {
-	struct rb_root *root;
-	struct rb_node *next;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	next = rb_first(root);
-	while (next != NULL) {
-		struct hist_entry *he, *pair;
+	struct hist_entry *he;
 
-		he   = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&he->rb_node_in);
+	hist__for_each_entry_in(he, hists) {
+		struct hist_entry *pair;
 
 		pair = get_pair_data(he, &data__files[sort_compute]);
 		if (!pair)
@@ -553,27 +533,15 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
 static void hists__compute_resort(struct hists *hists)
 {
-	struct rb_root *root;
-	struct rb_node *next;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
+	struct hist_entry *he;
 
 	hists->entries = RB_ROOT;
-	next = rb_first(root);
 
 	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
-	while (next != NULL) {
-		struct hist_entry *he;
-
-		he = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&he->rb_node_in);
-
+	hist__for_each_entry_in(he, hists) {
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
 		hists__inc_nr_entries(hists, he);
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e58b124..427f2e2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -338,7 +338,6 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 {
 	char *buf = malloc(0), *p;
 	struct hist_entry *syme = top->sym_filter_entry, *n, *found = NULL;
-	struct rb_node *next;
 	size_t dummy = 0;
 
 	/* zero counters of active symbol */
@@ -355,14 +354,11 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (p)
 		*p = 0;
 
-	next = rb_first(&top->sym_evsel->hists.entries);
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
+	hist__for_each_entry_out(n, (&top->sym_evsel->hists)) {
 		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
 			found = n;
 			break;
 		}
-		next = rb_next(&n->rb_node);
 	}
 
 	if (!found) {
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index bd851c6..a0def6b 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -280,23 +280,9 @@ static int find_sample(struct sample *samples, size_t nr_samples,
 static int __validate_match(struct hists *hists)
 {
 	size_t count = 0;
-	struct rb_root *root;
-	struct rb_node *node;
-
-	/*
-	 * Only entries from fake_common_samples should have a pair.
-	 */
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node_in);
+	struct hist_entry *he;
 
+	hist__for_each_entry_in(he, hists) {
 		if (hist_entry__has_pairs(he)) {
 			if (find_sample(fake_common_samples,
 					ARRAY_SIZE(fake_common_samples),
@@ -307,8 +293,6 @@ static int __validate_match(struct hists *hists)
 				return -1;
 			}
 		}
-
-		node = rb_next(node);
 	}
 
 	if (count != ARRAY_SIZE(fake_common_samples)) {
@@ -330,25 +314,15 @@ static int __validate_link(struct hists *hists, int idx)
 	size_t count = 0;
 	size_t count_pair = 0;
 	size_t count_dummy = 0;
-	struct rb_root *root;
-	struct rb_node *node;
+	struct hist_entry *he;
 
 	/*
 	 * Leader hists (idx = 0) will have dummy entries from other,
 	 * and some entries will have no pair.  However every entry
 	 * in other hists should have (dummy) pair.
 	 */
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node_in);
 
+	hist__for_each_entry_in(he, hists) {
 		if (hist_entry__has_pairs(he)) {
 			if (!find_sample(fake_common_samples,
 					 ARRAY_SIZE(fake_common_samples),
@@ -365,7 +339,6 @@ static int __validate_link(struct hists *hists, int idx)
 		}
 
 		count++;
-		node = rb_next(node);
 	}
 
 	/*
@@ -406,27 +379,15 @@ static int validate_link(struct hists *leader, struct hists *other)
 static void print_hists(struct hists *hists)
 {
 	int i = 0;
-	struct rb_root *root;
-	struct rb_node *node;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
+	struct hist_entry *he;
 
 	pr_info("----- %s --------\n", __func__);
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node_in);
-
+	hist__for_each_entry_in(he, hists) {
 		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
 			i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
 			he->ms.sym->name, he->stat.period);
 
 		i++;
-		node = rb_next(node);
 	}
 }
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ec871a..f2693f3 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -282,12 +282,11 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
 
 static void hists__set_folding(struct hists *hists, bool unfold)
 {
-	struct rb_node *nd;
+	struct hist_entry *he;
 
 	hists->nr_entries = 0;
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_entry_out(he, hists) {
 		hist_entry__set_folding(he, unfold);
 		hists->nr_entries += 1 + he->nr_rows;
 	}
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e395ef9..3df6c00a 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -155,12 +155,12 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	GtkCellRenderer *renderer;
 	struct sort_entry *se;
 	GtkTreeStore *store;
-	struct rb_node *nd;
 	GtkWidget *view;
 	int col_idx;
 	int sym_col = -1;
 	int nr_cols;
 	char s[512];
+	struct hist_entry *h;
 
 	struct perf_hpp hpp = {
 		.buf		= s,
@@ -225,8 +225,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 	g_object_unref(GTK_TREE_MODEL(store));
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_entry_out(h, hists) {
 		GtkTreeIter iter;
 		float percent = h->stat.period * 100.0 /
 					hists->stats.total_period;
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d59893e..96defa8 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -369,7 +369,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 {
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
-	struct rb_node *nd;
 	size_t ret = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
@@ -383,6 +382,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	bool first = true;
 	size_t linesz;
 	char *line = NULL;
+	struct hist_entry *h;
 
 	init_rem_hits();
 
@@ -478,8 +478,7 @@ print_entries:
 		goto out;
 	}
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+	hist__for_each_entry_out(h, hists) {
 		float percent = h->stat.period * 100.0 /
 					hists->stats.total_period;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 57545b3..68eec0f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -672,29 +672,18 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 
 void hists__output_resort(struct hists *hists)
 {
-	struct rb_root *root;
-	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
 	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&n->rb_node_in);
-
+	hist__for_each_entry_in(n, hists) {
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
 		hists__inc_nr_entries(hists, n);
 	}
@@ -897,17 +886,9 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
  */
 void hists__match(struct hists *leader, struct hists *other)
 {
-	struct rb_root *root;
-	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	if (sort__need_collapse)
-		root = &leader->entries_collapsed;
-	else
-		root = leader->entries_in;
-
-	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
-		pos  = rb_entry(nd, struct hist_entry, rb_node_in);
+	hist__for_each_entry_in(pos, leader) {
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
@@ -922,18 +903,9 @@ void hists__match(struct hists *leader, struct hists *other)
  */
 int hists__link(struct hists *leader, struct hists *other)
 {
-	struct rb_root *root;
-	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	if (sort__need_collapse)
-		root = &other->entries_collapsed;
-	else
-		root = other->entries_in;
-
-	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node_in);
-
+	hist__for_each_entry_in(pos, other) {
 		if (!hist_entry__has_pairs(pos)) {
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..a089986 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -22,6 +22,7 @@
 #include "parse-events.h"
 
 #include "thread.h"
+#include "hist.h"
 
 extern regex_t parent_regex;
 extern const char *sort_order;
@@ -129,6 +130,64 @@ static inline void hist_entry__add_pair(struct hist_entry *pair,
 	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
+static inline struct rb_root *hists__get_root(struct hists *hists)
+{
+	if (sort__need_collapse)
+		return &hists->entries_collapsed;
+	else
+		return hists->entries_in;
+}
+
+
+/**
+ * __hist__for_each_entry - iterate thru all the entries in hist
+ * @entry:	struct hist_entry to use as a loop cursor
+ * @root:	struct rb_root that points to the top of an rbtree
+ * @field:	the name of the rb_node within the struct
+ */
+#define __hist__for_each_entry(entry, root, field)				\
+	for (entry = rb_entry_safe(rb_first(root), typeof(*entry), field);	\
+	     entry;								\
+	     entry = rb_entry_safe(rb_next(&entry->field), typeof(*entry), field))
+
+/**
+ * __hist__for_each_entry_safe - iterate thru all the entries in hist, safe against removal of entry
+ * @entry:	struct hist_entry to use as a loop cursor
+ * @next:	struct hist_entry to use as temporary storage
+ * @root:	struct rb_root that points to the top of an rbtree
+ * @field:	the name of the rb_node within the struct
+ */
+#define __hist__for_each_entry_safe(entry, next, root, field)			\
+	for (entry = rb_entry_safe(rb_first(root), typeof(*entry), field);	\
+	     entry && ({ next = rb_entry_safe(rb_next(&entry->field),		\
+			 typeof(*entry), field); 1; });				\
+	     entry = next)
+
+/**
+ * hist__for_each_entry_in - iterate thru all the input entries in hist
+ * @entry:	struct hist_entry to use as a loop cursor
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_entry_in(entry, hists)					\
+	__hist__for_each_entry(entry, hists__get_root(hists), rb_node_in)
+
+/**
+ * hist__for_each_entry_in_safe - iterate thru all the input entries in hist, safe against removal of entry
+ * @entry:	struct hist_entry to use as a loop cursor
+ * @next:	struct hist_entry to use as temporary storage
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_entry_in_safe(entry, next, hists)			\
+	__hist__for_each_entry_safe(entry, next, hists__get_root(hists), rb_node_in)
+
+/**
+ * hist__for_each_entry_out - iterate thru all the output entries in hist
+ * @entry:	struct hist_entry to use as a loop cursor
+ * @hists:	struct hists entry that points to an rb_root tree
+ */
+#define hist__for_each_entry_out(entry, hists)					\
+	__hist__for_each_entry(entry, (&hists->entries), rb_node)
+
 enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
-- 
1.7.11.7

