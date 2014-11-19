Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaKSQE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:51444 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaKSQEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:24 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf callchain: Use a common function to resolve symbol or name
Date: Wed, 19 Nov 2014 13:03:28 -0300
Message-Id: <1416413016-19110-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Refactor the duplicated code to resolve the symbol name or
the address of a symbol into a single function.

Used in next patch to add common functionality.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-6-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 17 -----------------
 tools/perf/ui/gtk/hists.c      | 11 +----------
 tools/perf/ui/stdio/hist.c     | 23 +++++++++--------------
 tools/perf/util/callchain.c    | 19 +++++++++++++++++++
 tools/perf/util/callchain.h    |  3 +++
 5 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cfb976b3de3a..12c17c5a3d68 100644
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
index fc654fb77ace..4b3585eed1e8 100644
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
index 15b451acbde6..dfcbc90146ef 100644
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
index 00229809a904..38da69c8c1ff 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -808,3 +808,22 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
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
index 3caccc2c173c..3e1ed15d11f1 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -193,4 +193,7 @@ static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 }
 #endif
 
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso);
+
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.9.3

