Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaEVMVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaEVMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:38 -0400
Date: Thu, 22 May 2014 05:21:26 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7g3h86woz2sckg3h1lj42ygj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Consolidate output field handling to hpp format routines
Git-Commit-ID: 26d8b338271a17a8a9b78000ebaec8b4645f5476
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26d8b338271a17a8a9b78000ebaec8b4645f5476
Gitweb:     http://git.kernel.org/tip/26d8b338271a17a8a9b78000ebaec8b4645f5476
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 16:16:20 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:34 +0200

perf tools: Consolidate output field handling to hpp format routines

Until now the hpp and sort functions do similar jobs different ways.
Since the sort functions converted/wrapped to hpp formats it can do
the job in a uniform way.

The perf_hpp__sort_list has a list of hpp formats to sort entries and
the perf_hpp__list has a list of hpp formats to print output result.

To have a backward compatibility, it automatically adds 'overhead'
field in front of sort list.  And then all of fields in sort list
added to the output list (if it's not already there).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-7g3h86woz2sckg3h1lj42ygj@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 31 ++++++++++++++----------
 tools/perf/ui/gtk/hists.c      | 31 ------------------------
 tools/perf/ui/hist.c           | 26 ++++++++++++++++++++
 tools/perf/ui/stdio/hist.c     | 55 +++++++++++++-----------------------------
 tools/perf/util/hist.c         |  2 +-
 tools/perf/util/hist.h         |  1 +
 6 files changed, 63 insertions(+), 83 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b0861e3..847de11 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -760,8 +760,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		slsmg_write_nstring(s, width);
+		slsmg_write_nstring("", width);
+
 		++row;
 		++printed;
 	} else
@@ -1104,27 +1104,32 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 				       struct hist_entry *he, FILE *fp)
 {
 	char s[8192];
-	double percent;
 	int printed = 0;
 	char folded_sign = ' ';
+	struct perf_hpp hpp = {
+		.buf = s,
+		.size = sizeof(s),
+	};
+	struct perf_hpp_fmt *fmt;
+	bool first = true;
+	int ret;
 
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
-	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
-
 	if (symbol_conf.use_callchain)
 		printed += fprintf(fp, "%c ", folded_sign);
 
-	printed += fprintf(fp, " %5.2f%%", percent);
-
-	if (symbol_conf.show_nr_samples)
-		printed += fprintf(fp, " %11u", he->stat.nr_events);
-
-	if (symbol_conf.show_total_period)
-		printed += fprintf(fp, " %12" PRIu64, he->stat.period);
+	perf_hpp__for_each_format(fmt) {
+		if (!first) {
+			ret = scnprintf(hpp.buf, hpp.size, "  ");
+			advance_hpp(&hpp, ret);
+		} else
+			first = false;
 
+		ret = fmt->entry(fmt, &hpp, he);
+		advance_hpp(&hpp, ret);
+	}
 	printed += fprintf(fp, "%s\n", rtrim(s));
 
 	if (folded_sign == '-')
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 91f10f3..d5c336e 100644
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
index 0299385..400437e 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -354,6 +354,14 @@ LIST_HEAD(perf_hpp__sort_list);
 
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
@@ -371,6 +379,13 @@ void perf_hpp__init(void)
 
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
@@ -389,6 +404,17 @@ void perf_hpp__column_enable(unsigned col)
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
index 9eccf7f..49e2e4a 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -306,8 +306,7 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
-static int hist_entry__period_snprintf(struct perf_hpp *hpp,
-				       struct hist_entry *he)
+static int hist_entry__snprintf(struct hist_entry *he, struct perf_hpp *hpp)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct perf_hpp_fmt *fmt;
@@ -353,8 +352,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he);
-	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	hist_entry__snprintf(he, &hpp);
 
 	ret = fprintf(fp, "%s\n", bf);
 
@@ -386,28 +384,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
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
@@ -420,7 +399,21 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
@@ -447,20 +440,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
index c99ae4d..ae13c2d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -569,7 +569,7 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	perf_hpp__for_each_format(fmt) {
+	perf_hpp__for_each_sort_list(fmt) {
 		cmp = fmt->sort(a, b);
 		if (cmp)
 			break;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index eee154a..e76d323 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -196,6 +196,7 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
+void perf_hpp__setup_output_field(void);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
