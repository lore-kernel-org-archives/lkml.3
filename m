Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaCQF6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:58:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:37734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285AbaCQF63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:58:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,667,1389772800"; 
   d="scan'208";a="473898247"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 01/16] perf, x86: Reduce lbr_sel_map size
Date: Mon, 17 Mar 2014 13:57:21 +0800
Message-Id: <1395035856-15411-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
References: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index of lbr_sel_map is bit value of perf branch_sample_type.
PERF_SAMPLE_BRANCH_MAX is 1024 at present, so each lbr_sel_map uses
4096 bytes. By using bit shift as index, we can reduce lbr_sel_map
size to 40 bytes. This patch defines 'bit shift' for branch types,
and use 'bit shift' to define lbr_sel_maps.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  4 +++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 50 ++++++++++++++----------------
 include/uapi/linux/perf_event.h            | 42 +++++++++++++++++--------
 3 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..b58c0ba 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -471,6 +471,10 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+enum {
+	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
+};
+
 #define x86_add_quirk(func_)						\
 do {									\
 	static struct x86_pmu_quirk __quirk __initdata = {		\
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d82d155..1ae2ec5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -69,10 +69,6 @@ static enum {
 #define LBR_FROM_FLAG_IN_TX    (1ULL << 62)
 #define LBR_FROM_FLAG_ABORT    (1ULL << 61)
 
-#define for_each_branch_sample_type(x) \
-	for ((x) = PERF_SAMPLE_BRANCH_USER; \
-	     (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
-
 /*
  * x86control flow change classification
  * x86control flow changes include branches, interrupts, traps, faults
@@ -400,14 +396,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 {
 	struct hw_perf_event_extra *reg;
 	u64 br_type = event->attr.branch_sample_type;
-	u64 mask = 0, m;
-	u64 v;
+	u64 mask = 0, v;
+	int i;
 
-	for_each_branch_sample_type(m) {
-		if (!(br_type & m))
+	for (i = 0; i < PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE; i++) {
+		if (!(br_type & (1ULL << i)))
 			continue;
 
-		v = x86_pmu.lbr_sel_map[m];
+		v = x86_pmu.lbr_sel_map[i];
 		if (v == LBR_NOT_SUPP)
 			return -EOPNOTSUPP;
 
@@ -662,33 +658,33 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 /*
  * Map interface branch filters onto LBR filters
  */
-static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
-	[PERF_SAMPLE_BRANCH_ANY]	= LBR_ANY,
-	[PERF_SAMPLE_BRANCH_USER]	= LBR_USER,
-	[PERF_SAMPLE_BRANCH_KERNEL]	= LBR_KERNEL,
-	[PERF_SAMPLE_BRANCH_HV]		= LBR_IGN,
-	[PERF_SAMPLE_BRANCH_ANY_RETURN]	= LBR_RETURN | LBR_REL_JMP
-					| LBR_IND_JMP | LBR_FAR,
+static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV_SHIFT]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]	= LBR_RETURN | LBR_REL_JMP
+						| LBR_IND_JMP | LBR_FAR,
 	/*
 	 * NHM/WSM erratum: must include REL_JMP+IND_JMP to get CALL branches
 	 */
-	[PERF_SAMPLE_BRANCH_ANY_CALL] =
+	[PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT] =
 	 LBR_REL_CALL | LBR_IND_CALL | LBR_REL_JMP | LBR_IND_JMP | LBR_FAR,
 	/*
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
-	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_IND_CALL_SHIFT] = LBR_IND_CALL | LBR_IND_JMP,
 };
 
-static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
-	[PERF_SAMPLE_BRANCH_ANY]	= LBR_ANY,
-	[PERF_SAMPLE_BRANCH_USER]	= LBR_USER,
-	[PERF_SAMPLE_BRANCH_KERNEL]	= LBR_KERNEL,
-	[PERF_SAMPLE_BRANCH_HV]		= LBR_IGN,
-	[PERF_SAMPLE_BRANCH_ANY_RETURN]	= LBR_RETURN | LBR_FAR,
-	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
-					| LBR_FAR,
-	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV_SHIFT]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]	= LBR_RETURN | LBR_FAR,
+	[PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT]	= LBR_REL_CALL | LBR_IND_CALL
+						| LBR_FAR,
+	[PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]	= LBR_IND_CALL,
 };
 
 /* core */
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..95e7022 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -151,20 +151,36 @@ enum perf_event_sample_format {
  * The branch types can be combined, however BRANCH_ANY covers all types
  * of branches and therefore it supersedes all the other types.
  */
+enum perf_branch_sample_type_shift {
+	PERF_SAMPLE_BRANCH_USER_SHIFT		= 0, /* user branches */
+	PERF_SAMPLE_BRANCH_KERNEL_SHIFT		= 1, /* kernel branches */
+	PERF_SAMPLE_BRANCH_HV_SHIFT		= 2, /* hypervisor branches */
+
+	PERF_SAMPLE_BRANCH_ANY_SHIFT		= 3, /* any branch types */
+	PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT	= 4, /* any call branch */
+	PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT	= 5, /* any return branch */
+	PERF_SAMPLE_BRANCH_IND_CALL_SHIFT	= 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT	= 7, /* transaction aborts */
+	PERF_SAMPLE_BRANCH_IN_TX_SHIFT		= 8, /* in transaction */
+	PERF_SAMPLE_BRANCH_NO_TX_SHIFT		= 9, /* not in transaction */
+
+	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
+};
+
 enum perf_branch_sample_type {
-	PERF_SAMPLE_BRANCH_USER		= 1U << 0, /* user branches */
-	PERF_SAMPLE_BRANCH_KERNEL	= 1U << 1, /* kernel branches */
-	PERF_SAMPLE_BRANCH_HV		= 1U << 2, /* hypervisor branches */
-
-	PERF_SAMPLE_BRANCH_ANY		= 1U << 3, /* any branch types */
-	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
-	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
-	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
-	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
-	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
-	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
-
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_USER         = 1U << PERF_SAMPLE_BRANCH_USER_SHIFT,
+	PERF_SAMPLE_BRANCH_KERNEL       = 1U << PERF_SAMPLE_BRANCH_KERNEL_SHIFT,
+	PERF_SAMPLE_BRANCH_HV           = 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
+
+	PERF_SAMPLE_BRANCH_ANY          = 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_CALL     = 1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ABORT_TX     = 1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_IN_TX        = 1U << PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_NO_TX        = 1U << PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
+
+	PERF_SAMPLE_BRANCH_MAX          = 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.8.5.3

