Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaGWPee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:34:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33513 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbaGWPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:34:31 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86_64,entry: Use lret to return to userspace when possible
Date: Wed, 23 Jul 2014 08:34:12 -0700
Message-Id: <5415846495916e6c56250cbb8b8b9c6a81f1a770.1406129132.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406129131.git.luto@amacapital.net>
References: <cover.1406129131.git.luto@amacapital.net>
In-Reply-To: <cover.1406129131.git.luto@amacapital.net>
References: <cover.1406129131.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRET serializes, but LRET does not.  Try to use LRET to return
to userspace when possible.  It's possible if the saved RF and TF
are clear, IF is set, and espfix isn't needed.

This cuts about 23ns off of the IRET-to-userspace path on my
machine.  (YMMV -- this was in a tight loop, and I can imagine
the performance hit from serialization to be somewhat higher
in real code.)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I've tested normal code, iret faults, lret faults, and returns to funny
SS values.

I haven't explicitly exercised this code under heavy NMI load, nor
have I tested it on Xen (although, unless I screwed up, it shouldn't
do anything on Xen).

Benchmark away.  I know that Linus had a test for this stuff.  I doubt
that this will be as spectacular as my old sysret trampoline hack, but
it could still be a nice speedup.

 arch/x86/include/asm/irqflags.h  |  3 +-
 arch/x86/include/asm/paravirt.h  |  4 ++
 arch/x86/include/asm/traps.h     |  6 +++
 arch/x86/kernel/cpu/mcheck/mce.c |  2 +
 arch/x86/kernel/entry_64.S       | 93 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/nmi.c            | 21 +++++++++
 6 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 0a8b519..04c45bb 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -129,7 +129,8 @@ static inline notrace unsigned long arch_local_irq_save(void)
 
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 
-#define INTERRUPT_RETURN	jmp native_iret
+#define INTERRUPT_RETURN		jmp native_iret
+#define INTERRUPT_RETURN_UNBLOCK_NMI	jmp native_irq_return_need_iret
 #define USERGS_SYSRET64				\
 	swapgs;					\
 	sysretq;
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..3716b3d 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -913,6 +913,10 @@ extern void default_banner(void);
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
 		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_iret))
 
+#define INTERRUPT_RETURN_UNBLOCK_NMI					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_iret))
+
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
 		  PV_SAVE_REGS(clobbers | CLBR_CALLEE_SAVE);		\
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index bc8352e..2e3dfe8 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -134,4 +134,10 @@ enum {
 	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
 };
 
+#ifdef CONFIG_X86_64
+extern void fixup_lret_nmi(struct pt_regs *regs);
+#else
+static inline void fixup_lret_nmi(struct pt_regs *regs) {}
+#endif
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38..0bb9b9b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -43,6 +43,7 @@
 #include <linux/export.h>
 
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -1168,6 +1169,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	sync_core();
+	fixup_lret_nmi(regs);
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c844f08..a23b302 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -834,6 +834,81 @@ irq_return:
 
 ENTRY(native_iret)
 	/*
+	 * This implements "iret" the Platonic ideal, not "iret" the
+	 * instruction.  Specifically, it will pop RIP, CS, FLAGS,
+	 * RSP, and SS and load them, correctly, into the CPU state.
+	 * (IRET screws up RSP depending on SS).  It tries to avoid
+	 * serializing (IRET always serializes).
+	 *
+	 * This code does *not* promise to unblock NMIs.  Use
+	 * INTERRUPT_RETURN_UNBLOCK_NMI if you need NMIs to be unblocked.
+	 */
+
+	/*
+	 * Only IRET can set RF correctly, and our sti trick is
+	 * is incompatible with TF being set.
+	 */
+	testl $(X86_EFLAGS_RF|X86_EFLAGS_TF), (EFLAGS-RIP)(%rsp)
+	jnz native_irq_return_need_iret
+
+	/*
+	 * While it's technically possible to be in userspace with IF
+	 * clear (using iopl(2)), it's so unlikely that there's no point
+	 * in optimizing it.
+	 */
+	testl $X86_EFLAGS_IF, (EFLAGS-RIP)(%rsp)
+	jz native_irq_return_need_iret
+
+	/*
+	 * Returning without IRET to kernel space is possible, but
+	 * the considerations are different and we're not ready for that
+	 * yet.
+	 */
+	testl $3, (CS-RIP)(%rsp)
+	jz native_irq_return_need_iret
+
+#ifdef CONFIG_X86_ESPFIX64
+	/* lret has the same bug^Wfeature as iret wrt 16-bit SS. */
+	testb $4,(SS-RIP)(%rsp)
+	jnz native_irq_return_ldt
+#endif
+
+	/*
+	 * Rearrange the stack to pretend we got here via a call gate
+	 * (yes, really), and do a long return.
+	 */
+	pushq (SS     - RIP + 0*8)(%rsp)
+	pushq (RSP    - RIP + 1*8)(%rsp)
+	pushq (CS     - RIP + 2*8)(%rsp)
+	pushq (RIP    - RIP + 3*8)(%rsp)
+	pushq (EFLAGS - RIP + 4*8)(%rsp)
+	andl $~X86_EFLAGS_IF, (%rsp)	/* Clear saved IF. */
+	popfq				/* Restore all regs except IF. */
+
+.global native_sti_before_lret_to_userspace
+native_sti_before_lret_to_userspace:
+	sti				/* Restore IF. */
+
+	/*
+	 * This relies on the one-instruction interrupt grace period here
+	 * between sti and lret.  A non-paranoid interrupt here will
+	 * explode because GS is wrong.  More subtly, we may be on an IST
+	 * stack, and if we enable interrupts before leaving the IST stack,
+	 * we could cause a recursive IST interrupt, which would blow away
+	 * our stack frame.
+	 *
+	 * NMI and MCE are safe here -- see fixup_lret_nmi.
+	 */
+
+.global native_lret_to_userspace
+native_lret_to_userspace:
+	lretq
+
+	/* This fixup is special -- see error_lret. */
+	_ASM_EXTABLE(native_lret_to_userspace, bad_iret)
+
+native_irq_return_need_iret:
+	/*
 	 * Are we returning to a stack segment from the LDT?  Note: in
 	 * 64-bit mode SS:RSP on the exception stack is always valid.
 	 */
