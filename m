Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3AVJLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:11:01 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3AVJK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:10:58 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-dc-50fe579b55d2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranina@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 12/19] perf gtk/browser: Add support for event group view
Date: Tue, 22 Jan 2013 18:09:40 +0900
Message-Id: <1358845787-1350-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members's overhead also when showing leader's if event
group is enabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranina@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 38be79d4b5c6..c87a98c7efaa 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,8 +8,7 @@
 
 #define MAX_COLUMNS			32
 
-static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
-					    double percent)
+static int __percent_color_snprintf(char *buf, size_t size, double percent)
 {
 	int ret = 0;
 	const char *markup;
@@ -18,7 +17,7 @@ static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
+	ret += scnprintf(buf + ret, size - ret, " %6.2f%%", percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -37,7 +36,55 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);
+	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
+
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			return ret;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			while (idx_delta--) {
+				/*
+				 * zero-fill group members in the middle which
+				 * have no sample
+				 */
+				ret += __percent_color_snprintf(hpp->buf + ret,
+								hpp->size - ret,
+								0.0);
+			}
+
+			percent = 100.0 * period / total;
+			ret += __percent_color_snprintf(hpp->buf + ret,
+							hpp->size - ret,
+							percent);
+
+			prev_idx = perf_evsel__group_idx(evsel);
+		}
+
+		idx_delta = nr_members - prev_idx - 1;
+
+		while (idx_delta--) {
+			/*
+			 * zero-fill group members at last which have no sample
+			 */
+			ret += __percent_color_snprintf(hpp->buf + ret,
+							hpp->size - ret,
+							0.0);
+		}
+	}
 	return ret;
 }
 
@@ -96,6 +143,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
+		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
-- 
1.7.11.7

