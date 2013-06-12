Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3FLMGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:06:52 -0400
Received: from forward5.mail.yandex.net ([77.88.46.21]:35085 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3FLMGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:06:50 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] spin_unlock*_no_resched()
MIME-Version: 1.0
Message-Id: <1022041371038807@web30d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 12 Jun 2013 16:06:47 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many constructions like:

	spin_unlock_irq(lock);
	schedule();

In case of preemptible kernel we check if task needs reschedule
at the end of spin_unlock(). So if TIF_NEED_RESCHED is set
we call schedule() twice and we have a little overhead here.
Add primitives to avoid these situations.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/spinlock.h         |   27 +++++++++++++++++++++++++++
 include/linux/spinlock_api_smp.h |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_api_up.h  |   13 +++++++++++++
 kernel/spinlock.c                |   20 ++++++++++++++++++++
 4 files changed, 97 insertions(+), 0 deletions(-)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7d537ce..35caa32 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -221,13 +221,24 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 #define raw_spin_lock_irq(lock)		_raw_spin_lock_irq(lock)
 #define raw_spin_lock_bh(lock)		_raw_spin_lock_bh(lock)
 #define raw_spin_unlock(lock)		_raw_spin_unlock(lock)
+#define raw_spin_unlock_no_resched(lock)	\
+	_raw_spin_unlock_no_resched(lock)
+
 #define raw_spin_unlock_irq(lock)	_raw_spin_unlock_irq(lock)
+#define raw_spin_unlock_irq_no_resched(lock)	\
+	_raw_spin_unlock_irq_no_resched(lock)
 
 #define raw_spin_unlock_irqrestore(lock, flags)		\
 	do {							\
 		typecheck(unsigned long, flags);		\
 		_raw_spin_unlock_irqrestore(lock, flags);	\
 	} while (0)
+#define raw_spin_unlock_irqrestore_no_resched(lock, flags)	\
+	do {							\
+		typecheck(unsigned long, flags);		\
+		_raw_spin_unlock_irqrestore_no_resched(lock, flags);	\
+	} while (0)
+
 #define raw_spin_unlock_bh(lock)	_raw_spin_unlock_bh(lock)
 
 #define raw_spin_trylock_bh(lock) \
@@ -325,6 +336,11 @@ static inline void spin_unlock(spinlock_t *lock)
 	raw_spin_unlock(&lock->rlock);
 }
 
+static inline void spin_unlock_no_resched(spinlock_t *lock)
+{
+	raw_spin_unlock_no_resched(&lock->rlock);
+}
+
 static inline void spin_unlock_bh(spinlock_t *lock)
 {
 	raw_spin_unlock_bh(&lock->rlock);
@@ -335,11 +351,22 @@ static inline void spin_unlock_irq(spinlock_t *lock)
 	raw_spin_unlock_irq(&lock->rlock);
 }
 
+static inline void spin_unlock_irq_no_resched(spinlock_t *lock)
+{
+	raw_spin_unlock_irq_no_resched(&lock->rlock);
+}
+
 static inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	raw_spin_unlock_irqrestore(&lock->rlock, flags);
 }
 
+static inline void spin_unlock_irqrestore_no_resched(spinlock_t *lock,
+						     unsigned long flags)
+{
+	raw_spin_unlock_irqrestore_no_resched(&lock->rlock, flags);
+}
+
 static inline int spin_trylock_bh(spinlock_t *lock)
 {
 	return raw_spin_trylock_bh(&lock->rlock);
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 51df117..541d371 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -37,11 +37,18 @@ _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
 int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock);
 int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock);
 void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)		__releases(lock);
+void __lockfunc
+_raw_spin_unlock_no_resched(raw_spinlock_t *lock)		__releases(lock);
 void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc
+_raw_spin_unlock_irq_no_resched(raw_spinlock_t *lock)		__releases(lock);
+void __lockfunc
 _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 								__releases(lock);
+void __lockfunc
+_raw_spin_unlock_irqrestore_no_resched(raw_spinlock_t *lock, unsigned long flags)
+								__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
 #define _raw_spin_lock(lock) __raw_spin_lock(lock)
@@ -69,6 +76,8 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 
 #ifndef CONFIG_UNINLINE_SPIN_UNLOCK
 #define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
+#define _raw_spin_unlock_no_resched(lock)	\
+	__raw_spin_unlock_no_resched(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
@@ -77,10 +86,14 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 #define _raw_spin_unlock_irq(lock) __raw_spin_unlock_irq(lock)
+#define _raw_spin_unlock_irq_no_resched(lock)	\
+	__raw_spin_unlock_irq_no_resched(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 #define _raw_spin_unlock_irqrestore(lock, flags) __raw_spin_unlock_irqrestore(lock, flags)
+#define _raw_spin_unlock_irqrestore_no_resched(lock, flags)	\
+	__raw_spin_unlock_irqrestore_no_resched(lock, flags)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
@@ -153,6 +166,13 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
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
@@ -162,6 +182,15 @@ static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 	preempt_enable();
 }
 
+static inline void __raw_spin_unlock_irqrestore_no_resched(raw_spinlock_t *lock,
+							   unsigned long flags)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	do_raw_spin_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable_no_resched();
+}
+
 static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
@@ -170,6 +199,14 @@ static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
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
index af1f472..6f78980 100644
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
@@ -46,9 +49,15 @@
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)
 
+#define __UNLOCK_IRQ_NO_RESCHED(lock) \
+  do { local_irq_enable(); __UNLOCK_NO_RESCHED(lock); } while (0)
+ 
 #define __UNLOCK_IRQRESTORE(lock, flags) \
   do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
 
+#define __UNLOCK_IRQRESTORE_NO_RESCHED(lock, flags) \
+  do { local_irq_restore(flags); __UNLOCK_NO_RESCHED(lock); } while (0)
+
 #define _raw_spin_lock(lock)			__LOCK(lock)
 #define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
 #define _raw_read_lock(lock)			__LOCK(lock)
@@ -67,16 +76,20 @@
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
 					__UNLOCK_IRQRESTORE(lock, flags)
+#define _raw_spin_unlock_irqrestore_no_resched(lock, flags) \
+				__UNLOCK_IRQRESTORE_NO_RESCHED(lock, flags)
 #define _raw_read_unlock_irqrestore(lock, flags) \
 					__UNLOCK_IRQRESTORE(lock, flags)
 #define _raw_write_unlock_irqrestore(lock, flags) \
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 5cdd806..c52bdf7 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -169,6 +169,12 @@ void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 	__raw_spin_unlock(lock);
 }
 EXPORT_SYMBOL(_raw_spin_unlock);
+
+void __lockfunc _raw_spin_unlock_no_resched(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_no_resched(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_no_resched);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
@@ -177,6 +183,13 @@ void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long
 	__raw_spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
+
+void __lockfunc _raw_spin_unlock_irqrestore_no_resched(raw_spinlock_t *lock,
+						       unsigned long flags)
+{
+	__raw_spin_unlock_irqrestore_no_resched(lock, flags);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_irqrestore_no_resched);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
@@ -185,6 +198,13 @@ void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
 	__raw_spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_raw_spin_unlock_irq);
+
+void __lockfunc _raw_spin_unlock_irq_no_resched(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_irq_no_resched(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_irq_no_resched);
+
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
