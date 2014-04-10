Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030635AbaDJUMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759152AbaDJULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:33 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 3/5] perf: Add in stub hist_entry_group code
Date: Thu, 10 Apr 2014 16:10:59 -0400
Message-Id: <1397160661-33395-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is hist_entry_group?

The idea is to create a new abstract layer between struct hist
and struct hist_entry.  This new layer has the ability to 'group'
entries together and sort them independently for the entry sorting
routines.

For now only one group is created, so there is nothing to sort at the
group level.  Later on, patches will add the ability to sort on cpu,
pid, and cacheline.

In an example, normal sorting on cycles provides the hottest instruction
addresses at the top.  This is great if one particular instruction is
hot.  But when using groups and sorting on pid, one can see a whole
bunch of cycle addresses collectively making a pid hot.

This allows us to view data differently and possibly spot trends.

The main reason for this work is for cacheline sorting.  I needed a way
to organize data addresses into cachelines to do proper entry sorting
later.  This allows me to see the hottest cachelines and the biggest
abusers within that cacheline.

This patch is more an intermediate patch that compiles and
shows the core data structure and changes.  It does nothing
right now.  It doesn't even hook into struct hists yet.

The next patch will do the giant conversion.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/hist.c | 135 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |   2 +
 tools/perf/util/sort.c |   2 +
 tools/perf/util/sort.h |  24 +++++++++
 4 files changed, 163 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 68eec0f..9b87a1f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -317,6 +317,23 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
+static struct hist_entry_group *hist_group__new(struct hist_entry_group *template)
+{
+	struct hist_entry_group *hg = zalloc(sizeof(*hg));
+
+	if (hg != NULL) {
+		*hg = *template;
+
+		hg->entries_in_array[0] = hg->entries_in_array[1] = RB_ROOT;
+		hg->entries_in = &hg->entries_in_array[0];
+		hg->entries_collapsed = RB_ROOT;
+		hg->entries = RB_ROOT;
+		INIT_LIST_HEAD(&hg->entry.pairs.node);
+	}
+
+	return hg;
+}
+
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
@@ -399,6 +416,55 @@ out:
 	return he;
 }
 
+static struct hist_entry_group *add_hist_group(struct hists *hists __maybe_unused,
+					       struct hist_entry_group *group)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hist_entry_group *hg;
+	int64_t cmp;
+	u64 period = group->entry.stat.period;
+	u64 weight = group->entry.stat.weight;
+
+	//p = &hists->groups_in->rb_node;
+	p = &parent;  //REMOVE when groups enabled
+
+	while (*p != NULL) {
+		parent = *p;
+		hg = rb_entry(parent, struct hist_entry_group, rb_node_in);
+
+		/*
+		 * Make sure that it receives arguments in a same order as
+		 * hist_entry__collapse() so that we can use an appropriate
+		 * function when searching an entry regardless which sort
+		 * keys were used.
+		 */
+		cmp = hist_group__cmp(&hg->entry, &group->entry);
+
+		if (!cmp) {
+
+			he_stat__add_period(&hg->entry.stat, period, weight);
+
+			goto out;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	hg = hist_group__new(group);
+	if (!hg)
+		return NULL;
+
+	//hists->nr_entries++;
+	rb_link_node(&hg->rb_node_in, parent, p);
+	//rb_insert_color(&hg->rb_node_in, hists->groups_in);
+out:
+	return hg;
+};
+
 static struct hist_entry *__hists__add_entry(struct hists *hists,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
@@ -441,6 +507,41 @@ struct hist_entry *hists__add_entry(struct hists *hists,
 				    u64 period, u64 weight,
 				    u64 transaction)
 {
+	struct hist_entry_group *hg;
+
+	struct hist_entry_group group = {
+		.entry = {
+			.thread	= al->thread,
+			.comm = thread__comm(al->thread),
+			.ms = {
+				.map	= al->map,
+				.sym	= al->sym,
+			},
+			.cpu	 = al->cpu,
+			.ip	 = al->addr,
+			.level	 = al->level,
+			.stat = {
+				.nr_events = 1,
+				.period	= period,
+				.weight = weight,
+			},
+			.parent = sym_parent,
+			.filtered = symbol__parent_filter(sym_parent) | al->filtered,
+			.branch_info = bi,
+			.mem_info = mi,
+			.transaction = transaction,
+		},
+		.hists = hists,
+	};
+
+	/* create group first */
+	hg = add_hist_group(hists, &group);
+	if (!hg)
+		return NULL;
+
+	/* for outputing later */
+	hg->entry.groups = hg;
+
 	return __hists__add_entry(hists, al, sym_parent, bi, mi, period,
 				  weight, transaction);
 }
@@ -487,6 +588,40 @@ void hist_entry__free(struct hist_entry *he)
 	free(he);
 }
 
+int64_t
+hist_group__cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_group__sort_list, list) {
+		cmp = se->se_cmp(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+int64_t
+hist_group__collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_group__sort_list, list) {
+		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+
+		f = se->se_collapse ?: se->se_cmp;
+
+		cmp = f(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
 /*
  * collapse the histogram
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1d24c27..618123b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -101,6 +101,8 @@ struct hist_entry *hists__add_entry(struct hists *hists,
 				    u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
+int64_t hist_group__cmp(struct hist_entry *left, struct hist_entry *right);
+int64_t hist_group__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
 int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..c292c78 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -14,11 +14,13 @@ int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
 int		sort__has_dso = 0;
+int		sort__has_group = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
 
 LIST_HEAD(hist_entry__sort_list);
+LIST_HEAD(hist_group__sort_list);
 
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index a089986..a40e856 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -34,6 +34,7 @@ extern int have_ignore_callees;
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
+extern int sort__has_group;
 extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
@@ -68,6 +69,8 @@ struct hist_entry_diff {
 	s64	wdiff;
 };
 
+struct hist_entry_group;
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -109,9 +112,29 @@ struct hist_entry {
 	struct branch_info	*branch_info;
 	struct hists		*hists;
 	struct mem_info		*mem_info;
+	struct hist_entry_group	*groups;
 	struct callchain_root	callchain[0]; /* must be last member */
 };
 
+struct hist_entry_group {
+	/* for struct hists */
+	struct rb_node		rb_node_in;
+	struct rb_node		rb_node;
+	struct hists		*hists;
+
+	/* for entries in group */
+	struct rb_root		entries_in_array[2];
+	struct rb_root		*entries_in;
+	struct rb_root		entries;
+	struct rb_root		entries_collapsed;
+	u64			nr_entries;
+
+	u64			event_stream;
+
+	/* embed to allow re-use of sorting code */
+	struct hist_entry	entry;
+};
+
 static inline bool hist_entry__has_pairs(struct hist_entry *he)
 {
 	return !list_empty(&he->pairs.node);
@@ -246,6 +269,7 @@ struct sort_entry {
 
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
+extern struct list_head hist_group__sort_list;
 
 int setup_sorting(void);
 extern int sort_dimension__add(const char *);
-- 
1.7.11.7

