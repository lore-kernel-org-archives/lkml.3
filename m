Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbaGSJMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:12:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:52403 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760588AbaGSJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:12:06 -0400
Date: Sat, 19 Jul 2014 11:11:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] locking updates for 3.16
Message-ID: <alpine.DEB.2.10.1407191053510.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest locking-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-urgent-for-linus

The locking department delivers:

    * A rather large and intrusive bundle of fixes to address serious
      performance regressions introduced by the new rwsem / mcs
      technology. Simpler solutions have been discussed, but they
      would have been ugly bandaids with more risk than doing the
      right thing.

    * Make the rwsem spin on owner technology opt-in for
      architectures and enable it only on the known to work ones.

    * A few fixes to the lockdep userspace library  

Thanks,

	tglx

------------------>
Davidlohr Bueso (1):
      locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER

Jason Low (6):
      locking/rwsem: Allow conservative optimistic spinning when readers have lock
      locking/spinlocks/mcs: Rename optimistic_spin_queue() to optimistic_spin_node()
      locking/spinlocks/mcs: Convert osq lock to atomic_t to reduce overhead
      locking/spinlocks/mcs: Introduce and use init macro and function for osq locks
      locking/spinlocks/mcs: Micro-optimize osq_unlock()
      locking/rwsem: Reduce the size of struct rw_semaphore

Peter Zijlstra (2):
      locking/rwsem: Rename 'activity' to 'count'
      locking/mutex: Disable optimistic spinning on some architectures

S. Lockwood-Childs (1):
      tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire

Sasha Levin (1):
      tools/liblockdep: Remove debug print left over from development

zhangdianfang (1):
      tools/liblockdep: Fix comparison of a boolean value with a value of 2


 arch/arm/Kconfig                              |  1 +
 arch/arm64/Kconfig                            |  1 +
 arch/powerpc/Kconfig                          |  1 +
 arch/sparc/Kconfig                            |  1 +
 arch/x86/Kconfig                              |  1 +
 include/linux/mutex.h                         |  4 +-
 include/linux/osq_lock.h                      | 27 +++++++++++
 include/linux/rwsem-spinlock.h                |  8 ++--
 include/linux/rwsem.h                         | 34 +++++++-------
 kernel/Kconfig.locks                          |  9 +++-
 kernel/locking/mcs_spinlock.c                 | 64 ++++++++++++++++++++-------
 kernel/locking/mcs_spinlock.h                 |  9 ++--
 kernel/locking/mutex.c                        |  2 +-
 kernel/locking/rwsem-spinlock.c               | 28 ++++++------
 kernel/locking/rwsem-xadd.c                   | 16 +++----
 kernel/locking/rwsem.c                        |  2 +-
 tools/lib/lockdep/include/liblockdep/mutex.h  |  4 +-
 tools/lib/lockdep/include/liblockdep/rwlock.h |  8 ++--
 tools/lib/lockdep/preload.c                   | 20 ++++-----
 19 files changed, 154 insertions(+), 86 deletions(-)
 create mode 100644 include/linux/osq_lock.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 245058b..88acf8b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -6,6 +6,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a474de34..839f48c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -4,6 +4,7 @@ config ARM64
 	select ARCH_HAS_OPP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fefe7c8..80b94b0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -145,6 +145,7 @@ config PPC
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 29f2e98..407c87d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -78,6 +78,7 @@ config SPARC64
 	select HAVE_C_RECORDMCOUNT
 	select NO_BOOTMEM
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..d24887b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 11692de..42aa9b9 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -17,6 +17,7 @@
 #include <linux/lockdep.h>
 #include <linux/atomic.h>
 #include <asm/processor.h>
