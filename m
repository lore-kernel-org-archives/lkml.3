Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbaIPAPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:15:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:48904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbaIPAPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="477731866"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] perf, tools: Support handling complete branch stacks as histograms
Date: Mon, 15 Sep 2014 16:54:26 -0700
Message-Id: <1410825273-7054-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
References: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
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
- detect overlaps with the callchain
- remove small loop duplicates in the LBR

Current limitations:
- The LBR flags (mispredict etc.) are not shown in the history
and LBR entries have no special marker.
- It would be nice if annotate marked the LBR entries somehow
(e.g. with arrows)

v2: Various fixes.
v3: Merge further patches into this one. Fix white space.
v4: Improve manpage. Address review feedback.
v5: Rename functions. Better error message without -g. Fix crash without
    -b.
v6: Rebase
v7: Rebase. Use NO_ENTRY in memset.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |   7 +-
 tools/perf/builtin-report.c              |   4 +-
 tools/perf/util/callchain.c              |   2 +
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/machine.c                | 162 +++++++++++++++++++++++++++----
 tools/perf/util/symbol.h                 |   3 +-
 6 files changed, 154 insertions(+), 25 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index d561e02..3e3801c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -159,7 +159,7 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min[,limit],order[,key]]::
+-g [type,min[,limit],order[,key][,branch]]::
 --call-graph::
         Display call chains using type, min percent threshold, optional print
 	limit and order.
@@ -177,6 +177,11 @@ OPTIONS
 	- function: compare on functions
 	- address: compare on individual code addresses
 
+	branch can be:
+	- branch: include last branch information in callgraph
+	when available. Usually more convenient to use --branch-history
+	for this.
+
 	Default: fractal,0.5,callee,function.
 
 --children::
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3da59a8..fd6b019 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -628,8 +628,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order[,branch]",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), add branches. "
 		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
 		    "Accumulate callchains of children and show total overhead as well"),
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 08f0fbf..265457c 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -61,6 +61,8 @@ parse_callchain_report_opt(const char *arg)
 			callchain_param.key = CCKEY_FUNCTION;
 		else if (!strncmp(tok, "address", strlen(tok)))
 			callchain_param.key = CCKEY_ADDRESS;
+		else if (!strncmp(tok, "branch", strlen(tok)))
+			callchain_param.branch_callstack = 1;
 		/* try to get the min percent */
 		else if (!minpcnt_set) {
 			callchain_param.min_percent = strtod(tok, &endptr);
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index da43619..7a1788a 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -60,6 +60,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	bool			branch_callstack;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ec38b..8ba32ce 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -12,6 +12,7 @@
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
+#include "linux/hash.h"
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
@@ -1364,9 +1365,84 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
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
+	al.filtered = 0;
+	al.sym = NULL;
+	if (cpumode == -1)
+		thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
+	else
+		thread__find_addr_location(thread, machine, cpumode, MAP__FUNCTION,
+				   ip, &al);
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
+#define CHASHSZ 127
+#define CHASHBITS 7
+#define NO_ENTRY 0xff
+
+#define PERF_MAX_BRANCH_DEPTH 127
+
+/* Remove loops. */
+static int remove_loops(struct branch_entry *l, int nr)
+{
+	int i, j, off;
+	unsigned char chash[CHASHSZ];
+	memset(chash, NO_ENTRY, sizeof(chash));
+
+	BUG_ON(nr >= 256);
+	for (i = 0; i < nr; i++) {
+		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;
+
+		/* no collision handling for now */
+		if (chash[h] == NO_ENTRY) {
+			chash[h] = i;
+		} else if (l[chash[h]].from == l[i].from) {
+			bool is_loop = true;
+			/* check if it is a real loop */
+			off = 0;
+			for (j = chash[h]; j < i && i + off < nr; j++, off++)
+				if (l[j].from != l[i + off].from) {
+					is_loop = false;
+					break;
+				}
+			if (is_loop) {
+				memmove(l + i, l + i + off,
+					(nr - (i + off))
+					* sizeof(struct branch_entry));
+				nr -= off;
+			}
+		}
+	}
+	return nr;
+}
+
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
+					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
 					     int max_stack)
@@ -1377,9 +1453,66 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int j;
 	int err;
 	int skip_idx __maybe_unused;
+	int first_call = 0;
 
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
+	 */
+
+	if (branch && callchain_param.branch_callstack) {
+		int nr = min(max_stack, (int)branch->nr);
+		struct branch_entry be[nr];
+
+		if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
+			pr_warning("corrupted branch chain. skipping...\n");
+			return 0;
+		}
+
+		for (i = 0; i < nr; i++) {
+			if (callchain_param.order == ORDER_CALLEE) {
+				be[i] = branch->entries[i];
+				/*
+				 * Check for overlap into the callchain.
+				 * The return address is one off compared to
+				 * the branch entry. To adjust for this
+				 * assume the calling instruction is not longer
+				 * than 8 bytes.
+				 */
+				if (be[i].from < chain->ips[first_call] &&
+				    be[i].from >= chain->ips[first_call] - 8)
+					first_call++;
+			} else
+				be[i] = branch->entries[branch->nr - i - 1];
+		}
+
+		nr = remove_loops(be, nr);
+
+		for (i = 0; i < nr; i++) {
+			err = add_callchain_ip(machine, thread, parent,
+					       root_al,
+					       -1, be[i].to);
+			if (!err)
+				err = add_callchain_ip(machine, thread,
+						       parent, root_al,
+						       -1, be[i].from);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
+		chain_nr -= nr;
+	}
+
 	if (chain->nr > PERF_MAX_STACK_DEPTH) {
 		pr_warning("corrupted callchain. skipping...\n");
 		return 0;
@@ -1391,9 +1524,8 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	 */
 	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
 
-	for (i = 0; i < chain_nr; i++) {
+	for (i = first_call; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
@@ -1430,24 +1562,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
-		al.filtered = 0;
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
-		}
-
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
+		err = add_callchain_ip(machine, thread, parent, root_al,
+				       cpumode, ip);
+		if (err == -EINVAL)
+			break;
 		if (err)
 			return err;
 	}
@@ -1473,7 +1591,9 @@ int machine__resolve_callchain(struct machine *machine,
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
index 3f95ea0..d28b94c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -121,7 +121,8 @@ struct symbol_conf {
 			event_group,
 			demangle,
 			filter_relative,
-			show_hist_headers;
+			show_hist_headers,
+			branch_callstack;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.9.3

