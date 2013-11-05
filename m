Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3KEMXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:23:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3KEMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:43 -0500
Message-Id: <20131105110027.281616550@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 6/8] locking: Move rwsem into kernel/locking/
References: <20131105105244.666320103@infradead.org>
Content-Disposition: inline; filename=peterz-move-locking-rwsem.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notably: changed lib/rwsem* targets from lib- to obj-, no idea about
the ramifications of that.

Cc: dhowells@redhat.com
Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Makefile                 |    2 
 kernel/locking/Makefile         |    4 
 kernel/locking/rwsem-spinlock.c |  296 ++++++++++++++++++++++++++++++++++++++++
 kernel/locking/rwsem-xadd.c     |  293 +++++++++++++++++++++++++++++++++++++++
 kernel/locking/rwsem.c          |  157 +++++++++++++++++++++
 kernel/rwsem.c                  |  157 ---------------------
 lib/Makefile                    |    2 
 lib/rwsem-spinlock.c            |  296 ----------------------------------------
 lib/rwsem.c                     |  293 ---------------------------------------
 9 files changed, 750 insertions(+), 750 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    extable.o params.o posix-timers.o \
 	    kthread.o sys_ni.o posix-cpu-timers.o \
-	    hrtimer.o rwsem.o nsproxy.o \
+	    hrtimer.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
 
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o
+obj-y += mutex.o semaphore.o rwsem.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -20,3 +20,5 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmute
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
+obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
+obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
\ No newline at end of file
--- /dev/null
+++ b/kernel/locking/rwsem-spinlock.c
@@ -0,0 +1,296 @@
+/* rwsem-spinlock.c: R/W semaphores: contention handling functions for
+ * generic spinlock implementation
+ *
+ * Copyright (c) 2001   David Howells (dhowells@redhat.com).
+ * - Derived partially from idea by Andrea Arcangeli <andrea@suse.de>
+ * - Derived also from comments by Linus
+ */
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+#include <linux/export.h>
+
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ
+};
+
+struct rwsem_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	enum rwsem_waiter_type type;
+};
+
+int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	int ret = 1;
+	unsigned long flags;
+
+	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
+		ret = (sem->activity != 0);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(rwsem_is_locked);
+
+/*
+ * initialise the semaphore
+ */
+void __init_rwsem(struct rw_semaphore *sem, const char *name,
+		  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held semaphore:
+	 */
+	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
+	lockdep_init_map(&sem->dep_map, name, key, 0);
+#endif
+	sem->activity = 0;
+	raw_spin_lock_init(&sem->wait_lock);
+	INIT_LIST_HEAD(&sem->wait_list);
+}
+EXPORT_SYMBOL(__init_rwsem);
+
+/*
+ * handle the lock release when processes blocked on it that can now run
+ * - if we come here, then:
+ *   - the 'active count' _reached_ zero
+ *   - the 'waiting count' is non-zero
+ * - the spinlock must be held by the caller
+ * - woken process blocks are discarded from the list after having task zeroed
+ * - writers are only woken if wakewrite is non-zero
+ */
+static inline struct rw_semaphore *
+__rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
+{
+	struct rwsem_waiter *waiter;
+	struct task_struct *tsk;
+	int woken;
+
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+
+	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
+		if (wakewrite)
+			/* Wake up a writer. Note that we do not grant it the
+			 * lock - it will have to acquire it when it runs. */
+			wake_up_process(waiter->task);
+		goto out;
+	}
+
+	/* grant an infinite number of read locks to the front of the queue */
+	woken = 0;
+	do {
+		struct list_head *next = waiter->list.next;
+
+		list_del(&waiter->list);
+		tsk = waiter->task;
+		smp_mb();
+		waiter->task = NULL;
+		wake_up_process(tsk);
+		put_task_struct(tsk);
+		woken++;
+		if (next == &sem->wait_list)
+			break;
+		waiter = list_entry(next, struct rwsem_waiter, list);
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
+
+	sem->activity += woken;
+
+ out:
+	return sem;
+}
+
+/*
+ * wake a single writer
+ */
+static inline struct rw_semaphore *
+__rwsem_wake_one_writer(struct rw_semaphore *sem)
+{
+	struct rwsem_waiter *waiter;
+
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	wake_up_process(waiter->task);
+
+	return sem;
+}
+
+/*
+ * get a read lock on the semaphore
+ */
+void __sched __down_read(struct rw_semaphore *sem)
+{
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
+		/* granted */
+		sem->activity++;
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+		goto out;
+	}
+
+	tsk = current;
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_READ;
+	get_task_struct(tsk);
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we don't need to touch the semaphore struct anymore */
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	/* wait to be given the lock */
+	for (;;) {
+		if (!waiter.task)
+			break;
+		schedule();
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	}
+
+	tsk->state = TASK_RUNNING;
+ out:
+	;
+}
+
+/*
+ * trylock for reading -- returns 1 if successful, 0 if contention
+ */
+int __down_read_trylock(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+	int ret = 0;
+
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
+		/* granted */
+		sem->activity++;
+		ret = 1;
+	}
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	return ret;
+}
+
+/*
+ * get a write lock on the semaphore
+ */
+void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
+{
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	/* set up my own style of waitqueue */
+	tsk = current;
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_WRITE;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* wait for someone to release the lock */
+	for (;;) {
+		/*
+		 * That is the key to support write lock stealing: allows the
+		 * task already on CPU to get the lock soon rather than put
+		 * itself into sleep and waiting for system woke it or someone
+		 * else in the head of the wait list up.
+		 */
+		if (sem->activity == 0)
+			break;
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+		schedule();
+		raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	}
+	/* got the lock */
+	sem->activity = -1;
+	list_del(&waiter.list);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+void __sched __down_write(struct rw_semaphore *sem)
+{
+	__down_write_nested(sem, 0);
+}
+
+/*
+ * trylock for writing -- returns 1 if successful, 0 if contention
+ */
+int __down_write_trylock(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	if (sem->activity == 0) {
+		/* got the lock */
+		sem->activity = -1;
+		ret = 1;
+	}
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	return ret;
+}
+
+/*
+ * release a read lock on the semaphore
+ */
+void __up_read(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	if (--sem->activity == 0 && !list_empty(&sem->wait_list))
+		sem = __rwsem_wake_one_writer(sem);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+/*
+ * release a write lock on the semaphore
+ */
+void __up_write(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	sem->activity = 0;
+	if (!list_empty(&sem->wait_list))
+		sem = __rwsem_do_wake(sem, 1);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+/*
+ * downgrade a write lock into a read lock
+ * - just wake up any readers at the front of the queue
+ */
+void __downgrade_write(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	sem->activity = 1;
+	if (!list_empty(&sem->wait_list))
+		sem = __rwsem_do_wake(sem, 0);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
--- /dev/null
+++ b/kernel/locking/rwsem-xadd.c
@@ -0,0 +1,293 @@
+/* rwsem.c: R/W semaphores: contention handling functions
+ *
+ * Written by David Howells (dhowells@redhat.com).
+ * Derived from arch/i386/kernel/semaphore.c
+ *
+ * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
+ * and Michel Lespinasse <walken@google.com>
+ */
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/export.h>
+
+/*
+ * Initialize an rwsem:
+ */
+void __init_rwsem(struct rw_semaphore *sem, const char *name,
+		  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held semaphore:
+	 */
+	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
+	lockdep_init_map(&sem->dep_map, name, key, 0);
+#endif
+	sem->count = RWSEM_UNLOCKED_VALUE;
+	raw_spin_lock_init(&sem->wait_lock);
+	INIT_LIST_HEAD(&sem->wait_list);
+}
+
+EXPORT_SYMBOL(__init_rwsem);
+
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ
+};
+
+struct rwsem_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	enum rwsem_waiter_type type;
+};
+
+enum rwsem_wake_type {
+	RWSEM_WAKE_ANY,		/* Wake whatever's at head of wait list */
+	RWSEM_WAKE_READERS,	/* Wake readers only */
+	RWSEM_WAKE_READ_OWNED	/* Waker thread holds the read lock */
+};
+
+/*
+ * handle the lock release when processes blocked on it that can now run
+ * - if we come here from up_xxxx(), then:
+ *   - the 'active part' of count (&0x0000ffff) reached 0 (but may have changed)
+ *   - the 'waiting part' of count (&0xffff0000) is -ve (and will still be so)
+ * - there must be someone on the queue
+ * - the spinlock must be held by the caller
+ * - woken process blocks are discarded from the list after having task zeroed
+ * - writers are only woken if downgrading is false
+ */
+static struct rw_semaphore *
+__rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
+{
+	struct rwsem_waiter *waiter;
+	struct task_struct *tsk;
+	struct list_head *next;
+	long oldcount, woken, loop, adjustment;
+
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
+		if (wake_type == RWSEM_WAKE_ANY)
+			/* Wake writer at the front of the queue, but do not
+			 * grant it the lock yet as we want other writers
+			 * to be able to steal it.  Readers, on the other hand,
+			 * will block as they will notice the queued writer.
+			 */
+			wake_up_process(waiter->task);
+		goto out;
+	}
+
+	/* Writers might steal the lock before we grant it to the next reader.
+	 * We prefer to do the first reader grant before counting readers
+	 * so we can bail out early if a writer stole the lock.
+	 */
+	adjustment = 0;
+	if (wake_type != RWSEM_WAKE_READ_OWNED) {
+		adjustment = RWSEM_ACTIVE_READ_BIAS;
+ try_reader_grant:
+		oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
+		if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
+			/* A writer stole the lock. Undo our reader grant. */
+			if (rwsem_atomic_update(-adjustment, sem) &
+						RWSEM_ACTIVE_MASK)
+				goto out;
+			/* Last active locker left. Retry waking readers. */
+			goto try_reader_grant;
+		}
+	}
+
+	/* Grant an infinite number of read locks to the readers at the front
+	 * of the queue.  Note we increment the 'active part' of the count by
+	 * the number of readers before waking any processes up.
+	 */
+	woken = 0;
+	do {
+		woken++;
+
+		if (waiter->list.next == &sem->wait_list)
+			break;
+
+		waiter = list_entry(waiter->list.next,
+					struct rwsem_waiter, list);
+
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
+
+	adjustment = woken * RWSEM_ACTIVE_READ_BIAS - adjustment;
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
+		/* hit end of list above */
+		adjustment -= RWSEM_WAITING_BIAS;
+
+	if (adjustment)
+		rwsem_atomic_add(adjustment, sem);
+
+	next = sem->wait_list.next;
+	loop = woken;
+	do {
+		waiter = list_entry(next, struct rwsem_waiter, list);
+		next = waiter->list.next;
+		tsk = waiter->task;
+		smp_mb();
+		waiter->task = NULL;
+		wake_up_process(tsk);
+		put_task_struct(tsk);
+	} while (--loop);
+
+	sem->wait_list.next = next;
+	next->prev = &sem->wait_list;
+
+ out:
+	return sem;
+}
+
+/*
+ * wait for the read lock to be granted
+ */
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
+{
+	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_READ;
+	get_task_struct(tsk);
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we're now waiting on the lock, but no longer actively locking */
+	count = rwsem_atomic_update(adjustment, sem);
+
+	/* If there are no active locks, wake the front queued process(es).
+	 *
+	 * If there are no writers and we are first in the queue,
+	 * wake our own waiter to join the existing active readers !
+	 */
+	if (count == RWSEM_WAITING_BIAS ||
+	    (count > RWSEM_WAITING_BIAS &&
+	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!waiter.task)
+			break;
+		schedule();
+	}
+
+	tsk->state = TASK_RUNNING;
+
+	return sem;
+}
+
+/*
+ * wait until we successfully acquire the write lock
+ */
+struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
+{
+	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_WRITE;
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we're now waiting on the lock, but no longer actively locking */
+	count = rwsem_atomic_update(adjustment, sem);
+
+	/* If there were already threads queued before us and there are no
+	 * active writers, the lock must be read owned; so we try to wake
+	 * any read locks that were queued ahead of us. */
+	if (count > RWSEM_WAITING_BIAS &&
+	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+
+	/* wait until we successfully acquire the lock */
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	while (true) {
+		if (!(count & RWSEM_ACTIVE_MASK)) {
+			/* Try acquiring the write lock. */
+			count = RWSEM_ACTIVE_WRITE_BIAS;
+			if (!list_is_singular(&sem->wait_list))
+				count += RWSEM_WAITING_BIAS;
+
+			if (sem->count == RWSEM_WAITING_BIAS &&
+			    cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+							RWSEM_WAITING_BIAS)
+				break;
+		}
+
+		raw_spin_unlock_irq(&sem->wait_lock);
+
+		/* Block until there are no active lockers. */
+		do {
+			schedule();
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
+
+		raw_spin_lock_irq(&sem->wait_lock);
+	}
+
+	list_del(&waiter.list);
+	raw_spin_unlock_irq(&sem->wait_lock);
+	tsk->state = TASK_RUNNING;
+
+	return sem;
+}
+
+/*
+ * handle waking up a waiter on the semaphore
+ * - up_read/up_write has decremented the active part of count if we come here
+ */
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	/* do nothing if list empty */
+	if (!list_empty(&sem->wait_list))
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	return sem;
+}
+
+/*
+ * downgrade a write lock into a read lock
+ * - caller incremented waiting part of count and discovered it still negative
+ * - just wake up any readers at the front of the queue
+ */
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+
+	/* do nothing if list empty */
+	if (!list_empty(&sem->wait_list))
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+
+	return sem;
+}
+
+EXPORT_SYMBOL(rwsem_down_read_failed);
+EXPORT_SYMBOL(rwsem_down_write_failed);
+EXPORT_SYMBOL(rwsem_wake);
+EXPORT_SYMBOL(rwsem_downgrade_wake);
--- /dev/null
+++ b/kernel/locking/rwsem.c
@@ -0,0 +1,157 @@
+/* kernel/rwsem.c: R/W semaphores, public implementation
+ *
+ * Written by David Howells (dhowells@redhat.com).
+ * Derived from asm-i386/semaphore.h
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/export.h>
+#include <linux/rwsem.h>
+
+#include <linux/atomic.h>
+
+/*
+ * lock for reading
+ */
+void __sched down_read(struct rw_semaphore *sem)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+}
+
+EXPORT_SYMBOL(down_read);
+
+/*
+ * trylock for reading -- returns 1 if successful, 0 if contention
+ */
+int down_read_trylock(struct rw_semaphore *sem)
+{
+	int ret = __down_read_trylock(sem);
+
+	if (ret == 1)
+		rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
+	return ret;
+}
+
+EXPORT_SYMBOL(down_read_trylock);
+
+/*
+ * lock for writing
+ */
+void __sched down_write(struct rw_semaphore *sem)
+{
+	might_sleep();
+	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+}
+
+EXPORT_SYMBOL(down_write);
+
+/*
+ * trylock for writing -- returns 1 if successful, 0 if contention
+ */
+int down_write_trylock(struct rw_semaphore *sem)
+{
+	int ret = __down_write_trylock(sem);
+
+	if (ret == 1)
+		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
+	return ret;
+}
+
+EXPORT_SYMBOL(down_write_trylock);
+
+/*
+ * release a read lock
+ */
+void up_read(struct rw_semaphore *sem)
+{
+	rwsem_release(&sem->dep_map, 1, _RET_IP_);
+
+	__up_read(sem);
+}
+
+EXPORT_SYMBOL(up_read);
+
+/*
+ * release a write lock
+ */
+void up_write(struct rw_semaphore *sem)
+{
+	rwsem_release(&sem->dep_map, 1, _RET_IP_);
+
+	__up_write(sem);
+}
+
+EXPORT_SYMBOL(up_write);
+
+/*
+ * downgrade write lock to read lock
+ */
+void downgrade_write(struct rw_semaphore *sem)
+{
+	/*
+	 * lockdep: a downgraded write will live on as a write
+	 * dependency.
+	 */
+	__downgrade_write(sem);
+}
+
+EXPORT_SYMBOL(downgrade_write);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+void down_read_nested(struct rw_semaphore *sem, int subclass)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+}
+
+EXPORT_SYMBOL(down_read_nested);
+
+void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
+{
+	might_sleep();
+	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+}
+
+EXPORT_SYMBOL(_down_write_nest_lock);
+
+void down_read_non_owner(struct rw_semaphore *sem)
+{
+	might_sleep();
+
+	__down_read(sem);
+}
+
+EXPORT_SYMBOL(down_read_non_owner);
+
+void down_write_nested(struct rw_semaphore *sem, int subclass)
+{
+	might_sleep();
+	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+}
+
+EXPORT_SYMBOL(down_write_nested);
+
+void up_read_non_owner(struct rw_semaphore *sem)
+{
+	__up_read(sem);
+}
+
+EXPORT_SYMBOL(up_read_non_owner);
+
+#endif
+
+
--- a/kernel/rwsem.c
+++ /dev/null
@@ -1,157 +0,0 @@
-/* kernel/rwsem.c: R/W semaphores, public implementation
- *
- * Written by David Howells (dhowells@redhat.com).
- * Derived from asm-i386/semaphore.h
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/export.h>
-#include <linux/rwsem.h>
-
-#include <linux/atomic.h>
-
-/*
- * lock for reading
- */
-void __sched down_read(struct rw_semaphore *sem)
-{
-	might_sleep();
-	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
-
-	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
-}
-
-EXPORT_SYMBOL(down_read);
-
-/*
- * trylock for reading -- returns 1 if successful, 0 if contention
- */
-int down_read_trylock(struct rw_semaphore *sem)
-{
-	int ret = __down_read_trylock(sem);
-
-	if (ret == 1)
-		rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
-	return ret;
-}
-
-EXPORT_SYMBOL(down_read_trylock);
-
-/*
- * lock for writing
- */
-void __sched down_write(struct rw_semaphore *sem)
-{
-	might_sleep();
-	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
-
-	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
-}
-
-EXPORT_SYMBOL(down_write);
-
-/*
- * trylock for writing -- returns 1 if successful, 0 if contention
- */
-int down_write_trylock(struct rw_semaphore *sem)
-{
-	int ret = __down_write_trylock(sem);
-
-	if (ret == 1)
-		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
-	return ret;
-}
-
-EXPORT_SYMBOL(down_write_trylock);
-
-/*
- * release a read lock
- */
-void up_read(struct rw_semaphore *sem)
-{
-	rwsem_release(&sem->dep_map, 1, _RET_IP_);
-
-	__up_read(sem);
-}
-
-EXPORT_SYMBOL(up_read);
-
-/*
- * release a write lock
- */
-void up_write(struct rw_semaphore *sem)
-{
-	rwsem_release(&sem->dep_map, 1, _RET_IP_);
-
-	__up_write(sem);
-}
-
-EXPORT_SYMBOL(up_write);
-
-/*
- * downgrade write lock to read lock
- */
-void downgrade_write(struct rw_semaphore *sem)
-{
-	/*
-	 * lockdep: a downgraded write will live on as a write
-	 * dependency.
-	 */
-	__downgrade_write(sem);
-}
-
-EXPORT_SYMBOL(downgrade_write);
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-void down_read_nested(struct rw_semaphore *sem, int subclass)
-{
-	might_sleep();
-	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
-
-	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
-}
-
-EXPORT_SYMBOL(down_read_nested);
-
-void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
-{
-	might_sleep();
-	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
-
-	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
-}
-
-EXPORT_SYMBOL(_down_write_nest_lock);
-
-void down_read_non_owner(struct rw_semaphore *sem)
-{
-	might_sleep();
-
-	__down_read(sem);
-}
-
-EXPORT_SYMBOL(down_read_non_owner);
-
-void down_write_nested(struct rw_semaphore *sem, int subclass)
-{
-	might_sleep();
-	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
-
-	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
-}
-
-EXPORT_SYMBOL(down_write_nested);
-
-void up_read_non_owner(struct rw_semaphore *sem)
-{
-	__up_read(sem);
-}
-
-EXPORT_SYMBOL(up_read_non_owner);
-
-#endif
-
-
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,8 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_i
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
-lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
--- a/lib/rwsem-spinlock.c
+++ /dev/null
@@ -1,296 +0,0 @@
-/* rwsem-spinlock.c: R/W semaphores: contention handling functions for
- * generic spinlock implementation
- *
- * Copyright (c) 2001   David Howells (dhowells@redhat.com).
- * - Derived partially from idea by Andrea Arcangeli <andrea@suse.de>
- * - Derived also from comments by Linus
- */
-#include <linux/rwsem.h>
-#include <linux/sched.h>
-#include <linux/export.h>
-
-enum rwsem_waiter_type {
-	RWSEM_WAITING_FOR_WRITE,
-	RWSEM_WAITING_FOR_READ
-};
-
-struct rwsem_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	enum rwsem_waiter_type type;
-};
-
-int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	int ret = 1;
-	unsigned long flags;
-
-	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
-		ret = (sem->activity != 0);
-		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-	}
-	return ret;
-}
-EXPORT_SYMBOL(rwsem_is_locked);
-
-/*
- * initialise the semaphore
- */
-void __init_rwsem(struct rw_semaphore *sem, const char *name,
-		  struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held semaphore:
-	 */
-	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
-#endif
-	sem->activity = 0;
-	raw_spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-EXPORT_SYMBOL(__init_rwsem);
-
-/*
- * handle the lock release when processes blocked on it that can now run
- * - if we come here, then:
- *   - the 'active count' _reached_ zero
- *   - the 'waiting count' is non-zero
- * - the spinlock must be held by the caller
- * - woken process blocks are discarded from the list after having task zeroed
- * - writers are only woken if wakewrite is non-zero
- */
-static inline struct rw_semaphore *
-__rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
-{
-	struct rwsem_waiter *waiter;
-	struct task_struct *tsk;
-	int woken;
-
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-
-	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
-		if (wakewrite)
-			/* Wake up a writer. Note that we do not grant it the
-			 * lock - it will have to acquire it when it runs. */
-			wake_up_process(waiter->task);
-		goto out;
-	}
-
-	/* grant an infinite number of read locks to the front of the queue */
-	woken = 0;
-	do {
-		struct list_head *next = waiter->list.next;
-
-		list_del(&waiter->list);
-		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
-		woken++;
-		if (next == &sem->wait_list)
-			break;
-		waiter = list_entry(next, struct rwsem_waiter, list);
-	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
-
-	sem->activity += woken;
-
- out:
-	return sem;
-}
-
-/*
- * wake a single writer
- */
-static inline struct rw_semaphore *
-__rwsem_wake_one_writer(struct rw_semaphore *sem)
-{
-	struct rwsem_waiter *waiter;
-
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	wake_up_process(waiter->task);
-
-	return sem;
-}
-
-/*
- * get a read lock on the semaphore
- */
-void __sched __down_read(struct rw_semaphore *sem)
-{
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
-		/* granted */
-		sem->activity++;
-		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-		goto out;
-	}
-
-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_READ;
-	get_task_struct(tsk);
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we don't need to touch the semaphore struct anymore */
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the lock */
-	for (;;) {
-		if (!waiter.task)
-			break;
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-
-	tsk->state = TASK_RUNNING;
- out:
-	;
-}
-
-/*
- * trylock for reading -- returns 1 if successful, 0 if contention
- */
-int __down_read_trylock(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
-		/* granted */
-		sem->activity++;
-		ret = 1;
-	}
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	return ret;
-}
-
-/*
- * get a write lock on the semaphore
- */
-void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
-{
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	/* set up my own style of waitqueue */
-	tsk = current;
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_WRITE;
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* wait for someone to release the lock */
-	for (;;) {
-		/*
-		 * That is the key to support write lock stealing: allows the
-		 * task already on CPU to get the lock soon rather than put
-		 * itself into sleep and waiting for system woke it or someone
-		 * else in the head of the wait list up.
-		 */
-		if (sem->activity == 0)
-			break;
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-		schedule();
-		raw_spin_lock_irqsave(&sem->wait_lock, flags);
-	}
-	/* got the lock */
-	sem->activity = -1;
-	list_del(&waiter.list);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
-void __sched __down_write(struct rw_semaphore *sem)
-{
-	__down_write_nested(sem, 0);
-}
-
-/*
- * trylock for writing -- returns 1 if successful, 0 if contention
- */
-int __down_write_trylock(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	if (sem->activity == 0) {
-		/* got the lock */
-		sem->activity = -1;
-		ret = 1;
-	}
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	return ret;
-}
-
-/*
- * release a read lock on the semaphore
- */
-void __up_read(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	if (--sem->activity == 0 && !list_empty(&sem->wait_list))
-		sem = __rwsem_wake_one_writer(sem);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
-/*
- * release a write lock on the semaphore
- */
-void __up_write(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	sem->activity = 0;
-	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 1);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
-/*
- * downgrade a write lock into a read lock
- * - just wake up any readers at the front of the queue
- */
-void __downgrade_write(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	sem->activity = 1;
-	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 0);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
--- a/lib/rwsem.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/* rwsem.c: R/W semaphores: contention handling functions
- *
- * Written by David Howells (dhowells@redhat.com).
- * Derived from arch/i386/kernel/semaphore.c
- *
- * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
- * and Michel Lespinasse <walken@google.com>
- */
-#include <linux/rwsem.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/export.h>
-
-/*
- * Initialize an rwsem:
- */
-void __init_rwsem(struct rw_semaphore *sem, const char *name,
-		  struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held semaphore:
-	 */
-	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
-#endif
-	sem->count = RWSEM_UNLOCKED_VALUE;
-	raw_spin_lock_init(&sem->wait_lock);
-	INIT_LIST_HEAD(&sem->wait_list);
-}
-
-EXPORT_SYMBOL(__init_rwsem);
-
-enum rwsem_waiter_type {
-	RWSEM_WAITING_FOR_WRITE,
-	RWSEM_WAITING_FOR_READ
-};
-
-struct rwsem_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	enum rwsem_waiter_type type;
-};
-
-enum rwsem_wake_type {
-	RWSEM_WAKE_ANY,		/* Wake whatever's at head of wait list */
-	RWSEM_WAKE_READERS,	/* Wake readers only */
-	RWSEM_WAKE_READ_OWNED	/* Waker thread holds the read lock */
-};
-
-/*
- * handle the lock release when processes blocked on it that can now run
- * - if we come here from up_xxxx(), then:
- *   - the 'active part' of count (&0x0000ffff) reached 0 (but may have changed)
- *   - the 'waiting part' of count (&0xffff0000) is -ve (and will still be so)
- * - there must be someone on the queue
- * - the spinlock must be held by the caller
- * - woken process blocks are discarded from the list after having task zeroed
- * - writers are only woken if downgrading is false
- */
-static struct rw_semaphore *
-__rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
-{
-	struct rwsem_waiter *waiter;
-	struct task_struct *tsk;
-	struct list_head *next;
-	long oldcount, woken, loop, adjustment;
-
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
-		if (wake_type == RWSEM_WAKE_ANY)
-			/* Wake writer at the front of the queue, but do not
-			 * grant it the lock yet as we want other writers
-			 * to be able to steal it.  Readers, on the other hand,
-			 * will block as they will notice the queued writer.
-			 */
-			wake_up_process(waiter->task);
-		goto out;
-	}
-
-	/* Writers might steal the lock before we grant it to the next reader.
-	 * We prefer to do the first reader grant before counting readers
-	 * so we can bail out early if a writer stole the lock.
-	 */
-	adjustment = 0;
-	if (wake_type != RWSEM_WAKE_READ_OWNED) {
-		adjustment = RWSEM_ACTIVE_READ_BIAS;
- try_reader_grant:
-		oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-		if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
-			/* A writer stole the lock. Undo our reader grant. */
-			if (rwsem_atomic_update(-adjustment, sem) &
-						RWSEM_ACTIVE_MASK)
-				goto out;
-			/* Last active locker left. Retry waking readers. */
-			goto try_reader_grant;
-		}
-	}
-
-	/* Grant an infinite number of read locks to the readers at the front
-	 * of the queue.  Note we increment the 'active part' of the count by
-	 * the number of readers before waking any processes up.
-	 */
-	woken = 0;
-	do {
-		woken++;
-
-		if (waiter->list.next == &sem->wait_list)
-			break;
-
-		waiter = list_entry(waiter->list.next,
-					struct rwsem_waiter, list);
-
-	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
-
-	adjustment = woken * RWSEM_ACTIVE_READ_BIAS - adjustment;
-	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
-		/* hit end of list above */
-		adjustment -= RWSEM_WAITING_BIAS;
-
-	if (adjustment)
-		rwsem_atomic_add(adjustment, sem);
-
-	next = sem->wait_list.next;
-	loop = woken;
-	do {
-		waiter = list_entry(next, struct rwsem_waiter, list);
-		next = waiter->list.next;
-		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
-	} while (--loop);
-
-	sem->wait_list.next = next;
-	next->prev = &sem->wait_list;
-
- out:
-	return sem;
-}
-
-/*
- * wait for the read lock to be granted
- */
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
-{
-	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_READ;
-	get_task_struct(tsk);
-
-	raw_spin_lock_irq(&sem->wait_lock);
-	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
-
-	/* If there are no active locks, wake the front queued process(es).
-	 *
-	 * If there are no writers and we are first in the queue,
-	 * wake our own waiter to join the existing active readers !
-	 */
-	if (count == RWSEM_WAITING_BIAS ||
-	    (count > RWSEM_WAITING_BIAS &&
-	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
-
-	raw_spin_unlock_irq(&sem->wait_lock);
-
-	/* wait to be given the lock */
-	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		if (!waiter.task)
-			break;
-		schedule();
-	}
-
-	tsk->state = TASK_RUNNING;
-
-	return sem;
-}
-
-/*
- * wait until we successfully acquire the write lock
- */
-struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
-{
-	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_WRITE;
-
-	raw_spin_lock_irq(&sem->wait_lock);
-	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
-
-	/* If there were already threads queued before us and there are no
-	 * active writers, the lock must be read owned; so we try to wake
-	 * any read locks that were queued ahead of us. */
-	if (count > RWSEM_WAITING_BIAS &&
-	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
-
-	/* wait until we successfully acquire the lock */
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (true) {
-		if (!(count & RWSEM_ACTIVE_MASK)) {
-			/* Try acquiring the write lock. */
-			count = RWSEM_ACTIVE_WRITE_BIAS;
-			if (!list_is_singular(&sem->wait_list))
-				count += RWSEM_WAITING_BIAS;
-
-			if (sem->count == RWSEM_WAITING_BIAS &&
-			    cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
-							RWSEM_WAITING_BIAS)
-				break;
-		}
-
-		raw_spin_unlock_irq(&sem->wait_lock);
-
-		/* Block until there are no active lockers. */
-		do {
-			schedule();
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
-
-		raw_spin_lock_irq(&sem->wait_lock);
-	}
-
-	list_del(&waiter.list);
-	raw_spin_unlock_irq(&sem->wait_lock);
-	tsk->state = TASK_RUNNING;
-
-	return sem;
-}
-
-/*
- * handle waking up a waiter on the semaphore
- * - up_read/up_write has decremented the active part of count if we come here
- */
-struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	/* do nothing if list empty */
-	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	return sem;
-}
-
-/*
- * downgrade a write lock into a read lock
- * - caller incremented waiting part of count and discovered it still negative
- * - just wake up any readers at the front of the queue
- */
-struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-
-	/* do nothing if list empty */
-	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
-
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	return sem;
-}
-
-EXPORT_SYMBOL(rwsem_down_read_failed);
-EXPORT_SYMBOL(rwsem_down_write_failed);
-EXPORT_SYMBOL(rwsem_wake);
-EXPORT_SYMBOL(rwsem_downgrade_wake);


