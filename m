Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbaGYBTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46367 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbaGYBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:16 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/7] perf tools: Make __hpp__fmt() receive an additional len argument
Date: Fri, 25 Jul 2014 10:18:53 +0900
Message-Id: <1406251138-6574-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can properly handle alignment requirements later.  To do
that, add percent_color_len_snprintf() fucntion to help coloring of
overhead columns.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 14 ++++++++------
 tools/perf/ui/gtk/hists.c      |  8 +++++---
 tools/perf/ui/hist.c           | 43 +++++++++++++++++++++---------------------
 tools/perf/util/color.c        | 16 ++++++++++++++++
 tools/perf/util/color.h        |  1 +
 tools/perf/util/hist.h         |  4 ++--
 6 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a94b11fc5e00..02507ba944e3 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -653,17 +653,18 @@ struct hpp_arg {
 static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	struct hpp_arg *arg = hpp->ptr;
-	int ret;
+	int ret, len;
 	va_list args;
 	double percent;
 
 	va_start(args, fmt);
+	len = va_arg(args, int);
 	percent = va_arg(args, double);
 	va_end(args);
 
 	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
 
-	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
+	ret = scnprintf(hpp->buf, hpp->size, fmt, len, percent);
 	slsmg_printf("%s", hpp->buf);
 
 	advance_hpp(hpp, ret);
@@ -681,7 +682,7 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__fmt(hpp, he, __hpp_get_##_field, " %6.2f%%",	\
+	return __hpp__fmt(hpp, he, __hpp_get_##_field, " %*.2f%%", 6,	\
 			  __hpp__slsmg_color_printf, true);		\
 }
 
@@ -697,13 +698,14 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct hist_entry *he)			\
 {									\
 	if (!symbol_conf.cumulate_callchain) {				\
-		int ret = scnprintf(hpp->buf, hpp->size, "%8s", "N/A");	\
+		int ret = scnprintf(hpp->buf, hpp->size,		\
+				    "%*s", 8, "N/A");			\
 		slsmg_printf("%s", hpp->buf);				\
 									\
 		return ret;						\
 	}								\
-	return __hpp__fmt(hpp, he, __hpp_get_acc_##_field, " %6.2f%%",	\
-			  __hpp__slsmg_color_printf, true);		\
+	return __hpp__fmt(hpp, he, __hpp_get_acc_##_field, " %*.2f%%",	\
+			  6, __hpp__slsmg_color_printf, true);	\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 6ca60e482cdc..91f6cd7d2312 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -11,6 +11,7 @@
 static int __percent_color_snprintf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	int ret = 0;
+	int len;
 	va_list args;
 	double percent;
 	const char *markup;
@@ -18,6 +19,7 @@ static int __percent_color_snprintf(struct perf_hpp *hpp, const char *fmt, ...)
 	size_t size = hpp->size;
 
 	va_start(args, fmt);
+	len = va_arg(args, int);
 	percent = va_arg(args, double);
 	va_end(args);
 
@@ -25,7 +27,7 @@ static int __percent_color_snprintf(struct perf_hpp *hpp, const char *fmt, ...)
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, fmt, percent);
+	ret += scnprintf(buf + ret, size - ret, fmt, len, percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -43,7 +45,7 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%", 6,		\
 			  __percent_color_snprintf, true);			\
 }
 
@@ -57,7 +59,7 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%", 6, 	\
 			      __percent_color_snprintf, true);			\
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 498adb23c02e..c6cffbd0b0e1 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,7 +16,7 @@
 })
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, const char *fmt,
+	       hpp_field_fn get_field, const char *fmt, int len,
 	       hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	int ret;
@@ -32,9 +32,9 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		if (total)
 			percent = 100.0 * get_field(he) / total;
 
-		ret = hpp__call_print_fn(hpp, print_fn, fmt, percent);
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, len, percent);
 	} else
-		ret = hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, len, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -60,19 +60,19 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 */
 				if (fmt_percent) {
 					ret += hpp__call_print_fn(hpp, print_fn,
-								  fmt, 0.0);
+								  fmt, len, 0.0);
 				} else {
 					ret += hpp__call_print_fn(hpp, print_fn,
-								  fmt, 0ULL);
+								  fmt, len, 0ULL);
 				}
 			}
 
 			if (fmt_percent) {
-				ret += hpp__call_print_fn(hpp, print_fn, fmt,
+				ret += hpp__call_print_fn(hpp, print_fn, fmt, len,
 							  100.0 * period / total);
 			} else {
 				ret += hpp__call_print_fn(hpp, print_fn, fmt,
-							  period);
+							  len, period);
 			}
 
 			prev_idx = perf_evsel__group_idx(evsel);
