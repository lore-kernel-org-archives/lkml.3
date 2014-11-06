Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaKFPKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:10:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:37579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaKFPJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:09:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="627702062"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V8 14/14] perf, x86: expose LBR callstack to user space tool
Date: Thu,  6 Nov 2014 09:54:31 -0500
Message-Id: <1415285671-16894-15-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra (Intel) <peterz@infradead.org>

With LBR call stack feature enable, there are three callchain options.
Enable the 3rd callchain options LBR callstack to user space tool.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  8 --------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  8 ++++----
 include/uapi/linux/perf_event.h            | 14 ++++++--------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b4568e5..8b90803 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -517,14 +517,6 @@ struct x86_perf_task_context {
 	int lbr_stack_state;
 };
 
-enum {
-	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
-	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
-
-	PERF_SAMPLE_BRANCH_CALL_STACK =
-				1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
-};
-
 #define x86_add_quirk(func_)						\
 do {									\
 	static struct x86_pmu_quirk __quirk __initdata = {		\
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 7ed04f8..511c063 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -537,7 +537,7 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 	u64 mask = 0, v;
 	int i;
 
-	for (i = 0; i < PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE; i++) {
+	for (i = 0; i < PERF_SAMPLE_BRANCH_MAX_SHIFT; i++) {
 		if (!(br_type & (1ULL << i)))
 			continue;
 
@@ -808,7 +808,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 /*
  * Map interface branch filters onto LBR filters
  */
-static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
@@ -827,7 +827,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
 	[PERF_SAMPLE_BRANCH_COND_SHIFT]     = LBR_JCC,
 };
 
-static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
@@ -839,7 +839,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
 	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
 };
 
-static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] = {
 	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
 	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
 	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index c610960..bc22a6b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -164,6 +164,7 @@ enum perf_branch_sample_type_shift {
 	PERF_SAMPLE_BRANCH_IN_TX_SHIFT		= 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX_SHIFT		= 9, /* not in transaction */
 	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional branches */
+	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT	= 11, /* call/ret stack*/
 
 	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
 };
@@ -174,18 +175,15 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_HV		= 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
 
 	PERF_SAMPLE_BRANCH_ANY		= 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
-	PERF_SAMPLE_BRANCH_ANY_CALL	=
-				1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
-	PERF_SAMPLE_BRANCH_ANY_RETURN	=
-				1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
-	PERF_SAMPLE_BRANCH_IND_CALL	=
-				1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
-	PERF_SAMPLE_BRANCH_ABORT_TX	=
-				1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
 	PERF_SAMPLE_BRANCH_COND		= 1U << PERF_SAMPLE_BRANCH_COND_SHIFT,
 
+	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
 	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
-- 
1.8.3.2

