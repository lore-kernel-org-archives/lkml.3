Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3KKORy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:17:54 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43709 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3KKORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:17:41 -0500
Date: Mon, 11 Nov 2013 15:17:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] IRQ changes for v3.13
Message-ID: <20131111141738.GA9987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   # HEAD: 5702941eec32cfd7b8cf9e36a0936e48170011a4 irqchip: bcm2835: Convert to use IRQCHIP_DECLARE macro

The biggest change this cycle are the softirq/hardirq stack interaction 
and nesting fixes, cleanups and reorganizations from Frederic. This is the 
longer followup story to the softirq nesting fix that is already upstream:

       ded797547548 irq: Force hardirq exit's softirq processing on its own stack

 Thanks,

	Ingo

------------------>
Axel Lin (1):
      irqchip: bcm2835: Convert to use IRQCHIP_DECLARE macro

Frederic Weisbecker (7):
      irq: Consolidate do_softirq() arch overriden implementations
      irq: Optimize call to softirq on hardirq exit
      irq: Improve a bit softirq debugging
      irq: Justify the various softirq stack choices
      irq: Optimize softirq stack selection in irq exit
      x86: Tell about irq stack coverage
      powerpc: Tell about irq stack coverage

Yanchuan Nian (1):
      x86/irq: Correct comment about i8259 initialization


 arch/Kconfig                    | 10 ++++++++
 arch/arm/mach-bcm2835/bcm2835.c |  5 ++--
 arch/metag/kernel/irq.c         | 52 ++++++++++++++-----------------------
 arch/parisc/kernel/irq.c        | 17 ++----------
 arch/powerpc/Kconfig            |  1 +
 arch/powerpc/kernel/irq.c       | 17 +-----------
 arch/s390/kernel/irq.c          | 52 +++++++++++++++----------------------
 arch/sh/kernel/irq.c            | 57 +++++++++++++++--------------------------
 arch/sparc/kernel/irq_64.c      | 31 ++++++++--------------
 arch/x86/Kconfig                |  1 +
 arch/x86/kernel/entry_64.S      |  4 +--
 arch/x86/kernel/i8259.c         |  3 +--
 arch/x86/kernel/irq_32.c        | 30 ++++++----------------
 arch/x86/kernel/irq_64.c        | 21 ---------------
 drivers/irqchip/irq-bcm2835.c   | 22 ++++++++--------
 include/linux/interrupt.h       | 11 ++++++++
 include/linux/irqchip/bcm2835.h | 29 ---------------------
 kernel/softirq.c                | 37 +++++++++++++++++---------
 18 files changed, 145 insertions(+), 255 deletions(-)
 delete mode 100644 include/linux/irqchip/bcm2835.h

diff --git a/arch/Kconfig b/arch/Kconfig
index af2cc6e..ad95133 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -390,6 +390,16 @@ config HAVE_UNDERSCORE_SYMBOL_PREFIX
 	  Some architectures generate an _ in front of C symbols; things like
 	  module loading and assembly files need to know about this.
 
+config HAVE_IRQ_EXIT_ON_IRQ_STACK
+	bool
+	help
+	  Architecture doesn't only execute the irq handler on the irq stack
+	  but also irq_exit(). This way we can process softirqs on this irq
+	  stack instead of switching to a new one when we call __do_softirq()
+	  in the end of an hardirq.
+	  This spares a stack switch and improves cache usage on softirq
+	  processing.
+
 #
 # ABI hall of shame
 #
