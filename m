Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbaCNVax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbaCNVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf ui/gtk: Reuse generic __hpp__fmt() code
Date: Fri, 14 Mar 2014 18:30:02 -0300
Message-Id: <1394832610-17818-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The __hpp__color_fmt used in the gtk code can be replace by the generic
code with small change in print_fn callback.

This is a preparation to upcoming changes and no functional changes
intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393809254-4480-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

