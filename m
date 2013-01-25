Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3AYKtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:49:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3AYKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:48:59 -0500
Date: Fri, 25 Jan 2013 02:48:32 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ce74f60eab3cc8b7a3b0cb9c29ec9b1e1abac7d2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1355128197-18193-3-git-send-email-namhyung@kernel.org>
References: <1355128197-18193-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Link hist entries before inserting to an output tree
Git-Commit-ID: ce74f60eab3cc8b7a3b0cb9c29ec9b1e1abac7d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:48:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce74f60eab3cc8b7a3b0cb9c29ec9b1e1abac7d2
Gitweb:     http://git.kernel.org/tip/ce74f60eab3cc8b7a3b0cb9c29ec9b1e1abac7d2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 10 Dec 2012 17:29:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:06 -0300

perf hists: Link hist entries before inserting to an output tree

For matching and/or linking hist entries, they need to be sorted by
given sort keys.  However current hists__match/link did this on the
output trees, so that the entries in the output tree need to be resort
before doing it.

This looks not so good since we have trees for collecting or collapsing
entries before passing them to an output tree and they're already sorted
by the given sort keys.  Since we don't need to print anything at the
time of matching/linking, we can use these internal trees directly
instead of bothering with double resort on the output tree.

Its only user - at the time of this writing - perf diff can be easily
converted to use the internal tree and can save some lines too by
getting rid of unnecessary resorting codes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355128197-18193-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 65 +++++++++++++----------------------------------
 tools/perf/util/hist.c    | 49 ++++++++++++++++++++++++++---------
 2 files changed, 54 insertions(+), 60 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4dda6f4..8b896f5 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -275,43 +275,6 @@ static struct perf_tool tool = {
 	.ordering_requires_timestamps = true,
 };
 
-static void insert_hist_entry_by_name(struct rb_root *root,
-				      struct hist_entry *he)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp(iter, he) < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
-}
-
-static void hists__name_resort(struct hists *self)
-{
-	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&self->entries);
-
-	while (next != NULL) {
-		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
-
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &self->entries);
-		insert_hist_entry_by_name(&tmp, n);
-	}
-
-	self->entries = tmp;
-}
-
 static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 				      struct perf_evlist *evlist)
 {
@@ -324,30 +287,34 @@ static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 	return NULL;
 }
 
-static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
+static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		struct hists *hists = &evsel->hists;
 
-		hists__output_resort(hists);
-
-		if (name)
-			hists__name_resort(hists);
+		hists__collapse_resort(hists);
 	}
 }
 
 static void hists__baseline_only(struct hists *hists)
 {
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
 
+	next = rb_first(root);
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
 
-		next = rb_next(&he->rb_node);
+		next = rb_next(&he->rb_node_in);
 		if (!hist_entry__next_pair(he)) {
-			rb_erase(&he->rb_node, &hists->entries);
+			rb_erase(&he->rb_node_in, root);
 			hist_entry__free(he);
 		}
 	}
@@ -471,6 +438,8 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
+	hists__output_resort(new);
+
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
@@ -505,8 +474,8 @@ static int __cmd_diff(void)
 	evlist_old = older->evlist;
 	evlist_new = newer->evlist;
 
-	perf_evlist__resort_hists(evlist_old, true);
-	perf_evlist__resort_hists(evlist_new, false);
+	perf_evlist__collapse_resort(evlist_old);
+	perf_evlist__collapse_resort(evlist_new);
 
 	list_for_each_entry(evsel, &evlist_new->entries, node) {
 		struct perf_evsel *evsel_old;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3a9ccd0..8ff3c2f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -726,16 +726,24 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 						 struct hist_entry *pair)
 {
-	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_root *root;
+	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int cmp;
 
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	p = &root->rb_node;
+
 	while (*p != NULL) {
 		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
+		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(he, pair);
+		cmp = hist_entry__collapse(he, pair);
 
 		if (!cmp)
 			goto out;
@@ -750,8 +758,8 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
-		rb_link_node(&he->rb_node, parent, p);
-		rb_insert_color(&he->rb_node, &hists->entries);
+		rb_link_node(&he->rb_node_in, parent, p);
+		rb_insert_color(&he->rb_node_in, root);
 		hists__inc_nr_entries(hists, he);
 	}
 out:
@@ -761,11 +769,16 @@ out:
 static struct hist_entry *hists__find_entry(struct hists *hists,
 					    struct hist_entry *he)
 {
-	struct rb_node *n = hists->entries.rb_node;
+	struct rb_node *n;
+
+	if (sort__need_collapse)
+		n = hists->entries_collapsed.rb_node;
+	else
+		n = hists->entries_in->rb_node;
 
 	while (n) {
-		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(iter, he);
+		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node_in);
+		int64_t cmp = hist_entry__collapse(iter, he);
 
 		if (cmp < 0)
 			n = n->rb_left;
@@ -783,11 +796,17 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
  */
 void hists__match(struct hists *leader, struct hists *other)
 {
+	struct rb_root *root;
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&leader->entries); nd; nd = rb_next(nd)) {
-		pos  = rb_entry(nd, struct hist_entry, rb_node);
+	if (sort__need_collapse)
+		root = &leader->entries_collapsed;
+	else
+		root = leader->entries_in;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos  = rb_entry(nd, struct hist_entry, rb_node_in);
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
@@ -802,11 +821,17 @@ void hists__match(struct hists *leader, struct hists *other)
  */
 int hists__link(struct hists *leader, struct hists *other)
 {
+	struct rb_root *root;
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
+	if (sort__need_collapse)
+		root = &other->entries_collapsed;
+	else
+		root = other->entries_in;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node_in);
 
 		if (!hist_entry__has_pairs(pos)) {
 			pair = hists__add_dummy_entry(leader, pos);
