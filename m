Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3KDTow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:44:52 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:48576 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3KDTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:44:49 -0500
Date: Mon, 4 Nov 2013 20:44:43 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andreas Schwab <schwab@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
 <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Thomas,

On Mon, 4 Nov 2013, Thomas Gleixner wrote:
> On Thu, 19 Sep 2013, Geert Uytterhoeven wrote:
> > However, the resulting kernel hangs (on ARAnyM) after starting userspace:
> > 
> > | INIT: version 2.86 booting
> > 
> > I'll have a deeper look when I have some more time...
> 
> Any chance that you find some more time? :)

Sure!

But only if you look at "[m68k] IRQ: add handle_polled_irq() for timer
based soft interrupt" (http://www.spinics.net/lists/linux-m68k/msg05889.html)
first ;-)

Below is a patch with some fixups, on top of your two patches.

Unfortunately it still hangs somewhere after mounting the root filesystem.

Using this debug code for do_IRQ():

diff --git a/arch/m68k/kernel/irq.c b/arch/m68k/kernel/irq.c
index aaf7b15fad41..da9687803d98 100644
--- a/arch/m68k/kernel/irq.c
+++ b/arch/m68k/kernel/irq.c
@@ -22,11 +22,21 @@ asmlinkage int do_IRQ(int irq, struct pt_regs *regs)
 	struct pt_regs *oldregs = set_irq_regs(regs);
 	int nested = regs->sr & ~ALLOWINT;
 
+static int nesting;
+const char prefix[] = "                ";
+unsigned long flags;
+local_irq_save(flags);
+nesting++;
+printk("# %sirq %d nested %d\n", &prefix[16-2*nesting], irq, nested);
+local_irq_restore(flags);
 	irq_enter();
 	generic_handle_irq(irq);
 	irq_exit_nested(nested);
 
 	set_irq_regs(oldregs);
+local_irq_save(flags);
+nesting--;
+local_irq_restore(flags);
 	return nested;
 }
 
I get output like

#   irq 15 nested 0
#     irq 15 nested 1024

irq 15 while irq 15 in progress??

#     irq 15 nested 1024
#     irq 15 nested 1024
#     irq 15 nested 1024
#     irq 13 nested 1024
#     irq 13 nested 1024
#     irq 13 nested 1024
#     irq 13 nested 1024
#     irq 13 nested 1024
#     irq 4 nested 0
#       irq 13 nested 1024
#     irq 4 nested 0
#       irq 13 nested 1024
#     irq 4 nested 0
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#     irq 4 nested 0
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#       irq 13 nested 1024
#     irq 4 nested 0
#       irq 13 nested 1024
#   irq 13 nested 1024

[...]

#   irq 13 nested 1024
#   irq 13 nested 1024
#   irq 4 nested 0
#     irq 13 nested 1024
#     irq 4 nested 0

irq 4 while irq 4 in progress?

#   irq 13 nested 1024
#   irq 4 nested 0
#   irq 13 nested 0

and then it stops printing anything.

With similar debug code on the old working do_IRQ(), I get
  - slightly less deep nesting,
  - do_IRQ() is never re-entered with the same irq number.

Also note that the value of "nested" doesn't match the indentation level,
which depends on my own bookkeeping using "nesting".

Anyone with an idea where it's going wrong?

Thanks!

>From 209b6ac37811297cd305821c5689dff75226af48 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 22 Sep 2013 11:31:25 +0200
Subject: [PATCH] m68k/hardirq: Make hardirq bits generic fixups

  - tstl instead of cmpl #0 (from Andreas)
  - arch/m68k/kernel/built-in.o: In function `bad_inthandler': (.text+0x2a6): undefined reference to `ret_from_last_interrupt'
  - Handle nesting in bad_inthandler() and handle_badint(),
  - As do_IRQ() now returns int, m68k_setup_auto_interrupt() should take a
    function that returns int, too,
  - Forgot to update forward declaration of q40_irq_handler(),
  - Whitespace fixes

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/irq.h      |    4 ++--
 arch/m68k/kernel/entry.S         |   10 ++--------
 arch/m68k/kernel/ints.c          |    9 +++++++--
 arch/m68k/platform/68000/entry.S |    2 +-
 arch/m68k/platform/68000/ints.c  |    2 +-
 arch/m68k/platform/68360/entry.S |    4 ++--
 arch/m68k/q40/q40ints.c          |    2 +-
 7 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 8d8e0f835275..fa7f079aeafa 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -60,8 +60,8 @@ struct irq_desc;
 extern unsigned int m68k_irq_startup(struct irq_data *data);
 extern unsigned int m68k_irq_startup_irq(unsigned int irq);
 extern void m68k_irq_shutdown(struct irq_data *data);
-extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int,
-						      struct pt_regs *));
+extern void m68k_setup_auto_interrupt(int (*handler)(unsigned int,
+						     struct pt_regs *));
 extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt);
 extern void m68k_setup_irq_controller(struct irq_chip *,
 				      void (*handle)(unsigned int irq,
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index d35c2a22398a..ca355813ce51 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -289,7 +289,7 @@ ret_from_interrupt:
 	 * Only the last interrupt leaving the kernel goes through the
 	 * various exception return checks.
 	 */
-	cmpl	#0, %d0
+	tstl	%d0
 	jeq	.Lret_from_exception
 	RESTORE_ALL
 
@@ -313,18 +313,12 @@ user_irqvec_fixup = . + 2
 
 ENTRY(bad_inthandler)
 	SAVE_ALL_INT
-	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 
 	movel	%sp,%sp@-
 	jsr	handle_badint
 	addql	#4,%sp
 
-	movel	%curptr@(TASK_STACK),%a1
-	subqb	#1,%a1@(TINFO_PREEMPT+1)
-	jeq	ret_from_last_interrupt
-	RESTORE_ALL
+	jra	ret_from_interrupt
 
 
 resume:
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 077d3a70fed1..ec1648b97dc8 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -72,7 +72,8 @@ void __init init_IRQ(void)
  * standard do_IRQ(), it will be called with irq numbers in the range
  * from IRQ_AUTO_1 - IRQ_AUTO_7.
  */
-void __init m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *))
+void __init m68k_setup_auto_interrupt(int (*handler)(unsigned int,
+						     struct pt_regs *))
 {
 	if (handler)
 		*auto_irqhandler_fixup = (u32)handler;
@@ -162,8 +163,12 @@ unsigned int irq_canonicalize(unsigned int irq)
 EXPORT_SYMBOL(irq_canonicalize);
 
 
-asmlinkage void handle_badint(struct pt_regs *regs)
+asmlinkage int handle_badint(struct pt_regs *regs)
 {
+	int nested = regs->sr & ~ALLOWINT;
+
 	atomic_inc(&irq_err_count);
 	pr_warn("unexpected interrupt from %u\n", regs->vector);
+
+	return nested;
 }
diff --git a/arch/m68k/platform/68000/entry.S b/arch/m68k/platform/68000/entry.S
index afc49235c3c7..b32c6c423c90 100644
--- a/arch/m68k/platform/68000/entry.S
+++ b/arch/m68k/platform/68000/entry.S
@@ -221,7 +221,7 @@ ret_from_interrupt:
 	 * Only the last interrupt leaving the kernel goes through the
 	 * various exception return checks.
 	 */
-	cmpl	#0, %d0
+	tstl	%d0
 	jeq	ret_from_exception
 	RESTORE_ALL
 
diff --git a/arch/m68k/platform/68000/ints.c b/arch/m68k/platform/68000/ints.c
index fadd2b9ff0d9..a6c05a60a9e5 100644
--- a/arch/m68k/platform/68000/ints.c
+++ b/arch/m68k/platform/68000/ints.c
@@ -76,7 +76,7 @@ asmlinkage irqreturn_t inthandler7(void);
  */
 int process_int(int vec, struct pt_regs *fp)
 {
-	int irq, mask, nested =fp->sr & ~ALLOWINT;
+	int irq, mask, nested = fp->sr & ~ALLOWINT;
 	unsigned long pend = ISR;
 
 	while (pend) {
diff --git a/arch/m68k/platform/68360/entry.S b/arch/m68k/platform/68360/entry.S
index 795abe505c35..e818794edfa7 100644
--- a/arch/m68k/platform/68360/entry.S
+++ b/arch/m68k/platform/68360/entry.S
@@ -133,14 +133,14 @@ inthandler:
 	movel	%sp,%sp@-
 	movel	%d0,%sp@- 		/*  put vector # on stack*/
 	jbsr	do_IRQ			/*  process the IRQ, returns nest level */
-     	addql	#8,%sp			/*  pop parameters off stack*/
+	addql	#8,%sp			/*  pop parameters off stack*/
 
 ret_from_interrupt:
 	/*
 	 * Only the last interrupt leaving the kernel goes through the
 	 * various exception return checks.
 	 */
-	cmpl	#0, %d0
+	tstl	%d0
 	jeq	ret_from_exception
 	RESTORE_ALL
 
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 179aee3a6498..a7525f189264 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -33,7 +33,7 @@
  *
 */
 
-static void q40_irq_handler(unsigned int, struct pt_regs *fp);
+static int q40_irq_handler(unsigned int, struct pt_regs *fp);
 static void q40_irq_enable(struct irq_data *data);
 static void q40_irq_disable(struct irq_data *data);
 
-- 
1.7.9.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
