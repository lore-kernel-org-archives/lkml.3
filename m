Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3BMQMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:12:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:59705 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116Ab3BMQMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:12:51 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/16] softirq: Make serving softirqs a task flag
Date: Wed, 13 Feb 2013 17:11:56 +0100
Message-Id: <1360771932-27150-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Avoid the percpu softirq_runner pointer magic by using a task flag.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy@linutronix: different PF_IN_SOFTIRQ bit]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/sched.h |    1 +
 kernel/softirq.c      |   20 +++-----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e2f9e3b..751e65a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1821,6 +1821,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
+#define PF_IN_SOFTIRQ	0x00000001	/* Task is serving softirq */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ca00a68..d4cace1 100644
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

