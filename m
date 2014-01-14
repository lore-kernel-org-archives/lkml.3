Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaANF2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:28:14 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65497 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaANF0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:06 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-a7-52d4ca68fce8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 16/24] perf tools: Apply percent-limit to cumulative percentage
Date: Tue, 14 Jan 2014 14:25:49 +0900
Message-Id: <1389677157-30513-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If -g cumulative option is given, it needs to show entries which don't
have self overhead.  So apply percent-limit to accumulated overhead
percentage in this case.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 33 +++++++++++----------------------
 tools/perf/ui/gtk/hists.c      |  4 ++--
 tools/perf/ui/stdio/hist.c     |  4 ++--
 tools/perf/util/hist.h         |  1 +
 tools/perf/util/sort.h         | 17 ++++++++++++++++-
 5 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c8e3a2e7b5c0..0a088535ebac 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -828,12 +828,12 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hb->hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -846,18 +846,13 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 }
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
-					     struct hists *hists,
 					     float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent = hist_entry__get_percent_limit(h);
 
-		if (percent < min_pcnt)
-			return NULL;
-
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -867,13 +862,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 }
 
 static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
-						  struct hists *hists,
 						  float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent = hist_entry__get_percent_limit(h);
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
@@ -902,14 +895,14 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(browser->entries),
-					   hb->hists, hb->min_pcnt);
+					   hb->min_pcnt);
 		break;
 	case SEEK_CUR:
 		nd = browser->top;
 		goto do_offset;
 	case SEEK_END:
 		nd = hists__filter_prev_entries(rb_last(browser->entries),
-						hb->hists, hb->min_pcnt);
+						hb->min_pcnt);
 		first = false;
 		break;
 	default:
@@ -952,8 +945,7 @@ do_offset:
 					break;
 				}
 			}
-			nd = hists__filter_entries(rb_next(nd), hb->hists,
-						   hb->min_pcnt);
+			nd = hists__filter_entries(rb_next(nd), hb->min_pcnt);
 			if (nd == NULL)
 				break;
 			--offset;
@@ -986,7 +978,7 @@ do_offset:
 				}
 			}
 
-			nd = hists__filter_prev_entries(rb_prev(nd), hb->hists,
+			nd = hists__filter_prev_entries(rb_prev(nd),
 							hb->min_pcnt);
 			if (nd == NULL)
 				break;
@@ -1157,7 +1149,6 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 {
 	struct rb_node *nd = hists__filter_entries(rb_first(browser->b.entries),
-						   browser->hists,
 						   browser->min_pcnt);
 	int printed = 0;
 
@@ -1165,8 +1156,7 @@ static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		printed += hist_browser__fprintf_entry(browser, h, fp);
-		nd = hists__filter_entries(rb_next(nd), browser->hists,
-					   browser->min_pcnt);
+		nd = hists__filter_entries(rb_next(nd), browser->min_pcnt);
 	}
 
 	return printed;
@@ -1390,8 +1380,7 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 
 	while (nd) {
 		nr_entries++;
-		nd = hists__filter_entries(rb_next(nd), hb->hists,
-					   hb->min_pcnt);
+		nd = hists__filter_entries(rb_next(nd), hb->min_pcnt);
 	}
 
 	hb->nr_pcnt_entries = nr_entries;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 49531c1c7121..ded22b4da677 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -296,12 +296,12 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < min_pcnt)
 			continue;
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb77d1ff..b48c7ba49a1c 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -487,12 +487,12 @@ print_entries:
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < min_pcnt)
 			continue;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 59d8ba4665a4..421c2d809769 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -140,6 +140,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
+
 void hists__output_resort(struct hists *hists);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 309f2838a1b4..103748ba25f2 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -20,7 +20,7 @@
 
 #include "parse-options.h"
 #include "parse-events.h"
-
+#include "hist.h"
 #include "thread.h"
 
 extern regex_t parent_regex;
@@ -130,6 +130,21 @@ static inline void hist_entry__add_pair(struct hist_entry *pair,
 	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
+static inline float hist_entry__get_percent_limit(struct hist_entry *he)
+{
+	u64 period = he->stat.period;
+	u64 total_period = he->hists->stats.total_period;
+
+	if (unlikely(total_period == 0))
+		return 0;
+
+	if (symbol_conf.cumulate_callchain)
+		period = he->stat_acc->period;
+
+	return period * 100.0 / total_period;
+}
+
+
 enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
-- 
1.7.11.7

