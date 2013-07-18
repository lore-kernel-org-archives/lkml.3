Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193Ab3GRUB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:01:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab3GRTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/76] perf gtk/hists: Display callchain overhead also
Date: Thu, 18 Jul 2013 16:49:24 -0300
Message-Id: <1374177003-3706-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Display callchain percent value in the overhead column.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370337737-30812-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 226c7e1..fa9f8a0 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -134,7 +134,7 @@ static void callchain_list__sym_name(struct callchain_list *cl,
 }
 
 static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
-				    GtkTreeIter *parent, int col)
+				    GtkTreeIter *parent, int col, u64 total)
 {
 	struct rb_node *nd;
 	bool has_single_node = (rb_first(root) == rb_last(root));
@@ -144,9 +144,14 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 		struct callchain_list *chain;
 		GtkTreeIter iter, new_parent;
 		bool need_new_parent;
+		double percent;
+		u64 hits, child_total;
 
 		node = rb_entry(nd, struct callchain_node, rb_node);
 
+		hits = callchain_cumul_hits(node);
+		percent = 100.0 * hits / total;
+
 		new_parent = *parent;
 		need_new_parent = !has_single_node && (node->val_nr > 1);
 
@@ -155,6 +160,9 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 
 			gtk_tree_store_append(store, &iter, &new_parent);
 
+			scnprintf(buf, sizeof(buf), "%5.2f%%", percent);
+			gtk_tree_store_set(store, &iter, 0, buf, -1);
+
 			callchain_list__sym_name(chain, buf, sizeof(buf));
 			gtk_tree_store_set(store, &iter, col, buf, -1);
 
@@ -168,8 +176,14 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 			}
 		}
 
+		if (callchain_param.mode == CHAIN_GRAPH_REL)
+			child_total = node->children_hit;
+		else
+			child_total = total;
+
 		/* Now 'iter' contains info of the last callchain_list */
-		perf_gtk__add_callchain(&node->rb_root, store, &iter, col);
+		perf_gtk__add_callchain(&node->rb_root, store, &iter, col,
+					child_total);
 	}
 }
 
@@ -283,8 +297,15 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 
 		if (symbol_conf.use_callchain && sort__has_sym) {
+			u64 total;
+
+			if (callchain_param.mode == CHAIN_GRAPH_REL)
+				total = h->stat.period;
+			else
+				total = hists->stats.total_period;
+
 			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
-						sym_col);
+						sym_col, total);
 		}
 	}
 
-- 
1.8.1.4

