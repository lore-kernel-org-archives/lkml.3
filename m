Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaFOQyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFOQxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:53:38 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf tools: Factor ui_browser ops out of ui_browser struct
Date: Sun, 15 Jun 2014 18:53:20 +0200
Message-Id: <1402851203-3083-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
References: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating ops out of 'struct ui_browser' into
'struct ui_browser_ops'.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browser.c           | 37 ++++++++++++++++++++++---------------
 tools/perf/ui/browser.h           | 28 +++++++++++++++++-----------
 tools/perf/ui/browsers/annotate.c | 19 +++++++++++--------
 tools/perf/ui/browsers/header.c   |  8 +++++---
 tools/perf/ui/browsers/hists.c    | 14 ++++++++------
 tools/perf/ui/browsers/map.c      |  8 +++++---
 tools/perf/ui/browsers/scripts.c  |  2 +-
 tools/perf/ui/tui/util.c          |  8 +++++---
 8 files changed, 74 insertions(+), 50 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3ccf6e1..e6f96be 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -46,12 +46,18 @@ void ui_browser__gotorc(struct ui_browser *browser, int y, int x)
 	SLsmg_gotorc(browser->y + y, browser->x + x);
 }
 
+static bool ui_browser__filter(struct ui_browser *browser, void *entry)
+{
+	return browser->ops.filter ? browser->ops.filter(browser, entry) :
+				     false;
+}
+
 static struct list_head *
 ui_browser__list_head_filter_entries(struct ui_browser *browser,
 				     struct list_head *pos)
 {
 	do {
-		if (!browser->filter || !browser->filter(browser, pos))
+		if (!ui_browser__filter(browser, pos))
 			return pos;
 		pos = pos->next;
 	} while (pos != browser->entries);
@@ -64,7 +70,7 @@ ui_browser__list_head_filter_prev_entries(struct ui_browser *browser,
 					  struct list_head *pos)
 {
 	do {
-		if (!browser->filter || !browser->filter(browser, pos))
+		if (!ui_browser__filter(browser, pos))
 			return pos;
 		pos = pos->prev;
 	} while (pos != browser->entries);
@@ -149,7 +155,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *browser)
 
 	while (nd != NULL) {
 		ui_browser__gotorc(browser, row, 0);
-		browser->write(browser, nd, row);
+		browser->ops.write(browser, nd, row);
 		if (++row == browser->height)
 			break;
 		nd = rb_next(nd);
@@ -227,7 +233,7 @@ bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text)
 void ui_browser__reset_index(struct ui_browser *browser)
 {
 	browser->index = browser->top_idx = 0;
-	browser->seek(browser, 0, SEEK_SET);
+	browser->ops.seek(browser, 0, SEEK_SET);
 }
 
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
@@ -302,7 +308,7 @@ static int __ui_browser__refresh(struct ui_browser *browser)
 	int row;
 	int width = browser->width;
 
-	row = browser->refresh(browser);
+	row = browser->ops.refresh(browser);
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
 
 	if (!browser->use_navkeypressed || browser->navkeypressed)
@@ -346,11 +352,12 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	}
 
 	browser->top = NULL;
