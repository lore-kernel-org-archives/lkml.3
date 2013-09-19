Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3ISPPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:15:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:36239 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3ISPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:15:01 -0400
Date: Thu, 19 Sep 2013 17:14:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

On Wed, 18 Sep 2013, Thomas Gleixner wrote:
> The low level entry code is fiddling with preempt_count by adding
> HARDIRQ_OFFSET to it to keep track of nested interrupts. If the count
> goes to 0, it invokes do_softirq(). And you have another safety guard:
> 
> ret_from_last_interrupt:
>         moveq   #(~ALLOWINT>>8)&0xff,%d0
> 	andb    %sp@(PT_OFF_SR),%d0
> 	jne     2b
> 
> That's due to the irq priority level stuff, which results in nested
> interrupts depending on the level of the serviced interrupt, right?
> And that's why you fiddle yourself with the HARDIRQ bits in the
> preempt count to prevent the core code from calling do_softirq().
> 
> Though this scheme also prevents that other parts of irq_exit() are
> working correctly, because they depend on the hardirq count being
> zero, e.g. the nohz code.
> 
> Needs more thoughts how to fix that w/o wasting precious bits for the
> HARDIRQ count.

So after staring a while into the m68k code I came up with the
following (untested and uncompiled) solution:

Instead of doing the HARDIRQ fiddling and the softirq handling from
the low level entry code, I provided an irq_exit_nested() variant
which has an argument to tell the core code, that it shouldn't invoke
softirq handling and the nohz exit code. That way 4 HARDIRQ bits in
preempt_count() should be sufficient and we can move them around as we
see fit without being bound by some magic asm code fiddling with it.

By modifying do_IRQ to return an indicator whether this is the last
irq in the chain, we can also simplify the asm code significantly.

Can you have a look with m68k eyes on that please? I'm sure that my
vague memory of the 68k ASM tricked me into doing something
fundamentally wrong :)

Thanks,

	tglx
---
Subject: m68k: Deal with interrupt nesting in the core code
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 18 Sep 2013 11:56:58 +0200

m68k increments the HARDIRQ part of preempt_count in the low level
interrupt entry code, which prevents the core code from restructuring
the preempt_count layout.

This is done to prevent softirq invocation for
nested interrupts. The nesting can happen due to the interrupt
priority scheme of the 68k.

This patch removes the low level handling and moves it to the
interrupt core code by providing an irq_exit_nested() variant. The
nested argument to this function tells the core code whether to invoke
softirqs or not.

Also let do_IRQ() and the other handler variants return the nest
indicator so the low level entry code can utilize this to select
either immediate return or the expensive work functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/include/asm/irq.h      |    2 +-
 arch/m68k/kernel/entry.S         |   36 +++++++++---------------------------
 arch/m68k/kernel/ints.c          |    6 ------
 arch/m68k/kernel/irq.c           |    7 ++++---
 arch/m68k/platform/68000/entry.S |   19 ++++++-------------
 arch/m68k/platform/68000/ints.c  |    7 +++----
 arch/m68k/platform/68360/entry.S |   25 ++++++++-----------------
 arch/m68k/q40/q40ints.c          |   12 ++++++------
 include/linux/hardirq.h          |    1 +
 kernel/softirq.c                 |   15 +++++++++++----
 10 files changed, 49 insertions(+), 81 deletions(-)

