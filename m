Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaAOFIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:08:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52015 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaAOFIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:08:47 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-04-52d617dddd67
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH/RFC] perf ui/tui: Show column header in hist browser
Date: Wed, 15 Jan 2014 14:08:45 +0900
Message-Id: <1389762525-1795-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a line for showing column headers like --stdio.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browser.c        |  4 +--
 tools/perf/ui/browsers/hists.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index d11541d4d7d7..441470ba8d2c 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -278,8 +278,8 @@ void ui_browser__hide(struct ui_browser *browser)
 static void ui_browser__scrollbar_set(struct ui_browser *browser)
 {
 	int height = browser->height, h = 0, pct = 0,
-	    col = browser->width,
-	    row = browser->y - 1;
+	    col = browser->width, row = 0;
+
 
 	if (browser->nr_entries > 1) {
 		pct = ((browser->index * (browser->height - 1)) /
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e0ab399d431d..5b94de48f23c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -25,6 +25,7 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
+	bool		     show_column_header;
 	float		     min_pcnt;
 	u64		     nr_pcnt_entries;
 };
@@ -312,6 +313,57 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 
 static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
 
+static void hist_browser__column_header(struct hist_browser *browser)
+{
+	struct perf_hpp_fmt *fmt;
+	struct sort_entry *se;
+	struct hists *hists = browser->hists;
+	bool show = browser->show_column_header;
+	unsigned int width;
+
+	pthread_mutex_lock(&ui__lock);
+
+	if (!show)
+		goto out;
+
+	ui_browser__gotorc(&browser->b, 0, 0);
+
+	perf_hpp__for_each_format(fmt) {
+		char buf[128];
+		struct perf_hpp hpp = {
+			.buf	= buf,
+			.size	= sizeof(buf),
+			.ptr	= hists_to_evsel(hists),
+		};
+
+		width = fmt->width(fmt, &hpp);
+		fmt->header(fmt, &hpp);
+
+		slsmg_printf(" %-*s", width, hpp.buf);
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		width = strlen(se->se_header);
+		if (!hists__new_col_len(hists, se->se_width_idx, width))
+			width = hists__col_len(hists, se->se_width_idx);
+
+		slsmg_printf("  %-*s", width, se->se_header);
+	}
+
+	/*
+	 * We just called ui_browser__refresh_dimensions().
+	 * Update it to honor a new column header line.
+	 */
+	browser->b.y++;
+	browser->b.height--;
+
+out:
+	pthread_mutex_unlock(&ui__lock);
+}
+
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -331,6 +383,8 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
+	hist_browser__column_header(browser);
+
 	while (1) {
 		key = ui_browser__run(&browser->b, delay_secs);
 
@@ -1198,6 +1252,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
+		browser->show_column_header = true;
 	}
 
 	return browser;
-- 
1.7.11.7

