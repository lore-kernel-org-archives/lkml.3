Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbaGPTOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558AbaGPTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:44 -0400
Date: Wed, 16 Jul 2014 12:14:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-m894d6qk30h3qofw4k8neq4q@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Add support for showing columns header
Git-Commit-ID: 025bf7ea0aca26df4a4b28f0b12afe1aaf91e4bd
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

Commit-ID:  025bf7ea0aca26df4a4b28f0b12afe1aaf91e4bd
Gitweb:     http://git.kernel.org/tip/025bf7ea0aca26df4a4b28f0b12afe1aaf91e4bd
Author:     Arnaldo Carvalho de Melo <jolsa@kernel.org>
AuthorDate: Sat, 14 Jun 2014 15:44:52 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:55 -0300

perf hists browser: Add support for showing columns header

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
index ef7abf8..2be71bf 100644
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
