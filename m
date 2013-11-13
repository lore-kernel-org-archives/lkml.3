Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3KMTnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:43:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3KMTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:42:58 -0500
Date: Wed, 13 Nov 2013 11:42:38 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-09f90f6685cd88b6b904c141035d096169958cc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, schmitz@biophys.uni-duesseldorf.de,
        tglx@linutronix.de, schwab@linux-m68k.org, linux-m68k@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, schmitz@biophys.uni-duesseldorf.de,
        tglx@linutronix.de, schwab@linux-m68k.org, linux-m68k@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] m68k: Simplify low level interrupt handling code
Git-Commit-ID: 09f90f6685cd88b6b904c141035d096169958cc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:42:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09f90f6685cd88b6b904c141035d096169958cc4
Gitweb:     http://git.kernel.org/tip/09f90f6685cd88b6b904c141035d096169958cc4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 11 Nov 2013 21:01:03 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:46 +0100

m68k: Simplify low level interrupt handling code

The low level interrupt entry code of m68k contains the following:

    add_preempt_count(HARDIRQ_OFFSET);

    do_IRQ();
	irq_enter();
	    add_preempt_count(HARDIRQ_OFFSET);
	handle_interrupt();    
	irq_exit();    
	    sub_preempt_count(HARDIRQ_OFFSET);
	    if (in_interrupt())
       	       return; <---- On m68k always taken!
	    if (local_softirq_pending())
       	       do_softirq();

    sub_preempt_count(HARDIRQ_OFFSET);
    if (in_hardirq())
       return;
    if (status_on_stack_has_interrupt_priority_mask > 0)
       return;
    if (local_softirq_pending())
       do_softirq();

    ret_from_exception:
	if (interrupted_context_is_kernel)
	   return:
	....

I tried to find a proper explanation for this, but the changelog is
sparse and there are no mails explaining it further. But obviously
this relates to the interrupt priority levels of the m68k and tries to
be extra clever with nested interrupts. Though this cleverness just
adds code bloat to the interrupt hotpath.

For the common case of non nested interrupts the code runs through two
extra conditionals to the only important one, which checks whether the
return is to kernel or user space.

For the nested case the checks for in_hardirq() and the priority mask
value on stack catch only the case where the nested interrupt happens
inside the hard irq context of the first interrupt. If the nested
interrupt happens while the first interrupt handles soft interrupts,
then these extra checks buy nothing. The nested interrupt will fall
through to the final kernel/user space return check at
ret_from_exception.

Changing the code flow in the following way:

    do_IRQ();
	irq_enter();
	    add_preempt_count(HARDIRQ_OFFSET);
	handle_interrupt();    
	irq_exit();    
	    sub_preempt_count(HARDIRQ_OFFSET);
	    if (in_interrupt())
       	       return;
	    if (local_softirq_pending())
       	       do_softirq();

    ret_from_exception:
	if (interrupted_context_is_kernel)
	   return:

makes the region protected by the hardirq count slightly smaller and
the softirq handling is invoked with a minimal deeper stack. But
otherwise it's completely functional equivalent and saves 104 bytes of
text in arch/m68k/kernel/entry.o.

This modification allows us further to get rid of the limitations
which m68k puts on the preempt_count layout, so we can make the
preempt count bits completely generic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de
---
 arch/m68k/kernel/entry.S         | 40 ++++------------------------------------
 arch/m68k/kernel/ints.c          |  6 ------
 arch/m68k/platform/68000/entry.S | 33 ++++++++-------------------------
 arch/m68k/platform/68360/entry.S | 24 +++---------------------
 4 files changed, 15 insertions(+), 88 deletions(-)

diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index a78f564..b54ac7a 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -45,7 +45,7 @@
 .globl system_call, buserr, trap, resume
 .globl sys_call_table
 .globl __sys_fork, __sys_clone, __sys_vfork
-.globl ret_from_interrupt, bad_interrupt
+.globl bad_interrupt
 .globl auto_irqhandler_fixup
 .globl user_irqvec_fixup
 
@@ -275,8 +275,6 @@ do_delayed_trace:
 ENTRY(auto_inthandler)
 	SAVE_ALL_INT
 	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 	subw	#VEC_SPUR,%d0
@@ -286,32 +284,13 @@ ENTRY(auto_inthandler)
 auto_irqhandler_fixup = . + 2
 	jsr	do_IRQ			|  process the IRQ
 	addql	#8,%sp			|  pop parameters off stack
-
-ret_from_interrupt:
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
-	jeq	.Lret_from_exception
-	pea	ret_from_exception
-	jra	do_softirq
+	jra	ret_from_exception
 
 /* Handler for user defined interrupt vectors */
 
 ENTRY(user_inthandler)
 	SAVE_ALL_INT
 	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 					|  put exception # in d0
 	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 user_irqvec_fixup = . + 2
