Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaDPDKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:10:54 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59934 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaDPDF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 07/17] perf ui: Get rid of callback from __hpp__fmt()
Date: Wed, 16 Apr 2014 12:05:44 +0900
Message-Id: <1397617554-26319-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callback was used by TUI for determining color of folded sign
using percent of first field/column.  But it cannot be used anymore
since it now support dynamic reording of output field.

So move the logic to the hist_browser__show_entry().

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 62 ++++++++++++++++--------------------------
 tools/perf/ui/gtk/hists.c      |  2 +-
 tools/perf/ui/hist.c           | 28 ++++++-------------
 tools/perf/util/hist.h         |  4 +--
 4 files changed, 34 insertions(+), 62 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c4616e9f309a..415bdeefd532 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -587,35 +587,6 @@ struct hpp_arg {
 	bool current_entry;
 };
 
-static int __hpp__overhead_callback(struct perf_hpp *hpp, bool front)
-{
-	struct hpp_arg *arg = hpp->ptr;
-
-	if (arg->current_entry && arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_SELECTED);
-	else
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
-
-	if (front) {
-		if (!symbol_conf.use_callchain)
-			return 0;
-
-		slsmg_printf("%c ", arg->folded_sign);
-		return 2;
-	}
-
-	return 0;
-}
-
-static int __hpp__color_callback(struct perf_hpp *hpp, bool front __maybe_unused)
-{
-	struct hpp_arg *arg = hpp->ptr;
-
-	if (!arg->current_entry || !arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
-	return 0;
-}
-
 static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	struct hpp_arg *arg = hpp->ptr;
@@ -636,7 +607,7 @@ static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 	return ret;
 }
 
-#define __HPP_COLOR_PERCENT_FN(_type, _field, _cb)			\
+#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
 static u64 __hpp_get_##_field(struct hist_entry *he)			\
 {									\
 	return he->stat._field;						\
@@ -647,15 +618,15 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__fmt(hpp, he, __hpp_get_##_field, _cb, " %6.2f%%",	\
+	return __hpp__fmt(hpp, he, __hpp_get_##_field, " %6.2f%%",	\
 			  __hpp__slsmg_color_printf, true);		\
 }
 
-__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__overhead_callback)
-__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_us, period_us, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead, period)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 #undef __HPP_COLOR_PERCENT_FN
 
@@ -700,7 +671,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 	if (row_offset == 0) {
 		struct hpp_arg arg = {
-			.b 		= &browser->b,
+			.b		= &browser->b,
 			.folded_sign	= folded_sign,
 			.current_entry	= current_entry,
 		};
@@ -713,11 +684,24 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		ui_browser__gotorc(&browser->b, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
-			if (!first) {
+			if (current_entry && browser->b.navkeypressed) {
+				ui_browser__set_color(&browser->b,
+						      HE_COLORSET_SELECTED);
+			} else {
+				ui_browser__set_color(&browser->b,
+						      HE_COLORSET_NORMAL);
+			}
+
+			if (first) {
+				if (symbol_conf.use_callchain) {
+					slsmg_printf("%c ", folded_sign);
+					width -= 2;
+				}
+				first = false;
+			} else {
 				slsmg_printf("  ");
 				width -= 2;
 			}
-			first = false;
 
 			if (fmt->color) {
 				width -= fmt->color(fmt, &hpp, entry);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index d5c336e1bb14..2237245bfac0 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -43,7 +43,7 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  __percent_color_snprintf, true);			\
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 32d2dfd794d9..400dad8c41e4 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,20 +16,15 @@
 })
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, hpp_callback_fn callback,
-	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
+	       hpp_field_fn get_field, const char *fmt,
+	       hpp_snprint_fn print_fn, bool fmt_percent)
 {
-	int ret = 0;
+	int ret;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
 	char *buf = hpp->buf;
 	size_t size = hpp->size;
 
-	if (callback) {
-		ret = callback(hpp, true);
-		advance_hpp(hpp, ret);
-	}
-
 	if (fmt_percent) {
 		double percent = 0.0;
 		u64 total = hists__total_period(hists);
@@ -37,9 +32,9 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		if (total)
 			percent = 100.0 * get_field(he) / total;
 
-		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
-		ret += hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -99,13 +94,6 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		}
 	}
 
-	if (callback) {
-		int __ret = callback(hpp, false);
-
-		advance_hpp(hpp, __ret);
-		ret += __ret;
-	}
-
 	/*
 	 * Restore original buf and size as it's where caller expects
 	 * the result will be saved.
@@ -235,7 +223,7 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  hpp_color_scnprintf, true);				\
 }
 
@@ -244,7 +232,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, fmt,			\
+	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
 			  hpp_entry_scnprintf, true);				\
 }
 
@@ -264,7 +252,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, NULL, fmt,		\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt,			\
 			  hpp_entry_scnprintf, false);				\
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0f8d46803c92..4f70fb490a63 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -195,8 +195,8 @@ typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, hpp_callback_fn callback,
-	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+	       hpp_field_fn get_field, const char *fmt,
+	       hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 {
-- 
1.9.2

