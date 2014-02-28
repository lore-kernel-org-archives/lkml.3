Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaB1EXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:23:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB1EWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:22:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="491307976"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/8] perf, tools: Support handling complete branch stacks as histograms v4
Date: Thu, 27 Feb 2014 20:22:26 -0800
Message-Id: <1393561352-23448-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |   7 +-
 tools/perf/builtin-report.c              |  15 ++-
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/machine.c                | 188 ++++++++++++++++++++++++++-----
 tools/perf/util/symbol.h                 |   3 +-
 5 files changed, 177 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4..349cd2a 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -121,7 +121,7 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min[,limit],order[,key]]::
+-g [type,min[,limit],order[,key][,branch]]::
 --call-graph::
         Display call chains using type, min percent threshold, optional print
 	limit and order.
@@ -139,6 +139,11 @@ OPTIONS
 	- function: compare on functions
 	- address: compare on individual code addresses
 
+	branch can be:
+	- branch: include last branch information in callgraph
+	when available. Usually more convenient to use --branch-history
+	for this.
+
 	Default: fractal,0.5,callee,function.
 
 --max-stack::
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d882b6f..f7a9e3d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -634,7 +634,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		callchain_param.order = ORDER_CALLER;
 	else if (!strncmp(tok2, "callee", strlen("callee")))
 		callchain_param.order = ORDER_CALLEE;
-	else
+	else if (tok2[0] != 0)
 		return -1;
 
 	/* Get the sort key */
@@ -645,8 +645,15 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
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
@@ -762,8 +769,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 8ad97e9..be29bb8 100644
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
index ac37d78..6eff65e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
+#include "linux/hash.h"
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
@@ -1192,17 +1193,16 @@ static const u8 cpumodes[] = {
 };
 #define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
 
-static void ip__resolve_ams(struct machine *machine, struct thread *thread,
-			    struct addr_map_symbol *ams,
-			    u64 ip)
+static void resolve_branch_ams(struct machine *machine, struct thread *thread,
+			       u64 ip,
+			       struct addr_location *al)
 {
-	struct addr_location al;
 	size_t i;
 	u8 m;
 
-	memset(&al, 0, sizeof(al));
+	memset(al, 0, sizeof(*(al)));
 
-	for (i = 0; i < NCPUMODES; i++) {
+	for (i = 0; i < NCPUMODES && !al->sym; i++) {
 		m = cpumodes[i];
 		/*
 		 * We cannot use the header.misc hint to determine whether a
@@ -1212,11 +1212,17 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 		 * or else, the symbol is unknown
 		 */
 		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
-				ip, &al);
-		if (al.sym)
-			goto found;
+				ip, al);
 	}
-found:
+}
+
+static void ip__resolve_ams(struct machine *machine, struct thread *thread,
+			    struct addr_map_symbol *ams,
+			    u64 ip)
+{
+	struct addr_location al;
+
+	resolve_branch_ams(machine, thread, ip, &al);
 	ams->addr = ip;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
@@ -1272,9 +1278,85 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
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
+		resolve_branch_ams(machine, thread, ip, &al);
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
+	memset(chash, -1, sizeof(chash));
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
@@ -1283,17 +1365,73 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
 	int err;
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
+	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
+		pr_warning("corrupted branch chain. skipping...\n");
+		return 0;
+	}
+
+	if (callchain_param.branch_callstack) {
+		int nr = min(max_stack, (int)branch->nr);
+		struct branch_entry be[nr];
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
 	}
 
-	for (i = 0; i < chain_nr; i++) {
+	for (i = first_call; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			ip = chain->ips[i];
@@ -1324,24 +1462,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
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
@@ -1367,7 +1491,9 @@ int machine__resolve_callchain(struct machine *machine,
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
index 2553ae0..33b2be7 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -115,7 +115,8 @@ struct symbol_conf {
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
1.8.5.3

