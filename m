Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3LRFWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:22:05 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54370 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3LRFVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:33 -0500
X-AuditID: 9c93017d-b7c5eae000004296-35-52b130d99db3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 15/18] perf tools: Apply percent-limit to cumulative percentage
Date: Wed, 18 Dec 2013 14:21:23 +0900
Message-Id: <1387344086-12744-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If -g cumulative option is given, it needs to show entries which don't
have self overhead.  So apply percent-limit to accumulated overhead
percentage in this case.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 34 ++++++++++++++++++++++++++--------
 tools/perf/ui/gtk/hists.c      | 11 +++++++++--
 tools/perf/ui/stdio/hist.c     | 11 +++++++++--
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index efa78894f70d..b02e71ecc5fe 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -828,12 +828,19 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hb->hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		if (symbol_conf.cumulate_callchain) {
+			percent = h->stat_acc->period * 100.0 /
+					hb->hists->stats.total_period;
+		} else {
+			percent = h->stat.period * 100.0 /
+					hb->hists->stats.total_period;
+		}
+
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -851,13 +858,17 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
-		if (percent < min_pcnt)
-			return NULL;
+		if (symbol_conf.cumulate_callchain) {
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+		} else {
+			percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
+		}
 
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -872,8 +883,15 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
+		float percent;
+
+		if (symbol_conf.cumulate_callchain) {
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+		} else {
+			percent = h->stat.period * 100.0 /
 					hists->stats.total_period;
+		}
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 70ed0d5e1b94..06ae3342e14f 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -296,12 +296,19 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		if (symbol_conf.cumulate_callchain) {
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+		} else {
+			percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
+		}
+
 		if (percent < min_pcnt)
 			continue;
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 4c4986e809d8..7ea8502192b0 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -487,12 +487,19 @@ print_entries:
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		if (symbol_conf.cumulate_callchain) {
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+		} else {
+			percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
+		}
+
 		if (percent < min_pcnt)
 			continue;
 
-- 
1.7.11.7

