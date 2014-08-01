Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaHAXAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 19:00:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaHAXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 19:00:41 -0400
Date: Fri, 1 Aug 2014 16:00:19 -0700
Message-Id: <201408012300.s71N0JxY000968@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/Xen fix for v3.16[-rc8]
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mingo@kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A single fix to not invoke the espfix code on Xen PV, as it turns out
to oops the guest when invoked after all.  This patch leaves some
amount of dead code, in particular unnecessary initialization of the
espfix stacks when they won't be used, but in the interest of keeping
the patch minimal that cleanup can wait for the next cycle.

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 7209a75d2009dbf7745e2fd354abf25c3deb3ca3:

  x86_64/entry/xen: Do not invoke espfix64 on Xen (2014-07-28 15:25:40 -0700)

----------------------------------------------------------------
Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

 arch/x86/include/asm/irqflags.h     |  2 +-
 arch/x86/kernel/entry_64.S          | 28 ++++++++++------------------
 arch/x86/kernel/paravirt_patch_64.c |  2 --
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index bba3cf8..0a8b519 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -129,7 +129,7 @@ static inline notrace unsigned long arch_local_irq_save(void)
 
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 
-#define INTERRUPT_RETURN	iretq
+#define INTERRUPT_RETURN	jmp native_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
 	sysretq;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b25ca96..c844f08 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -830,27 +830,24 @@ restore_args:
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
-	_ASM_EXTABLE(irq_return_iret, bad_iret)
-
-#ifdef CONFIG_PARAVIRT
-ENTRY(native_iret)
+native_irq_return_iret:
 	iretq
-	_ASM_EXTABLE(native_iret, bad_iret)
-#endif
+	_ASM_EXTABLE(native_irq_return_iret, bad_iret)
 
 #ifdef CONFIG_X86_ESPFIX64
-irq_return_ldt:
+native_irq_return_ldt:
 	pushq_cfi %rax
 	pushq_cfi %rdi
 	SWAPGS
@@ -872,7 +869,7 @@ irq_return_ldt:
 	SWAPGS
 	movq %rax,%rsp
 	popq_cfi %rax
-	jmp irq_return_iret
+	jmp native_irq_return_iret
 #endif
 
 	.section .fixup,"ax"
@@ -956,13 +953,8 @@ __do_double_fault:
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
@@ -1428,7 +1420,7 @@ error_sti:
  */
 error_kernelspace:
 	incl %ebx
-	leaq irq_return_iret(%rip),%rcx
+	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
 	movl %ecx,%eax	/* zero extend */
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
index 3f08f34..a1da673 100644
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -6,7 +6,6 @@ DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
 DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
 DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
 DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
-DEF_NATIVE(pv_cpu_ops, iret, "iretq");
 DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
 DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
 DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
@@ -50,7 +49,6 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 		PATCH_SITE(pv_irq_ops, save_fl);
 		PATCH_SITE(pv_irq_ops, irq_enable);
 		PATCH_SITE(pv_irq_ops, irq_disable);
-		PATCH_SITE(pv_cpu_ops, iret);
 		PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret32);
 		PATCH_SITE(pv_cpu_ops, usergs_sysret64);
