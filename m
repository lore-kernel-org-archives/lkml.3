Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaBBVkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaBBVj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 11/22] perf tools: Remove ev_name argument from perf_evsel__hists_browse
Date: Sun,  2 Feb 2014 22:38:59 +0100
Message-Id: <1391377150-23920-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing ev_name argument from perf_evsel__hists_browse
function, because it's not needed. We can get the name
out of the 'struct perf_evsel' which is passed as
argument as well.

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
 tools/perf/ui/browsers/hists.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b4e476c..b4e789b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -32,8 +32,7 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name);
+static int hists__browser_title(struct hists *hists, char *bf, size_t size);
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
@@ -313,7 +312,7 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 
 static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
 
-static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
+static int hist_browser__run(struct hist_browser *browser,
 			     struct hist_browser_timer *hbt)
 {
 	int key;
@@ -326,7 +325,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 		browser->b.nr_entries = browser->nr_pcnt_entries;
 
 	hist_browser__refresh_dimensions(browser);
-	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+	hists__browser_title(browser->hists, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -356,7 +355,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+			hists__browser_title(browser->hists, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -1239,8 +1238,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name)
+static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1249,6 +1247,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	const char *ev_name = perf_evsel__name(evsel);
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
@@ -1401,7 +1400,7 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
-				    const char *helpline, const char *ev_name,
+				    const char *helpline,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
 				    float min_pcnt,
@@ -1475,7 +1474,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, ev_name, hbt);
+		key = hist_browser__run(browser, hbt);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1840,7 +1839,7 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
-	const char *ev_name, *title = "Available samples";
+	const char *title = "Available samples";
 	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
@@ -1873,9 +1872,8 @@ browse_hists:
 			 */
 			if (hbt)
 				hbt->timer(hbt->arg);
-			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
-						       ev_name, true, hbt,
+						       true, hbt,
 						       menu->min_pcnt,
 						       menu->env);
 			ui_browser__show_title(&menu->b, title);
@@ -1981,10 +1979,9 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 single_entry:
 	if (nr_entries == 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
-		const char *ev_name = perf_evsel__name(first);
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
-						ev_name, false, hbt, min_pcnt,
+						false, hbt, min_pcnt,
 						env);
 	}
 
-- 
1.8.3.1

