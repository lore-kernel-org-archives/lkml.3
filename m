Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3IJPc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:32:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23571 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3IJPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:12 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 4/5] xen/PMU: Add support for PMU registes on PV guests
Date: Tue, 10 Sep 2013 11:31:49 -0400
Message-Id: <1378827110-4192-5-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU emulation code: MSR caching in PMU context and LVTPC APIC
handling. (Portions of this code are taken from Xen's VPMU
implementation)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/enlighten.c       |  27 +++-
 arch/x86/xen/pmu.c             | 289 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/pmu.h             |   3 +
 include/xen/interface/xenpmu.h |   5 +
 4 files changed, 317 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 193097e..2512bd3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -82,6 +82,7 @@
 #include "mmu.h"
 #include "smp.h"
 #include "multicalls.h"
+#include "pmu.h"
 
 EXPORT_SYMBOL_GPL(hypercall_page);
 
@@ -960,6 +961,11 @@ static u32 xen_apic_read(u32 reg)
 
 static void xen_apic_write(u32 reg, u32 val)
 {
+	if (reg == APIC_LVTPC) {
+		(void)pmu_apic_update(reg);
+		return;
+	}
+
 	/* Warn to see if there's any stray references */
 	WARN_ON(1);
 }
@@ -1064,11 +1070,20 @@ static inline void xen_write_cr8(unsigned long val)
 	BUG_ON(val);
 }
 #endif
-static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
+
+static u64 xen_read_msr_safe(unsigned int msr, int *err)
 {
-	int ret;
+	u64 val;
 
-	ret = 0;
+	if (pmu_msr_read(msr, &val, err))
+		return val;
+
+	return native_read_msr_safe(msr, err);
+}
+
+static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
+{
+	int ret = 0;
 
 	switch (msr) {
 #ifdef CONFIG_X86_64
@@ -1102,10 +1117,10 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 		if (smp_processor_id() == 0)
 			xen_set_pat(((u64)high << 32) | low);
 		break;
+	}
 
-	default:
+	if (!pmu_msr_write(msr, low, high, &ret))
 		ret = native_write_msr_safe(msr, low, high);
-	}
 
 	return ret;
 }
@@ -1239,7 +1254,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 
 	.wbinvd = native_wbinvd,
 
-	.read_msr = native_read_msr_safe,
+	.read_msr = xen_read_msr_safe,
 	.write_msr = xen_write_msr_safe,
 
 	.read_tsc = native_read_tsc,
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index da061d4..d8b059b 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -17,6 +17,291 @@
 /* Shared page between hypervisor and domain */
 DEFINE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
 
