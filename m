Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaCCBQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:16:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61734 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaCCBOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:14:22 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-bd-5313d769f740
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 05/13] perf tools: Pass evsel to hpp->header/width functions explicitly
Date: Mon,  3 Mar 2014 10:14:06 +0900
Message-Id: <1393809254-4480-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions need evsel to investigate event group and it's passed
via hpp->ptr.  However as it can be missed easily so it's better to
pass it via an argument IMHO.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c  |  7 ++++---
 tools/perf/ui/gtk/hists.c  |  3 +--
 tools/perf/ui/hist.c       | 37 ++++++++++++++++---------------------
 tools/perf/ui/stdio/hist.c |  5 ++---
 tools/perf/util/hist.h     |  6 ++++--
 5 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a77e31246c00..204fffe22532 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -952,8 +952,8 @@ static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
 				 dfmt->header_width, buf);
 }
 
-static int hpp__header(struct perf_hpp_fmt *fmt,
-		       struct perf_hpp *hpp)
+static int hpp__header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		       struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
@@ -963,7 +963,8 @@ static int hpp__header(struct perf_hpp_fmt *fmt,
 }
 
 static int hpp__width(struct perf_hpp_fmt *fmt,
-		      struct perf_hpp *hpp __maybe_unused)
+		      struct perf_hpp *hpp __maybe_unused,
+		      struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 7912dab6e5fb..e395ef9b0ae0 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -165,7 +165,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
-		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
@@ -192,7 +191,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
-		fmt->header(fmt, &hpp);
+		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
 							    -1, ltrim(s),
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index ac39313a3f0c..765e3918368f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -116,31 +116,28 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	return ret;
 }
 
-#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
-static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			       struct perf_hpp *hpp)			\
-{									\
-	int len = _min_width;						\
-									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
-		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
+#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 			\
+static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
+			       struct perf_hpp *hpp, struct perf_evsel *evsel)	\
+{										\
+	int len = _min_width;							\
+										\
+	if (symbol_conf.event_group)						\
+		len = max(len, evsel->nr_members * _unit_width);		\
+										\
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);		\
 }
 
 #define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
 static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			      struct perf_hpp *hpp __maybe_unused)	\
+			      struct perf_hpp *hpp __maybe_unused,	\
+			      struct perf_evsel *evsel)			\
 {									\
 	int len = _min_width;						\
 									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
+	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
+									\
 	return len;							\
 }
 
@@ -329,15 +326,13 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	int i = 0, ret = 0;
-	struct perf_hpp dummy_hpp = {
-		.ptr	= hists_to_evsel(hists),
-	};
+	struct perf_hpp dummy_hpp;
 
 	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(fmt, &dummy_hpp);
+		ret += fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 9bad89228472..d59893edf031 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -379,7 +379,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
-		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 	size_t linesz;
@@ -398,7 +397,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		fmt->header(fmt, &dummy_hpp);
+		fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		fprintf(fp, "%s", bf);
 	}
 
@@ -443,7 +442,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		width = fmt->width(fmt, &dummy_hpp);
+		width = fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9e1cada45bb8..0c76bf972736 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -132,8 +132,10 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
-	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		      struct perf_evsel *evsel);
+	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct perf_evsel *evsel);
 	int (*color)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
-- 
1.7.11.7

