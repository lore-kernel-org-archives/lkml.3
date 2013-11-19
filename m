Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3KSPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:47:10 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62451 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3KSPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:47:05 -0500
Date: Tue, 19 Nov 2013 16:47:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq cleanups
Message-ID: <20131119154702.GA12336@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   # HEAD: 00d1a39e69d5afa7523dad515a05b21abd17c389 preempt: Make PREEMPT_ACTIVE generic

This is a multi-arch cleanup series from Thomas Gleixner, which we 
kept to near the end of the merge window, to not interfere with 
architecture updates.

This series (motivated by the -rt kernel) unifies more aspects of IRQ 
handling and generalizes PREEMPT_ACTIVE.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (7):
      genirq: Prevent spurious detection for unconditionally polled interrupts
      m68k: Simplify low level interrupt handling code
      hardirq: Make hardirq bits generic
      m32r: Use preempt_schedule_irq
      ia64: Use preempt_schedule_irq
      sparc: Use preempt_schedule_irq
      preempt: Make PREEMPT_ACTIVE generic


 arch/alpha/include/asm/thread_info.h      |  2 --
 arch/arc/include/asm/thread_info.h        |  2 --
 arch/arm/include/asm/thread_info.h        |  6 -----
 arch/arm64/include/asm/thread_info.h      |  6 -----
 arch/avr32/include/asm/thread_info.h      |  2 --
 arch/blackfin/include/asm/hardirq.h       |  3 ---
 arch/blackfin/include/asm/thread_info.h   |  2 --
 arch/c6x/include/asm/thread_info.h        |  2 --
 arch/cris/include/asm/hardirq.h           | 12 ---------
 arch/cris/include/asm/thread_info.h       |  2 --
 arch/frv/include/asm/thread_info.h        |  2 --
 arch/hexagon/include/asm/thread_info.h    |  4 ---
 arch/ia64/include/asm/thread_info.h       |  3 ---
 arch/ia64/kernel/entry.S                  | 15 +----------
 arch/m32r/include/asm/hardirq.h           | 16 ------------
 arch/m32r/include/asm/thread_info.h       |  2 --
 arch/m32r/kernel/entry.S                  |  8 +-----
 arch/m68k/include/asm/hardirq.h           | 11 ---------
 arch/m68k/include/asm/thread_info.h       |  2 --
 arch/m68k/kernel/entry.S                  | 40 +++---------------------------
 arch/m68k/kernel/ints.c                   |  6 -----
 arch/m68k/platform/68000/entry.S          | 33 ++++++-------------------
 arch/m68k/platform/68360/entry.S          | 24 +++---------------
 arch/metag/include/asm/thread_info.h      |  2 --
 arch/microblaze/include/asm/thread_info.h |  2 --
 arch/mips/include/asm/thread_info.h       |  2 --
 arch/mn10300/include/asm/thread_info.h    |  2 --
 arch/parisc/include/asm/thread_info.h     |  3 ---
 arch/powerpc/include/asm/thread_info.h    |  2 --
 arch/s390/include/asm/hardirq.h           |  2 --
 arch/s390/include/asm/thread_info.h       |  2 --
 arch/score/include/asm/thread_info.h      |  2 --
 arch/sh/include/asm/thread_info.h         |  2 --
 arch/sh/kernel/entry-common.S             |  6 ++---
 arch/sparc/include/asm/hardirq_32.h       |  1 -
 arch/sparc/include/asm/hardirq_64.h       |  2 --
 arch/sparc/include/asm/thread_info_32.h   |  2 --
 arch/sparc/include/asm/thread_info_64.h   |  2 --
 arch/sparc/kernel/rtrap_64.S              |  6 ++---
 arch/tile/include/asm/hardirq.h           |  2 --
 arch/tile/include/asm/thread_info.h       |  2 --
 arch/um/include/asm/thread_info.h         |  2 --
 arch/unicore32/include/asm/thread_info.h  |  6 -----
 arch/x86/include/asm/thread_info.h        |  2 --
 arch/xtensa/include/asm/thread_info.h     |  2 --
 include/linux/irq.h                       |  7 +++++-
 include/linux/preempt_mask.h              | 41 +++++++++----------------------
 include/linux/sched.h                     |  2 +-
 kernel/irq/settings.h                     |  7 ++++++
 kernel/irq/spurious.c                     | 12 ++++++---
 50 files changed, 55 insertions(+), 275 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 52cd2a4..453597b 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -58,8 +58,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags:
  * - these are process state flags and used from assembly
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 2d50a4c..45be216 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -80,8 +80,6 @@ static inline __attribute_const__ struct thread_info *current_thread_info(void)
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE      0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d..71a06b2 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -141,12 +141,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SYSCAL_AUDIT	- syscall auditing active
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 23a3c47..720e70b 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -89,12 +89,6 @@ static inline struct thread_info *current_thread_info(void)
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index 6dc62e1..a978f3f 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -66,8 +66,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
-
 /*
  * Thread information flags
  * - these are process state flags that various assembly files may need to access
diff --git a/arch/blackfin/include/asm/hardirq.h b/arch/blackfin/include/asm/hardirq.h
index c078dd7..58b54a6 100644
--- a/arch/blackfin/include/asm/hardirq.h
+++ b/arch/blackfin/include/asm/hardirq.h
@@ -12,9 +12,6 @@
 extern void ack_bad_irq(unsigned int irq);
 #define ack_bad_irq ack_bad_irq
 
-/* Define until common code gets sane defaults */
-#define HARDIRQ_BITS 9
-
 #include <asm-generic/hardirq.h>
 
 #endif
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 3894005..55f473b 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -88,8 +88,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TI_CPU		12
 #define TI_PREEMPT	16
 