diff --git a/arch/arm/mach-bcm2835/bcm2835.c b/arch/arm/mach-bcm2835/bcm2835.c
index 40686d7..a4abd85 100644
--- a/arch/arm/mach-bcm2835/bcm2835.c
+++ b/arch/arm/mach-bcm2835/bcm2835.c
@@ -14,7 +14,7 @@
 
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/irqchip/bcm2835.h>
+#include <linux/irqchip.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/clk/bcm2835.h>
@@ -131,8 +131,7 @@ static const char * const bcm2835_compat[] = {
 
 DT_MACHINE_START(BCM2835, "BCM2835")
 	.map_io = bcm2835_map_io,
-	.init_irq = bcm2835_init_irq,
-	.handle_irq = bcm2835_handle_irq,
+	.init_irq = irqchip_init,
 	.init_machine = bcm2835_init,
 	.init_time = clocksource_of_init,
 	.restart = bcm2835_restart,
diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
index 2a2c9d5..3b4b7f6 100644
--- a/arch/metag/kernel/irq.c
+++ b/arch/metag/kernel/irq.c
@@ -159,44 +159,30 @@ void irq_ctx_exit(int cpu)
 
 extern asmlinkage void __do_softirq(void);
 
-asmlinkage void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	unsigned long flags;
 	struct thread_info *curctx;
 	union irq_ctx *irqctx;
 	u32 *isp;
 
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	if (local_softirq_pending()) {
-		curctx = current_thread_info();
-		irqctx = softirq_ctx[smp_processor_id()];
-		irqctx->tinfo.task = curctx->task;
-
-		/* build the stack frame on the softirq stack */
-		isp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
-
-		asm volatile (
-			"MOV   D0.5,%0\n"
-			"SWAP  A0StP,D0.5\n"
-			"CALLR D1RtP,___do_softirq\n"
-			"MOV   A0StP,D0.5\n"
-			:
-			: "r" (isp)
-			: "memory", "cc", "D1Ar1", "D0Ar2", "D1Ar3", "D0Ar4",
-			  "D1Ar5", "D0Ar6", "D0Re0", "D1Re0", "D0.4", "D1RtP",
-			  "D0.5"
-			);
-		/*
-		 * Shouldn't happen, we returned above if in_interrupt():
-		 */
-		WARN_ON_ONCE(softirq_count());
-	}
-
-	local_irq_restore(flags);
+	curctx = current_thread_info();
+	irqctx = softirq_ctx[smp_processor_id()];
+	irqctx->tinfo.task = curctx->task;
+
+	/* build the stack frame on the softirq stack */
+	isp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+
+	asm volatile (
+		"MOV   D0.5,%0\n"
+		"SWAP  A0StP,D0.5\n"
+		"CALLR D1RtP,___do_softirq\n"
+		"MOV   A0StP,D0.5\n"
+		:
+		: "r" (isp)
+		: "memory", "cc", "D1Ar1", "D0Ar2", "D1Ar3", "D0Ar4",
+		  "D1Ar5", "D0Ar6", "D0Re0", "D1Re0", "D0.4", "D1RtP",
+		  "D0.5"
+		);
 }
 #endif
 
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 2e6443b..ef59276 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -499,22 +499,9 @@ static void execute_on_irq_stack(void *func, unsigned long param1)
 	*irq_stack_in_use = 1;
 }
 
-asmlinkage void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	__u32 pending;
-	unsigned long flags;
-
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	pending = local_softirq_pending();
-
-	if (pending)
-		execute_on_irq_stack(__do_softirq, 0);
-
-	local_irq_restore(flags);
+	execute_on_irq_stack(__do_softirq, 0);
 }
 #endif /* CONFIG_IRQSTACKS */
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 38f3b7e..b365d5c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,6 +138,7 @@ config PPC
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 57d286a..5c4adfc 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -593,7 +593,7 @@ void irq_ctx_init(void)
 	}
 }
 
-static inline void do_softirq_onstack(void)
+void do_softirq_own_stack(void)
 {
 	struct thread_info *curtp, *irqtp;
 
@@ -611,21 +611,6 @@ static inline void do_softirq_onstack(void)
 		set_bits(irqtp->flags, &curtp->flags);
 }
 
