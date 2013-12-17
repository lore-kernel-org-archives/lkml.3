Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3LQU4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:56:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3LQUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 07/12] xen/pvh: Secondary VCPU bringup (non-bootup CPUs)
Date: Tue, 17 Dec 2013 15:51:38 -0500
Message-Id: <1387313503-31362-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

The VCPU bringup protocol follows the PV with certain twists.
>From xen/include/public/arch-x86/xen.h:

Also note that when calling DOMCTL_setvcpucontext and VCPU_initialise
for HVM and PVH guests, not all information in this structure is updated:

 - For HVM guests, the structures read include: fpu_ctxt (if
 VGCT_I387_VALID is set), flags, user_regs, debugreg[*]

 - PVH guests are the same as HVM guests, but additionally use ctrlreg[3] to
 set cr3. All other fields not used should be set to 0.

This is what we do. We piggyback on the 'xen_setup_gdt' - but modify
a bit - we need to call 'load_percpu_segment' so that 'switch_to_new_gdt'
can load per-cpu data-structures. It has no effect on the VCPU0.

We also piggyback on the %rdi register to pass in the CPU number - so
that when we bootup a new CPU, the cpu_bringup_and_idle will have
passed as the first parameter the CPU number (via %rdi for 64-bit).

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |  7 ++++---
 arch/x86/xen/smp.c       | 49 ++++++++++++++++++++++++++++++++----------------
 arch/x86/xen/xen-ops.h   |  1 +
 3 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0d13652..e420613 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1413,13 +1413,14 @@ static void __init xen_boot_params_init_edd(void)
  * we do this, we have to be careful not to call any stack-protected
  * function, which is most of the kernel.
  */
-static void __init xen_setup_gdt(void)
+void xen_setup_gdt(int cpu)
 {
 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
 #ifdef CONFIG_X86_64
 		unsigned long dummy;
 
-		switch_to_new_gdt(0); /* GDT and GS set */
+		load_percpu_segment(cpu); /* We need to access per-cpu area */
+		switch_to_new_gdt(cpu); /* GDT and GS set */
 
 		/* We are switching of the Xen provided GDT to our HVM mode
 		 * GDT. The new GDT has  __KERNEL_CS with CS.L = 1
@@ -1534,7 +1535,7 @@ asmlinkage void __init xen_start_kernel(void)
 	 * Set up kernel GDT and segment registers, mainly so that
 	 * -fstack-protector code can be executed.
 	 */
-	xen_setup_gdt();
+	xen_setup_gdt(0);
 
 	xen_init_irq_ops();
 	xen_init_cpuid_mask();
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c36b325..5e46190 100644
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
@@ -97,8 +99,14 @@ static void cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-static void cpu_bringup_and_idle(void)
+/* Note: cpu parameter is only relevant for PVH */
+static void cpu_bringup_and_idle(int cpu)
 {
+#ifdef CONFIG_X86_64
+	if (xen_feature(XENFEAT_auto_translated_physmap) &&
+	    xen_feature(XENFEAT_supervisor_mode_kernel))
+		xen_setup_gdt(cpu);
+#endif
 	cpu_bringup();
 	cpu_startup_entry(CPUHP_ONLINE);
 }
@@ -274,9 +282,10 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	native_smp_prepare_boot_cpu();
 
 	if (xen_pv_domain()) {
-		/* We've switched to the "real" per-cpu gdt, so make sure the
-		   old memory can be recycled */
-		make_lowmem_page_readwrite(xen_initial_gdt);
+		if (!xen_feature(XENFEAT_writable_page_tables))
+			/* We've switched to the "real" per-cpu gdt, so make
+			 * sure the old memory can be recycled. */
+			make_lowmem_page_readwrite(xen_initial_gdt);
 
 #ifdef CONFIG_X86_32
 		/*
@@ -360,22 +369,21 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 
 	gdt = get_cpu_gdt_table(cpu);
 
-	ctxt->flags = VGCF_IN_KERNEL;
-	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
+	/* Note: PVH is not yet supported on x86_32. */
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
 	ctxt->user_regs.gs = __KERNEL_STACK_CANARY;
-#else
-	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
-	{
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		ctxt->flags = VGCF_IN_KERNEL;
 		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 		ctxt->user_regs.ds = __USER_DS;
 		ctxt->user_regs.es = __USER_DS;
+		ctxt->user_regs.ss = __KERNEL_DS;
 
 		xen_copy_trap_info(ctxt->trap_ctxt);
 
@@ -396,18 +404,27 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 		ctxt->event_callback_cs     = __KERNEL_CS;
 		ctxt->failsafe_callback_cs  = __KERNEL_CS;
+#else
+		ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 		ctxt->event_callback_eip    =
 					(unsigned long)xen_hypervisor_callback;
 		ctxt->failsafe_callback_eip =
 					(unsigned long)xen_failsafe_callback;
+		ctxt->user_regs.cs = __KERNEL_CS;
+		per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
+#ifdef CONFIG_X86_32
 	}
-	ctxt->user_regs.cs = __KERNEL_CS;
+#else
+	} else
+		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
+		 * %rdi having the cpu number - which means are passing in
+		 * as the first parameter the cpu. Subtle!
+		 */
+		ctxt->user_regs.rdi = cpu;
+#endif
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
-
-	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
 	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
-
 	if (HYPERVISOR_vcpu_op(VCPUOP_initialise, cpu, ctxt))
 		BUG();
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 95f8c61..9059c24 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -123,4 +123,5 @@ __visible void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
+void xen_setup_gdt(int cpu);
 #endif /* XEN_OPS_H */
-- 
1.8.3.1

