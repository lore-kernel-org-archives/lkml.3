Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213Ab3GRUB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:01:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3GRTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 51/76] perf tools: Add struct perf_hpp_fmt into hpp callbacks
Date: Thu, 18 Jul 2013 16:49:38 -0300
Message-Id: <1374177003-3706-52-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding 'struct perf_hpp_fmt' into hpp callbacks, so commands can access
their private data.

It'll be handy for diff command in future to be able to access file
related data for each column.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-7vy2m18574b1bicoljn8e9lw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 10 +++---
 tools/perf/ui/gtk/hists.c      |  9 ++---
 tools/perf/ui/hist.c           | 79 +++++++++++++++++++++++++++---------------
 tools/perf/ui/stdio/hist.c     |  4 +--
 tools/perf/util/hist.h         | 10 +++---
 5 files changed, 71 insertions(+), 41 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 06e892f..2cb3916 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -685,8 +685,10 @@ static u64 __hpp_get_##_field(struct hist_entry *he)			\
 	return he->stat._field;						\
 }									\
 									\
-static int hist_browser__hpp_color_##_type(struct perf_hpp *hpp,	\
-					   struct hist_entry *he)	\
+static int								\
+hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
+				struct perf_hpp *hpp,			\
+				struct hist_entry *he)			\
 {									\
 	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
 }
@@ -762,9 +764,9 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			first = false;
 
 			if (fmt->color) {
-				width -= fmt->color(&hpp, entry);
+				width -= fmt->color(fmt, &hpp, entry);
 			} else {
-				width -= fmt->entry(&hpp, entry);
+				width -= fmt->entry(fmt, &hpp, entry);
 				slsmg_printf("%s", s);
 			}
 		}
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 3254903..cb2ed198 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -91,7 +91,8 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int perf_gtk__hpp_color_##_type(struct perf_hpp *hpp,			\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
 	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
@@ -244,7 +245,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
-		fmt->header(&hpp);
+		fmt->header(fmt, &hpp);
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
 							    -1, ltrim(s),
@@ -296,9 +297,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 		perf_hpp__for_each_format(fmt) {
 			if (fmt->color)
-				fmt->color(&hpp, h);
+				fmt->color(fmt, &hpp, h);
 			else
-				fmt->entry(&hpp, h);
+				fmt->entry(fmt, &hpp, h);
 
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 4bf91b0..5440d56 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -1,4 +1,5 @@
 #include <math.h>
+#include <linux/compiler.h>
 
 #include "../util/hist.h"
 #include "../util/util.h"
@@ -79,7 +80,8 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 }
 
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
-static int hpp__header_##_type(struct perf_hpp *hpp)			\
+static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+			       struct perf_hpp *hpp)			\
 {									\
 	int len = _min_width;						\
 									\
@@ -92,7 +94,8 @@ static int hpp__header_##_type(struct perf_hpp *hpp)			\
 }
 
 #define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
-static int hpp__width_##_type(struct perf_hpp *hpp __maybe_unused)	\
+static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+			      struct perf_hpp *hpp __maybe_unused)	\
 {									\
 	int len = _min_width;						\
 									\
@@ -110,14 +113,16 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  (hpp_snprint_fn)percent_color_snprintf, true);	\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
-static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
 	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
@@ -130,7 +135,8 @@ static u64 he_get_raw_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
 	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf, false);	\
@@ -158,12 +164,14 @@ HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
 
 
-static int hpp__header_baseline(struct perf_hpp *hpp)
+static int hpp__header_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+				struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Baseline");
 }
 
-static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp __maybe_unused)
 {
 	return 8;
 }
@@ -184,7 +192,8 @@ static double baseline_percent(struct hist_entry *he)
 	return percent;
 }
 
-static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
@@ -194,7 +203,8 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
-static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
@@ -205,19 +215,22 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
-static int hpp__header_period_baseline(struct perf_hpp *hpp)
+static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+				       struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
 }
 
-static int hpp__width_period_baseline(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_period_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+				      struct perf_hpp *hpp __maybe_unused)
 {
 	return 12;
 }
 
-static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+				      struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 period = pair ? pair->stat.period : 0;
@@ -226,19 +239,22 @@ static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *h
 	return scnprintf(hpp->buf, hpp->size, fmt, period);
 }
 
-static int hpp__header_delta(struct perf_hpp *hpp)
+static int hpp__header_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Delta");
 }
 
-static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_delta(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 7;
 }
 
-static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
@@ -259,19 +275,22 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_ratio(struct perf_hpp *hpp)
+static int hpp__header_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
 }
 
-static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_ratio(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 14;
 }
 
-static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
@@ -291,19 +310,22 @@ static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_wdiff(struct perf_hpp *hpp)
+static int hpp__header_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Weighted diff");
 }
 
-static int hpp__width_wdiff(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 14;
 }
 
-static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
@@ -323,19 +345,22 @@ static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_formula(struct perf_hpp *hpp)
+static int hpp__header_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Formula");
 }
 
-static int hpp__width_formula(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_formula(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp __maybe_unused)
 {
 	return 70;
 }
 
-static int hpp__entry_formula(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
+			      struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
@@ -454,9 +479,9 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 			first = false;
 
 		if (color && fmt->color)
-			ret = fmt->color(hpp, he);
+			ret = fmt->color(fmt, hpp, he);
 		else
-			ret = fmt->entry(hpp, he);
+			ret = fmt->entry(fmt, hpp, he);
 
 		advance_hpp(hpp, ret);
 	}
@@ -499,7 +524,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(&dummy_hpp);
+		ret += fmt->width(fmt, &dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index ae7a754..ee70372 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -365,7 +365,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		fmt->header(&dummy_hpp);
+		fmt->header(fmt, &dummy_hpp);
 		fprintf(fp, "%s", bf);
 	}
 
@@ -410,7 +410,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		width = fmt->width(&dummy_hpp);
+		width = fmt->width(fmt, &dummy_hpp);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2d3790f..0c62116 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -141,10 +141,12 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	int (*header)(struct perf_hpp *hpp);
-	int (*width)(struct perf_hpp *hpp);
-	int (*color)(struct perf_hpp *hpp, struct hist_entry *he);
-	int (*entry)(struct perf_hpp *hpp, struct hist_entry *he);
+	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*color)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct hist_entry *he);
+	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct hist_entry *he);
 
 	struct list_head list;
 };
-- 
1.8.1.4

