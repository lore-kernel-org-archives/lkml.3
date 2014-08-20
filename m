Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbaHTIJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:09:06 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60620 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHTIIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:08:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] perf hists browser: Cleanup callchain print functions
Date: Wed, 20 Aug 2014 17:07:59 +0900
Message-Id: <1408522080-26556-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hist_browser__show_callchain() and friends don't need to be that
complex.  Simplify the function and consolidate the logic into a
single function.  It should have no functional change.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 120 +++++++++++------------------------------
 1 file changed, 32 insertions(+), 88 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d42d8a8f3810..05ff679777a1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -502,26 +502,19 @@ static void hist_browser__show_callchain_entry(struct hist_browser *browser,
 
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
-	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
+	int first_row = row;
+	int offset = level * LEVEL_OFFSET_STEP;
+	bool has_single_node = (rb_first(root) == rb_last(root));
 	u64 new_total;
 
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = chain_node->children_hit;
-	else
-		new_total = total;
-
-	node = rb_first(&chain_node->rb_root);
-	while (node) {
+	for (node = rb_first(root); node; node = rb_next(node)) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
-		struct rb_node *next = rb_next(node);
 		u64 cumul = callchain_cumul_hits(child);
 		struct callchain_list *chain;
 		char folded_sign = ' ';
@@ -535,7 +528,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 
 			if (first)
 				first = false;
-			else
+			else if (!has_single_node || level > 1)
 				extra_offset = LEVEL_OFFSET_STEP;
 
 			folded_sign = callchain_list__folded(chain);
@@ -547,8 +540,9 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			alloc_str = NULL;
 			str = callchain_list__sym_name(chain, bf, sizeof(bf),
 						       browser->show_dso);
-			if (was_first) {
-				double percent = cumul * 100.0 / new_total;
+
+			if (was_first && (!has_single_node || level > 1)) {
+				double percent = cumul * 100.0 / total;
 
 				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
 					str = "Not enough memory!";
@@ -569,80 +563,23 @@ do_next:
 				break;
 		}
 
-		if (folded_sign == '-') {
-			const int new_level = level + (extra_offset ? 2 : 1);
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
-
-		folded_sign = callchain_list__folded(chain);
-
-		if (*row_offset != 0) {
-			--*row_offset;
+		if (folded_sign != '-')
 			continue;
-		}
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
 
-	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		if (callchain_param.mode == CHAIN_GRAPH_REL)
+			new_total = child->children_hit;
+		else
+			new_total = total;
 
-		row += hist_browser__show_callchain_node(browser, node, level,
-							 row, row_offset,
-							 is_current_entry);
+		row += hist_browser__show_callchain(browser, &child->rb_root,
+						    level + 1 + !!extra_offset,
+						    row, row_offset,
+						    new_total,
+						    is_current_entry);
 		if (row == browser->b.rows)
 			break;
 	}
-
+out:
 	return row - first_row;
 }
 
@@ -817,9 +754,16 @@ static int hist_browser__show_entry(struct hist_browser *browser,
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
2.0.0

