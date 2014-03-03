Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaCCBOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:14:19 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61734 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaCCBOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:14:18 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-a6-5313d7673f28
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 02/13] perf ui/gtk: Reuse generic __hpp__fmt() code
Date: Mon,  3 Mar 2014 10:14:03 +0900
Message-Id: <1393809254-4480-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __hpp__color_fmt used in the gtk code can be replace by the
generic code with small change in print_fn callback.

This is a preparation to upcoming changes and no functional changes
intended.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 73 +++++++----------------------------------------
 tools/perf/ui/hist.c      |  9 ++----
 tools/perf/util/hist.h    |  6 ++++
 3 files changed, 19 insertions(+), 69 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44f3435..3dab00e748f2 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,16 +8,22 @@
 
 #define MAX_COLUMNS			32
 
-static int __percent_color_snprintf(char *buf, size_t size, double percent)
+static int __percent_color_snprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	int ret = 0;
+	va_list args;
+	double percent;
 	const char *markup;
 
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
+
 	markup = perf_gtk__get_percent_color(percent);
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, " %6.2f%%", percent);
+	ret += scnprintf(buf + ret, size - ret, fmt, percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -25,66 +31,6 @@ static int __percent_color_snprintf(char *buf, size_t size, double percent)
 	return ret;
 }
 
-
-static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *))
-{
-	int ret;
-	double percent = 0.0;
-	struct hists *hists = he->hists;
-	struct perf_evsel *evsel = hists_to_evsel(hists);
-
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
-
-	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
-
-	if (perf_evsel__is_group_event(evsel)) {
-		int prev_idx, idx_delta;
-		struct hist_entry *pair;
-		int nr_members = evsel->nr_members;
-
-		prev_idx = perf_evsel__group_idx(evsel);
-
-		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
-			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
-
-			evsel = hists_to_evsel(pair->hists);
-			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
-
-			while (idx_delta--) {
-				/*
-				 * zero-fill group members in the middle which
-				 * have no sample
-				 */
-				ret += __percent_color_snprintf(hpp->buf + ret,
-								hpp->size - ret,
-								0.0);
-			}
-
-			percent = 100.0 * period / total;
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							percent);
-
-			prev_idx = perf_evsel__group_idx(evsel);
-		}
-
-		idx_delta = nr_members - prev_idx - 1;
-
-		while (idx_delta--) {
-			/*
-			 * zero-fill group members at last which have no sample
-			 */
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							0.0);
-		}
-	}
-	return ret;
-}
-
 #define __HPP_COLOR_PERCENT_FN(_type, _field)					\
 static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
@@ -95,7 +41,8 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+			  __percent_color_snprintf, true);			\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 6094562c9523..085353435f07 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,12 +8,9 @@
 
 /* hist period print (hpp) functions */
 
-typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
-
-static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-		      u64 (*get_field)(struct hist_entry *),
-		      const char *fmt, hpp_snprint_fn print_fn,
-		      bool fmt_percent)
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       u64 (*get_field)(struct hist_entry *),
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	int ret;
 	struct hists *hists = he->hists;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743fa3ef7..97f924ec6af9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -166,6 +166,12 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
+
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       u64 (*get_field)(struct hist_entry *),
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+
 static inline size_t perf_hpp__use_color(void)
 {
 	return !symbol_conf.field_sep;
-- 
1.7.11.7

