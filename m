Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3EUGPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:15:54 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52766 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3EUGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:44 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-8a-519b10d19ca3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 4/7] perf gtk/hists: Add support for hierachical output
Date: Tue, 21 May 2013 15:14:35 +0900
Message-Id: <1369116878-12489-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When the symbol_conf.hierarchy is set, perf will collapse entries by a
first sort key, and then second key, and so on in a hierarchical
manner.  It'll be looked like a tree view so set the expander column
to a column that displays sort entries.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 109 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 103 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e1b8f702daf2..fb4b5ff00319 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -164,6 +164,62 @@ static void perf_gtk__add_entries(struct hists *hists, struct perf_hpp *hpp,
 	}
 }
 
+static void __perf_gtk__add_entries_hierarchy(struct hists *hists,
+					      struct rb_root *root,
+					      GtkTreeStore *store,
+					      GtkTreeIter *parent,
+					      struct perf_hpp *hpp,
+					      struct sort_entry *se)
+{
+	int col_idx;
+	struct rb_node *nd;
+	struct perf_hpp_fmt *fmt;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+		struct sort_entry *next_se;
+
+		if (h->filtered)
+			continue;
+
+		gtk_tree_store_append(store, &iter, parent);
+
+		col_idx = 0;
+
+		perf_hpp__for_each_format(fmt) {
+			if (fmt->color)
+				fmt->color(hpp, h);
+			else
+				fmt->entry(hpp, h);
+
+			gtk_tree_store_set(store, &iter, col_idx++, hpp->buf, -1);
+		}
+
+		se->se_snprintf(h, hpp->buf, hpp->size,
+				hists__col_len(hists, se->se_width_idx));
+
+		gtk_tree_store_set(store, &iter, col_idx++, ltrim(hpp->buf), -1);
+
+		next_se = list_entry(se->list.next, struct sort_entry, list);
+		__perf_gtk__add_entries_hierarchy(hists, &h->rb_hroot, store,
+						  &iter, hpp, next_se);
+	}
+}
+
+static void perf_gtk__add_entries_hierarchy(struct hists *hists,
+					    struct perf_hpp *hpp,
+					    GtkTreeStore *store)
+{
+	struct rb_root *root;
+	struct sort_entry *se;
+
+	root = &hists->entries;
+	se = list_first_entry(&hist_entry__sort_list, struct sort_entry, list);
+
+	__perf_gtk__add_entries_hierarchy(hists, root, store, NULL, hpp, se);
+}
+
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
 	struct perf_hpp_fmt *fmt;
@@ -173,6 +229,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	GtkTreeStore *store;
 	GtkWidget *view;
 	int col_idx;
+	int sort_col = 0;
 	int nr_cols;
 	char s[512];
 
@@ -187,11 +244,19 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	perf_hpp__for_each_format(fmt)
 		col_types[nr_cols++] = G_TYPE_STRING;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		col_types[nr_cols++] = G_TYPE_STRING;
+	if (symbol_conf.hierarchy) {
+		/*
+		 * In --hierarchy mode, all sort entries are displayed in a
+		 * single column.
+		 */
+		col_types[nr_cols] = G_TYPE_STRING;
+		sort_col = nr_cols++;
+	} else {
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (se->elide)
+				continue;
+			col_types[nr_cols++] = G_TYPE_STRING;
+		}
 	}
 
 	store = gtk_tree_store_newv(nr_cols, col_types);
@@ -211,6 +276,26 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 							    col_idx++, NULL);
 	}
 
+	if (symbol_conf.hierarchy) {
+		bool first = true;
+
+		s[0] = '\0';
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (!first)
+				strcat(s, " / ");
+
+			strcat(s, se->se_header);
+
+			first = false;
+		}
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, s,
+							    renderer, "text",
+							    col_idx++, NULL);
+		goto add;
+	}
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
@@ -221,11 +306,23 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 							    col_idx++, NULL);
 	}
 
+add:
 	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
 
 	g_object_unref(GTK_TREE_MODEL(store));
 
-	perf_gtk__add_entries(hists, &hpp, store);
+	if (!symbol_conf.hierarchy)
+		perf_gtk__add_entries(hists, &hpp, store);
+	else {
+		GtkTreeViewColumn *expander_col;
+
+		expander_col = gtk_tree_view_get_column(GTK_TREE_VIEW(view),
+							sort_col);
+		gtk_tree_view_set_expander_column(GTK_TREE_VIEW(view),
+						  expander_col);
+
+		perf_gtk__add_entries_hierarchy(hists, &hpp, store);
+	}
 
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
-- 
1.7.11.7

