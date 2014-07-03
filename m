Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbaGCVnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:43:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:53817 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759711AbaGCVni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:43:38 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf hists browser: Add support for showing columns header
Date: Thu,  3 Jul 2014 18:42:58 -0300
Message-Id: <1404423780-24026-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404423780-24026-1-git-send-email-acme@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <jolsa@kernel.org>

Open up space to show a one-line header text whenever 'H' is pressed,
hide it on another key press.

Follow up patch will format this line from the set of headers used.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-m894d6qk30h3qofw4k8neq4q@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ef7abf896f5a..2be71bf17b71 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,6 +26,7 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
+	bool		     show_headers;
 	float		     min_pcnt;
 	u64		     nr_non_filtered_entries;
 	u64		     nr_callchain_rows;
@@ -56,6 +57,21 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
 	return nr_entries + hb->nr_callchain_rows;
 }
 
+static void hist_browser__update_rows(struct hist_browser *hb)
+{
+	struct ui_browser *browser = &hb->b;
+	u16 header_offset = hb->show_headers ? 1 : 0, index_row;
+
+	browser->rows = browser->height - header_offset;
+	/*
+	 * Verify if we were at the last line and that line isn't
+	 * visibe because we now show the header line(s).
+	 */
+	index_row = browser->index - browser->top_idx;
+	if (index_row >= browser->rows)
+		browser->index -= index_row - browser->rows + 1;
+}
+
 static void hist_browser__refresh_dimensions(struct ui_browser *browser)
 {
 	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
@@ -69,11 +85,14 @@ static void hist_browser__refresh_dimensions(struct ui_browser *browser)
  	 *	  changeset.
  	 */
 	ui_browser__refresh_dimensions(browser);
+	hist_browser__update_rows(hb);
 }
 
 static void hist_browser__gotorc(struct hist_browser *browser, int row, int column)
 {
-	ui_browser__gotorc(&browser->b, row, column);
+	u16 header_offset = browser->show_headers ? 1 : 0;
+
+	ui_browser__gotorc(&browser->b, row + header_offset, column);
 }
 
 static void hist_browser__reset(struct hist_browser *browser)
@@ -421,6 +440,10 @@ static int hist_browser__run(struct hist_browser *browser,
 			/* Expand the whole world. */
 			hist_browser__set_folding(browser, true);
 			break;
+		case 'H':
+			browser->show_headers = !browser->show_headers;
+			hist_browser__update_rows(browser);
+			break;
 		case K_ENTER:
 			if (hist_browser__toggle_fold(browser))
 				break;
@@ -799,6 +822,13 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	return printed;
 }
 
+static void hist_browser__show_headers(struct hist_browser *browser)
+{
+	ui_browser__gotorc(&browser->b, 0, 0);
+	ui_browser__set_color(&browser->b, HE_COLORSET_ROOT);
+	slsmg_write_nstring(" ", browser->b.width + 1);
+}
+
 static void ui_browser__hists_init_top(struct ui_browser *browser)
 {
 	if (browser->top == NULL) {
@@ -812,9 +842,15 @@ static void ui_browser__hists_init_top(struct ui_browser *browser)
 static unsigned int hist_browser__refresh(struct ui_browser *browser)
 {
 	unsigned row = 0;
+	u16 header_offset = 0;
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
 
+	if (hb->show_headers) {
+		hist_browser__show_headers(hb);
+		header_offset = 1;
+	}
+
 	ui_browser__hists_init_top(browser);
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
@@ -833,7 +869,7 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 			break;
 	}
 
-	return row;
+	return row + header_offset;
 }
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -1205,6 +1241,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh_dimensions = hist_browser__refresh_dimensions;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
+		browser->show_headers = false;
 	}
 
 	return browser;
@@ -1434,6 +1471,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
 	"F             Toggle percentage of filtered entries\n"		\
+	"H             Display column headers\n"			\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
-- 
1.9.3

