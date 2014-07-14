Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaGODRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:17:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:59361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655AbaGODOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="561822734"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 1/2] perf ignore LBR and extra_rsp
Date: Mon, 14 Jul 2014 12:25:56 -0700
Message-Id: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

x86, perf: Protect LBR and extra_regs against KVM lying

With -cpu host, KVM reports LBR and extra_regs support, if the host has
support.
When the guest perf driver tries to access LBR or extra_regs MSR,
it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
So check the related MSRs access right once at initialization time to avoid
the error access at runtime.

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y
(for host kernel).
And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to
trigger offcore_rsp #GP

Signed-off-by: Kan Liang <kan.liang@intel.com>

---
V2: Move the check code to initialization time.
V3: Add flag for each extra register.
    Check all LBR MSRs at initialization time.
V4: Remove lbr_msr_access.
    For LBR msr, simply set lbr_nr to 0 if check_msr failed.
    Disable all extra msrs in creation places if check_msr failed.
V5: Fix check_msr broken
    Don't check any more MSRs after the first fail
    Return error when checking fail to stop creating the event
    Remove the checking code path which never get
V6: Move extra_msr_access to struct extra_reg
    Modify and move check_msr function to perf_event_intel.c
    Other minor code changes

 arch/x86/kernel/cpu/perf_event.c              |  3 ++
 arch/x86/kernel/cpu/perf_event.h              | 20 ++++----
 arch/x86/kernel/cpu/perf_event_intel.c        | 66 ++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  4 +-
 4 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff..2879ecd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!er->extra_msr_access)
+			return -ENXIO;
 
 		reg->idx = er->idx;
 		reg->config = event->attr.config1;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..2e613b2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -295,22 +295,24 @@ struct extra_reg {
 	u64			config_mask;
 	u64			valid_mask;
 	int			idx;  /* per_xxx->regs[] reg index */
+	bool			extra_msr_access;
 };
 
-#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event = (e),		\
-	.msr = (ms),		\
-	.config_mask = (m),	\
-	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i,	\
+#define EVENT_EXTRA_REG(e, ms, m, vm, i, a) {	\
+	.event = (e),			\
+	.msr = (ms),			\
+	.config_mask = (m),		\
+	.valid_mask = (vm),		\
+	.idx = EXTRA_REG_##i,		\
+	.extra_msr_access = (a),	\
 	}
 
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx, true)
 
 #define INTEL_UEVENT_EXTRA_REG(event, msr, vm, idx) \
 	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
-			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx)
+			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx, true)
 
 #define INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(c) \
 	INTEL_UEVENT_EXTRA_REG(c, \
@@ -318,7 +320,7 @@ struct extra_reg {
 			       0xffff, \
 			       LDLAT)
 
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0, false)
 
 union perf_capabilities {
 	struct {
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..9c234d1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2173,6 +2173,40 @@ static void intel_snb_check_microcode(void)
 	}
 }
 
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static bool check_msr(unsigned long msr, u64 mask)
+{
+	u64 val_old, val_new, val_tmp;
+
+	/*
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
+	 */
+	if (rdmsrl_safe(msr, &val_old))
+		return false;
+	/*
+	 * Only chagne the bits which can be updated by wrmsrl.
+	 */
+	val_tmp = val_old ^ mask;
+	if (wrmsrl_safe(msr, val_tmp) ||
+	rdmsrl_safe(msr, &val_new))
+		return false;
+
+	if (val_new != val_tmp)
+		return false;
+
+	/* Here it's sure that the MSR can be safely accessed.
+	 * Restore the old value and return.
+	 */
+	wrmsrl(msr, val_old);
+
+	return true;
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
 	x86_pmu.check_microcode = intel_snb_check_microcode;
@@ -2262,7 +2296,8 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	int version, i;
+	struct extra_reg *er;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2565,6 +2600,35 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
+		x86_pmu.lbr_nr = 0;
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
+		      check_msr(x86_pmu.lbr_to + i, 0xffffUL)))
+			x86_pmu.lbr_nr = 0;
+	}
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		for (er = x86_pmu.extra_regs; er->msr; er++) {
+			er->extra_msr_access =
+				check_msr(er->msr, 0x1ffUL);
+			/* Disable LBR select mapping */
+			if ((er->idx == EXTRA_REG_LBR) &&
+			!er->extra_msr_access)
+				x86_pmu.lbr_sel_map = NULL;
+		}
+	}
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period = x86_pmu.cntval_mask;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 90236f0..d860e26 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -366,11 +366,11 @@
 				NHMEX_M_PMON_CTL_FLAG_MODE)
 #define MBOX_INC_SEL_EXTAR_REG(c, r) \
 		EVENT_EXTRA_REG(MBOX_INC_SEL(c), NHMEX_M0_MSR_PMU_##r, \
-				MBOX_INC_SEL_MASK, (u64)-1, NHMEX_M_##r)
+				MBOX_INC_SEL_MASK, (u64)-1, NHMEX_M_##r, true)
 #define MBOX_SET_FLAG_SEL_EXTRA_REG(c, r) \
 		EVENT_EXTRA_REG(MBOX_SET_FLAG_SEL(c), NHMEX_M0_MSR_PMU_##r, \
 				MBOX_SET_FLAG_SEL_MASK, \
-				(u64)-1, NHMEX_M_##r)
+				(u64)-1, NHMEX_M_##r, true)
 
 /* NHM-EX Rbox */
 #define NHMEX_R_MSR_GLOBAL_CTL			0xe00
-- 
1.8.3.1

