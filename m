Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955Ab3BTUQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:16:12 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54907 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936000Ab3BTUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:16:05 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 25/32] tty: Add read-recursive, writer-prioritized rw semaphore
Date: Wed, 20 Feb 2013 15:03:12 -0500
Message-Id: <1361390599-15195-26-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantics of a rw semaphore are almost ideally suited
for tty line discipline lifetime management;  multiple active
threads obtain "references" (read locks) while performing i/o
to prevent the loss or change of the current line discipline
(write lock).

Unfortunately, the existing rw_semaphore is ill-suited in other
ways;
1) obtaining a "reference" can be recursive, ie., a reference holder
   may attempt to obtain another "reference". Recursive read locks
   are not supported by rwsem.
2) TIOCSETD ioctl (change line discipline) expects to return an
   error if the line discipline cannot be exclusively locked within
   5 secs. Lock wait timeouts are not supported by rwsem.
3) A tty hangup is expected to halt and scrap pending i/o, so
   exclusive locking must be prioritized without precluding
   existing reference holders from obtaining recursive read locks.
   Writer priority is not supported by rwsem.

Add ld_semaphore which implements these requirements in a
semantically and operationally similar way to rw_semaphore.

Read recursion is handled with a small bitmap indexed by a hashed
current value (allowing some non-recursive read locks with a
writer waiting is acceptable, whereas not allowing a recursive
read lock is not). This comes at a small expense to write lock
speed, as this bitmap is cleared under spinlock when a write lock is
obtained.

Writer priority is handled by separate wait lists for readers and
writers. Pending write waits are priortized before existing read
waits and prevent further read locks, except for the aforementioned
read lock recursion.

Wait timeouts are trivially added, but obviously change the lock
semantics as lock attempts can fail (but only due to timeout).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/Makefile      |   2 +-
 drivers/tty/tty_ldsem.c   | 507 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty_ldisc.h |  47 +++++
 3 files changed, 555 insertions(+), 1 deletion(-)
 create mode 100644 drivers/tty/tty_ldsem.c

diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 6b78399..58ad1c0 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_TTY)		+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
-				   tty_buffer.o tty_port.o tty_mutex.o
+				   tty_buffer.o tty_port.o tty_mutex.o tty_ldsem.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-$(CONFIG_AUDIT)		+= tty_audit.o
diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
new file mode 100644
index 0000000..0ab5b09
--- /dev/null
+++ b/drivers/tty/tty_ldsem.c
@@ -0,0 +1,507 @@
+/*
+ * Ldisc rw semaphore
+ *
+ * The ldisc semaphore is semantically a rw_semaphore but which enforces
+ * an alternate policy, namely:
+ *   1) Recursive read locking is allowed
+ *   2) Supports lock wait timeouts
+ *   3) Write waiter has priority, even if lock is already read owned, except:
+ *   4) Write waiter does not prevent recursive locking
+ *   5) Downgrading is not supported (because of #3 & #4 above)
+ *
+ * Implementation notes:
+ *   1) Upper half of semaphore count is a wait count (differs from rwsem
+ *	in that rwsem normalizes the upper half to the wait bias)
+ *   2) Lacks overflow checking
+ *   3) Read recursion is tracked with a bitmap indexed by hashed 'current'
+ *	This approach results in some false positives; ie, a non-recursive
+ *	read lock may be granted while a write lock is waited.
+ *	However, this approach does not produce false-negatives
+ *	(ie. not granting a read lock to a recursive attempt) which might
+ *	deadlock.
+ *	Testing the bitmap need not be atomic wrt. setting the bitmap
+ *	(as the 'current' thread cannot contend with itself); however,
+ *	since the bitmap is cleared when write lock is granted.
+ *	Note: increasing the bitmap size reduces the probability of false
+ *	positives, and thus the probability of granting a non-recursive
+ *	read lock with writer(s) waiting.
+ *
+ * The generic counting was copied and modified from include/asm-generic/rwsem.h
+ * by Paul Mackerras <paulus@samba.org>.
+ *
+ * The scheduling policy was copied and modified from lib/rwsem.c
+ * Written by David Howells (dhowells@redhat.com).
+ *
+ * Copyright (C) 2013 Peter Hurley <peter@hurleysoftware.com>
+ *
+ * This file may be redistributed under the terms of the GNU General Public
+ * License v2.
+ */
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+#include <linux/tty.h>
+#include <linux/sched.h>
+
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define __acq(l, s, t, r, c, n, i)		\
+				lock_acquire(&(l)->dep_map, s, t, r, c, n, i)
+# define __rel(l, n, i)				\
+				lock_release(&(l)->dep_map, n, i)
+# ifdef CONFIG_PROVE_LOCKING
+#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 2, NULL, i)
+#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 2, n, i)
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 2, 2, NULL, i)
+#  define lockdep_release(l, n, i)		__rel(l, n, i)
+# else
+#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
+#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 2, 1, NULL, i)
+#  define lockdep_release(l, n, i)		__rel(l, n, i)
+# endif
+#else
+# define lockdep_acquire(l, s, t, i)		do { } while (0)
+# define lockdep_acquire_nest(l, s, t, n, i)	do { } while (0)
+# define lockdep_acquire_read(l, s, t, i)	do { } while (0)
+# define lockdep_release(l, n, i)		do { } while (0)
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+# define lock_stat(_lock, stat)		lock_##stat(&(_lock)->dep_map, _RET_IP_)
+#else
+# define lock_stat(_lock, stat)		do { } while (0)
+#endif
+
+
+#if BITS_PER_LONG == 64
+# define LDSEM_ACTIVE_MASK	0xffffffffL
+#else
+# define LDSEM_ACTIVE_MASK	0x0000ffffL
+#endif
+
+#define LDSEM_UNLOCKED		0L
+#define LDSEM_ACTIVE_BIAS	1L
+#define LDSEM_WAIT_BIAS		(-LDSEM_ACTIVE_MASK-1)
+#define LDSEM_READ_BIAS		LDSEM_ACTIVE_BIAS
+#define LDSEM_WRITE_BIAS	(LDSEM_WAIT_BIAS + LDSEM_ACTIVE_BIAS)
+
+struct ldsem_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	unsigned int flags;
+#define LDSEM_READ_WAIT		0x00000001
+#define LDSEM_WRITE_WAIT	0x00000002
+};
+
+/* Wake types for __ldsem_wake().  Note: RWSEM_WAKE_NO_CHECK implies
+ * the spinlock must have been kept held since the ldsem value was observed.
+ */
+#define LDSEM_WAKE_NORMAL	0 /* All race conditions checked */
+#define LDSEM_WAKE_NO_CHECK	1 /* Reader wakeup can skip race checking  */
+
+static inline long ldsem_atomic_update(long delta, struct ld_semaphore *sem)
+{
+	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
+}
+
+
+static inline unsigned long __hash_current(void)
+{
+	return (unsigned long)current % TASK_MAP_BITS;
+}
+
+static inline void ldsem_clear_task_map(struct ld_semaphore *sem)
+{
+	bitmap_zero(sem->task_map, TASK_MAP_BITS);
+}
+
+static inline void ldsem_update_task_map(struct ld_semaphore *sem)
+{
+	__set_bit(__hash_current(), sem->task_map);
+}
+
+static inline int ldsem_lock_recursion(struct ld_semaphore *sem)
+{
+	return test_bit(__hash_current(), sem->task_map);
+}
+
+/*
+ * Initialize an ldsem:
+ */
+void __init_ldsem(struct ld_semaphore *sem, const char *name,
+		  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held semaphore:
+	 */
+	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
+	lockdep_init_map(&sem->dep_map, name, key, 0);
+#endif
+	sem->count = LDSEM_UNLOCKED;
+	raw_spin_lock_init(&sem->wait_lock);
+	INIT_LIST_HEAD(&sem->read_wait);
+	INIT_LIST_HEAD(&sem->write_wait);
+	ldsem_clear_task_map(sem);
+}
+
+static void __ldsem_wake_readers(struct ld_semaphore *sem, int wake_type)
+{
+	struct ldsem_waiter *waiter, *next;
+	struct task_struct *tsk;
+	long adjust;
+
+	/* If we come here from up_xxxx(), another thread might have reached
+	 * down_failed() before we acquired the spinlock and
+	 * woken up a waiter, making it now active.  We prefer to check for
+	 * this first in order to not spend too much time with the spinlock
+	 * held if we're not going to be able to wake up readers in the end.
+	 *
+	 * Note that we do not need to update the ldsem count: any writer
+	 * trying to acquire ldsem will run down_write_failed() due
+	 * to the waiting threads and block trying to acquire the spinlock.
+	 *
+	 * We use a dummy atomic update in order to acquire the cache line
+	 * exclusively since we expect to succeed and run the final ldsem
+	 * count adjustment pretty soon.
+	 */
+	if (wake_type == LDSEM_WAKE_NORMAL &&
+	    (ldsem_atomic_update(0, sem) & LDSEM_ACTIVE_MASK) != 0)
+		/* Someone grabbed the sem for write already */
+		return;
+
+	/* Grant read locks to all readers on the read wait list.
+	 * Note the 'active part' of the count is incremented by
+	 * the number of readers before waking any processes up.
+	 */
+	adjust = 0;
+	list_for_each_entry(waiter, &sem->read_wait, list)
+		adjust += LDSEM_ACTIVE_BIAS - LDSEM_WAIT_BIAS;
+	ldsem_atomic_update(adjust, sem);
+
+	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
+		tsk = waiter->task;
+		smp_mb();
+		waiter->task = NULL;
+		wake_up_process(tsk);
+		put_task_struct(tsk);
+	}
+	INIT_LIST_HEAD(&sem->read_wait);
+}
+
+static void __ldsem_wake_writer(struct ld_semaphore *sem)
+{
+	struct ldsem_waiter *waiter;
+	struct task_struct *tsk;
+
+	waiter = list_entry(sem->write_wait.next, struct ldsem_waiter, list);
+
+	/* only wake this writer if the active part of the count can be
+	 * transitioned from 0 -> 1
+	 */
+	do {
+		long count;
+
+		count = ldsem_atomic_update(LDSEM_ACTIVE_BIAS, sem);
+		if ((count & LDSEM_ACTIVE_MASK) == 1)
+			break;
+
+		/* Someone grabbed the sem already -
+		 * undo the change to the active count, but check for
+		 * a transition 1->0
+		 */
+		count = ldsem_atomic_update(-LDSEM_ACTIVE_BIAS, sem);
+		if (count & LDSEM_ACTIVE_MASK)
+			return;
+	} while (1);
+
+	/* reset read lock recursion map */
+	ldsem_clear_task_map(sem);
+
+	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
+	 * It is an allocated on the waiter's stack and may become invalid at
+	 * any time after that point (due to a wakeup from another source).
+	 */
+	list_del(&waiter->list);
+	tsk = waiter->task;
+	smp_mb();
+	waiter->task = NULL;
+	wake_up_process(tsk);
+	put_task_struct(tsk);
+}
+
+/*
+ * handle the lock release when processes blocked on it that can now run
+ * - if we come here from up_xxxx(), then:
+ *   - the 'active part' of count (&0x0000ffff) reached 0 (but may have changed)
+ *   - the 'waiting part' of count (&0xffff0000) is -ve (and will still be so)
+ * - the spinlock must be held by the caller
+ * - woken process blocks are discarded from the list after having task zeroed
+ */
+static void __ldsem_wake(struct ld_semaphore *sem, int wake_type)
+{
+	if (!list_empty(&sem->write_wait))
+		__ldsem_wake_writer(sem);
+	else if (!list_empty(&sem->read_wait))
+		__ldsem_wake_readers(sem, wake_type);
+}
+
+static void ldsem_wake(struct ld_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	__ldsem_wake(sem, LDSEM_WAKE_NORMAL);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+/*
+ * wait for a lock to be granted
+ */
+static struct ld_semaphore __sched *
+down_failed(struct ld_semaphore *sem, unsigned flags, long adjust, long timeout)
+{
+	struct ldsem_waiter waiter;
+
+	/* set up my own style of waitqueue */
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	if (flags & LDSEM_READ_WAIT) {
+		/* Handle recursive read locking -- if the reader already has
+		 * a read lock then allow lock acquire without waiting
+		 * but also without waking other waiters
+		 */
+		if (ldsem_lock_recursion(sem)) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return sem;
+		}
+		list_add_tail(&waiter.list, &sem->read_wait);
+	} else
+		list_add_tail(&waiter.list, &sem->write_wait);
+
+	waiter.task = current;
+	waiter.flags = flags;
+	get_task_struct(current);
+
+	/* change the lock attempt to a wait --
+	 * if there are no active locks, wake the new lock owner(s)
+	 */
+	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
+		__ldsem_wake(sem, LDSEM_WAKE_NO_CHECK);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		if (!waiter.task)
+			break;
+		if (!timeout)
+			break;
+		timeout = schedule_timeout(timeout);
+	}
+
+	__set_current_state(TASK_RUNNING);
+
+	if (!timeout) {
+		/* lock timed out but check if this task was just
+		 * granted lock ownership - if so, pretend there
+		 * was no timeout; otherwise, cleanup lock wait */
+		raw_spin_lock_irq(&sem->wait_lock);
+		if (waiter.task) {
+			ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
+			list_del(&waiter.list);
+			put_task_struct(waiter.task);
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return NULL;
+		}
+		raw_spin_unlock_irq(&sem->wait_lock);
+	}
+
+	return sem;
+}
+
+/*
+ * wait for the read lock to be granted
+ */
+static struct ld_semaphore __sched *
+down_read_failed(struct ld_semaphore *sem, long timeout)
+{
+	return down_failed(sem, LDSEM_READ_WAIT,
+			   -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS, timeout);
+}
+
+/*
+ * wait for the write lock to be granted
+ */
+static struct ld_semaphore __sched *
+down_write_failed(struct ld_semaphore *sem, long timeout)
+{
+	return down_failed(sem, LDSEM_WRITE_WAIT, -LDSEM_ACTIVE_BIAS, timeout);
+}
+
+
+
+static inline int __ldsem_down_read_nested(struct ld_semaphore *sem,
+					   int subclass, long timeout)
+{
+	lockdep_acquire_read(sem, subclass, 0, _RET_IP_);
+
+	if (atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0) {
+		lock_stat(sem, contended);
+		if (!down_read_failed(sem, timeout)) {
+			lockdep_release(sem, 1, _RET_IP_);
+			return 0;
+		}
+	}
+	lock_stat(sem, acquired);
+
+	/* used for read lock recursion test */
+	ldsem_update_task_map(sem);
+	return 1;
+}
+
+static inline int __ldsem_down_write_nested(struct ld_semaphore *sem,
+					    int subclass, long timeout)
+{
+	long count;
+
+	lockdep_acquire(sem, subclass, 0, _RET_IP_);
+
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	count = atomic_long_add_return(LDSEM_WRITE_BIAS,
+				       (atomic_long_t *)&sem->count);
+	if (count == LDSEM_WRITE_BIAS) {
+		/* reset read lock recursion map */
+		ldsem_clear_task_map(sem);
+		raw_spin_unlock_irq(&sem->wait_lock);
+	} else {
+		raw_spin_unlock_irq(&sem->wait_lock);
+
+		lock_stat(sem, contended);
+		if (!down_write_failed(sem, timeout)) {
+			lockdep_release(sem, 1, _RET_IP_);
+			return 0;
+		}
+	}
+	lock_stat(sem, acquired);
+	return 1;
+}
+
+
+/*
+ * lock for reading -- returns 1 if successful, 0 if timed out
+ */
+int __sched ldsem_down_read(struct ld_semaphore *sem, long timeout)
+{
+	might_sleep();
+	return __ldsem_down_read_nested(sem, 0, timeout);
+}
+
+/*
+ * trylock for reading -- returns 1 if successful, 0 if contention
+ */
+int ldsem_down_read_trylock(struct ld_semaphore *sem)
+{
+	long count;
+
+	while ((count = sem->count) >= 0) {
+		if (count == atomic_long_cmpxchg(&sem->count, count,
+						 count + LDSEM_READ_BIAS)) {
+			lockdep_acquire_read(sem, 0, 1, _RET_IP_);
+			lock_stat(sem, acquired);
+
+			ldsem_update_task_map(sem);
+			return 1;
+		}
+	}
+	lock_stat(sem, contended);
+	return 0;
+}
+
+/*
+ * lock for writing -- returns 1 if successful, 0 if timed out
+ */
+int __sched ldsem_down_write(struct ld_semaphore *sem, long timeout)
+{
+	might_sleep();
+	return __ldsem_down_write_nested(sem, 0, timeout);
+}
+
+/*
+ * trylock for writing -- returns 1 if successful, 0 if contention
+ */
+int ldsem_down_write_trylock(struct ld_semaphore *sem)
+{
+	long count;
+
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	count = atomic_long_cmpxchg(&sem->count, LDSEM_UNLOCKED,
+				    LDSEM_WRITE_BIAS);
+	if (count == LDSEM_UNLOCKED) {
+		/* reset read lock recursion map */
+		ldsem_clear_task_map(sem);
+
+		raw_spin_unlock_irq(&sem->wait_lock);
+
+		lockdep_acquire(sem, 0, 1, _RET_IP_);
+		lock_stat(sem, acquired);
+		return 1;
+	}
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+	lock_stat(sem, contended);
+	return 0;
+}
+
+/*
+ * release a read lock
+ */
+void ldsem_up_read(struct ld_semaphore *sem)
+{
+	long count;
+
+	lockdep_release(sem, 1, _RET_IP_);
+
+	count = atomic_long_dec_return((atomic_long_t *)&sem->count);
+	if (count < 0 && (count & LDSEM_ACTIVE_MASK) == 0)
+		ldsem_wake(sem);
+}
+
+/*
+ * release a write lock
+ */
+void ldsem_up_write(struct ld_semaphore *sem)
+{
+	long count;
+
+	lockdep_release(sem, 1, _RET_IP_);
+
+	count = atomic_long_sub_return(LDSEM_WRITE_BIAS,
+				       (atomic_long_t *)&sem->count);
+	if (count < 0)
+		ldsem_wake(sem);
+}
+
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int ldsem_down_read_nested(struct ld_semaphore *sem, int subclass, long timeout)
+{
+	might_sleep();
+	return __ldsem_down_read_nested(sem, subclass, timeout);
+}
+
+int ldsem_down_write_nested(struct ld_semaphore *sem, int subclass,
+			    long timeout)
+{
+	might_sleep();
+	return __ldsem_down_write_nested(sem, subclass, timeout);
+}
+
+#endif
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 455a0d7..bbefe71 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -110,6 +110,53 @@
 #include <linux/wait.h>
 #include <linux/wait.h>
 
