Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaKFPNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:13:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:35147 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaKFPNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="632672600"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 2/2] perf tools: Construct LBR call chain
Date: Thu,  6 Nov 2014 09:58:06 -0500
Message-Id: <1415285886-16949-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

LBR call stack only has user callchain. It is output as
PERF_SAMPLE_BRANCH_STACK data format. For the kernel callchain, it's
still from PERF_SAMPLE_CALLCHAIN.
The perf tool has to handle both data sources to construct a
complete callstack.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/machine.c | 194 ++++++++++++++++++++++++++++++----------------
 tools/perf/util/session.c |  41 ++++++++--
 2 files changed, 163 insertions(+), 72 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e9490..f51014f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1399,18 +1399,70 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 	return bi;
 }
 
+static inline int __thread__resolve_callchain_sample(struct thread *thread,
+						     u64 ip, u8 *cpumode,
+						     struct symbol **parent,
+						     struct addr_location *root_al,
+						     struct addr_location *al)
+{
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
+	thread__find_addr_location(thread, *cpumode,
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
+	return callchain_cursor_append(&callchain_cursor,
+				      ip, al->map, al->sym);
+}
+
 static int thread__resolve_callchain_sample(struct thread *thread,
-					     struct ip_callchain *chain,
-					     struct symbol **parent,
-					     struct addr_location *root_al,
-					     int max_stack)
+					    struct perf_evsel *evsel,
+					    struct perf_sample *sample,
+					    struct symbol **parent,
+					    struct addr_location *root_al,
+					    int max_stack)
 {
+	struct ip_callchain *chain = sample->callchain;
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
-	int i;
-	int j;
-	int err;
+	int i, j, err = 0;
 	int skip_idx __maybe_unused;
+	int lbr = 0;
+	u64 ip;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1419,74 +1471,81 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 		return 0;
 	}
 
-	/*
-	 * Based on DWARF debug information, some architectures skip
-	 * a callchain entry saved by the kernel.
-	 */
-	skip_idx = arch_skip_callchain_idx(thread, chain);
+	if (evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
+		lbr = 1;
 
-	for (i = 0; i < chain_nr; i++) {
-		u64 ip;
-		struct addr_location al;
+again:
+	/* LBR call stack */
+	if (lbr) {
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
+			lbr = 0;
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
-		thread__find_addr_location(thread, cpumode,
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
+			err = __thread__resolve_callchain_sample(thread,
+				ip, &cpumode, parent, root_al, &al);
+			if (err)
+				goto exit;
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
+		skip_idx = arch_skip_callchain_idx(thread, chain);
 
-	return 0;
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
+			err = __thread__resolve_callchain_sample(thread,
+				ip, &cpumode, parent, root_al, &al);
+			if (err)
+				goto exit;
+		}
+	}
+exit:
+	return (err < 0) ? err : 0;
 }
 
 static int unwind_entry(struct unwind_entry *entry, void *arg)
@@ -1503,8 +1562,9 @@ int thread__resolve_callchain(struct thread *thread,
 			      struct addr_location *root_al,
 			      int max_stack)
 {
-	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
-						   parent, root_al, max_stack);
+	int ret = thread__resolve_callchain_sample(thread, evsel,
+						   sample, parent,
+						   root_al, max_stack);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f4478ce..fa476be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -557,15 +557,45 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	return 0;
 }
 
-static void callchain__printf(struct perf_sample *sample)
+static void callchain__printf(struct perf_evsel *evsel,
+			      struct perf_sample *sample)
 {
 	unsigned int i;
+	u64 total_nr, callchain_nr;
+	int lbr = 0;
 
-	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
+	total_nr = callchain_nr = sample->callchain->nr;
 
-	for (i = 0; i < sample->callchain->nr; i++)
+	if (evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
+		lbr = 1;
+
+	if (lbr) {
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
@@ -691,9 +721,10 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	sample_type = evsel->attr.sample_type;
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		callchain__printf(sample);
+		callchain__printf(evsel, sample);
 
-	if (sample_type & PERF_SAMPLE_BRANCH_STACK)
+	if ((sample_type & PERF_SAMPLE_BRANCH_STACK) &&
+		!(evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK))
 		branch_stack__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER)
-- 
1.8.3.2