-	browser->seek(browser, browser->top_idx, SEEK_SET);
+	browser->ops.seek(browser, browser->top_idx, SEEK_SET);
 }
 
 int ui_browser__run(struct ui_browser *browser, int delay_secs)
 {
+	struct ui_browser_ops *ops = &browser->ops;
 	int err, key;
 
 	while (1) {
@@ -391,7 +398,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			++browser->index;
 			if (browser->index == browser->top_idx + browser->height) {
 				++browser->top_idx;
-				browser->seek(browser, +1, SEEK_CUR);
+				ops->seek(browser, +1, SEEK_CUR);
 			}
 			break;
 		case K_UP:
@@ -400,7 +407,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			--browser->index;
 			if (browser->index < browser->top_idx) {
 				--browser->top_idx;
-				browser->seek(browser, -1, SEEK_CUR);
+				ops->seek(browser, -1, SEEK_CUR);
 			}
 			break;
 		case K_PGDN:
@@ -413,7 +420,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 				offset = browser->nr_entries - 1 - browser->index;
 			browser->index += offset;
 			browser->top_idx += offset;
-			browser->seek(browser, +offset, SEEK_CUR);
+			ops->seek(browser, +offset, SEEK_CUR);
 			break;
 		case K_PGUP:
 			if (browser->top_idx == 0)
@@ -426,7 +433,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 
 			browser->index -= offset;
 			browser->top_idx -= offset;
-			browser->seek(browser, -offset, SEEK_CUR);
+			ops->seek(browser, -offset, SEEK_CUR);
 			break;
 		case K_HOME:
 			ui_browser__reset_index(browser);
@@ -438,7 +445,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 
 			browser->index = browser->nr_entries - 1;
 			browser->top_idx = browser->index - offset;
-			browser->seek(browser, -offset, SEEK_END);
+			ops->seek(browser, -offset, SEEK_END);
 			break;
 		default:
 			return key;
@@ -459,9 +466,9 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 	pos = browser->top;
 
 	list_for_each_from(pos, head) {
-		if (!browser->filter || !browser->filter(browser, pos)) {
+		if (!ui_browser__filter(browser, pos)) {
 			ui_browser__gotorc(browser, row, 0);
-			browser->write(browser, pos, row);
+			browser->ops.write(browser, pos, row);
 			if (++row == browser->height)
 				break;
 		}
@@ -584,9 +591,9 @@ unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
 
 	pos = (char **)browser->top;
 	while (idx < browser->nr_entries) {
-		if (!browser->filter || !browser->filter(browser, *pos)) {
+		if (!ui_browser__filter(browser, *pos)) {
 			ui_browser__gotorc(browser, row, 0);
-			browser->write(browser, pos, row);
+			browser->ops.write(browser, pos, row);
 			if (++row == browser->height)
 				break;
 		}
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 03d4d62..5887ca7 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -11,21 +11,27 @@
 #define HE_COLORSET_ADDR	55
 #define HE_COLORSET_ROOT	56
 
-struct ui_browser {
-	u64	      index, top_idx;
-	void	      *top, *entries;
-	u16	      y, x, width, height;
-	int	      current_color;
-	void	      *priv;
-	const char    *title;
-	char	      *helpline;
+struct ui_browser;
+
+struct ui_browser_ops {
 	unsigned int  (*refresh)(struct ui_browser *browser);
 	void	      (*write)(struct ui_browser *browser, void *entry, int row);
 	void	      (*seek)(struct ui_browser *browser, off_t offset, int whence);
 	bool	      (*filter)(struct ui_browser *browser, void *entry);
-	u32	      nr_entries;
-	bool	      navkeypressed;
-	bool	      use_navkeypressed;
+};
+
+struct ui_browser {
+	u64			index, top_idx;
+	void			*top, *entries;
+	u16			y, x, width, height;
+	int			current_color;
+	void			*priv;
+	const char		*title;
+	char			*helpline;
+	u32			nr_entries;
+	bool			navkeypressed;
+	bool			use_navkeypressed;
+	struct ui_browser_ops	ops;
 };
 
 int  ui_browser__set_color(struct ui_browser *browser, int color);
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f0697a3..bc4bcfa 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -388,8 +388,9 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	struct disasm_line *dl;
 	struct browser_disasm_line *bdl;
 	off_t offset = browser->b.index - browser->b.top_idx;
+	struct ui_browser_ops *ops = &browser->b.ops;
 
-	browser->b.seek(&browser->b, offset, SEEK_CUR);
+	ops->seek(&browser->b, offset, SEEK_CUR);
 	dl = list_entry(browser->b.top, struct disasm_line, node);
 	bdl = disasm_line__browser(dl);
 
@@ -399,13 +400,13 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 
 		browser->b.nr_entries = browser->nr_entries;
 		annotate_browser__opts.hide_src_code = false;
-		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		ops->seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx - offset;
 		browser->b.index = bdl->idx;
 	} else {
 		if (bdl->idx_asm < 0) {
 			ui_helpline__puts("Only available for assembly lines.");
-			browser->b.seek(&browser->b, -offset, SEEK_CUR);
+			ops->seek(&browser->b, -offset, SEEK_CUR);
 			return false;
 		}
 
@@ -414,7 +415,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 
 		browser->b.nr_entries = browser->nr_asm_entries;
 		annotate_browser__opts.hide_src_code = true;
-		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		ops->seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx_asm - offset;
 		browser->b.index = bdl->idx_asm;
 	}
@@ -882,10 +883,12 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 	};
 	struct annotate_browser browser = {
 		.b = {
-			.refresh = annotate_browser__refresh,
-			.seek	 = ui_browser__list_head_seek,
-			.write	 = annotate_browser__write,
-			.filter  = disasm_line__filter,
+			.ops = {
+				.refresh = annotate_browser__refresh,
+				.seek	 = ui_browser__list_head_seek,
+				.write	 = annotate_browser__write,
+				.filter  = disasm_line__filter,
+			},
 			.priv	 = &ms,
 			.use_navkeypressed = true,
 		},
diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
index 89c16b9..69f1929 100644
--- a/tools/perf/ui/browsers/header.c
+++ b/tools/perf/ui/browsers/header.c
@@ -81,10 +81,12 @@ static int ui__list_menu(int argc, char * const argv[])
 {
 	struct ui_browser menu = {
 		.entries    = (void *)argv,
-		.refresh    = ui_browser__argv_refresh,
-		.seek	    = ui_browser__argv_seek,
-		.write	    = ui_browser__argv_write,
 		.nr_entries = argc,
+		.ops = {
+			.refresh    = ui_browser__argv_refresh,
+			.seek	    = ui_browser__argv_seek,
+			.write	    = ui_browser__argv_write,
+		},
 	};
 
 	return list_menu__run(&menu);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 04a229a..7cb6309 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1190,8 +1190,8 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 
 	if (browser) {
 		browser->hists = hists;
-		browser->b.refresh = hist_browser__refresh;
-		browser->b.seek = ui_browser__hists_seek;
+		browser->b.ops.refresh = hist_browser__refresh;
+		browser->b.ops.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
 	}
 
@@ -1947,11 +1947,13 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
 		.b = {
+			.ops = {
+				.refresh    = ui_browser__list_head_refresh,
+				.seek	    = ui_browser__list_head_seek,
+				.write	    = perf_evsel_menu__write,
+				.filter	    = filter_group_entries,
+			},
 			.entries    = &evlist->entries,
-			.refresh    = ui_browser__list_head_refresh,
-			.seek	    = ui_browser__list_head_seek,
-			.write	    = perf_evsel_menu__write,
-			.filter	    = filter_group_entries,
 			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index b11639f..6b09cd6 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -103,9 +103,11 @@ int map__browse(struct map *map)
 	struct map_browser mb = {
 		.b = {
 			.entries = &map->dso->symbols[map->type],
-			.refresh = ui_browser__rb_tree_refresh,
-			.seek	 = ui_browser__rb_tree_seek,
-			.write	 = map_browser__write,
+			.ops = {
+				.refresh = ui_browser__rb_tree_refresh,
+				.seek	 = ui_browser__rb_tree_seek,
+				.write	 = map_browser__write,
+			},
 		},
 		.map = map,
 	};
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index 402d2bd..bbbc442 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -116,7 +116,7 @@ int script_browse(const char *script_opt)
 	struct script_line *sline;
 
 	struct perf_script_browser script = {
-		.b = {
+		.b.ops = {
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = script_browser__write,
diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index bf890f7..8ac0465 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -60,10 +60,12 @@ int ui__popup_menu(int argc, char * const argv[])
 {
 	struct ui_browser menu = {
 		.entries    = (void *)argv,
-		.refresh    = ui_browser__argv_refresh,
-		.seek	    = ui_browser__argv_seek,
-		.write	    = ui_browser__argv_write,
 		.nr_entries = argc,
+		.ops        = {
+			.refresh    = ui_browser__argv_refresh,
+			.seek	    = ui_browser__argv_seek,
+			.write	    = ui_browser__argv_write,
+		},
 	};
 
 	return popup_menu__run(&menu);
-- 
1.8.3.1