+#include <linux/osq_lock.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
@@ -46,7 +47,6 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct optimistic_spin_queue;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct optimistic_spin_queue	*osq;	/* Spinner MCS lock */
+	struct optimistic_spin_queue osq; /* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
new file mode 100644
index 0000000..90230d5
--- /dev/null
+++ b/include/linux/osq_lock.h
@@ -0,0 +1,27 @@
+#ifndef __LINUX_OSQ_LOCK_H
+#define __LINUX_OSQ_LOCK_H
+
+/*
+ * An MCS like lock especially tailored for optimistic spinning for sleeping
+ * lock implementations (mutex, rwsem, etc).
+ */
+
+#define OSQ_UNLOCKED_VAL (0)
+
+struct optimistic_spin_queue {
+	/*
+	 * Stores an encoded value of the CPU # of the tail node in the queue.
+	 * If the queue is empty, then it's set to OSQ_UNLOCKED_VAL.
+	 */
+	atomic_t tail;
+};
+
+/* Init macro and function. */
+#define OSQ_LOCK_UNLOCKED { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
+
+static inline void osq_lock_init(struct optimistic_spin_queue *lock)
+{
+	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
+}
+
+#endif
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index d5b13bc..561e861 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -15,13 +15,13 @@
 #ifdef __KERNEL__
 /*
  * the rw-semaphore definition
- * - if activity is 0 then there are no active readers or writers
- * - if activity is +ve then that is the number of active readers
- * - if activity is -1 then there is one active writer
+ * - if count is 0 then there are no active readers or writers
+ * - if count is +ve then that is the number of active readers
+ * - if count is -1 then there is one active writer
  * - if wait_list is not empty, then there are processes waiting for the semaphore
  */
 struct rw_semaphore {
-	__s32			activity;
+	__s32			count;
 	raw_spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8d79708..035d3c5 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -13,10 +13,11 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-
 #include <linux/atomic.h>
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+#include <linux/osq_lock.h>
+#endif
 
-struct optimistic_spin_queue;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -25,15 +26,15 @@ struct rw_semaphore;
 /* All arch specific implementations share the same struct */
 struct rw_semaphore {
 	long count;
-	raw_spinlock_t wait_lock;
 	struct list_head wait_list;
-#ifdef CONFIG_SMP
+	raw_spinlock_t wait_lock;
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+	struct optimistic_spin_queue osq; /* spinner MCS lock */
 	/*
 	 * Write owner. Used as a speculative check to see
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_queue *osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -64,22 +65,19 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
-#define __RWSEM_INITIALIZER(name)			\
-	{ RWSEM_UNLOCKED_VALUE,				\
-	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-	  LIST_HEAD_INIT((name).wait_list),		\
-	  NULL, /* owner */				\
-	  NULL /* mcs lock */                           \
-	  __RWSEM_DEP_MAP_INIT(name) }
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+#define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
 #else
-#define __RWSEM_INITIALIZER(name)			\
-	{ RWSEM_UNLOCKED_VALUE,				\
-	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-	  LIST_HEAD_INIT((name).wait_list)		\
-	  __RWSEM_DEP_MAP_INIT(name) }
+#define __RWSEM_OPT_INIT(lockname)
 #endif
 
+#define __RWSEM_INITIALIZER(name)				\
+	{ .count = RWSEM_UNLOCKED_VALUE,			\
+	  .wait_list = LIST_HEAD_INIT((name).wait_list),	\
+	  .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock)	\
+	  __RWSEM_OPT_INIT(name)				\
+	  __RWSEM_DEP_MAP_INIT(name) }
+
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
 
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 35536d9..76768ee 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -220,9 +220,16 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 
 endif
 
+config ARCH_SUPPORTS_ATOMIC_RMW
+	bool
+
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
-	depends on SMP && !DEBUG_MUTEXES
+	depends on SMP && !DEBUG_MUTEXES && ARCH_SUPPORTS_ATOMIC_RMW
+
+config RWSEM_SPIN_ON_OWNER
+       def_bool y
+       depends on SMP && RWSEM_XCHGADD_ALGORITHM && ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_USE_QUEUE_RWLOCK
 	bool
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index 838dc9e..be9ee15 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -14,21 +14,47 @@
  * called from interrupt context and we have preemption disabled while
  * spinning.
  */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_queue, osq_node);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
