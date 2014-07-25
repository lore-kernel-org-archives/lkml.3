Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbaGYBUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:20:47 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46444 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbaGYBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:19 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/7] perf tools: Add name field into perf_hpp_fmt
Date: Fri, 25 Jul 2014 10:18:57 +0900
Message-Id: <1406251138-6574-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes the code a bit simpler and easier to debug IMHO.

I guess it can also remove similar code in perf diff, but let's keep
it for a future work. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c |   4 +-
 tools/perf/ui/hist.c      | 109 ++++++++++++++++++++++------------------------
 tools/perf/util/hist.h    |   1 +
 tools/perf/util/sort.c    |   6 +--
 4 files changed, 57 insertions(+), 63 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 897b2e140428..f3fa4258b256 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -207,10 +207,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		if (perf_hpp__is_sort_entry(fmt))
 			sym_col = col_idx;
 
-		fmt->header(fmt, &hpp, hists_to_evsel(hists));
-
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, ltrim(s),
+							    -1, fmt->name,
 							    renderer, "markup",
 							    col_idx++, NULL);
 	}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b2d60a95f01d..93285df06164 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -209,7 +209,7 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 	return ret;
 }
 
-#define __HPP_WIDTH_FN(_type, _str)					\
+#define __HPP_WIDTH_FN(_type)						\
 static int hpp__width_##_type(struct perf_hpp_fmt *fmt,			\
 			      struct perf_hpp *hpp __maybe_unused,	\
 			      struct perf_evsel *evsel)			\
@@ -219,19 +219,19 @@ static int hpp__width_##_type(struct perf_hpp_fmt *fmt,			\
 	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * fmt->len);		\
 									\
-	if (len < (int)strlen(_str))					\
-		len = strlen(_str);					\
+	if (len < (int)strlen(fmt->name))				\
+		len = strlen(fmt->name);				\
 									\
 	return len;							\
 }
 
-#define __HPP_HEADER_FN(_type, _str) 					\
+#define __HPP_HEADER_FN(_type) 						\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt,		\
 			       struct perf_hpp *hpp,			\
 			       struct perf_evsel *evsel)		\
 {									\
 	int len = hpp__width_##_type(fmt, hpp, evsel);			\
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, fmt->name);	\
 }
 
 static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
@@ -337,38 +337,35 @@ static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
 }
 
 
-#define HPP_PERCENT_FNS(_type, _str, _field)				\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_PERCENT_FNS(_type, _field)					\
+__HPP_WIDTH_FN(_type)							\
+__HPP_HEADER_FN(_type)							\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
 __HPP_ENTRY_PERCENT_FN(_type, _field)					\
 __HPP_SORT_FN(_type, _field)
 
-#define HPP_PERCENT_ACC_FNS(_type, _str, _field)			\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_PERCENT_ACC_FNS(_type, _field)				\
+__HPP_WIDTH_FN(_type)							\
+__HPP_HEADER_FN(_type)							\
 __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
 __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
 __HPP_SORT_ACC_FN(_type, _field)
 
-#define HPP_RAW_FNS(_type, _str, _field)				\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_RAW_FNS(_type, _field)					\
+__HPP_WIDTH_FN(_type)							\
+__HPP_HEADER_FN(_type)							\
 __HPP_ENTRY_RAW_FN(_type, _field)					\
 __HPP_SORT_RAW_FN(_type, _field)
 
-__HPP_WIDTH_FN(overhead_self, "Self")
-__HPP_HEADER_FN(overhead_self, "Self")
+HPP_PERCENT_FNS(overhead, period)
+HPP_PERCENT_FNS(overhead_sys, period_sys)
+HPP_PERCENT_FNS(overhead_us, period_us)
+HPP_PERCENT_FNS(overhead_guest_sys, period_guest_sys)
+HPP_PERCENT_FNS(overhead_guest_us, period_guest_us)
+HPP_PERCENT_ACC_FNS(overhead_acc, period)
 
-HPP_PERCENT_FNS(overhead, "Overhead", period)
-HPP_PERCENT_FNS(overhead_sys, "sys", period_sys)
-HPP_PERCENT_FNS(overhead_us, "usr", period_us)
-HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys)
-HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us)
-HPP_PERCENT_ACC_FNS(overhead_acc, "Children", period)
-
-HPP_RAW_FNS(samples, "Samples", nr_events)
-HPP_RAW_FNS(period, "Period", period)
+HPP_RAW_FNS(samples, nr_events)
+HPP_RAW_FNS(period, period)
 
 static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
 			    struct hist_entry *b __maybe_unused)
@@ -376,47 +373,50 @@ static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
 	return 0;
 }
 
-#define HPP__COLOR_PRINT_FNS(_name)			\
+#define HPP__COLOR_PRINT_FNS(_name, _fn)		\
 	{						\
-		.header	= hpp__header_ ## _name,	\
-		.width	= hpp__width_ ## _name,		\
-		.color	= hpp__color_ ## _name,		\
-		.entry	= hpp__entry_ ## _name,		\
+		.name   = _name,			\
+		.header	= hpp__header_ ## _fn,		\
+		.width	= hpp__width_ ## _fn,		\
+		.color	= hpp__color_ ## _fn,		\
+		.entry	= hpp__entry_ ## _fn,		\
 		.cmp	= hpp__nop_cmp,			\
 		.collapse = hpp__nop_cmp,		\
-		.sort	= hpp__sort_ ## _name,		\
+		.sort	= hpp__sort_ ## _fn,		\
 	}
 
