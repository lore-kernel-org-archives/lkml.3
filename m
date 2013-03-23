Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423136Ab3CWB1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:27:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:1050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422984Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455610"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/29] locking, tsx: Allow architecture to control mutex fast path owner field
Date: Fri, 22 Mar 2013 18:25:10 -0700
Message-Id: <1364001923-10796-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Elided locks do not allow writing to the lock cache line in the fast
path. This would abort the transaction.  They do not actually need
an owner in the speculative fast path, because they do not actually
take the lock. But in the slow path when the lock is taken
they actually want setting the owner, so that adaptive spinning
works correctly.

Right now the mutex code does only allow the architecture to either
opt in fully to always owner or never. Add new fast path wrappers
that combine owner setting with the fast path call and that can
be overwritten by the architecture.

This lets the RTM code only write the owner when not eliding.

This is the initial patch that just moves the code out into
new macros. Noop in itself.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/mutex.c |   79 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 52f2301..982b136 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -26,6 +26,17 @@
 #include <linux/debug_locks.h>
 
 /*
+ * When debugging is enabled we must not clear the owner before time,
+ * the slow path will always be taken, and that clears the owner field
+ * after verifying that it was indeed current.
+ */
+#ifndef CONFIG_DEBUG_MUTEXES
+#define mutex_unlock_clear_owner(l) mutex_clear_owner(l)
+#else
+#define mutex_unlock_clear_owner(l) do {} while(0)
+#endif
+
+/*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
  * which forces all calls into the slowpath:
  */
@@ -37,6 +48,36 @@
 # include <asm/mutex.h>
 #endif
 
+/*
+ * Eliding locks cannot support an owner, so allow the architecture
+ * to disable owner for this case only.
+ *
+ * Below are the default implementations to be used when the architecture
+ * doesn't do anything special.
+ *
+ * Note this cannot be inlines because "s" is a label passed to assembler.
+ */
+#ifndef ARCH_HAS_MUTEX_AND_OWN
+#define __mutex_fastpath_lock_and_own(l, s) ({	\
+	__mutex_fastpath_lock(&(l)->count, s);	\
+	mutex_set_owner(l); })
+#define __mutex_fastpath_unlock_and_unown(l, s) ({	\
+	mutex_unlock_clear_owner(l);			\
+	__mutex_fastpath_unlock(&(l)->count, s); })
+#define __mutex_fastpath_lock_retval_and_own(l, s) ({ \
+	int ret;					     \
+	ret = __mutex_fastpath_lock_retval(&(l)->count, s);  \
+	if (!ret)					     \
+		mutex_set_owner(l);			     \
+	ret; })
+#define __mutex_fastpath_trylock_and_own(l, s) ({			\
+	int ret;							\
+	ret = __mutex_fastpath_trylock(&(l)->count, s);			\
+	if (ret)							\
+		mutex_set_owner(l);					\
+	ret; })
+#endif
+
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -88,8 +129,7 @@ void __sched mutex_lock(struct mutex *lock)
 	 * The locking fastpath is the 1->0 transition from
 	 * 'unlocked' into 'locked' state.
 	 */
-	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
-	mutex_set_owner(lock);
+	__mutex_fastpath_lock_and_own(lock, __mutex_lock_slowpath);
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -114,15 +154,7 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
 	 * into 'unlocked' state:
 	 */
-#ifndef CONFIG_DEBUG_MUTEXES
-	/*
-	 * When debugging is enabled we must not clear the owner before time,
-	 * the slow path will always be taken, and that clears the owner field
-	 * after verifying that it was indeed current.
-	 */
-	mutex_clear_owner(lock);
-#endif
-	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
+	__mutex_fastpath_unlock_and_unown(lock, __mutex_unlock_slowpath);
 }
 
 EXPORT_SYMBOL(mutex_unlock);
@@ -372,11 +404,8 @@ int __sched mutex_lock_interruptible(struct mutex *lock)
 	int ret;
 
 	might_sleep();
-	ret =  __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_interruptible_slowpath);
-	if (!ret)
-		mutex_set_owner(lock);
-
+	return  __mutex_fastpath_lock_retval_and_own(lock,
+					     __mutex_lock_interruptible_slowpath);
 	return ret;
 }
 
@@ -384,15 +413,9 @@ EXPORT_SYMBOL(mutex_lock_interruptible);
 
 int __sched mutex_lock_killable(struct mutex *lock)
 {
-	int ret;
-
 	might_sleep();
-	ret = __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_killable_slowpath);
-	if (!ret)
-		mutex_set_owner(lock);
-
-	return ret;
+	return __mutex_fastpath_lock_retval_and_own(lock,
+					    __mutex_lock_killable_slowpath);
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -464,13 +487,7 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  */
 int __sched mutex_trylock(struct mutex *lock)
 {
-	int ret;
-
-	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
-	if (ret)
-		mutex_set_owner(lock);
-
-	return ret;
+	return __mutex_fastpath_trylock_and_own(lock, __mutex_trylock_slowpath);
 }
 EXPORT_SYMBOL(mutex_trylock);
 
-- 
1.7.7.6