+/* PMU register caching */
+
+/* AMD PMU */
+static __read_mostly uint32_t amd_counters_base;
+static __read_mostly uint32_t amd_ctrls_base;
+static __read_mostly int amd_msr_step;
+static __read_mostly int k7_counters_mirrored;
+static __read_mostly int amd_num_counters;
+
+/* Intel PMU */
+#define MSR_TYPE_COUNTER            0
+#define MSR_TYPE_CTRL               1
+#define MSR_TYPE_GLOBAL             2
+#define MSR_TYPE_ARCH_COUNTER       3
+#define MSR_TYPE_ARCH_CTRL          4
+
+#define PMU_GENERAL_NR_SHIFT        8  /* Number of general pmu registers */
+#define PMU_GENERAL_NR_BITS         8  /* 8 bits 8..15 */
+#define PMU_GENERAL_NR_MASK         (((1 << PMU_GENERAL_NR_BITS) - 1) \
+				     << PMU_GENERAL_NR_SHIFT)
+
+static __read_mostly int intel_num_counters;
+
+
+static void xen_pmu_arch_init(void)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+
+		switch (boot_cpu_data.x86) {
+		case 0x15:
+			amd_num_counters = F15H_NUM_COUNTERS;
+			amd_counters_base = MSR_F15H_PERF_CTR;
+			amd_ctrls_base = MSR_F15H_PERF_CTL;
+			amd_msr_step = 2;
+			k7_counters_mirrored = 1;
+			break;
+		case 0x10:
+		case 0x12:
+		case 0x14:
+		case 0x16:
+		default:
+			amd_num_counters = F10H_NUM_COUNTERS;
+			amd_counters_base = MSR_K7_PERFCTR0;
+			amd_ctrls_base = MSR_K7_EVNTSEL0;
+			amd_msr_step = 1;
+			k7_counters_mirrored = 0;
+			break;
+		}
+	} else {
+		uint32_t eax = cpuid_eax(0xa);
+
+		intel_num_counters = (eax & PMU_GENERAL_NR_MASK) >>
+			PMU_GENERAL_NR_SHIFT;
+	}
+}
+
+static inline uint32_t get_fam15h_addr(u32 addr)
+{
+	switch (addr) {
+	case MSR_K7_PERFCTR0:
+	case MSR_K7_PERFCTR1:
+	case MSR_K7_PERFCTR2:
+	case MSR_K7_PERFCTR3:
+		return MSR_F15H_PERF_CTR + (addr - MSR_K7_PERFCTR0);
+	case MSR_K7_EVNTSEL0:
+	case MSR_K7_EVNTSEL1:
+	case MSR_K7_EVNTSEL2:
+	case MSR_K7_EVNTSEL3:
+		return MSR_F15H_PERF_CTL + (addr - MSR_K7_EVNTSEL0);
+	default:
+		break;
+	}
+
+	return addr;
+}
+
+static inline bool is_amd_pmu_msr(unsigned int msr)
+{
+	if ((msr < MSR_F15H_PERF_CTL ||
+	     msr > MSR_F15H_PERF_CTR + amd_num_counters) &&
+	    (msr < MSR_K7_EVNTSEL0 ||
+	     msr > MSR_K7_PERFCTR0 + amd_num_counters))
+		return true;
+
+	return false;
+}
+
+static bool is_core2_pmu_msr(u32 msr_index, int *type, int *index)
+{
+	int i;
+
+	for (i = 0; i < VPMU_CORE2_NUM_FIXED; i++) {
+		if (core2_fix_counters_msr[i] == msr_index) {
+			*type = MSR_TYPE_COUNTER;
+			*index = i;
+			return true;
+		}
+	}
+
+	for (i = 0; i < VPMU_CORE2_NUM_CTRLS; i++) {
+		if (core2_ctrls_msr[i] == msr_index) {
+			*type = MSR_TYPE_CTRL;
+			*index = i;
+			return true;
+		}
+	}
+
+	if ((msr_index == MSR_CORE_PERF_GLOBAL_CTRL) ||
+	    (msr_index == MSR_CORE_PERF_GLOBAL_STATUS) ||
+	    (msr_index == MSR_CORE_PERF_GLOBAL_OVF_CTRL)) {
+		*type = MSR_TYPE_GLOBAL;
+		return true;
+	}
+
+	if ((msr_index >= MSR_IA32_PERFCTR0) &&
+	     (msr_index < (MSR_IA32_PERFCTR0 + intel_num_counters))) {
+		*type = MSR_TYPE_ARCH_COUNTER;
+		*index = msr_index - MSR_IA32_PERFCTR0;
+		return true;
+	}
+
+	if ((msr_index >= MSR_P6_EVNTSEL0) &&
+	     (msr_index < (MSR_P6_EVNTSEL0 + intel_num_counters))) {
+		*type = MSR_TYPE_ARCH_CTRL;
+		*index = msr_index - MSR_P6_EVNTSEL0;
+		return true;
+	}
+
+	return false;
+}
+
+int xen_intel_pmu_rw(unsigned int msr, u64 *val, int type,
+		     int index, bool is_read)
+{
+	uint64_t *reg = NULL;
+	struct core2_vpmu_context *ctxt;
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+
+	if (!xenpmu_data)
+		return 1;
+
+	if (!(xenpmu_data->pmu_flags & PMU_CACHED)) /* No caching needed */
+		return 1;
+
+	ctxt = &xenpmu_data->pmu.intel;
+
+	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		reg = &ctxt->global_ovf_ctrl;
+		break;
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+		reg = &ctxt->global_status;
+		break;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		reg = &ctxt->global_ctrl;
+		break;
+	case MSR_CORE_PERF_FIXED_CTR_CTRL:
+		reg = &ctxt->ctrls[0];
+		break;
+	default:
+		switch (type) {
+		case MSR_TYPE_COUNTER:
+			reg = &ctxt->fix_counters[index];
+			break;
+		case MSR_TYPE_ARCH_COUNTER:
+			reg = &ctxt->arch_msr_pair[index].counter;
+			break;
+		case MSR_TYPE_ARCH_CTRL:
+			reg = &ctxt->arch_msr_pair[index].control;
+			break;
+		default:
+			return 1;
+		}
+	}
+
+	if (reg) {
+		if (is_read)
+			*val = *reg;
+		else {
+			*reg = *val;
+
+			if (msr == MSR_CORE_PERF_GLOBAL_OVF_CTRL)
+				ctxt->global_status &= (~(*val));
+		}
+		return 0;
+	}
+
+	return 1;
+}
+
+int xen_amd_pmu_rw(unsigned int msr, u64 *val, bool is_read)
+{
+	uint64_t *reg = NULL;
+	int i, off = 0;
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+
+	if (!xenpmu_data)
+		return 1;
+
+	if (!(xenpmu_data->pmu_flags & PMU_CACHED)) /* No caching needed */
+		return 1;
+
+	if (k7_counters_mirrored &&
+	    ((msr >= MSR_K7_EVNTSEL0) && (msr <= MSR_K7_PERFCTR3)))
+		msr = get_fam15h_addr(msr);
+
+	for (i = 0; i < amd_num_counters; i++) {
+		if (msr == amd_ctrls_base + off) {
+			reg = &xenpmu_data->pmu.amd.ctrls[i];
+			break;
+		} else if (msr == amd_counters_base + off) {
+			reg = &xenpmu_data->pmu.amd.counters[i];
+			break;
+		}
+		off += amd_msr_step;
+	}
+
+	if (reg) {
+		if (is_read)
+			*val = *reg;
+		else
+			*reg = *val;
+		return 0;
+	}
+	return 1;
+}
+
+int pmu_msr_read(unsigned int msr, uint64_t *val, int *err)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+		if (is_amd_pmu_msr(msr)) {
+			if (xen_amd_pmu_rw(msr, val, true))
+				*val = native_read_msr_safe(msr, err);
+			return 1;
+		}
+	} else {
+		int type, index;
+		if (is_core2_pmu_msr(msr, &type, &index)) {
+			if (xen_intel_pmu_rw(msr, val, type, index, true))
+				*val = native_read_msr_safe(msr, err);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+int pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err)
+{
+	uint64_t val = ((uint64_t)high << 32) | low;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+		if (is_amd_pmu_msr(msr)) {
+			if (xen_amd_pmu_rw(msr, &val, false))
+				*err = native_write_msr_safe(msr, low, high);
+			return 1;
+		}
+	} else {
+		int type, index;
+
+		if (is_core2_pmu_msr(msr, &type, &index)) {
+			if (xen_intel_pmu_rw(msr, &val, type, index, false))
+				*err = native_write_msr_safe(msr, low, high);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+int pmu_apic_update(uint64_t reg)
+{
+	int ret;
+	struct xenpmu_params xp;
+
+	xp.lvtpc = reg;
+	xp.version.maj = XENPMU_VER_MAJ;
+	xp.version.min = XENPMU_VER_MIN;
+	ret = HYPERVISOR_xenpmu_op(XENPMU_lvtpc_set, &xp);
+
+	return ret;
+}
+
 /* perf callbacks*/
 int xen_is_in_guest(void)
 {
@@ -97,8 +382,10 @@ int xen_pmu_init(int cpu)
 
 	per_cpu(xenpmu_shared, cpu) = xenpmu_data;
 
-	if (cpu == 0)
+	if (cpu == 0) {
 		perf_register_guest_info_callbacks(&xen_guest_cbs);
+		xen_pmu_arch_init();
+	}
 
 	return ret;
 
diff --git a/arch/x86/xen/pmu.h b/arch/x86/xen/pmu.h
index 51de7d2..adc2b5e 100644
--- a/arch/x86/xen/pmu.h
+++ b/arch/x86/xen/pmu.h
@@ -6,6 +6,9 @@
 irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
 int xen_pmu_init(int cpu);
 void xen_pmu_finish(int cpu);
+int pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
+int pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
+int pmu_apic_update(uint64_t reg);
 
 DECLARE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
 
diff --git a/include/xen/interface/xenpmu.h b/include/xen/interface/xenpmu.h
index 7af682d..16fe1ab 100644
--- a/include/xen/interface/xenpmu.h
+++ b/include/xen/interface/xenpmu.h
@@ -15,6 +15,7 @@
 #define XENPMU_flags_set       3
 #define XENPMU_init            4
 #define XENPMU_finish          5
+#define XENPMU_lvtpc_set       6
 
 /* Parameter structure for HYPERVISOR_xenpmu_op call */
 struct xenpmu_params {
@@ -28,6 +29,7 @@ struct xenpmu_params {
 	uint64_t control;
 	uint64_t mfn;
 	uint64_t vcpu;
+	uint64_t lvtpc;
 };
 
 /* VPMU modes */
@@ -96,6 +98,9 @@ struct core2_vpmu_context {
 	struct core2_pmu_enable *pmu_enable;
 };
 
+/* PMU flags */
+#define PMU_CACHED        1
+
 /* Shared between hypervisor and PV domain */
 struct xenpmu_data {
 	union {
-- 
1.8.1.4

