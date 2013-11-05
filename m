Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3KEMXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:23:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3KEMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:43 -0500
Message-Id: <20131105110027.057494574@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 3/8] locking: Move spinlock into kernel/locking/
References: <20131105105244.666320103@infradead.org>
Content-Disposition: inline; filename=peterz-move-locking-spinlock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Makefile                 |    3 
 kernel/locking/Makefile         |    4 
 kernel/locking/spinlock.c       |  399 ++++++++++++++++++++++++++++++++++++++++
 kernel/locking/spinlock_debug.c |  302 ++++++++++++++++++++++++++++++
 kernel/spinlock.c               |  399 ----------------------------------------
 lib/Makefile                    |    1 
 lib/spinlock_debug.c            |  302 ------------------------------
 7 files changed, 705 insertions(+), 705 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,9 +43,6 @@ obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
-obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
 obj-$(CONFIG_MODULES) += module.o
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -13,3 +13,7 @@ obj-$(CONFIG_LOCKDEP) += lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
+obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
--- /dev/null
+++ b/kernel/locking/spinlock.c
@@ -0,0 +1,399 @@
+/*
+ * Copyright (2004) Linus Torvalds
+ *
+ * Author: Zwane Mwaikambo <zwane@fsmlabs.com>
+ *
+ * Copyright (2004, 2005) Ingo Molnar
+ *
+ * This file contains the spinlock/rwlock implementations for the
+ * SMP and the DEBUG_SPINLOCK cases. (UP-nondebug inlines them)
+ *
+ * Note that some architectures have special knowledge about the
+ * stack frames of these functions in their profile_pc. If you
+ * change anything significant here that could change the stack
+ * frame contact the architecture maintainers.
+ */
+
+#include <linux/linkage.h>
+#include <linux/preempt.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/debug_locks.h>
+#include <linux/export.h>
+
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+/*
+ * The __lock_function inlines are taken from
+ * include/linux/spinlock_api_smp.h
+ */
+#else
+#define raw_read_can_lock(l)	read_can_lock(l)
+#define raw_write_can_lock(l)	write_can_lock(l)
+
+/*
+ * Some architectures can relax in favour of the CPU owning the lock.
+ */
+#ifndef arch_read_relax
+# define arch_read_relax(l)	cpu_relax()
+#endif
+#ifndef arch_write_relax
+# define arch_write_relax(l)	cpu_relax()
+#endif
+#ifndef arch_spin_relax
+# define arch_spin_relax(l)	cpu_relax()
+#endif
+
+/*
+ * We build the __lock_function inlines here. They are too large for
+ * inlining all over the place, but here is only one user per function
+ * which embedds them into the calling _lock_function below.
+ *
+ * This could be a long-held lock. We both prepare to spin for a long
+ * time (making _this_ CPU preemptable if possible), and we also signal
+ * towards that other CPU that it should break the lock ASAP.
+ */
+#define BUILD_LOCK_OPS(op, locktype)					\
+void __lockfunc __raw_##op##_lock(locktype##_t *lock)			\
+{									\
+	for (;;) {							\
+		preempt_disable();					\
+		if (likely(do_raw_##op##_trylock(lock)))		\
+			break;						\
+		preempt_enable();					\
+									\
+		if (!(lock)->break_lock)				\
+			(lock)->break_lock = 1;				\
+		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
+			arch_##op##_relax(&lock->raw_lock);		\
+	}								\
+	(lock)->break_lock = 0;						\
+}									\
+									\
+unsigned long __lockfunc __raw_##op##_lock_irqsave(locktype##_t *lock)	\
+{									\
+	unsigned long flags;						\
+									\
+	for (;;) {							\
+		preempt_disable();					\
+		local_irq_save(flags);					\
+		if (likely(do_raw_##op##_trylock(lock)))		\
+			break;						\
+		local_irq_restore(flags);				\
+		preempt_enable();					\
+									\
+		if (!(lock)->break_lock)				\
+			(lock)->break_lock = 1;				\
+		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
+			arch_##op##_relax(&lock->raw_lock);		\
+	}								\
+	(lock)->break_lock = 0;						\
+	return flags;							\
+}									\
+									\
+void __lockfunc __raw_##op##_lock_irq(locktype##_t *lock)		\
+{									\
+	_raw_##op##_lock_irqsave(lock);					\
+}									\
+									\
+void __lockfunc __raw_##op##_lock_bh(locktype##_t *lock)		\
+{									\
+	unsigned long flags;						\
+									\
+	/*							*/	\
+	/* Careful: we must exclude softirqs too, hence the	*/	\
+	/* irq-disabling. We use the generic preemption-aware	*/	\
+	/* function:						*/	\
+	/**/								\
+	flags = _raw_##op##_lock_irqsave(lock);				\
+	local_bh_disable();						\
+	local_irq_restore(flags);					\
+}									\
+
+/*
+ * Build preemption-friendly versions of the following
+ * lock-spinning functions:
+ *
+ *         __[spin|read|write]_lock()
+ *         __[spin|read|write]_lock_irq()
+ *         __[spin|read|write]_lock_irqsave()
+ *         __[spin|read|write]_lock_bh()
+ */
+BUILD_LOCK_OPS(spin, raw_spinlock);
+BUILD_LOCK_OPS(read, rwlock);
+BUILD_LOCK_OPS(write, rwlock);
+
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK
+int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
+{
+	return __raw_spin_trylock(lock);
+}
+EXPORT_SYMBOL(_raw_spin_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
+int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
+{
+	return __raw_spin_trylock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_spin_trylock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK
+void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
+{
+	__raw_spin_lock(lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
+unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
+{
+	return __raw_spin_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
+void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
+{
+	__raw_spin_lock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_BH
+void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
+{
+	__raw_spin_lock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_bh);
+#endif
+
+#ifdef CONFIG_UNINLINE_SPIN_UNLOCK
+void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
+void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
+{
+	__raw_spin_unlock_irqrestore(lock, flags);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
+void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
+void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_spin_unlock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_READ_TRYLOCK
+int __lockfunc _raw_read_trylock(rwlock_t *lock)
+{
+	return __raw_read_trylock(lock);
+}
+EXPORT_SYMBOL(_raw_read_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK
+void __lockfunc _raw_read_lock(rwlock_t *lock)
+{
+	__raw_read_lock(lock);
+}
+EXPORT_SYMBOL(_raw_read_lock);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
+unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
+{
+	return __raw_read_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_raw_read_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_IRQ
+void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
+{
+	__raw_read_lock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_read_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_BH
+void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
+{
+	__raw_read_lock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_read_lock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_READ_UNLOCK
+void __lockfunc _raw_read_unlock(rwlock_t *lock)
+{
+	__raw_read_unlock(lock);
+}
+EXPORT_SYMBOL(_raw_read_unlock);
+#endif
+
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
+void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	__raw_read_unlock_irqrestore(lock, flags);
+}
+EXPORT_SYMBOL(_raw_read_unlock_irqrestore);
+#endif
+
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
+void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
+{
+	__raw_read_unlock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_read_unlock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_READ_UNLOCK_BH
+void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
+{
+	__raw_read_unlock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_read_unlock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_TRYLOCK
+int __lockfunc _raw_write_trylock(rwlock_t *lock)
+{
+	return __raw_write_trylock(lock);
+}
+EXPORT_SYMBOL(_raw_write_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK
+void __lockfunc _raw_write_lock(rwlock_t *lock)
+{
+	__raw_write_lock(lock);
+}
+EXPORT_SYMBOL(_raw_write_lock);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
+unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
+{
+	return __raw_write_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_raw_write_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
+void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
+{
+	__raw_write_lock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_write_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_BH
+void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
+{
+	__raw_write_lock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_write_lock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_UNLOCK
+void __lockfunc _raw_write_unlock(rwlock_t *lock)
+{
+	__raw_write_unlock(lock);
+}
+EXPORT_SYMBOL(_raw_write_unlock);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
+void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	__raw_write_unlock_irqrestore(lock, flags);
+}
+EXPORT_SYMBOL(_raw_write_unlock_irqrestore);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
+void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
+{
+	__raw_write_unlock_irq(lock);
+}
+EXPORT_SYMBOL(_raw_write_unlock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
+void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
+{
+	__raw_write_unlock_bh(lock);
+}
+EXPORT_SYMBOL(_raw_write_unlock_bh);
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
+{
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_nested);
+
+unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
+						   int subclass)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, do_raw_spin_trylock, do_raw_spin_lock,
+				do_raw_spin_lock_flags, &flags);
+	return flags;
+}
+EXPORT_SYMBOL(_raw_spin_lock_irqsave_nested);
+
+void __lockfunc _raw_spin_lock_nest_lock(raw_spinlock_t *lock,
+				     struct lockdep_map *nest_lock)
+{
+	preempt_disable();
+	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
+
+#endif
+
+notrace int in_lock_functions(unsigned long addr)
+{
+	/* Linker adds these: start and end of __lockfunc functions */
+	extern char __lock_text_start[], __lock_text_end[];
+
+	return addr >= (unsigned long)__lock_text_start
+	&& addr < (unsigned long)__lock_text_end;
+}
+EXPORT_SYMBOL(in_lock_functions);
--- /dev/null
+++ b/kernel/locking/spinlock_debug.c
@@ -0,0 +1,302 @@
+/*
+ * Copyright 2005, Red Hat, Inc., Ingo Molnar
+ * Released under the General Public License (GPL).
+ *
+ * This file contains the spinlock/rwlock implementations for
+ * DEBUG_SPINLOCK.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/nmi.h>
+#include <linux/interrupt.h>
+#include <linux/debug_locks.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+
+void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
+			  struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+#endif
+	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	lock->magic = SPINLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
+EXPORT_SYMBOL(__raw_spin_lock_init);
+
+void __rwlock_init(rwlock_t *lock, const char *name,
+		   struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+#endif
+	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
+	lock->magic = RWLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
+EXPORT_SYMBOL(__rwlock_init);
+
+static void spin_dump(raw_spinlock_t *lock, const char *msg)
+{
+	struct task_struct *owner = NULL;
+
+	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
+		owner = lock->owner;
+	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
+		msg, raw_smp_processor_id(),
+		current->comm, task_pid_nr(current));
+	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
+			".owner_cpu: %d\n",
+		lock, lock->magic,
+		owner ? owner->comm : "<none>",
+		owner ? task_pid_nr(owner) : -1,
+		lock->owner_cpu);
+	dump_stack();
+}
+
+static void spin_bug(raw_spinlock_t *lock, const char *msg)
+{
+	if (!debug_locks_off())
+		return;
+
+	spin_dump(lock, msg);
+}
+
+#define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
+
+static inline void
+debug_spin_lock_before(raw_spinlock_t *lock)
+{
+	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
+	SPIN_BUG_ON(lock->owner == current, lock, "recursion");
+	SPIN_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
+							lock, "cpu recursion");
+}
+
+static inline void debug_spin_lock_after(raw_spinlock_t *lock)
+{
+	lock->owner_cpu = raw_smp_processor_id();
+	lock->owner = current;
+}
+
+static inline void debug_spin_unlock(raw_spinlock_t *lock)
+{
+	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
+	SPIN_BUG_ON(!raw_spin_is_locked(lock), lock, "already unlocked");
+	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
+	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
+							lock, "wrong CPU");
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
+static void __spin_lock_debug(raw_spinlock_t *lock)
+{
+	u64 i;
+	u64 loops = loops_per_jiffy * HZ;
+
+	for (i = 0; i < loops; i++) {
+		if (arch_spin_trylock(&lock->raw_lock))
+			return;
+		__delay(1);
+	}
+	/* lockup suspected: */
+	spin_dump(lock, "lockup suspected");
+#ifdef CONFIG_SMP
+	trigger_all_cpu_backtrace();
+#endif
+
+	/*
+	 * The trylock above was causing a livelock.  Give the lower level arch
+	 * specific lock code a chance to acquire the lock. We have already
+	 * printed a warning/backtrace at this point. The non-debug arch
+	 * specific code might actually succeed in acquiring the lock.  If it is
+	 * not successful, the end-result is the same - there is no forward
+	 * progress.
+	 */
+	arch_spin_lock(&lock->raw_lock);
+}
+
+void do_raw_spin_lock(raw_spinlock_t *lock)
+{
+	debug_spin_lock_before(lock);
+	if (unlikely(!arch_spin_trylock(&lock->raw_lock)))
+		__spin_lock_debug(lock);
+	debug_spin_lock_after(lock);
+}
+
+int do_raw_spin_trylock(raw_spinlock_t *lock)
+{
+	int ret = arch_spin_trylock(&lock->raw_lock);
+
+	if (ret)
+		debug_spin_lock_after(lock);
+#ifndef CONFIG_SMP
+	/*
+	 * Must not happen on UP:
+	 */
+	SPIN_BUG_ON(!ret, lock, "trylock failure on UP");
+#endif
+	return ret;
+}
+
+void do_raw_spin_unlock(raw_spinlock_t *lock)
+{
+	debug_spin_unlock(lock);
+	arch_spin_unlock(&lock->raw_lock);
+}
+
+static void rwlock_bug(rwlock_t *lock, const char *msg)
+{
+	if (!debug_locks_off())
+		return;
+
+	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p\n",
+		msg, raw_smp_processor_id(), current->comm,
+		task_pid_nr(current), lock);
+	dump_stack();
+}
+
+#define RWLOCK_BUG_ON(cond, lock, msg) if (unlikely(cond)) rwlock_bug(lock, msg)
+
+#if 0		/* __write_lock_debug() can lock up - maybe this can too? */
+static void __read_lock_debug(rwlock_t *lock)
+{
+	u64 i;
+	u64 loops = loops_per_jiffy * HZ;
+	int print_once = 1;
+
+	for (;;) {
+		for (i = 0; i < loops; i++) {
+			if (arch_read_trylock(&lock->raw_lock))
+				return;
+			__delay(1);
+		}
+		/* lockup suspected: */
+		if (print_once) {
+			print_once = 0;
+			printk(KERN_EMERG "BUG: read-lock lockup on CPU#%d, "
+					"%s/%d, %p\n",
+				raw_smp_processor_id(), current->comm,
+				current->pid, lock);
+			dump_stack();
+		}
+	}
+}
+#endif
+
+void do_raw_read_lock(rwlock_t *lock)
+{
+	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
+	arch_read_lock(&lock->raw_lock);
+}
+
+int do_raw_read_trylock(rwlock_t *lock)
+{
+	int ret = arch_read_trylock(&lock->raw_lock);
+
+#ifndef CONFIG_SMP
+	/*
+	 * Must not happen on UP:
+	 */
+	RWLOCK_BUG_ON(!ret, lock, "trylock failure on UP");
+#endif
+	return ret;
+}
+
+void do_raw_read_unlock(rwlock_t *lock)
+{
+	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
+	arch_read_unlock(&lock->raw_lock);
+}
+
+static inline void debug_write_lock_before(rwlock_t *lock)
+{
+	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
+	RWLOCK_BUG_ON(lock->owner == current, lock, "recursion");
+	RWLOCK_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
+							lock, "cpu recursion");
+}
+
+static inline void debug_write_lock_after(rwlock_t *lock)
+{
+	lock->owner_cpu = raw_smp_processor_id();
+	lock->owner = current;
+}
+
+static inline void debug_write_unlock(rwlock_t *lock)
+{
+	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
+	RWLOCK_BUG_ON(lock->owner != current, lock, "wrong owner");
+	RWLOCK_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
+							lock, "wrong CPU");
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
+#if 0		/* This can cause lockups */
+static void __write_lock_debug(rwlock_t *lock)
+{
+	u64 i;
+	u64 loops = loops_per_jiffy * HZ;
+	int print_once = 1;
+
+	for (;;) {
+		for (i = 0; i < loops; i++) {
+			if (arch_write_trylock(&lock->raw_lock))
+				return;
+			__delay(1);
+		}
+		/* lockup suspected: */
+		if (print_once) {
+			print_once = 0;
+			printk(KERN_EMERG "BUG: write-lock lockup on CPU#%d, "
+					"%s/%d, %p\n",
+				raw_smp_processor_id(), current->comm,
+				current->pid, lock);
+			dump_stack();
+		}
+	}
+}
+#endif
+
+void do_raw_write_lock(rwlock_t *lock)
+{
+	debug_write_lock_before(lock);
+	arch_write_lock(&lock->raw_lock);
+	debug_write_lock_after(lock);
+}
+
+int do_raw_write_trylock(rwlock_t *lock)
+{
+	int ret = arch_write_trylock(&lock->raw_lock);
+
+	if (ret)
+		debug_write_lock_after(lock);
+#ifndef CONFIG_SMP
+	/*
+	 * Must not happen on UP:
+	 */
+	RWLOCK_BUG_ON(!ret, lock, "trylock failure on UP");
+#endif
+	return ret;
+}
+
+void do_raw_write_unlock(rwlock_t *lock)
+{
+	debug_write_unlock(lock);
+	arch_write_unlock(&lock->raw_lock);
+}
--- a/kernel/spinlock.c
+++ /dev/null
@@ -1,399 +0,0 @@
-/*
- * Copyright (2004) Linus Torvalds
- *
- * Author: Zwane Mwaikambo <zwane@fsmlabs.com>
- *
- * Copyright (2004, 2005) Ingo Molnar
- *
- * This file contains the spinlock/rwlock implementations for the
- * SMP and the DEBUG_SPINLOCK cases. (UP-nondebug inlines them)
- *
- * Note that some architectures have special knowledge about the
- * stack frames of these functions in their profile_pc. If you
- * change anything significant here that could change the stack
- * frame contact the architecture maintainers.
- */
-
-#include <linux/linkage.h>
-#include <linux/preempt.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/debug_locks.h>
-#include <linux/export.h>
-
-/*
- * If lockdep is enabled then we use the non-preemption spin-ops
- * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
- * not re-enabled during lock-acquire (which the preempt-spin-ops do):
- */
-#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
-/*
- * The __lock_function inlines are taken from
- * include/linux/spinlock_api_smp.h
- */
-#else
-#define raw_read_can_lock(l)	read_can_lock(l)
-#define raw_write_can_lock(l)	write_can_lock(l)
-
-/*
- * Some architectures can relax in favour of the CPU owning the lock.
- */
-#ifndef arch_read_relax
-# define arch_read_relax(l)	cpu_relax()
-#endif
-#ifndef arch_write_relax
-# define arch_write_relax(l)	cpu_relax()
-#endif
-#ifndef arch_spin_relax
-# define arch_spin_relax(l)	cpu_relax()
-#endif
-
-/*
- * We build the __lock_function inlines here. They are too large for
- * inlining all over the place, but here is only one user per function
- * which embedds them into the calling _lock_function below.
- *
- * This could be a long-held lock. We both prepare to spin for a long
- * time (making _this_ CPU preemptable if possible), and we also signal
- * towards that other CPU that it should break the lock ASAP.
- */
-#define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc __raw_##op##_lock(locktype##_t *lock)			\
-{									\
-	for (;;) {							\
-		preempt_disable();					\
-		if (likely(do_raw_##op##_trylock(lock)))		\
-			break;						\
-		preempt_enable();					\
-									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
-			arch_##op##_relax(&lock->raw_lock);		\
-	}								\
-	(lock)->break_lock = 0;						\
-}									\
-									\
-unsigned long __lockfunc __raw_##op##_lock_irqsave(locktype##_t *lock)	\
-{									\
-	unsigned long flags;						\
-									\
-	for (;;) {							\
-		preempt_disable();					\
-		local_irq_save(flags);					\
-		if (likely(do_raw_##op##_trylock(lock)))		\
-			break;						\
-		local_irq_restore(flags);				\
-		preempt_enable();					\
-									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
-			arch_##op##_relax(&lock->raw_lock);		\
-	}								\
-	(lock)->break_lock = 0;						\
-	return flags;							\
-}									\
-									\
-void __lockfunc __raw_##op##_lock_irq(locktype##_t *lock)		\
-{									\
-	_raw_##op##_lock_irqsave(lock);					\
-}									\
-									\
-void __lockfunc __raw_##op##_lock_bh(locktype##_t *lock)		\
-{									\
-	unsigned long flags;						\
-									\
-	/*							*/	\
-	/* Careful: we must exclude softirqs too, hence the	*/	\
-	/* irq-disabling. We use the generic preemption-aware	*/	\
-	/* function:						*/	\
-	/**/								\
-	flags = _raw_##op##_lock_irqsave(lock);				\
-	local_bh_disable();						\
-	local_irq_restore(flags);					\
-}									\
-
-/*
- * Build preemption-friendly versions of the following
- * lock-spinning functions:
- *
- *         __[spin|read|write]_lock()
- *         __[spin|read|write]_lock_irq()
- *         __[spin|read|write]_lock_irqsave()
- *         __[spin|read|write]_lock_bh()
- */
-BUILD_LOCK_OPS(spin, raw_spinlock);
-BUILD_LOCK_OPS(read, rwlock);
-BUILD_LOCK_OPS(write, rwlock);
-
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_TRYLOCK
-int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
-{
-	return __raw_spin_trylock(lock);
-}
-EXPORT_SYMBOL(_raw_spin_trylock);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
-{
-	return __raw_spin_trylock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_spin_trylock_bh);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
-{
-	__raw_spin_lock(lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
-{
-	return __raw_spin_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock_irqsave);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
-void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
-{
-	__raw_spin_lock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_LOCK_BH
-void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
-{
-	__raw_spin_lock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock_bh);
-#endif
-
-#ifdef CONFIG_UNINLINE_SPIN_UNLOCK
-void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
-{
-	__raw_spin_unlock(lock);
-}
-EXPORT_SYMBOL(_raw_spin_unlock);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
-{
-	__raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
-{
-	__raw_spin_unlock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_spin_unlock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
-{
-	__raw_spin_unlock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_spin_unlock_bh);
-#endif
-
-#ifndef CONFIG_INLINE_READ_TRYLOCK
-int __lockfunc _raw_read_trylock(rwlock_t *lock)
-{
-	return __raw_read_trylock(lock);
-}
-EXPORT_SYMBOL(_raw_read_trylock);
-#endif
-
-#ifndef CONFIG_INLINE_READ_LOCK
-void __lockfunc _raw_read_lock(rwlock_t *lock)
-{
-	__raw_read_lock(lock);
-}
-EXPORT_SYMBOL(_raw_read_lock);
-#endif
-
-#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
-{
-	return __raw_read_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_raw_read_lock_irqsave);
-#endif
-
-#ifndef CONFIG_INLINE_READ_LOCK_IRQ
-void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
-{
-	__raw_read_lock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_read_lock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_READ_LOCK_BH
-void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
-{
-	__raw_read_lock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_read_lock_bh);
-#endif
-
-#ifndef CONFIG_INLINE_READ_UNLOCK
-void __lockfunc _raw_read_unlock(rwlock_t *lock)
-{
-	__raw_read_unlock(lock);
-}
-EXPORT_SYMBOL(_raw_read_unlock);
-#endif
-
-#ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-{
-	__raw_read_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(_raw_read_unlock_irqrestore);
-#endif
-
-#ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
-void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
-{
-	__raw_read_unlock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_read_unlock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_READ_UNLOCK_BH
-void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
-{
-	__raw_read_unlock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_read_unlock_bh);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_TRYLOCK
-int __lockfunc _raw_write_trylock(rwlock_t *lock)
-{
-	return __raw_write_trylock(lock);
-}
-EXPORT_SYMBOL(_raw_write_trylock);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_LOCK
-void __lockfunc _raw_write_lock(rwlock_t *lock)
-{
-	__raw_write_lock(lock);
-}
-EXPORT_SYMBOL(_raw_write_lock);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
-{
-	return __raw_write_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_raw_write_lock_irqsave);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
-void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
-{
-	__raw_write_lock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_write_lock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_LOCK_BH
-void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
-{
-	__raw_write_lock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_write_lock_bh);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_UNLOCK
-void __lockfunc _raw_write_unlock(rwlock_t *lock)
-{
-	__raw_write_unlock(lock);
-}
-EXPORT_SYMBOL(_raw_write_unlock);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-{
-	__raw_write_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(_raw_write_unlock_irqrestore);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
-{
-	__raw_write_unlock_irq(lock);
-}
-EXPORT_SYMBOL(_raw_write_unlock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
-void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
-{
-	__raw_write_unlock_bh(lock);
-}
-EXPORT_SYMBOL(_raw_write_unlock_bh);
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
-{
-	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock_nested);
-
-unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
-						   int subclass)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, do_raw_spin_trylock, do_raw_spin_lock,
-				do_raw_spin_lock_flags, &flags);
-	return flags;
-}
-EXPORT_SYMBOL(_raw_spin_lock_irqsave_nested);
-
-void __lockfunc _raw_spin_lock_nest_lock(raw_spinlock_t *lock,
-				     struct lockdep_map *nest_lock)
-{
-	preempt_disable();
-	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
-	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
-}
-EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
-
-#endif
-
-notrace int in_lock_functions(unsigned long addr)
-{
-	/* Linker adds these: start and end of __lockfunc functions */
-	extern char __lock_text_start[], __lock_text_end[];
-
-	return addr >= (unsigned long)__lock_text_start
-	&& addr < (unsigned long)__lock_text_end;
-}
-EXPORT_SYMBOL(in_lock_functions);
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_i
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
--- a/lib/spinlock_debug.c
+++ /dev/null
@@ -1,302 +0,0 @@
-/*
- * Copyright 2005, Red Hat, Inc., Ingo Molnar
- * Released under the General Public License (GPL).
- *
- * This file contains the spinlock/rwlock implementations for
- * DEBUG_SPINLOCK.
- */
-
-#include <linux/spinlock.h>
-#include <linux/nmi.h>
-#include <linux/interrupt.h>
-#include <linux/debug_locks.h>
-#include <linux/delay.h>
-#include <linux/export.h>
-
-void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
-			  struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
-#endif
-	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	lock->magic = SPINLOCK_MAGIC;
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-EXPORT_SYMBOL(__raw_spin_lock_init);
-
-void __rwlock_init(rwlock_t *lock, const char *name,
-		   struct lock_class_key *key)
-{
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
-#endif
-	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
-	lock->magic = RWLOCK_MAGIC;
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-EXPORT_SYMBOL(__rwlock_init);
-
-static void spin_dump(raw_spinlock_t *lock, const char *msg)
-{
-	struct task_struct *owner = NULL;
-
-	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
-		owner = lock->owner;
-	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
-		msg, raw_smp_processor_id(),
-		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
-			".owner_cpu: %d\n",
-		lock, lock->magic,
-		owner ? owner->comm : "<none>",
-		owner ? task_pid_nr(owner) : -1,
-		lock->owner_cpu);
-	dump_stack();
-}
-
-static void spin_bug(raw_spinlock_t *lock, const char *msg)
-{
-	if (!debug_locks_off())
-		return;
-
-	spin_dump(lock, msg);
-}
-
-#define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
-
-static inline void
-debug_spin_lock_before(raw_spinlock_t *lock)
-{
-	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
-	SPIN_BUG_ON(lock->owner == current, lock, "recursion");
-	SPIN_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
-							lock, "cpu recursion");
-}
-
-static inline void debug_spin_lock_after(raw_spinlock_t *lock)
-{
-	lock->owner_cpu = raw_smp_processor_id();
-	lock->owner = current;
-}
-
-static inline void debug_spin_unlock(raw_spinlock_t *lock)
-{
-	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
-	SPIN_BUG_ON(!raw_spin_is_locked(lock), lock, "already unlocked");
-	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
-	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
-							lock, "wrong CPU");
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-static void __spin_lock_debug(raw_spinlock_t *lock)
-{
-	u64 i;
-	u64 loops = loops_per_jiffy * HZ;
-
-	for (i = 0; i < loops; i++) {
-		if (arch_spin_trylock(&lock->raw_lock))
-			return;
-		__delay(1);
-	}
-	/* lockup suspected: */
-	spin_dump(lock, "lockup suspected");
-#ifdef CONFIG_SMP
-	trigger_all_cpu_backtrace();
-#endif
-
-	/*
-	 * The trylock above was causing a livelock.  Give the lower level arch
-	 * specific lock code a chance to acquire the lock. We have already
-	 * printed a warning/backtrace at this point. The non-debug arch
-	 * specific code might actually succeed in acquiring the lock.  If it is
-	 * not successful, the end-result is the same - there is no forward
-	 * progress.
-	 */
-	arch_spin_lock(&lock->raw_lock);
-}
-
-void do_raw_spin_lock(raw_spinlock_t *lock)
-{
-	debug_spin_lock_before(lock);
-	if (unlikely(!arch_spin_trylock(&lock->raw_lock)))
-		__spin_lock_debug(lock);
-	debug_spin_lock_after(lock);
-}
-
-int do_raw_spin_trylock(raw_spinlock_t *lock)
-{
-	int ret = arch_spin_trylock(&lock->raw_lock);
-
-	if (ret)
-		debug_spin_lock_after(lock);
-#ifndef CONFIG_SMP
-	/*
-	 * Must not happen on UP:
-	 */
-	SPIN_BUG_ON(!ret, lock, "trylock failure on UP");
-#endif
-	return ret;
-}
-
-void do_raw_spin_unlock(raw_spinlock_t *lock)
-{
-	debug_spin_unlock(lock);
-	arch_spin_unlock(&lock->raw_lock);
-}
-
-static void rwlock_bug(rwlock_t *lock, const char *msg)
-{
-	if (!debug_locks_off())
-		return;
-
-	printk(KERN_EMERG "BUG: rwlock %s on CPU#%d, %s/%d, %p\n",
-		msg, raw_smp_processor_id(), current->comm,
-		task_pid_nr(current), lock);
-	dump_stack();
-}
-
-#define RWLOCK_BUG_ON(cond, lock, msg) if (unlikely(cond)) rwlock_bug(lock, msg)
-
-#if 0		/* __write_lock_debug() can lock up - maybe this can too? */
-static void __read_lock_debug(rwlock_t *lock)
-{
-	u64 i;
-	u64 loops = loops_per_jiffy * HZ;
-	int print_once = 1;
-
-	for (;;) {
-		for (i = 0; i < loops; i++) {
-			if (arch_read_trylock(&lock->raw_lock))
-				return;
-			__delay(1);
-		}
-		/* lockup suspected: */
-		if (print_once) {
-			print_once = 0;
-			printk(KERN_EMERG "BUG: read-lock lockup on CPU#%d, "
-					"%s/%d, %p\n",
-				raw_smp_processor_id(), current->comm,
-				current->pid, lock);
-			dump_stack();
-		}
-	}
-}
-#endif
-
-void do_raw_read_lock(rwlock_t *lock)
-{
-	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	arch_read_lock(&lock->raw_lock);
-}
-
-int do_raw_read_trylock(rwlock_t *lock)
-{
-	int ret = arch_read_trylock(&lock->raw_lock);
-
-#ifndef CONFIG_SMP
-	/*
-	 * Must not happen on UP:
-	 */
-	RWLOCK_BUG_ON(!ret, lock, "trylock failure on UP");
-#endif
-	return ret;
-}
-
-void do_raw_read_unlock(rwlock_t *lock)
-{
-	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	arch_read_unlock(&lock->raw_lock);
-}
-
-static inline void debug_write_lock_before(rwlock_t *lock)
-{
-	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	RWLOCK_BUG_ON(lock->owner == current, lock, "recursion");
-	RWLOCK_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
-							lock, "cpu recursion");
-}
-
-static inline void debug_write_lock_after(rwlock_t *lock)
-{
-	lock->owner_cpu = raw_smp_processor_id();
-	lock->owner = current;
-}
-
-static inline void debug_write_unlock(rwlock_t *lock)
-{
-	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	RWLOCK_BUG_ON(lock->owner != current, lock, "wrong owner");
-	RWLOCK_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
-							lock, "wrong CPU");
-	lock->owner = SPINLOCK_OWNER_INIT;
-	lock->owner_cpu = -1;
-}
-
-#if 0		/* This can cause lockups */
-static void __write_lock_debug(rwlock_t *lock)
-{
-	u64 i;
-	u64 loops = loops_per_jiffy * HZ;
-	int print_once = 1;
-
-	for (;;) {
-		for (i = 0; i < loops; i++) {
-			if (arch_write_trylock(&lock->raw_lock))
-				return;
-			__delay(1);
-		}
-		/* lockup suspected: */
-		if (print_once) {
-			print_once = 0;
-			printk(KERN_EMERG "BUG: write-lock lockup on CPU#%d, "
-					"%s/%d, %p\n",
-				raw_smp_processor_id(), current->comm,
-				current->pid, lock);
-			dump_stack();
-		}
-	}
-}
-#endif
-
-void do_raw_write_lock(rwlock_t *lock)
-{
-	debug_write_lock_before(lock);
-	arch_write_lock(&lock->raw_lock);
-	debug_write_lock_after(lock);
-}
-
-int do_raw_write_trylock(rwlock_t *lock)
-{
-	int ret = arch_write_trylock(&lock->raw_lock);
-
-	if (ret)
-		debug_write_lock_after(lock);
-#ifndef CONFIG_SMP
-	/*
-	 * Must not happen on UP:
-	 */
-	RWLOCK_BUG_ON(!ret, lock, "trylock failure on UP");
-#endif
-	return ret;
-}
-
-void do_raw_write_unlock(rwlock_t *lock)
-{
-	debug_write_unlock(lock);
-	arch_write_unlock(&lock->raw_lock);
-}


