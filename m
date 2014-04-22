Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaDVIuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:35 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62822 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaDVIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:50:01 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 8/9] perf top/tui: Update nr_entries properly after a filter is applied
Date: Tue, 22 Apr 2014 17:49:50 +0900
Message-Id: <1398156591-11001-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hist_browser__reset() is only called right after a filter is
applied so it needs to udpate browser->nr_entries properly.  We cannot
use hists->nr_non_filtered_entreis directly since it's possible that
such entries are also filtered out by minimum percentage limit.

In addition when a filter is used for perf top, hist browser's
nr_entries field was not updated after applying the filter.  But it
needs to be updated as new samples are coming.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 20 ++++++++++++++++----
 tools/perf/util/hist.h         |  6 ++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 769295bf2c10..886eee0062e0 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -35,6 +35,11 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
+static bool hist_browser__has_filter(struct hist_browser *hb)
+{
+	return hists__has_filter(hb->hists) || hb->min_pcnt;
+}
+
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
@@ -44,7 +49,8 @@ static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 
 static void hist_browser__reset(struct hist_browser *browser)
 {
-	browser->b.nr_entries = browser->hists->nr_entries;
+	hist_browser__update_nr_entries(browser);
+	browser->b.nr_entries = browser->nr_non_filtered_entries;
 	hist_browser__refresh_dimensions(browser);
 	ui_browser__reset_index(&browser->b);
 }
@@ -319,9 +325,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
-	browser->b.nr_entries = browser->hists->nr_entries;
-	if (browser->min_pcnt)
+	if (hist_browser__has_filter(browser))
 		browser->b.nr_entries = browser->nr_non_filtered_entries;
+	else
+		browser->b.nr_entries = browser->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -338,7 +345,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			u64 nr_entries;
 			hbt->timer(hbt->arg);
 
-			if (browser->min_pcnt) {
+			if (hist_browser__has_filter(browser)) {
 				hist_browser__update_nr_entries(browser);
 				nr_entries = browser->nr_non_filtered_entries;
 			} else {
@@ -1347,6 +1354,11 @@ static void hist_browser__update_nr_entries(struct hist_browser *hb)
 	u64 nr_entries = 0;
 	struct rb_node *nd = rb_first(&hb->hists->entries);
 
+	if (hb->min_pcnt == 0) {
+		hb->nr_non_filtered_entries = hb->hists->nr_non_filtered_entries;
+		return;
+	}
+
 	while ((nd = hists__filter_entries(nd, hb->hists,
 					   hb->min_pcnt)) != NULL) {
 		nr_entries++;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 185bd41be2ce..9cfbfee24dc9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -129,6 +129,12 @@ void hists__filter_by_dso(struct hists *hists);
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

