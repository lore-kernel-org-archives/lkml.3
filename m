Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445Ab3BMQOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:14:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:59765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab3BMQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:14:03 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/12] softirq: Make serving softirqs a task flag
Date: Wed, 13 Feb 2013 17:13:40 +0100
Message-Id: <1360772031-27186-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
References: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Avoid the percpu softirq_runner pointer magic by using a task flag.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/sched.h |    1 +
 kernel/softirq.c      |   20 +++-----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0448fa..8313893 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1876,6 +1876,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
+#define PF_IN_SOFTIRQ	0x00004000	/* Task is serving softirq */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 34fe1db..2980048 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -383,7 +383,6 @@ static inline void ksoftirqd_clr_sched_params(void) { }
  * On RT we serialize softirq execution with a cpu local lock
  */
 static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
-static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner);
 
 static void __do_softirq_common(int need_rcu_bh_qs);
 
@@ -438,22 +437,9 @@ void _local_bh_enable(void)
 }
 EXPORT_SYMBOL(_local_bh_enable);
 
-/* For tracing */
-int notrace __in_softirq(void)
-{
-	if (__get_cpu_var(local_softirq_lock).owner == current)
-		return __get_cpu_var(local_softirq_lock).nestcnt;
-	return 0;
-}
-
 int in_serving_softirq(void)
 {
-	int res;
-
-	preempt_disable();
-	res = __get_cpu_var(local_softirq_runner) == current;
-	preempt_enable();
-	return res;
+	return current->flags & PF_IN_SOFTIRQ;
 }
 EXPORT_SYMBOL(in_serving_softirq);
 
@@ -471,7 +457,7 @@ static void __do_softirq_common(int need_rcu_bh_qs)
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
 
-	__get_cpu_var(local_softirq_runner) = current;
+	current->flags |= PF_IN_SOFTIRQ;
 
 	lockdep_softirq_enter();
 
@@ -482,7 +468,7 @@ static void __do_softirq_common(int need_rcu_bh_qs)
 		wakeup_softirqd();
 
 	lockdep_softirq_exit();
-	__get_cpu_var(local_softirq_runner) = NULL;
+	current->flags &= ~PF_IN_SOFTIRQ;
 
 	current->softirq_nestcnt--;
 }
-- 
1.7.10.4

