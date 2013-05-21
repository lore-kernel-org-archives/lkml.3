Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3EUGQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:16:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46119 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3EUGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:44 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-89-519b10d1a1ac
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3/7] perf gtk/hists: Factor out perf_gtk__add_entries()
Date: Tue, 21 May 2013 15:14:34 +0900
Message-Id: <1369116878-12489-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This is a preparation for supporting hierarchical output in the hist
browser.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 72 +++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index ba59d5d63d74..e1b8f702daf2 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -124,6 +124,46 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_us;
 }
 
+static void perf_gtk__add_entries(struct hists *hists, struct perf_hpp *hpp,
+				  GtkTreeStore *store)
+{
+	int col_idx;
+	struct rb_node *nd;
+	struct perf_hpp_fmt *fmt;
+	struct sort_entry *se;
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+
+		if (h->filtered)
+			continue;
+
+		gtk_tree_store_append(store, &iter, NULL);
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
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (se->elide)
+				continue;
+
+			se->se_snprintf(h, hpp->buf, hpp->size,
+					hists__col_len(hists, se->se_width_idx));
+
+			gtk_tree_store_set(store, &iter, col_idx++, hpp->buf, -1);
+		}
+	}
+}
+
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
 	struct perf_hpp_fmt *fmt;
@@ -131,7 +171,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	GtkCellRenderer *renderer;
 	struct sort_entry *se;
 	GtkTreeStore *store;
-	struct rb_node *nd;
 	GtkWidget *view;
 	int col_idx;
 	int nr_cols;
@@ -186,36 +225,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 	g_object_unref(GTK_TREE_MODEL(store));
 
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		GtkTreeIter iter;
-
-		if (h->filtered)
-			continue;
-
-		gtk_tree_store_append(store, &iter, NULL);
-
-		col_idx = 0;
-
-		perf_hpp__for_each_format(fmt) {
-			if (fmt->color)
-				fmt->color(&hpp, h);
-			else
-				fmt->entry(&hpp, h);
-
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
-
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
-			if (se->elide)
-				continue;
-
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
-					hists__col_len(hists, se->se_width_idx));
-
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
-	}
+	perf_gtk__add_entries(hists, &hpp, store);
 
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
-- 
1.7.11.7

