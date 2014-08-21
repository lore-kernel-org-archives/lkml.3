Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaHUCRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:17:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44522 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaHUCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:17:00 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V0 PATCH 2/2] AMD-PVH: set EFER.NX and EFER.SCE for secondary vcpus
Date: Wed, 20 Aug 2014 19:16:40 -0700
Message-Id: <1408587400-18663-3-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The secondary vcpus come on kernel page tables which have the NX bit set
in pte entries for DS/SS. On AMD, EFER.NX must be set to avoid protection
fault.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/smp.c      | 28 ++++++++++++++++++++--------
 arch/x86/xen/smp.h      |  1 +
 arch/x86/xen/xen-head.S | 21 +++++++++++++++++++++
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7005974..66058b9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -37,6 +37,7 @@
 #include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
+#include "smp.h"
 
 cpumask_var_t xen_cpu_initialized_map;
 
@@ -99,8 +100,12 @@ static void cpu_bringup(void)
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
 #ifdef CONFIG_X86_64
 	if (xen_feature(XENFEAT_auto_translated_physmap) &&
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
@@ -416,12 +420,20 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 	}
 #else
-	} else
-		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
-		 * %rdi having the cpu number - which means are passing in
-		 * as the first parameter the cpu. Subtle!
+	} else {
+		/*
+		 * The vcpu comes on kernel page tables which have the NX pte
+		 * bit set on AMD. This means before DS/SS is touched, NX in
+		 * EFER must be set. Hence the following assembly glue code.
+		 */
+		ctxt->user_regs.eip = (unsigned long)pvh_cpu_bringup;
+
+		/* N.B. The bringup function cpu_bringup_and_idle is called with
+		 * %rdi having the cpu number - which means we are passing it in
+		 * as the first parameter. Subtle!
 		 */
 		ctxt->user_regs.rdi = cpu;
+	}
 #endif
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
 	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index c7c2d89..b20ba68 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -7,5 +7,6 @@ extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
 extern void xen_send_IPI_allbutself(int vector);
 extern void xen_send_IPI_all(int vector);
 extern void xen_send_IPI_self(int vector);
+extern void pvh_cpu_bringup(int cpu);
 
 #endif
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 485b695..db8dca5 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -47,6 +47,27 @@ ENTRY(startup_xen)
 
 	__FINIT
 
+#ifdef CONFIG_XEN_PVH
+#ifdef CONFIG_X86_64
+/* Note that rdi contains the cpu number and must be preserved */
+ENTRY(pvh_cpu_bringup)
+	/* Gather features to see if NX implemented. (no EFER.NX on intel) */
+	movl    $0x80000001, %eax
+	cpuid
+	movl    %edx,%esi
+
+	movl    $MSR_EFER, %ecx
+	rdmsr
+	btsl    $_EFER_SCE, %eax
+
+	btl     $20,%esi
+	jnc     1f	/* No NX, skip it */
+	btsl    $_EFER_NX, %eax
+1:	wrmsr
+	jmp cpu_bringup_and_idle
+#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_XEN_PVH */
+
 .pushsection .text
 	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-- 
1.8.3.1

