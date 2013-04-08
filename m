Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab3DHUK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:10:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935925Ab3DHUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:10:25 -0400
Date: Mon, 8 Apr 2013 13:09:20 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ee761f629d598579594d7e1eb8c552f3c5f71e4d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.446034505@linutronix.de>
References: <20130321215233.446034505@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arch: Consolidate tsk_is_polling()
Git-Commit-ID: ee761f629d598579594d7e1eb8c552f3c5f71e4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:09:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee761f629d598579594d7e1eb8c552f3c5f71e4d
Gitweb:     http://git.kernel.org/tip/ee761f629d598579594d7e1eb8c552f3c5f71e4d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:32 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:22 +0200

arch: Consolidate tsk_is_polling()

Move it to a common place. Preparatory patch for implementing
set/clear for the idle need_resched poll implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.446034505@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/thread_info.h      |  2 --
 arch/ia64/include/asm/thread_info.h       |  2 --
 arch/metag/include/asm/thread_info.h      |  2 --
 arch/microblaze/include/asm/thread_info.h |  1 -
 arch/mn10300/include/asm/thread_info.h    |  2 --
 arch/openrisc/include/asm/thread_info.h   |  2 --
 arch/parisc/include/asm/thread_info.h     |  2 --
 arch/powerpc/include/asm/thread_info.h    |  2 --
 arch/sh/include/asm/thread_info.h         |  2 --
 arch/sparc/include/asm/thread_info_32.h   |  2 --
 arch/sparc/include/asm/thread_info_64.h   |  2 --
 arch/tile/include/asm/thread_info.h       |  2 --
 arch/x86/include/asm/thread_info.h        |  2 --
 include/linux/sched.h                     | 20 ++++++++++++++++++++
 kernel/sched/core.c                       |  5 -----
 15 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 1f8c729..52cd2a4 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -95,8 +95,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TS_POLLING		0x0010	/* idle task polling need_resched,
 					   skip sending interrupt */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index 020d655..cade13d 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -131,8 +131,6 @@ struct thread_info {
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 #define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 0ecd34d..7c4a330 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -150,6 +150,4 @@ static inline int kstack_end(void *addr)
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
 				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 008f304..de26ea6 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -182,7 +182,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	ti->status &= ~TS_RESTORE_SIGMASK;
 	return true;
 }
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index f90062b..224b426 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -165,8 +165,6 @@ void arch_release_thread_info(struct thread_info *ti);
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index 07f3212..d797acc 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -128,8 +128,6 @@ register struct thread_info *current_thread_info_reg asm("r10");
 /* For OpenRISC, this is anything in the LSW other than syscall trace */
 #define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index d1fb79a..6182832 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -77,8 +77,6 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE_MASK (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP |	\
 				 _TIF_BLOCKSTEP)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_PARISC_THREAD_INFO_H */
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 406b7b9..8ceea14 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -182,8 +182,6 @@ static inline bool test_thread_local_flags(unsigned int flags)
 #define is_32bit_task()	(1)
 #endif
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 7d5ac4e..45a9366 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -207,8 +207,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 25849ae..dd38075 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -132,8 +132,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 269bd92..d5e5042 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -256,8 +256,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #define thread32_stack_is_64bit(__SP) (((__SP) & 0x1) != 0)
 #define test_thread_64bit_stack(__SP) \
 	((test_thread_flag(TIF_32BIT) && !thread32_stack_is_64bit(__SP)) ? \
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index e9c670d..ccc8ef3 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -153,8 +153,6 @@ extern void _cpu_idle(void);
 #define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2cd056e..a1df6e8 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -241,8 +241,6 @@ static inline struct thread_info *current_thread_info(void)
 					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..6709a58 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2622,6 +2622,26 @@ static inline int spin_needbreak(spinlock_t *lock)
 }
 
 /*
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
+	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
+}
+#else
+static inline int tsk_is_polling(struct task_struct *p) { return 0; }
+#endif
+
+/*
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..243a20c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
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
