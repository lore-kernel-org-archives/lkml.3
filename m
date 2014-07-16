Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbaGPTOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760546AbaGPTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:25 -0400
Date: Wed, 16 Jul 2014 12:13:24 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-xexmwg1mv7u03j5imn66jdak@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Add ->
 rows to disambiguate from ->height
Git-Commit-ID: 62c95ae33f64ecf398f490886f026a6132fb1520
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

Commit-ID:  62c95ae33f64ecf398f490886f026a6132fb1520
Gitweb:     http://git.kernel.org/tip/62c95ae33f64ecf398f490886f026a6132fb1520
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Jul 2014 11:07:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:54 -0300

perf ui browser: Add ->rows to disambiguate from ->height

The ui_browser->height is about the whole browser "window", including
any header, status lines or any other space needed for some "Yes", "No",
etc buttons a descendent browser, like hist_browser, may have.

Since the navigation is done mostly on the ui_browser methods, it needs
to know how many rows are on the screen, while details about what other
components are, say, if a header (that may be composed of multiple
lines, etc) is present.

Besides this we'll need to add a ui_browser->refresh_dimensions() hook
so that browsers like hist_browser can update ->rows in response to
screen resizes, this will come in a follow up patch.

This patch just adds ->rows and updates it when updating ->height, keeps
using ->height for the only other widget that can come with ui_browser,
the scrollbar, that goes on using all the height on the rightmost column
in the screen, using ->rows for the keyboard navigation needs.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xexmwg1mv7u03j5imn66jdak@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c        | 30 +++++++++++++++---------------
 tools/perf/ui/browser.h        |  2 +-
 tools/perf/ui/browsers/hists.c | 16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 9d2294e..adb294a 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -150,7 +150,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *browser)
 	while (nd != NULL) {
 		ui_browser__gotorc(browser, row, 0);
 		browser->write(browser, nd, row);
-		if (++row == browser->height)
+		if (++row == browser->rows)
 			break;
 		nd = rb_next(nd);
 	}
@@ -166,7 +166,7 @@ bool ui_browser__is_current_entry(struct ui_browser *browser, unsigned row)
 void ui_browser__refresh_dimensions(struct ui_browser *browser)
 {
 	browser->width = SLtt_Screen_Cols - 1;
-	browser->height = SLtt_Screen_Rows - 2;
+	browser->height = browser->rows = SLtt_Screen_Rows - 2;
 	browser->y = 1;
 	browser->x = 0;
 }
@@ -389,7 +389,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			if (browser->index == browser->nr_entries - 1)
 				break;
 			++browser->index;
-			if (browser->index == browser->top_idx + browser->height) {
+			if (browser->index == browser->top_idx + browser->rows) {
 				++browser->top_idx;
 				browser->seek(browser, +1, SEEK_CUR);
 			}
@@ -405,10 +405,10 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			break;
 		case K_PGDN:
 		case ' ':
-			if (browser->top_idx + browser->height > browser->nr_entries - 1)
+			if (browser->top_idx + browser->rows > browser->nr_entries - 1)
 				break;
 
-			offset = browser->height;
+			offset = browser->rows;
 			if (browser->index + offset > browser->nr_entries - 1)
 				offset = browser->nr_entries - 1 - browser->index;
 			browser->index += offset;
@@ -419,10 +419,10 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			if (browser->top_idx == 0)
 				break;
 
-			if (browser->top_idx < browser->height)
+			if (browser->top_idx < browser->rows)
 				offset = browser->top_idx;
 			else
-				offset = browser->height;
+				offset = browser->rows;
 
 			browser->index -= offset;
 			browser->top_idx -= offset;
@@ -432,7 +432,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			ui_browser__reset_index(browser);
 			break;
 		case K_END:
-			offset = browser->height - 1;
+			offset = browser->rows - 1;
 			if (offset >= browser->nr_entries)
 				offset = browser->nr_entries - 1;
 
@@ -462,7 +462,7 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 		if (!browser->filter || !browser->filter(browser, pos)) {
 			ui_browser__gotorc(browser, row, 0);
 			browser->write(browser, pos, row);
-			if (++row == browser->height)
+			if (++row == browser->rows)
 				break;
 		}
 	}
