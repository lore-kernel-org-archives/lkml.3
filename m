Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FDJXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:23:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44362 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3FDJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:20 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-df-51adb1cade00
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/6] perf gtk/hists: Add support for callchains
Date: Tue,  4 Jun 2013 18:22:13 +0900
Message-Id: <1370337737-30812-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Display callchain information in the symbol column.  It's only enabled
when recorded with -g and has symbol sort key.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index cb6a9b45f789..226c7e10f3cc 100644
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
1.7.11.7

