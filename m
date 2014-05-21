Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaEUNPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbaEUNNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:13 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 15/22] perf tools: Skip elided sort entries
Date: Wed, 21 May 2014 15:12:37 +0200
Message-Id: <1400677964-25160-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When it converted sort entries to hpp formats, it missed se->elide
handling, so add it for compatibility.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-16-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  6 ++++++
 tools/perf/ui/gtk/hists.c      |  6 ++++++
 tools/perf/ui/stdio/hist.c     |  9 +++++++++
 tools/perf/util/hist.c         |  9 +++++++++
 tools/perf/util/hist.h         |  1 +
 tools/perf/util/sort.c         | 11 +++++++++++
 6 files changed, 42 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 169224c..1c331b9 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -711,6 +711,9 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		ui_browser__gotorc(&browser->b, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
 			if (current_entry && browser->b.navkeypressed) {
 				ui_browser__set_color(&browser->b,
 						      HE_COLORSET_SELECTED);
@@ -1100,6 +1103,9 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 		printed += fprintf(fp, "%c ", folded_sign);
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first) {
 			ret = scnprintf(hpp.buf, hpp.size, "  ");
 			advance_hpp(&hpp, ret);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fd52669..9d90683 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -178,6 +178,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
@@ -222,6 +225,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		col_idx = 0;
 
 		perf_hpp__for_each_format(fmt) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
 			if (fmt->color)
 				fmt->color(fmt, &hpp, h);
 			else
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 49e2e4a..e3fdf4e 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -318,6 +318,9 @@ static int hist_entry__snprintf(struct hist_entry *he, struct perf_hpp *hpp)
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		/*
 		 * If there's no field_sep, we still need
 		 * to display initial '  '.
@@ -407,6 +410,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	fprintf(fp, "# ");
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
@@ -430,6 +436,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	perf_hpp__for_each_format(fmt) {
 		unsigned int i;
 
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ae13c2d..b262b44 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -436,6 +436,9 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->cmp(left, right);
 		if (cmp)
 			break;
@@ -451,6 +454,9 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->collapse(left, right);
 		if (cmp)
 			break;
@@ -570,6 +576,9 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->sort(a, b);
 		if (cmp)
 			break;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f3713b7..f67feb4 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -201,6 +201,7 @@ void perf_hpp__append_sort_keys(void);
 
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
 bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
+bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5414ba5..0fe7cbe 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1358,6 +1358,17 @@ static int __setup_sorting(void)
 	return ret;
 }
 
+bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
+{
+	if (perf_hpp__is_sort_entry(format)) {
+		struct hpp_sort_entry *hse;
+
+		hse = container_of(format, struct hpp_sort_entry, hpp);
+		return hse->se->elide;
+	}
+	return false;
+}
+
 static void sort_entry__setup_elide(struct sort_entry *se,
 				    struct strlist *list,
 				    const char *list_name, FILE *fp)
-- 
1.8.3.1

