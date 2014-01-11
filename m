Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaAKTsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:48:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:63799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbaAKTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="465222331"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/9] perf, tools: Support handling complete branch stacks as histograms
Date: Sat, 11 Jan 2014 11:42:52 -0800
Message-Id: <1389469379-13340-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Currently branch stacks can be only shown as edge histograms for
individual branches. I never found this display particularly useful.

This implements an alternative mode that creates histograms over complete
branch traces, instead of individual branches, similar to how normal
callgraphs are handled. This is done by putting it in
front of the normal callgraph and then using the normal callgraph
histogram infrastructure to unify them.

This way in complex functions we can understand the control flow
that lead to a particular sample, and may even see some control
flow in the caller for short functions.

Example (simplified, of course for such simple code this
is usually not needed):

tcall.c:

volatile a = 10000, b = 100000, c;

__attribute__((noinline)) f2()
{
	c = a / b;
}

__attribute__((noinline)) f1()
{
	f2();
	f2();
}
main()
{
	int i;
	for (i = 0; i < 1000000; i++)
		f1();
}

% perf record -b -g ./tsrc/tcall
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
% perf report --branch-history
...
    54.91%  tcall.c:6  [.] f2                      tcall
            |
            |--65.53%-- f2 tcall.c:5
            |          |
            |          |--70.83%-- f1 tcall.c:11
            |          |          f1 tcall.c:10
            |          |          main tcall.c:18
            |          |          main tcall.c:18
            |          |          main tcall.c:17
            |          |          main tcall.c:17
            |          |          f1 tcall.c:13
            |          |          f1 tcall.c:13
            |          |          f2 tcall.c:7
            |          |          f2 tcall.c:5
            |          |          f1 tcall.c:12
            |          |          f1 tcall.c:12
            |          |          f2 tcall.c:7
            |          |          f2 tcall.c:5
            |          |          f1 tcall.c:11
            |          |
            |           --29.17%-- f1 tcall.c:12
            |                     f1 tcall.c:12
            |                     f2 tcall.c:7
            |                     f2 tcall.c:5
            |                     f1 tcall.c:11
            |                     f1 tcall.c:10
            |                     main tcall.c:18
            |                     main tcall.c:18
            |                     main tcall.c:17
            |                     main tcall.c:17
            |                     f1 tcall.c:13
            |                     f1 tcall.c:13
            |                     f2 tcall.c:7
            |                     f2 tcall.c:5
            |                     f1 tcall.c:12

The default output is unchanged.

This is only implemented in perf report, no change to record
or anywhere else.

This adds the basic code to report:
- add a new "branch" option to the -g option parser to enable this mode
- when the flag is set include the LBR into the callstack in machine.c.
The rest of the history code is unchanged and doesn't know the difference
between LBR entry and normal call entry.

Current limitations:
- The LBR flags (mispredict etc.) are not shown in the history
and LBR entries have no special marker.
- It would be nice if annotate marked the LBR entries somehow
(e.g. with arrows)

v2: Various fixes.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-report.c |  15 ++++--
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/machine.c   | 113 ++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h    |   3 +-
 4 files changed, 106 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 46864dd..19a74e1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -658,7 +658,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		callchain_param.order = ORDER_CALLER;
 	else if (!strncmp(tok2, "callee", strlen("callee")))
 		callchain_param.order = ORDER_CALLEE;
-	else
+	else if (tok2[0] != 0)
 		return -1;
 
 	/* Get the sort key */
@@ -669,8 +669,15 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
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
 		pr_err("Can't register callchain params\n");
@@ -786,8 +793,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 08b25af..a1a298a 100644
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
index 0130279..f2eaf85 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1248,9 +1248,58 @@ struct branch_info *machine__resolve_bstack(struct machine *machine,
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
@@ -1262,6 +1311,43 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 
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
@@ -1269,7 +1355,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			ip = chain->ips[i];
@@ -1300,26 +1385,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
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
@@ -1345,7 +1414,9 @@ int machine__resolve_callchain(struct machine *machine,
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
index cbd6803..0da4b24 100644
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

