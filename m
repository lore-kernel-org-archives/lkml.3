Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaJSWGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:06:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaJSWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644519"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 17/17] perf tools: choose to dump callchain from LBR and FP
Date: Sun, 19 Oct 2014 17:55:12 -0400
Message-Id: <1413755712-8259-18-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend call-graph option in perf report to support callchain source (fp
or lbr).
The default value is fp. It means that frame pointers is preferred call
chain source. If it isn't available, lbr data will be used then.
If the value is set to lbr, it means lbr data is preferred call chain
source. If lbr data isn't available, try fp data then.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/builtin-report.c |   8 +-
 tools/perf/util/callchain.c |  18 +++-
 tools/perf/util/callchain.h |   6 ++
 tools/perf/util/machine.c   | 198 ++++++++++++++++++++++++++++++--------------
 tools/perf/util/session.c   |  34 +++++++-
 5 files changed, 194 insertions(+), 70 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 140a6cd..23fad5a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -575,7 +575,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
-	char callchain_default_opt[] = "fractal,0.5,callee";
+	char callchain_default_opt[] = "fractal,0.5,callee,function,fp";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
 		NULL
@@ -637,9 +637,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
-		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order,source",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), callchain source(fp or lbr). "
+		     "Default: fractal,0.5,callee,function,fp", &report_parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
 		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c84d3f8..281ba14 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -152,6 +152,19 @@ static int parse_callchain_sort_key(const char *value)
 	return -1;
 }
 
+static int parse_callchain_source(const char *value)
+{
+	if (!strncmp(value, "fp", strlen(value))) {
+		callchain_param.source = SOURCE_FP;
+		return 0;
+	}
+	if (!strncmp(value, "lbr", strlen(value))) {
+		callchain_param.source = SOURCE_LBR;
+		return 0;
+	}
+	return -1;
+}
+
 int
 parse_callchain_report_opt(const char *arg)
 {
@@ -173,7 +186,8 @@ parse_callchain_report_opt(const char *arg)
 
 		if (!parse_callchain_mode(tok) ||
 		    !parse_callchain_order(tok) ||
-		    !parse_callchain_sort_key(tok)) {
+		    !parse_callchain_sort_key(tok) ||
+		    !parse_callchain_source(tok)) {
 			/* parsing ok - move on to the next */
 		} else if (!minpcnt_set) {
 			/* try to get the min percent */
@@ -225,6 +239,8 @@ int perf_callchain_config(const char *var, const char *value)
 		return parse_callchain_order(value);
 	if (!strcmp(var, "sort-key"))
 		return parse_callchain_sort_key(value);
+	if (!strcmp(var, "source"))
+		return parse_callchain_source(value);
 	if (!strcmp(var, "threshold")) {
 		callchain_param.min_percent = strtod(value, &endptr);
 		if (value == endptr)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 94cfefd..6b3ba57 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -53,6 +53,11 @@ enum chain_key {
 	CCKEY_ADDRESS
 };
 
+enum chain_source {
+	SOURCE_FP,
+	SOURCE_LBR
+};
+
 struct callchain_param {
 	bool			enabled;
 	enum perf_call_graph_mode record_mode;
@@ -63,6 +68,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	enum chain_source	source;
 };
 
 extern struct callchain_param callchain_param;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 34fc7c8..9fc5fd9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1371,19 +1371,81 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 	return bi;
 }
 
+static inline int __machine__resolve_callchain_sample(struct machine *machine,
+			struct thread *thread,
+			u64 ip,
+			u8 *cpumode,
+			struct symbol **parent,
+			struct addr_location *root_al,
+			struct addr_location *al)
+{
+	int err;
+
+	if (ip >= PERF_CONTEXT_MAX) {
+		switch (ip) {
+		case PERF_CONTEXT_HV:
+			*cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			break;
+		case PERF_CONTEXT_KERNEL:
+			*cpumode = PERF_RECORD_MISC_KERNEL;
+			break;
+		case PERF_CONTEXT_USER:
+			*cpumode = PERF_RECORD_MISC_USER;
+			break;
+		default:
+			pr_debug("invalid callchain context: "
+				 "%"PRId64"\n", (s64) ip);
+			/*
+			 * It seems the callchain is corrupted.
+			 * Discard all.
+			 */
+			callchain_cursor_reset(&callchain_cursor);
+			return 1;
+		}
+		return 0;
+	}
+
+	al->filtered = 0;
+	thread__find_addr_location(thread, machine, *cpumode,
+				   MAP__FUNCTION, ip, al);
+	if (al->sym != NULL) {
+		if (sort__has_parent && !*parent &&
+		    symbol__match_regex(al->sym, &parent_regex))
+			*parent = al->sym;
+		else if (have_ignore_callees && root_al &&
+		  symbol__match_regex(al->sym, &ignore_callees_regex)) {
+			/* Treat this symbol as the root,
+			   forgetting its callees. */
+			*root_al = *al;
+			callchain_cursor_reset(&callchain_cursor);
+		}
+	}
+
+	err = callchain_cursor_append(&callchain_cursor,
+				      ip, al->map, al->sym);
+	if (err)
+		return err;
+	return 0;
+}
+
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
-					     struct ip_callchain *chain,
+					     struct perf_sample *sample,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
 					     int max_stack)
 {
+	struct ip_callchain *chain = sample->callchain;
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err;
 	int skip_idx __maybe_unused;
+	int use_fp = (callchain_param.source == SOURCE_FP) ? 1 : 0;
+	u64 ip;
+
+	/* If there isn't user fp callchain available, try LBR */
+	if (!(chain->source & PERF_FP_CALLCHAIN))
+		use_fp = 0;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1392,73 +1454,83 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
-	/*
-	 * Based on DWARF debug information, some architectures skip
-	 * a callchain entry saved by the kernel.
-	 */
-	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
-
-	for (i = 0; i < chain_nr; i++) {
-		u64 ip;
-		struct addr_location al;
+again:
+	/* try LBR */
+	if (!use_fp && (chain->source & PERF_LBR_CALLCHAIN)) {
+		struct branch_stack *lbr_stack = sample->branch_stack;
+		int lbr_nr = lbr_stack->nr;
+		int mix_chain_nr;
 
-		if (callchain_param.order == ORDER_CALLEE)
-			j = i;
-		else
-			j = chain->nr - i - 1;
+		for (i = 0; i < chain_nr; i++) {
+			if (chain->ips[i] == PERF_CONTEXT_USER)
+				break;
+		}
 
-#ifdef HAVE_SKIP_CALLCHAIN_IDX
-		if (j == skip_idx)
-			continue;
-#endif
-		ip = chain->ips[j];
+		/* LBR only affects the user callchain */
+		if (i == chain_nr) {
+			use_fp = 1;
+			goto again;
+		}
 
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;
-				break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;
-				break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;
-				break;
-			default:
-				pr_debug("invalid callchain context: "
-					 "%"PRId64"\n", (s64) ip);
-				/*
-				 * It seems the callchain is corrupted.
-				 * Discard all.
-				 */
-				callchain_cursor_reset(&callchain_cursor);
-				return 0;
-			}
-			continue;
+		mix_chain_nr = i + 2 + lbr_nr;
+		if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
+			pr_warning("corrupted callchain. skipping...\n");
+			return 0;
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
+		for (j = 0; j < mix_chain_nr; j++) {
+			struct addr_location al;
+
+			if (callchain_param.order == ORDER_CALLEE) {
+				if (j < i + 2)
+					ip = chain->ips[j];
+				else
+					ip = lbr_stack->entries[j - i - 2].from;
+			} else {
+				if (j < lbr_nr)
+					ip = lbr_stack->entries[lbr_nr - j - 1].from;
+				else
+					ip = chain->ips[i + 1 - (j - lbr_nr)];
 			}
+			err = __machine__resolve_callchain_sample(machine,
+				thread, ip, &cpumode, parent, root_al, &al);
+			/* Discard all when the callchain is corrupted */
+			if (err > 0)
+				return 0;
+			else if (err)
+				return err;
 		}
+	} else {
 
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
-		if (err)
-			return err;
-	}
+		/*
+		 * Based on DWARF debug information, some architectures skip
+		 * a callchain entry saved by the kernel.
+		 */
+		skip_idx = arch_skip_callchain_idx(machine, thread, chain);
+
+		for (i = 0; i < chain_nr; i++) {
+			struct addr_location al;
+
+			if (callchain_param.order == ORDER_CALLEE)
+				j = i;
+			else
+				j = chain->nr - i - 1;
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+			if (j == skip_idx)
+				continue;
+#endif
+			ip = chain->ips[j];
+			err = __machine__resolve_callchain_sample(machine,
+				thread, ip, &cpumode, parent, root_al, &al);
 
+			/* Discard all when the callchain is corrupted */
+			if (err > 0)
+				return 0;
+			else if (err)
+				return err;
+		}
+	}
 	return 0;
 }
 
