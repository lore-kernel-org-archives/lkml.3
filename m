Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3KVVLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:11:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:47175 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3KVVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:11:21 -0500
Date: Fri, 22 Nov 2013 22:11:19 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.1-rt4
Message-ID: <20131122211119.GL8698@linutronix.de>
References: <20131116194633.GD11518@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131116194633.GD11518@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.1-rt4 patch set.

Changes since v3.12.0-rt2
- rtmutex: the patch with the conversion to raw_spinlock_irq() of the
  waiter lock has been replaced by a trylock attempt this keeps the
  change a lot smaller. Initially suggested by Matt Cowell.
  There is also a special unlock function so lockdep does not complain
  on the in unlock path.
- A patch from Peter Zijlstra so lockdep sees the locking problem from
  above.
- migrate_disable() does not invoke preempt_enable() +
  preempt_disable() on recursion. An optimisation by Nicholas Mc Guire.
- rt_mutex_trylock() does not invoke migrate_disable() +
  migrate_enable() in the case where it did not get the lock. An
  optimisation by Nicholas Mc Guire.

Known issues:

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The delta patch against v3.12.1-rt3 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.1-rt3-rt4.patch.xz

The RT patch against 3.12.1 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.1-rt4.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.1-rt4.tar.xz

Sebastian

diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 0618387..b3c504b 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -22,6 +22,7 @@ extern void __lockfunc rt_spin_lock(spinlock_t *lock);
 extern unsigned long __lockfunc rt_spin_lock_trace_flags(spinlock_t *lock);
 extern void __lockfunc rt_spin_lock_nested(spinlock_t *lock, int subclass);
 extern void __lockfunc rt_spin_unlock(spinlock_t *lock);
+extern void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock);
 extern void __lockfunc rt_spin_unlock_wait(spinlock_t *lock);
 extern int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags);
 extern int __lockfunc rt_spin_trylock_bh(spinlock_t *lock);
diff --git a/kernel/futex.c b/kernel/futex.c
index 404d0bd..0ef419d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -891,7 +891,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	if (pi_state->owner != current)
 		return -EINVAL;
 
-	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -917,21 +917,21 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 		else if (curval != uval)
 			ret = -EINVAL;
 		if (ret) {
-			raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			return ret;
 		}
 	}
 
-	raw_spin_lock(&pi_state->owner->pi_lock);
+	raw_spin_lock_irq(&pi_state->owner->pi_lock);
 	WARN_ON(list_empty(&pi_state->list));
 	list_del_init(&pi_state->list);
-	raw_spin_unlock(&pi_state->owner->pi_lock);
+	raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-	raw_spin_lock(&new_owner->pi_lock);
+	raw_spin_lock_irq(&new_owner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &new_owner->pi_state_list);
 	pi_state->owner = new_owner;
-	raw_spin_unlock(&new_owner->pi_lock);
+	raw_spin_unlock_irq(&new_owner->pi_lock);
 
 	raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
@@ -1762,11 +1762,11 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * we returned due to timeout or signal without taking the
 		 * rt_mutex. Too late.
 		 */
-		raw_spin_lock_irq(&q->pi_state->pi_mutex.wait_lock);
+		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
 		if (!owner)
 			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
-		raw_spin_unlock_irq(&q->pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
 		ret = fixup_pi_state_owner(uaddr, q, owner);
 		goto out;
 	}
diff --git a/kernel/rt.c b/kernel/rt.c
index 433ae42..4b2c4a9 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -182,11 +182,10 @@ int __lockfunc rt_write_trylock(rwlock_t *rwlock)
 {
 	int ret = rt_mutex_trylock(&rwlock->lock);
 
-	migrate_disable();
-	if (ret)
+	if (ret) {
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-	else
-		migrate_enable();
+		migrate_disable();
+	}
 
 	return ret;
 }
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index c2f3f63..4e9691f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -298,7 +298,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
 	/* Release the task */
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	if (!rt_mutex_owner(lock)) {
 		struct rt_mutex_waiter *lock_top_waiter;
 
@@ -309,7 +309,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		lock_top_waiter = rt_mutex_top_waiter(lock);
 		if (top_waiter != lock_top_waiter)
 			rt_mutex_wake_waiter(lock_top_waiter);
-		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
 		goto out_put_task;
 	}
 	put_task_struct(task);
