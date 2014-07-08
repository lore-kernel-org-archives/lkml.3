Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaGIAjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:39:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:33691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaGIAjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,629,1400050800"; 
   d="scan'208";a="566995790"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Date: Tue,  8 Jul 2014 09:49:40 -0700
Message-Id: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

x86, perf: Protect LBR and extra_regs against KVM lying

With -cpu host, KVM reports LBR and extra_regs support, if the host has support.
When the guest perf driver tries to access LBR or extra_regs MSR,
it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
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
V4: Remove lbr_msr_access. For LBR msr, simply set lbr_nr to 0 if check_msr failed.
    Disable all extra msrs in creation places if check_msr failed.
---
 arch/x86/kernel/cpu/perf_event.c       |  3 +++
 arch/x86/kernel/cpu/perf_event.h       | 21 +++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c | 43 +++++++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff..f0e8022 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!x86_pmu.extra_msr_access[er->idx])
+			continue;
 
 		reg->idx = er->idx;
 		reg->config = event->attr.config1;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..85725c5 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -464,6 +464,12 @@ struct x86_pmu {
 	 */
 	struct extra_reg *extra_regs;
 	unsigned int er_flags;
+	/*
+	 * EXTRA REG MSR can be accessed
+	 * The extra registers are completely unrelated to each other.
+	 * So it needs a flag for each extra register.
+	 */
+	bool		extra_msr_access[EXTRA_REG_MAX];
 
 	/*
 	 * Intel host/guest support (KVM)
@@ -525,6 +531,21 @@ extern u64 __read_mostly hw_cache_extra_regs
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
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..2be44be 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1471,11 +1471,14 @@ static void intel_fixup_er(struct perf_event *event, int idx)
 {
 	event->hw.extra_reg.idx = idx;
 
-	if (idx == EXTRA_REG_RSP_0) {
+	/* The extra_reg doesn't update if msrs cannot be accessed safely */
+	if ((idx == EXTRA_REG_RSP_0) &&
+			x86_pmu.extra_msr_access[EXTRA_REG_RSP_0]) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
 		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_0].event;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
-	} else if (idx == EXTRA_REG_RSP_1) {
+	} else if ((idx == EXTRA_REG_RSP_1) &&
+			x86_pmu.extra_msr_access[EXTRA_REG_RSP_1]) {
 		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
 		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_1].event;
 		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
@@ -2262,7 +2265,9 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	int version, i;
+	struct extra_reg *er;
+	bool access;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2565,6 +2570,38 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr) {
+		access = check_msr(x86_pmu.lbr_tos);
+		for (i = 0; i < x86_pmu.lbr_nr; i++) {
+			access &= check_msr(x86_pmu.lbr_from + i);
+			access &= check_msr(x86_pmu.lbr_to + i);
+		}
+		if (!access)
+			x86_pmu.lbr_nr = 0;
+	}
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		memset(x86_pmu.extra_msr_access,
+			true, sizeof(bool) * EXTRA_REG_MAX);
+		for (er = x86_pmu.extra_regs; er->msr; er++) {
+			x86_pmu.extra_msr_access[er->idx] =
+				check_msr(er->msr);
+		}
+		/* Disable LBR select mapping */
+		if (!x86_pmu.extra_msr_access[EXTRA_REG_LBR])
+			x86_pmu.lbr_sel_map = NULL;
+	}
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period = x86_pmu.cntval_mask;
-- 
1.8.3.1