+
+/*
+ * We use the value 0 to represent "no CPU", thus the encoded value
+ * will be the CPU number incremented by 1.
+ */
+static inline int encode_cpu(int cpu_nr)
+{
+	return cpu_nr + 1;
+}
+
+static inline struct optimistic_spin_node *decode_cpu(int encoded_cpu_val)
+{
+	int cpu_nr = encoded_cpu_val - 1;
+
+	return per_cpu_ptr(&osq_node, cpu_nr);
+}
 
 /*
  * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
  * Can return NULL in case we were the last queued and we updated @lock instead.
  */
-static inline struct optimistic_spin_queue *
-osq_wait_next(struct optimistic_spin_queue **lock,
-	      struct optimistic_spin_queue *node,
-	      struct optimistic_spin_queue *prev)
+static inline struct optimistic_spin_node *
+osq_wait_next(struct optimistic_spin_queue *lock,
+	      struct optimistic_spin_node *node,
+	      struct optimistic_spin_node *prev)
 {
-	struct optimistic_spin_queue *next = NULL;
+	struct optimistic_spin_node *next = NULL;
+	int curr = encode_cpu(smp_processor_id());
+	int old;
+
+	/*
+	 * If there is a prev node in queue, then the 'old' value will be
+	 * the prev node's CPU #, else it's set to OSQ_UNLOCKED_VAL since if
+	 * we're currently last in queue, then the queue will then become empty.
+	 */
+	old = prev ? prev->cpu : OSQ_UNLOCKED_VAL;
 
 	for (;;) {
-		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+		if (atomic_read(&lock->tail) == curr &&
+		    atomic_cmpxchg(&lock->tail, curr, old) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
@@ -59,18 +85,23 @@ osq_wait_next(struct optimistic_spin_queue **lock,
 	return next;
 }
 
-bool osq_lock(struct optimistic_spin_queue **lock)
+bool osq_lock(struct optimistic_spin_queue *lock)
 {
-	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *prev, *next;
+	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_node *prev, *next;
+	int curr = encode_cpu(smp_processor_id());
+	int old;
 
 	node->locked = 0;
 	node->next = NULL;
+	node->cpu = curr;
 
-	node->prev = prev = xchg(lock, node);
-	if (likely(prev == NULL))
+	old = atomic_xchg(&lock->tail, curr);
+	if (old == OSQ_UNLOCKED_VAL)
 		return true;
 
+	prev = decode_cpu(old);
+	node->prev = prev;
 	ACCESS_ONCE(prev->next) = node;
 
 	/*
@@ -149,20 +180,21 @@ unqueue:
 	return false;
 }
 
-void osq_unlock(struct optimistic_spin_queue **lock)
+void osq_unlock(struct optimistic_spin_queue *lock)
 {
-	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *next;
+	struct optimistic_spin_node *node, *next;
+	int curr = encode_cpu(smp_processor_id());
 
 	/*
 	 * Fast path for the uncontended case.
 	 */
-	if (likely(cmpxchg(lock, node, NULL) == node))
+	if (likely(atomic_cmpxchg(&lock->tail, curr, OSQ_UNLOCKED_VAL) == curr))
 		return;
 
 	/*
 	 * Second most likely case.
 	 */
+	node = this_cpu_ptr(&osq_node);
 	next = xchg(&node->next, NULL);
 	if (next) {
 		ACCESS_ONCE(next->locked) = 1;
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..74356dc 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -118,12 +118,13 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
  * mutex_lock()/rwsem_down_{read,write}() etc.
  */
 
-struct optimistic_spin_queue {
-	struct optimistic_spin_queue *next, *prev;
+struct optimistic_spin_node {
+	struct optimistic_spin_node *next, *prev;
 	int locked; /* 1 if lock acquired */
+	int cpu; /* encoded CPU # value */
 };
 
-extern bool osq_lock(struct optimistic_spin_queue **lock);
-extern void osq_unlock(struct optimistic_spin_queue **lock);
+extern bool osq_lock(struct optimistic_spin_queue *lock);
+extern void osq_unlock(struct optimistic_spin_queue *lock);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..acca2c1 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -60,7 +60,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->osq = NULL;
+	osq_lock_init(&lock->osq);
 #endif
 
 	debug_mutex_init(lock, name, key);
diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 9be8a91..2c93571 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -26,7 +26,7 @@ int rwsem_is_locked(struct rw_semaphore *sem)
 	unsigned long flags;
 
 	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
-		ret = (sem->activity != 0);
+		ret = (sem->count != 0);
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 	}
 	return ret;
@@ -46,7 +46,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
 	lockdep_init_map(&sem->dep_map, name, key, 0);
 #endif
-	sem->activity = 0;
+	sem->count = 0;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
@@ -95,7 +95,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 		waiter = list_entry(next, struct rwsem_waiter, list);
 	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
 
-	sem->activity += woken;
+	sem->count += woken;
 
  out:
 	return sem;
@@ -126,9 +126,9 @@ void __sched __down_read(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
+	if (sem->count >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
-		sem->activity++;
+		sem->count++;
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
@@ -170,9 +170,9 @@ int __down_read_trylock(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
+	if (sem->count >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
-		sem->activity++;
+		sem->count++;
 		ret = 1;
 	}
 
@@ -206,7 +206,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 		 * itself into sleep and waiting for system woke it or someone
 		 * else in the head of the wait list up.
 		 */
-		if (sem->activity == 0)
+		if (sem->count == 0)
 			break;
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
@@ -214,7 +214,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 		raw_spin_lock_irqsave(&sem->wait_lock, flags);
 	}
 	/* got the lock */
-	sem->activity = -1;
+	sem->count = -1;
 	list_del(&waiter.list);
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
@@ -235,9 +235,9 @@ int __down_write_trylock(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity == 0) {
+	if (sem->count == 0) {
 		/* got the lock */
-		sem->activity = -1;
+		sem->count = -1;
 		ret = 1;
 	}
 
@@ -255,7 +255,7 @@ void __up_read(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (--sem->activity == 0 && !list_empty(&sem->wait_list))
+	if (--sem->count == 0 && !list_empty(&sem->wait_list))
 		sem = __rwsem_wake_one_writer(sem);
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
@@ -270,7 +270,7 @@ void __up_write(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	sem->activity = 0;
+	sem->count = 0;
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, 1);
 
@@ -287,7 +287,7 @@ void __downgrade_write(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	sem->activity = 1;
+	sem->count = 1;
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, 0);
 
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..a2391ac 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -82,9 +82,9 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	sem->owner = NULL;
-	sem->osq = NULL;
+	osq_lock_init(&sem->osq);
 #endif
 }
 
@@ -262,7 +262,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 	return false;
 }
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
  * Try to acquire write lock before the writer has been put on wait queue.
  */
@@ -285,10 +285,10 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
-	bool on_cpu = true;
+	bool on_cpu = false;
 
 	if (need_resched())
-		return 0;
+		return false;
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(sem->owner);
@@ -297,9 +297,9 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 	rcu_read_unlock();
 
 	/*
-	 * If sem->owner is not set, the rwsem owner may have
-	 * just acquired it and not set the owner yet or the rwsem
-	 * has been released.
+	 * If sem->owner is not set, yet we have just recently entered the
+	 * slowpath, then there is a possibility reader(s) may have the lock.
+	 * To be safe, avoid spinning in these situations.
 	 */
 	return on_cpu;
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 42f806d..e2d3bc7 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -12,7 +12,7 @@
 
 #include <linux/atomic.h>
 
-#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
 	sem->owner = current;
diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
index c342f70..ee53a42 100644
--- a/tools/lib/lockdep/include/liblockdep/mutex.h
+++ b/tools/lib/lockdep/include/liblockdep/mutex.h
@@ -35,7 +35,7 @@ static inline int __mutex_init(liblockdep_pthread_mutex_t *lock,
 
 static inline int liblockdep_pthread_mutex_lock(liblockdep_pthread_mutex_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_mutex_lock(&lock->mutex);
 }
 
@@ -47,7 +47,7 @@ static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lo
 
 static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
 }
 
diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
index a680ab8..4ec03f8 100644
--- a/tools/lib/lockdep/include/liblockdep/rwlock.h
+++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
@@ -36,7 +36,7 @@ static inline int __rwlock_init(liblockdep_pthread_rwlock_t *lock,
 
 static inline int liblockdep_pthread_rwlock_rdlock(liblockdep_pthread_rwlock_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 0, 2, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 0, 2, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_rwlock_rdlock(&lock->rwlock);
 
 }
@@ -49,19 +49,19 @@ static inline int liblockdep_pthread_rwlock_unlock(liblockdep_pthread_rwlock_t *
 
 static inline int liblockdep_pthread_rwlock_wrlock(liblockdep_pthread_rwlock_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_rwlock_wrlock(&lock->rwlock);
 }
 
 static inline int liblockdep_pthread_rwlock_tryrdlock(liblockdep_pthread_rwlock_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 1, 2, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 1, 2, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_rwlock_tryrdlock(&lock->rwlock) == 0 ? 1 : 0;
 }
 
 static inline int liblockdep_pthread_rwlock_trywlock(liblockdep_pthread_rwlock_t *lock)
 {
-	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&lock->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
 	return pthread_rwlock_trywlock(&lock->rwlock) == 0 ? 1 : 0;
 }
 
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
index 23bd69c..6f80360 100644
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -92,7 +92,7 @@ enum { none, prepare, done, } __init_state;
 static void init_preload(void);
 static void try_init_preload(void)
 {
-	if (!__init_state != done)
+	if (__init_state != done)
 		init_preload();
 }
 
@@ -252,7 +252,7 @@ int pthread_mutex_lock(pthread_mutex_t *mutex)
 
 	try_init_preload();
 
-	lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL,
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 1, NULL,
 			(unsigned long)_RET_IP_);
 	/*
 	 * Here's the thing with pthread mutexes: unlike the kernel variant,
@@ -281,7 +281,7 @@ int pthread_mutex_trylock(pthread_mutex_t *mutex)
 
 	try_init_preload();
 
-	lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
 	r = ll_pthread_mutex_trylock(mutex);
 	if (r)
 		lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
@@ -303,7 +303,7 @@ int pthread_mutex_unlock(pthread_mutex_t *mutex)
 	 */
 	r = ll_pthread_mutex_unlock(mutex);
 	if (r)
-		lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+		lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
 
 	return r;
 }
@@ -352,7 +352,7 @@ int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock)
 
         init_preload();
 
-	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 2, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 2, 1, NULL, (unsigned long)_RET_IP_);
 	r = ll_pthread_rwlock_rdlock(rwlock);
 	if (r)
 		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
@@ -366,7 +366,7 @@ int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock)
 
         init_preload();
 
-	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 2, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 2, 1, NULL, (unsigned long)_RET_IP_);
 	r = ll_pthread_rwlock_tryrdlock(rwlock);
 	if (r)
 		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
@@ -380,7 +380,7 @@ int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock)
 
         init_preload();
 
-	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
 	r = ll_pthread_rwlock_trywrlock(rwlock);
 	if (r)
                 lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
@@ -394,7 +394,7 @@ int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock)
 
         init_preload();
 
-	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
 	r = ll_pthread_rwlock_wrlock(rwlock);
 	if (r)
 		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
@@ -411,7 +411,7 @@ int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)
 	lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
 	r = ll_pthread_rwlock_unlock(rwlock);
 	if (r)
-		lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+		lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
 
 	return r;
 }
@@ -439,8 +439,6 @@ __attribute__((constructor)) static void init_preload(void)
 	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
 #endif
 
-	printf("%p\n", ll_pthread_mutex_trylock);fflush(stdout);
-
 	lockdep_init();
 
 	__init_state = done;
