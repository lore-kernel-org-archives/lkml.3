Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJSWFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:05:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaJSWF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644443"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 01/17] perf, x86: Reduce lbr_sel_map size
Date: Sun, 19 Oct 2014 17:54:56 -0400
Message-Id: <1413755712-8259-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index of lbr_sel_map is bit value of perf branch_sample_type.
PERF_SAMPLE_BRANCH_MAX is 1024 at present, so each lbr_sel_map uses
4096 bytes. By using bit shift as index, we can reduce lbr_sel_map
size to 40 bytes. This patch defines 'bit shift' for branch types,
and use 'bit shift' to define lbr_sel_maps.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  4 +++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 54 ++++++++++++++----------------
 include/uapi/linux/perf_event.h            | 49 +++++++++++++++++++--------
 3 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d98a34d..2d017fa 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -510,6 +510,10 @@ struct x86_pmu {
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
index 4af1061..7344f05 100644
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
@@ -403,14 +399,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
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
 
@@ -665,35 +661,35 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
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
-	[PERF_SAMPLE_BRANCH_COND]     = LBR_JCC,
+	[PERF_SAMPLE_BRANCH_IND_CALL_SHIFT] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_COND_SHIFT]     = LBR_JCC,
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
-	[PERF_SAMPLE_BRANCH_COND]       = LBR_JCC,
+static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
+	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV_SHIFT]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT]	= LBR_RETURN | LBR_FAR,
+	[PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT]	= LBR_REL_CALL | LBR_IND_CALL
+						| LBR_FAR,
+	[PERF_SAMPLE_BRANCH_IND_CALL_SHIFT]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
 };
 
 /* core */
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de2..7d41d59 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -151,21 +151,42 @@ enum perf_event_sample_format {
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
+	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional branches */
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
-	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
-
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
+	PERF_SAMPLE_BRANCH_USER		= 1U << PERF_SAMPLE_BRANCH_USER_SHIFT,
+	PERF_SAMPLE_BRANCH_KERNEL	= 1U << PERF_SAMPLE_BRANCH_KERNEL_SHIFT,
+	PERF_SAMPLE_BRANCH_HV		= 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
+
+	PERF_SAMPLE_BRANCH_ANY		= 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_CALL	=
+				1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_RETURN	=
+				1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_CALL	=
+				1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ABORT_TX	=
+				1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_IN_TX	= 1U << PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_NO_TX	= 1U << PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_COND		= 1U << PERF_SAMPLE_BRANCH_COND_SHIFT,
+
+	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.8.3.2

