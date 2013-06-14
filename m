Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3FNOkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:40:55 -0400
Received: from forward4.mail.yandex.net ([77.88.46.9]:50782 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3FNOky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:40:54 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: schedule_raw_spin_unlock() and schedule_spin_unlock()
MIME-Version: 1.0
Message-Id: <353211371220851@web23d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 14 Jun 2013 18:40:51 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helpers for replacement repeating patterns:

1)raw_spin_unlock_irq(lock);
   schedule();
2)raw_spin_unlock_irqrestore(lock, flags);
   schedule();

(The same for spinlock_t)

They allow to prevent excess preempt_schedule(), which can happen on preemptible kernel.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |   20 ++++++++++++++++++++
 kernel/sched/core.c   |   24 ++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b10339..0ae79f3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -310,6 +310,26 @@ extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
 
+#ifdef CONFIG_PREEMPT
+extern void schedule_raw_spin_unlock(raw_spinlock_t *lock);
+/* See comment for schedule_raw_spin_unlock() */
+static inline void schedule_spin_unlock(spinlock_t *lock)
+{
+	schedule_raw_spin_unlock(&lock->rlock);
+}
+#else
+static inline void schedule_raw_spin_unlock(raw_spinlock_t *lock)
+{
+	raw_spin_unlock_irq(lock);
+	schedule();
+}
+static inline void schedule_spin_unlock(spinlock_t *lock)
+{
+	spin_unlock_irq(lock);
+	schedule();
+}
+#endif
+
 struct nsproxy;
 struct user_namespace;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..381e493 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3125,6 +3125,30 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	exception_exit(prev_state);
 }
 
+/*
+ * schedule_raw_spin_unlock - unlock raw_spinlock and call schedule()
+ * 
+ * Should be used instead of the constructions
+ *   1) raw_spin_unlock_irq(lock);
+ *      schedule();
+ *   or
+ *   2) raw_spin_unlock_irqrestore(lock, flags);
+ *      schedule();
+ * where they have to be.
+ *
+ * It helps to prevent excess preempt_schedule() during the unlocking,
+ * which can be called on preemptible kernel.
+ * Returns with irqs enabled.
+ */
+void __sched schedule_raw_spin_unlock(raw_spinlock_t *lock)
+{
+	preempt_disable();
+	raw_spin_unlock_irq(lock);
+	sched_preempt_enable_no_resched();
+	schedule();
+}
+EXPORT_SYMBOL(schedule_raw_spin_unlock);
+
 #endif /* CONFIG_PREEMPT */
 
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
