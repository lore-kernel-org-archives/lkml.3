Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaHVQaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:30:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:33788 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaHVQaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:22 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/16] perf hists browser: Cleanup callchain print functions
Date: Fri, 22 Aug 2014 13:29:22 -0300
Message-Id: <1408724968-3441-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The hist_browser__show_callchain() and friends don't need to be that
complex.  They're splitted in 3 pieces - one for traversing top-level
tree, other one for special casing first chains in the top-level
entries, and last one for recursive traversing inner trees.  It led to
code duplication and unnecessary complexity IMHO.

Simplify the function and consolidate the logic into a single function
- it can recursively call itself.  A little difference in printing
  callchains in top-level tree can be handled with a small change.

It should have no functional change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408583746-5540-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 112 +++++++++++------------------------------
 1 file changed, 29 insertions(+), 83 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d42d8a8f3810..519353d9f5fb 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -502,23 +502,16 @@ static void hist_browser__show_callchain_entry(struct hist_browser *browser,
 
 #define LEVEL_OFFSET_STEP 3
 
-static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browser,
-						     struct callchain_node *chain_node,
-						     u64 total, int level,
-						     unsigned short row,
-						     off_t *row_offset,
-						     bool *is_current_entry)
+static int hist_browser__show_callchain(struct hist_browser *browser,
+					struct rb_root *root, int level,
+					unsigned short row, off_t *row_offset,
+					u64 total, bool *is_current_entry)
 {
 	struct rb_node *node;
 	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
 	u64 new_total;
 
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = chain_node->children_hit;
-	else
-		new_total = total;
-
-	node = rb_first(&chain_node->rb_root);
+	node = rb_first(root);
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
 		struct rb_node *next = rb_next(node);
@@ -535,7 +528,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 
 			if (first)
 				first = false;
-			else
+			else if (level > 1)
 				extra_offset = LEVEL_OFFSET_STEP;
 
 			folded_sign = callchain_list__folded(chain);
@@ -547,8 +540,9 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			alloc_str = NULL;
 			str = callchain_list__sym_name(chain, bf, sizeof(bf),
 						       browser->show_dso);
-			if (was_first) {
-				double percent = cumul * 100.0 / new_total;
+
+			if (was_first && level > 1) {
+				double percent = cumul * 100.0 / total;
 
 				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
 					str = "Not enough memory!";
@@ -571,78 +565,23 @@ do_next:
 
 		if (folded_sign == '-') {
 			const int new_level = level + (extra_offset ? 2 : 1);
-			row += hist_browser__show_callchain_node_rb_tree(browser, child, new_total,
-									 new_level, row, row_offset,
-									 is_current_entry);
-		}
-		if (row == browser->b.rows)
-			goto out;
-		node = next;
-	}
-out:
-	return row - first_row;
-}
-
-static int hist_browser__show_callchain_node(struct hist_browser *browser,
-					     struct callchain_node *node,
-					     int level, unsigned short row,
-					     off_t *row_offset,
-					     bool *is_current_entry)
-{
-	struct callchain_list *chain;
-	int first_row = row;
-	int offset = level * LEVEL_OFFSET_STEP;
-	char folded_sign = ' ';
-
-	list_for_each_entry(chain, &node->val, list) {
-		char bf[1024], *s;
 
-		folded_sign = callchain_list__folded(chain);
+			if (callchain_param.mode == CHAIN_GRAPH_REL)
+				new_total = child->children_hit;
+			else
+				new_total = total;
 
-		if (*row_offset != 0) {
-			--*row_offset;
-			continue;
+			row += hist_browser__show_callchain(browser, &child->rb_root,
+							    new_level,
+							    row, row_offset,
+							    new_total,
+							    is_current_entry);
 		}
-
-		s = callchain_list__sym_name(chain, bf, sizeof(bf),
-					     browser->show_dso);
-		hist_browser__show_callchain_entry(browser, chain, row,
-						   offset, folded_sign, s,
-						   is_current_entry);
-
-		if (++row == browser->b.rows)
-			goto out;
-	}
-
-	if (folded_sign == '-')
-		row += hist_browser__show_callchain_node_rb_tree(browser, node,
-								 browser->hists->stats.total_period,
-								 level + 1, row,
-								 row_offset,
-								 is_current_entry);
-out:
-	return row - first_row;
-}
-
-static int hist_browser__show_callchain(struct hist_browser *browser,
-					struct rb_root *chain,
-					int level, unsigned short row,
-					off_t *row_offset,
-					bool *is_current_entry)
-{
-	struct rb_node *nd;
-	int first_row = row;
-
-	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-
-		row += hist_browser__show_callchain_node(browser, node, level,
-							 row, row_offset,
-							 is_current_entry);
 		if (row == browser->b.rows)
 			break;
+		node = next;
 	}
-
+out:
 	return row - first_row;
 }
 
@@ -817,9 +756,16 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		--row_offset;
 
 	if (folded_sign == '-' && row != browser->b.rows) {
-		printed += hist_browser__show_callchain(browser, &entry->sorted_chain,
+		u64 total = hists__total_period(entry->hists);
+
+		if (symbol_conf.cumulate_callchain)
+			total = entry->stat_acc->period;
+
+		printed += hist_browser__show_callchain(browser,
+							&entry->sorted_chain,
 							1, row, &row_offset,
-							&current_entry);
+							total, &current_entry);
+
 		if (current_entry)
 			browser->he_selection = entry;
 	}
-- 
1.9.3

