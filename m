Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaGCCES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:04:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:51127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaGCCEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="567593300"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org,
        Kan Liang <kan.liang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Date: Wed,  2 Jul 2014 11:14:13 -0700
Message-Id: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

x86, perf: Protect LBR and offcore rsp against KVM lying

With -cpu host, KVM reports LBR and offcore support, if the host has support.
When the guest perf driver tries to access LBR or offcore_rsp MSR,
it #GPs all MSR accesses,since KVM doesn't handle LBR and offcore support.
So check the related MSRs access right once at initialization time to avoid the error access at runtime.

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y.
And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n.
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR #GP.
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to trigger offcore_rsp #GP

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>

V2: Move the check code to initialization time.
---
 arch/x86/kernel/cpu/perf_event.h           | 19 +++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c     |  7 +++++++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  4 ++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..5d977b2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -458,12 +458,13 @@ struct x86_pmu {
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
-
+	bool		lbr_msr_access;		   /* LBR MSR can be accessed */
 	/*
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
 	unsigned int er_flags;
+	bool		extra_msr_access;	   /* EXTRA REG MSR can be accessed */
 
 	/*
 	 * Intel host/guest support (KVM)
@@ -525,6 +526,20 @@ extern u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+/* 
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static inline bool test_msr_access(unsigned long msr)
+{
+	u64 value;
+	if (rdmsrl_safe(msr, &value) < 0)
+		return false;
+	if (wrmsrl_safe(msr, value) < 0)
+		return false;
+	return true;
+}
+
 u64 x86_perf_event_update(struct perf_event *event);
 
 static inline unsigned int x86_pmu_config_addr(int index)
@@ -555,7 +570,7 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 {
 	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
 
-	if (hwc->extra_reg.reg)
+	if (hwc->extra_reg.reg && x86_pmu.extra_msr_access)
 		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
 	wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..8011d42 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2565,6 +2565,13 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Access LBR MSR may cause #GP under certain circumstances. E.g. KVM doesn't support LBR MSR */
+	if (x86_pmu.lbr_nr)
+		x86_pmu.lbr_msr_access = test_msr_access(x86_pmu.lbr_tos) & test_msr_access(x86_pmu.lbr_from);
+	/* Access extra MSR may cause #GP under certain circumstances. E.g. KVM doesn't support offcore event */
+	if (x86_pmu.extra_regs)
+		x86_pmu.extra_msr_access = test_msr_access(x86_pmu.extra_regs->msr);
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period = x86_pmu.cntval_mask;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9dd2459..9508d1e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -172,7 +172,7 @@ static void intel_pmu_lbr_reset_64(void)
 
 void intel_pmu_lbr_reset(void)
 {
-	if (!x86_pmu.lbr_nr)
+	if (!x86_pmu.lbr_nr  || !x86_pmu.lbr_msr_access)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
@@ -334,7 +334,7 @@ void intel_pmu_lbr_read(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!cpuc->lbr_users)
+	if (!cpuc->lbr_users || !x86_pmu.lbr_msr_access)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
-- 
1.8.3.1

