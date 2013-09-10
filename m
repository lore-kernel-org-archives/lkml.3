Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3IJPbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:31:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17495 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3IJPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:16 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 3/5] xen/PMU: Initialization code for Xen PMU
Date: Tue, 10 Sep 2013 11:31:48 -0400
Message-Id: <1378827110-4192-4-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map shared data structure that will hold CPU registers, VPMU context,
VCPU/PCPI IDs of the VCPU interrupted by PMU interrupt. Hypervisor
fills this information in its handler and passes it to the guest for
further processing.

Set up PMU VIRQ.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/Makefile          |   2 +-
 arch/x86/xen/pmu.c             | 122 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/pmu.h             |  12 ++++
 arch/x86/xen/smp.c             |  31 ++++++++++-
 include/xen/interface/xen.h    |   1 +
 include/xen/interface/xenpmu.h |  77 ++++++++++++++++++++++++++
 6 files changed, 243 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/xen/pmu.c
 create mode 100644 arch/x86/xen/pmu.h

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 96ab2c0..b187df5 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o platform-pci-unplug.o \
-			p2m.o
+			p2m.o pmu.o
 
 obj-$(CONFIG_EVENT_TRACING) += trace.o
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
new file mode 100644
index 0000000..da061d4
--- /dev/null
+++ b/arch/x86/xen/pmu.c
@@ -0,0 +1,122 @@
+#include <linux/types.h>
+#include <linux/interrupt.h>
+
+#include <asm/xen/hypercall.h>
+#include <xen/page.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/vcpu.h>
+#include <xen/interface/xenpmu.h>
+
+#include "xen-ops.h"
+#include "pmu.h"
+
+/* x86_pmu.handle_irq definition */
+#include <../kernel/cpu/perf_event.h>
+
+
+/* Shared page between hypervisor and domain */
+DEFINE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
+
+/* perf callbacks*/
+int xen_is_in_guest(void)
+{
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+
+	if (!xen_initial_domain() ||
+	    xenpmu_data->domain_id > DOMID_SELF || xenpmu_data->domain_id == 0)
+		return 0;
+
+	return 1;
+}
+
+static int xen_is_user_mode(void)
+{
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+	return ((xenpmu_data->regs.cs & 3) == 3);
+}
+
+static unsigned long xen_get_guest_ip(void)
+{
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+	return xenpmu_data->regs.eip;
+}
+
+static struct perf_guest_info_callbacks xen_guest_cbs = {
+	.is_in_guest            = xen_is_in_guest,
+	.is_user_mode           = xen_is_user_mode,
+	.get_guest_ip           = xen_get_guest_ip,
+};
+
+/* Convert registers from Xen's format to Linux' */
+static void xen_convert_regs(struct cpu_user_regs *xen_regs,
+			     struct pt_regs *regs)
+{
+	regs->ip = xen_regs->eip;
+	regs->cs = xen_regs->cs;
+}
+
+irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
+{
+	int ret = IRQ_NONE;
+	struct pt_regs regs;
+	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
+						  smp_processor_id());
+
+	xen_convert_regs(&xenpmu_data->regs, &regs);
+	if (x86_pmu.handle_irq(&regs))
+		ret = IRQ_HANDLED;
+
+	return ret;
+}
+
+int xen_pmu_init(int cpu)
+{
+	int ret = 0;
+	struct xenpmu_params xp;
+	unsigned long pfn;
+	struct xenpmu_data *xenpmu_data;
+
+	BUILD_BUG_ON(sizeof(struct xenpmu_data) > PAGE_SIZE);
+	xenpmu_data = vmalloc(PAGE_SIZE);
+	if (!xenpmu_data) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	pfn = vmalloc_to_pfn((char *)xenpmu_data);
+
+	xp.mfn = pfn_to_mfn(pfn);
+	xp.vcpu = cpu;
+	xp.version.maj = XENPMU_VER_MAJ;
+	xp.version.min = XENPMU_VER_MIN;
+	ret = HYPERVISOR_xenpmu_op(XENPMU_init, &xp);
+	if (ret)
+		goto fail;
+
+	per_cpu(xenpmu_shared, cpu) = xenpmu_data;
+
+	if (cpu == 0)
+		perf_register_guest_info_callbacks(&xen_guest_cbs);
+
+	return ret;
+
+fail:
+	vfree(xenpmu_data);
+	return ret;
+}
+
+void xen_pmu_finish(int cpu)
+{
+	struct xenpmu_params xp;
+
+	xp.vcpu = cpu;
+	xp.version.maj = XENPMU_VER_MAJ;
+	xp.version.min = XENPMU_VER_MIN;
+
+	(void)HYPERVISOR_xenpmu_op(XENPMU_finish, &xp);
+
+	vfree(per_cpu(xenpmu_shared, cpu));
+	per_cpu(xenpmu_shared, cpu) = NULL;
+}
diff --git a/arch/x86/xen/pmu.h b/arch/x86/xen/pmu.h
new file mode 100644
index 0000000..51de7d2
--- /dev/null
+++ b/arch/x86/xen/pmu.h
@@ -0,0 +1,12 @@
+#ifndef __XEN_PMU_H
+#define __XEN_PMU_H
+
+#include <xen/interface/xenpmu.h>
+
+irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
+int xen_pmu_init(int cpu);
+void xen_pmu_finish(int cpu);
+
+DECLARE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
+
+#endif /* __XEN_PMU_H */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index ca92754..17a88d1 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -26,6 +26,7 @@
 
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/xenpmu.h>
 
 #include <asm/xen/interface.h>
 #include <asm/xen/hypercall.h>
