Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3AaRaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:30:00 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60086
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranina@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/25] perf gtk/browser: Add support for event group view
Date: Thu, 31 Jan 2013 14:25:17 -0300
Message-Id: <1359653128-10433-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members's overhead also when showing leader's if event
group is enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranina@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 38be79d..c87a98c 100644
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
1.8.1.1.361.gec3ae6e

