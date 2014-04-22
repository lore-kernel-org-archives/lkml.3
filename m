Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaDVIul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:41 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62820 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDVIuB (ORCPT
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
Subject: [PATCH 9/9] perf hists/tui: Count callchain rows separately
Date: Tue, 22 Apr 2014 17:49:51 +0900
Message-Id: <1398156591-11001-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When TUI hist browser expands/collapses callchains it accounted number
of callchain nodes into total entries to show.  However this code
ignores filtering so that it can make the cursor go to out of screen.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 886eee0062e0..215f10429dda 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -27,6 +27,7 @@ struct hist_browser {
 	bool		     show_dso;
 	float		     min_pcnt;
 	u64		     nr_non_filtered_entries;
+	u64		     nr_callchain_rows;
 };
 
 extern void hist_browser__init_hpp(void);
@@ -35,6 +36,10 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
+static struct rb_node *hists__filter_entries(struct rb_node *nd,
+					     struct hists *hists,
+					     float min_pcnt);
+
 static bool hist_browser__has_filter(struct hist_browser *hb)
 {
 	return hists__has_filter(hb->hists) || hb->min_pcnt;
@@ -51,6 +56,7 @@ static void hist_browser__reset(struct hist_browser *browser)
 {
 	hist_browser__update_nr_entries(browser);
 	browser->b.nr_entries = browser->nr_non_filtered_entries;
+	browser->b.nr_entries += browser->nr_callchain_rows;
 	hist_browser__refresh_dimensions(browser);
 	ui_browser__reset_index(&browser->b);
 }
@@ -205,14 +211,16 @@ static bool hist_browser__toggle_fold(struct hist_browser *browser)
 		struct hist_entry *he = browser->he_selection;
 
 		hist_entry__init_have_children(he);
-		browser->hists->nr_entries -= he->nr_rows;
+		browser->b.nr_entries -= he->nr_rows;
+		browser->nr_callchain_rows -= he->nr_rows;
 
 		if (he->ms.unfolded)
 			he->nr_rows = callchain__count_rows(&he->sorted_chain);
 		else
 			he->nr_rows = 0;
-		browser->hists->nr_entries += he->nr_rows;
-		browser->b.nr_entries = browser->hists->nr_entries;
+
+		browser->b.nr_entries += he->nr_rows;
+		browser->nr_callchain_rows += he->nr_rows;
 
 		return true;
 	}
@@ -287,23 +295,31 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
 		he->nr_rows = 0;
 }
 
-static void hists__set_folding(struct hists *hists, bool unfold)
+static void
+__hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
 	struct rb_node *nd;
+	struct hists *hists = browser->hists;
 
-	hists->nr_entries = 0;
-
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries);
+	     (nd = hists__filter_entries(nd, hists, browser->min_pcnt)) != NULL;
+	     nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		hist_entry__set_folding(he, unfold);
-		hists->nr_entries += 1 + he->nr_rows;
+		browser->nr_callchain_rows += he->nr_rows;
 	}
 }
 
 static void hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
-	hists__set_folding(browser->hists, unfold);
-	browser->b.nr_entries = browser->hists->nr_entries;
+	browser->nr_callchain_rows = 0;
+	__hist_browser__set_folding(browser, unfold);
+
+	if (hist_browser__has_filter(browser))
+		browser->b.nr_entries = browser->nr_non_filtered_entries;
+	else
+		browser->b.nr_entries = browser->hists->nr_entries;
+	browser->b.nr_entries += browser->nr_callchain_rows;
 	/* Go to the start, we may be way after valid entries after a collapse */
 	ui_browser__reset_index(&browser->b);
 }
@@ -329,6 +345,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 		browser->b.nr_entries = browser->nr_non_filtered_entries;
 	else
 		browser->b.nr_entries = browser->hists->nr_entries;
+	browser->b.nr_entries += browser->nr_callchain_rows;
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -352,6 +369,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 				nr_entries = browser->hists->nr_entries;
 			}
 
+			nr_entries += browser->nr_callchain_rows;
 			ui_browser__update_nr_entries(&browser->b, nr_entries);
 
 			if (browser->hists->stats.nr_lost_warned !=
-- 
1.9.2

