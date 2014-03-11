Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaCKBIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:08:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:10684 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbaCKBFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,627,1389772800"; 
   d="scan'208";a="469893774"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/8] perf, tools: Enable printing the srcline in the history v3
Date: Mon, 10 Mar 2014 18:05:16 -0700
Message-Id: <1394499921-27668-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394499921-27668-1-git-send-email-andi@firstfloor.org>
References: <1394499921-27668-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For lbr-as-callgraph we need to see the line number in the history,
because many LBR entries can be in a single function, and just
showing the same function name many times is not useful.

When the history code is configured to sort by address, also try to
resolve the address to a file:srcline and display this in the browser.
If that doesn't work still display the address.

This can be also useful without LBRs for understanding which call in a large
function (or in which inlined function) called something else.

Contains fixes from Namhyung Kim

v2: Refactor code into common function
v3: Fix GTK build
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/ui/browsers/hists.c | 17 -----------------
 tools/perf/ui/gtk/hists.c      | 11 +----------
 tools/perf/ui/stdio/hist.c     | 23 +++++++++--------------
 tools/perf/util/callchain.c    | 29 +++++++++++++++++++++++++++++
 tools/perf/util/callchain.h    |  5 +++++
 tools/perf/util/machine.c      |  2 +-
 tools/perf/util/srcline.c      |  6 ++++--
 7 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b720b92..ec69142 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -394,23 +394,6 @@ out:
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
 #define LEVEL_OFFSET_STEP 3
 
 static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browser,
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44..cafe105 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -123,15 +123,6 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_us;
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
@@ -162,7 +153,7 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 			scnprintf(buf, sizeof(buf), "%5.2f%%", percent);
 			gtk_tree_store_set(store, &iter, 0, buf, -1);
 
-			callchain_list__sym_name(chain, buf, sizeof(buf));
+			callchain_list__sym_name(chain, buf, sizeof(buf), false);
 			gtk_tree_store_set(store, &iter, col, buf, -1);
 
 			if (need_new_parent) {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb7..3ac9ace 100644
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
@@ -195,10 +194,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
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
@@ -218,6 +215,7 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
+	char bf[1024];
 
 	if (!node)
 		return 0;
@@ -228,11 +226,8 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
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
index 8d9db45..56ab517 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -551,3 +551,32 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
+
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso)
+{
+	int printed;
+
+	if (cl->ms.sym) {
+		if (callchain_param.key == CCKEY_ADDRESS &&
+		    cl->ms.map && !cl->srcline)
+			cl->srcline = get_srcline(cl->ms.map->dso,
+						  map__rip_2objdump(cl->ms.map,
+								    cl->ip));
+		if (cl->srcline)
+			printed = scnprintf(bf, bfsize, "%s %s",
+					cl->ms.sym->name, cl->srcline);
+		else
+			printed = scnprintf(bf, bfsize, "%s",
+					    cl->ms.sym->name);
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
index be29bb8..39322ef 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -59,6 +59,7 @@ struct callchain_param {
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char		       *srcline;
 	struct list_head	list;
 };
 
@@ -158,4 +159,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
 
 extern const char record_callchain_help[];
+
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso);
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b7337d2..0e6d8d4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1310,7 +1310,7 @@ static int add_callchain_ip(struct machine *machine,
 			return -EINVAL;
 	}
 
-	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
 }
 
 #define CHASHSZ 127
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index f3e4bc5..c6a7cdc 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -258,7 +258,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	const char *dso_name;
 
 	if (!dso->has_srcline)
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	if (dso->symsrc_filename)
 		dso_name = dso->symsrc_filename;
@@ -289,7 +289,9 @@ out:
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
-	return SRCLINE_UNKNOWN;
+	if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+		return SRCLINE_UNKNOWN;
+	return srcline;
 }
 
 void free_srcline(char *srcline)
-- 
1.8.5.3

