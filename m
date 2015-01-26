Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbbAZRse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:48:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:52961 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbbAZRsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:30 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/26] perf diff: Get rid of hists__compute_resort()
Date: Mon, 26 Jan 2015 14:47:16 -0300
Message-Id: <1422294449-12735-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The hists__compute_resort() is to sort output fields based on the
given field/criteria.  This was done without the sort list but as we
added the field to the sort list, we can do it with normal
hists__output_resort() using the ->sort callback.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1419656793-32756-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 59 +++--------------------------------------------
 1 file changed, 3 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 318ab9c3f0ba..72c718e6549c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -581,68 +581,15 @@ hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
 	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
 }
 
-static void insert_hist_entry_by_compute(struct rb_root *root,
-					 struct hist_entry *he,
-					 int c)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp_compute(he, iter, c) < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
-}
-
-static void hists__compute_resort(struct hists *hists)
-{
-	struct rb_root *root;
-	struct rb_node *next;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	hists->entries = RB_ROOT;
-	next = rb_first(root);
-
-	hists__reset_stats(hists);
-	hists__reset_col_len(hists);
-
-	while (next != NULL) {
-		struct hist_entry *he;
-
-		he = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&he->rb_node_in);
-
-		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_stats(hists, he);
-
-		if (!he->filtered)
-			hists__calc_col_len(hists, he);
-	}
-}
-
 static void hists__process(struct hists *hists)
 {
 	if (show_baseline_only)
 		hists__baseline_only(hists);
 
-	if (sort_compute) {
+	if (sort_compute)
 		hists__precompute(hists);
-		hists__compute_resort(hists);
-	} else {
-		hists__output_resort(hists, NULL);
-	}
+
+	hists__output_resort(hists, NULL);
 
 	hists__fprintf(hists, true, 0, 0, 0, stdout);
 }
-- 
1.9.3

