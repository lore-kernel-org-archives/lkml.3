Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab3GRUGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:06:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41535 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3GRTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/76] perf gtk/hists: Add support for callchains
Date: Thu, 18 Jul 2013 16:49:23 -0300
Message-Id: <1374177003-3706-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Display callchain information in the symbol column.  It's only enabled
when recorded with -g and has symbol sort key.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370337737-30812-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index cb6a9b4..226c7e1 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -124,6 +124,55 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_us;
 }
 
+static void callchain_list__sym_name(struct callchain_list *cl,
+				     char *bf, size_t bfsize)
+{
+	if (cl->ms.sym)
+		scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+	else
+		scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+}
+
+static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
+				    GtkTreeIter *parent, int col)
+{
+	struct rb_node *nd;
+	bool has_single_node = (rb_first(root) == rb_last(root));
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		struct callchain_node *node;
+		struct callchain_list *chain;
+		GtkTreeIter iter, new_parent;
+		bool need_new_parent;
+
+		node = rb_entry(nd, struct callchain_node, rb_node);
+
+		new_parent = *parent;
+		need_new_parent = !has_single_node && (node->val_nr > 1);
+
+		list_for_each_entry(chain, &node->val, list) {
+			char buf[128];
+
+			gtk_tree_store_append(store, &iter, &new_parent);
+
+			callchain_list__sym_name(chain, buf, sizeof(buf));
+			gtk_tree_store_set(store, &iter, col, buf, -1);
+
+			if (need_new_parent) {
+				/*
+				 * Only show the top-most symbol in a callchain
+				 * if it's not the only callchain.
+				 */
+				new_parent = iter;
+				need_new_parent = false;
+			}
+		}
+
+		/* Now 'iter' contains info of the last callchain_list */
+		perf_gtk__add_callchain(&node->rb_root, store, &iter, col);
+	}
+}
+
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 				 float min_pcnt)
 {
@@ -135,6 +184,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct rb_node *nd;
 	GtkWidget *view;
 	int col_idx;
+	int sym_col = -1;
 	int nr_cols;
 	char s[512];
 
@@ -153,6 +203,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		if (se->elide)
 			continue;
 
+		if (se == &sort_sym)
+			sym_col = nr_cols;
+
 		col_types[nr_cols++] = G_TYPE_STRING;
 	}
 
@@ -183,6 +236,13 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
+	if (symbol_conf.use_callchain && sort__has_sym) {
+		GtkTreeViewColumn *column;
+
+		column = gtk_tree_view_get_column(GTK_TREE_VIEW(view), sym_col);
+		gtk_tree_view_set_expander_column(GTK_TREE_VIEW(view), column);
+	}
+
 	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
 
 	g_object_unref(GTK_TREE_MODEL(store));
@@ -221,6 +281,11 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
+
+		if (symbol_conf.use_callchain && sort__has_sym) {
+			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
+						sym_col);
+		}
 	}
 
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.8.1.4

