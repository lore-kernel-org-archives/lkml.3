Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbaGYBTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:20 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46361 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbaGYBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:17 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/7] perf tools: Save column length in perf_hpp_fmt
Date: Fri, 25 Jul 2014 10:18:54 +0900
Message-Id: <1406251138-6574-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save column length in the hpp format and pass it to print functions.
This is a preparation for users to control column width in the output.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |   2 +-
 tools/perf/ui/hist.c           | 135 +++++++++++++++++++++++++++--------------
 tools/perf/util/hist.h         |   2 +
 tools/perf/util/sort.c         |   3 +-
 4 files changed, 94 insertions(+), 48 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 02507ba944e3..c1d8d3925fe1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -849,7 +849,7 @@ static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		/* We need to add the length of the columns header. */
+		/* We need to ensure length of the columns header. */
 		perf_hpp__reset_width(fmt, hists);
 
 		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index c6cffbd0b0e1..e28ca972d046 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -110,7 +110,7 @@ int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
 {
 	if (!symbol_conf.cumulate_callchain) {
 		return snprintf(hpp->buf, hpp->size, "%*s",
-				fmt_percent ? 8 : 12, "N/A");
+				fmt_percent ? len + 2 : len + 1, "N/A");
 	}
 
 	return __hpp__fmt(hpp, he, get_field, fmt, len, print_fn, fmt_percent);
@@ -190,32 +190,31 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 	return ret;
 }
 
-#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
-static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			       struct perf_hpp *hpp,			\
-			       struct perf_evsel *evsel)		\
-{									\
-	int len = _min_width;						\
-									\
-	if (symbol_conf.event_group)					\
-		len = max(len, evsel->nr_members * _unit_width);	\
-									\
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
-}
-
-#define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
-static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+#define __HPP_WIDTH_FN(_type, _str)					\
+static int hpp__width_##_type(struct perf_hpp_fmt *fmt,			\
 			      struct perf_hpp *hpp __maybe_unused,	\
 			      struct perf_evsel *evsel)			\
 {									\
-	int len = _min_width;						\
+	int len = fmt->len;						\
 									\
 	if (symbol_conf.event_group)					\
-		len = max(len, evsel->nr_members * _unit_width);	\
+		len = max(len, evsel->nr_members * len);		\
+									\
+	if (len < (int)strlen(_str))					\
+		len = strlen(_str);					\
 									\
 	return len;							\
 }
 
+#define __HPP_HEADER_FN(_type, _str) 					\
+static int hpp__header_##_type(struct perf_hpp_fmt *fmt,		\
+			       struct perf_hpp *hpp,			\
+			       struct perf_evsel *evsel)		\
+{									\
+	int len = hpp__width_##_type(fmt, hpp, evsel);			\
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
+}
+
 static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	va_list args;
@@ -251,18 +250,19 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
+static int hpp__color_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	6,		\
+	int len = fmt->len - 2;	/* 2 for a space and a % sign */		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	len,		\
 			  hpp_color_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
-static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : 6;				\
+	int len = symbol_conf.field_sep ? 1 : fmt->len - 2;			\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	len,		\
 			  hpp_entry_scnprintf, true);				\
 }
@@ -279,18 +279,19 @@ static u64 he_get_acc_##_field(struct hist_entry *he)				\
 	return he->stat_acc->_field;						\
 }										\
 										\
-static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
+static int hpp__color_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%",	6, 	\
+	int len = fmt->len - 2;	/* 2 for a space and a % sign */		\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%",	len, 	\
 			      hpp_color_scnprintf, true);			\
 }
 
 #define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
-static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : 6;				\
+	int len = symbol_conf.field_sep ? 1 : fmt->len - 2;			\
 	return __hpp__fmt_acc(hpp, he, he_get_##_field, " %*.2f%%", len,	\
 			      hpp_entry_scnprintf, true);			\
 }
@@ -307,10 +308,10 @@ static u64 he_get_raw_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : 11;				\
+	int len = symbol_conf.field_sep ? 1 : fmt->len - 1;			\
 	return __hpp__fmt(hpp, he, he_get_raw_##_field, " %*"PRIu64, len, 	\
 			  hpp_entry_scnprintf, false);				\
 }
@@ -322,37 +323,38 @@ static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
 }
 
 
-#define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
-__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
-__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+#define HPP_PERCENT_FNS(_type, _str, _field)				\
+__HPP_WIDTH_FN(_type, _str)						\
+__HPP_HEADER_FN(_type, _str)						\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
 __HPP_ENTRY_PERCENT_FN(_type, _field)					\
 __HPP_SORT_FN(_type, _field)
 
