Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbaGYBTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:22 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46425 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbaGYBTR (ORCPT
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
Subject: [PATCH 4/7] perf report: Honor column width setting
Date: Fri, 25 Jul 2014 10:18:55 +0900
Message-Id: <1406251138-6574-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set column width and do not change it if user gives -w/--column-widths
option.  It'll truncate longer symbols than the width if exists.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 23 ++++++++----
 tools/perf/ui/gtk/hists.c      | 10 ++---
 tools/perf/ui/hist.c           | 84 +++++++++++++++++++++++++++++-------------
 tools/perf/ui/stdio/hist.c     |  4 +-
 tools/perf/util/hist.h         | 14 ++++---
 tools/perf/util/sort.c         | 46 ++++++++++++++---------
 6 files changed, 117 insertions(+), 64 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c1d8d3925fe1..f0ef031558dd 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -678,12 +678,12 @@ static u64 __hpp_get_##_field(struct hist_entry *he)			\
 }									\
 									\
 static int								\
-hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
+hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt,		\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__fmt(hpp, he, __hpp_get_##_field, " %*.2f%%", 6,	\
-			  __hpp__slsmg_color_printf, true);		\
+	return hpp__fmt(fmt, hpp, he, __hpp_get_##_field, " %*.2f%%",	\
+			__hpp__slsmg_color_printf, true);		\
 }
 
 #define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)			\
@@ -693,19 +693,20 @@ static u64 __hpp_get_acc_##_field(struct hist_entry *he)		\
 }									\
 									\
 static int								\
-hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
+hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt,		\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
 	if (!symbol_conf.cumulate_callchain) {				\
+		int len = fmt->user_len ?: fmt->len;			\
 		int ret = scnprintf(hpp->buf, hpp->size,		\
-				    "%*s", 8, "N/A");			\
+				    "%*s", len, "N/A");			\
 		slsmg_printf("%s", hpp->buf);				\
 									\
 		return ret;						\
 	}								\
-	return __hpp__fmt(hpp, he, __hpp_get_acc_##_field, " %*.2f%%",	\
-			  6, __hpp__slsmg_color_printf, true);	\
+	return hpp__fmt(fmt, hpp, he, __hpp_get_acc_##_field,		\
+			" %*.2f%%", __hpp__slsmg_color_printf, true);	\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
@@ -797,8 +798,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (fmt->color) {
 				width -= fmt->color(fmt, &hpp, entry);
 			} else {
-				width -= fmt->entry(fmt, &hpp, entry);
+				int ret = fmt->entry(fmt, &hpp, entry);
+				s[ret] = '\0';
 				slsmg_printf("%s", s);
+
+				width -= ret;
 			}
 		}
 
@@ -1549,6 +1553,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	memset(options, 0, sizeof(options));
 
+	if (symbol_conf.col_width_list_str)
+		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
+
 	while (1) {
 		const struct thread *thread = NULL;
 		const struct dso *dso = NULL;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 91f6cd7d2312..897b2e140428 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -41,12 +41,12 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 	return he->stat._field;							\
 }										\
 										\
-static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt,		\
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%", 6,		\
-			  __percent_color_snprintf, true);			\
+	return hpp__fmt(fmt, hpp, he, he_get_##_field, " %*.2f%%",		\
+			__percent_color_snprintf, true);			\
 }
 
 #define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
@@ -59,8 +59,8 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%", 6, 	\
-			      __percent_color_snprintf, true);			\
+	return hpp__fmt_acc(fmt, hpp, he, he_get_acc_##_field, " %*.2f%%", 	\
+			    __percent_color_snprintf, true);			\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e28ca972d046..b2d60a95f01d 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -15,9 +15,9 @@
 	__ret;							\
 })
 
-int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, const char *fmt, int len,
-	       hpp_snprint_fn print_fn, bool fmt_percent)
+static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+		      hpp_field_fn get_field, const char *fmt, int len,
+		      hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	int ret;
 	struct hists *hists = he->hists;
@@ -104,16 +104,35 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	return ret;
 }
 
