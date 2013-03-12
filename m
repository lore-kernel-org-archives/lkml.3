Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3CLDVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:21:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52529 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3CLDVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:21:30 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-a8-513e9f38a3d7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 00/12] perf annotate: Add support for event group view (v2)
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
	<20130311205316.GA11779@ghostprotocols.net>
Date: Tue, 12 Mar 2013 12:21:27 +0900
In-Reply-To: <20130311205316.GA11779@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 11 Mar 2013 17:53:16 -0300")
Message-ID: <878v5tl2vc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 11 Mar 2013 17:53:16 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 05, 2013 at 02:53:20PM +0900, Namhyung Kim escreveu:
>> This patchset implements event group view on perf annotate.  It's
>> basically a rebased version and major difference to prior version is
>> the GTK annotation browser support.
>
>> Here goes an example:
>
>>  $ perf annotate --group --stdio
>
>>   crtstuff.c:0
>>      8.08    2.40    5.29 :        387dc0aa50:   mov    %rdi,%rdx
>
>
> I applied this series minus the TUI enabling one, as it is not working,
> so right now my perf/core has --group --stdio and --group --gtk working,
> please take a look at --group --tui.

Thanks, I took a look at the TUI code and found some missing pieces and
bugs.  Those code were in the original version but seems to get lost
during the cherry-picking and I tested wrong version. :(

>
> I need to go thru this more thoroughly, as at least one thing caught my
> attention, in some cases ->nr_pcnt is used and in others
> evsel->nr_members, do we need both?

Probably not.  I was thought keeping an array and its length together is
better.  But it's rather a waste to save the same information to every
date structure so I move it to the struct annotate_browser->nr_events.

For evsel->nr_members, current code sets it only for grouping is enabled
so the individual events will have value of 0.  Also it's not pass the
evsel to every function need it.  But if you think it should really be
fixed that way I can make the change to pass and use evsel->nr_members.

Anyway, below is a fixed version that could survived my testing.



>From 9d2948c274c4958ebde866adb28951f44e0595eb Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 10 Nov 2012 01:21:02 +0900
Subject: [PATCH] perf annotate browser: Support event group view on TUI

Dynamically allocate browser_disasm_line according to a number of
group members.  This way we can handle multiple events in a general
manner.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 93 +++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 8b16926dd56e..f56247a03a22 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -17,6 +17,10 @@ struct browser_disasm_line {
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	/*
+	 * actual length of this array is saved on the nr_events field
+	 * of the struct annotate_browser
+	 */
 	double		percent[1];
 };
 
@@ -34,8 +38,9 @@ struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
-	struct disasm_line	  *selection;
+	struct disasm_line  *selection;
 	struct disasm_line  **offsets;
+	int		    nr_events;
 	u64		    start;
 	int		    nr_asm_entries;
 	int		    nr_entries;
@@ -95,14 +100,24 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 			     (!current_entry || (browser->use_navkeypressed &&
 					         !browser->navkeypressed)));
 	int width = browser->width, printed;
+	int i, pcnt_width = 7 * ab->nr_events;
+	double percent_max = 0.0;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent[0] != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent[0], current_entry);
-		slsmg_printf("%6.2f ", bdl->percent[0]);
+	for (i = 0; i < ab->nr_events; i++) {
+		if (bdl->percent[i] > percent_max)
+			percent_max = bdl->percent[i];
+	}
+
+	if (dl->offset != -1 && percent_max != 0.0) {
+		for (i = 0; i < ab->nr_events; i++) {
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
@@ -112,12 +127,12 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
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
@@ -176,7 +191,7 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		}
 
 		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
-		slsmg_write_nstring(bf, width - 10 - printed);
+		slsmg_write_nstring(bf, width - pcnt_width - 3 - printed);
 	}
 
 	if (current_entry)
@@ -201,6 +216,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	unsigned int from, to;
 	struct map_symbol *ms = ab->b.priv;
 	struct symbol *sym = ms->sym;
+	u8 pcnt_width = 7;
 
 	/* PLT symbols contain external offsets */
 	if (strstr(sym->name, "@plt"))
@@ -224,23 +240,44 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 		to = (u64)btarget->idx;
 	}
 
+	pcnt_width *= ab->nr_events;
+
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
-	__ui_browser__line_arrow(browser, 9 + ab->addr_width, from, to);
+	__ui_browser__line_arrow(browser, pcnt_width + 2 + ab->addr_width,
+				 from, to);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	int ret = ui_browser__list_head_refresh(browser);
+	int pcnt_width;
+
+	pcnt_width = 7 * ab->nr_events;
 
 	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
-	__ui_browser__vline(browser, 7, 0, browser->height - 1);
+	__ui_browser__vline(browser, pcnt_width, 0, browser->height - 1);
 	return ret;
 }
 
-static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
+static int disasm__cmp(struct browser_disasm_line *a,
+		       struct browser_disasm_line *b, int nr_pcnt)
+{
+	int i;
+
+	for (i = 0; i < nr_pcnt; i++) {
+		if (a->percent[i] == b->percent[i])
+			continue;
+		return a->percent[i] < b->percent[i];
+	}
+	return 0;
+}
+
+static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl,
+				   int nr_events)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -249,7 +286,8 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent[0] < l->percent[0])
+
+		if (disasm__cmp(bdl, l, nr_events))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -313,6 +351,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
 		const char *path = NULL;
+		double max_percent = 0.0;
+		int i;
 
 		if (pos->offset == -1) {
 			RB_CLEAR_NODE(&bpos->rb_node);
@@ -320,15 +360,24 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 		}
 
 		next = disasm__get_next_ip_line(&notes->src->source, pos);
-		bpos->percent[0] = disasm__calc_percent(notes, evsel->idx,
-					pos->offset, next ? next->offset : len,
-				        &path);
 
-		if (bpos->percent[0] < 0.01) {
+		for (i = 0; i < browser->nr_events; i++) {
+			bpos->percent[i] = disasm__calc_percent(notes,
+						evsel->idx + i,
+						pos->offset,
+						next ? next->offset : len,
+					        &path);
+
+			if (max_percent < bpos->percent[i])
+				max_percent = bpos->percent[i];
+		}
+
+		if (max_percent < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
 		}
-		disasm_rb_tree__insert(&browser->entries, bpos);
+		disasm_rb_tree__insert(&browser->entries, bpos,
+				       browser->nr_events);
 	}
 	pthread_mutex_unlock(&notes->lock);
 
@@ -829,6 +878,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		},
 	};
 	int ret = -1;
+	int nr_pcnt = 1;
+	size_t sizeof_bdl = sizeof(struct browser_disasm_line);
 
 	if (sym == NULL)
 		return -1;
@@ -844,7 +895,12 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		return -1;
 	}
 
-	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
+	if (perf_evsel__is_group_event(evsel)) {
+		nr_pcnt = evsel->nr_members;
+		sizeof_bdl += sizeof(double) * (nr_pcnt - 1);
+	}
+
+	if (symbol__annotate(sym, map, sizeof_bdl) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
 		goto out_free_offsets;
 	}
@@ -882,6 +938,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 	browser.addr_width = browser.target_width = browser.min_addr_width = hex_width(size);
 	browser.max_addr_width = hex_width(sym->end);
 	browser.jumps_width = width_jumps(browser.max_jump_sources);
+	browser.nr_events = nr_pcnt;
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-- 
1.7.11.7

