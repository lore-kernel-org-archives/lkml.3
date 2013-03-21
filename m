Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3CUVxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:33026 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3CUVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:00 -0400
Message-Id: <20130321215233.446034505@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:52:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 02/34] arch: Consolidate tsk_is_polling()
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=arch-consolidate-tsk-is-polling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it to a common place. Preparatory patch for implementing
set/clear for the idle need_resched poll implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/thread_info.h      |    2 --
 arch/ia64/include/asm/thread_info.h       |    2 --
 arch/metag/include/asm/thread_info.h      |    2 --
 arch/microblaze/include/asm/thread_info.h |    1 -
 arch/mn10300/include/asm/thread_info.h    |    2 --
 arch/openrisc/include/asm/thread_info.h   |    2 --
 arch/parisc/include/asm/thread_info.h     |    2 --
 arch/powerpc/include/asm/thread_info.h    |    4 ----
 arch/sh/include/asm/thread_info.h         |    4 ----
 arch/sparc/include/asm/thread_info_32.h   |    2 --
 arch/sparc/include/asm/thread_info_64.h   |    2 --
 arch/tile/include/asm/thread_info.h       |    2 --
 arch/x86/include/asm/thread_info.h        |    2 --
 include/linux/sched.h                     |   20 ++++++++++++++++++++
 kernel/sched/core.c                       |    5 -----
 15 files changed, 20 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/thread_info.h
+++ linux-2.6/arch/alpha/include/asm/thread_info.h
@@ -95,8 +95,6 @@ register struct thread_info *__current_t
 #define TS_POLLING		0x0010	/* idle task polling need_resched,
 					   skip sending interrupt */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
Index: linux-2.6/arch/ia64/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/thread_info.h
+++ linux-2.6/arch/ia64/include/asm/thread_info.h
@@ -131,8 +131,6 @@ struct thread_info {
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 #define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
Index: linux-2.6/arch/metag/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/metag/include/asm/thread_info.h
+++ linux-2.6/arch/metag/include/asm/thread_info.h
@@ -150,6 +150,4 @@ static inline int kstack_end(void *addr)
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
 				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6/arch/microblaze/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/thread_info.h
+++ linux-2.6/arch/microblaze/include/asm/thread_info.h
@@ -182,7 +182,6 @@ static inline bool test_and_clear_restor
 	ti->status &= ~TS_RESTORE_SIGMASK;
 	return true;
 }
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6/arch/mn10300/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/thread_info.h
+++ linux-2.6/arch/mn10300/include/asm/thread_info.h
@@ -165,8 +165,6 @@ void arch_release_thread_info(struct thr
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6/arch/openrisc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/openrisc/include/asm/thread_info.h
+++ linux-2.6/arch/openrisc/include/asm/thread_info.h
@@ -128,8 +128,6 @@ register struct thread_info *current_thr
 /* For OpenRISC, this is anything in the LSW other than syscall trace */
 #define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6/arch/parisc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/thread_info.h
+++ linux-2.6/arch/parisc/include/asm/thread_info.h
@@ -77,8 +77,6 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE_MASK (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP |	\
 				 _TIF_BLOCKSTEP)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_PARISC_THREAD_INFO_H */
Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
+++ linux-2.6/arch/powerpc/include/asm/thread_info.h
@@ -182,10 +182,6 @@ static inline bool test_thread_local_fla
 #define is_32bit_task()	(1)
 #endif
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
-#endif	/* !__ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_THREAD_INFO_H */
Index: linux-2.6/arch/sh/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/thread_info.h
+++ linux-2.6/arch/sh/include/asm/thread_info.h
@@ -207,10 +207,6 @@ static inline bool test_and_clear_restor
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
-#endif	/* !__ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASM_SH_THREAD_INFO_H */
Index: linux-2.6/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_32.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_32.h
@@ -132,8 +132,6 @@ register struct thread_info *current_thr
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
Index: linux-2.6/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/thread_info_64.h
+++ linux-2.6/arch/sparc/include/asm/thread_info_64.h
@@ -256,8 +256,6 @@ static inline bool test_and_clear_restor
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #define thread32_stack_is_64bit(__SP) (((__SP) & 0x1) != 0)
 #define test_thread_64bit_stack(__SP) \
 	((test_thread_flag(TIF_32BIT) && !thread32_stack_is_64bit(__SP)) ? \
Index: linux-2.6/arch/tile/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/tile/include/asm/thread_info.h
+++ linux-2.6/arch/tile/include/asm/thread_info.h
@@ -153,8 +153,6 @@ extern void _cpu_idle(void);
 #define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -241,8 +241,6 @@ static inline struct thread_info *curren
 					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2472,6 +2472,26 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+/*
+ * Idle thread specific functions to determine the need_resched
+ * polling state. We have two versions, one based on TS_POLLING in
+ * thread_info.status and one based on TIF_POLLING_NRFLAG in
+ * thread_info.flags
+ */
+#ifdef TS_POLLING
+static inline int tsk_is_polling(struct task_struct *p)
+{
+	return task_thread_info(p)->status & TS_POLLING;
+}
+#elif defined(TIF_POLLING_NRFLAG)
+static inline int tsk_is_polling(struct task_struct *p)
+{
+	test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
+}
+#else
+static inline int tsk_is_polling(struct task_struct *p) { return 0; }
+#endif
+
 static inline int object_is_on_stack(void *obj)
 {
 	void *stack = task_stack_page(current);
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -512,11 +512,6 @@ static inline void init_hrtick(void)
  * the target CPU.
  */
 #ifdef CONFIG_SMP
-
-#ifndef tsk_is_polling
-#define tsk_is_polling(t) 0
-#endif
-
 void resched_task(struct task_struct *p)
 {
 	int cpu;


