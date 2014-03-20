Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaCTFkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:40:06 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52980 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTFgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:53 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-11-532a7e728806
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 12/21] perf tools: Apply percent-limit to cumulative percentage
Date: Thu, 20 Mar 2014 14:36:37 +0900
Message-Id: <1395293806-25847-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If -g cumulative option is given, it needs to show entries which don't
have self overhead.  So apply percent-limit to accumulated overhead
percentage in this case.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 42 +++++++++++-------------------------------
 tools/perf/ui/gtk/hists.c      |  6 ++----
 tools/perf/ui/stdio/hist.c     |  4 ++--
 tools/perf/util/hist.h         |  1 +
 tools/perf/util/sort.h         | 17 ++++++++++++++++-
 5 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5089bc1f2259..5ef962670c02 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -780,15 +780,12 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		u64 total = hists__total_period(h->hists);
-		float percent = 0.0;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
-		if (total)
-			percent = h->stat.period * 100.0 / total;
-
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -801,21 +798,13 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 }
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
-					     struct hists *hists,
 					     float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		u64 total = hists__total_period(hists);
-		float percent = 0.0;
-
-		if (total)
-			percent = h->stat.period * 100.0 / total;
+		float percent = hist_entry__get_percent_limit(h);
 
-		if (percent < min_pcnt)
-			return NULL;
-
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -825,16 +814,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 }
 
 static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
-						  struct hists *hists,
 						  float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		u64 total = hists__total_period(hists);
-		float percent = 0.0;
-
-		if (total)
-			percent = h->stat.period * 100.0 / total;
+		float percent = hist_entry__get_percent_limit(h);
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
@@ -863,14 +847,14 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
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
@@ -913,8 +897,7 @@ do_offset:
 					break;
 				}
 			}
-			nd = hists__filter_entries(rb_next(nd), hb->hists,
-						   hb->min_pcnt);
+			nd = hists__filter_entries(rb_next(nd), hb->min_pcnt);
 			if (nd == NULL)
 				break;
 			--offset;
@@ -947,7 +930,7 @@ do_offset:
 				}
 			}
 
-			nd = hists__filter_prev_entries(rb_prev(nd), hb->hists,
+			nd = hists__filter_prev_entries(rb_prev(nd),
 							hb->min_pcnt);
 			if (nd == NULL)
 				break;
@@ -1118,7 +1101,6 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 {
 	struct rb_node *nd = hists__filter_entries(rb_first(browser->b.entries),
-						   browser->hists,
 						   browser->min_pcnt);
 	int printed = 0;
 
@@ -1126,8 +1108,7 @@ static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		printed += hist_browser__fprintf_entry(browser, h, fp);
-		nd = hists__filter_entries(rb_next(nd), browser->hists,
-					   browser->min_pcnt);
+		nd = hists__filter_entries(rb_next(nd), browser->min_pcnt);
 	}
 
 	return printed;
@@ -1361,8 +1342,7 @@ static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
 
 	while (nd) {
 		nr_entries++;
-		nd = hists__filter_entries(rb_next(nd), hb->hists,
-					   hb->min_pcnt);
+		nd = hists__filter_entries(rb_next(nd), hb->min_pcnt);
 	}
 
 	hb->nr_pcnt_entries = nr_entries;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 61ba102d8a2c..8d886a2a72d2 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -228,14 +228,12 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
 		u64 total = hists__total_period(h->hists);
-		float percent = 0.0;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
-		if (total)
-			percent = h->stat.period * 100.0 / total;
-
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < min_pcnt)
 			continue;
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index a1b133fed607..38ed7b2a48b7 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -454,12 +454,12 @@ print_entries:
 
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
index ac7629003dd4..8b62bc8ad740 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -144,6 +144,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
+
 void hists__output_resort(struct hists *hists);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f840a8d1ca70..7c6b0093c011 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -20,7 +20,7 @@
 
 #include "parse-options.h"
 #include "parse-events.h"
-
+#include "hist.h"
 #include "thread.h"
 
 extern regex_t parent_regex;
@@ -131,6 +131,21 @@ static inline void hist_entry__add_pair(struct hist_entry *pair,
 	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
+static inline float hist_entry__get_percent_limit(struct hist_entry *he)
+{
+	u64 period = he->stat.period;
+	u64 total_period = hists__total_period(he->hists);
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

