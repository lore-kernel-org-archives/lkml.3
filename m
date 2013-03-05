Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3CEFxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:53:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab3CEFxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:52 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-14-5135886cd331
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 09/12] perf annotate browser: Make browser_disasm_line->percent an array
Date: Tue,  5 Mar 2013 14:53:29 +0900
Message-Id: <1362462812-30885-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make percent field of struct browser_disasm_line an array and
move it to the last.  This is a preparation of event group view
feature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cfae57f90146..62369f0b6608 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -14,10 +14,10 @@
 
 struct browser_disasm_line {
 	struct rb_node	rb_node;
-	double		percent;
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	double		percent[1];
 };
 
 static struct annotate_browser_opt {
@@ -97,9 +97,9 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 	int width = browser->width, printed;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent, current_entry);
-		slsmg_printf("%6.2f ", bdl->percent);
+	if (dl->offset != -1 && bdl->percent[0] != 0.0) {
+		ui_browser__set_percent_color(browser, bdl->percent[0], current_entry);
+		slsmg_printf("%6.2f ", bdl->percent[0]);
 	} else {
 		ui_browser__set_percent_color(browser, 0, current_entry);
 		slsmg_write_nstring(" ", 7);
@@ -283,7 +283,7 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent < l->percent)
+		if (bdl->percent[0] < l->percent[0])
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -345,8 +345,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent = disasm_line__calc_percent(pos, sym, evsel->idx);
-		if (bpos->percent < 0.01) {
+		bpos->percent[0] = disasm_line__calc_percent(pos, sym, evsel->idx);
+		if (bpos->percent[0] < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
 		}
-- 
1.7.11.7

