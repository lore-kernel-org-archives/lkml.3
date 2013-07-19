Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451Ab3GSHs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965367Ab3GSHsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:54 -0400
Date: Fri, 19 Jul 2013 00:48:37 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-cc60f24e225e50a0b57398f9ba105fd8ffcf4bb3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370337737-30812-4-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/hists: Display callchain overhead also
Git-Commit-ID: cc60f24e225e50a0b57398f9ba105fd8ffcf4bb3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc60f24e225e50a0b57398f9ba105fd8ffcf4bb3
Gitweb:     http://git.kernel.org/tip/cc60f24e225e50a0b57398f9ba105fd8ffcf4bb3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 18:22:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:40 -0300

perf gtk/hists: Display callchain overhead also

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
 