@@ -86,10 +86,10 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			 */
 			if (fmt_percent) {
 				ret += hpp__call_print_fn(hpp, print_fn,
-							  fmt, 0.0);
+							  fmt, len, 0.0);
 			} else {
 				ret += hpp__call_print_fn(hpp, print_fn,
-							  fmt, 0ULL);
+							  fmt, len, 0ULL);
 			}
 		}
 	}
@@ -105,7 +105,7 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 }
 
 int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
-		   hpp_field_fn get_field, const char *fmt,
+		   hpp_field_fn get_field, const char *fmt, int len,
 		   hpp_snprint_fn print_fn, bool fmt_percent)
 {
 	if (!symbol_conf.cumulate_callchain) {
@@ -113,7 +113,7 @@ int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
 				fmt_percent ? 8 : 12, "N/A");
 	}
 
-	return __hpp__fmt(hpp, he, get_field, fmt, print_fn, fmt_percent);
+	return __hpp__fmt(hpp, he, get_field, fmt, len, print_fn, fmt_percent);
 }
 
 static int field_cmp(u64 field_a, u64 field_b)
@@ -221,11 +221,12 @@ static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
 	va_list args;
 	ssize_t ssize = hpp->size;
 	double percent;
-	int ret;
+	int ret, len;
 
 	va_start(args, fmt);
+	len = va_arg(args, int);
 	percent = va_arg(args, double);
-	ret = value_color_snprintf(hpp->buf, hpp->size, fmt, percent);
+	ret = percent_color_len_snprintf(hpp->buf, hpp->size, fmt, len, percent);
 	va_end(args);
 
 	return (ret >= ssize) ? (ssize - 1) : ret;
@@ -253,7 +254,7 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	6,		\
 			  hpp_color_scnprintf, true);				\
 }
 
@@ -261,8 +262,8 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
+	int len = symbol_conf.field_sep ? 1 : 6;				\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %*.2f%%",	len,		\
 			  hpp_entry_scnprintf, true);				\
 }
 
@@ -281,7 +282,7 @@ static u64 he_get_acc_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %*.2f%%",	6, 	\
 			      hpp_color_scnprintf, true);			\
 }
 
@@ -289,8 +290,8 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, fmt,		\
+	int len = symbol_conf.field_sep ? 1 : 6;				\
+	return __hpp__fmt_acc(hpp, he, he_get_##_field, " %*.2f%%", len,	\
 			      hpp_entry_scnprintf, true);			\
 }
 
@@ -309,8 +310,8 @@ static u64 he_get_raw_##_field(struct hist_entry *he)				\
 static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt,			\
+	int len = symbol_conf.field_sep ? 1 : 11;				\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, " %*"PRIu64, len, 	\
 			  hpp_entry_scnprintf, false);				\
 }
 
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 87b8672eb413..f4654183d391 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -335,3 +335,19 @@ int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
 	va_end(args);
 	return value_color_snprintf(bf, size, fmt, percent);
 }
+
+int percent_color_len_snprintf(char *bf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+	double percent;
+	const char *color;
+
+	va_start(args, fmt);
+	len = va_arg(args, int);
+	percent = va_arg(args, double);
+	va_end(args);
+
+	color = get_percent_color(percent);
+	return color_snprintf(bf, size, color, fmt, len, percent);
+}
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 7ff30a62a132..0a594b8a0c26 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -41,6 +41,7 @@ int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
 int value_color_snprintf(char *bf, size_t size, const char *fmt, double value);
 int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...);
+int percent_color_len_snprintf(char *bf, size_t size, const char *fmt, ...);
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
 const char *get_percent_color(double percent);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 742f49a85725..13d074db9ef1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -267,10 +267,10 @@ typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, const char *fmt,
+	       hpp_field_fn get_field, const char *fmt, int len,
 	       hpp_snprint_fn print_fn, bool fmt_percent);
 int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
-		   hpp_field_fn get_field, const char *fmt,
+		   hpp_field_fn get_field, const char *fmt, int len,
 		   hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
-- 
2.0.0

