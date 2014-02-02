Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaBBVkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbaBBVkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:15 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 14/22] perf tools tui: Display columns header text on 'H' press
Date: Sun,  2 Feb 2014 22:39:02 +0100
Message-Id: <1391377150-23920-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Displaing columns header text whenever 'H' is pressed,
and hiding it on on another press.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browser.c        | 12 ++++++-
 tools/perf/ui/browser.h        |  2 +-
 tools/perf/ui/browsers/hists.c | 78 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3f8a758..7a8cd15 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -243,6 +243,13 @@ void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 	slsmg_write_nstring(title, browser->width + 1);
 }
 
+static void __ui_browser__show_header(struct ui_browser *browser, char *header)
+{
+	SLsmg_gotorc(1, 0);
+	ui_browser__set_color(browser, HE_COLORSET_ROOT);
+	slsmg_write_nstring(header, browser->width + 1);
+}
+
 void ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	pthread_mutex_lock(&ui__lock);
@@ -268,7 +275,7 @@ static int ui_browser__show_va(struct ui_browser *browser, const char *title,
 }
 
 int __ui_browser__show(struct ui_browser *browser, const char *title,
-		       const char *helpline, ...)
+		       char *header, const char *helpline, ...)
 {
 	va_list args;
 	int err;
@@ -277,6 +284,9 @@ int __ui_browser__show(struct ui_browser *browser, const char *title,
 	err = ui_browser__show_va(browser, title, helpline, args);
 	va_end(args);
 
+	if (header)
+		__ui_browser__show_header(browser, header);
+
 	return err ? 0 : -1;
 }
 
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 7231f39..348e761 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -51,7 +51,7 @@ void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int __ui_browser__show(struct ui_browser *browser, const char *title,
-		       const char *helpline, ...);
+		       char *header, const char *helpline, ...);
 int ui_browser__show(struct ui_browser *browser, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 3dd71d6..1d519e9 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -25,6 +25,7 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
+	bool		     show_col_headers;
 	float		     min_pcnt;
 	u64		     nr_pcnt_entries;
 	u64		     time_base;
@@ -36,9 +37,12 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size);
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
-	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
-			     sizeof("[k]"));
+	u16 header = browser->show_col_headers ? 1 : 0;
+
+	browser->b.width = SLtt_Screen_Cols - 1;
+	browser->b.height = SLtt_Screen_Rows - 2 - header;
+	browser->b.y = 1 + header;
+	browser->b.x = 0;
 }
 
 static void hist_browser__reset(struct hist_browser *browser)
@@ -310,6 +314,61 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
+static size_t scnprintf_header_fmt(char *buf, size_t size)
+{
+	struct perf_hpp_fmt *fmt;
+	bool first = true;
+	size_t ret = 0;
+
+	perf_hpp__for_each_format(fmt) {
+		struct perf_hpp hpp = { .ptr = NULL, };
+
+		if (!first)
+			ret += scnprintf(buf + ret, size, "  ");
+
+		hpp.buf	 = buf + ret,
+		hpp.size = size - ret,
+
+		first = false;
+
+		ret += fmt->header(fmt, &hpp);
+	}
+	return ret;
+}
+
+static size_t scnprintf_header_se(struct hists *hists, char *buf, size_t size)
+{
+	struct sort_entry *se;
+	unsigned int width;
+	int ret = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		width = strlen(se->se_header);
+		if (!hists__new_col_len(hists, se->se_width_idx, width))
+			width = hists__col_len(hists, se->se_width_idx);
+
+		ret += scnprintf(buf + ret, size - ret, "  %*s", width,
+				 se->se_header);
+	}
+	return ret;
+}
+
+static int hists__scnprintf_header(char *buf, size_t size, struct hists *hists)
+{
+	size_t ret = 0;
+
+	if (symbol_conf.use_callchain)
+		ret += scnprintf(buf, size, "  ");
+
+	ret += scnprintf_header_fmt(buf + ret, size - ret);
+	ret += scnprintf_header_se(hists, buf + ret, size - ret);
+
+	return ret;
+}
+
 static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
 
 static int hist_browser__run(struct hist_browser *browser,
@@ -373,6 +432,9 @@ static int hist_browser__run(struct hist_browser *browser,
 			/* Expand the whole world. */
 			hist_browser__set_folding(browser, true);
 			break;
+		case 'H':
+			browser->show_col_headers = !browser->show_col_headers;
+			continue;
 		case K_ENTER:
 			if (hist_browser__toggle_fold(browser))
 				break;
@@ -596,6 +658,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	double percent = 0.0;
 	struct hists *hists = he->hists;
 	struct hpp_arg *arg = hpp->ptr;
+	const char *fmt = arg->hb->show_col_headers ? " %6.2f%%" : "%6.2f%%";
 
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
@@ -605,7 +668,7 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (callchain_cb)
 		ret += callchain_cb(arg);
 
-	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	ret += scnprintf(hpp->buf, hpp->size, fmt, percent);
 	slsmg_printf("%s", hpp->buf);
 
 	if (symbol_conf.event_group) {
@@ -1205,12 +1268,15 @@ static unsigned int hist_browser__header(struct ui_browser *b)
 {
 	struct hist_browser *browser;
 	char title[160];
+	char header[500];
+	size_t size = min(b->width, (u16) sizeof(header));
 
 	browser = container_of(b, struct hist_browser, b);
-	ui_browser__refresh_dimensions(b);
+	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title));
+	hists__scnprintf_header(header, size, browser->hists);
 
-	if (__ui_browser__show(b, title,
+	if (__ui_browser__show(b, title, header,
 		"Press '?' for help on key bindings") < 0)
 		return -1;
 
-- 
1.8.3.1

