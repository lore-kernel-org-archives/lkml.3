Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514Ab3BMQP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:15:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:59776 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934447Ab3BMQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:14:09 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/12] softirq: Adapt NOHZ softirq pending check to new RT scheme
Date: Wed, 13 Feb 2013 17:13:43 +0100
Message-Id: <1360772031-27186-5-git-send-email-bigeasy@linutronix.de>
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

We can't rely on ksoftirqd anymore and we need to check the tasks
which run a particular softirq and if such a task is pi blocked ignore
the other pending bits of that task as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/softirq.c |   68 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8e5e1c7..72abc38 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -65,45 +65,75 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 
 #ifdef CONFIG_NO_HZ
 # ifdef CONFIG_PREEMPT_RT_FULL
+
+struct softirq_runner {
+	struct task_struct *runner[NR_SOFTIRQS];
+};
+
+static DEFINE_PER_CPU(struct softirq_runner, softirq_runners);
+
+static inline void softirq_set_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = current;
+}
+
+static inline void softirq_clr_runner(unsigned int sirq)
+{
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+
+	sr->runner[sirq] = NULL;
+}
+
 /*
- * On preempt-rt a softirq might be blocked on a lock. There might be
- * no other runnable task on this CPU because the lock owner runs on
- * some other CPU. So we have to go into idle with the pending bit
- * set. Therefor we need to check this otherwise we warn about false
- * positives which confuses users and defeats the whole purpose of
- * this test.
+ * On preempt-rt a softirq running context might be blocked on a
+ * lock. There might be no other runnable task on this CPU because the
+ * lock owner runs on some other CPU. So we have to go into idle with
+ * the pending bit set. Therefor we need to check this otherwise we
+ * warn about false positives which confuses users and defeats the
+ * whole purpose of this test.
  *
  * This code is called with interrupts disabled.
  */
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	struct softirq_runner *sr = &__get_cpu_var(softirq_runners);
+	u32 warnpending, pending = local_softirq_pending();
 
 	if (rate_limit >= 10)
 		return;
 
-	if (pending) {
+	warnpending = pending;
+
+	while (pending) {
 		struct task_struct *tsk;
+		int i = __ffs(pending);
 
-		tsk = __get_cpu_var(ksoftirqd);
+		pending &= ~(1 << i);
+
+		tsk = sr->runner[i];
 		/*
 		 * The wakeup code in rtmutex.c wakes up the task
 		 * _before_ it sets pi_blocked_on to NULL under
 		 * tsk->pi_lock. So we need to check for both: state
 		 * and pi_blocked_on.
 		 */
-		raw_spin_lock(&tsk->pi_lock);
-
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
-
-		raw_spin_unlock(&tsk->pi_lock);
+		if (tsk) {
+			raw_spin_lock(&tsk->pi_lock);
+			if (tsk->pi_blocked_on || tsk->state == TASK_RUNNING) {
+				/* Clear all bits pending in that task */
+				warnpending &= ~(tsk->softirqs_raised);
+				warnpending &= ~(1 << i);
+			}
+			raw_spin_unlock(&tsk->pi_lock);
+		}
 	}
 
 	if (warnpending) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       pending);
+		       warnpending);
 		rate_limit++;
 	}
 }
@@ -122,6 +152,10 @@ void softirq_check_pending_idle(void)
 	}
 }
 # endif
+
+#else /* !NO_HZ */
+static inline void softirq_set_runner(unsigned int sirq) { }
+static inline void softirq_clr_runner(unsigned int sirq) { }
 #endif
 
 /*
@@ -469,6 +503,7 @@ static void do_current_softirqs(int need_rcu_bh_qs)
 		 */
 		lock_softirq(i);
 		local_irq_disable();
+		softirq_set_runner(i);
 		/*
 		 * Check with the local_softirq_pending() bits,
 		 * whether we need to process this still or if someone
@@ -479,6 +514,7 @@ static void do_current_softirqs(int need_rcu_bh_qs)
 			set_softirq_pending(pending & ~mask);
 			do_single_softirq(i, need_rcu_bh_qs);
 		}
+		softirq_clr_runner(i);
 		unlock_softirq(i);
 		WARN_ON(current->softirq_nestcnt != 1);
 	}
-- 
1.7.10.4