-#define HPP__COLOR_ACC_PRINT_FNS(_name)			\
+#define HPP__COLOR_ACC_PRINT_FNS(_name, _fn)		\
 	{						\
-		.header	= hpp__header_ ## _name,	\
-		.width	= hpp__width_ ## _name,		\
-		.color	= hpp__color_ ## _name,		\
-		.entry	= hpp__entry_ ## _name,		\
+		.name   = _name,			\
+		.header	= hpp__header_ ## _fn,		\
+		.width	= hpp__width_ ## _fn,		\
+		.color	= hpp__color_ ## _fn,		\
+		.entry	= hpp__entry_ ## _fn,		\
 		.cmp	= hpp__nop_cmp,			\
 		.collapse = hpp__nop_cmp,		\
-		.sort	= hpp__sort_ ## _name,		\
+		.sort	= hpp__sort_ ## _fn,		\
 	}
 
-#define HPP__PRINT_FNS(_name)				\
+#define HPP__PRINT_FNS(_name, _fn)			\
 	{						\
-		.header	= hpp__header_ ## _name,	\
-		.width	= hpp__width_ ## _name,		\
-		.entry	= hpp__entry_ ## _name,		\
+		.name   = _name,			\
+		.header	= hpp__header_ ## _fn,	\
+		.width	= hpp__width_ ## _fn,		\
+		.entry	= hpp__entry_ ## _fn,		\
 		.cmp	= hpp__nop_cmp,			\
 		.collapse = hpp__nop_cmp,		\
-		.sort	= hpp__sort_ ## _name,		\
+		.sort	= hpp__sort_ ## _fn,		\
 	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
-	HPP__COLOR_PRINT_FNS(overhead),
-	HPP__COLOR_PRINT_FNS(overhead_sys),
-	HPP__COLOR_PRINT_FNS(overhead_us),
-	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
-	HPP__COLOR_PRINT_FNS(overhead_guest_us),
-	HPP__COLOR_ACC_PRINT_FNS(overhead_acc),
-	HPP__PRINT_FNS(samples),
-	HPP__PRINT_FNS(period)
+	HPP__COLOR_PRINT_FNS("Overhead", overhead),
+	HPP__COLOR_PRINT_FNS("sys", overhead_sys),
+	HPP__COLOR_PRINT_FNS("usr", overhead_us),
+	HPP__COLOR_PRINT_FNS("guest sys", overhead_guest_sys),
+	HPP__COLOR_PRINT_FNS("guest usr", overhead_guest_us),
+	HPP__COLOR_ACC_PRINT_FNS("Children", overhead_acc),
+	HPP__PRINT_FNS("Samples", samples),
+	HPP__PRINT_FNS("Period", period)
 };
 
 LIST_HEAD(perf_hpp__list);
@@ -466,11 +466,7 @@ void perf_hpp__init(void)
 
 	if (symbol_conf.cumulate_callchain) {
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_ACC);
-
-		perf_hpp__format[PERF_HPP__OVERHEAD].header =
-						hpp__header_overhead_self;
-		perf_hpp__format[PERF_HPP__OVERHEAD].width =
-						hpp__width_overhead_self;
+		perf_hpp__format[PERF_HPP__OVERHEAD].name = "Self";
 	}
 
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
@@ -536,8 +532,7 @@ void perf_hpp__cancel_cumulate(void)
 		return;
 
 	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
-	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
-	perf_hpp__format[PERF_HPP__OVERHEAD].width = hpp__width_overhead;
+	perf_hpp__format[PERF_HPP__OVERHEAD].name = "Overhead";
 }
 
 void perf_hpp__setup_output_field(void)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2e70003fcd00..95405a8fbd95 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -192,6 +192,7 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
+	const char *name;
 	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		      struct perf_evsel *evsel);
 	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c75d95023d4c..0be2d2bc922a 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1203,8 +1203,7 @@ void perf_hpp__reset_sort_width(struct perf_hpp_fmt *fmt, struct hists *hists)
 		return;
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
-	hists__new_col_len(hists, hse->se->se_width_idx,
-			   strlen(hse->se->se_header));
+	hists__new_col_len(hists, hse->se->se_width_idx, strlen(fmt->name));
 }
 
 static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
@@ -1218,7 +1217,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	if (!len)
 		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, hse->se->se_header);
+	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, fmt->name);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
@@ -1262,6 +1261,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 	}
 
 	hse->se = sd->entry;
+	hse->hpp.name = sd->entry->se_header;
 	hse->hpp.header = __sort__hpp_header;
 	hse->hpp.width = __sort__hpp_width;
 	hse->hpp.entry = __sort__hpp_entry;
-- 
2.0.0