@@ -317,7 +317,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	raw_spin_lock(&task->pi_lock);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
@@ -335,10 +335,10 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		__rt_mutex_adjust_prio(task);
 	}
 
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	top_waiter = rt_mutex_top_waiter(lock);
-	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+	raw_spin_unlock(&lock->wait_lock);
 
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
@@ -425,9 +425,10 @@ __try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	/* We got the lock. */
 
 	if (waiter || rt_mutex_has_waiters(lock)) {
+		unsigned long flags;
 		struct rt_mutex_waiter *top;
 
-		raw_spin_lock(&task->pi_lock);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 		/* remove the queued waiter. */
 		if (waiter) {
@@ -444,7 +445,7 @@ __try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 			top->pi_list_entry.prio = top->list_entry.prio;
 			plist_add(&top->pi_list_entry, &task->pi_waiters);
 		}
-		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
 
 	debug_rt_mutex_lock(lock);
@@ -477,9 +478,10 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
+	unsigned long flags;
 	int chain_walk = 0, res;
 
-	raw_spin_lock(&task->pi_lock);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	/*
 	 * In the case of futex requeue PI, this will be a proxy
@@ -491,7 +493,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 * the task if PI_WAKEUP_INPROGRESS is set.
 	 */
 	if (task != current && task->pi_blocked_on == PI_WAKEUP_INPROGRESS) {
-		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return -EAGAIN;
 	}
 
@@ -510,20 +512,20 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	task->pi_blocked_on = waiter;
 
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	if (!owner)
 		return 0;
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock(&owner->pi_lock);
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
 		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
-		raw_spin_unlock(&owner->pi_lock);
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;
@@ -538,12 +540,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 */
 	get_task_struct(owner);
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
 					 task);
 
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	return res;
 }
@@ -558,8 +560,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
+	unsigned long flags;
 
-	raw_spin_lock(&current->pi_lock);
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
 
 	waiter = rt_mutex_top_waiter(lock);
 
@@ -573,7 +576,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 
 	rt_mutex_set_owner(lock, NULL);
 
-	raw_spin_unlock(&current->pi_lock);
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	rt_mutex_wake_waiter(waiter);
 }
@@ -589,19 +592,20 @@ static void remove_waiter(struct rt_mutex *lock,
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	unsigned long flags;
 	int chain_walk = 0;
 
-	raw_spin_lock(&current->pi_lock);
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	current->pi_blocked_on = NULL;
-	raw_spin_unlock(&current->pi_lock);
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	if (!owner)
 		return;
 
 	if (first) {
 
-		raw_spin_lock(&owner->pi_lock);
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
 		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
 
@@ -616,7 +620,7 @@ static void remove_waiter(struct rt_mutex *lock,
 		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
 
-		raw_spin_unlock(&owner->pi_lock);
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
 	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
@@ -627,11 +631,11 @@ static void remove_waiter(struct rt_mutex *lock,
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(owner);
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
 
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 }
 
 /*
@@ -719,6 +723,9 @@ static int adaptive_wait(struct rt_mutex *lock,
 }
 #endif
 
+# define pi_lock(lock)			raw_spin_lock_irq(lock)
+# define pi_unlock(lock)		raw_spin_unlock_irq(lock)
+
 /*
  * Slow path lock function spin_lock style: this variant is very
  * careful not to miss any non-lock wakeups.
@@ -730,22 +737,19 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 {
 	struct task_struct *lock_owner, *self = current;
 	struct rt_mutex_waiter waiter, *top_waiter;
-	unsigned long flags;
 	int ret;
 
 	rt_mutex_init_waiter(&waiter, true);
 
-	raw_local_save_flags(flags);
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 	init_lists(lock);
 
 	if (__try_to_take_rt_mutex(lock, self, NULL, STEAL_LATERAL)) {
-		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
 		return;
 	}
 
 	BUG_ON(rt_mutex_owner(lock) == self);
-	BUG_ON(arch_irqs_disabled_flags(flags));
 
 	/*
 	 * We save whatever state the task is in and we'll restore it
@@ -753,10 +757,10 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * as well. We are serialized via pi_lock against wakeups. See
 	 * try_to_wake_up().
 	 */
-	raw_spin_lock(&self->pi_lock);
+	pi_lock(&self->pi_lock);
 	self->saved_state = self->state;
 	__set_current_state(TASK_UNINTERRUPTIBLE);
-	raw_spin_unlock(&self->pi_lock);
+	pi_unlock(&self->pi_lock);
 
 	ret = task_blocks_on_rt_mutex(lock, &waiter, self, 0);
 	BUG_ON(ret);
@@ -769,18 +773,18 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 		top_waiter = rt_mutex_top_waiter(lock);
 		lock_owner = rt_mutex_owner(lock);
 
-		raw_spin_unlock_irq(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
 		if (top_waiter != &waiter || adaptive_wait(lock, lock_owner))
 			schedule_rt_mutex(lock);
 
-		raw_spin_lock_irq(&lock->wait_lock);
+		raw_spin_lock(&lock->wait_lock);
 
-		raw_spin_lock(&self->pi_lock);
+		pi_lock(&self->pi_lock);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		raw_spin_unlock(&self->pi_lock);
+		pi_unlock(&self->pi_lock);
 	}
 
 	/*
@@ -790,10 +794,10 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * happened while we were blocked. Clear saved_state so
 	 * try_to_wakeup() does not get confused.
 	 */
-	raw_spin_lock(&self->pi_lock);
+	pi_lock(&self->pi_lock);
 	__set_current_state(self->saved_state);
 	self->saved_state = TASK_RUNNING;
-	raw_spin_unlock(&self->pi_lock);
+	pi_unlock(&self->pi_lock);
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -804,7 +808,7 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	BUG_ON(rt_mutex_has_waiters(lock) && &waiter == rt_mutex_top_waiter(lock));
 	BUG_ON(!plist_node_empty(&waiter.list_entry));
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_free_waiter(&waiter);
 }
@@ -812,30 +816,43 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 /*
  * Slow path to release a rt_mutex spin_lock style
  */
-static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+static void __sched __rt_spin_lock_slowunlock(struct rt_mutex *lock)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&lock->wait_lock, flags);
-
 	debug_rt_mutex_unlock(lock);
 
 	rt_mutex_deadlock_account_unlock(current);
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/* Undo pi boosting.when necessary */
 	rt_mutex_adjust_prio(current);
 }
 