-#define	PREEMPT_ACTIVE	0x4000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index 4c8dc56..d4e9ef8 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -84,8 +84,6 @@ struct thread_info *current_thread_info(void)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 #endif /* __ASSEMBLY__ */
 
-#define	PREEMPT_ACTIVE	0x10000000
-
 /*
  * thread information flag bit numbers
  * - pending work-to-be-done flags are in LSW
diff --git a/arch/cris/include/asm/hardirq.h b/arch/cris/include/asm/hardirq.h
index 17bb12d..04126f7 100644
--- a/arch/cris/include/asm/hardirq.h
+++ b/arch/cris/include/asm/hardirq.h
@@ -2,18 +2,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 07c8c40..55dede1 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -44,8 +44,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index bebd7ea..af29e17 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -52,8 +52,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index f7c3240..a59dad3 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -73,10 +73,6 @@ struct thread_info {
 
 #endif  /* __ASSEMBLY__  */
 
-/*  looks like "linux/hardirq.h" uses this.  */
-
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifndef __ASSEMBLY__
 
 #define INIT_THREAD_INFO(tsk)                   \
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index cade13d..5957cf6 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -11,9 +11,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 
-#define PREEMPT_ACTIVE_BIT 30
-#define PREEMPT_ACTIVE	(1 << PREEMPT_ACTIVE_BIT)
-
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 7a53530..ddea607f 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1169,21 +1169,8 @@ skip_rbs_switch:
 .work_pending:
 	tbit.z p6,p0=r31,TIF_NEED_RESCHED	// is resched not needed?
 (p6)	br.cond.sptk.few .notify
-#ifdef CONFIG_PREEMPT
-(pKStk) dep r21=-1,r0,PREEMPT_ACTIVE_BIT,1
-	;;
-(pKStk) st4 [r20]=r21
-#endif
-	SSM_PSR_I(p0, p6, r2)	// enable interrupts
-	br.call.spnt.many rp=schedule
+	br.call.spnt.many rp=preempt_schedule_irq
 .ret9:	cmp.eq p6,p0=r0,r0	// p6 <- 1 (re-check)
-	RSM_PSR_I(p0, r2, r20)	// disable interrupts
-	;;
-#ifdef CONFIG_PREEMPT
-(pKStk)	adds r20=TI_PRE_COUNT+IA64_TASK_SIZE,r13
-	;;
-(pKStk)	st4 [r20]=r0		// preempt_count() <- 0
-#endif
 (pLvSys)br.cond.sptk.few  __paravirt_pending_syscall_end
 	br.cond.sptk.many .work_processed_kernel
 
