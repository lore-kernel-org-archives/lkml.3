Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaINL72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:59:28 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35669 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaINL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:59:19 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.17-rc4 v6 2/6] arm: fiq: Replace default FIQ handler
Date: Sun, 14 Sep 2014 12:57:11 +0100
Message-Id: <1410695835-10496-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
References: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new default FIQ handler that is structured in a
similar way to the existing ARM exception handler and result in the FIQ
being handled by C code running on the SVC stack (despite this code run
in the FIQ handler is subject to severe limitations with respect to
locking making normal interaction with the kernel impossible).

This default handler allows concepts that on x86 would be handled using
NMIs to be realized on ARM.

Credit:

    This patch is a near complete re-write of a patch originally
    provided by Anton Vorontsov. Today only a couple of small fragments
    survive, however without Anton's work to build from this patch would
    not exist. Thanks also to Russell King for spoonfeeding me a variety
    of fixes during the review cycle.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/kernel/entry-armv.S   | 98 +++++++++++++++++++++++++++++++++++++-----
 arch/arm/kernel/entry-header.S | 47 ++++++++++++++++++++
 arch/arm/kernel/fiq.c          | 11 ++++-
 arch/arm/kernel/setup.c        |  8 +++-
 arch/arm/kernel/traps.c        | 26 +++++++++++
 5 files changed, 177 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 36276cd..859f56c 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -146,7 +146,7 @@ ENDPROC(__und_invalid)
 #define SPFIX(code...)
 #endif
 
-	.macro	svc_entry, stack_hole=0
+	.macro	svc_entry, stack_hole=0, trace=1
  UNWIND(.fnstart		)
  UNWIND(.save {r0 - pc}		)
 	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
@@ -182,9 +182,11 @@ ENDPROC(__und_invalid)
 	@
 	stmia	r7, {r2 - r6}
 
+	.if \trace
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
+	.endif
 	.endm
 
 	.align	5
@@ -295,6 +297,15 @@ __pabt_svc:
 ENDPROC(__pabt_svc)
 
 	.align	5
+__fiq_svc:
+	svc_entry trace=0
+	mov	r0, sp				@ struct pt_regs *regs
+	bl	handle_fiq_as_nmi
+	svc_exit_via_fiq
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
+
+	.align	5
 .LCcralign:
 	.word	cr_alignment
 #ifdef MULTI_DABORT
