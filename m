Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBBVkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaBBVkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:06 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 12/22] perf tools: Add header callback to hist browser
Date: Sun,  2 Feb 2014 22:39:00 +0100
Message-Id: <1391377150-23920-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding header callback for hist browser to display
the column headers.

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
 tools/perf/ui/browser.c        | 46 ++++++++++++++++++++++++++++++++----------
 tools/perf/ui/browser.h        |  2 ++
 tools/perf/ui/browsers/hists.c | 25 +++++++++++++++--------
 3 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 31bd6e8..3f8a758 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -250,26 +250,49 @@ void ui_browser__show_title(struct ui_browser *browser, const char *title)
 	pthread_mutex_unlock(&ui__lock);
 }
 
-int ui_browser__show(struct ui_browser *browser, const char *title,
-		     const char *helpline, ...)
+static int ui_browser__show_va(struct ui_browser *browser, const char *title,
+			const char *helpline, va_list args)
 {
 	int err;
-	va_list ap;
-
-	ui_browser__refresh_dimensions(browser);
 
-	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(browser, title);
 
 	browser->title = title;
 	zfree(&browser->helpline);
 
-	va_start(ap, helpline);
-	err = vasprintf(&browser->helpline, helpline, ap);
-	va_end(ap);
+	err = vasprintf(&browser->helpline, helpline, args);
 	if (err > 0)
 		ui_helpline__push(browser->helpline);
+
+	return err;
+}
+
+int __ui_browser__show(struct ui_browser *browser, const char *title,
+		       const char *helpline, ...)
+{
+	va_list args;
+	int err;
+
+	va_start(args, helpline);
+	err = ui_browser__show_va(browser, title, helpline, args);
+	va_end(args);
+
+	return err ? 0 : -1;
+}
+
+int ui_browser__show(struct ui_browser *browser, const char *title,
+		     const char *helpline, ...)
+{
+	va_list args;
+	int err;
+
+	pthread_mutex_lock(&ui__lock);
+	ui_browser__refresh_dimensions(browser);
+	va_start(args, helpline);
+	err = ui_browser__show_va(browser, title, helpline, args);
+	va_end(args);
 	pthread_mutex_unlock(&ui__lock);
+
 	return err ? 0 : -1;
 }
 
@@ -311,14 +334,15 @@ static void __ui_browser__header(struct ui_browser *browser)
 
 static int __ui_browser__refresh(struct ui_browser *browser)
 {
-	int row;
-	int width = browser->width;
+	int row, width;
 
 	__ui_browser__header(browser);
 
 	row = browser->ops.refresh(browser);
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
 
+	width = browser->width;
+
 	if (!browser->use_navkeypressed || browser->navkeypressed)
 		ui_browser__scrollbar_set(browser);
 	else
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 73b17b7..7231f39 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -50,6 +50,8 @@ void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
 			      u64 start, u64 end);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
+int __ui_browser__show(struct ui_browser *browser, const char *title,
+		       const char *helpline, ...);
 int ui_browser__show(struct ui_browser *browser, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b4e789b..9a95fdc 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -316,7 +316,6 @@ static int hist_browser__run(struct hist_browser *browser,
 			     struct hist_browser_timer *hbt)
 {
 	int key;
-	char title[160];
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
@@ -325,11 +324,6 @@ static int hist_browser__run(struct hist_browser *browser,
 		browser->b.nr_entries = browser->nr_pcnt_entries;
 
 	hist_browser__refresh_dimensions(browser);
-	hists__browser_title(browser->hists, title, sizeof(title));
-
-	if (ui_browser__show(&browser->b, title,
-			     "Press '?' for help on key bindings") < 0)
-		return -1;
 
 	while (1) {
 		key = ui_browser__run(&browser->b, delay_secs);
@@ -355,8 +349,6 @@ static int hist_browser__run(struct hist_browser *browser,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title));
-			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
 		case 'D': { /* Debug */
@@ -1209,12 +1201,29 @@ static int hist_browser__dump(struct hist_browser *browser)
 	return 0;
 }
 
+static unsigned int hist_browser__header(struct ui_browser *b)
+{
+	struct hist_browser *browser;
+	char title[160];
+
+	browser = container_of(b, struct hist_browser, b);
+	ui_browser__refresh_dimensions(b);
+	hists__browser_title(browser->hists, title, sizeof(title));
+
+	if (__ui_browser__show(b, title,
+		"Press '?' for help on key bindings") < 0)
+		return -1;
+
+	return 0;
+}
+
 static struct hist_browser *hist_browser__new(struct hists *hists)
 {
 	struct hist_browser *browser = zalloc(sizeof(*browser));
 
 	if (browser) {
 		browser->hists = hists;
+		browser->b.ops.header = hist_browser__header;
 		browser->b.ops.refresh = hist_browser__refresh;
 		browser->b.ops.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-- 
1.8.3.1

