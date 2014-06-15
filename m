Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaFOQxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaFOQxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:53:40 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf tools: Remove ev_name argument from perf_evsel__hists_browse
Date: Sun, 15 Jun 2014 18:53:21 +0200
Message-Id: <1402851203-3083-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
References: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing ev_name argument from perf_evsel__hists_browse
function, because it's not needed. We can get the name
out of the 'struct perf_evsel' which is passed as
argument as well.

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
 tools/perf/ui/browsers/hists.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7cb6309..6aeed29 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -33,8 +33,7 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name);
+static int hists__browser_title(struct hists *hists, char *bf, size_t size);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -346,7 +345,7 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
+static int hist_browser__run(struct hist_browser *browser,
 			     struct hist_browser_timer *hbt)
 {
 	int key;
@@ -357,7 +356,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
 	hist_browser__refresh_dimensions(browser);
-	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+	hists__browser_title(browser->hists, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -384,7 +383,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+			hists__browser_title(browser->hists, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -1213,8 +1212,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name)
+static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1223,6 +1221,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	const char *ev_name = perf_evsel__name(evsel);
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
@@ -1390,7 +1389,7 @@ static void hist_browser__update_nr_entries(struct hist_browser *hb)
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
-				    const char *helpline, const char *ev_name,
+				    const char *helpline,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
 				    float min_pcnt,
@@ -1465,7 +1464,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, ev_name, hbt);
+		key = hist_browser__run(browser, hbt);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1843,7 +1842,7 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
-	const char *ev_name, *title = "Available samples";
+	const char *title = "Available samples";
 	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
@@ -1876,9 +1875,8 @@ browse_hists:
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
@@ -1984,10 +1982,9 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
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