@@ -587,7 +587,7 @@ unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
 		if (!browser->filter || !browser->filter(browser, *pos)) {
 			ui_browser__gotorc(browser, row, 0);
 			browser->write(browser, pos, row);
-			if (++row == browser->height)
+			if (++row == browser->rows)
 				break;
 		}
 
@@ -623,7 +623,7 @@ static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 
 	SLsmg_set_char_set(1);
 
-	if (start < browser->top_idx + browser->height) {
+	if (start < browser->top_idx + browser->rows) {
 		row = start - browser->top_idx;
 		ui_browser__gotorc(browser, row, column);
 		SLsmg_write_char(SLSMG_LLCORN_CHAR);
@@ -633,7 +633,7 @@ static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 		if (row-- == 0)
 			goto out;
 	} else
-		row = browser->height - 1;
+		row = browser->rows - 1;
 
 	if (end > browser->top_idx)
 		end_row = end - browser->top_idx;
@@ -675,8 +675,8 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 	} else
 		row = 0;
 
-	if (end >= browser->top_idx + browser->height)
-		end_row = browser->height - 1;
+	if (end >= browser->top_idx + browser->rows)
+		end_row = browser->rows - 1;
 	else
 		end_row = end - browser->top_idx;
 
@@ -684,7 +684,7 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 	SLsmg_draw_vline(end_row - row + 1);
 
 	ui_browser__gotorc(browser, end_row, column);
-	if (end < browser->top_idx + browser->height) {
+	if (end < browser->top_idx + browser->rows) {
 		SLsmg_write_char(SLSMG_LLCORN_CHAR);
 		ui_browser__gotorc(browser, end_row, column + 1);
 		SLsmg_write_char(SLSMG_HLINE_CHAR);
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 03d4d62..cb8f39a 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -14,7 +14,7 @@
 struct ui_browser {
 	u64	      index, top_idx;
 	void	      *top, *entries;
-	u16	      y, x, width, height;
+	u16	      y, x, width, height, rows;
 	int	      current_color;
 	void	      *priv;
 	const char    *title;
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2185091..e16aff4 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -392,10 +392,10 @@ static int hist_browser__run(struct hist_browser *browser,
 			struct hist_entry *h = rb_entry(browser->b.top,
 							struct hist_entry, rb_node);
 			ui_helpline__pop();
-			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
+			ui_helpline__fpush("%d: nr_ent=(%d,%d), rows=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
 					   seq++, browser->b.nr_entries,
 					   browser->hists->nr_entries,
-					   browser->b.height,
+					   browser->b.rows,
 					   browser->b.index,
 					   browser->b.top_idx,
 					   h->row_offset, h->nr_rows);
@@ -514,7 +514,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			slsmg_write_nstring(str, width);
 			free(alloc_str);
 
-			if (++row == browser->b.height)
+			if (++row == browser->b.rows)
 				goto out;
 do_next:
 			if (folded_sign == '+')
@@ -527,7 +527,7 @@ do_next:
 									 new_level, row, row_offset,
 									 is_current_entry);
 		}
-		if (row == browser->b.height)
+		if (row == browser->b.rows)
 			goto out;
 		node = next;
 	}
@@ -573,7 +573,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 		slsmg_printf("%c ", folded_sign);
 		slsmg_write_nstring(s, width - 2);
 
-		if (++row == browser->b.height)
+		if (++row == browser->b.rows)
 			goto out;
 	}
 
@@ -602,7 +602,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 		row += hist_browser__show_callchain_node(browser, node, level,
 							 row, row_offset,
 							 is_current_entry);
-		if (row == browser->b.height)
+		if (row == browser->b.rows)
 			break;
 	}
 
@@ -776,7 +776,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	} else
 		--row_offset;
 
-	if (folded_sign == '-' && row != browser->b.height) {
+	if (folded_sign == '-' && row != browser->b.rows) {
 		printed += hist_browser__show_callchain(browser, &entry->sorted_chain,
 							1, row, &row_offset,
 							&current_entry);
@@ -817,7 +817,7 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 			continue;
 
 		row += hist_browser__show_entry(hb, h, row);
-		if (row == browser->height)
+		if (row == browser->rows)
 			break;
 	}
 
