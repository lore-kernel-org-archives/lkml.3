Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaDPDGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:17 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60148 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 16/17] perf tools: Skip elided sort entries
Date: Wed, 16 Apr 2014 12:05:53 +0900
Message-Id: <1397617554-26319-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it converted sort entries to hpp formats, it missed se->elide
handling, so add it for compatibility.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  3 +++
 tools/perf/ui/gtk/hists.c      |  6 ++++++
 tools/perf/ui/stdio/hist.c     |  9 +++++++++
 tools/perf/util/hist.c         |  9 +++++++++
 tools/perf/util/hist.h         |  1 +
 tools/perf/util/sort.c         | 11 +++++++++++
 6 files changed, 39 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2771b7aa84dd..8895b4717015 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -682,6 +682,9 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		ui_browser__gotorc(&browser->b, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
 			if (current_entry && browser->b.navkeypressed) {
 				ui_browser__set_color(&browser->b,
 						      HE_COLORSET_SELECTED);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fd52669018ee..9d90683914d4 100644
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
index 6c4ea9c89220..5ecd433bee26 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -319,6 +319,9 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		/*
 		 * If there's no field_sep, we still need
 		 * to display initial '  '.
@@ -408,6 +411,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	fprintf(fp, "# ");
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
@@ -431,6 +437,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	perf_hpp__for_each_format(fmt) {
 		unsigned int i;
 
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 017b4896a9a0..7f47ba4d3f77 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -441,6 +441,9 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->cmp(left, right);
 		if (cmp)
 			break;
@@ -456,6 +459,9 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->collapse(left, right);
 		if (cmp)
 			break;
@@ -575,6 +581,9 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 	int64_t cmp = 0;
 
 	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		cmp = fmt->sort(a, b);
 		if (cmp)
 			break;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 4c5c2837a27d..826ad4b354a4 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -194,6 +194,7 @@ void perf_hpp__append_sort_keys(void);
 
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
 bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
+bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1e7b80e517d5..9dc33df4f9a6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1355,6 +1355,17 @@ int setup_sorting(void)
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
1.9.2