@@ -1480,7 +1552,7 @@ int machine__resolve_callchain(struct machine *machine,
 	int ret;
 
 	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent,
+						sample, parent,
 						root_al, max_stack);
 	if (ret)
 		return ret;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac2..75fa183 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -548,12 +548,42 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 static void callchain__printf(struct perf_sample *sample)
 {
 	unsigned int i;
+	u64 total_nr, callchain_nr;
+	int use_fp = (callchain_param.source == SOURCE_FP) ? 1 : 0;
 
-	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
+	total_nr = callchain_nr = sample->callchain->nr;
 
-	for (i = 0; i < sample->callchain->nr; i++)
+	/* If there isn't user fp callchain available, try LBR */
+	if (!(sample->callchain->source & PERF_FP_CALLCHAIN))
+		use_fp = 0;
+
+	if (!use_fp && (sample->callchain->source & PERF_LBR_CALLCHAIN)) {
+		struct branch_stack *lbr_stack = sample->branch_stack;
+
+		for (i = 0; i < callchain_nr; i++) {
+			if (sample->callchain->ips[i] == PERF_CONTEXT_USER)
+				break;
+		}
+
+		if (i != callchain_nr) {
+			total_nr = i + 1 + lbr_stack->nr;
+			callchain_nr = i + 1;
+		}
+	}
+
+	printf("... chain: nr:%" PRIu64 "\n", total_nr);
+
+	for (i = 0; i < callchain_nr + 1; i++)
 		printf("..... %2d: %016" PRIx64 "\n",
 		       i, sample->callchain->ips[i]);
+
+	if (total_nr > callchain_nr) {
+		struct branch_stack *lbr_stack = sample->branch_stack;
+
+		for (i = 0; i < lbr_stack->nr; i++)
+			printf("..... %2d: %016" PRIx64 "\n",
+				(int)(i + callchain_nr + 1), lbr_stack->entries[i].from);
+	}
 }
 
 static void branch_stack__printf(struct perf_sample *sample)
-- 
1.8.3.2