@@ -305,6 +316,46 @@ ENDPROC(__pabt_svc)
 	.word	fp_enter
 
 /*
+ * Abort mode handlers
+ */
+
+@
+@ Taking a FIQ in abort mode is similar to taking a FIQ in SVC mode
+@ and reuses the same macros. However in abort mode we must also
+@ save/restore lr_abt and spsr_abt to make nested aborts safe.
+@
+	.align 5
+__fiq_abt:
+	svc_entry trace=0
+
+ ARM(	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( mov	r0, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( msr	cpsr_c, r0 )
+	mov	r1, lr		@ Save lr_abt
+	mrs	r2, spsr	@ Save spsr_abt, abort is now safe
+ ARM(	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( mov	r0, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( msr	cpsr_c, r0 )
+	stmfd	sp!, {r1 - r2}
+
+	add	r0, sp, #8			@ struct pt_regs *regs
+	bl	handle_fiq_as_nmi
+
+	ldmfd	sp!, {r1 - r2}
+ ARM(	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( mov	r0, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( msr	cpsr_c, r0 )
+	mov	lr, r1		@ Restore lr_abt, abort is unsafe
+	msr	spsr_cxsf, r2	@ Restore spsr_abt
+ ARM(	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( mov	r0, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
+ THUMB( msr	cpsr_c, r0 )
+
+	svc_exit_via_fiq
+ UNWIND(.fnend		)
+ENDPROC(__fiq_abt)
+
+/*
  * User mode handlers
  *
  * EABI note: sp_svc is always 64-bit aligned here, so should S_FRAME_SIZE
@@ -314,7 +365,7 @@ ENDPROC(__pabt_svc)
 #error "sizeof(struct pt_regs) must be a multiple of 8"
 #endif
 
-	.macro	usr_entry
+	.macro	usr_entry, trace=1
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)	@ don't unwind the user space
 	sub	sp, sp, #S_FRAME_SIZE
@@ -351,10 +402,12 @@ ENDPROC(__pabt_svc)
 	@
 	zero_fp
 
+	.if	\trace
 #ifdef CONFIG_IRQSOFF_TRACER
 	bl	trace_hardirqs_off
 #endif
 	ct_user_exit save = 0
+	.endif
 	.endm
 
 	.macro	kuser_cmpxchg_check
@@ -683,6 +736,17 @@ ENTRY(ret_from_exception)
 ENDPROC(__pabt_usr)
 ENDPROC(ret_from_exception)
 
+	.align	5
+__fiq_usr:
+	usr_entry trace=0
+	kuser_cmpxchg_check
+	mov	r0, sp				@ struct pt_regs *regs
+	bl	handle_fiq_as_nmi
+	get_thread_info tsk
+	restore_user_regs fast = 0, offset = 0
+ UNWIND(.fnend		)
+ENDPROC(__fiq_usr)
+
 /*
  * Register switch for ARMv3 and ARMv4 processors
  * r0 = previous task_struct, r1 = previous thread_info, r2 = next thread_info
@@ -1118,17 +1182,29 @@ vector_addrexcptn:
 	b	vector_addrexcptn
 
 /*=============================================================================
- * Undefined FIQs
+ * FIQ "NMI" handler
  *-----------------------------------------------------------------------------
- * Enter in FIQ mode, spsr = ANY CPSR, lr = ANY PC
- * MUST PRESERVE SVC SPSR, but need to switch to SVC mode to show our msg.
- * Basically to switch modes, we *HAVE* to clobber one register...  brain
- * damage alert!  I don't think that we can execute any code in here in any
- * other mode than FIQ...  Ok you can switch to another mode, but you can't
- * get out of that mode without clobbering one register.
+ * Handle a FIQ using the SVC stack allowing FIQ act like NMI on x86
+ * systems.
  */
-vector_fiq:
-	subs	pc, lr, #4
+	vector_stub	fiq, FIQ_MODE, 4
+
+	.long	__fiq_usr			@  0  (USR_26 / USR_32)
+	.long	__fiq_svc			@  1  (FIQ_26 / FIQ_32)
+	.long	__fiq_svc			@  2  (IRQ_26 / IRQ_32)
+	.long	__fiq_svc			@  3  (SVC_26 / SVC_32)
+	.long	__fiq_svc			@  4
+	.long	__fiq_svc			@  5
+	.long	__fiq_svc			@  6
+	.long	__fiq_abt			@  7
+	.long	__fiq_svc			@  8
+	.long	__fiq_svc			@  9
+	.long	__fiq_svc			@  a
+	.long	__fiq_svc			@  b
+	.long	__fiq_svc			@  c
+	.long	__fiq_svc			@  d
+	.long	__fiq_svc			@  e
+	.long	__fiq_svc			@  f
 
 	.globl	vector_fiq_offset
 	.equ	vector_fiq_offset, vector_fiq
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 2fdf867..0d91ca0 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -216,6 +216,34 @@
 	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
 	.endm
 
+	@
+	@ svc_exit_via_fiq - like svc_exit but switches to FIQ mode before exit
+	@
+	@ This macro acts in a similar manner to svc_exit but switches to FIQ
+	@ mode to restore the final part of the register state.
+	@
+	@ We cannot use the normal svc_exit procedure because that would
+	@ clobber spsr_svc (FIQ could be delivered during the first few
+	@ instructions of vector_swi meaning its contents have not been
+	@ saved anywhere).
+	@
+	@ Note that, unlike svc_exit, this macro also does not allow a caller
+	@ supplied rpsr. This is because the FIQ exceptions are not re-entrant
+	@ and the handlers cannot call into the scheduler (meaning the value
+	@ on the stack remains correct).
+	@
+	.macro  svc_exit_via_fiq
+	mov	r0, sp
+	ldmib	r0, {r1 - r14}	@ abort is deadly from here onward (it will
+				@ clobber state restored below)
+	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
+	add	r8, r0, #S_PC
+	ldr	r9, [r0, #S_PSR]
+	msr	spsr_cxsf, r9
+	ldr	r0, [r0, #S_R0]
+	ldmia	r8, {pc}^
+	.endm
+
 	.macro	restore_user_regs, fast = 0, offset = 0
 	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
 	ldr	lr, [sp, #\offset + S_PC]!	@ get pc
@@ -267,6 +295,25 @@
 	rfeia	sp!
 	.endm
 
+	@
+	@ svc_exit_via_fiq - like svc_exit but switches to FIQ mode before exit
+	@
+	@ For full details see non-Thumb implementation above.
+	@
+	.macro  svc_exit_via_fiq
+	add	r0, sp, #S_R2
+	ldr	lr, [sp, #S_LR]
+	ldr	sp, [sp, #S_SP] @ abort is deadly from here onward (it will
+			        @ clobber state restored below)
+	ldmia	r0, {r2 - r12}
+	mov	r1, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
+	msr	cpsr_c, r1
+	sub	r0, #S_R2
+	add	r8, r0, #S_PC
+	ldmia	r0, {r0 - r1}
+	rfeia	r8
+	.endm
+
 #ifdef CONFIG_CPU_V7M
 	/*
 	 * Note we don't need to do clrex here as clearing the local monitor is
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 918875d..1743049 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -53,6 +53,7 @@
 	})
 
 static unsigned long no_fiq_insn;
+static struct pt_regs def_fiq_regs;
 
 /* Default reacquire function
  * - we always relinquish FIQ control
@@ -60,8 +61,15 @@ static unsigned long no_fiq_insn;
  */
 static int fiq_def_op(void *ref, int relinquish)
 {
-	if (!relinquish)
+	if (!relinquish) {
+		/* Restore default handler and registers */
+		local_fiq_disable();
+		set_fiq_regs(&dfl_fiq_regs);
 		set_fiq_handler(&no_fiq_insn, sizeof(no_fiq_insn));
+		local_fiq_enable();
+
+		/* FIXME: notify irq controller to standard enable FIQs */
+	}
 
 	return 0;
 }
@@ -151,5 +159,6 @@ void __init init_FIQ(int start)
 {
 	unsigned offset = FIQ_OFFSET;
 	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
+	get_fiq_regs(&dfl_fiq_regs);
 	fiq_start = start;
 }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 84db893d..c031063 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -133,6 +133,7 @@ struct stack {
 	u32 irq[3];
 	u32 abt[3];
 	u32 und[3];
+	u32 fiq[3];
 } ____cacheline_aligned;
 
 #ifndef CONFIG_CPU_V7M
@@ -470,7 +471,10 @@ void notrace cpu_init(void)
 	"msr	cpsr_c, %5\n\t"
 	"add	r14, %0, %6\n\t"
 	"mov	sp, r14\n\t"
-	"msr	cpsr_c, %7"
+	"msr	cpsr_c, %7\n\t"
+	"add	r14, %0, %8\n\t"
+	"mov	sp, r14\n\t"
+	"msr	cpsr_c, %9"
 	    :
 	    : "r" (stk),
 	      PLC (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
@@ -479,6 +483,8 @@ void notrace cpu_init(void)
 	      "I" (offsetof(struct stack, abt[0])),
 	      PLC (PSR_F_BIT | PSR_I_BIT | UND_MODE),
 	      "I" (offsetof(struct stack, und[0])),
+	      PLC (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
+	      "I" (offsetof(struct stack, fiq[0])),
 	      PLC (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
 	    : "r14");
 #endif
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index a447dcc..439138d 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/irq.h>
 
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
@@ -461,6 +462,31 @@ die_sig:
 }
 
 /*
+ * Handle FIQ similarly to NMI on x86 systems.
+ *
+ * The runtime environment for NMIs is extremely restrictive
+ * (NMIs can pre-empt critical sections meaning almost all locking is
+ * forbidden) meaning this default FIQ handling must only be used in
+ * circumstances where non-maskability improves robustness, such as
+ * watchdog or debug logic.
+ *
+ * This handler is not appropriate for general purpose use in drivers
+ * platform code and can be overrideen using set_fiq_handler.
+ */
+asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	nmi_enter();
+
+	/* nop. FIQ handlers for special arch/arm features can be added here. */
+
+	nmi_exit();
+
+	set_irq_regs(old_regs);
+}
+
+/*
  * bad_mode handles the impossible case in the vectors.  If you see one of
  * these, then it's extremely serious, and could mean you have buggy hardware.
  * It never returns, and never tries to sync.  We hope that we can at least
-- 
1.9.3