-int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
-		   hpp_field_fn get_field, const char *fmt, int len,
-		   hpp_snprint_fn print_fn, bool fmt_percent)
+int hpp__fmt(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+	     struct hist_entry *he, hpp_field_fn get_field,
+	     const char *fmtstr, hpp_snprint_fn print_fn, bool fmt_percent)
+{
+	int len = fmt->user_len ?: fmt->len;
+
+	if (symbol_conf.field_sep) {
+		return __hpp__fmt(hpp, he, get_field, fmtstr, 1,
+				  print_fn, fmt_percent);
+	}
+
+	if (fmt_percent)
+		len -= 2; /* 2 for a space and a % sign */
+	else
+		len -= 1;
+
+	return  __hpp__fmt(hpp, he, get_field, fmtstr, len, print_fn, fmt_percent);
+}
+
+int hpp__fmt_acc(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		 struct hist_entry *he, hpp_field_fn get_field,
+		 const char *fmtstr, hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	if (!symbol_conf.cumulate_callchain) {
-		return snprintf(hpp->buf, hpp->size, "%*s",
-				fmt_percent ? len + 2 : len + 1, "N/A");
+		int len = fmt->user_len ?: fmt->len;
+		return snprintf(hpp->buf, hpp->size, " %*s", len - 1, "N/A");
 	}
 
-	return __hpp__fmt(hpp, he, get_field, fmt, len, print_fn, fmt_percent);
+	return hpp__fmt(fmt, hpp, he, get_field, fmtstr, print_fn, fmt_percent);
 }
 
 static int field_cmp(u64 field_a, u64 field_b)
@@ -195,10 +214,10 @@ static int hpp__width_##_type(struct perf_hpp_fmt *fmt,			\
 			      struct perf_hpp *hpp __maybe_unused,	\
 			      struct perf_evsel *evsel)			\
 {									\
-	int len = fmt->len;						\
+	int len = fmt->user_len ?: fmt->len;				\
 									\
 	if (symbol_conf.event_group)					\
-		len = max(len, evsel->nr_members * len);		\
+		len = max(len, evsel->nr_members * fmt->len);		\
 									\
 	if (len < (int)strlen(_str))					\
 		len = strlen(_str);					\
@@ -253,18 +272,16 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = fmt->len - 2;	/* 2 for a space and a % sign */		\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	len,		\
-			  hpp_color_scnprintf, true);				\
+	return hpp__fmt(fmt, hpp, he, he_get_##_field, " %*.2f%%",		\
+			hpp_color_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
 static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : fmt->len - 2;			\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	len,		\
-			  hpp_entry_scnprintf, true);				\
+	return hpp__fmt(fmt, hpp, he, he_get_##_field, " %*.2f%%",		\
+			hpp_entry_scnprintf, true);				\
 }
 
 #define __HPP_SORT_FN(_type, _field)						\
@@ -282,18 +299,16 @@ static u64 he_get_acc_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = fmt->len - 2;	/* 2 for a space and a % sign */		\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%",	len, 	\
-			      hpp_color_scnprintf, true);			\
+	return hpp__fmt_acc(fmt, hpp, he, he_get_acc_##_field, " %*.2f%%", 	\
+			    hpp_color_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
 static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : fmt->len - 2;			\
-	return __hpp__fmt_acc(hpp, he, he_get_##_field, " %*.2f%%", len,	\
-			      hpp_entry_scnprintf, true);			\
+	return hpp__fmt_acc(fmt, hpp, he, he_get_##_field, " %*.2f%%",		\
+			    hpp_entry_scnprintf, true);				\
 }
 
 #define __HPP_SORT_ACC_FN(_type, _field)					\
@@ -311,9 +326,8 @@ static u64 he_get_raw_##_field(struct hist_entry *he)				\
 static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	int len = symbol_conf.field_sep ? 1 : fmt->len - 1;			\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, " %*"PRIu64, len, 	\
-			  hpp_entry_scnprintf, false);				\
+	return hpp__fmt(fmt, hpp, he, he_get_raw_##_field, " %*"PRIu64, 	\
+			hpp_entry_scnprintf, false);				\
 }
 
 #define __HPP_SORT_RAW_FN(_type, _field)					\
@@ -666,3 +680,21 @@ void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
 		break;
 	}
 }
+
+void perf_hpp__set_user_width(const char *width_list_str)
+{
+	struct perf_hpp_fmt *fmt;
+	const char *ptr = width_list_str;
+
+	perf_hpp__for_each_format(fmt) {
+		char *p;
+
+		int len = strtol(ptr, &p, 10);
+		fmt->user_len = len;
+
+		if (*p == ',')
+			ptr = p + 1;
+		else
+			break;
+	}
+}
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 40af0acb4fe9..15b451acbde6 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -395,10 +395,12 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 	init_rem_hits();
 
-
 	perf_hpp__for_each_format(fmt)
 		perf_hpp__reset_width(fmt, hists);
 
+	if (symbol_conf.col_width_list_str)
+		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
+
 	if (!show_header)
 		goto print_entries;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a7ae890f4c71..2e70003fcd00 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,6 +208,7 @@ struct perf_hpp_fmt {
 	struct list_head sort_list;
 	bool elide;
 	int len;
+	int user_len;
 };
 
 extern struct list_head perf_hpp__list;