-void do_softirq(void)
-{
-	unsigned long flags;
-
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	if (local_softirq_pending())
-		do_softirq_onstack();
-
-	local_irq_restore(flags);
-}
-
 irq_hw_number_t virq_to_hw(unsigned int virq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 8ac2097..bb27a26 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -157,39 +157,29 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
-asmlinkage void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	unsigned long flags, old, new;
-
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	if (local_softirq_pending()) {
-		/* Get current stack pointer. */
-		asm volatile("la %0,0(15)" : "=a" (old));
-		/* Check against async. stack address range. */
-		new = S390_lowcore.async_stack;
-		if (((new - old) >> (PAGE_SHIFT + THREAD_ORDER)) != 0) {
-			/* Need to switch to the async. stack. */
-			new -= STACK_FRAME_OVERHEAD;
-			((struct stack_frame *) new)->back_chain = old;
-
-			asm volatile("   la    15,0(%0)\n"
-				     "   basr  14,%2\n"
-				     "   la    15,0(%1)\n"
-				     : : "a" (new), "a" (old),
-				         "a" (__do_softirq)
-				     : "0", "1", "2", "3", "4", "5", "14",
-				       "cc", "memory" );
-		} else {
-			/* We are already on the async stack. */
-			__do_softirq();
-		}
+	unsigned long old, new;
+
+	/* Get current stack pointer. */
+	asm volatile("la %0,0(15)" : "=a" (old));
+	/* Check against async. stack address range. */
+	new = S390_lowcore.async_stack;
+	if (((new - old) >> (PAGE_SHIFT + THREAD_ORDER)) != 0) {
+		/* Need to switch to the async. stack. */
+		new -= STACK_FRAME_OVERHEAD;
+		((struct stack_frame *) new)->back_chain = old;
+		asm volatile("   la    15,0(%0)\n"
+			     "   basr  14,%2\n"
+			     "   la    15,0(%1)\n"
+			     : : "a" (new), "a" (old),
+			         "a" (__do_softirq)
+			     : "0", "1", "2", "3", "4", "5", "14",
+			       "cc", "memory" );
+	} else {
+		/* We are already on the async stack. */
+		__do_softirq();
 	}
-
-	local_irq_restore(flags);
 }
 
 /*
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 063af10..0833736 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -149,47 +149,32 @@ void irq_ctx_exit(int cpu)
 	hardirq_ctx[cpu] = NULL;
 }
 
-asmlinkage void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	unsigned long flags;
 	struct thread_info *curctx;
 	union irq_ctx *irqctx;
 	u32 *isp;
 
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	if (local_softirq_pending()) {
-		curctx = current_thread_info();
-		irqctx = softirq_ctx[smp_processor_id()];
-		irqctx->tinfo.task = curctx->task;
-		irqctx->tinfo.previous_sp = current_stack_pointer;
-
-		/* build the stack frame on the softirq stack */
-		isp = (u32 *)((char *)irqctx + sizeof(*irqctx));
-
-		__asm__ __volatile__ (
-			"mov	r15, r9		\n"
-			"jsr	@%0		\n"
-			/* switch to the softirq stack */
-			" mov	%1, r15		\n"
-			/* restore the thread stack */
-			"mov	r9, r15		\n"
-			: /* no outputs */
-			: "r" (__do_softirq), "r" (isp)
-			: "memory", "r0", "r1", "r2", "r3", "r4",
-			  "r5", "r6", "r7", "r8", "r9", "r15", "t", "pr"
-		);
-
-		/*
-		 * Shouldn't happen, we returned above if in_interrupt():
-		 */
-		WARN_ON_ONCE(softirq_count());
-	}
-
-	local_irq_restore(flags);
+	curctx = current_thread_info();
+	irqctx = softirq_ctx[smp_processor_id()];
+	irqctx->tinfo.task = curctx->task;
+	irqctx->tinfo.previous_sp = current_stack_pointer;
+
+	/* build the stack frame on the softirq stack */
+	isp = (u32 *)((char *)irqctx + sizeof(*irqctx));
+
+	__asm__ __volatile__ (
+		"mov	r15, r9		\n"
+		"jsr	@%0		\n"
+		/* switch to the softirq stack */
+		" mov	%1, r15		\n"
+		/* restore the thread stack */
+		"mov	r9, r15		\n"
+		: /* no outputs */
+		: "r" (__do_softirq), "r" (isp)
+		: "memory", "r0", "r1", "r2", "r3", "r4",
+		  "r5", "r6", "r7", "r8", "r9", "r15", "t", "pr"
+	);
 }
 #else
 static inline void handle_one_irq(unsigned int irq)
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index d4840ce..666193f 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -698,30 +698,19 @@ void __irq_entry handler_irq(int pil, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	unsigned long flags;
-
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
+	void *orig_sp, *sp = softirq_stack[smp_processor_id()];
 
-	if (local_softirq_pending()) {
-		void *orig_sp, *sp = softirq_stack[smp_processor_id()];
-
-		sp += THREAD_SIZE - 192 - STACK_BIAS;
-
-		__asm__ __volatile__("mov %%sp, %0\n\t"
-				     "mov %1, %%sp"
-				     : "=&r" (orig_sp)
-				     : "r" (sp));
-		__do_softirq();
-		__asm__ __volatile__("mov %0, %%sp"
-				     : : "r" (orig_sp));
-	}
+	sp += THREAD_SIZE - 192 - STACK_BIAS;
 
-	local_irq_restore(flags);
+	__asm__ __volatile__("mov %%sp, %0\n\t"
+			     "mov %1, %%sp"
+			     : "=&r" (orig_sp)
+			     : "r" (sp));
+	__do_softirq();
+	__asm__ __volatile__("mov %0, %%sp"
+			     : : "r" (orig_sp));
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..99eb1cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b077f4c..083da7c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1342,7 +1342,7 @@ bad_gs:
 	.previous
 
 /* Call softirq on interrupt stack. Interrupts are off. */
-ENTRY(call_softirq)
+ENTRY(do_softirq_own_stack)
 	CFI_STARTPROC
 	pushq_cfi %rbp
 	CFI_REL_OFFSET rbp,0
@@ -1359,7 +1359,7 @@ ENTRY(call_softirq)
 	decl PER_CPU_VAR(irq_count)
 	ret
 	CFI_ENDPROC
-END(call_softirq)
+END(do_softirq_own_stack)
 
 #ifdef CONFIG_XEN
 zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 9a5c460..2e977b5 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -312,8 +312,7 @@ static void init_8259A(int auto_eoi)
 	 */
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
-	   to 0x20-0x27 on i386 */
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 
 	/* 8259A-1 (the master) has a slave on IR2 */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4186755..8a5bb01 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -149,35 +149,21 @@ void irq_ctx_init(int cpu)
 	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
 }
 