+
+/*
+ * the semaphore definition
+ */
+struct ld_semaphore {
+	long			count;
+	raw_spinlock_t		wait_lock;
+	struct list_head	read_wait;
+	struct list_head	write_wait;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+#define TASK_MAP_BITS		157
+	DECLARE_BITMAP(task_map, TASK_MAP_BITS);
+};
+
+extern void __init_ldsem(struct ld_semaphore *sem, const char *name,
+			 struct lock_class_key *key);
+
+#define init_ldsem(sem)						\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__init_ldsem((sem), #sem, &__key);			\
+} while (0)
+
+
+extern int ldsem_down_read(struct ld_semaphore *sem, long timeout);
+extern int ldsem_down_read_trylock(struct ld_semaphore *sem);
+extern int ldsem_down_write(struct ld_semaphore *sem, long timeout);
+extern int ldsem_down_write_trylock(struct ld_semaphore *sem);
+extern void ldsem_up_read(struct ld_semaphore *sem);
+extern void ldsem_up_write(struct ld_semaphore *sem);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern int ldsem_down_read_nested(struct ld_semaphore *sem, int subclass,
+				  long timeout);
+extern int ldsem_down_write_nested(struct ld_semaphore *sem, int subclass,
+				   long timeout);
+#else
+# define ldsem_down_read_nested(sem, subclass, timeout)		\
+		ldsem_down_read(sem, timeout)
+# define ldsem_down_write_nested(sem, subclass, timeout)	\
+		ldsem_down_write(sem, timeout)
+#endif
+
+
 struct tty_ldisc_ops {
 	int	magic;
 	char	*name;
-- 
1.8.1.2

