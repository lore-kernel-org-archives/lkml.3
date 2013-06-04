Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3FDJWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:22:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59281 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3FDJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:22:21 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-e2-51adb1ca786a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/6] perf gtk/hists: Display callchain overhead also
Date: Tue,  4 Jun 2013 18:22:14 +0900
Message-Id: <1370337737-30812-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Display callchain percent value in the overhead column.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 226c7e10f3cc..fa9f8a09233e 100644
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
1.7.11.7

