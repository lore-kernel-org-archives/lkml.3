Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaHUBQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:16:11 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55968 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaHUBQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:16:06 -0400
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
Subject: [PATCH v2 2/2] perf hists browser: Consolidate callchain print functions in TUI
Date: Thu, 21 Aug 2014 10:15:46 +0900
Message-Id: <1408583746-5540-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there're two callchain print functions in TUI - one for the
hists browser and another for file dump.  They do almost same job so
it'd be better consolidate the codes.

To do that, move row calculation code into a print callback so that
the dump code cannot be limited by the current screen size.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 210 +++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 134 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 519353d9f5fb..48d8c8eee6c2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -477,20 +477,32 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
 	return bf;
 }
 
+struct callchain_print_arg {
+	/* for hists browser */
+	unsigned short row;
+	off_t row_offset;
+	bool is_current_entry;
+
+	/* for file dump */
+	FILE *fp;
+	int printed;
+};
+
 static void hist_browser__show_callchain_entry(struct hist_browser *browser,
 					       struct callchain_list *chain,
-					       unsigned short row, int offset,
-					       char folded_sign, const char *str,
-					       bool *is_current_entry)
+					       const char *str, int offset,
+					       struct callchain_print_arg *arg)
 {
 	int color, width;
+	unsigned short row = arg->row;
+	char folded_sign = callchain_list__folded(chain);
 
 	color = HE_COLORSET_NORMAL;
 	width = browser->b.width - (offset + 2);
 	if (ui_browser__is_current_entry(&browser->b, row)) {
 		browser->selection = &chain->ms;
 		color = HE_COLORSET_SELECTED;
-		*is_current_entry = true;
+		arg->is_current_entry = true;
 	}
 
 	ui_browser__set_color(&browser->b, color);
@@ -498,17 +510,40 @@ static void hist_browser__show_callchain_entry(struct hist_browser *browser,
 	slsmg_write_nstring(" ", offset);
 	slsmg_printf("%c ", folded_sign);
 	slsmg_write_nstring(str, width);
+
+	/*
+	 * increase row here so that we can reuse the
+	 * hist_browser__show_callchain() for dumping the whole
+	 * callchain to a file.
+	 */
+	arg->row++;
+}
+
+static void hist_browser__fprintf_callchain_entry(struct hist_browser *b __maybe_unused,
+						  struct callchain_list *chain,
+						  const char *str, int offset,
+						  struct callchain_print_arg *arg)
+{
+	char folded_sign = callchain_list__folded(chain);
+
+	arg->printed += fprintf(arg->fp, "%*s%c %s\n", offset, " ",
+				folded_sign, str);
 }
 
+typedef void (*print_callchain_entry_fn)(struct hist_browser *browser,
+					 struct callchain_list *chain,
+					 const char *str, int offset,
+					 struct callchain_print_arg *arg);
+
 #define LEVEL_OFFSET_STEP 3
 
 static int hist_browser__show_callchain(struct hist_browser *browser,
-					struct rb_root *root, int level,
-					unsigned short row, off_t *row_offset,
-					u64 total, bool *is_current_entry)
+					struct rb_root *root, int level, u64 total,
+					print_callchain_entry_fn print,
+					struct callchain_print_arg *arg)
 {
 	struct rb_node *node;
-	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
+	int first_row = arg->row, offset = level * LEVEL_OFFSET_STEP;
 	u64 new_total;
 
 	node = rb_first(root);
@@ -532,8 +567,8 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 				extra_offset = LEVEL_OFFSET_STEP;
 
 			folded_sign = callchain_list__folded(chain);
-			if (*row_offset != 0) {
-				--*row_offset;
+			if (arg->row_offset != 0) {
+				arg->row_offset--;
 				goto do_next;
 			}
 
@@ -550,13 +585,11 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 					str = alloc_str;
 			}
 
-			hist_browser__show_callchain_entry(browser, chain, row,
-							   offset + extra_offset,
-							   folded_sign, str,
-							   is_current_entry);
+			print(browser, chain, str, offset + extra_offset, arg);
+
 			free(alloc_str);
 
-			if (++row == browser->b.rows)
+			if (arg->row == browser->b.rows)
 				goto out;
 do_next:
 			if (folded_sign == '+')
@@ -571,18 +604,16 @@ do_next:
 			else
 				new_total = total;
 
-			row += hist_browser__show_callchain(browser, &child->rb_root,
-							    new_level,
-							    row, row_offset,
-							    new_total,
-							    is_current_entry);
+			hist_browser__show_callchain(browser, &child->rb_root,
+						     new_level, new_total,
+						     print, arg);
 		}
-		if (row == browser->b.rows)
+		if (arg->row == browser->b.rows)
 			break;
 		node = next;
 	}
 out:
