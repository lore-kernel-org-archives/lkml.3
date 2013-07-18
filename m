Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab3GRWnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:43:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:58825 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933668Ab3GRWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="367589347"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        fweisbec@gmail.com
Subject: [PATCH] perf, tools: Support callchain sorting based on addresses
Date: Thu, 18 Jul 2013 15:42:50 -0700
Message-Id: <1374187370-14183-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With programs with very large functions it can be useful to distinguish
the callgraph nodes on more than just function names. So for example if
you have multiple calls to the same function, it ends up being
separate nodes in the chain.

This patch adds a new key field to the callgraph options, that
allows comparing nodes on functions (as today, default) and addresses.

Longer term it would be nice to also handle src lines, but that
would need more changes and address is a reasonable proxy for
it today.

I right now reference the global params, as there was no
simple way to register a params pointer.

Cc: fweisbec@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |  8 ++++++--
 tools/perf/builtin-report.c              | 19 +++++++++++++++----
 tools/perf/util/callchain.c              |  7 +++++--
 tools/perf/util/callchain.h              |  6 ++++++
 tools/perf/util/hist.c                   |  3 ++-
 5 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 66dab74..1def920 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -115,7 +115,7 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min[,limit],order]::
+-g [type,min[,limit],order[,key]]::
 --call-graph::
         Display call chains using type, min percent threshold, optional print
 	limit and order.
@@ -129,7 +129,11 @@ OPTIONS
 	- callee: callee based call graph.
 	- caller: inverted caller based call graph.
 
-	Default: fractal,0.5,callee.
+	key can be:
+	- function: compare on functions
+	- address: compare on individual code addresses
+
+	Default: fractal,0.5,callee,function.
 
 -G::
 --inverted::
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3662047..719216c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -680,12 +680,23 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	}
 
 	/* get the call chain order */
-	if (!strcmp(tok2, "caller"))
+	if (!strncmp(tok2, "caller", strlen("caller")))
 		callchain_param.order = ORDER_CALLER;
-	else if (!strcmp(tok2, "callee"))
+	else if (!strncmp(tok2, "callee", strlen("callee")))
 		callchain_param.order = ORDER_CALLEE;
 	else
 		return -1;
+
+	/* Get the sort key */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "function", strlen("function")))
+		callchain_param.key = CCKEY_FUNCTION;
+	else if (!strncmp(tok2, "address", strlen("address")))
+		callchain_param.key = CCKEY_ADDRESS;
+	else
+		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
@@ -780,8 +791,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit and callchain order. "
-		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 42b6a63..4fee33b 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
+#include "hist.h"
 #include "util.h"
 #include "callchain.h"
 
@@ -327,7 +328,8 @@ append_chain(struct callchain_node *root,
 	/*
 	 * Lookup in the current node
 	 * If we have a symbol, then compare the start to match
-	 * anywhere inside a function.
+	 * anywhere inside a function, unless function
+	 * mode is disabled.
 	 */
 	list_for_each_entry(cnode, &root->val, list) {
 		struct callchain_cursor_node *node;
@@ -339,7 +341,8 @@ append_chain(struct callchain_node *root,
 
 		sym = node->sym;
 
-		if (cnode->ms.sym && sym) {
+		if (cnode->ms.sym && sym &&
+		    callchain_param.key == CCKEY_FUNCTION) {
 			if (cnode->ms.sym->start != sym->start)
 				break;
 		} else if (cnode->ip != node->ip)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3ee9f67..812d5a0 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -41,12 +41,18 @@ struct callchain_param;
 typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_root *,
 				 u64, struct callchain_param *);
 
+enum chain_key {
+	CCKEY_FUNCTION,
+	CCKEY_ADDRESS
+};
+
 struct callchain_param {
 	enum chain_mode 	mode;
 	u32			print_limit;
 	double			min_percent;
 	sort_chain_func_t	sort;
 	enum chain_order	order;
+	enum chain_key		key;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b11a6cf..04f8313 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -24,7 +24,8 @@ enum hist_filter {
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5,
-	.order  = ORDER_CALLEE
+	.order  = ORDER_CALLEE,
+	.key	= CCKEY_FUNCTION
 };
 
 u16 hists__col_len(struct hists *hists, enum hist_column col)
-- 
1.8.1.4

