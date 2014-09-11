Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaIKMgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51688 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755471AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Lutomirski" <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.711567933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 129/131] x86_64/entry/xen: Do not invoke espfix64 on Xen
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 7209a75d2009dbf7745e2fd354abf25c3deb3ca3 upstream.

This moves the espfix64 logic into native_iret.  To make this work,
it gets rid of the native patch for INTERRUPT_RETURN:
INTERRUPT_RETURN on native kernels is now 'jmp native_iret'.

This changes the 16-bit SS behavior on Xen from OOPSing to leaking
some bits of the Xen hypervisor's RSP (I think).

[ hpa: this is a nonzero cost on native, but probably not enough to
  measure. Xen needs to fix this in their own code, probably doing
  something equivalent to espfix64. ]

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/7b8f1d8ef6597cb16ae004a43c56980a7de3cf94.1406129132.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/irqflags.h     |  2 +-
 arch/x86/kernel/entry_64.S          | 31 ++++++++++---------------------
 arch/x86/kernel/paravirt_patch_64.c |  2 --
 3 files changed, 11 insertions(+), 24 deletions(-)

--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -129,7 +129,7 @@ static inline notrace unsigned long arch
 
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 
-#define INTERRUPT_RETURN	iretq
+#define INTERRUPT_RETURN	jmp native_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
 	sysretq;
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -861,33 +861,27 @@ restore_args:
 	RESTORE_ARGS 1,8,1
 
 irq_return:
+	INTERRUPT_RETURN
+
+ENTRY(native_iret)
 	/*
 	 * Are we returning to a stack segment from the LDT?  Note: in
 	 * 64-bit mode SS:RSP on the exception stack is always valid.
 	 */
 #ifdef CONFIG_X86_ESPFIX64
 	testb $4,(SS-RIP)(%rsp)
-	jnz irq_return_ldt
+	jnz native_irq_return_ldt
 #endif
 
-irq_return_iret:
-	INTERRUPT_RETURN
-
-	.section __ex_table, "a"
-	.quad irq_return_iret, bad_iret
-	.previous
-
-#ifdef CONFIG_PARAVIRT
-ENTRY(native_iret)
+native_irq_return_iret:
 	iretq
 
 	.section __ex_table,"a"
-	.quad native_iret, bad_iret
+	.quad native_irq_return_iret, bad_iret
 	.previous
-#endif
 
 #ifdef CONFIG_X86_ESPFIX64
-irq_return_ldt:
+native_irq_return_ldt:
 	pushq_cfi %rax
 	pushq_cfi %rdi
 	SWAPGS
@@ -909,7 +903,7 @@ irq_return_ldt:
 	SWAPGS
 	movq %rax,%rsp
 	popq_cfi %rax
-	jmp irq_return_iret
+	jmp native_irq_return_iret
 #endif
 
 	.section .fixup,"ax"
@@ -995,13 +989,8 @@ __do_double_fault:
 	cmpl $__KERNEL_CS,CS(%rdi)
 	jne do_double_fault
 	movq RIP(%rdi),%rax
-	cmpq $irq_return_iret,%rax
-#ifdef CONFIG_PARAVIRT
-	je 1f
-	cmpq $native_iret,%rax
-#endif
+	cmpq $native_irq_return_iret,%rax
 	jne do_double_fault		/* This shouldn't happen... */
-1:
 	movq PER_CPU_VAR(kernel_stack),%rax
 	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
 	movq %rax,RSP(%rdi)
@@ -1511,7 +1500,7 @@ error_sti:
  */
 error_kernelspace:
 	incl %ebx
-	leaq irq_return_iret(%rip),%rcx
+	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
 	movl %ecx,%eax	/* zero extend */
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -6,7 +6,6 @@ DEF_NATIVE(pv_irq_ops, irq_disable, "cli
 DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
 DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
-DEF_NATIVE(pv_cpu_ops, iret, "iretq");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
@@ -50,7 +49,6 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_irq_ops, irq_enable);
 		PATCH_SITE(pv_irq_ops, irq_disable);
-		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret32);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret64);

