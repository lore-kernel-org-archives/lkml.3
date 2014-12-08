Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaLHGx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:53:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHGxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:53:24 -0500
Date: Sun, 7 Dec 2014 22:53:10 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-8b7bad58efb7e3aaff60f7c1fa4361fb8c23181d@git.kernel.org>
Cc: acme@redhat.com, tglx@linutronix.de, mingo@kernel.org, ak@linux.intel.com,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        namhyung@kernel.org
Reply-To: hpa@zytor.com, namhyung@kernel.org, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, mingo@kernel.org,
        acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1415844328-4884-3-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Support handling complete branch stacks as histograms
Git-Commit-ID: 8b7bad58efb7e3aaff60f7c1fa4361fb8c23181d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b7bad58efb7e3aaff60f7c1fa4361fb8c23181d
Gitweb:     http://git.kernel.org/tip/8b7bad58efb7e3aaff60f7c1fa4361fb8c23181d
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:20 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:31 -0300

perf callchain: Support handling complete branch stacks as histograms

Currently branch stacks can be only shown as edge histograms for
individual branches. I never found this display particularly useful.

This implements an alternative mode that creates histograms over
complete branch traces, instead of individual branches, similar to how
normal callgraphs are handled. This is done by putting it in front of
the normal callgraph and then using the normal callgraph histogram
infrastructure to unify them.

This way in complex functions we can understand the control flow that
lead to a particular sample, and may even see some control flow in the
caller for short functions.

Example (simplified, of course for such simple code this is usually not
needed), please run this after the whole patchkit is in, as at this
point in the patch order there is no --branch-history, that will be
added in a patch after this one:

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
% perf report --no-children --branch-history
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

This is only implemented in perf report, no change to record or anywhere
else.

This adds the basic code to report:

- add a new "branch" option to the -g option parser to enable this mode
- when the flag is set include the LBR into the callstack in machine.c.

The rest of the history code is unchanged and doesn't know the
difference between LBR entry and normal call entry.

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
v8: Port to latest tip. Move add_callchain_ip to separate
    patch. Skip initial entries in callchain. Minor cleanups.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-3-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |   7 +-
 tools/perf/builtin-report.c              |   4 +-
 tools/perf/util/callchain.c              |   4 +
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/machine.c                | 126 ++++++++++++++++++++++++++++---
 tools/perf/util/symbol.h                 |   3 +-
 6 files changed, 132 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 0927bf4..22706be 100644
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
index 140a6cd..410d44f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -637,8 +637,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 517ed84..cf524a3 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -149,6 +149,10 @@ static int parse_callchain_sort_key(const char *value)
 		callchain_param.key = CCKEY_ADDRESS;
 		return 0;
 	}
+	if (!strncmp(value, "branch", strlen(value))) {
+		callchain_param.branch_callstack = 1;
+		return 0;
+	}
 	return -1;
 }
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3f15847..dbc08cf 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -63,6 +63,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	bool			branch_callstack;
 };
 
 extern struct callchain_param callchain_param;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b75b487..15dd0a9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -12,6 +12,7 @@
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
+#include "linux/hash.h"
 
 static void dsos__init(struct dsos *dsos)
 {
@@ -1391,7 +1392,11 @@ static int add_callchain_ip(struct thread *thread,
 
 	al.filtered = 0;
 	al.sym = NULL;
-	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+	if (cpumode == -1)
+		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
+						   ip, &al);
+	else
+		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
 				   ip, &al);
 	if (al.sym != NULL) {
 		if (sort__has_parent && !*parent &&
@@ -1427,8 +1432,50 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 	return bi;
 }
 
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
+
+	memset(chash, NO_ENTRY, sizeof(chash));
+
+	BUG_ON(PERF_MAX_BRANCH_DEPTH > 255);
+
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
+					(nr - (i + off)) * sizeof(*l));
+				nr -= off;
+			}
+		}
+	}
+	return nr;
+}
+
 static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct ip_callchain *chain,
+					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
 					     int max_stack)
@@ -1438,22 +1485,82 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 	int i;
 	int j;
 	int err;
-	int skip_idx __maybe_unused;
+	int skip_idx = -1;
+	int first_call = 0;
+
+	/*
+	 * Based on DWARF debug information, some architectures skip
+	 * a callchain entry saved by the kernel.
+	 */
+	if (chain->nr < PERF_MAX_STACK_DEPTH)
+		skip_idx = arch_skip_callchain_idx(thread, chain);
 
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
+			goto check_calls;
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
+				if (i == skip_idx ||
+				    chain->ips[first_call] >= PERF_CONTEXT_MAX)
+					first_call++;
+				else if (be[i].from < chain->ips[first_call] &&
+				    be[i].from >= chain->ips[first_call] - 8)
+					first_call++;
+			} else
+				be[i] = branch->entries[branch->nr - i - 1];
+		}
+
+		nr = remove_loops(be, nr);
+
+		for (i = 0; i < nr; i++) {
+			err = add_callchain_ip(thread, parent, root_al,
+					       -1, be[i].to);
+			if (!err)
+				err = add_callchain_ip(thread, parent, root_al,
+						       -1, be[i].from);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
+		chain_nr -= nr;
+	}
+
+check_calls:
 	if (chain->nr > PERF_MAX_STACK_DEPTH) {
 		pr_warning("corrupted callchain. skipping...\n");
 		return 0;
 	}
 
-	/*
-	 * Based on DWARF debug information, some architectures skip
-	 * a callchain entry saved by the kernel.
-	 */
-	skip_idx = arch_skip_callchain_idx(thread, chain);
-
-	for (i = 0; i < chain_nr; i++) {
+	for (i = first_call; i < chain_nr; i++) {
 		u64 ip;
 
 		if (callchain_param.order == ORDER_CALLEE)
@@ -1517,6 +1624,7 @@ int thread__resolve_callchain(struct thread *thread,
 			      int max_stack)
 {
 	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
+						   sample->branch_stack,
 						   parent, root_al, max_stack);
 	if (ret)
 		return ret;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index e0b297c..9d602e9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -102,7 +102,8 @@ struct symbol_conf {
 			demangle,
 			demangle_kernel,
 			filter_relative,
-			show_hist_headers;
+			show_hist_headers,
+			branch_callstack;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
