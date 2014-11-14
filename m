Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323AbaKNN7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:59:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:4466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935271AbaKNN7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:59:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,386,1413270000"; 
   d="scan'208";a="607847740"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH V3 3/3] perf tools: Construct LBR call chain
Date: Fri, 14 Nov 2014 08:44:12 -0500
Message-Id: <1415972652-17310-4-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

LBR call stack only has user callchain. It is output as
PERF_SAMPLE_BRANCH_STACK data format. For the kernel callchain, it's
still from PERF_SAMPLE_CALLCHAIN.
The perf tool has to handle both data sources to construct a
complete callstack.
For perf report -D option, both lbr and fp information will be
displayed.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/evsel.h   |  4 +++
 tools/perf/util/machine.c | 72 +++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/session.c | 60 +++++++++++++++++++++++++++++++++++----
 3 files changed, 122 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 9797909..1bbaa74 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -368,4 +368,8 @@ for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
      (_evsel) && (_evsel)->leader == (_leader);					\
      (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
 
+static inline bool has_branch_callstack(struct perf_evsel *evsel)
+{
+	return evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK;
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index dd8496a..a26c9e0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1452,15 +1452,19 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 }
 
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
 	int i, j, err = 0;
 	int skip_idx __maybe_unused;
+	u64 ip;
+	bool lbr = has_branch_callstack(evsel);
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1469,6 +1473,59 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 		return 0;
 	}
 
+	if (lbr) {
+		for (i = 0; i < chain_nr; i++) {
+			if (chain->ips[i] == PERF_CONTEXT_USER)
+				break;
+		}
+
+		/* LBR only affects the user callchain */
+		if (i != chain_nr) {
+			struct branch_stack *lbr_stack = sample->branch_stack;
+			int lbr_nr = lbr_stack->nr;
+			/*
+			 * LBR callstack can only get user call chain.
+			 * The mix_chain_nr is kernel call chain
+			 * number plus LBR user call chain number.
+			 * i is kernel call chain number,
+			 * 1 is PERF_CONTEXT_USER,
+			 * lbr_nr + 1 is the user call chain number.
+			 * For details, please refer to the comments
+			 * in callchain__printf
+			 */
+			int mix_chain_nr = i + 1 + lbr_nr + 1;
+
+			if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
+				pr_warning("corrupted callchain. skipping...\n");
+				return 0;
+			}
+
+			for (j = 0; j < mix_chain_nr; j++) {
+				if (callchain_param.order == ORDER_CALLEE) {
+					if (j < i + 1)
+						ip = chain->ips[j];
+					else if (j > i + 1)
+						ip = lbr_stack->entries[j - i - 2].from;
+					else
+						ip = lbr_stack->entries[0].to;
+				} else {
+					if (j < lbr_nr)
+						ip = lbr_stack->entries[lbr_nr - j - 1].from;
+					else if (j > lbr_nr)
+						ip = chain->ips[i + 1 - (j - lbr_nr)];
+					else
+						ip = lbr_stack->entries[0].to;
+				}
+
+				err = add_callchain_ip(thread, parent, root_al,
+						       cpumode, ip);
+				if (err)
+					goto exit;
+			}
+			return 0;
+		}
+	}
+
 	/*
 	 * Based on DWARF debug information, some architectures skip
 	 * a callchain entry saved by the kernel.
@@ -1476,8 +1533,6 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 	skip_idx = arch_skip_callchain_idx(thread, chain);
 
 	for (i = 0; i < chain_nr; i++) {
-		u64 ip;
-
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
 		else
@@ -1512,8 +1567,9 @@ int thread__resolve_callchain(struct thread *thread,
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
index f4478ce..335c3a9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -557,15 +557,63 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	return 0;
 }
 
-static void callchain__printf(struct perf_sample *sample)
+static void callchain__printf(struct perf_evsel *evsel,
+			      struct perf_sample *sample)
 {
 	unsigned int i;
+	struct ip_callchain *callchain = sample->callchain;
+	bool lbr = has_branch_callstack(evsel);
 
-	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
+	if (lbr) {
+		struct branch_stack *lbr_stack = sample->branch_stack;
+		u64 kernel_callchain_nr = callchain->nr;
 
-	for (i = 0; i < sample->callchain->nr; i++)
+		for (i = 0; i < kernel_callchain_nr; i++) {
+			if (callchain->ips[i] == PERF_CONTEXT_USER)
+				break;
+		}
+
+		if ((i != kernel_callchain_nr) && lbr_stack->nr) {
+			u64 total_nr;
+			/*
+			 * LBR callstack can only get user call chain,
+			 * i is kernel call chain number,
+			 * 1 is PERF_CONTEXT_USER.
+			 *
+			 * The user call chain is stored in LBR registers.
+			 * LBR are pair registers. The caller is stored
+			 * in "from" register, while the callee is stored
+			 * in "to" register.
+			 * For example, there is a call stack
+			 * "A"->"B"->"C"->"D".
+			 * The LBR registers will recorde like
+			 * "C"->"D", "B"->"C", "A"->"B".
+			 * So only the first "to" register and all "from"
+			 * registers are needed to construct the whole stack.
+			 */
+			total_nr = i + 1 + lbr_stack->nr + 1;
+			kernel_callchain_nr = i + 1;
+
+			printf("... LBR call chain: nr:%" PRIu64 "\n", total_nr);
+
+			for (i = 0; i < kernel_callchain_nr; i++)
+				printf("..... %2d: %016" PRIx64 "\n",
+				       i, callchain->ips[i]);
+
+			printf("..... %2d: %016" PRIx64 "\n",
+			       (int)(kernel_callchain_nr), lbr_stack->entries[0].to);
+			for (i = 0; i < lbr_stack->nr; i++)
+				printf("..... %2d: %016" PRIx64 "\n",
+				       (int)(i + kernel_callchain_nr + 1), lbr_stack->entries[i].from);
+		}
+
+	}
+
+	printf("... FP chain: nr:%" PRIu64 "\n", callchain->nr);
+
+	for (i = 0; i < callchain->nr; i++)
 		printf("..... %2d: %016" PRIx64 "\n",
-		       i, sample->callchain->ips[i]);
+		       i, callchain->ips[i]);
 }
 
 static void branch_stack__printf(struct perf_sample *sample)
@@ -691,9 +739,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	sample_type = evsel->attr.sample_type;
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN)
-		callchain__printf(sample);
+		callchain__printf(evsel, sample);
 
-	if (sample_type & PERF_SAMPLE_BRANCH_STACK)
+	if ((sample_type & PERF_SAMPLE_BRANCH_STACK) && !has_branch_callstack(evsel))
 		branch_stack__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER)
-- 
1.8.3.2

