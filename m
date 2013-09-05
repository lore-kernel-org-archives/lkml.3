Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3IEPdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:33:36 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62029 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3IEPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:33:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] irq: Consolidate do_softirq() arch overriden implementations
Date: Thu,  5 Sep 2013 17:33:22 +0200
Message-Id: <1378395204-25342-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
References: <1378330796.4321.50.camel@pasglop>
 <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All arch's overriden implementation of do_softirq() do the same:
disabled irqs, check if there are softirqs pending, then execute
__do_softirq() it a specific stack.

Consolidate the common parts such that arch only worry about the
stack switch.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/metag/kernel/irq.c    |   56 +++++++++++++++++------------------------
 arch/parisc/kernel/irq.c   |   17 +-----------
 arch/powerpc/kernel/irq.c  |   17 +-----------
 arch/s390/kernel/irq.c     |   52 +++++++++++++++----------------------
 arch/sh/kernel/irq.c       |   60 ++++++++++++++++++-------------------------
 arch/sparc/kernel/irq_64.c |   31 +++++++---------------
 arch/x86/kernel/irq_32.c   |   34 +++++++++----------------
 arch/x86/kernel/irq_64.c   |   18 ++-----------
 include/linux/interrupt.h  |   11 ++++++++
 kernel/softirq.c           |    7 +---
 10 files changed, 110 insertions(+), 193 deletions(-)

diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
index 2a2c9d5..12a12b4 100644
--- a/arch/metag/kernel/irq.c
+++ b/arch/metag/kernel/irq.c
@@ -159,44 +159,34 @@ void irq_ctx_exit(int cpu)
 
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
+	/*
+	 * Shouldn't happen, we returned above if in_interrupt():
+	 */
+	WARN_ON_ONCE(softirq_count());
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
 
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index c69440c..7d0da88 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -601,7 +601,7 @@ void irq_ctx_init(void)
 	}
 }
 
-static inline void do_softirq_onstack(void)
+void do_softirq_own_stack(void)
 {
 	struct thread_info *curtp, *irqtp;
 	unsigned long saved_sp_limit = current->thread.ksp_limit;
@@ -623,21 +623,6 @@ static inline void do_softirq_onstack(void)
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
index 54b0995..c289daa 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -124,39 +124,29 @@ skip_arch_irqs:
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
 
 #ifdef CONFIG_PROC_FS
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 063af10..50ecd48 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -149,47 +149,37 @@ void irq_ctx_exit(int cpu)
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
+	/*
+	 * Shouldn't happen, we returned above if in_interrupt():
+	 */
+	WARN_ON_ONCE(softirq_count());
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
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4186755..1036f03 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -149,35 +149,25 @@ void irq_ctx_init(int cpu)
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
+	/*
+	 * Shouldn't happen, we returned above if in_interrupt():
+	 */
+	WARN_ON_ONCE(softirq_count());
 }
 
 bool handle_irq(unsigned irq, struct pt_regs *regs)
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index d04d3ec..8dd8c96 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -91,20 +91,8 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 
 extern void call_softirq(void);
 
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
-	pending = local_softirq_pending();
-	/* Switch to interrupt stack */
-	if (pending) {
-		call_softirq();
-		WARN_ON_ONCE(softirq_count());
-	}
-	local_irq_restore(flags);
+	call_softirq();
+	WARN_ON_ONCE(softirq_count());
 }
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..6554954 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -19,6 +19,7 @@
 
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
+#include <asm/irq.h>
 
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
@@ -443,6 +444,16 @@ struct softirq_action
 
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index be3d351..39d27ff 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -29,7 +29,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
 
-#include <asm/irq.h>
 /*
    - No shared variables, all the data are CPU local.
    - If a softirq needs serialization, let it serialize itself
@@ -283,7 +282,7 @@ restart:
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-#ifndef __ARCH_HAS_DO_SOFTIRQ
+
 
 asmlinkage void do_softirq(void)
 {
@@ -298,13 +297,11 @@ asmlinkage void do_softirq(void)
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
-- 
1.7.5.4

