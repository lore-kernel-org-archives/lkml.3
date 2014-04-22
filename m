Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaDVIux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:53 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62788 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaDVIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:50:00 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 7/9] perf ui/tui: Rename hist_browser__update_nr_entries()
Date: Tue, 22 Apr 2014 17:49:49 +0900
Message-Id: <1398156591-11001-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename ->nr_pcnt_entries and hist_browser__update_pcnt_entries() to
->nr_non_filtered_entries and hist_browser__update_nr_entries() since
it's now used for filtering as well.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 311226edae12..769295bf2c10 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,13 +26,14 @@ struct hist_browser {
 	int		     print_seq;
 	bool		     show_dso;
 	float		     min_pcnt;
-	u64		     nr_pcnt_entries;
+	u64		     nr_non_filtered_entries;
 };
 
 extern void hist_browser__init_hpp(void);
 
 static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
+static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
@@ -310,8 +311,6 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
-
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -322,7 +321,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = browser->hists->nr_entries;
 	if (browser->min_pcnt)
-		browser->b.nr_entries = browser->nr_pcnt_entries;
+		browser->b.nr_entries = browser->nr_non_filtered_entries;
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -340,8 +339,8 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			hbt->timer(hbt->arg);
 
 			if (browser->min_pcnt) {
-				hist_browser__update_pcnt_entries(browser);
-				nr_entries = browser->nr_pcnt_entries;
+				hist_browser__update_nr_entries(browser);
+				nr_entries = browser->nr_non_filtered_entries;
 			} else {
 				nr_entries = browser->hists->nr_entries;
 			}
@@ -1343,7 +1342,7 @@ close_file_and_continue:
 	return ret;
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
+static void hist_browser__update_nr_entries(struct hist_browser *hb)
 {
 	u64 nr_entries = 0;
 	struct rb_node *nd = rb_first(&hb->hists->entries);
@@ -1354,7 +1353,7 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 		nd = rb_next(nd);
 	}
 
-	hb->nr_pcnt_entries = nr_entries;
+	hb->nr_non_filtered_entries = nr_entries;
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
@@ -1411,7 +1410,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	if (min_pcnt) {
 		browser->min_pcnt = min_pcnt;
-		hist_browser__update_pcnt_entries(browser);
+		hist_browser__update_nr_entries(browser);
 	}
 
 	fstack = pstack__new(2);
-- 
1.9.2

