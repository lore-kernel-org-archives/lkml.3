Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3LLOZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:25:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36023 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3LLOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:14 -0500
Message-Id: <20131212141654.816593653@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] locking: Optimize lock_bh functions
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-remove_preempt_enable_no_sched-from-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all _bh_ lock functions do two preempt_count operations:

  local_bh_disable();
  preempt_disable();

and for the unlock:

  preempt_enable_no_resched();
  local_bh_enable();

Since its a waste of perfectly good cycles to modify the same variable
twice when you can do it in one go; use the new
__local_bh_{dis,en}able_ip() functions that allow us to provide a
preempt_count value to add/sub.

So define SOFTIRQ_LOCK_OFFSET as the offset a _bh_ lock needs to
add/sub to be done in one go.

As a bonus it gets rid of the preempt_enable_no_resched() usage.

This reduces a 1000 loops of:

  spin_lock_bh(&bh_lock);
  spin_unlock_bh(&bh_lock);

from 53596 cycles to 51995 cycles. I didn't do enough measurements to
say for absolute sure that the result is significant but the the few
runs I did for each suggest it is so.

Cc: rjw@rjwysocki.net
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/preempt_mask.h     |   15 +++++++++++++++
 include/linux/rwlock_api_smp.h   |   12 ++++--------
 include/linux/spinlock_api_smp.h |   12 ++++--------
 include/linux/spinlock_api_up.h  |   16 +++++++++++-----
 4 files changed, 34 insertions(+), 21 deletions(-)

--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -78,6 +78,21 @@
 #endif
 
 /*
+ * The preempt_count offset needed for things like:
+ *
+ *  spin_lock_bh()
+ *
+ * Which need to disable both preemption (CONFIG_PREEMPT_COUNT) and
+ * softirqs, such that unlock sequences of:
+ *
+ *  spin_unlock();
+ *  local_bh_enable();
+ *
+ * Work as expected.
+ */
+#define SOFTIRQ_LOCK_OFFSET (SOFTIRQ_DISABLE_OFFSET + PREEMPT_CHECK_OFFSET)
+
+/*
  * Are we running in atomic context?  WARNING: this macro cannot
  * always detect atomic context; in particular, it cannot know about
  * held spinlocks in non-preemptible kernels.  Thus it should not be
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -172,8 +172,7 @@ static inline void __raw_read_lock_irq(r
 
 static inline void __raw_read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
@@ -200,8 +199,7 @@ static inline void __raw_write_lock_irq(
 
 static inline void __raw_write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
@@ -250,8 +248,7 @@ static inline void __raw_read_unlock_bh(
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
@@ -275,8 +272,7 @@ static inline void __raw_write_unlock_bh
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 #endif /* __LINUX_RWLOCK_API_SMP_H */
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -131,8 +131,7 @@ static inline void __raw_spin_lock_irq(r
 
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
@@ -174,20 +173,17 @@ static inline void __raw_spin_unlock_bh(
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	if (do_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	return 0;
 }
 
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -24,11 +24,14 @@
  * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
+#define ___LOCK(lock) \
+  do { __acquire(lock); (void)(lock); } while (0)
+
 #define __LOCK(lock) \
-  do { preempt_disable(); __acquire(lock); (void)(lock); } while (0)
+  do { preempt_disable(); ___LOCK(lock); } while (0);
 
 #define __LOCK_BH(lock) \
-  do { local_bh_disable(); __LOCK(lock); } while (0)
+  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK(lock); } while (0)
 
 #define __LOCK_IRQ(lock) \
   do { local_irq_disable(); __LOCK(lock); } while (0)
@@ -36,12 +39,15 @@
 #define __LOCK_IRQSAVE(lock, flags) \
   do { local_irq_save(flags); __LOCK(lock); } while (0)
 
+#define ___UNLOCK(lock) \
+  do { __release(lock); (void)(lock); } while (0)
+
 #define __UNLOCK(lock) \
-  do { preempt_enable(); __release(lock); (void)(lock); } while (0)
+  do { preempt_enable(); ___UNLOCK(lock); } while (0)
 
 #define __UNLOCK_BH(lock) \
-  do { preempt_enable_no_resched(); local_bh_enable(); \
-	  __release(lock); (void)(lock); } while (0)
+  do { __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); \
+       ___UNLOCK(lock); } while (0)
 
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)


