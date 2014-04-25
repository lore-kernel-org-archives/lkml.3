Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaDYNPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:15:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40561 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaDYNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:15:23 -0400
Date: Fri, 25 Apr 2014 06:15:12 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-268397cb2a47ce6e1c0298d9de1762143867f9d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-11-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top/tui:
  Update nr_entries properly after a filter is applied
Git-Commit-ID: 268397cb2a47ce6e1c0298d9de1762143867f9d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  268397cb2a47ce6e1c0298d9de1762143867f9d3
Gitweb:     http://git.kernel.org/tip/268397cb2a47ce6e1c0298d9de1762143867f9d3
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Apr 2014 14:49:31 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:34:09 +0200

perf top/tui: Update nr_entries properly after a filter is applied

The hist_browser__reset() is only called right after a filter is
applied so it needs to udpate browser->nr_entries properly.  We cannot
use hists->nr_non_filtered_entreis directly since it's possible that
such entries are also filtered out by minimum percentage limit.

In addition when a filter is used for perf top, hist browser's
nr_entries field was not updated after applying the filter.  But it
needs to be updated as new samples are coming.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-11-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 20 ++++++++++++++++----
 tools/perf/util/hist.h         |  6 ++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 769295b..886eee0 100644
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
index ef1ad7a..38c3e87 100644
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
