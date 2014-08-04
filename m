Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaHDQVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:39699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHDQVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:21:32 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/33] perf tools: Add name field into perf_hpp_fmt
Date: Mon,  4 Aug 2014 13:17:41 -0300
Message-Id: <1407169064-25625-31-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It makes the code a bit simpler and easier to debug IMHO.

I guess it can also remove similar code in perf diff, but let's keep
it for a future work. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406785662-5534-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c |   4 +-
 tools/perf/ui/hist.c      | 136 +++++++++++++++++++++-------------------------
 tools/perf/util/hist.h    |   1 +
 tools/perf/util/sort.c    |   6 +-
 4 files changed, 66 insertions(+), 81 deletions(-)

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
index b2d60a95f01d..b5fa7019d2e2 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -209,29 +209,26 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 	return ret;
 }
 
-#define __HPP_WIDTH_FN(_type, _str)					\
-static int hpp__width_##_type(struct perf_hpp_fmt *fmt,			\
-			      struct perf_hpp *hpp __maybe_unused,	\
-			      struct perf_evsel *evsel)			\
-{									\
-	int len = fmt->user_len ?: fmt->len;				\
-									\
-	if (symbol_conf.event_group)					\
-		len = max(len, evsel->nr_members * fmt->len);		\
-									\
-	if (len < (int)strlen(_str))					\
-		len = strlen(_str);					\
-									\
-	return len;							\
-}
-
-#define __HPP_HEADER_FN(_type, _str) 					\
-static int hpp__header_##_type(struct perf_hpp_fmt *fmt,		\
-			       struct perf_hpp *hpp,			\
-			       struct perf_evsel *evsel)		\
-{									\
-	int len = hpp__width_##_type(fmt, hpp, evsel);			\
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
+static int hpp__width_fn(struct perf_hpp_fmt *fmt,
+			 struct perf_hpp *hpp __maybe_unused,
+			 struct perf_evsel *evsel)
+{
+	int len = fmt->user_len ?: fmt->len;
+
+	if (symbol_conf.event_group)
+		len = max(len, evsel->nr_members * fmt->len);
+
+	if (len < (int)strlen(fmt->name))
+		len = strlen(fmt->name);
+
+	return len;
+}
+
+static int hpp__header_fn(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+			  struct perf_evsel *evsel)
+{
+	int len = hpp__width_fn(fmt, hpp, evsel);
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, fmt->name);
 }
 
 static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
@@ -337,38 +334,29 @@ static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
 }
 
 
-#define HPP_PERCENT_FNS(_type, _str, _field)				\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_PERCENT_FNS(_type, _field)					\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
 __HPP_ENTRY_PERCENT_FN(_type, _field)					\
 __HPP_SORT_FN(_type, _field)
 
-#define HPP_PERCENT_ACC_FNS(_type, _str, _field)			\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_PERCENT_ACC_FNS(_type, _field)				\
 __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
 __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
 __HPP_SORT_ACC_FN(_type, _field)
 
-#define HPP_RAW_FNS(_type, _str, _field)				\
-__HPP_WIDTH_FN(_type, _str)						\
-__HPP_HEADER_FN(_type, _str)						\
+#define HPP_RAW_FNS(_type, _field)					\
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
@@ -376,47 +364,50 @@ static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
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
+		.header	= hpp__header_fn,		\
+		.width	= hpp__width_fn,		\
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
+		.header	= hpp__header_fn,		\
+		.width	= hpp__width_fn,		\
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
+		.header	= hpp__header_fn,		\
+		.width	= hpp__width_fn,		\
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
@@ -466,11 +457,7 @@ void perf_hpp__init(void)
 
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
@@ -536,8 +523,7 @@ void perf_hpp__cancel_cumulate(void)
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
index 153b3803f0b7..b4a805e5e440 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1206,8 +1206,7 @@ void perf_hpp__reset_sort_width(struct perf_hpp_fmt *fmt, struct hists *hists)
 		return;
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
-	hists__new_col_len(hists, hse->se->se_width_idx,
-			   strlen(hse->se->se_header));
+	hists__new_col_len(hists, hse->se->se_width_idx, strlen(fmt->name));
 }
 
 static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
@@ -1221,7 +1220,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	if (!len)
 		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, hse->se->se_header);
+	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, fmt->name);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
@@ -1265,6 +1264,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 	}
 
 	hse->se = sd->entry;
+	hse->hpp.name = sd->entry->se_header;
 	hse->hpp.header = __sort__hpp_header;
 	hse->hpp.width = __sort__hpp_width;
 	hse->hpp.entry = __sort__hpp_entry;
-- 
1.9.3

