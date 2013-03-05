Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab3CEFyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:54:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622Ab3CEFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:54 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-24-5135886e4651
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 11/12] perf annotate browser: Support event group view on TUI
Date: Tue,  5 Mar 2013 14:53:31 +0900
Message-Id: <1362462812-30885-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate browser_disasm_line according to a number of
group members and save nr_pcnt to the struct.  This way we can
handle multiple events in a general manner.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 67 +++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 8b16926dd56e..95d5998fe57e 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -17,6 +17,7 @@ struct browser_disasm_line {
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	int		nr_pcnt;
 	double		percent[1];
 };
 
@@ -95,14 +96,24 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 			     (!current_entry || (browser->use_navkeypressed &&
 					         !browser->navkeypressed)));
 	int width = browser->width, printed;
+	int i, pcnt_width = 7 * bdl->nr_pcnt;
+	double percent_max = 0.0;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent[0] != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent[0], current_entry);
-		slsmg_printf("%6.2f ", bdl->percent[0]);
+	for (i = 0; i < bdl->nr_pcnt; i++) {
+		if (bdl->percent[i] > percent_max)
+			percent_max = bdl->percent[i];
+	}
+
+	if (dl->offset != -1 && percent_max != 0.0) {
+		for (i = 0; i < bdl->nr_pcnt; i++) {
+			ui_browser__set_percent_color(browser, bdl->percent[i],
+						      current_entry);
+			slsmg_printf("%6.2f ", bdl->percent[i]);
+		}
 	} else {
 		ui_browser__set_percent_color(browser, 0, current_entry);
-		slsmg_write_nstring(" ", 7);
+		slsmg_write_nstring(" ", pcnt_width);
 	}
 
 	SLsmg_write_char(' ');
@@ -112,12 +123,12 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		width += 1;
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 7);
+		slsmg_write_nstring(" ", width - pcnt_width);
 	else if (dl->offset == -1) {
 		printed = scnprintf(bf, sizeof(bf), "%*s  ",
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
-		slsmg_write_nstring(dl->line, width - printed - 6);
+		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
 	} else {
 		u64 addr = dl->offset;
 		int color = -1;
@@ -176,7 +187,7 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		}
 
 		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
-		slsmg_write_nstring(bf, width - 10 - printed);
+		slsmg_write_nstring(bf, width - pcnt_width - 3 - printed);
 	}
 
 	if (current_entry)
@@ -201,6 +212,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	unsigned int from, to;
 	struct map_symbol *ms = ab->b.priv;
 	struct symbol *sym = ms->sym;
+	u8 pcnt_width = 7;
 
 	/* PLT symbols contain external offsets */
 	if (strstr(sym->name, "@plt"))
@@ -224,22 +236,48 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 		to = (u64)btarget->idx;
 	}
 
+	pcnt_width *= bcursor->nr_pcnt;
+
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
-	__ui_browser__line_arrow(browser, 9 + ab->addr_width, from, to);
+	__ui_browser__line_arrow(browser, pcnt_width + 2 + ab->addr_width,
+				 from, to);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
+	struct annotate_browser *ab;
+	struct disasm_line *cursor;
+	struct browser_disasm_line *bcursor;
 	int ret = ui_browser__list_head_refresh(browser);
+	int pcnt_width;
+
+	ab = container_of(browser, struct annotate_browser, b);
+	cursor = ab->offsets[0];
+	bcursor = disasm_line__browser(cursor);
+
+	pcnt_width = 7 * bcursor->nr_pcnt;
 
 	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
-	__ui_browser__vline(browser, 7, 0, browser->height - 1);
+	__ui_browser__vline(browser, pcnt_width, 0, browser->height - 1);
 	return ret;
 }
 
+static int disasm__cmp(struct browser_disasm_line *a,
+		       struct browser_disasm_line *b)
+{
+	int i;
+
+	for (i = 0; i < a->nr_pcnt; i++) {
+		if (a->percent[i] == b->percent[i])
+			continue;
+		return a->percent[i] < b->percent[i];
+	}
+	return 0;
+}
+
 static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
 {
 	struct rb_node **p = &root->rb_node;
@@ -249,7 +287,8 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent[0] < l->percent[0])
+
+		if (disasm__cmp(bdl, l))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -829,6 +868,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		},
 	};
 	int ret = -1;
+	int nr_pcnt = 1;
+	size_t sizeof_bdl = sizeof(struct browser_disasm_line);
 
 	if (sym == NULL)
 		return -1;
@@ -844,6 +885,11 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		return -1;
 	}
 
+	if (perf_evsel__is_group_event(evsel)) {
+		nr_pcnt = evsel->nr_members;
+		sizeof_bdl += sizeof(double) * (nr_pcnt - 1);
+	}
+
 	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
 		goto out_free_offsets;
@@ -861,6 +907,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
 		bpos = disasm_line__browser(pos);
+		bpos->nr_pcnt = nr_pcnt;
 		bpos->idx = browser.nr_entries++;
 		if (pos->offset != -1) {
 			bpos->idx_asm = browser.nr_asm_entries++;
-- 
1.7.11.7

