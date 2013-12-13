Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3LMCKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:10:44 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33346 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3LMCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:36 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 02/14] xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus.
Date: Thu, 12 Dec 2013 21:10:09 -0500
Message-Id: <1386900621-27528-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

Make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
as PVH only needs to send down gdtaddr and gdtsz in the
vcpu_guest_context structure..

For interrupts, PVH uses native_irq_ops so we can skip most of the
PV ones. In the future we can support the pirq_eoi_map..
Also VCPU hotplug is currently not available for PVH.

For events (and IRQs) we follow what PVHVM does - so use callback
vector.  Lastly, for XenBus we use the same logic that is used in
the PVHVM case.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
[v2: Rebased it]
[v3: Move 64-bit ifdef and based on Stefan add extra comments.]
[v4: Rebased it once more]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Conflicts:
	arch/x86/xen/p2m.c
	arch/x86/xen/smp.c
[Conflict due to xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
squashing PV and HVM code together.]
---
 arch/x86/include/asm/xen/interface.h |   11 +++++++++-
 arch/x86/xen/irq.c                   |    5 +++-
 arch/x86/xen/p2m.c                   |    4 ++-
 arch/x86/xen/smp.c                   |   38 +++++++++++++++++++++++++---------
 drivers/xen/cpu_hotplug.c            |    4 ++-
 drivers/xen/events.c                 |    9 +++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 7 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index fd9cb76..20e738a 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -145,7 +145,16 @@ struct vcpu_guest_context {
     struct cpu_user_regs user_regs;         /* User-level CPU registers     */
     struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
     unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
-    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
+    union {
+	struct {
+		/* PV: GDT (machine frames, # ents).*/
+		unsigned long gdt_frames[16], gdt_ents;
+	} pv;
+	struct {
+		/* PVH: GDTR addr and size */
+		unsigned long gdtaddr, gdtsz;
+	} pvh;
+    } u;
     unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
     /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
     unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 0da7f86..4f7f351 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/features.h>
 #include <xen/events.h>
 
 #include <asm/xen/hypercall.h>
@@ -128,6 +129,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
 
 void __init xen_init_irq_ops(void)
 {
-	pv_irq_ops = xen_irq_ops;
+	/* For PVH we use default pv_irq_ops settings */
+	if (!xen_feature(XENFEAT_hvm_callback_vector))
+		pv_irq_ops = xen_irq_ops;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 }
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 2ae8699..93655e8 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -800,8 +800,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	unsigned topidx, mididx, idx;
 
 	/* don't track P2M changes in autotranslate guests */
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
 		return true;
+	}
 
 	if (unlikely(pfn >= MAX_P2M_PFN)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c36b325..afffa07 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -73,9 +73,11 @@ static void cpu_bringup(void)
 	touch_softlockup_watchdog();
 	preempt_disable();
 
-	xen_enable_sysenter();
-	xen_enable_syscall();
-
+	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
+	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
+		xen_enable_sysenter();
+		xen_enable_syscall();
+	}
 	cpu = smp_processor_id();
 	smp_store_cpu_info(cpu);
 	cpu_data(cpu).x86_max_cores = 1;
@@ -274,9 +276,10 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	native_smp_prepare_boot_cpu();
 
 	if (xen_pv_domain()) {
-		/* We've switched to the "real" per-cpu gdt, so make sure the
-		   old memory can be recycled */
-		make_lowmem_page_readwrite(xen_initial_gdt);
+		if (!xen_feature(XENFEAT_writable_page_tables))
+			/* We've switched to the "real" per-cpu gdt, so make sure the
+			 * old memory can be recycled */
+			make_lowmem_page_readwrite(xen_initial_gdt);
 
 #ifdef CONFIG_X86_32
 		/*
@@ -286,7 +289,6 @@ static void __init xen_smp_prepare_boot_cpu(void)
 		loadsegment(ds, __USER_DS);
 		loadsegment(es, __USER_DS);
 #endif
-
 		xen_filter_cpu_maps();
 		xen_setup_vcpu_info_placement();
 	}
@@ -372,7 +374,23 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
-	{
+	if (xen_feature(XENFEAT_auto_translated_physmap) &&
+	    xen_feature(XENFEAT_supervisor_mode_kernel)) {
+		/* Note: PVH is not supported on x86_32. */
+#ifdef CONFIG_X86_64
+		ctxt->user_regs.ds = __KERNEL_DS;
+		ctxt->user_regs.es = 0;
+		ctxt->user_regs.gs = 0;
+
+		/* GUEST_GDTR_BASE and */
+		ctxt->u.pvh.gdtaddr = (unsigned long)gdt;
+		/* GUEST_GDTR_LIMIT in the VMCS. */
+		ctxt->u.pvh.gdtsz = (unsigned long)(GDT_SIZE - 1);
+
+		ctxt->gs_base_user = (unsigned long)
+					per_cpu(irq_stack_union.gs_base, cpu);
+#endif
+	} else {
 		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 		ctxt->user_regs.ds = __USER_DS;
 		ctxt->user_regs.es = __USER_DS;
@@ -387,8 +405,8 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 		make_lowmem_page_readonly(gdt);
 		make_lowmem_page_readonly(mfn_to_virt(gdt_mfn));
 
-		ctxt->gdt_frames[0] = gdt_mfn;
-		ctxt->gdt_ents      = GDT_ENTRIES;
+		ctxt->u.pv.gdt_frames[0] = gdt_mfn;
+		ctxt->u.pv.gdt_ents      = GDT_ENTRIES;
 
 		ctxt->kernel_ss = __KERNEL_DS;
 		ctxt->kernel_sp = idle->thread.sp0;
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index cc6513a..cbb02af 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -4,6 +4,7 @@
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
+#include <xen/features.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/cpu.h>
@@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
 	static struct notifier_block xsn_cpu = {
 		.notifier_call = setup_cpu_watcher };
 
-	if (!xen_pv_domain())
+	/* PVH TBD/FIXME: future work */
+	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENODEV;
 
 	register_xenstore_notifier(&xsn_cpu);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4035e83..38d56a2 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1862,7 +1862,7 @@ int xen_set_callback_via(uint64_t via)
 }
 EXPORT_SYMBOL_GPL(xen_set_callback_via);
 
-#ifdef CONFIG_XEN_PVHVM
+#ifdef CONFIG_X86
 /* Vector callbacks are better than PCI interrupts to receive event
  * channel notifications because we can receive vector callbacks on any
  * vcpu and we don't need PCI support or APIC interactions. */
@@ -1922,6 +1922,13 @@ void __init xen_init_IRQ(void)
 		if (xen_initial_domain())
 			pci_xen_initial_domain();
 
+		if (xen_feature(XENFEAT_hvm_callback_vector)) {
+			xen_callback_vector();
+			return;
+		}
+
+		/* PVH: TBD/FIXME: debug and fix eio map to work with pvh */
+
 		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 		eoi_gmfn.gmfn = virt_to_mfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index ec097d6..7f7c454 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -45,6 +45,7 @@
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/xen.h>
+#include <xen/features.h>
 
 #include "xenbus_probe.h"
 
@@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
 
 void __init xenbus_ring_ops_init(void)
 {
-	if (xen_pv_domain())
+	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
 		ring_ops = &ring_ops_pv;
 	else
 		ring_ops = &ring_ops_hvm;
-- 
1.7.7.6

