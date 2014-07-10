Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaGJStJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:49:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:6585 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaGJStH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:49:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,639,1400050800"; 
   d="scan'208";a="541594220"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 1/2] perf ignore LBR and extra_regs
Date: Thu, 10 Jul 2014 03:59:43 -0700
Message-Id: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
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
V5: Fix check_msr broken
    Don't check any more MSRs after the first fail
    Return error when checking fail to stop creating the event
    Remove the checking code path which never get
---
 arch/x86/kernel/cpu/perf_event.c       |  3 +++
 arch/x86/kernel/cpu/perf_event.h       | 45 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c | 38 +++++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff..a7c5e4b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!x86_pmu.extra_msr_access[er->idx])
+			return -EFAULT;
 
 		reg->idx = er->idx;
 		reg->config = event->attr.config1;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..992c678 100644
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
@@ -525,6 +531,45 @@ extern u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static inline bool check_msr(unsigned long msr)
+{
+	u64 val_old, val_new, val_tmp;
+
+	/*
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
+	 */
+	if (rdmsrl_safe(msr, &val_old))
+		goto msr_fail;
+	/*
+	 * Only chagne it slightly,
+	 * since the higher bits of some MSRs cannot be updated by wrmsrl.
+	 * E.g. MSR_LBR_TOS
+	 */
+	val_tmp = val_old ^ 0x3UL;
+	if (wrmsrl_safe(msr, val_tmp) ||
+		rdmsrl_safe(msr, &val_new))
+		goto msr_fail;
+
+	if (val_new != val_tmp)
+		goto msr_fail;
+
+	/* Here it's sure that the MSR can be safely accessed.
+	 * Restore the old value and return.
+	 */
+	wrmsrl(msr, val_old);
+
+	return true;
+
+msr_fail:
+	return false;
+}
+
 u64 x86_perf_event_update(struct perf_event *event);
 
 static inline unsigned int x86_pmu_config_addr(int index)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..953b2b2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2262,7 +2262,8 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	int version, i;
+	struct extra_reg *er;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2565,6 +2566,41 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr) {
+		if (check_msr(x86_pmu.lbr_tos)) {
+			for (i = 0; i < x86_pmu.lbr_nr; i++) {
+				if (!(check_msr(x86_pmu.lbr_from + i) &&
+				      check_msr(x86_pmu.lbr_to + i))) {
+					x86_pmu.lbr_nr = 0;
+					break;
+				}
+			}
+		} else
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

