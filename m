Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaIJXgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:36:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42709 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaIJXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:36:21 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE in PVH guests
Date: Wed, 10 Sep 2014 16:36:06 -0700
Message-Id: <1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two bugs in PVH guests:

  - Not setting EFER.NX means the NX bit in page table entries is
    ignored on Intel processors and causes reserved bit page faults on
    AMD processors.

  - After the Xen commit 7645640d6ff1 ("x86/PVH: don't set EFER_SCE for
    pvh guest") PVH guests are required to set EFER.SCE to enable the
    SYSCALL instruction.

Secondary VCPUs are started with pagetables with the NX bit set so
EFER.NX must be set before using any stack or data segment.
xen_pvh_cpu_early_init() is the new secondary VCPU entry point that
sets EFER before jumping to cpu_bringup_and_idle().

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/enlighten.c |  6 ++++++
 arch/x86/xen/smp.c       | 29 ++++++++++++++++++-----------
 arch/x86/xen/smp.h       |  8 ++++++++
 arch/x86/xen/xen-head.S  | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..424d831 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1463,6 +1463,7 @@ static void __ref xen_setup_gdt(int cpu)
 	pv_cpu_ops.load_gdt = xen_load_gdt;
 }
 
+#ifdef CONFIG_XEN_PVH
 /*
  * A PV guest starts with default flags that are not set for PVH, set them
  * here asap.
@@ -1508,12 +1509,15 @@ static void __init xen_pvh_early_guest_init(void)
 		return;
 
 	xen_have_vector_callback = 1;
+
+	xen_pvh_early_cpu_init(0, false);
 	xen_pvh_set_cr_flags(0);
 
 #ifdef CONFIG_X86_32
 	BUG(); /* PVH: Implement proper support. */
 #endif
 }
+#endif    /* CONFIG_XEN_PVH */
 
 /* First C function to be called on Xen boot */
 asmlinkage __visible void __init xen_start_kernel(void)
@@ -1527,7 +1531,9 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	xen_domain_type = XEN_PV_DOMAIN;
 
 	xen_setup_features();
+#ifdef CONFIG_XEN_PVH
 	xen_pvh_early_guest_init();
+#endif
 	xen_setup_machphys_mapping();
 
 	/* Install Xen paravirt ops */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7005974..b25f8942 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -37,6 +37,7 @@
 #include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
+#include "smp.h"
 
 cpumask_var_t xen_cpu_initialized_map;
 
@@ -99,10 +100,14 @@ static void cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-/* Note: cpu parameter is only relevant for PVH */
-static void cpu_bringup_and_idle(int cpu)
+/*
+ * Note: cpu parameter is only relevant for PVH. The reason for passing it
+ * is we can't do smp_processor_id until the percpu segments are loaded, for
+ * which we need the cpu number! So we pass it in rdi as first parameter.
+ */
+asmlinkage __visible void cpu_bringup_and_idle(int cpu)
 {
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_XEN_PVH
 	if (xen_feature(XENFEAT_auto_translated_physmap) &&
 	    xen_feature(XENFEAT_supervisor_mode_kernel))
 		xen_pvh_secondary_vcpu_init(cpu);
@@ -374,11 +379,10 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
 	ctxt->user_regs.gs = __KERNEL_STACK_CANARY;
 #endif
-	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
-
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 		ctxt->flags = VGCF_IN_KERNEL;
 		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 		ctxt->user_regs.ds = __USER_DS;
@@ -413,15 +417,18 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 					(unsigned long)xen_failsafe_callback;
 		ctxt->user_regs.cs = __KERNEL_CS;
 		per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
-#ifdef CONFIG_X86_32
 	}
-#else
-	} else
-		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
-		 * %rdi having the cpu number - which means are passing in
-		 * as the first parameter the cpu. Subtle!
+#ifdef CONFIG_XEN_PVH
+	else {
+		/*
+		 * The vcpu comes on kernel page tables which have the NX pte
+		 * bit set. This means before DS/SS is touched, NX in
+		 * EFER must be set. Hence the following assembly glue code.
 		 */
+		ctxt->user_regs.eip = (unsigned long)xen_pvh_early_cpu_init;
 		ctxt->user_regs.rdi = cpu;
+		ctxt->user_regs.rsi = true;  /* secondary cpu == true */
+	}
 #endif
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
 	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index c7c2d89..04a83a7 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -8,4 +8,12 @@ extern void xen_send_IPI_allbutself(int vector);
 extern void xen_send_IPI_all(int vector);
 extern void xen_send_IPI_self(int vector);
 
+#ifdef CONFIG_XEN_PVH
+extern void xen_pvh_early_cpu_init(int cpu, bool flag);
+#else
+static inline void xen_pvh_early_cpu_init(int cpu, bool flag);
+{
+}
+#endif
+
 #endif
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 485b695..718f330 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -47,6 +47,39 @@ ENTRY(startup_xen)
 
 	__FINIT
 
+#ifdef CONFIG_XEN_PVH
+/*
+ * xen_pvh_early_cpu_init() - early PVH VCPU initialization
+ * @cpu: this cpu number (%rdi)
+ * @flag: boolean flag true to indicate this is a secondary vcpu coming up
+ *        on this entry point or the primary cpu coming back online.
+ *
+ * Note: This is called as a function on the boot CPU, and is the entry point
+ *       on the secondary CPU.
+ */
+ENTRY(xen_pvh_early_cpu_init)
+	mov     %rsi, %r11
+
+	/* Gather features to see if NX implemented. */
+	mov     $0x80000001, %eax
+	cpuid
+	mov     %edx, %esi
+
+	mov     $MSR_EFER, %ecx
+	rdmsr
+	bts     $_EFER_SCE, %eax
+
+	bt      $20, %esi
+	jnc     1f      	/* No NX, skip setting it */
+	bts     $_EFER_NX, %eax
+1:	wrmsr
+
+	cmp     $0, %r11b
+	jne     cpu_bringup_and_idle
+	ret
+
+#endif /* CONFIG_XEN_PVH */
+
 .pushsection .text
 	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-- 
1.8.3.1