@@ -37,6 +38,7 @@
 #include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
+#include "pmu.h"
 
 cpumask_var_t xen_cpu_initialized_map;
 
@@ -49,6 +51,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
+static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
@@ -139,11 +142,18 @@ static void xen_smp_intr_free(unsigned int cpu)
 		kfree(per_cpu(xen_irq_work, cpu).name);
 		per_cpu(xen_irq_work, cpu).name = NULL;
 	}
+
+	if (per_cpu(xen_pmu_irq, cpu).irq >= 0) {
+		unbind_from_irqhandler(per_cpu(xen_pmu_irq, cpu).irq, NULL);
+		per_cpu(xen_pmu_irq, cpu).irq = -1;
+		kfree(per_cpu(xen_pmu_irq, cpu).name);
+		per_cpu(xen_pmu_irq, cpu).name = NULL;
+	}
 };
 static int xen_smp_intr_init(unsigned int cpu)
 {
 	int rc;
-	char *resched_name, *callfunc_name, *debug_name;
+	char *resched_name, *callfunc_name, *debug_name, *pmu_name;
 
 	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
@@ -209,6 +219,18 @@ static int xen_smp_intr_init(unsigned int cpu)
 	per_cpu(xen_irq_work, cpu).irq = rc;
 	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 
+	if (per_cpu(xenpmu_shared, cpu)) {
+		pmu_name = kasprintf(GFP_KERNEL, "pmu%d", cpu);
+		rc = bind_virq_to_irqhandler(VIRQ_XENPMU, cpu,
+					     xen_pmu_irq_handler,
+					     IRQF_PERCPU|IRQF_NOBALANCING,
+					     pmu_name, NULL);
+		if (rc < 0)
+			goto fail;
+		per_cpu(xen_pmu_irq, cpu).irq = rc;
+		per_cpu(xen_pmu_irq, cpu).name = pmu_name;
+	}
+
 	return 0;
 
  fail:
@@ -307,6 +329,9 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
+	if (xen_pmu_init(0))
+		pr_err("Could not initialize VPMU for VCPU 0\n");
+
 	if (xen_smp_intr_init(0))
 		BUG();
 
@@ -427,6 +452,9 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 		/* Just in case we booted with a single CPU. */
 		alternatives_enable_smp();
 
+	if (xen_pmu_init(cpu))
+		pr_err("Could not initialize VPMU for VCPU %u\n", cpu);
+
 	rc = xen_smp_intr_init(cpu);
 	if (rc)
 		return rc;
@@ -468,6 +496,7 @@ static void xen_cpu_die(unsigned int cpu)
 	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
+	xen_pmu_finish(cpu);
 }
 
 static void xen_play_dead(void) /* used only with HOTPLUG_CPU */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index c29d427..74eb6f3 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -81,6 +81,7 @@
 #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
 #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
 #define VIRQ_PCPU_STATE 9  /* (DOM0) PCPU state changed                   */
+#define VIRQ_XENPMU    13  /* PMC interrupt                               */
 
 /* Architecture-specific VIRQ definitions. */
 #define VIRQ_ARCH_0    16
