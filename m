Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaHKIu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaHKIuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:54 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/20] perf tui browser: Add interface to terminate browser from uotside
Date: Mon, 11 Aug 2014 10:50:03 +0200
Message-Id: <1407747014-18394-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the TUI browser could be terminated only via keypress
'q' and interrupt. But there's another situation possible where
we want to terminate the browser from outside like when all
monitored events are closed.

Adding 'done' pointer parameter to TUI browser functions to
allow a browser loops break when '*done != 0'.

Changing top TUI browser to use top's 'done' in here.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-report.c       |  3 ++-
 tools/perf/builtin-top.c          |  3 ++-
 tools/perf/ui/browser.c           |  4 ++--
 tools/perf/ui/browser.h           |  8 +++++++-
 tools/perf/ui/browsers/annotate.c |  2 +-
 tools/perf/ui/browsers/header.c   |  2 +-
 tools/perf/ui/browsers/hists.c    | 39 ++++++++++++++++++++++-----------------
 tools/perf/ui/browsers/map.c      |  2 +-
 tools/perf/ui/browsers/scripts.c  |  2 +-
 tools/perf/ui/keysyms.h           |  1 +
 tools/perf/ui/tui/util.c          |  2 +-
 tools/perf/util/hist.h            |  6 ++++--
 12 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 041e93da13e4..a5d8c9140eba 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -400,7 +400,8 @@ static int report__browse_hists(struct report *rep)
 	case 1:
 		ret = perf_evlist__tui_browse_hists(evlist, help, NULL,
 						    rep->min_percent,
-						    &session->header.env);
+						    &session->header.env,
+						    NULL);
 		/*
 		 * Usually "ret" is the last pressed key, and we only
 		 * care if the key notifies us to switch data file.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4fb6f726271c..4cd56c9ddedc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -571,7 +571,8 @@ static void *display_thread_tui(void *arg)
 		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
 
 	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
-				      &top->session->header.env);
+				      &top->session->header.env,
+				      (int *) &done);
 
 	done = 1;
 	return NULL;
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 6680fa5cb9dd..82d70c71f522 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -352,11 +352,11 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
-int ui_browser__run(struct ui_browser *browser, int delay_secs)
+int ui_browser__run(struct ui_browser *browser, int delay_secs, int *done)
 {
 	int err, key;
 
-	while (1) {
+	while (!browser_is_done(done)) {
 		off_t offset;
 
 		pthread_mutex_lock(&ui__lock);
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 92ae72113965..9e9a4bf12f2a 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -46,7 +46,7 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *browser);
 int ui_browser__refresh(struct ui_browser *browser);
-int ui_browser__run(struct ui_browser *browser, int delay_secs);
+int ui_browser__run(struct ui_browser *browser, int delay_secs, int *done);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 void ui_browser__handle_resize(struct ui_browser *browser);
 void __ui_browser__vline(struct ui_browser *browser, unsigned int column,
@@ -72,4 +72,10 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser);
 
 void ui_browser__init(void);
 void annotate_browser__init(void);
+
+static inline bool browser_is_done(int *done)
+{
+	return done ? *done != 0 : 0;
+}
+
 #endif /* _PERF_UI_BROWSER_H_ */
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f0697a3aede0..e3271d76480d 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -681,7 +681,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
 	nd = browser->curr_hot;
 
 	while (1) {
-		key = ui_browser__run(&browser->b, delay_secs);
+		key = ui_browser__run(&browser->b, delay_secs, NULL);
 
 		if (delay_secs != 0) {
 			annotate_browser__calc_percent(browser, evsel);
diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
index 89c16b988618..931be7c5e91b 100644
--- a/tools/perf/ui/browsers/header.c
+++ b/tools/perf/ui/browsers/header.c
@@ -42,7 +42,7 @@ static int list_menu__run(struct ui_browser *menu)
 		return -1;
 
 	while (1) {
-		key = ui_browser__run(menu, 0);
+		key = ui_browser__run(menu, 0, NULL);
 
 		switch (key) {
 		case K_RIGHT:
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 045c1e16ac59..bb8beb8c3ad8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -378,9 +378,10 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 }
 
 static int hist_browser__run(struct hist_browser *browser,
-			     struct hist_browser_timer *hbt)
+			     struct hist_browser_timer *hbt,
+			     int *done)
 {
-	int key;
+	int key = K_INIT;
 	char title[160];
 	int delay_secs = hbt ? hbt->refresh : 0;
 
@@ -393,8 +394,8 @@ static int hist_browser__run(struct hist_browser *browser,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	while (1) {
-		key = ui_browser__run(&browser->b, delay_secs);
+	while (!browser_is_done(done)) {
+		key = ui_browser__run(&browser->b, delay_secs, done);
 
 		switch (key) {
 		case K_TIMER: {
@@ -1486,7 +1487,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
 				    float min_pcnt,
-				    struct perf_session_env *env)
+				    struct perf_session_env *env,
+				    int *done)
 {
 	struct hists *hists = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(hists);
@@ -1554,7 +1556,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	if (symbol_conf.col_width_list_str)
 		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
 
-	while (1) {
+	while (!browser_is_done(done)) {
 		const struct thread *thread = NULL;
 		const struct dso *dso = NULL;
 		int choice = 0,
@@ -1565,7 +1567,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, hbt);
+		key = hist_browser__run(browser, hbt, done);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1939,20 +1941,21 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 
 static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 				int nr_events, const char *help,
-				struct hist_browser_timer *hbt)
+				struct hist_browser_timer *hbt,
+				int *done)
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *title = "Available samples";
 	int delay_secs = hbt ? hbt->refresh : 0;
-	int key;
+	int key = K_INIT;
 
 	if (ui_browser__show(&menu->b, title,
 			     "ESC: exit, ENTER|->: Browse histograms") < 0)
 		return -1;
 
-	while (1) {
-		key = ui_browser__run(&menu->b, delay_secs);
+	while (!browser_is_done(done)) {
+		key = ui_browser__run(&menu->b, delay_secs, done);
 
 		switch (key) {
 		case K_TIMER:
@@ -1979,7 +1982,7 @@ browse_hists:
 			key = perf_evsel__hists_browse(pos, nr_events, help,
 						       true, hbt,
 						       menu->min_pcnt,
-						       menu->env);
+						       menu->env, done);
 			ui_browser__show_title(&menu->b, title);
 			switch (key) {
 			case K_TAB:
@@ -2041,7 +2044,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 					   int nr_entries, const char *help,
 					   struct hist_browser_timer *hbt,
 					   float min_pcnt,
-					   struct perf_session_env *env)
+					   struct perf_session_env *env,
+					   int *done)
 {
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
@@ -2068,13 +2072,14 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			menu.b.width = line_len;
 	}
 
-	return perf_evsel_menu__run(&menu, nr_entries, help, hbt);
+	return perf_evsel_menu__run(&menu, nr_entries, help, hbt, done);
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
 				  float min_pcnt,
-				  struct perf_session_env *env)
+				  struct perf_session_env *env,
+				  int *done)
 {
 	int nr_entries = evlist->nr_entries;
 
@@ -2084,7 +2089,7 @@ single_entry:
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
 						false, hbt, min_pcnt,
-						env);
+						env, done);
 	}
 
 	if (symbol_conf.event_group) {
@@ -2101,5 +2106,5 @@ single_entry:
 	}
 
 	return __perf_evlist__tui_browse_hists(evlist, nr_entries, help,
-					       hbt, min_pcnt, env);
+					       hbt, min_pcnt, env, done);
 }
diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index b11639f33682..f87fa61c5e91 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -78,7 +78,7 @@ static int map_browser__run(struct map_browser *browser)
 		return -1;
 
 	while (1) {
-		key = ui_browser__run(&browser->b, 0);
+		key = ui_browser__run(&browser->b, 0, NULL);
 
 		switch (key) {
 		case '/':
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index 402d2bd30b09..6c23b197d6fb 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -93,7 +93,7 @@ static int script_browser__run(struct perf_script_browser *browser)
 		return -1;
 
 	while (1) {
-		key = ui_browser__run(&browser->b, 0);
+		key = ui_browser__run(&browser->b, 0, NULL);
 
 		/* We can add some special key handling here if needed */
 		break;
diff --git a/tools/perf/ui/keysyms.h b/tools/perf/ui/keysyms.h
index 65092d576b4e..63a0c1b56761 100644
--- a/tools/perf/ui/keysyms.h
+++ b/tools/perf/ui/keysyms.h
@@ -24,5 +24,6 @@
 #define K_ERROR	 -2
 #define K_RESIZE -3
 #define K_SWITCH_INPUT_DATA -4
+#define K_INIT	 -5
 
 #endif /* _PERF_KEYSYMS_H_ */
diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index bf890f72fe80..a97fd4c43079 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -32,7 +32,7 @@ static int popup_menu__run(struct ui_browser *menu)
 		return -1;
 
 	while (1) {
-		key = ui_browser__run(menu, 0);
+		key = ui_browser__run(menu, 0, NULL);
 
 		switch (key) {
 		case K_RIGHT:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 95405a8fbd95..c452af22ea89 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -312,7 +312,8 @@ int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
 				  float min_pcnt,
-				  struct perf_session_env *env);
+				  struct perf_session_env *env,
+				  int *done);
 int script_browse(const char *script_opt);
 #else
 static inline
@@ -320,7 +321,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
 				  struct hist_browser_timer *hbt __maybe_unused,
 				  float min_pcnt __maybe_unused,
-				  struct perf_session_env *env __maybe_unused)
+				  struct perf_session_env *env __maybe_unused,
+				  int *done __maybe_unused)
 {
 	return 0;
 }
-- 
1.8.3.1

