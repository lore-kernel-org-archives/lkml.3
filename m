Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab3FRPhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:37:09 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:39376 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3FRPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:37:01 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] sched: Add schedule_(raw_)spin_unlock and schedule_(raw_)spin_unlock_irq
MIME-Version: 1.0
Message-Id: <1981131371569812@web20h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Jun 2013 19:36:52 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helpers for replacement repeating patterns:

1)spin_unlock(lock);
  schedule();
2)spin_unlock_irq(lock);
  schedule();

  (The same for raw_spinlock_t)

This allows to prevent excess preempt_schedule(), which can happen on preemptible kernel.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h            |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_api_smp.h |   21 +++++++++++++++++++++
 include/linux/spinlock_api_up.h  |    8 ++++++++
 kernel/spinlock.c                |   13 +++++++++++++
 4 files changed, 79 insertions(+), 0 deletions(-)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b10339..2020071 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -310,6 +310,43 @@ extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
 
+/*
+ * schedule_raw_spin_unlock() -- should be used instead of pattern:
+ *
+ *     raw_spin_unlock(lock);
+ *     schedule();
+ *
+ * It's the same, but prevents preempt_schedule() call during the unlocking.
+ */
+static inline void schedule_raw_spin_unlock(raw_spinlock_t *lock)
+{
+	_raw_spin_unlock_no_resched(lock);
+	schedule();
+}
+
+/*
+ * schedule_raw_spin_unlock_irq() -- should be used instead of pattern:
+ *
+ *     raw_spin_unlock_irq(lock);
+ *     schedule();
+ *
+ * It's the same, but prevents preempt_schedule() call during the unlocking.
+ */
+static inline void schedule_raw_spin_unlock_irq(raw_spinlock_t *lock)
+{
+	_raw_spin_unlock_irq_no_resched(lock);
+	schedule();
+}
+
+static inline void schedule_spin_unlock(spinlock_t *lock)
+{
+	schedule_raw_spin_unlock(&lock->rlock);
+}
+static inline void schedule_spin_unlock_irq(spinlock_t *lock)
+{
+	schedule_raw_spin_unlock_irq(&lock->rlock);
+}
+
 struct nsproxy;
 struct user_namespace;
 
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 51df117..42dbdfe 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -42,6 +42,10 @@ void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc
 _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 								__releases(lock);
+void __lockfunc
+_raw_spin_unlock_no_resched(raw_spinlock_t *lock)		__releases(lock);
+void __lockfunc
+_raw_spin_unlock_irq_no_resched(raw_spinlock_t *lock)		__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
 #define _raw_spin_lock(lock) __raw_spin_lock(lock)
@@ -69,6 +73,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 
 #ifndef CONFIG_UNINLINE_SPIN_UNLOCK
 #define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
+#define _raw_spin_unlock_no_resched(lock) __raw_spin_unlock_no_resched(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
@@ -77,6 +82,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 #define _raw_spin_unlock_irq(lock) __raw_spin_unlock_irq(lock)
+#define _raw_spin_unlock_irq_no_resched(lock) __raw_spin_unlock_irq_no_resched(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
@@ -153,6 +159,13 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 	preempt_enable();
 }
 
+static inline void __raw_spin_unlock_no_resched(raw_spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	do_raw_spin_unlock(lock);
+	preempt_enable_no_resched();
+}
+
 static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
 {
@@ -170,6 +183,14 @@ static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 	preempt_enable();
 }
 
+static inline void __raw_spin_unlock_irq_no_resched(raw_spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	do_raw_spin_unlock(lock);
+	local_irq_enable();
+	preempt_enable_no_resched();
+}
+
 static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index af1f472..82280da 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -39,6 +39,9 @@
 #define __UNLOCK(lock) \
   do { preempt_enable(); __release(lock); (void)(lock); } while (0)
 
+#define __UNLOCK_NO_RESCHED(lock) \
+  do { preempt_enable_no_resched(); __release(lock); (void)(lock); } while (0)
+
 #define __UNLOCK_BH(lock) \
   do { preempt_enable_no_resched(); local_bh_enable(); \
 	  __release(lock); (void)(lock); } while (0)
@@ -46,6 +49,9 @@
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)
 
+#define __UNLOCK_IRQ_NO_RESCHED(lock) \
+  do { local_irq_enable(); __UNLOCK_NO_RESCHED(lock); } while (0)
+
 #define __UNLOCK_IRQRESTORE(lock, flags) \
   do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
 
@@ -67,12 +73,14 @@
 #define _raw_write_trylock(lock)			({ __LOCK(lock); 1; })
 #define _raw_spin_trylock_bh(lock)		({ __LOCK_BH(lock); 1; })
 #define _raw_spin_unlock(lock)			__UNLOCK(lock)
+#define _raw_spin_unlock_no_resched(lock)	__UNLOCK_NO_RESCHED(lock)
 #define _raw_read_unlock(lock)			__UNLOCK(lock)
 #define _raw_write_unlock(lock)			__UNLOCK(lock)
 #define _raw_spin_unlock_bh(lock)		__UNLOCK_BH(lock)
 #define _raw_write_unlock_bh(lock)		__UNLOCK_BH(lock)
 #define _raw_read_unlock_bh(lock)		__UNLOCK_BH(lock)
 #define _raw_spin_unlock_irq(lock)		__UNLOCK_IRQ(lock)
+#define _raw_spin_unlock_irq_no_resched(lock)	__UNLOCK_IRQ_NO_RESCHED(lock)
 #define _raw_read_unlock_irq(lock)		__UNLOCK_IRQ(lock)
 #define _raw_write_unlock_irq(lock)		__UNLOCK_IRQ(lock)
 #define _raw_spin_unlock_irqrestore(lock, flags) \
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 5cdd806..218058f 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -169,6 +169,13 @@ void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 	__raw_spin_unlock(lock);
 }
 EXPORT_SYMBOL(_raw_spin_unlock);
+
+void __lockfunc _raw_spin_unlock_no_resched(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_no_resched(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_no_resched);
+
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
@@ -185,6 +192,12 @@ void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
 	__raw_spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_raw_spin_unlock_irq);
+
+void __lockfunc _raw_spin_unlock_irq_no_resched(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_irq_no_resched(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_irq_no_resched);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
