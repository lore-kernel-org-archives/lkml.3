Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaKMCGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:06:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:43081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbaKMCGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:06:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,372,1413270000"; 
   d="scan'208";a="621556597"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/10] perf, tools: Use a common function to resolve symbol or name
Date: Wed, 12 Nov 2014 18:05:23 -0800
Message-Id: <1415844328-4884-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Refactor the duplicated code to resolve the symbol name or
the address of a symbol into a single function.

Used in next patch to add common functionality.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/ui/browsers/hists.c | 17 -----------------
 tools/perf/ui/gtk/hists.c      | 11 +----------
 tools/perf/ui/stdio/hist.c     | 23 +++++++++--------------
 tools/perf/util/callchain.c    | 19 +++++++++++++++++++
 tools/perf/util/callchain.h    |  3 +++
 5 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cfb976b..12c17c5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -463,23 +463,6 @@ out:
 	return key;
 }
 
-static char *callchain_list__sym_name(struct callchain_list *cl,
-				      char *bf, size_t bfsize, bool show_dso)
-{
-	int printed;
-
-	if (cl->ms.sym)
-		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
-		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
-
-	if (show_dso)
-		scnprintf(bf + printed, bfsize - printed, " %s",
-			  cl->ms.map ? cl->ms.map->dso->short_name : "unknown");
-
-	return bf;
-}
-
 struct callchain_print_arg {
 	/* for hists browser */
 	off_t	row_offset;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fc654fb..4b3585e 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -89,15 +89,6 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_acc;
 }
 
-static void callchain_list__sym_name(struct callchain_list *cl,
-				     char *bf, size_t bfsize)
-{
-	if (cl->ms.sym)
-		scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
-		scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
-}
-
 static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 				    GtkTreeIter *parent, int col, u64 total)
 {
@@ -128,7 +119,7 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 			scnprintf(buf, sizeof(buf), "%5.2f%%", percent);
 			gtk_tree_store_set(store, &iter, 0, buf, -1);
 
-			callchain_list__sym_name(chain, buf, sizeof(buf));
+			callchain_list__sym_name(chain, buf, sizeof(buf), false);
 			gtk_tree_store_set(store, &iter, col, buf, -1);
 
 			if (need_new_parent) {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 15b451a..dfcbc90 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -41,6 +41,7 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 {
 	int i;
 	size_t ret = 0;
+	char bf[1024];
 
 	ret += callchain__fprintf_left_margin(fp, left_margin);
 	for (i = 0; i < depth; i++) {
@@ -56,11 +57,8 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
-	if (chain->ms.sym)
-		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
-	else
-		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);
-
+	fputs(callchain_list__sym_name(chain, bf, sizeof(bf), false), fp);
+	fputc('\n', fp);
 	return ret;
 }
 
@@ -168,6 +166,7 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 	struct rb_node *node;
 	int i = 0;
 	int ret = 0;
+	char bf[1024];
 
 	/*
 	 * If have one single callchain root, don't bother printing
@@ -196,10 +195,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 			} else
 				ret += callchain__fprintf_left_margin(fp, left_margin);
 
-			if (chain->ms.sym)
-				ret += fprintf(fp, " %s\n", chain->ms.sym->name);
-			else
-				ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+			ret += fprintf(fp, "%s\n", callchain_list__sym_name(chain, bf, sizeof(bf),
+							false));
 
 			if (++entries_printed == callchain_param.print_limit)
 				break;
@@ -219,6 +216,7 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
+	char bf[1024];
 
 	if (!node)
 		return 0;
@@ -229,11 +227,8 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
 	list_for_each_entry(chain, &node->val, list) {
 		if (chain->ip >= PERF_CONTEXT_MAX)
 			continue;
-		if (chain->ms.sym)
-			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
+		ret += fprintf(fp, "                %s\n", callchain_list__sym_name(chain,
+					bf, sizeof(bf), false));
 	}
 
 	return ret;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 7131ee3..10870c9 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -812,3 +812,22 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 out:
 	return 1;
 }
+
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso)
+{
+	int printed;
+
+	if (cl->ms.sym) {
+		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+	} else
+		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+
+	if (show_dso)
+		scnprintf(bf + printed, bfsize - printed, " %s",
+			  cl->ms.map ?
+			  cl->ms.map->dso->short_name :
+			  "unknown");
+
+	return bf;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index f570b8e..5d5200c 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -194,4 +194,7 @@ static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 }
 #endif
 
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso);
+
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.9.3