@@ -263,17 +264,18 @@ static inline bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
 
 void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 void perf_hpp__reset_sort_width(struct perf_hpp_fmt *fmt, struct hists *hists);
+void perf_hpp__set_user_width(const char *width_list_str);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
-int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, const char *fmt, int len,
-	       hpp_snprint_fn print_fn, bool fmt_percent);
-int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
-		   hpp_field_fn get_field, const char *fmt, int len,
-		   hpp_snprint_fn print_fn, bool fmt_percent);
+int hpp__fmt(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+	     struct hist_entry *he, hpp_field_fn get_field,
+	     const char *fmtstr, hpp_snprint_fn print_fn, bool fmt_percent);
+int hpp__fmt_acc(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		 struct hist_entry *he, hpp_field_fn get_field,
+		 const char *fmtstr, hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a7f8a7b0eced..c75d95023d4c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -70,8 +70,10 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	const char *comm = thread__comm_str(he->thread);
-	return repsep_snprintf(bf, size, "%5d:%-*s", he->thread->tid,
-			       width - 6, comm ?: "");
+
+	width = max(7U, width) - 6;
+	return repsep_snprintf(bf, size, "%5d:%-*.*s", he->thread->tid,
+			       width, width, comm ?: "");
 }
 
 struct sort_entry sort_thread = {
@@ -106,7 +108,7 @@ sort__comm_sort(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*s", width, comm__str(he->comm));
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, comm__str(he->comm));
 }
 
 struct sort_entry sort_comm = {
@@ -152,10 +154,10 @@ static int _hist_entry__dso_snprintf(struct map *map, char *bf,
 	if (map && map->dso) {
 		const char *dso_name = !verbose ? map->dso->short_name :
 			map->dso->long_name;
-		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
+		return repsep_snprintf(bf, size, "%-*.*s", width, width, dso_name);
 	}
 
-	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, "[unknown]");
 }
 
 static int hist_entry__dso_snprintf(struct hist_entry *he, char *bf,
@@ -257,7 +259,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				       width - ret, "");
 	}
 
-	return ret;
+	return width;
 }
 
 static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
@@ -302,10 +304,9 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
-					size_t size,
-					unsigned int width __maybe_unused)
+					size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-s", he->srcline);
+	return repsep_snprintf(bf, size, "%*.*-s", width, width, he->srcline);
 }
 
 struct sort_entry sort_srcline = {
@@ -332,7 +333,7 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*s", width,
+	return repsep_snprintf(bf, size, "%-*.*s", width, width,
 			      he->parent ? he->parent->name : "[other]");
 }
 
@@ -354,7 +355,7 @@ sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__cpu_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*d", width, he->cpu);
+	return repsep_snprintf(bf, size, "%*.*d", width, width, he->cpu);
 }
 
 struct sort_entry sort_cpu = {
@@ -484,7 +485,7 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *he, char *bf,
 	else if (he->branch_info->flags.mispred)
 		out = "Y";
 
-	return repsep_snprintf(bf, size, "%-*s", width, out);
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, out);
 }
 
 /* --sort daddr_sym */
@@ -1210,12 +1211,14 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 			      struct perf_evsel *evsel)
 {
 	struct hpp_sort_entry *hse;
-	size_t len;
+	size_t len = fmt->user_len;
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
-	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%-*s", len, hse->se->se_header);
+	if (!len)
+		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+
+	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, hse->se->se_header);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
@@ -1223,20 +1226,26 @@ static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
 			     struct perf_evsel *evsel)
 {
 	struct hpp_sort_entry *hse;
+	size_t len = fmt->user_len;
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
-	return hists__col_len(&evsel->hists, hse->se->se_width_idx);
+	if (!len)
+		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+
+	return len;
 }
 
 static int __sort__hpp_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 			     struct hist_entry *he)
 {
 	struct hpp_sort_entry *hse;
-	size_t len;
+	size_t len = fmt->user_len;
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
-	len = hists__col_len(he->hists, hse->se->se_width_idx);
+
+	if (!len)
+		len = hists__col_len(he->hists, hse->se->se_width_idx);
 
 	return hse->se->se_snprintf(he, hpp->buf, hpp->size, len);
 }
@@ -1266,6 +1275,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
 	hse->hpp.elide = false;
 	hse->hpp.len = 0;
+	hse->hpp.user_len = 0;
 
 	return hse;
 }
-- 
2.0.0

