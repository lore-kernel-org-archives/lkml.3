Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHXO6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:58:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaHXO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:58:04 -0400
Date: Sun, 24 Aug 2014 07:57:40 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f4536ddd20d93b70d432b7ca5db873525e23c2c4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1408522080-26556-3-git-send-email-namhyung@kernel.org>
References: <1408522080-26556-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Factor out hist_browser__show_callchain_entry()
Git-Commit-ID: f4536ddd20d93b70d432b7ca5db873525e23c2c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4536ddd20d93b70d432b7ca5db873525e23c2c4
Gitweb:     http://git.kernel.org/tip/f4536ddd20d93b70d432b7ca5db873525e23c2c4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 20 Aug 2014 17:07:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Aug 2014 12:14:58 -0300

perf hists browser: Factor out hist_browser__show_callchain_entry()

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
index 2f34c6b..d42d8a8 100644
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