@@ -883,6 +958,8 @@ bad_iret:
 	 * We are now running with the kernel GS after exception recovery.
 	 * But error_entry expects us to have user GS to match the user %cs,
 	 * so swap back.
+	 *
+	 * lret faults land here, too.
 	 */
 	pushq $0
 
@@ -1412,7 +1489,7 @@ error_sti:
 	ret
 
 /*
- * There are two places in the kernel that can potentially fault with
+ * There are three places in the kernel that can potentially fault with
  * usergs. Handle them here. The exception handlers after iret run with
  * kernel gs again, so don't set the user space flag. B stepping K8s
  * sometimes report an truncated RIP for IRET exceptions returning to
@@ -1428,6 +1505,8 @@ error_kernelspace:
 	je bstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
 	je error_swapgs
+	cmpq $native_lret_to_userspace,RIP+8(%rsp)
+	je error_lret
 	jmp error_sti
 
 bstep_iret:
@@ -1435,6 +1514,16 @@ bstep_iret:
 	movq %rcx,RIP+8(%rsp)
 	jmp error_swapgs
 	CFI_ENDPROC
+
+error_lret:
+	/*
+	 * We can't return from this fault with IF set because we'll lose
+	 * the sti grace period.  Fix up the fault so that it looks just
+	 * like an iret fault instead.
+	 */
+	addq $4*8,RSP+8(%rsp)			/* pop the lret frame */
+	andl $~X86_EFLAGS_IF,EFLAGS+8(%rsp)	/* clear IF */
+	jmp error_swapgs			/* return w/ kernel GS */
 END(error_entry)
 
 
@@ -1706,7 +1795,7 @@ nmi_restore:
 
 	/* Clear the NMI executing stack variable */
 	movq $0, 5*8(%rsp)
-	jmp irq_return
+	INTERRUPT_RETURN_UNBLOCK_NMI
 	CFI_ENDPROC
 END(nmi)
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index c3e985d..ca8be8e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -306,12 +306,33 @@ NOKPROBE_SYMBOL(unknown_nmi_error);
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
+#ifdef CONFIG_X86_64
+void fixup_lret_nmi(struct pt_regs *regs)
+{
+	/*
+	 * There is no architectural guarantee that an NMI or MCE can't
+	 * happen between sti and lret.  To avoid returning to the lret
+	 * instruction with interrupts on, we back up one instruction.
+	 */
+	extern const char native_lret_to_userspace[];
+	extern const char native_sti_before_lret_to_userspace[];
+
+	if (!user_mode_vm(regs) &&
+	    regs->ip == (unsigned long)native_lret_to_userspace) {
+		regs->ip = (unsigned long)native_sti_before_lret_to_userspace;
+		regs->flags &= ~X86_EFLAGS_IF;
+	}
+}
+#endif
+
 static void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
 	bool b2b = false;
 
+	fixup_lret_nmi(regs);
+
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
 	 * NMI, otherwise we may lose it, because the CPU-specific
-- 
1.9.3

