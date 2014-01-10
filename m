Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaAJMcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:32:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:34258 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbaAJMci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:32:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="456668301"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        jolsa@redhat.com, fweisbec@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] perf, tools: Add support for prepending LBRs to the callstack
Date: Fri, 10 Jan 2014 04:32:03 -0800
Message-Id: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I never found the default LBR display mode which generates histograms
of individual branches particularly useful.

This implements an alternative mode that creates histograms over complete
branch traces, instead of individual branches, similar to how normal
callgraphs are handled. This is done by putting it in
front of the normal callgraph and then using the normal callgraph
histogram infrastructure to unify them.

This way in complex functions we can understand the control flow
that lead to a particular sample.

The default output is unchanged.

This is only implemented in perf report, no change to record
or anywhere else.

This adds the basic code to report:
- add a new "branch" option to the -g option parser to enable this mode
- when the flag is set include the LBR into the callstack in machine.c.
The rest of the history code is unchanged and doesn't know the difference
between LBR entry and normal call entry.

Current limitations:
- There is no attempt to cut off the LBR at the beginning of the function,
so there may be small overlaps between the callstack and the LBR.
- The LBR flags (mispredict etc.) are not shown in the history

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-report.c |  15 ++++--
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/machine.c   | 113 ++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h    |   3 +-
 4 files changed, 106 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66..c2e6e43 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -706,7 +706,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		callchain_param.order = ORDER_CALLER;
 	else if (!strncmp(tok2, "callee", strlen("callee")))
 		callchain_param.order = ORDER_CALLEE;
-	else
+	else if (tok2[0] != 0)
 		return -1;
 
 	/* Get the sort key */
@@ -717,8 +717,15 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		callchain_param.key = CCKEY_FUNCTION;
 	else if (!strncmp(tok2, "address", strlen("address")))
 		callchain_param.key = CCKEY_ADDRESS;
-	else
+	else if (tok2[0] != 0)
 		return -1;
+
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "branch", 6))
+		callchain_param.branch_callstack = 1;
+
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
@@ -831,8 +838,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order[,branch]",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), add branches. "
 		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 4f7f989..3d799f2 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -53,6 +53,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	bool			branch_callstack;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84cdb07..a7e538b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1254,9 +1254,58 @@ struct branch_info *machine__resolve_bstack(struct machine *machine,
 	return bi;
 }
 
+static int add_callchain_ip(struct machine *machine,
+			    struct thread *thread,
+			    struct symbol **parent,
+			    struct addr_location *root_al,
+			    int cpumode,
+			    u64 ip)
+{
+	struct addr_location al;
+
+	al.filtered = false;
+	al.sym = NULL;
+	if (cpumode == -1) {
+		int i;
+
+		for (i = 0; i < (int)NCPUMODES && !al.sym; i++) {
+			/*
+	 	 	 * We cannot use the header.misc hint to determine whether a
+		 	 * branch stack address is user, kernel, guest, hypervisor.
+		 	 * Branches may straddle the kernel/user/hypervisor boundaries.
+		 	 * Thus, we have to try consecutively until we find a match
+		 	 * or else, the symbol is unknown
+		 	 */
+			thread__find_addr_location(thread, machine, cpumodes[i], 
+					MAP__FUNCTION,
+					ip, &al);
+		}
+	} else {
+		thread__find_addr_location(thread, machine, cpumode,
+					   MAP__FUNCTION, ip, &al);
+	}
+	if (al.sym != NULL) {
+		if (sort__has_parent && !*parent &&
+		    symbol__match_regex(al.sym, &parent_regex))
+			*parent = al.sym;
+		else if (have_ignore_callees && root_al &&
+		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
+			/* Treat this symbol as the root,
+			   forgetting its callees. */
+			*root_al = al;
+			callchain_cursor_reset(&callchain_cursor);
+		}
+		if (!symbol_conf.use_callchain)
+			return -EINVAL;
+	}
+
+	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+}
+
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
+					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
 					     int max_stack)
@@ -1268,6 +1317,43 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 
 	callchain_cursor_reset(&callchain_cursor);
 
+	/* 
+	 * Add branches to call stack for easier browsing. This gives
+	 * more context for a sample than just the callers.
+	 * 
+	 * This uses individual histograms of paths compared to the
+	 * aggregated histograms the normal LBR mode uses.
+	 *
+	 * Limitations for now:
+	 * - No extra filters
+	 * - No annotations (should annotate somehow)
+	 * - When the sample is near the beginning of the function
+ 	 *   we may overlap with the real callstack. Could handle this
+	 *   case later, by checking against the last ip.
+	 */
+
+	if (callchain_param.branch_callstack) {
+		for (i = 0; i < branch->nr; i++) { 
+			struct branch_entry *b; 
+
+			if (callchain_param.order == ORDER_CALLEE)
+				b = &branch->entries[i];
+			else
+				b = &branch->entries[branch->nr - i - 1];
+
+			err = add_callchain_ip(machine, thread, parent, root_al,
+					       -1, b->to);
+			if (!err)
+				err = add_callchain_ip(machine, thread, parent, root_al,
+					       -1, b->from);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+
+		}
+	}
+
 	if (chain->nr > PERF_MAX_STACK_DEPTH) {
 		pr_warning("corrupted callchain. skipping...\n");
 		return 0;
@@ -1275,7 +1361,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			ip = chain->ips[i];
@@ -1306,26 +1391,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
-		al.filtered = false;
-		thread__find_addr_location(thread, machine, cpumode,
-					   MAP__FUNCTION, ip, &al);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    symbol__match_regex(al.sym, &parent_regex))
-				*parent = al.sym;
-			else if (have_ignore_callees && root_al &&
-			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
-				/* Treat this symbol as the root,
-				   forgetting its callees. */
-				*root_al = al;
-				callchain_cursor_reset(&callchain_cursor);
-			}
-			if (!symbol_conf.use_callchain)
-				break;
-		}
 
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
+		err = add_callchain_ip(machine, thread, parent, root_al, cpumode, ip);
+		if (err == -EINVAL)
+			break;
 		if (err)
 			return err;
 	}
@@ -1351,7 +1420,9 @@ int machine__resolve_callchain(struct machine *machine,
 	int ret;
 
 	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent,
+						sample->callchain, 
+						sample->branch_stack,
+						parent,
 						root_al, max_stack);
 	if (ret)
 		return ret;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 07de8fe..a21436e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -99,7 +99,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			branch_callstack;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.8.3.1