Index: linux-2.6/arch/m68k/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/irq.h
+++ linux-2.6/arch/m68k/include/asm/irq.h
@@ -74,7 +74,7 @@ extern unsigned int irq_canonicalize(uns
 #define irq_canonicalize(irq)  (irq)
 #endif /* !(CONFIG_M68020 || CONFIG_M68030 || CONFIG_M68040 || CONFIG_M68060) */
 
-asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
+asmlinkage int do_IRQ(int irq, struct pt_regs *regs);
 extern atomic_t irq_err_count;
 
 #endif /* _M68K_IRQ_H_ */
Index: linux-2.6/arch/m68k/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/entry.S
+++ linux-2.6/arch/m68k/kernel/entry.S
@@ -274,9 +274,6 @@ do_delayed_trace:
 
 ENTRY(auto_inthandler)
 	SAVE_ALL_INT
-	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 	subw	#VEC_SPUR,%d0
@@ -284,34 +281,22 @@ ENTRY(auto_inthandler)
 	movel	%sp,%sp@-
 	movel	%d0,%sp@-		|  put vector # on stack
 auto_irqhandler_fixup = . + 2
-	jsr	do_IRQ			|  process the IRQ
+	jsr	do_IRQ			|  process the IRQ, returns nest level
 	addql	#8,%sp			|  pop parameters off stack
 
 ret_from_interrupt:
-	movel	%curptr@(TASK_STACK),%a1
-	subqb	#1,%a1@(TINFO_PREEMPT+1)
-	jeq	ret_from_last_interrupt
-2:	RESTORE_ALL
-
-	ALIGN
-ret_from_last_interrupt:
-	moveq	#(~ALLOWINT>>8)&0xff,%d0
-	andb	%sp@(PT_OFF_SR),%d0
-	jne	2b
-
-	/* check if we need to do software interrupts */
-	tstl	irq_stat+CPUSTAT_SOFTIRQ_PENDING
+	/*
+	 * Only the last interrupt leaving the kernel goes through the
+	 * various exception return checks.
+	 */
+	cmpl	#0, %d0
 	jeq	.Lret_from_exception
-	pea	ret_from_exception
-	jra	do_softirq
+	RESTORE_ALL
 
 /* Handler for user defined interrupt vectors */
 
 ENTRY(user_inthandler)
 	SAVE_ALL_INT
-	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 user_irqvec_fixup = . + 2
@@ -319,13 +304,10 @@ user_irqvec_fixup = . + 2
 
 	movel	%sp,%sp@-
 	movel	%d0,%sp@-		|  put vector # on stack
-	jsr	do_IRQ			|  process the IRQ
+	jsr	do_IRQ			|  process the IRQ, returns nest level
 	addql	#8,%sp			|  pop parameters off stack
 
-	movel	%curptr@(TASK_STACK),%a1
-	subqb	#1,%a1@(TINFO_PREEMPT+1)
-	jeq	ret_from_last_interrupt
-	RESTORE_ALL
+	jra	ret_from_interrupt
 
 /* Handler for uninitialized and spurious interrupts */
 
Index: linux-2.6/arch/m68k/kernel/ints.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/ints.c
+++ linux-2.6/arch/m68k/kernel/ints.c
@@ -58,12 +58,6 @@ void __init init_IRQ(void)
 {
 	int i;
 
-	/* assembly irq entry code relies on this... */
-	if (HARDIRQ_MASK != 0x00ff0000) {
-		extern void hardirq_mask_is_broken(void);
-		hardirq_mask_is_broken();
-	}
-
 	for (i = IRQ_AUTO_1; i <= IRQ_AUTO_7; i++)
 		irq_set_chip_and_handler(i, &auto_irq_chip, handle_simple_irq);
 
Index: linux-2.6/arch/m68k/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/irq.c
+++ linux-2.6/arch/m68k/kernel/irq.c
@@ -17,18 +17,19 @@
 #include <linux/seq_file.h>
 #include <asm/traps.h>
 
-asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
+asmlinkage int do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *oldregs = set_irq_regs(regs);
+	int nested = regs->sr & ~ALLOWINT;
 
 	irq_enter();
 	generic_handle_irq(irq);
-	irq_exit();
+	irq_exit_nested(nested);
 
 	set_irq_regs(oldregs);
+	return nested;
 }
 
-
 /* The number of spurious interrupts */
 atomic_t irq_err_count;
 
Index: linux-2.6/arch/m68k/platform/68000/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/platform/68000/entry.S
+++ linux-2.6/arch/m68k/platform/68000/entry.S
@@ -217,20 +217,13 @@ inthandler:
 	bra	ret_from_interrupt
 
 ret_from_interrupt:
-	jeq	1f
-2:
-	RESTORE_ALL
-1:
-	moveb	%sp@(PT_OFF_SR), %d0
-	and	#7, %d0
-	jhi	2b
-
-	/* check if we need to do software interrupts */
+	/*
+	 * Only the last interrupt leaving the kernel goes through the
+	 * various exception return checks.
+	 */
+	cmpl	#0, %d0
 	jeq	ret_from_exception
-
-	pea	ret_from_exception
-	jra	do_softirq
-
+	RESTORE_ALL
 
 /*
  * Handler for uninitialized and spurious interrupts.
Index: linux-2.6/arch/m68k/platform/68000/ints.c
===================================================================
--- linux-2.6.orig/arch/m68k/platform/68000/ints.c
+++ linux-2.6/arch/m68k/platform/68000/ints.c
@@ -74,11 +74,9 @@ asmlinkage irqreturn_t inthandler7(void)
  * into one vector and look in the blasted mask register...
  * This code is designed to be fast, almost constant time, not clean!
  */
-void process_int(int vec, struct pt_regs *fp)
+int process_int(int vec, struct pt_regs *fp)
 {
-	int irq;
-	int mask;
-
+	int irq, mask, nested =fp->sr & ~ALLOWINT;
 	unsigned long pend = ISR;
 
 	while (pend) {
@@ -128,6 +126,7 @@ void process_int(int vec, struct pt_regs
 		do_IRQ(irq, fp);
 		pend &= ~mask;
 	}
+	return nested;
 }
 
 static void intc_irq_unmask(struct irq_data *d)
Index: linux-2.6/arch/m68k/platform/68360/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/platform/68360/entry.S
+++ linux-2.6/arch/m68k/platform/68360/entry.S
@@ -132,26 +132,17 @@ inthandler:
 
 	movel	%sp,%sp@-
 	movel	%d0,%sp@- 		/*  put vector # on stack*/
-	jbsr	do_IRQ			/*  process the IRQ*/
-3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	jbsr	do_IRQ			/*  process the IRQ, returns nest level */
+     	addql	#8,%sp			/*  pop parameters off stack*/
 
 ret_from_interrupt:
-	jeq	1f
-2:
-	RESTORE_ALL
-1:
-	moveb	%sp@(PT_OFF_SR), %d0
-	and	#7, %d0
-	jhi	2b
-	/* check if we need to do software interrupts */
-
-	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
+	/*
+	 * Only the last interrupt leaving the kernel goes through the
+	 * various exception return checks.
+	 */
+	cmpl	#0, %d0
 	jeq	ret_from_exception
-
-	pea	ret_from_exception
-	jra	do_softirq
-
+	RESTORE_ALL
 
 /*
  * Handler for uninitialized and spurious interrupts.
Index: linux-2.6/arch/m68k/q40/q40ints.c
===================================================================
--- linux-2.6.orig/arch/m68k/q40/q40ints.c
+++ linux-2.6/arch/m68k/q40/q40ints.c
@@ -202,10 +202,10 @@ static int aliased_irq=0;  /* how many t
 
 
 /* got interrupt, dispatch to ISA or keyboard/timer IRQs */
-static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
+static int q40_irq_handler(unsigned int irq, struct pt_regs *fp)
 {
 	unsigned mir, mer;
-	int i;
+	int i, nested = fp->sr & ~ALLOWINT;
 
 //repeat:
 	mir = master_inb(IIRQ_REG);
@@ -213,14 +213,14 @@ static void q40_irq_handler(unsigned int
 	if ((mir & Q40_IRQ_EXT_MASK) &&
 	    (master_inb(EIRQ_REG) & Q40_IRQ6_MASK)) {
 		floppy_hardint();
-		return;
+		return nested;
 	}
 #endif
 	switch (irq) {
 	case 4:
 	case 6:
 		do_IRQ(Q40_IRQ_SAMPLE, fp);
-		return;
+		return nested;
 	}
 	if (mir & Q40_IRQ_FRAME_MASK) {
 		do_IRQ(Q40_IRQ_FRAME, fp);
@@ -277,7 +277,7 @@ static void q40_irq_handler(unsigned int
 #endif
 				}
 // used to do 'goto repeat;' here, this delayed bh processing too long
-				return;
+				return nested;
 			}
 		}
 		if (mer && ccleirq > 0 && !aliased_irq) {
@@ -291,7 +291,7 @@ static void q40_irq_handler(unsigned int
 	if (mir & Q40_IRQ_KEYB_MASK)
 		do_IRQ(Q40_IRQ_KEYBOARD, fp);
 
-	return;
+	return nested;
 }
 
 void q40_irq_enable(struct irq_data *data)
Index: linux-2.6/include/linux/hardirq.h
===================================================================
--- linux-2.6.orig/include/linux/hardirq.h
+++ linux-2.6/include/linux/hardirq.h
@@ -55,6 +55,7 @@ extern void irq_enter(void);
 /*
  * Exit irq context and process softirqs if needed:
  */
+extern void irq_exit_nested(bool nested);
 extern void irq_exit(void);
 
 #define nmi_enter()						\
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -350,7 +350,7 @@ static inline void tick_irq_exit(void)
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
  */
-void irq_exit(void)
+void irq_exit_nested(bool nested)
 {
 #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
 	local_irq_disable();
@@ -361,13 +361,20 @@ void irq_exit(void)
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
 	sub_preempt_count(HARDIRQ_OFFSET);
-	if (!in_interrupt() && local_softirq_pending())
-		invoke_softirq();
 
-	tick_irq_exit();
+	if (!nested) {
+		if (!in_interrupt() && local_softirq_pending())
+			invoke_softirq();
+		tick_irq_exit();
+	}
 	rcu_irq_exit();
 }
 
+void irq_exit(void)
+{
+	irq_exit_nested(false);
+}
+
 /*
  * This function must run with irqs disabled!
  */