-	return row - first_row;
+	return arg->row - first_row;
 }
 
 struct hpp_arg {
@@ -757,16 +788,21 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 	if (folded_sign == '-' && row != browser->b.rows) {
 		u64 total = hists__total_period(entry->hists);
+		struct callchain_print_arg arg = {
+			.row = row,
+			.row_offset = row_offset,
+			.is_current_entry = current_entry,
+		};
 
 		if (symbol_conf.cumulate_callchain)
 			total = entry->stat_acc->period;
 
 		printed += hist_browser__show_callchain(browser,
-							&entry->sorted_chain,
-							1, row, &row_offset,
-							total, &current_entry);
+					&entry->sorted_chain, 1, total,
+					hist_browser__show_callchain_entry,
+					&arg);
 
-		if (current_entry)
+		if (arg.is_current_entry)
 			browser->he_selection = entry;
 	}
 
@@ -1022,112 +1058,6 @@ do_offset:
 	}
 }
 
-static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *browser,
-							struct callchain_node *chain_node,
-							u64 total, int level,
-							FILE *fp)
-{
-	struct rb_node *node;
-	int offset = level * LEVEL_OFFSET_STEP;
-	u64 new_total;
-	int printed = 0;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = chain_node->children_hit;
-	else
-		new_total = total;
-
-	node = rb_first(&chain_node->rb_root);
-	while (node) {
-		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
-		struct rb_node *next = rb_next(node);
-		u64 cumul = callchain_cumul_hits(child);
-		struct callchain_list *chain;
-		char folded_sign = ' ';
-		int first = true;
-		int extra_offset = 0;
-
-		list_for_each_entry(chain, &child->val, list) {
-			char bf[1024], *alloc_str;
-			const char *str;
-			bool was_first = first;
-
-			if (first)
-				first = false;
-			else
-				extra_offset = LEVEL_OFFSET_STEP;
-
-			folded_sign = callchain_list__folded(chain);
-
-			alloc_str = NULL;
-			str = callchain_list__sym_name(chain, bf, sizeof(bf),
-						       browser->show_dso);
-			if (was_first) {
-				double percent = cumul * 100.0 / new_total;
-
-				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
-					str = "Not enough memory!";
-				else
-					str = alloc_str;
-			}
-
-			printed += fprintf(fp, "%*s%c %s\n", offset + extra_offset, " ", folded_sign, str);
-			free(alloc_str);
-			if (folded_sign == '+')
-				break;
-		}
-
-		if (folded_sign == '-') {
-			const int new_level = level + (extra_offset ? 2 : 1);
-			printed += hist_browser__fprintf_callchain_node_rb_tree(browser, child, new_total,
-										new_level, fp);
-		}
-
-		node = next;
-	}
-
-	return printed;
-}
-
-static int hist_browser__fprintf_callchain_node(struct hist_browser *browser,
-						struct callchain_node *node,
-						int level, FILE *fp)
-{
-	struct callchain_list *chain;
-	int offset = level * LEVEL_OFFSET_STEP;
-	char folded_sign = ' ';
-	int printed = 0;
-
-	list_for_each_entry(chain, &node->val, list) {
-		char bf[1024], *s;
-
-		folded_sign = callchain_list__folded(chain);
-		s = callchain_list__sym_name(chain, bf, sizeof(bf), browser->show_dso);
-		printed += fprintf(fp, "%*s%c %s\n", offset, " ", folded_sign, s);
-	}
-
-	if (folded_sign == '-')
-		printed += hist_browser__fprintf_callchain_node_rb_tree(browser, node,
-									browser->hists->stats.total_period,
-									level + 1,  fp);
-	return printed;
-}
-
-static int hist_browser__fprintf_callchain(struct hist_browser *browser,
-					   struct rb_root *chain, int level, FILE *fp)
-{
-	struct rb_node *nd;
-	int printed = 0;
-
-	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
-		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-
-		printed += hist_browser__fprintf_callchain_node(browser, node, level, fp);
-	}
-
-	return printed;
-}
-
 static int hist_browser__fprintf_entry(struct hist_browser *browser,
 				       struct hist_entry *he, FILE *fp)
 {
@@ -1163,8 +1093,20 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	}
 	printed += fprintf(fp, "%s\n", rtrim(s));
 
-	if (folded_sign == '-')
-		printed += hist_browser__fprintf_callchain(browser, &he->sorted_chain, 1, fp);
+	if (folded_sign == '-') {
+		u64 total = hists__total_period(he->hists);
+		struct callchain_print_arg arg  = {
+			.fp = fp,
+		};
+
+		if (symbol_conf.cumulate_callchain)
+			total = he->stat_acc->period;
+
+		hist_browser__show_callchain(browser, &he->sorted_chain, 1, total,
+					     hist_browser__fprintf_callchain_entry,
+					     &arg);
+		printed += arg.printed;
+	}
 
 	return printed;
 }
-- 
2.0.0

