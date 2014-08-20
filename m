Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaHTIIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:08:11 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60603 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTIIE (ORCPT
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
Subject: [PATCH 2/5] perf hists browser: Factor out hist_browser__show_callchain_entry()
Date: Wed, 20 Aug 2014 17:07:57 +0900
Message-Id: <1408522080-26556-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out duplicate callchain printing code into the hist_browser__
show_callchain_entry().

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 64 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4892480e8298..2abb0c5cbbaa 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -477,6 +477,29 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
 	return bf;
 }
 
+static void hist_browser__show_callchain_entry(struct hist_browser *browser,
+					       struct callchain_list *chain,
+					       unsigned short row, int offset,
+					       char folded_sign, const char *str,
+					       bool *is_current_entry)
+{
+	int color, width;
+
+	color = HE_COLORSET_NORMAL;
+	width = browser->b.width - (offset + 2);
+	if (ui_browser__is_current_entry(&browser->b, row)) {
+		browser->selection = &chain->ms;
+		color = HE_COLORSET_SELECTED;
+		*is_current_entry = true;
+	}
+
+	ui_browser__set_color(&browser->b, color);
+	hist_browser__gotorc(browser, row, 0);
+	slsmg_write_nstring(" ", offset);
+	slsmg_printf("%c ", folded_sign);
+	slsmg_write_nstring(str, width);
+}
+
 #define LEVEL_OFFSET_STEP 3
 
 static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browser,
@@ -487,7 +510,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 						     bool *is_current_entry)
 {
 	struct rb_node *node;
-	int first_row = row, width, offset = level * LEVEL_OFFSET_STEP;
+	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
 	u64 new_total, remaining;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
@@ -511,7 +534,6 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
-			int color;
 			bool was_first = first;
 
 			if (first)
@@ -537,19 +559,10 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 					str = alloc_str;
 			}
 
-			color = HE_COLORSET_NORMAL;
-			width = browser->b.width - (offset + extra_offset + 2);
-			if (ui_browser__is_current_entry(&browser->b, row)) {
-				browser->selection = &chain->ms;
-				color = HE_COLORSET_SELECTED;
-				*is_current_entry = true;
-			}
-
-			ui_browser__set_color(&browser->b, color);
-			hist_browser__gotorc(browser, row, 0);
-			slsmg_write_nstring(" ", offset + extra_offset);
-			slsmg_printf("%c ", folded_sign);
-			slsmg_write_nstring(str, width);
+			hist_browser__show_callchain_entry(browser, chain, row,
+							   offset + extra_offset,
+							   folded_sign, str,
+							   is_current_entry);
 			free(alloc_str);
 
 			if (++row == browser->b.rows)
@@ -580,14 +593,12 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 					     bool *is_current_entry)
 {
 	struct callchain_list *chain;
-	int first_row = row,
-	     offset = level * LEVEL_OFFSET_STEP,
-	     width = browser->b.width - offset;
+	int first_row = row;
+	int offset = level * LEVEL_OFFSET_STEP;
 	char folded_sign = ' ';
 
 	list_for_each_entry(chain, &node->val, list) {
 		char bf[1024], *s;
-		int color;
 
 		folded_sign = callchain_list__folded(chain);
 
@@ -596,20 +607,11 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 			continue;
 		}
 
-		color = HE_COLORSET_NORMAL;
-		if (ui_browser__is_current_entry(&browser->b, row)) {
-			browser->selection = &chain->ms;
-			color = HE_COLORSET_SELECTED;
-			*is_current_entry = true;
-		}
-
 		s = callchain_list__sym_name(chain, bf, sizeof(bf),
 					     browser->show_dso);
-		hist_browser__gotorc(browser, row, 0);
-		ui_browser__set_color(&browser->b, color);
-		slsmg_write_nstring(" ", offset);
-		slsmg_printf("%c ", folded_sign);
-		slsmg_write_nstring(s, width - 2);
+		hist_browser__show_callchain_entry(browser, chain, row,
+						   offset, folded_sign, s,
+						   is_current_entry);
 
 		if (++row == browser->b.rows)
 			goto out;
-- 
2.0.0

