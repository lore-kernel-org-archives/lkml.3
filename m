Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaGGVYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:24:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:26529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaGGVYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,620,1400050800"; 
   d="scan'208";a="539915107"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Date: Mon,  7 Jul 2014 06:34:25 -0700
Message-Id: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
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

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y (for host kernel).
And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR #GP.
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to trigger offcore_rsp #GP

Signed-off-by: Kan Liang <kan.liang@intel.com>

V2: Move the check code to initialization time.
V3: Add flag for each extra register.
    Check all LBR MSRs at initialization time.
---
 arch/x86/kernel/cpu/perf_event.h           | 30 +++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c     | 39 +++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  4 +--
 3 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..7e286d7 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -458,12 +458,19 @@ struct x86_pmu {
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
+	/*
+	 * EXTRA REG MSR can be accessed
+	 * The extra offcore registers are completely unrelated to each other.
+	 * So it needs a flag for each extra register.
+	 * The extra offcore MSRs are MSR_OFFCORE_RSP_0 and MSR_OFFCORE_RSP_1.
+	 */
+	bool		extra_msr_access[2];
 
 	/*
 	 * Intel host/guest support (KVM)
@@ -525,6 +532,21 @@ extern u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static inline bool check_msr(unsigned long msr)
+{
+	u64 value;
+
+	if (rdmsrl_safe(msr, &value) < 0)
+		return false;
+	if (wrmsrl_safe(msr, value) < 0)
+		return false;
+	return true;
+}
+
 u64 x86_perf_event_update(struct perf_event *event);
 
 static inline unsigned int x86_pmu_config_addr(int index)
@@ -555,7 +577,11 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 {
 	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
 
-	if (hwc->extra_reg.reg)
+	if (hwc->extra_reg.reg &&
+		((hwc->extra_reg.idx == EXTRA_REG_RSP_0) ?
+			x86_pmu.extra_msr_access[0] : true) &&
+		((hwc->extra_reg.idx == EXTRA_REG_RSP_1) ?
+			x86_pmu.extra_msr_access[1] : true))
 		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
 	wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..3d18765 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2262,7 +2262,7 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	int version, i;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2565,6 +2565,43 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr) {
+		x86_pmu.lbr_msr_access = check_msr(x86_pmu.lbr_tos);
+		for (i = 0; i < x86_pmu.lbr_nr; i++) {
+			x86_pmu.lbr_msr_access &=
+				check_msr(x86_pmu.lbr_from + i);
+			x86_pmu.lbr_msr_access &=
+				check_msr(x86_pmu.lbr_to + i);
+		}
+	}
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		x86_pmu.extra_msr_access[0] =
+			check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_0].msr);
+
+		/* Not all platforms have EXTRA_REG_RSP_1 */
+		if (x86_pmu.extra_regs[EXTRA_REG_RSP_1].idx == EXTRA_REG_RSP_1)
+			x86_pmu.extra_msr_access[1] =
+			check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_1].msr);
+		/*
+		 * If there is no EXTRA_REG_RSP_1 support,
+		 * just set the flag to be true.
+		 * So it is ignored at the runtime check.
+		 */
+		else
+			x86_pmu.extra_msr_access[1] = true;
+	}
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

