Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaA1TN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:13:58 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44908 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaA1TNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:13:55 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [RFC][PATCH v2 4/5] mutex: Disable preemtion between modifying lock->owner and locking/unlocking mutex
Date: Tue, 28 Jan 2014 11:13:15 -0800
Message-Id: <1390936396-3962-5-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC patch disables preemption between modifying lock->owner and
locking/unlocking the mutex lock. This prevents situations where the owner
can preempt between those 2 operations, which causes optimistic spinners to
be unable to check if lock->owner is not on CPU. As mentioned in the
thread for this v1 patchset, disabling preemption is a cheap operation.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 6d85b08..cfaaf53 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -98,8 +98,10 @@ void __sched mutex_lock(struct mutex *lock)
 	 * The locking fastpath is the 1->0 transition from
 	 * 'unlocked' into 'locked' state.
 	 */
+	preempt_disable();
 	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
 	mutex_set_owner(lock);
+	preempt_enable();
 }
 
 EXPORT_SYMBOL(mutex_lock);
@@ -253,9 +255,13 @@ void __sched mutex_unlock(struct mutex *lock)
 	 * the slow path will always be taken, and that clears the owner field
 	 * after verifying that it was indeed current.
 	 */
+	preempt_disable();
 	mutex_clear_owner(lock);
 #endif
 	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
+#ifndef CONFIG_DEBUG_MUTEXES
+	preempt_enable();
+#endif
 }
 
 EXPORT_SYMBOL(mutex_unlock);
@@ -292,9 +298,13 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
 	 * the slow path will always be taken, and that clears the owner field
 	 * after verifying that it was indeed current.
 	 */
+	preempt_disable();
 	mutex_clear_owner(&lock->base);
 #endif
 	__mutex_fastpath_unlock(&lock->base.count, __mutex_unlock_slowpath);
+#ifndef CONFIG_DEBUG_MUTEXES
+	preempt_enable();
+#endif
 }
 EXPORT_SYMBOL(ww_mutex_unlock);
 
@@ -780,12 +790,16 @@ int __sched mutex_lock_interruptible(struct mutex *lock)
 	int ret;
 
 	might_sleep();
+	preempt_disable();
 	ret =  __mutex_fastpath_lock_retval(&lock->count);
 	if (likely(!ret)) {
 		mutex_set_owner(lock);
+		preempt_enable();
 		return 0;
-	} else
+	} else {
+		preempt_enable();
 		return __mutex_lock_interruptible_slowpath(lock);
+	}
 }
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
@@ -795,12 +809,16 @@ int __sched mutex_lock_killable(struct mutex *lock)
 	int ret;
 
 	might_sleep();
+	preempt_disable();
 	ret = __mutex_fastpath_lock_retval(&lock->count);
 	if (likely(!ret)) {
 		mutex_set_owner(lock);
+		preempt_enable();
 		return 0;
-	} else
+	} else {
+		preempt_enable();
 		return __mutex_lock_killable_slowpath(lock);
+	}
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -889,9 +907,11 @@ int __sched mutex_trylock(struct mutex *lock)
 {
 	int ret;
 
+	preempt_disable();
 	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
 	if (ret)
 		mutex_set_owner(lock);
+	preempt_enable();
 
 	return ret;
 }
@@ -904,6 +924,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	int ret;
 
 	might_sleep();
+	preempt_disable();
 
 	ret = __mutex_fastpath_lock_retval(&lock->base.count);
 
@@ -912,6 +933,8 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 		mutex_set_owner(&lock->base);
 	} else
 		ret = __ww_mutex_lock_slowpath(lock, ctx);
+
+	preempt_enable();
 	return ret;
 }
 EXPORT_SYMBOL(__ww_mutex_lock);
@@ -922,6 +945,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	int ret;
 
 	might_sleep();
+	preempt_disable();
 
 	ret = __mutex_fastpath_lock_retval(&lock->base.count);
 
@@ -930,6 +954,8 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 		mutex_set_owner(&lock->base);
 	} else
 		ret = __ww_mutex_lock_interruptible_slowpath(lock, ctx);
+
+	preempt_enable();
 	return ret;
 }
 EXPORT_SYMBOL(__ww_mutex_lock_interruptible);
-- 
1.7.1

