Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162Ab3CWB2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:28:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:1050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422964Ab3CWBZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455606"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/29] locking, tsx: Add support for arch_read/write_unlock_irq/flags
Date: Fri, 22 Mar 2013 18:25:02 -0700
Message-Id: <1364001923-10796-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The TSX RTM lock elision code needs to distinguish unlocks that reenable
interrupts from others. Add arch_read/write_unlock_irq/flags for rwlocks
similar to the ones for spinlocks.  This is opt in by the architecture.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/rwlock.h         |   76 ++++++++++++++++++++++++++++++++++++++-
 include/linux/rwlock_api_smp.h |   12 ++----
 2 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index bc2994e..82a7f61 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -14,6 +14,34 @@
  * Released under the General Public License (GPL).
  */
 
+#if !defined(ARCH_HAS_RWLOCK_UNLOCK_IRQ) && defined(CONFIG_SMP)
+static inline void arch_read_unlock_irqrestore(arch_rwlock_t *lock,
+					       unsigned long flags)
+{
+	arch_read_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void arch_read_unlock_irq(arch_rwlock_t *lock)
+{
+	arch_read_unlock(lock);
+	local_irq_enable();
+}
+
+static inline void arch_write_unlock_irqrestore(arch_rwlock_t *lock,
+						unsigned long flags)
+{
+	arch_write_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void arch_write_unlock_irq(arch_rwlock_t *lock)
+{
+	arch_write_unlock(lock);
+	local_irq_enable();
+}
+#endif
+
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __rwlock_init(rwlock_t *lock, const char *name,
 			    struct lock_class_key *key);
@@ -37,17 +65,61 @@ do {								\
 #define do_raw_write_lock_flags(lock, flags) do_raw_write_lock(lock)
  extern int do_raw_write_trylock(rwlock_t *lock);
  extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
+
+static inline void do_raw_write_unlock_irq(rwlock_t *lock) __releases(lock)
+{
+	do_raw_write_unlock(lock);
+	local_irq_enable();
+}
+
+static inline void do_raw_read_unlock_irq(rwlock_t *lock) __releases(lock)
+{
+	do_raw_read_unlock(lock);
+	local_irq_enable();
+}
+
+static inline void do_raw_write_unlock_irqrestore(rwlock_t *lock,
+						  unsigned long flags)
+	__releases(lock)
+{
+	do_raw_write_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void do_raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+	__releases(lock)
+{
+	do_raw_read_unlock(lock);
+	local_irq_restore(flags);
+}
+
 #else
 # define do_raw_read_lock(rwlock)	do {__acquire(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
-# define do_raw_read_lock_flags(lock, flags) \
-		do {__acquire(lock); arch_read_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
+# define do_raw_read_lock_flags(lock, flags)	\
+		do { __acquire(lock);		\
+		     arch_read_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
 # define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_read_unlock_irqrestore(rwlock, flags)			\
+	do {								\
+		arch_read_unlock_irqrestore(&(rwlock)->raw_lock, flags); \
+		__release(lock); \
+	} while (0)
+# define do_raw_read_unlock_irq(rwlock)	\
+	do {arch_read_unlock_irq(&(rwlock)->raw_lock); __release(lock); } while (0)
 # define do_raw_write_lock(rwlock)	do {__acquire(lock); arch_write_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_write_lock_flags(lock, flags) \
 		do {__acquire(lock); arch_write_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
 # define do_raw_write_unlock(rwlock)	do {arch_write_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_write_unlock_irqrestore(rwlock, flags)			\
+	do {								\
+		arch_write_unlock_irqrestore(&(rwlock)->raw_lock, flags); \
+		__release(lock); \
+	} while (0)
+# define do_raw_write_unlock_irq(rwlock)		 \
+	do { arch_write_unlock_irq(&(rwlock)->raw_lock); \
+	     __release(lock); } while (0)
 #endif
 
 #define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..8ac4a73 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -233,16 +233,14 @@ static inline void
 __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_read_unlock(lock);
-	local_irq_restore(flags);
+	do_raw_read_unlock_irqrestore(lock, flags);
 	preempt_enable();
 }
 
 static inline void __raw_read_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_read_unlock(lock);
-	local_irq_enable();
+	do_raw_read_unlock_irq(lock);
 	preempt_enable();
 }
 
@@ -258,16 +256,14 @@ static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 					     unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_write_unlock(lock);
-	local_irq_restore(flags);
+	do_raw_write_unlock_irqrestore(lock, flags);
 	preempt_enable();
 }
 
 static inline void __raw_write_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_write_unlock(lock);
-	local_irq_enable();
+	do_raw_write_unlock_irq(lock);
 	preempt_enable();
 }
 
-- 
1.7.7.6