-#define HPP_PERCENT_ACC_FNS(_type, _str, _field, _min_width, _unit_width)\
-__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
-__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+#define HPP_PERCENT_ACC_FNS(_type, _str, _field)			\
+__HPP_WIDTH_FN(_type, _str)						\
+__HPP_HEADER_FN(_type, _str)						\
 __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
 __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
 __HPP_SORT_ACC_FN(_type, _field)
 
-#define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
-__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
-__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+#define HPP_RAW_FNS(_type, _str, _field)				\
+__HPP_WIDTH_FN(_type, _str)						\
+__HPP_HEADER_FN(_type, _str)						\
 __HPP_ENTRY_RAW_FN(_type, _field)					\
 __HPP_SORT_RAW_FN(_type, _field)
 
-__HPP_HEADER_FN(overhead_self, "Self", 8, 8)
+__HPP_WIDTH_FN(overhead_self, "Self")
+__HPP_HEADER_FN(overhead_self, "Self")
 
-HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
-HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
-HPP_PERCENT_FNS(overhead_us, "usr", period_us, 8, 8)
-HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys, 9, 8)
-HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
-HPP_PERCENT_ACC_FNS(overhead_acc, "Children", period, 8, 8)
+HPP_PERCENT_FNS(overhead, "Overhead", period)
+HPP_PERCENT_FNS(overhead_sys, "sys", period_sys)
+HPP_PERCENT_FNS(overhead_us, "usr", period_us)
+HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys)
+HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us)
+HPP_PERCENT_ACC_FNS(overhead_acc, "Children", period)
 
-HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
-HPP_RAW_FNS(period, "Period", period, 12, 12)
+HPP_RAW_FNS(samples, "Samples", nr_events)
+HPP_RAW_FNS(period, "Period", period)
 
 static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
 			    struct hist_entry *b __maybe_unused)
@@ -453,6 +455,8 @@ void perf_hpp__init(void)
 
 		perf_hpp__format[PERF_HPP__OVERHEAD].header =
 						hpp__header_overhead_self;
+		perf_hpp__format[PERF_HPP__OVERHEAD].width =
+						hpp__width_overhead_self;
 	}
 
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
@@ -519,6 +523,7 @@ void perf_hpp__cancel_cumulate(void)
 
 	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
 	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
+	perf_hpp__format[PERF_HPP__OVERHEAD].width = hpp__width_overhead;
 }
 
 void perf_hpp__setup_output_field(void)
@@ -623,3 +628,41 @@ unsigned int hists__sort_list_width(struct hists *hists)
 
 	return ret;
 }
+
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
+{
+	int idx;
+
+	if (perf_hpp__is_sort_entry(fmt))
+		return perf_hpp__reset_sort_width(fmt, hists);
+
+	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
+		if (fmt == &perf_hpp__format[idx])
+			break;
+	}
+
+	if (idx == PERF_HPP__MAX_INDEX)
+		return;
+
+	switch (idx) {
+	case PERF_HPP__OVERHEAD:
+	case PERF_HPP__OVERHEAD_SYS:
+	case PERF_HPP__OVERHEAD_US:
+	case PERF_HPP__OVERHEAD_ACC:
+		fmt->len = 8;
+		break;
+
+	case PERF_HPP__OVERHEAD_GUEST_SYS:
+	case PERF_HPP__OVERHEAD_GUEST_US:
+		fmt->len = 9;
+		break;
+
+	case PERF_HPP__SAMPLES:
+	case PERF_HPP__PERIOD:
+		fmt->len = 12;
+		break;
+
+	default:
+		break;
+	}
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 13d074db9ef1..a7ae890f4c71 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -207,6 +207,7 @@ struct perf_hpp_fmt {
 	struct list_head list;
 	struct list_head sort_list;
 	bool elide;
+	int len;
 };
 
 extern struct list_head perf_hpp__list;
@@ -261,6 +262,7 @@ static inline bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
 }
 
 void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
+void perf_hpp__reset_sort_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index eda9ee836cee..a7f8a7b0eced 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1194,7 +1194,7 @@ bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b)
 	return hse_a->se == hse_b->se;
 }
 
-void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
+void perf_hpp__reset_sort_width(struct perf_hpp_fmt *fmt, struct hists *hists)
 {
 	struct hpp_sort_entry *hse;
 
@@ -1265,6 +1265,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
 	hse->hpp.elide = false;
+	hse->hpp.len = 0;
 
 	return hse;
 }
-- 
2.0.0

