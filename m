Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3EVI3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:29:00 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48267 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3EVI1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:27:42 -0400
X-AuditID: 9c93017e-b7c8fae000000f00-15-519c817c9983
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/5] perf gtk/hists: Add support for callchains
Date: Wed, 22 May 2013 17:27:35 +0900
Message-Id: <1369211258-3163-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add a new column to display callchain information.  It's only enabled
when recorded with -g and has symbol sort key.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index cb6a9b45f789..14d0b26c7c8a 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -124,6 +124,41 @@ void perf_gtk__init_hpp(void)
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
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		struct callchain_node *node;
+		struct callchain_list *chain;
+		GtkTreeIter iter;
+
+		node = rb_entry(nd, struct callchain_node, rb_node);
+
+		list_for_each_entry(chain, &node->val, list) {
+			char buf[128];
+
+			gtk_tree_store_append(store, &iter, parent);
+
+			callchain_list__sym_name(chain, buf, sizeof(buf));
+			gtk_tree_store_set(store, &iter, col, buf, -1);
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
@@ -156,6 +191,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		col_types[nr_cols++] = G_TYPE_STRING;
 	}
 
+	if (symbol_conf.use_callchain && sort__has_sym)
+		col_types[nr_cols++] = G_TYPE_STRING;
+
 	store = gtk_tree_store_newv(nr_cols, col_types);
 
 	view = gtk_tree_view_new();
@@ -183,6 +221,23 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
+	if (symbol_conf.use_callchain && sort__has_sym) {
+		GtkTreeViewColumn *chain_column;
+
+		chain_column = gtk_tree_view_column_new();
+
+		gtk_tree_view_column_set_title(chain_column, "Callchains");
+		gtk_tree_view_column_pack_start(chain_column, renderer, TRUE);
+		gtk_tree_view_column_add_attribute(chain_column, renderer,
+						   "text", col_idx++);
+
+		gtk_tree_view_insert_column(GTK_TREE_VIEW(view),
+					    chain_column, -1);
+
+		gtk_tree_view_set_expander_column(GTK_TREE_VIEW(view),
+						  chain_column);
+	}
+
 	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
 
 	g_object_unref(GTK_TREE_MODEL(store));
@@ -221,6 +276,11 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
+
+		if (symbol_conf.use_callchain && sort__has_sym) {
+			gtk_tree_store_set(store, &iter, col_idx, "callchain", -1);
+			perf_gtk__add_callchain(&h->sorted_chain, store, &iter, col_idx);
+		}
 	}
 
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.7.11.7