-asmlinkage void do_softirq(void)
+void do_softirq_own_stack(void)
 {
-	unsigned long flags;
 	struct thread_info *curctx;
 	union irq_ctx *irqctx;
 	u32 *isp;
 
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-
-	if (local_softirq_pending()) {
-		curctx = current_thread_info();
-		irqctx = __this_cpu_read(softirq_ctx);
-		irqctx->tinfo.task = curctx->task;
-		irqctx->tinfo.previous_esp = current_stack_pointer;
-
-		/* build the stack frame on the softirq stack */
-		isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
+	curctx = current_thread_info();
+	irqctx = __this_cpu_read(softirq_ctx);
+	irqctx->tinfo.task = curctx->task;
+	irqctx->tinfo.previous_esp = current_stack_pointer;
 
-		call_on_stack(__do_softirq, isp);
-		/*
-		 * Shouldn't happen, we returned above if in_interrupt():
-		 */
-		WARN_ON_ONCE(softirq_count());
-	}
+	/* build the stack frame on the softirq stack */
+	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 
-	local_irq_restore(flags);
+	call_on_stack(__do_softirq, isp);
 }
 
 bool handle_irq(unsigned irq, struct pt_regs *regs)
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index d04d3ec..4d1c746 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -87,24 +87,3 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	generic_handle_irq_desc(irq, desc);
 	return true;
 }
-
-
-extern void call_softirq(void);
-
-asmlinkage void do_softirq(void)
-{
-	__u32 pending;
-	unsigned long flags;
-
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-	pending = local_softirq_pending();
-	/* Switch to interrupt stack */
-	if (pending) {
-		call_softirq();
-		WARN_ON_ONCE(softirq_count());
-	}
-	local_irq_restore(flags);
-}
diff --git a/drivers/irqchip/irq-bcm2835.c b/drivers/irqchip/irq-bcm2835.c
index 16c78f1..1693b8e 100644
--- a/drivers/irqchip/irq-bcm2835.c
+++ b/drivers/irqchip/irq-bcm2835.c
@@ -49,9 +49,11 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/irqdomain.h>
-#include <linux/irqchip/bcm2835.h>
 
 #include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
 
 /* Put the bank and irq (32 bits) into the hwirq */
 #define MAKE_HWIRQ(b, n)	((b << 5) | (n))
@@ -93,6 +95,8 @@ struct armctrl_ic {
 };
 
 static struct armctrl_ic intc __read_mostly;
+static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+	struct pt_regs *regs);
 
 static void armctrl_mask_irq(struct irq_data *d)
 {
@@ -164,17 +168,9 @@ static int __init armctrl_of_init(struct device_node *node,
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 	}
-	return 0;
-}
-
-static struct of_device_id irq_of_match[] __initconst = {
-	{ .compatible = "brcm,bcm2835-armctrl-ic", .data = armctrl_of_init },
-	{ }
-};
 
