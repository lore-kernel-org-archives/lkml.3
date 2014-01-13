Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaAMP53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:57:25 -0500
Date: Mon, 13 Jan 2014 07:56:46 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9ea4c380066fbe23fe0da7f4abfabc444f2467f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        peterz@infradead.org, bitbucket@online.de, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, bitbucket@online.de, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20131119151338.GF3694@twins.programming.kicks-ass.net>
References: <20131119151338.GF3694@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] locking: Optimize lock_bh functions
Git-Commit-ID: 9ea4c380066fbe23fe0da7f4abfabc444f2467f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ea4c380066fbe23fe0da7f4abfabc444f2467f4
Gitweb:     http://git.kernel.org/tip/9ea4c380066fbe23fe0da7f4abfabc444f2467f4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 19 Nov 2013 16:13:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:36 +0100

locking: Optimize lock_bh functions

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

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: rui.zhang@intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131119151338.GF3694@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/preempt_mask.h     | 15 +++++++++++++++
 include/linux/rwlock_api_smp.h   | 12 ++++--------
 include/linux/spinlock_api_smp.h | 12 ++++--------
 include/linux/spinlock_api_up.h  | 16 +++++++++++-----
 kernel/softirq.c                 |  4 ++--
 5 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index d169820..b8d96bc 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -79,6 +79,21 @@
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
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..5b9b84b 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -172,8 +172,7 @@ static inline void __raw_read_lock_irq(rwlock_t *lock)
 
 static inline void __raw_read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
@@ -200,8 +199,7 @@ static inline void __raw_write_lock_irq(rwlock_t *lock)
 
 static inline void __raw_write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
@@ -250,8 +248,7 @@ static inline void __raw_read_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
@@ -275,8 +272,7 @@ static inline void __raw_write_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 #endif /* __LINUX_RWLOCK_API_SMP_H */
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index bdb9993..42dfab8 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -131,8 +131,7 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
@@ -174,20 +173,17 @@ static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
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
 
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index af1f472..d0d1888 100644
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
+  do { preempt_disable(); ___LOCK(lock); } while (0)
 
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..7500cce1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -107,7 +107,7 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 	/*
 	 * Were softirqs turned off above:
 	 */
-	if (softirq_count() == cnt)
+	if (softirq_count() == (cnt & SOFTIRQ_MASK))
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
@@ -133,7 +133,7 @@ static void __local_bh_enable(unsigned int cnt)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (softirq_count() == cnt)
+	if (softirq_count() == (cnt & SOFTIRQ_MASK))
 		trace_softirqs_on(_RET_IP_);
 	preempt_count_sub(cnt);
 }
