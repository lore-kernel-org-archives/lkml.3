Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaGWT0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:26:44 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42297 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaGWT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:26:42 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] x86_64,entry: Use lret to return to userspace when possible
Date: Wed, 23 Jul 2014 12:26:36 -0700
Message-Id: <ac1af21fe141faf685374e3fb0c2383befb65651.1406143250.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
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

This applies on top of "x86_64,entry,xen: Do not invoke espfix64 on Xen".

This survived this abuse for a while:

perf record -o /dev/null -e cpu-cycles -c 100000 ./sigretloop.sh

where sigretloop.sh runs my sigreturn_32 test [1] over and over in a loop.

As before, sigreturn_32 will oops without the fix that's sitting in
tip/perf/urgent.

[1] sigreturn_32 from https://gitorious.org/linux-test-utils/linux-clock-tests/

Changes from v1:
 - Dropped patch 1 from the email.  There's no point in re-sending it
   over and over.  You'll still need it to apply this, though.
 - Fixed the paravirt stuff.  v1 was rather broken on paravirt kernels.

 arch/x86/include/asm/irqflags.h       |  3 +-
 arch/x86/include/asm/paravirt.h       |  4 ++
 arch/x86/include/asm/paravirt_types.h |  3 ++
 arch/x86/include/asm/traps.h          |  6 +++
 arch/x86/kernel/asm-offsets.c         |  3 ++
 arch/x86/kernel/cpu/mcheck/mce.c      |  2 +
 arch/x86/kernel/entry_64.S            | 94 ++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/nmi.c                 | 21 ++++++++
 arch/x86/kernel/paravirt.c            |  7 +++
 arch/x86/lguest/boot.c                |  3 ++
 arch/x86/xen/enlighten.c              |  3 ++
 11 files changed, 146 insertions(+), 3 deletions(-)

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
index cd6e161..c8b5529 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -913,6 +913,10 @@ extern void default_banner(void);
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
 		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_iret))
 
+#define INTERRUPT_RETURN_UNBLOCK_NMI					\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret_unblock_nmi), CLBR_NONE, \
+		  jmp PARA_INDIRECT(pv_cpu_ops+PV_CPU_iret_unblock_nmi))
+
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
 		  PV_SAVE_REGS(clobbers | CLBR_CALLEE_SAVE);		\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..dea3368 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -188,6 +188,9 @@ struct pv_cpu_ops {
 	   frame set up. */
 	void (*iret)(void);
 
+	/* Same as iret, but promises to unblock NMIs */
+	void (*iret_unblock_nmi)(void);
+
 	void (*swapgs)(void);
 
 	void (*start_context_switch)(struct task_struct *prev);
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
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 9f6b934..d424a1f 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -49,6 +49,9 @@ void common(void) {
 	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
 	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
 	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
+#ifdef CONFIG_X86_64
+	OFFSET(PV_CPU_iret_unblock_nmi, pv_cpu_ops, iret_unblock_nmi);
+#endif
 	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
 	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
 	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
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
index c844f08..997e1e0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -834,6 +834,82 @@ irq_return:
 
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
+.global native_irq_return_need_iret
+native_irq_return_need_iret:
+	/*
 	 * Are we returning to a stack segment from the LDT?  Note: in
 	 * 64-bit mode SS:RSP on the exception stack is always valid.
 	 */
@@ -883,6 +959,8 @@ bad_iret:
 	 * We are now running with the kernel GS after exception recovery.
 	 * But error_entry expects us to have user GS to match the user %cs,
 	 * so swap back.
+	 *
+	 * lret faults land here, too.
 	 */
 	pushq $0
 
@@ -1412,7 +1490,7 @@ error_sti:
 	ret
 
 /*
- * There are two places in the kernel that can potentially fault with
+ * There are three places in the kernel that can potentially fault with
  * usergs. Handle them here. The exception handlers after iret run with
  * kernel gs again, so don't set the user space flag. B stepping K8s
  * sometimes report an truncated RIP for IRET exceptions returning to
@@ -1428,6 +1506,8 @@ error_kernelspace:
 	je bstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
 	je error_swapgs
+	cmpq $native_lret_to_userspace,RIP+8(%rsp)
+	je error_lret
 	jmp error_sti
 
 bstep_iret:
@@ -1435,6 +1515,16 @@ bstep_iret:
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
 
 
@@ -1706,7 +1796,7 @@ nmi_restore:
 
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
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 548d25f..00aee0b 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -154,6 +154,7 @@ unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
 		ret = paravirt_patch_ident_64(insnbuf, len);
 
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
+		 type == PARAVIRT_PATCH(pv_cpu_ops.iret_unblock_nmi) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret32) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret64))
@@ -210,6 +211,9 @@ static u64 native_steal_clock(int cpu)
 
 /* These are in entry.S */
 extern void native_iret(void);
+#ifdef CONFIG_X86_64
+extern void native_irq_return_need_iret(void);
+#endif
 extern void native_irq_enable_sysexit(void);
 extern void native_usergs_sysret32(void);
 extern void native_usergs_sysret64(void);
@@ -381,6 +385,9 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.usergs_sysret64 = native_usergs_sysret64,
 #endif
 	.iret = native_iret,
+#ifdef CONFIG_X86_64
+	.iret_unblock_nmi = native_irq_return_need_iret,
+#endif
 	.swapgs = native_swapgs,
 
 	.set_iopl_mask = native_set_iopl_mask,
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aae9413..24d7dc5 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1305,6 +1305,9 @@ __init void lguest_init(void)
 	pv_cpu_ops.cpuid = lguest_cpuid;
 	pv_cpu_ops.load_idt = lguest_load_idt;
 	pv_cpu_ops.iret = lguest_iret;
+#ifdef CONFIG_X86_64
+	pv_cpu_ops.iret_unblock_nmi = lguest_iret;
+#endif
 	pv_cpu_ops.load_sp0 = lguest_load_sp0;
 	pv_cpu_ops.load_tr_desc = lguest_load_tr_desc;
 	pv_cpu_ops.set_ldt = lguest_set_ldt;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ffb101e..91090dc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1253,6 +1253,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_tscp = native_read_tscp,
 
 	.iret = xen_iret,
+#ifdef CONFIG_X86_64
+	.iret_unblock_nmi = xen_iret,
+#endif
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64
 	.usergs_sysret32 = xen_sysret32,
-- 
1.9.3

