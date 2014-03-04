Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaCDCoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:44:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56444 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaCDCmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:20 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 06/10] perf tools: Consolidate output field handling to hpp format routines
Date: Tue,  4 Mar 2014 11:42:12 +0900
Message-Id: <1393900936-22977-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/ui/gtk/hists.c      | 31 -------------------------
 tools/perf/ui/hist.c           | 28 +++++++++++++++++++++++
 tools/perf/ui/stdio/hist.c     | 52 +++++++++++++-----------------------------
 tools/perf/util/hist.c         |  2 +-
 5 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 756621b52493..e7980d0db7ec 100644
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
index b5fbf3e3d636..2d49fae6129d 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -351,8 +351,18 @@ LIST_HEAD(perf_hpp__sort_list);
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
@@ -370,6 +380,13 @@ void perf_hpp__init(void)
 
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
@@ -388,6 +405,17 @@ void perf_hpp__column_enable(unsigned col)
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
index 0a351f37223f..2d4be4195907 100644
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
1.7.11.7

