Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3CRQfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:35:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/54] perf annotate browser: Make browser_disasm_line->percent an array
Date: Mon, 18 Mar 2013 13:25:14 -0300
Message-Id: <1363623939-10748-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Make percent field of struct browser_disasm_line an array and move it to
the last.  This is a preparation of event group view feature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cfae57f..62369f0 100644
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
1.7.1

