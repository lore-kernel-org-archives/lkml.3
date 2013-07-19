Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab3GSHss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935322Ab3GSHsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:45 -0400
Date: Fri, 19 Jul 2013 00:48:28 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2bbc5874251830fee170a0fc97fa5788717d2fd9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370337737-30812-3-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/hists: Add support for callchains
Git-Commit-ID: 2bbc5874251830fee170a0fc97fa5788717d2fd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:48:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bbc5874251830fee170a0fc97fa5788717d2fd9
Gitweb:     http://git.kernel.org/tip/2bbc5874251830fee170a0fc97fa5788717d2fd9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 18:22:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:38 -0300

perf gtk/hists: Add support for callchains

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