+static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+{
+	raw_spin_lock(&lock->wait_lock);
+	__rt_spin_lock_slowunlock(lock);
+}
+
+static void  noinline __sched rt_spin_lock_slowunlock_hirq(struct rt_mutex *lock)
+{
+	int ret;
+
+	do {
+		ret = raw_spin_trylock(&lock->wait_lock);
+	} while (!ret);
+
+	__rt_spin_lock_slowunlock(lock);
+}
+
 void __lockfunc rt_spin_lock(spinlock_t *lock)
 {
 	rt_spin_lock_fastlock(&lock->lock, rt_spin_lock_slowlock);
@@ -866,6 +883,13 @@ void __lockfunc rt_spin_unlock(spinlock_t *lock)
 }
 EXPORT_SYMBOL(rt_spin_unlock);
 
+void __lockfunc rt_spin_unlock_after_trylock_in_irq(spinlock_t *lock)
+{
+	/* NOTE: we always pass in '1' for nested, for simplicity */
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	rt_spin_lock_fastunlock(&lock->lock, rt_spin_lock_slowunlock_hirq);
+}
+
 void __lockfunc __rt_spin_unlock(struct rt_mutex *lock)
 {
 	rt_spin_lock_fastunlock(lock, rt_spin_lock_slowunlock);
@@ -1030,13 +1054,13 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		raw_spin_unlock_irq(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
-		raw_spin_lock_irq(&lock->wait_lock);
+		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
 
@@ -1128,23 +1152,20 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		  int detect_deadlock, struct ww_acquire_ctx *ww_ctx)
 {
 	struct rt_mutex_waiter waiter;
-	unsigned long flags;
 	int ret = 0;
 
 	rt_mutex_init_waiter(&waiter, false);
 
-	raw_local_save_flags(flags);
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 	init_lists(lock);
 
 	/* Try to acquire the lock again: */
 	if (try_to_take_rt_mutex(lock, current, NULL)) {
 		if (ww_ctx)
 			ww_mutex_account_lock(lock, ww_ctx);
-		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
 		return 0;
 	}
-	BUG_ON(arch_irqs_disabled_flags(flags));
 
 	set_current_state(state);
 
@@ -1173,7 +1194,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/* Remove pending timer: */
 	if (unlikely(timeout))
@@ -1190,10 +1211,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 static inline int
 rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
-	unsigned long flags;
 	int ret = 0;
 
-	raw_spin_lock_irqsave(&lock->wait_lock, flags);
+	if (!raw_spin_trylock(&lock->wait_lock))
+		return ret;
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
@@ -1206,7 +1227,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 		fixup_rt_mutex_waiters(lock);
 	}
 
-	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+	raw_spin_unlock(&lock->wait_lock);
 
 	return ret;
 }
@@ -1217,9 +1238,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 static void __sched
 rt_mutex_slowunlock(struct rt_mutex *lock)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&lock->wait_lock, flags);