diff --git a/arch/m32r/include/asm/hardirq.h b/arch/m32r/include/asm/hardirq.h
index 4c31c0a..5f2ac4f 100644
--- a/arch/m32r/include/asm/hardirq.h
+++ b/arch/m32r/include/asm/hardirq.h
@@ -3,22 +3,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-
-#if NR_IRQS > 256
-#define HARDIRQ_BITS	9
-#else
-#define HARDIRQ_BITS	8
-#endif
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index c074f4c..0017170 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -53,8 +53,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define THREAD_SIZE		(PAGE_SIZE << 1)
 #define THREAD_SIZE_ORDER	1
 /*
diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index 0c01543..7c3db99 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -182,13 +182,7 @@ need_resched:
 	ld	r4, PSW(sp)		; interrupts off (exception path) ?
 	and3	r4, r4, #0x4000
 	beqz	r4, restore_all
-	LDIMM	(r4, PREEMPT_ACTIVE)
-	st	r4, @(TI_PRE_COUNT, r8)
-	ENABLE_INTERRUPTS(r4)
-	bl	schedule
-	ldi	r4, #0
-	st	r4, @(TI_PRE_COUNT, r8)
-	DISABLE_INTERRUPTS(r4)
+	bl	preempt_schedule_irq
 	bra	need_resched
 #endif
 
diff --git a/arch/m68k/include/asm/hardirq.h b/arch/m68k/include/asm/hardirq.h
index db30ed2..6c61852 100644
--- a/arch/m68k/include/asm/hardirq.h
+++ b/arch/m68k/include/asm/hardirq.h
@@ -5,17 +5,6 @@
 #include <linux/cache.h>
 #include <asm/irq.h>
 
-#define HARDIRQ_BITS	8
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #ifdef CONFIG_MMU
 
 static inline void ack_bad_irq(unsigned int irq)
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index 126131f..21a4784 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -35,8 +35,6 @@ struct thread_info {
 };
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
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
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 7c4a330..b19e9c5 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -46,8 +46,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SHIFT		12
 #else
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index de26ea6..8c9d365 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -106,8 +106,6 @@ static inline struct thread_info *current_thread_info(void)
 /* thread information allocation */
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index f9b24bf..4f58ef6 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -92,8 +92,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #define STACK_WARN	(THREAD_SIZE / 8)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 224b426..bf280ea 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -16,8 +16,6 @@
 
 #include <asm/page.h>
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		(4096)
 #define THREAD_SIZE_ORDER	(0)
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index bc7cf12..d5f97ea 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -46,9 +46,6 @@ struct thread_info {
 #define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
-#define PREEMPT_ACTIVE_BIT	28
-#define PREEMPT_ACTIVE		(1 << PREEMPT_ACTIVE_BIT)
-
 /*
  * thread information flags
  */
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index ba7b197..8fd6cf6 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -82,8 +82,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/s390/include/asm/hardirq.h b/arch/s390/include/asm/hardirq.h
index a908d29..b7eabaa 100644
--- a/arch/s390/include/asm/hardirq.h
+++ b/arch/s390/include/asm/hardirq.h
@@ -18,8 +18,6 @@
 #define __ARCH_HAS_DO_SOFTIRQ
 #define __ARCH_IRQ_EXIT_IRQS_DISABLED
 
-#define HARDIRQ_BITS	8
-
 static inline void ack_bad_irq(unsigned int irq)
 {
 	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index eb5f64d..10e0fcd 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -111,6 +111,4 @@ static inline struct thread_info *current_thread_info(void)
 #define is_32bit_task()		(1)
 #endif
 
-#define PREEMPT_ACTIVE		0x4000000
-
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 1425cc0..656b7ad 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -72,8 +72,6 @@ register struct thread_info *__current_thread_info __asm__("r28");
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * thread information flags
  * - these are process state flags that various assembly files may need to
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 45a9366..ad27ffa 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -41,8 +41,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #if defined(CONFIG_4KSTACKS)
 #define THREAD_SHIFT	12
 #else
diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index 9b6e4be..ca46834 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
@@ -108,7 +108,7 @@ need_resched:
 	and	#(0xf0>>1), r0		! interrupts off (exception path)?
 	cmp/eq	#(0xf0>>1), r0
 	bt	noresched
-	mov.l	3f, r0
+	mov.l	1f, r0
 	jsr	@r0			! call preempt_schedule_irq
 	 nop
 	bra	need_resched
@@ -119,9 +119,7 @@ noresched:
 	 nop
 
 	.align 2
-1:	.long	PREEMPT_ACTIVE
-2:	.long	schedule
-3:	.long	preempt_schedule_irq
+1:	.long	preempt_schedule_irq
 #endif
 
 ENTRY(resume_userspace)
diff --git a/arch/sparc/include/asm/hardirq_32.h b/arch/sparc/include/asm/hardirq_32.h
index 1620076..ee93923 100644
--- a/arch/sparc/include/asm/hardirq_32.h
+++ b/arch/sparc/include/asm/hardirq_32.h
@@ -7,7 +7,6 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#define HARDIRQ_BITS    8
 #include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
diff --git a/arch/sparc/include/asm/hardirq_64.h b/arch/sparc/include/asm/hardirq_64.h
index 7c29fd1..f478ff1 100644
--- a/arch/sparc/include/asm/hardirq_64.h
+++ b/arch/sparc/include/asm/hardirq_64.h
@@ -14,6 +14,4 @@
 
 void ack_bad_irq(unsigned int irq);
 
-#define HARDIRQ_BITS	8
-
 #endif /* !(__SPARC64_HARDIRQ_H) */
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index dd38075..96efa7a 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -105,8 +105,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define TI_W_SAVED	0x250
 /* #define TI_RESTART_BLOCK 0x25n */ /* Nobody cares */
 
-#define PREEMPT_ACTIVE		0x4000000
-
 /*
  * thread information flag bit numbers
  */
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index d5e5042..2b4e17b 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -111,8 +111,6 @@ struct thread_info {
 #define THREAD_SHIFT PAGE_SHIFT
 #endif /* PAGE_SHIFT == 13 */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index afa2a9e..76213db 100644
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -306,12 +306,10 @@ to_kernel:
 		 nop
 		cmp			%l4, 0
 		bne,pn			%xcc, kern_fpucheck
-		 sethi			%hi(PREEMPT_ACTIVE), %l6
-		stw			%l6, [%g6 + TI_PRE_COUNT]
-		call			schedule
+		 nop
+		call			preempt_schedule_irq
 		 nop
 		ba,pt			%xcc, rtrap
-		 stw			%g0, [%g6 + TI_PRE_COUNT]
 #endif
 kern_fpucheck:	ldub			[%g6 + TI_FPDEPTH], %l5
 		brz,pt			%l5, rt_continue
diff --git a/arch/tile/include/asm/hardirq.h b/arch/tile/include/asm/hardirq.h
index 822390f..54110af 100644
--- a/arch/tile/include/asm/hardirq.h
+++ b/arch/tile/include/asm/hardirq.h
@@ -42,6 +42,4 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-#define HARDIRQ_BITS	8
-
 #endif /* _ASM_TILE_HARDIRQ_H */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index b8aa6df..729aa10 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -113,8 +113,6 @@ extern void _cpu_idle(void);
 
 #endif /* !__ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * Thread information flags that various assembly files may need to access.
  * Keep flags accessed frequently in low bits, particular since it makes
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 2c8eeb2..1c5b2a8 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -60,8 +60,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index 818b4a1..af36d8e 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -118,12 +118,6 @@ static inline struct thread_info *current_thread_info(void)
 #endif
 
 /*
- * We use bit 30 of the preempt_count to indicate that kernel
- * preemption is occurring.  See <asm/hardirq.h>.
- */
-#define PREEMPT_ACTIVE	0x40000000
-
-/*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index c46a46b..3ba3de4 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -153,8 +153,6 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
-#define PREEMPT_ACTIVE		0x10000000
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 9481004..470153e 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -76,8 +76,6 @@ struct thread_info {
 
 #endif
 
-#define PREEMPT_ACTIVE		0x10000000
-
 /*
  * macros/functions for gaining access to the thread information structure
  */
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 56bb0dc..7dc1003 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -70,6 +70,9 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
  * IRQ_PER_CPU_DEVID		- Dev_id is a per-cpu variable
+ * IRQ_IS_POLLED		- Always polled by another interrupt. Exclude
+ *				  it from the spurious interrupt detection
+ *				  mechanism and from core side polling.
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
@@ -94,12 +97,14 @@ enum {
 	IRQ_NESTED_THREAD	= (1 << 15),
 	IRQ_NOTHREAD		= (1 << 16),
 	IRQ_PER_CPU_DEVID	= (1 << 17),
+	IRQ_IS_POLLED		= (1 << 18),
 };
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID | \
+	 IRQ_IS_POLLED)
 
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index 931bc61..d169820 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -11,36 +11,23 @@
  * - bits 0-7 are the preemption count (max preemption depth: 256)
  * - bits 8-15 are the softirq count (max # of softirqs: 256)
  *
- * The hardirq count can in theory reach the same as NR_IRQS.
- * In reality, the number of nested IRQS is limited to the stack
- * size as well. For archs with over 1000 IRQS it is not practical
- * to expect that they will all nest. We give a max of 10 bits for
- * hardirq nesting. An arch may choose to give less than 10 bits.
- * m68k expects it to be 8.
+ * The hardirq count could in theory be the same as the number of
+ * interrupts in the system, but we run all interrupt handlers with
+ * interrupts disabled, so we cannot have nesting interrupts. Though
+ * there are a few palaeontologic drivers which reenable interrupts in
+ * the handler, so we need more than one bit here.
  *
- * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
- * - bit 26 is the NMI_MASK
- * - bit 27 is the PREEMPT_ACTIVE flag
- *
- * PREEMPT_MASK: 0x000000ff
- * SOFTIRQ_MASK: 0x0000ff00
- * HARDIRQ_MASK: 0x03ff0000
- *     NMI_MASK: 0x04000000
+ * PREEMPT_MASK:	0x000000ff
+ * SOFTIRQ_MASK:	0x0000ff00
+ * HARDIRQ_MASK:	0x000f0000
+ *     NMI_MASK:	0x00100000
+ * PREEMPT_ACTIVE:	0x00200000
  */
 #define PREEMPT_BITS	8
 #define SOFTIRQ_BITS	8
+#define HARDIRQ_BITS	4
 #define NMI_BITS	1
 
-#define MAX_HARDIRQ_BITS 10
-
-#ifndef HARDIRQ_BITS
-# define HARDIRQ_BITS	MAX_HARDIRQ_BITS
-#endif
-
-#if HARDIRQ_BITS > MAX_HARDIRQ_BITS
-#error HARDIRQ_BITS too high!
-#endif
-
 #define PREEMPT_SHIFT	0
 #define SOFTIRQ_SHIFT	(PREEMPT_SHIFT + PREEMPT_BITS)
 #define HARDIRQ_SHIFT	(SOFTIRQ_SHIFT + SOFTIRQ_BITS)
@@ -60,15 +47,9 @@
 
 #define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
 
-#ifndef PREEMPT_ACTIVE
 #define PREEMPT_ACTIVE_BITS	1
 #define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
 #define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
-#endif
-
-#if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
-#error PREEMPT_ACTIVE is too low!
-#endif
 
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 045b0d2..55080df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,7 +22,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
-#include <linux/preempt.h>
+#include <linux/preempt_mask.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index 1162f10..3320b84 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -14,6 +14,7 @@ enum {
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
 	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
+	_IRQ_IS_POLLED		= IRQ_IS_POLLED,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
@@ -26,6 +27,7 @@ enum {
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
 #define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
+#define IRQ_IS_POLLED		GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -147,3 +149,8 @@ static inline bool irq_settings_is_nested_thread(struct irq_desc *desc)
 {
 	return desc->status_use_accessors & _IRQ_NESTED_THREAD;
 }
+
+static inline bool irq_settings_is_polled(struct irq_desc *desc)
+{
+	return desc->status_use_accessors & _IRQ_IS_POLLED;
+}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 7b5f012..a1d8cc6 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -67,8 +67,13 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 
 	raw_spin_lock(&desc->lock);
 
-	/* PER_CPU and nested thread interrupts are never polled */
-	if (irq_settings_is_per_cpu(desc) || irq_settings_is_nested_thread(desc))
+	/*
+	 * PER_CPU, nested thread interrupts and interrupts explicitely
+	 * marked polled are excluded from polling.
+	 */
+	if (irq_settings_is_per_cpu(desc) ||
+	    irq_settings_is_nested_thread(desc) ||
+	    irq_settings_is_polled(desc))
 		goto out;
 
 	/*
@@ -268,7 +273,8 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
-	if (desc->istate & IRQS_POLL_INPROGRESS)
+	if (desc->istate & IRQS_POLL_INPROGRESS ||
+	    irq_settings_is_polled(desc))
 		return;
 
 	/* we get here again via the threaded handler */
