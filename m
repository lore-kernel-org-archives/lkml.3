Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaG1FUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:20:05 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:11219 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaG1FSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:54 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip/master 4/7] locking/mutex: Refactor optimistic spinning code
Date: Sun, 27 Jul 2014 22:18:41 -0700
Message-Id: <1406524724-17946-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to acquire the mutex in the fastpath, we end up calling
__mutex_lock_common(). A lot goes on in this function. Move out the
optimistic spinning code into mutex_optimistic_spin() and simplify
the former a bit. Furthermore, this is similar to what we have in
rwsems. No logical changes.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/locking/mutex.c | 387 +++++++++++++++++++++++++++----------------------
 1 file changed, 212 insertions(+), 175 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 7a9be39..a925597 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -106,6 +106,92 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
+static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
+						   struct ww_acquire_ctx *ww_ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	/*
+	 * If this WARN_ON triggers, you used ww_mutex_lock to acquire,
+	 * but released with a normal mutex_unlock in this call.
+	 *
+	 * This should never happen, always use ww_mutex_unlock.
+	 */
+	DEBUG_LOCKS_WARN_ON(ww->ctx);
+
+	/*
+	 * Not quite done after calling ww_acquire_done() ?
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
+
+	if (ww_ctx->contending_lock) {
+		/*
+		 * After -EDEADLK you tried to
+		 * acquire a different ww_mutex? Bad!
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
+
+		/*
+		 * You called ww_mutex_lock after receiving -EDEADLK,
+		 * but 'forgot' to unlock everything else first?
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
+		ww_ctx->contending_lock = NULL;
+	}
+
+	/*
+	 * Naughty, using a different class will lead to undefined behavior!
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
+#endif
+	ww_ctx->acquired++;
+}
+
+/*
+ * after acquiring lock with fastpath or when we lost out in contested
+ * slowpath, set ctx and wake up any waiters so they can recheck.
+ *
+ * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
+ * as the fastpath and opportunistic spinning are disabled in that case.
+ */
+static __always_inline void
+ww_mutex_set_context_fastpath(struct ww_mutex *lock,
+			       struct ww_acquire_ctx *ctx)
+{
+	unsigned long flags;
+	struct mutex_waiter *cur;
+
+	ww_mutex_lock_acquired(lock, ctx);
+
+	lock->ctx = ctx;
+
+	/*
+	 * The lock->ctx update should be visible on all cores before
+	 * the atomic read is done, otherwise contended waiters might be
+	 * missed. The contended waiters will either see ww_ctx == NULL
+	 * and keep spinning, or it will acquire wait_lock, add itself
+	 * to waiter list and sleep.
+	 */
+	smp_mb(); /* ^^^ */
+
+	/*
+	 * Check if lock is contended, if not there is nobody to wake up
+	 */
+	if (likely(atomic_read(&lock->base.count) == 0))
+		return;
+
+	/*
+	 * Uh oh, we raced in fastpath, wake up everyone in this case,
+	 * so they can see the new lock->ctx.
+	 */
+	spin_lock_mutex(&lock->base.wait_lock, flags);
+	list_for_each_entry(cur, &lock->base.wait_list, list) {
+		debug_mutex_wake_waiter(&lock->base, cur);
+		wake_up_process(cur->task);
+	}
+	spin_unlock_mutex(&lock->base.wait_lock, flags);
+}
+
+
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 /*
  * In order to avoid a stampede of mutex spinners from acquiring the mutex
@@ -180,6 +266,126 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	 */
 	return retval;
 }
