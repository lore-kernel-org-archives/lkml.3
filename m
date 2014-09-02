Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIBNCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:02:11 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34850 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaIBNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:01:23 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v11 03/19] arm: fiq: Replace default FIQ handler
Date: Tue,  2 Sep 2014 14:00:37 +0100
Message-Id: <1409662853-29313-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
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
    not exist.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/entry-armv.S | 129 +++++++++++++++++++++++++++++++++++++++----
 arch/arm/kernel/fiq.c        |  19 +++++++
 arch/arm/kernel/setup.c      |   8 ++-
 3 files changed, 145 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 36276cd..ef64333 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -79,6 +79,15 @@
 #endif
 	.endm
 
+	.macro	fiq_handler
+	ldr	r1, =.LChandle_fiq
+	mov	r0, sp
+	adr	lr, BSYM(9998f)
+	ldr	pc, [r1]
+9998:
+	.endm
+
+
 #ifdef CONFIG_KPROBES
 	.section	.kprobes.text,"ax",%progbits
 #else
@@ -146,7 +155,7 @@ ENDPROC(__und_invalid)
 #define SPFIX(code...)
 #endif
 
-	.macro	svc_entry, stack_hole=0
+	.macro	svc_entry, stack_hole=0, call_trace=1
  UNWIND(.fnstart		)
  UNWIND(.save {r0 - pc}		)
 	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
@@ -183,10 +192,35 @@ ENDPROC(__und_invalid)
 	stmia	r7, {r2 - r6}
 
 #ifdef CONFIG_TRACE_IRQFLAGS
+	.if \call_trace
 	bl	trace_hardirqs_off
+	.endif
 #endif
 	.endm
 
+@
+@ svc_exit_via_fiq - similar to svc_exit but switches to FIQ mode before exit
+@
+@ This macro acts in a similar manner to svc_exit but switches to FIQ
+@ mode to restore the final part of the register state.
+@
+@ We cannot use the normal svc_exit procedure because that would
+@ clobber spsr_svc (FIQ could be delivered during the first few instructions
+@ of vector_swi meaning its contents have not been saved anywhere).
+@
+	.macro  svc_exit_via_fiq, rpsr
+
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
 	.align	5
 __dabt_svc:
 	svc_entry
@@ -295,6 +329,14 @@ __pabt_svc:
 ENDPROC(__pabt_svc)
 
 	.align	5
+__fiq_svc:
+	svc_entry 0, 0
+	fiq_handler
+	svc_exit_via_fiq r5
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
+
+	.align	5
 .LCcralign:
 	.word	cr_alignment
 #ifdef MULTI_DABORT
@@ -303,6 +345,43 @@ ENDPROC(__pabt_svc)
 #endif
 .LCfp:
 	.word	fp_enter
+.LChandle_fiq:
+#ifdef CONFIG_FIQ
+	.word	fiq_nmi_handler
+#else
+	.word	do_unexp_fiq
+#endif
+
+/*
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
+	svc_entry 0, 0
+
+	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
+	mov	r0, lr		@ Save lr_abt
+	mrs	r1, spsr	@ Save spsr_abt, abort is now safe
+	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
+	push	{r0 - r1}
+
+	fiq_handler
+
+	pop	{r0 - r1}
+	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
+	mov	lr, r0		@ Restore lr_abt, abort is unsafe
+	msr	spsr_cxsf, r1	@ Restore spsr_abt
+	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
+
+	svc_exit_via_fiq r5
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
 
 /*
  * User mode handlers
@@ -683,6 +762,17 @@ ENTRY(ret_from_exception)
 ENDPROC(__pabt_usr)
 ENDPROC(ret_from_exception)
 
+	.align	5
+__fiq_usr:
+	usr_entry
+	kuser_cmpxchg_check
+	fiq_handler
+	get_thread_info tsk
+	mov	why, #0
+	b	ret_to_user_from_irq
+ UNWIND(.fnend		)
+ENDPROC(__fiq_usr)
+
 /*
  * Register switch for ARMv3 and ARMv4 processors
  * r0 = previous task_struct, r1 = previous thread_info, r2 = next thread_info
@@ -1118,17 +1208,36 @@ vector_addrexcptn:
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
+ * systems. The runtime environment for NMIs is extremely restrictive
+ * (NMIs can pre-empt critical sections meaning almost all locking is
+ * forbidden) meaning this default FIQ handling must only be used in
+ * circumstances where non-maskability improves robustness, such as
+ * watchdog or debug logic.
+ *
+ * This handler is inappropriate for high performance (fast) interrupt
+ * servicing and can be overridden using set_fiq_handler.
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
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 3ccaa8c..77c62b2 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -43,11 +43,14 @@
 #include <linux/irq.h>
 #include <linux/radix-tree.h>
 #include <linux/slab.h>
+#include <linux/irqchip/arm-gic.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
+#include <asm/exception.h>
 #include <asm/fiq.h>
 #include <asm/irq.h>
+#include <asm/kgdb.h>
 #include <asm/traps.h>
 
 #define FIQ_OFFSET ({					\
@@ -216,6 +219,22 @@ bool has_fiq(int fiq)
 }
 EXPORT_SYMBOL(has_fiq);
 
+asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	nmi_enter();
+
+	/* these callbacks deliberately avoid using a notifier chain in
+	 * order to ensure code review happens (drivers cannot "secretly"
+	 * employ FIQ without modifying this chain of calls).
+	 */
+	/* list is currently empty */
+
+	nmi_exit();
+	set_irq_regs(old_regs);
+}
+
 EXPORT_SYMBOL(set_fiq_handler);
 EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
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
-- 
1.9.3