-void __init bcm2835_init_irq(void)
-{
-	of_irq_init(irq_of_match);
+	set_handle_irq(bcm2835_handle_irq);
+	return 0;
 }
 
 /*
@@ -200,7 +196,7 @@ static void armctrl_handle_shortcut(int bank, struct pt_regs *regs,
 	handle_IRQ(irq_linear_revmap(intc.domain, irq), regs);
 }
 
-asmlinkage void __exception_irq_entry bcm2835_handle_irq(
+static asmlinkage void __exception_irq_entry bcm2835_handle_irq(
 	struct pt_regs *regs)
 {
 	u32 stat, irq;
@@ -222,3 +218,5 @@ asmlinkage void __exception_irq_entry bcm2835_handle_irq(
 		}
 	}
 }
+
+IRQCHIP_DECLARE(bcm2835_armctrl_ic, "brcm,bcm2835-armctrl-ic", armctrl_of_init);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5e865b5..c9e831d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -19,6 +19,7 @@
 
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
+#include <asm/irq.h>
 
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
@@ -374,6 +375,16 @@ struct softirq_action
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
+
+#ifdef __ARCH_HAS_DO_SOFTIRQ
+void do_softirq_own_stack(void);
+#else
+static inline void do_softirq_own_stack(void)
+{
+	__do_softirq();
+}
+#endif
+
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
 extern void __raise_softirq_irqoff(unsigned int nr);
diff --git a/include/linux/irqchip/bcm2835.h b/include/linux/irqchip/bcm2835.h
deleted file mode 100644
index 48a859b..0000000
--- a/include/linux/irqchip/bcm2835.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Copyright (C) 2010 Broadcom
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#ifndef __LINUX_IRQCHIP_BCM2835_H_
-#define __LINUX_IRQCHIP_BCM2835_H_
-
-#include <asm/exception.h>
-
-extern void bcm2835_init_irq(void);
-
-extern asmlinkage void __exception_irq_entry bcm2835_handle_irq(
-	struct pt_regs *regs);
-
-#endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d7d498d..dacd0ab 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -29,7 +29,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
 
-#include <asm/irq.h>
 /*
    - No shared variables, all the data are CPU local.
    - If a softirq needs serialization, let it serialize itself
@@ -134,7 +133,6 @@ EXPORT_SYMBOL(local_bh_disable);
 
 static void __local_bh_enable(unsigned int cnt)
 {
-	WARN_ON_ONCE(in_irq());
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
@@ -149,6 +147,7 @@ static void __local_bh_enable(unsigned int cnt)
  */
 void _local_bh_enable(void)
 {
+	WARN_ON_ONCE(in_irq());
 	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
 
@@ -171,8 +170,13 @@ static inline void _local_bh_enable_ip(unsigned long ip)
  	 */
 	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
 
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
+	if (unlikely(!in_interrupt() && local_softirq_pending())) {
+		/*
+		 * Run softirq if any pending. And do it in its own stack
+		 * as we may be calling this deep in a task call stack already.
+		 */
 		do_softirq();
+	}
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -280,10 +284,11 @@ restart:
 
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
+	WARN_ON_ONCE(in_interrupt());
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-#ifndef __ARCH_HAS_DO_SOFTIRQ
+
 
 asmlinkage void do_softirq(void)
 {
@@ -298,13 +303,11 @@ asmlinkage void do_softirq(void)
 	pending = local_softirq_pending();
 
 	if (pending)
-		__do_softirq();
+		do_softirq_own_stack();
 
 	local_irq_restore(flags);
 }
 
-#endif
-
 /*
  * Enter an interrupt context.
  */
@@ -329,15 +332,21 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
+#ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
 		 * it is the irq stack, because it should be near empty
-		 * at this stage. But we have no way to know if the arch
-		 * calls irq_exit() on the irq stack. So call softirq
-		 * in its own stack to prevent from any overrun on top
-		 * of a potentially deep task stack.
+		 * at this stage.
 		 */
-		do_softirq();
+		__do_softirq();
+#else
+		/*
+		 * Otherwise, irq_exit() is called on the task stack that can
+		 * be potentially deep already. So call softirq in its own stack
+		 * to prevent from any overrun.
+		 */
+		do_softirq_own_stack();
+#endif
 	} else {
 		wakeup_softirqd();
 	}
@@ -771,6 +780,10 @@ static void run_ksoftirqd(unsigned int cpu)
 {
 	local_irq_disable();
 	if (local_softirq_pending()) {
+		/*
+		 * We can safely run softirq on inline stack, as we are not deep
+		 * in the task stack here.
+		 */
 		__do_softirq();
 		rcu_note_context_switch(cpu);
 		local_irq_enable();
