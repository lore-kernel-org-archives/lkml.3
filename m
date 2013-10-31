Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3JaG4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43539 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3JaG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:26 -0400
X-AuditID: 9c930197-b7b3eae00000122e-f0-5271ff17236a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 13/14] perf tools: Apply percent-limit to cumulative percentage
Date: Thu, 31 Oct 2013 15:56:15 +0900
Message-Id: <1383202576-28141-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/browsers/hists.c | 15 ++++++++++++---
 tools/perf/ui/gtk/hists.c      |  4 ++++
 tools/perf/ui/stdio/hist.c     |  4 ++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2cea6cd9824e..07f500d8df1b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -834,6 +834,10 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 		if (h->filtered)
 			continue;
 
+		if (callchain_param.mode == CHAIN_CUMULATIVE)
+			percent = h->stat_acc->period * 100.0 /
+					hb->hists->stats.total_period;
+
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -854,10 +858,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 		float percent = h->stat.period * 100.0 /
 					hists->stats.total_period;
 
-		if (percent < min_pcnt)
-			return NULL;
+		if (callchain_param.mode == CHAIN_CUMULATIVE)
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
 
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -875,6 +880,10 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
 		float percent = h->stat.period * 100.0 /
 					hists->stats.total_period;
 
+		if (callchain_param.mode == CHAIN_CUMULATIVE)
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 70ed0d5e1b94..b93302840cce 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -302,6 +302,10 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		if (h->filtered)
 			continue;
 
+		if (callchain_param.mode == CHAIN_CUMULATIVE)
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+
 		if (percent < min_pcnt)
 			continue;
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 302f08afd6a2..49db435f0cc2 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -496,6 +496,10 @@ print_entries:
 		if (h->filtered)
 			continue;
 
+		if (callchain_param.mode == CHAIN_CUMULATIVE)
+			percent = h->stat_acc->period * 100.0 /
+					hists->stats.total_period;
+
 		if (percent < min_pcnt)
 			continue;
 
-- 
1.7.11.7

