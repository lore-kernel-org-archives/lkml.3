Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaDQHxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:53:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54765 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQHx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:53:28 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/3] perf top/tui: Update nr_entries properly after filter is applied
Date: Thu, 17 Apr 2014 16:53:26 +0900
Message-Id: <1397721206-15393-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hist_browser__reset() is only called right after a filter is
applied so it needs to update browser->nr_entries properly.  We cannot
use hists->nr_non_filtered_entries directly since it's possible that
such entries are also filtered out by minimum percentage.

In addition when a filter is used for perf top, hist browser's
nr_entries field was not updated after applying the filter.  But it
needs to be updated as new samples are coming.

Rename ->nr_pcnt_entries and hist_browser__update_pcnt_entries() to
->nr_filtered_entries and hist_browser__update_nr_entries() since it's
now used for filtered entries as well.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 31 +++++++++++++++++--------------
 tools/perf/util/hist.h         |  6 ++++++
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e86b95cc55db..d98901a7e04f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,13 +26,14 @@ struct hist_browser {
 	int		     print_seq;
 	bool		     show_dso;
 	float		     min_pcnt;
-	u64		     nr_pcnt_entries;
+	u64		     nr_filtered_entries;
 };
 
 extern void hist_browser__init_hpp(void);
 
 static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
+static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
@@ -43,7 +44,8 @@ static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 
 static void hist_browser__reset(struct hist_browser *browser)
 {
-	browser->b.nr_entries = browser->hists->nr_entries;
+	hist_browser__update_nr_entries(browser);
+	browser->b.nr_entries = browser->nr_filtered_entries;
 	hist_browser__refresh_dimensions(browser);
 	ui_browser__reset_index(&browser->b);
 }
@@ -310,8 +312,6 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
-
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -320,9 +320,11 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
-	browser->b.nr_entries = browser->hists->nr_entries;
-	if (browser->min_pcnt)
-		browser->b.nr_entries = browser->nr_pcnt_entries;
+
+	if (hists__has_filter(browser->hists) || browser->min_pcnt)
+		browser->b.nr_entries = browser->nr_filtered_entries;
+	else
+		browser->b.nr_entries = browser->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -339,9 +341,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			u64 nr_entries;
 			hbt->timer(hbt->arg);
 
-			if (browser->min_pcnt) {
-				hist_browser__update_pcnt_entries(browser);
-				nr_entries = browser->nr_pcnt_entries;
+			if (hists__has_filter(browser->hists) ||
+			    browser->min_pcnt) {
+				hist_browser__update_nr_entries(browser);
+				nr_entries = browser->nr_filtered_entries;
 			} else {
 				nr_entries = browser->hists->nr_entries;
 			}
@@ -1343,7 +1346,7 @@ close_file_and_continue:
 	return ret;
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
+static void hist_browser__update_nr_entries(struct hist_browser *hb)
 {
 	u64 nr_entries = 0;
 	struct rb_node *nd = rb_first(&hb->hists->entries);
@@ -1355,7 +1358,7 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 			nr_entries++;
 	}
 
-	hb->nr_pcnt_entries = nr_entries;
+	hb->nr_filtered_entries = nr_entries;
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
@@ -1410,9 +1413,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	if (browser == NULL)
 		return -1;
 
-	if (min_pcnt) {
+	if (hists__has_filter(hists) || min_pcnt) {
 		browser->min_pcnt = min_pcnt;
-		hist_browser__update_pcnt_entries(browser);
+		hist_browser__update_nr_entries(browser);
 	}
 
 	fstack = pstack__new(2);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5a0343eb22e2..831faf086eb9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -128,6 +128,12 @@ void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
 void hists__filter_by_symbol(struct hists *hists);
 
+static inline bool hists__has_filter(struct hists *hists)
+{
+	return hists->thread_filter || hists->dso_filter ||
+		hists->symbol_filter_str;
+}
+
 u16 hists__col_len(struct hists *hists, enum hist_column col);
 void hists__set_col_len(struct hists *hists, enum hist_column col, u16 len);
 bool hists__new_col_len(struct hists *hists, enum hist_column col, u16 len);
-- 
1.9.2