+	raw_spin_lock(&lock->wait_lock);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -1227,13 +1246,13 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/* Undo pi boosting if necessary: */
 	rt_mutex_adjust_prio(current);
@@ -1493,10 +1512,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock_irq(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		return 1;
 	}
 
@@ -1519,17 +1538,18 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
 	 * it will know that we are in the process of requeuing it.
 	 */
-	raw_spin_lock(&task->pi_lock);
+	raw_spin_lock_irq(&task->pi_lock);
 	if (task->pi_blocked_on) {
-		raw_spin_unlock(&task->pi_lock);
-		raw_spin_unlock_irq(&lock->wait_lock);
+		raw_spin_unlock_irq(&task->pi_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		return -EAGAIN;
 	}
 	task->pi_blocked_on = PI_REQUEUE_INPROGRESS;
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irq(&task->pi_lock);
 #endif
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
 		 * Reset the return value. We might have
@@ -1543,7 +1563,7 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (unlikely(ret))
 		remove_waiter(lock, waiter);
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
 
@@ -1593,11 +1613,12 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 {
 	int ret;
 
-	raw_spin_lock_irq(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter, NULL);
+
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(ret))
@@ -1609,7 +1630,7 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock_irq(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	return ret;
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a7fafc28..22fa2e2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2418,13 +2418,12 @@ void migrate_disable(void)
 	}
 #endif
 
-	preempt_disable();
 	if (p->migrate_disable) {
 		p->migrate_disable++;
-		preempt_enable();
 		return;
 	}
 
+	preempt_disable();
 	preempt_lazy_disable();
 	pin_current_cpu();
 	p->migrate_disable = 1;
@@ -2454,13 +2453,12 @@ void migrate_enable(void)
 #endif
 	WARN_ON_ONCE(p->migrate_disable <= 0);
 
-	preempt_disable();
 	if (migrate_disable_count(p) > 1) {
 		p->migrate_disable--;
-		preempt_enable();
 		return;
 	}
 
+	preempt_disable();
 	if (unlikely(migrate_disabled_updated(p))) {
 		/*
 		 * Undo whatever update_migrate_disable() did, also see there
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 6c99698..9a7268f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -354,13 +354,51 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 #define MAX_SOFTIRQ_RESTART 10
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/*
+ * Convoluted means of passing __do_softirq() a message through the various
+ * architecture execute_on_stack() bits.
+ *
+ * When we run softirqs from irq_exit() and thus on the hardirq stack we need
+ * to keep the lockdep irq context tracking as tight as possible in order to
+ * not miss-qualify lock contexts and miss possible deadlocks.
+ */
+static DEFINE_PER_CPU(int, softirq_from_hardirq);
+
+static inline void lockdep_softirq_from_hardirq(void)
+{
+	this_cpu_write(softirq_from_hardirq, 1);
+}
+
+static inline void lockdep_softirq_start(void)
+{
+	if (this_cpu_read(softirq_from_hardirq))
+		trace_hardirq_exit();
+	lockdep_softirq_enter();
+}
+
+static inline void lockdep_softirq_end(void)
+{
+	lockdep_softirq_exit();
+	if (this_cpu_read(softirq_from_hardirq)) {
+		this_cpu_write(softirq_from_hardirq, 0);
+		trace_hardirq_enter();
+	}
+}
+
+#else
+static inline void lockdep_softirq_from_hardirq(void) { }
+static inline void lockdep_softirq_start(void) { }
+static inline void lockdep_softirq_end(void) { }
+#endif
+
 asmlinkage void __do_softirq(void)
 {
-	__u32 pending;
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
-	int cpu;
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
+	__u32 pending;
+	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -373,7 +411,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -391,8 +429,7 @@ asmlinkage void __do_softirq(void)
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_exit();
-
+	lockdep_softirq_end();
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
@@ -698,6 +735,7 @@ static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 		/*
 		 * We can safely execute softirq on the current stack if
 		 * it is the irq stack, because it should be near empty
@@ -746,13 +784,13 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	sub_preempt_count(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 }
 
 void raise_softirq(unsigned int nr)
diff --git a/kernel/timer.c b/kernel/timer.c
index fa4a92a..b06c647 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1400,7 +1400,7 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 		expires = base->next_timer;
 	}
 #ifdef CONFIG_PREEMPT_RT_FULL
-	rt_spin_unlock(&base->lock);
+	rt_spin_unlock_after_trylock_in_irq(&base->lock);
 #else
 	spin_unlock(&base->lock);
 #endif
diff --git a/localversion-rt b/localversion-rt
index 1445cd6..ad3da1b 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt3
+-rt4
