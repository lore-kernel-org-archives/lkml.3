Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaHVQaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:30:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:33666 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaHVQaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/16] perf hists browser: Factor out hist_browser__show_callchain_entry()
Date: Fri, 22 Aug 2014 13:29:17 -0300
Message-Id: <1408724968-3441-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Factor out duplicate callchain printing code into the hist_browser__
show_callchain_entry().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408522080-26556-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 64 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2f34c6b6d5dc..d42d8a8f3810 100644
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
 	u64 new_total;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
@@ -508,7 +531,6 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		list_for_each_entry(chain, &child->val, list) {
 			char bf[1024], *alloc_str;
 			const char *str;
-			int color;
 			bool was_first = first;
 
 			if (first)
@@ -534,19 +556,10 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
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
@@ -577,14 +590,12 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
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
 
@@ -593,20 +604,11 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
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
1.9.3

