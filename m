Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab3IXFo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 01:44:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:48681 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3IXFoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 01:44:25 -0400
Message-ID: <1380001379.5443.28.camel@pasglop>
Subject: [PATCH v2] powerpc/irq: Run softirqs off the top of the irq stack
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Sep 2013 15:42:59 +1000
In-Reply-To: <1379889489.24090.34.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	 <1379889489.24090.34.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays, irq_exit() calls __do_softirq() pretty much directly
instead of calling do_softirq() which switches to the decicated
softirq stack.

This has lead to observed stack overflows on powerpc since we call
irq_enter() and irq_exit() outside of the scope that switches to
the irq stack.

This fixes it by moving the stack switching up a level, making
irq_enter() and irq_exit() run off the irq stack.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

v2: Garbage collect now empty handle_one_irq()

---
 arch/powerpc/include/asm/irq.h |   4 +-
 arch/powerpc/kernel/irq.c      | 104 ++++++++++++++++++++---------------------
 arch/powerpc/kernel/misc_32.S  |   9 ++--
 arch/powerpc/kernel/misc_64.S  |  10 ++--
 4 files changed, 62 insertions(+), 65 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 0e40843..41f13ce 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -69,9 +69,9 @@ extern struct thread_info *softirq_ctx[NR_CPUS];
 
 extern void irq_ctx_init(void);
 extern void call_do_softirq(struct thread_info *tp);
-extern int call_handle_irq(int irq, void *p1,
-			   struct thread_info *tp, void *func);
+extern void call_do_irq(struct pt_regs *regs, struct thread_info *tp);
 extern void do_IRQ(struct pt_regs *regs);
+extern void __do_irq(struct pt_regs *regs);
 
 int irq_choose_cpu(const struct cpumask *mask);
 
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index c69440c..2234a12 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -441,50 +441,6 @@ void migrate_irqs(void)
 }
 #endif
 
-static inline void handle_one_irq(unsigned int irq)
-{
-	struct thread_info *curtp, *irqtp;
-	unsigned long saved_sp_limit;
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	if (!desc)
-		return;
-
-	/* Switch to the irq stack to handle this */
-	curtp = current_thread_info();
-	irqtp = hardirq_ctx[smp_processor_id()];
-
-	if (curtp == irqtp) {
-		/* We're already on the irq stack, just handle it */
-		desc->handle_irq(irq, desc);
-		return;
-	}
-
-	saved_sp_limit = current->thread.ksp_limit;
-
-	irqtp->task = curtp->task;
-	irqtp->flags = 0;
-
-	/* Copy the softirq bits in preempt_count so that the
-	 * softirq checks work in the hardirq context. */
-	irqtp->preempt_count = (irqtp->preempt_count & ~SOFTIRQ_MASK) |
-			       (curtp->preempt_count & SOFTIRQ_MASK);
-
-	current->thread.ksp_limit = (unsigned long)irqtp +
-		_ALIGN_UP(sizeof(struct thread_info), 16);
-
-	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
-	current->thread.ksp_limit = saved_sp_limit;
-	irqtp->task = NULL;
-
-	/* Set any flag that may have been set on the
-	 * alternate stack
-	 */
-	if (irqtp->flags)
-		set_bits(irqtp->flags, &curtp->flags);
-}
-
 static inline void check_stack_overflow(void)
 {
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
@@ -501,9 +457,9 @@ static inline void check_stack_overflow(void)
 #endif
 }
 
-void do_IRQ(struct pt_regs *regs)
+void __do_irq(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	irq_enter();
@@ -519,18 +475,64 @@ void do_IRQ(struct pt_regs *regs)
 	 */
 	irq = ppc_md.get_irq();
 
-	/* We can hard enable interrupts now */
+	/* We can hard enable interrupts now to allow perf interrupts */
 	may_hard_irq_enable();
 
 	/* And finally process it */
-	if (irq != NO_IRQ)
-		handle_one_irq(irq);
-	else
+	if (unlikely(irq == NO_IRQ))
 		__get_cpu_var(irq_stat).spurious_irqs++;
+	else {
+		desc = irq_to_desc(irq);
+		if (likely(desc))
+			desc->handle_irq(irq, desc);
+	}
 
 	trace_irq_exit(regs);
 
 	irq_exit();
+}
+
+void do_IRQ(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct thread_info *curtp, *irqtp;
+	unsigned long saved_sp_limit;
+
+	/* Switch to the irq stack to handle this */
+	curtp = current_thread_info();
+	irqtp = hardirq_ctx[raw_smp_processor_id()];
+
+	/* Already there ? */
+	if (unlikely(curtp == irqtp)) {
+		__do_irq(regs);
+		set_irq_regs(old_regs);
+		return;
+	}
+
+	/* Adjust the stack limit */
+	saved_sp_limit = current->thread.ksp_limit;
+	current->thread.ksp_limit = (unsigned long)irqtp +
+		_ALIGN_UP(sizeof(struct thread_info), 16);
+
+
+	/* Prepare the thread_info in the irq stack */
+	irqtp->task = curtp->task;
+	irqtp->flags = 0;
+
+	/* Copy the preempt_count so that the [soft]irq checks work. */
+	irqtp->preempt_count = curtp->preempt_count;
+
+	/* Switch stack and call */
+	call_do_irq(regs, irqtp);
+
+	/* Restore stack limit */
+	current->thread.ksp_limit = saved_sp_limit;
+	irqtp->task = NULL;
+
+	/* Copy back updates to the thread_info */
+	if (irqtp->flags)
+		set_bits(irqtp->flags, &curtp->flags);
+
 	set_irq_regs(old_regs);
 }
 
@@ -592,12 +594,10 @@ void irq_ctx_init(void)
 		memset((void *)softirq_ctx[i], 0, THREAD_SIZE);
 		tp = softirq_ctx[i];
 		tp->cpu = i;
-		tp->preempt_count = 0;
 
 		memset((void *)hardirq_ctx[i], 0, THREAD_SIZE);
 		tp = hardirq_ctx[i];
 		tp->cpu = i;
-		tp->preempt_count = HARDIRQ_OFFSET;
 	}
 }
 
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 777d999..7da3882 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -47,13 +47,12 @@ _GLOBAL(call_do_softirq)
 	mtlr	r0
 	blr
 
-_GLOBAL(call_handle_irq)
+_GLOBAL(call_do_irq)
 	mflr	r0
 	stw	r0,4(r1)
-	mtctr	r6
-	stwu	r1,THREAD_SIZE-STACK_FRAME_OVERHEAD(r5)
-	mr	r1,r5
-	bctrl
+	stwu	r1,THREAD_SIZE-STACK_FRAME_OVERHEAD(r4)
+	mr	r1,r4
+	bl	__do_irq
 	lwz	r1,0(r1)
 	lwz	r0,4(r1)
 	mtlr	r0
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 971d7e7..e59caf8 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -40,14 +40,12 @@ _GLOBAL(call_do_softirq)
 	mtlr	r0
 	blr
 
-_GLOBAL(call_handle_irq)
-	ld	r8,0(r6)
+_GLOBAL(call_do_irq)
 	mflr	r0
 	std	r0,16(r1)
-	mtctr	r8
-	stdu	r1,THREAD_SIZE-STACK_FRAME_OVERHEAD(r5)
-	mr	r1,r5
-	bctrl
+	stdu	r1,THREAD_SIZE-STACK_FRAME_OVERHEAD(r4)
+	mr	r1,r4
+	bl	.__do_irq
 	ld	r1,0(r1)
 	ld	r0,16(r1)
 	mtlr	r0