diff --git a/include/xen/interface/xenpmu.h b/include/xen/interface/xenpmu.h
index 63c42b1..7af682d 100644
--- a/include/xen/interface/xenpmu.h
+++ b/include/xen/interface/xenpmu.h
@@ -13,6 +13,8 @@
 #define XENPMU_mode_set        1
 #define XENPMU_flags_get       2
 #define XENPMU_flags_set       3
+#define XENPMU_init            4
+#define XENPMU_finish          5
 
 /* Parameter structure for HYPERVISOR_xenpmu_op call */
 struct xenpmu_params {
@@ -24,6 +26,8 @@ struct xenpmu_params {
 		uint64_t pad;
 	};
 	uint64_t control;
+	uint64_t mfn;
+	uint64_t vcpu;
 };
 
 /* VPMU modes */
@@ -41,4 +45,77 @@ struct xenpmu_params {
 #define VPMU_FLAGS_MASK    ((uint32_t)(~VPMU_MODE_MASK))
 #define VPMU_INTEL_BTS     (1<<8) /* Ignored on AMD */
 
+
+/* AMD PMU registers and structures */
+#define F10H_NUM_COUNTERS   4
+#define F15H_NUM_COUNTERS   6
+/* To accommodate more countes in the future (e.g. NB counters) */
+#define MAX_NUM_COUNTERS    16
+struct amd_vpmu_context {
+	uint64_t counters[MAX_NUM_COUNTERS];
+	uint64_t ctrls[MAX_NUM_COUNTERS];
+	uint8_t msr_bitmap_set;
+};
+
+
+/* Intel PMU registers and structures */
+static const uint32_t core2_fix_counters_msr[] = {
+	MSR_CORE_PERF_FIXED_CTR0,
+	MSR_CORE_PERF_FIXED_CTR1,
+	MSR_CORE_PERF_FIXED_CTR2
+};
+#define VPMU_CORE2_NUM_FIXED (sizeof(core2_fix_counters_msr) / sizeof(uint32_t))
+
+/* Core 2 Non-architectual Performance Control MSRs. */
+static const uint32_t core2_ctrls_msr[] = {
+	MSR_CORE_PERF_FIXED_CTR_CTRL,
+	MSR_IA32_PEBS_ENABLE,
+	MSR_IA32_DS_AREA
+};
+#define VPMU_CORE2_NUM_CTRLS (sizeof(core2_ctrls_msr) / sizeof(uint32_t))
+
+#define VPMU_CORE2_MAX_ARCH_PMCS   16
+struct core2_pmu_enable {
+	char ds_area_enable;
+	char fixed_ctr_enable[VPMU_CORE2_NUM_FIXED];
+	char arch_pmc_enable[VPMU_CORE2_MAX_ARCH_PMCS];
+};
+
+struct arch_msr_pair {
+	uint64_t counter;
+	uint64_t control;
+};
+struct core2_vpmu_context {
+	uint64_t global_ctrl;
+	uint64_t global_ovf_ctrl;
+	uint64_t global_status;
+	uint64_t global_ovf_status;
+	uint64_t fix_counters[VPMU_CORE2_NUM_FIXED];
+	uint64_t ctrls[VPMU_CORE2_NUM_CTRLS];
+	struct arch_msr_pair arch_msr_pair[VPMU_CORE2_MAX_ARCH_PMCS];
+	struct core2_pmu_enable *pmu_enable;
+};
+
+/* Shared between hypervisor and PV domain */
+struct xenpmu_data {
+	union {
+		struct cpu_user_regs regs;
+		uint8_t pad[256];
+	};
+	uint32_t domain_id;
+	uint32_t vcpu_id;
+	uint32_t pcpu_id;
+	uint32_t pmu_flags;
+	union {
+		struct amd_vpmu_context amd;
+		struct core2_vpmu_context intel;
+#define MAX(x, y)       ((x) > (y) ? (x) : (y))
+#define MAX_CTXT_SZ     MAX(sizeof(struct amd_vpmu_context),\
+			    sizeof(struct core2_vpmu_context))
+#define PMU_PAD_SIZE    (((MAX_CTXT_SZ + 64) & ~63) + 128)
+		uint8_t pad[PMU_PAD_SIZE]; /* a bit more than necessary */
+	} pmu;
+};
+
+
 #endif /* __XEN_PUBLIC_XENPMU_H__ */
-- 
1.8.1.4