+
+/*
+ * Atomically try to take the lock when it is available */
+static inline bool mutex_try_to_acquire(struct mutex *lock)
+{
+	return !mutex_is_locked(lock) &&
+		(atomic_cmpxchg(&lock->count, 1, 0) == 1);
+}
+
+/*
+ * Optimistic spinning.
+ *
+ * We try to spin for acquisition when we find that the lock owner
+ * is currently running on a (different) CPU and while we don't
+ * need to reschedule. The rationale is that if the lock owner is
+ * running, it is likely to release the lock soon.
+ *
+ * Since this needs the lock owner, and this mutex implementation
+ * doesn't track the owner atomically in the lock field, we need to
+ * track it non-atomically.
+ *
+ * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
+ * to serialize everything.
+ *
+ * The mutex spinners are queued up using MCS lock so that only one
+ * spinner can compete for the mutex. However, if mutex spinning isn't
+ * going to happen, there is no point in going through the lock/unlock
+ * overhead.
+ *
+ * Returns true when the lock was taken, otherwise false, indicating
+ * that we need to jump to the slowpath and sleep.
+ */
+static bool mutex_optimistic_spin(struct mutex *lock,
+				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
+{
+	struct task_struct *task = current;
+
+	if (!mutex_can_spin_on_owner(lock))
+		return false;
+
+	if (!osq_lock(&lock->osq))
+		return false;
+
+	while (true) {
+		struct task_struct *owner;
+
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
+			struct ww_mutex *ww;
+
+			ww = container_of(lock, struct ww_mutex, base);
+			/*
+			 * If ww->ctx is set the contents are undefined, only
+			 * by acquiring wait_lock there is a guarantee that
+			 * they are not invalid when reading.
+			 *
+			 * As such, when deadlock detection needs to be
+			 * performed the optimistic spinning cannot be done.
+			 */
+			if (ACCESS_ONCE(ww->ctx))
+				break;
+		}
+
+		/*
+		 * If there's an owner, wait for it to either
+		 * release the lock or go to sleep.
+		 */
+		owner = ACCESS_ONCE(lock->owner);
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
+
+		/* Try to acquire the mutex if it is unlocked. */
+		if (mutex_try_to_acquire(lock)) {
+			if (use_ww_ctx) {
+				struct ww_mutex *ww;
+				ww = container_of(lock, struct ww_mutex, base);
+
+				ww_mutex_set_context_fastpath(ww, ww_ctx);
+			}
+
+			mutex_set_owner(lock);
+			osq_unlock(&lock->osq);
+			return true;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(task)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		cpu_relax_lowlatency();
+	}
+
+	osq_unlock(&lock->osq);
+
+	/*
+	 * If we fell out of the spin path because of need_resched(),
+	 * reschedule now, before we try-lock the mutex. This avoids getting
+	 * scheduled out right after we obtained the mutex.
+	 */
+	if (need_resched())
+		schedule_preempt_disabled();
+
+	return false;
+}
+#else
+static bool mutex_optimistic_spin(struct mutex *lock,
+				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
+{
+	return false;
+}
 #endif
 
 __visible __used noinline
@@ -277,91 +483,6 @@ __mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
 	return 0;
 }
 
-static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
-						   struct ww_acquire_ctx *ww_ctx)
-{
-#ifdef CONFIG_DEBUG_MUTEXES
-	/*
-	 * If this WARN_ON triggers, you used ww_mutex_lock to acquire,
-	 * but released with a normal mutex_unlock in this call.
-	 *
-	 * This should never happen, always use ww_mutex_unlock.
-	 */
-	DEBUG_LOCKS_WARN_ON(ww->ctx);
-
-	/*
-	 * Not quite done after calling ww_acquire_done() ?
-	 */
-	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
-
-	if (ww_ctx->contending_lock) {
-		/*
-		 * After -EDEADLK you tried to
-		 * acquire a different ww_mutex? Bad!
-		 */
-		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
-
-		/*
-		 * You called ww_mutex_lock after receiving -EDEADLK,
-		 * but 'forgot' to unlock everything else first?
-		 */
-		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
-		ww_ctx->contending_lock = NULL;
-	}
-
-	/*
-	 * Naughty, using a different class will lead to undefined behavior!
-	 */
-	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
-#endif
-	ww_ctx->acquired++;
-}
-
-/*
- * after acquiring lock with fastpath or when we lost out in contested
- * slowpath, set ctx and wake up any waiters so they can recheck.
- *
- * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
- * as the fastpath and opportunistic spinning are disabled in that case.
- */
-static __always_inline void
-ww_mutex_set_context_fastpath(struct ww_mutex *lock,
-			       struct ww_acquire_ctx *ctx)
-{
-	unsigned long flags;
-	struct mutex_waiter *cur;
-
-	ww_mutex_lock_acquired(lock, ctx);
-
-	lock->ctx = ctx;
-
-	/*
-	 * The lock->ctx update should be visible on all cores before
-	 * the atomic read is done, otherwise contended waiters might be
-	 * missed. The contended waiters will either see ww_ctx == NULL
-	 * and keep spinning, or it will acquire wait_lock, add itself
-	 * to waiter list and sleep.
-	 */
-	smp_mb(); /* ^^^ */
-
-	/*
-	 * Check if lock is contended, if not there is nobody to wake up
-	 */
-	if (likely(atomic_read(&lock->base.count) == 0))
-		return;
-
-	/*
-	 * Uh oh, we raced in fastpath, wake up everyone in this case,
-	 * so they can see the new lock->ctx.
-	 */
-	spin_lock_mutex(&lock->base.wait_lock, flags);
-	list_for_each_entry(cur, &lock->base.wait_list, list) {
-		debug_mutex_wake_waiter(&lock->base, cur);
-		wake_up_process(cur->task);
-	}
-	spin_unlock_mutex(&lock->base.wait_lock, flags);
-}
-
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -378,96 +499,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
-#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	/*
-	 * Optimistic spinning.
-	 *
-	 * We try to spin for acquisition when we find that the lock owner
-	 * is currently running on a (different) CPU and while we don't
-	 * need to reschedule. The rationale is that if the lock owner is
-	 * running, it is likely to release the lock soon.
-	 *
-	 * Since this needs the lock owner, and this mutex implementation
-	 * doesn't track the owner atomically in the lock field, we need to
-	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
-	 *
-	 * The mutex spinners are queued up using MCS lock so that only one
-	 * spinner can compete for the mutex. However, if mutex spinning isn't
-	 * going to happen, there is no point in going through the lock/unlock
-	 * overhead.
-	 */
-	if (!mutex_can_spin_on_owner(lock))
-		goto slowpath;
-
-	if (!osq_lock(&lock->osq))
-		goto slowpath;
-
-	for (;;) {
-		struct task_struct *owner;
-
-		if (use_ww_ctx && ww_ctx->acquired > 0) {
-			struct ww_mutex *ww;
-
-			ww = container_of(lock, struct ww_mutex, base);
-			/*
-			 * If ww->ctx is set the contents are undefined, only
-			 * by acquiring wait_lock there is a guarantee that
-			 * they are not invalid when reading.
-			 *
-			 * As such, when deadlock detection needs to be
-			 * performed the optimistic spinning cannot be done.
-			 */
-			if (ACCESS_ONCE(ww->ctx))
-				break;
-		}
-
-		/*
-		 * If there's an owner, wait for it to either
-		 * release the lock or go to sleep.
-		 */
-		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
-			break;
-
-		/* Try to acquire the mutex if it is unlocked. */
-		if (!mutex_is_locked(lock) &&
-		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
-			lock_acquired(&lock->dep_map, ip);
-			if (use_ww_ctx) {
-				struct ww_mutex *ww;
-				ww = container_of(lock, struct ww_mutex, base);
-
-				ww_mutex_set_context_fastpath(ww, ww_ctx);
-			}
-
-			mutex_set_owner(lock);
-			osq_unlock(&lock->osq);
-			preempt_enable();
-			return 0;
-		}
-
-		/*
-		 * When there's no owner, we might have preempted between the
-		 * owner acquiring the lock and setting the owner field. If
-		 * we're an RT task that will live-lock because we won't let
-		 * the owner complete.
-		 */
-		if (!owner && (need_resched() || rt_task(task)))
-			break;
-
-		/*
-		 * The cpu_relax() call is a compiler barrier which forces
-		 * everything in this loop to be re-loaded. We don't need
-		 * memory barriers as we'll eventually observe the right
-		 * values at the cost of a few extra spins.
-		 */
-		cpu_relax_lowlatency();
+	if (mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx)) {
+		/* got it, yay! */
+		preempt_enable();
+		return 0;
 	}
-	osq_unlock(&lock->osq);
-slowpath:
+
 	/*
 	 * If we fell out of the spin path because of need_resched(),
 	 * reschedule now, before we try-lock the mutex. This avoids getting
@@ -475,7 +512,7 @@ slowpath:
 	 */
 	if (need_resched())
 		schedule_preempt_disabled();
-#endif
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	/*
-- 
1.8.1.4