@@ -321,29 +300,18 @@ user_irqvec_fixup = . + 2
 	movel	%d0,%sp@-		|  put vector # on stack
 	jsr	do_IRQ			|  process the IRQ
 	addql	#8,%sp			|  pop parameters off stack
-
-	movel	%curptr@(TASK_STACK),%a1
-	subqb	#1,%a1@(TINFO_PREEMPT+1)
-	jeq	ret_from_last_interrupt
-	RESTORE_ALL
+	jra	ret_from_exception
 
 /* Handler for uninitialized and spurious interrupts */
 
 ENTRY(bad_inthandler)
 	SAVE_ALL_INT
 	GET_CURRENT(%d0)
-	movel	%d0,%a1
-	addqb	#1,%a1@(TINFO_PREEMPT+1)
 
 	movel	%sp,%sp@-
 	jsr	handle_badint
 	addql	#4,%sp
-
-	movel	%curptr@(TASK_STACK),%a1
-	subqb	#1,%a1@(TINFO_PREEMPT+1)
-	jeq	ret_from_last_interrupt
-	RESTORE_ALL
-
+	jra	ret_from_exception
 
 resume:
 	/*
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 4d7da38..077d3a7 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
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
 
diff --git a/arch/m68k/platform/68000/entry.S b/arch/m68k/platform/68000/entry.S
index 7f91c2f..23ac054 100644
--- a/arch/m68k/platform/68000/entry.S
+++ b/arch/m68k/platform/68000/entry.S
@@ -27,7 +27,6 @@
 .globl ret_from_exception
 .globl ret_from_signal
 .globl sys_call_table
-.globl ret_from_interrupt
 .globl bad_interrupt
 .globl inthandler1
 .globl inthandler2
@@ -137,7 +136,7 @@ inthandler1:
 	movel	#65,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler2:
 	SAVE_ALL_INT
@@ -148,7 +147,7 @@ inthandler2:
 	movel	#66,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler3:
 	SAVE_ALL_INT
@@ -159,7 +158,7 @@ inthandler3:
 	movel	#67,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler4:
 	SAVE_ALL_INT
@@ -170,7 +169,7 @@ inthandler4:
 	movel	#68,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler5:
 	SAVE_ALL_INT
@@ -181,7 +180,7 @@ inthandler5:
 	movel	#69,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler6:
 	SAVE_ALL_INT
@@ -192,7 +191,7 @@ inthandler6:
 	movel	#70,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler7:
 	SAVE_ALL_INT
@@ -203,7 +202,7 @@ inthandler7:
 	movel	#71,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
+	bra	ret_from_exception
 
 inthandler:
 	SAVE_ALL_INT
@@ -214,23 +213,7 @@ inthandler:
 	movel	%d0,%sp@- 		/*  put vector # on stack*/
 	jbsr	process_int		/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
-
-ret_from_interrupt:
-	jeq	1f
-2:
-	RESTORE_ALL
-1:
-	moveb	%sp@(PT_OFF_SR), %d0
-	and	#7, %d0
-	jhi	2b
-
-	/* check if we need to do software interrupts */
-	jeq	ret_from_exception
-
-	pea	ret_from_exception
-	jra	do_softirq
-
+	bra	ret_from_exception
 
 /*
  * Handler for uninitialized and spurious interrupts.
diff --git a/arch/m68k/platform/68360/entry.S b/arch/m68k/platform/68360/entry.S
index 904fd9a..447c33e 100644
--- a/arch/m68k/platform/68360/entry.S
+++ b/arch/m68k/platform/68360/entry.S
@@ -29,7 +29,6 @@
 .globl ret_from_exception
 .globl ret_from_signal
 .globl sys_call_table
-.globl ret_from_interrupt
 .globl bad_interrupt
 .globl inthandler
 
@@ -132,26 +131,9 @@ inthandler:
 
 	movel	%sp,%sp@-
 	movel	%d0,%sp@- 		/*  put vector # on stack*/
-	jbsr	do_IRQ			/*  process the IRQ*/
-3:     	addql	#8,%sp			/*  pop parameters off stack*/
-	bra	ret_from_interrupt
-
-ret_from_interrupt:
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
-	jeq	ret_from_exception
-
-	pea	ret_from_exception
-	jra	do_softirq
-
+	jbsr	do_IRQ			/*  process the IRQ */
+	addql	#8,%sp			/*  pop parameters off stack*/
+	jra	ret_from_exception
 
 /*
  * Handler for uninitialized and spurious interrupts.
