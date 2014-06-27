Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaF0Q1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaF0Q1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:27:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] perf tools tui: Display columns header text on 'H' press
Date: Fri, 27 Jun 2014 18:26:57 +0200
Message-Id: <1403886418-5556-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
References: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Displaying columns header text whenever 'H' is pressed,
and hiding it on on another press. Displaying headers
by default.

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
 tools/perf/ui/browsers/hists.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 8102f45..33a986a 100644
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
@@ -58,7 +59,13 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
+	u16 header = browser->show_headers ? 1 : 0;
+
 	ui_browser__refresh_dimensions(&browser->b);
+
+	/* shrink view size if there are headers displayed */
+	browser->b.height -= header;
+	browser->b.y      += header;
 }
 
 static void hist_browser__reset(struct hist_browser *browser)
@@ -407,6 +414,9 @@ static int hist_browser__run(struct hist_browser *browser,
 			/* Expand the whole world. */
 			hist_browser__set_folding(browser, true);
 			break;
+		case 'H':
+			browser->show_headers = !browser->show_headers;
+			continue;
 		case K_ENTER:
 			if (hist_browser__toggle_fold(browser))
 				break;
@@ -785,6 +795,65 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	return printed;
 }
 
+static int advance_hpp_check(struct perf_hpp *hpp, int inc)
+{
+	advance_hpp(hpp, inc);
+	return hpp->size <= 0;
+}
+
+static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
+{
+	struct perf_hpp dummy_hpp = {
+		.buf    = buf,
+		.size   = size,
+	};
+	struct perf_hpp_fmt *fmt;
+	size_t ret = 0;
+
+	if (symbol_conf.use_callchain) {
+		ret = scnprintf(buf, size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			return ret;
+	}
+
+	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		/* We need to add the length of the columns header. */
+		perf_hpp__reset_width(fmt, hists);
+
+		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+
+		ret = scnprintf(dummy_hpp.buf, dummy_hpp.size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+	}
+
+	return ret;
+}
+
+static void ui_browser__show_headers(struct ui_browser *b, char *headers)
+{
+	SLsmg_gotorc(1, 0);
+	ui_browser__set_color(b, HE_COLORSET_ROOT);
+	slsmg_write_nstring(headers, b->width + 1);
+}
+
+static void hist_browser__show_headers(struct hist_browser *hb)
+{
+	static char buf[1024], *headers;
+
+	if (!headers) {
+		hists__scnprintf_headers(buf, sizeof(buf), hb->hists);
+		headers = buf;
+	}
+
+	ui_browser__show_headers(&hb->b, headers);
+}
+
 static void ui_browser__hists_init_top(struct ui_browser *browser)
 {
 	if (browser->top == NULL) {
@@ -801,6 +870,11 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
 
+	hist_browser__refresh_dimensions(hb);
+
+	if (hb->show_headers)
+		hist_browser__show_headers(hb);
+
 	ui_browser__hists_init_top(browser);
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
@@ -1190,6 +1264,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
+		browser->show_headers = true;
 	}
 
 	return browser;
@@ -1419,6 +1494,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
 	"F             Toggle percentage of filtered entries\n"		\
+	"H             Display column headers\n"			\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
-- 
1.8.3.1

