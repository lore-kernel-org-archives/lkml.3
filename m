Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaDPDK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:10:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59901 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDPDF4 (ORCPT
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
Subject: [PATCH 06/17] perf tools: Consolidate output field handling to hpp format routines
Date: Wed, 16 Apr 2014 12:05:43 +0900
Message-Id: <1397617554-26319-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the hpp and sort functions do similar jobs different ways.
Since the sort functions converted/wrapped to hpp formats it can do
the job in a uniform way.

The perf_hpp__sort_list has a list of hpp formats to sort entries and
the perf_hpp__list has a list of hpp formats to print output result.

To have a backward compatiblity, it automatically adds 'overhead'
field in front of sort list.  And then all of fields in sort list
added to the output list (if it's not already there).

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/ui/gtk/hists.c      | 31 -------------------------
 tools/perf/ui/hist.c           | 28 +++++++++++++++++++++++
 tools/perf/ui/stdio/hist.c     | 52 +++++++++++++-----------------------------
 tools/perf/util/hist.c         |  2 +-
 5 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4d416984c59d..c4616e9f309a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -731,8 +731,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		slsmg_write_nstring(s, width);
+		slsmg_write_nstring("", width);
+
 		++row;
 		++printed;
 	} else
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 91f10f3f6dd1..d5c336e1bb14 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -153,7 +153,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp_fmt *fmt;
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
-	struct sort_entry *se;
 	GtkTreeStore *store;
 	struct rb_node *nd;
 	GtkWidget *view;
@@ -172,16 +171,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	perf_hpp__for_each_format(fmt)
 		col_types[nr_cols++] = G_TYPE_STRING;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		if (se == &sort_sym)
-			sym_col = nr_cols;
-
-		col_types[nr_cols++] = G_TYPE_STRING;
-	}
-
 	store = gtk_tree_store_newv(nr_cols, col_types);
 
 	view = gtk_tree_view_new();
@@ -199,16 +188,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, se->se_header,
-							    renderer, "text",
-							    col_idx++, NULL);
-	}
-
 	for (col_idx = 0; col_idx < nr_cols; col_idx++) {
 		GtkTreeViewColumn *column;
 
@@ -253,16 +232,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
-			if (se->elide)
-				continue;
-
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
-					hists__col_len(hists, se->se_width_idx));
-
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
-
 		if (symbol_conf.use_callchain && sort__has_sym) {
 			if (callchain_param.mode == CHAIN_GRAPH_REL)
 				total = h->stat.period;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index c65a7fd744c6..32d2dfd794d9 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -352,8 +352,18 @@ LIST_HEAD(perf_hpp__sort_list);
 #undef __HPP_ENTRY_RAW_FN
 
 
+void perf_hpp__setup_output_field(void);
+
 void perf_hpp__init(void)
 {
+	struct list_head *list;
+	int i;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		INIT_LIST_HEAD(&perf_hpp__format[i].list);
+		INIT_LIST_HEAD(&perf_hpp__format[i].sort_list);
+	}
+
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 
 	if (symbol_conf.show_cpu_utilization) {
@@ -371,6 +381,13 @@ void perf_hpp__init(void)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__column_enable(PERF_HPP__PERIOD);
+
+	/* prepend overhead field for backward compatiblity.  */
+	list = &perf_hpp__format[PERF_HPP__OVERHEAD].sort_list;
+	if (list_empty(list))
+		list_add(list, &perf_hpp__sort_list);
+
+	perf_hpp__setup_output_field();
 }
 
 void perf_hpp__column_register(struct perf_hpp_fmt *format)
@@ -389,6 +406,17 @@ void perf_hpp__column_enable(unsigned col)
 	perf_hpp__column_register(&perf_hpp__format[col]);
 }
 
+void perf_hpp__setup_output_field(void)
+{
+	struct perf_hpp_fmt *fmt;
+
+	/* append sort keys to output field */
+	perf_hpp__for_each_sort_list(fmt) {
+		if (list_empty(&fmt->list))
+			perf_hpp__column_register(fmt);
+	}
+}
+
 int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			      struct hists *hists)
 {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d59893edf031..6c4ea9c89220 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -353,8 +353,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he);
-	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	hist_entry__period_snprintf(&hpp, he);
 
 	ret = fprintf(fp, "%s\n", bf);
 
@@ -386,28 +385,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 	init_rem_hits();
 
-	if (!show_header)
-		goto print_entries;
-
-	fprintf(fp, "# ");
-
-	perf_hpp__for_each_format(fmt) {
-		if (!first)
-			fprintf(fp, "%s", sep ?: "  ");
-		else
-			first = false;
-
-		fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
-		fprintf(fp, "%s", bf);
-	}
-
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
-		if (sep) {
-			fprintf(fp, "%c%s", *sep, se->se_header);
-			continue;
-		}
 		width = strlen(se->se_header);
 		if (symbol_conf.col_width_list_str) {
 			if (col_width) {
@@ -420,7 +400,21 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		}
 		if (!hists__new_col_len(hists, se->se_width_idx, width))
 			width = hists__col_len(hists, se->se_width_idx);
-		fprintf(fp, "  %*s", width, se->se_header);
+	}
+
+	if (!show_header)
+		goto print_entries;
+
+	fprintf(fp, "# ");
+
+	perf_hpp__for_each_format(fmt) {
+		if (!first)
+			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
+
+		fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
+		fprintf(fp, "%s", bf);
 	}
 
 	fprintf(fp, "\n");
@@ -447,20 +441,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 			fprintf(fp, ".");
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		unsigned int i;
-
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "  ");
-		width = hists__col_len(hists, se->se_width_idx);
-		if (width == 0)
-			width = strlen(se->se_header);
-		for (i = 0; i < width; i++)
-			fprintf(fp, ".");
-	}
-
 	fprintf(fp, "\n");
 	if (max_rows && ++nr_rows >= max_rows)
 		goto out;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a73aea306647..017b4896a9a0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -574,7 +574,7 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	perf_hpp__for_each_format(fmt) {
+	perf_hpp__for_each_sort_list(fmt) {
 		cmp = fmt->sort(a, b);
 		if (cmp)
 			break;
-- 
1.9.2

