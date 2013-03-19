Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab3CSUEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:04:32 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:33278 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3CSUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:04:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>, Michel Lespinasse <walken@google.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/7] tty: Add timed, writer-prioritized rw semaphore
Date: Tue, 19 Mar 2013 15:26:03 -0400
Message-Id: <1363721169-22445-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363721169-22445-1-git-send-email-peter@hurleysoftware.com>
References: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363721169-22445-1-git-send-email-peter@hurleysoftware.com>
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
1) TIOCSETD ioctl (change line discipline) expects to return an
   error if the line discipline cannot be exclusively locked within
   5 secs. Lock wait timeouts are not supported by rwsem.
2) A tty hangup is expected to halt and scrap pending i/o, so
   exclusive locking must be prioritized.
   Writer priority is not supported by rwsem.

Add ld_semaphore which implements these requirements in a
semantically similar way to rw_semaphore.

Writer priority is handled by separate wait lists for readers and
writers. Pending write waits are priortized before existing read
waits and prevent further read locks.

Wait timeouts are trivially added, but obviously change the lock
semantics as lock attempts can fail (but only due to timeout).

This implementation incorporates the write-lock stealing work of
Michel Lespinasse <walken@google.com>.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/Makefile      |   2 +-
 drivers/tty/tty_ldsem.c   | 453 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty_ldisc.h |  46 +++++
 3 files changed, 500 insertions(+), 1 deletion(-)
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
index 0000000..22fad8a
--- /dev/null
+++ b/drivers/tty/tty_ldsem.c
@@ -0,0 +1,453 @@
+/*
+ * Ldisc rw semaphore
+ *
+ * The ldisc semaphore is semantically a rw_semaphore but which enforces
+ * an alternate policy, namely:
+ *   1) Supports lock wait timeouts
+ *   2) Write waiter has priority
+ *   3) Downgrading is not supported
+ *
+ * Implementation notes:
+ *   1) Upper half of semaphore count is a wait count (differs from rwsem
+ *	in that rwsem normalizes the upper half to the wait bias)
+ *   2) Lacks overflow checking
+ *
+ * The generic counting was copied and modified from include/asm-generic/rwsem.h
+ * by Paul Mackerras <paulus@samba.org>.
+ *
+ * The scheduling policy was copied and modified from lib/rwsem.c
+ * Written by David Howells (dhowells@redhat.com).
+ *
+ * This implementation incorporates the write lock stealing work of
+ * Michel Lespinasse <walken@google.com>.
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
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 2, NULL, i)
+#  define lockdep_release(l, n, i)		__rel(l, n, i)
+# else
+#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
+#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
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
+};
+
+static inline long ldsem_atomic_update(long delta, struct ld_semaphore *sem)
+{
+	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
+}
+
+static inline int ldsem_cmpxchg(long *old, long new, struct ld_semaphore *sem)
+{
+	long tmp = *old;
+	*old = atomic_long_cmpxchg(&sem->count, *old, new);
+	return *old == tmp;
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
+	sem->wait_readers = 0;
+	raw_spin_lock_init(&sem->wait_lock);
+	INIT_LIST_HEAD(&sem->read_wait);
+	INIT_LIST_HEAD(&sem->write_wait);
+}
+
+static void __ldsem_wake_readers(struct ld_semaphore *sem)
+{
+	struct ldsem_waiter *waiter, *next;
+	struct task_struct *tsk;
+	long adjust, count;
+
+	/* Try to grant read locks to all readers on the read wait list.
+	 * Note the 'active part' of the count is incremented by
+	 * the number of readers before waking any processes up.
+	 */
+	adjust = sem->wait_readers * (LDSEM_ACTIVE_BIAS - LDSEM_WAIT_BIAS);
+	count = ldsem_atomic_update(adjust, sem);
+	do {
+		if (count > 0)
+			break;
+		if (ldsem_cmpxchg(&count, count - adjust, sem))
+			return;
+	} while (1);
+
+	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
+		tsk = waiter->task;
+		smp_mb();
+		waiter->task = NULL;
+		wake_up_process(tsk);
+		put_task_struct(tsk);
+	}
+	INIT_LIST_HEAD(&sem->read_wait);
+	sem->wait_readers = 0;
+}
+
+static inline int writer_trylock(struct ld_semaphore *sem)
+{
+	/* only wake this writer if the active part of the count can be
+	 * transitioned from 0 -> 1
+	 */
+	long count = ldsem_atomic_update(LDSEM_ACTIVE_BIAS, sem);
+	do {
+		if ((count & LDSEM_ACTIVE_MASK) == LDSEM_ACTIVE_BIAS)
+			return 1;
+		if (ldsem_cmpxchg(&count, count - LDSEM_ACTIVE_BIAS, sem))
+			return 0;
+	} while (1);
+}
+
+static void __ldsem_wake_writer(struct ld_semaphore *sem)
+{
+	struct ldsem_waiter *waiter;
+
+	waiter = list_entry(sem->write_wait.next, struct ldsem_waiter, list);
+	wake_up_process(waiter->task);
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
+static void __ldsem_wake(struct ld_semaphore *sem)
+{
+	if (!list_empty(&sem->write_wait))
+		__ldsem_wake_writer(sem);
+	else if (!list_empty(&sem->read_wait))
+		__ldsem_wake_readers(sem);
+}
+
+static void ldsem_wake(struct ld_semaphore *sem)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	__ldsem_wake(sem);
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+}
+
+/*
+ * wait for the read lock to be granted
+ */
+static struct ld_semaphore __sched *
+down_read_failed(struct ld_semaphore *sem, long count, long timeout)
+{
+	struct ldsem_waiter waiter;
+	struct task_struct *tsk = current;
+	long adjust = -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS;
+
+	/* set up my own style of waitqueue */
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* Try to reverse the lock attempt but if the count has changed
+	 * so that reversing fails, check if there are are no waiters,
+	 * and early-out if not */
+	do {
+		if (ldsem_cmpxchg(&count, count + adjust, sem))
+			break;
+		if (count > 0) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return sem;
+		}
+	} while (1);
+
+	list_add_tail(&waiter.list, &sem->read_wait);
+	sem->wait_readers++;
+
+	waiter.task = tsk;
+	get_task_struct(tsk);
+
+	/* if there are no active locks, wake the new lock owner(s) */
+	if ((count & LDSEM_ACTIVE_MASK) == 0)
+		__ldsem_wake(sem);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	for (;;) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+
+		if (!waiter.task)
+			break;
+		if (!timeout)
+			break;
+		timeout = schedule_timeout(timeout);
+	}
+
+	__set_task_state(tsk, TASK_RUNNING);
+
+	if (!timeout) {
+		/* lock timed out but check if this task was just
+		 * granted lock ownership - if so, pretend there
+		 * was no timeout; otherwise, cleanup lock wait */
+		raw_spin_lock_irq(&sem->wait_lock);
+		if (waiter.task) {
+			ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
+			list_del(&waiter.list);
+			raw_spin_unlock_irq(&sem->wait_lock);
+			put_task_struct(waiter.task);
+			return NULL;
+		}
+		raw_spin_unlock_irq(&sem->wait_lock);
+	}
+
+	return sem;
+}
+
+/*
+ * wait for the write lock to be granted
+ */
+static struct ld_semaphore __sched *
+down_write_failed(struct ld_semaphore *sem, long count, long timeout)
+{
+	struct ldsem_waiter waiter;
+	struct task_struct *tsk = current;
+	long adjust = -LDSEM_ACTIVE_BIAS;
+	int locked = 0;
+
+	/* set up my own style of waitqueue */
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* Try to reverse the lock attempt but if the count has changed
+	 * so that reversing fails, check if the lock is now owned,
+	 * and early-out if so */
+	do {
+		if (ldsem_cmpxchg(&count, count + adjust, sem))
+			break;
+		if ((count & LDSEM_ACTIVE_MASK) == LDSEM_ACTIVE_BIAS) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return sem;
+		}
+	} while (1);
+
+	list_add_tail(&waiter.list, &sem->write_wait);
+
+	waiter.task = tsk;
+
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	for (;;) {
+		if (!timeout)
+			break;
+		raw_spin_unlock_irq(&sem->wait_lock);
+		timeout = schedule_timeout(timeout);
+		raw_spin_lock_irq(&sem->wait_lock);
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if ((locked = writer_trylock(sem)))
+			break;
+	}
+
+	if (!locked)
+		ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
+	list_del(&waiter.list);
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	__set_task_state(tsk, TASK_RUNNING);
+
+	/* lock wait may have timed out */
+	if (!locked)
+		return NULL;
+	return sem;
+}
+
+
+
+static inline int __ldsem_down_read_nested(struct ld_semaphore *sem,
+					   int subclass, long timeout)
+{
+	long count;
+
+	lockdep_acquire_read(sem, subclass, 0, _RET_IP_);
+
+	count = ldsem_atomic_update(LDSEM_READ_BIAS, sem);
+	if (count <= 0) {
+		lock_stat(sem, contended);
+		if (!down_read_failed(sem, count, timeout)) {
+			lockdep_release(sem, 1, _RET_IP_);
+			return 0;
+		}
+	}
+	lock_stat(sem, acquired);
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
+	count = ldsem_atomic_update(LDSEM_WRITE_BIAS, sem);
+	if ((count & LDSEM_ACTIVE_MASK) != LDSEM_ACTIVE_BIAS) {
+		lock_stat(sem, contended);
+		if (!down_write_failed(sem, count, timeout)) {
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
+	long count = sem->count;
+
+	while (count >= 0) {
+		if (ldsem_cmpxchg(&count, count + LDSEM_READ_BIAS, sem)) {
+			lockdep_acquire_read(sem, 0, 1, _RET_IP_);
+			lock_stat(sem, acquired);
+			return 1;
+		}
+	}
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
+	long count = sem->count;
+
+	while ((count & LDSEM_ACTIVE_MASK) == 0) {
+		if (ldsem_cmpxchg(&count, count + LDSEM_WRITE_BIAS, sem)) {
+			lockdep_acquire(sem, 0, 1, _RET_IP_);
+			lock_stat(sem, acquired);
+			return 1;
+		}
+	}
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
+	count = ldsem_atomic_update(-LDSEM_READ_BIAS, sem);
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
+	count = ldsem_atomic_update(-LDSEM_WRITE_BIAS, sem);
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
index 455a0d7..ca000fc 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -110,6 +110,52 @@
 #include <linux/wait.h>
 #include <linux/wait.h>
 
+
+/*
+ * the semaphore definition
+ */
+struct ld_semaphore {
+	long			count;
+	raw_spinlock_t		wait_lock;
+	unsigned int		wait_readers;
+	struct list_head	read_wait;
+	struct list_head	write_wait;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
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

