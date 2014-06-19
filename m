Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbaFSVOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:34171 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbaFSVO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:28 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/11] perf hists browser: Remove ev_name argument from perf_evsel__hists_browse
Date: Thu, 19 Jun 2014 18:13:47 -0300
Message-Id: <1403212433-2714-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Removing ev_name argument from perf_evsel__hists_browse function,
because it's not needed. We can get the name out of the 'struct
perf_evsel' which is passed as argument as well.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403178076-14072-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 52c03fbbba17..1bd35e8ed9f1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -32,8 +32,7 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name);
+static int hists__browser_title(struct hists *hists, char *bf, size_t size);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -345,7 +344,7 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
+static int hist_browser__run(struct hist_browser *browser,
 			     struct hist_browser_timer *hbt)
 {
 	int key;
@@ -356,7 +355,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
 	hist_browser__refresh_dimensions(browser);
-	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+	hists__browser_title(browser->hists, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -383,7 +382,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+			hists__browser_title(browser->hists, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -1212,8 +1211,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name)
+static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1222,6 +1220,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	const char *ev_name = perf_evsel__name(evsel);
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
@@ -1389,7 +1388,7 @@ static void hist_browser__update_nr_entries(struct hist_browser *hb)
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
-				    const char *helpline, const char *ev_name,
+				    const char *helpline,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
 				    float min_pcnt,
@@ -1464,7 +1463,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, ev_name, hbt);
+		key = hist_browser__run(browser, hbt);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1832,7 +1831,7 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
-	const char *ev_name, *title = "Available samples";
+	const char *title = "Available samples";
 	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
@@ -1865,9 +1864,8 @@ browse_hists:
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
@@ -1971,10 +1969,9 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
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
1.9.3

