Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaFLLNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:13:33 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33490 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaFLLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:13:29 -0400
Date: Thu, 12 Jun 2014 13:13:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking tree updates for v3.16, #2
Message-ID: <20140612111323.GA23981@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-core-for-linus

   # HEAD: bd01ec1a13f9a327950c8e3080096446c7804753 x86, locking/rwlocks: Enable qrwlocks on x86

This is the second round of locking tree updates for v3.16, offering 
large system scalability improvements:

 - optimistic spinning for rwsems, from Davidlohr Bueso.
 - 'qrwlocks' core code and x86 enablement, from Waiman Long and PeterZ

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      locking/rwsem: Fix checkpatch.pl warnings

Davidlohr Bueso (3):
      locking/rwsem: Support optimistic spinning
      locking/rwsem: Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK
      locking/mutexes: Documentation update/rewrite

Waiman Long (2):
      locking/rwlocks: Introduce 'qrwlocks' - fair, queued rwlocks
      x86, locking/rwlocks: Enable qrwlocks on x86


 Documentation/mutex-design.txt        | 252 ++++++++++++++++++----------------
 arch/x86/Kconfig                      |   1 +
 arch/x86/include/asm/qrwlock.h        |  17 +++
 arch/x86/include/asm/spinlock.h       |   4 +
 arch/x86/include/asm/spinlock_types.h |   4 +
 include/asm-generic/qrwlock.h         | 166 ++++++++++++++++++++++
 include/asm-generic/qrwlock_types.h   |  21 +++
 include/linux/rwsem.h                 |  25 +++-
 kernel/Kconfig.locks                  |   7 +
 kernel/locking/Makefile               |   1 +
 kernel/locking/qrwlock.c              | 133 ++++++++++++++++++
 kernel/locking/rwsem-xadd.c           | 225 ++++++++++++++++++++++++++----
 kernel/locking/rwsem.c                |  31 ++++-
 13 files changed, 737 insertions(+), 150 deletions(-)
 create mode 100644 arch/x86/include/asm/qrwlock.h
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 include/asm-generic/qrwlock_types.h
 create mode 100644 kernel/locking/qrwlock.c

diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
index 1dfe62c..ee231ed 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/mutex-design.txt
@@ -1,139 +1,157 @@
 Generic Mutex Subsystem
 
 started by Ingo Molnar <mingo@redhat.com>
+updated by Davidlohr Bueso <davidlohr@hp.com>
 
-  "Why on earth do we need a new mutex subsystem, and what's wrong
-   with semaphores?"
+What are mutexes?
+-----------------
 
-firstly, there's nothing wrong with semaphores. But if the simpler
-mutex semantics are sufficient for your code, then there are a couple
-of advantages of mutexes:
+In the Linux kernel, mutexes refer to a particular locking primitive
+that enforces serialization on shared memory systems, and not only to
+the generic term referring to 'mutual exclusion' found in academia
+or similar theoretical text books. Mutexes are sleeping locks which
+behave similarly to binary semaphores, and were introduced in 2006[1]
+as an alternative to these. This new data structure provided a number
+of advantages, including simpler interfaces, and at that time smaller
+code (see Disadvantages).
 
- - 'struct mutex' is smaller on most architectures: E.g. on x86,
-   'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
-   A smaller structure size means less RAM footprint, and better
-   CPU-cache utilization.
+[1] http://lwn.net/Articles/164802/
 
- - tighter code. On x86 i get the following .text sizes when
-   switching all mutex-alike semaphores in the kernel to the mutex
-   subsystem:
+Implementation
+--------------
 
-        text    data     bss     dec     hex filename
-     3280380  868188  396860 4545428  455b94 vmlinux-semaphore
-     3255329  865296  396732 4517357  44eded vmlinux-mutex
+Mutexes are represented by 'struct mutex', defined in include/linux/mutex.h
+and implemented in kernel/locking/mutex.c. These locks use a three
+state atomic counter (->count) to represent the different possible
+transitions that can occur during the lifetime of a lock:
 
-   that's 25051 bytes of code saved, or a 0.76% win - off the hottest
-   codepaths of the kernel. (The .data savings are 2892 bytes, or 0.33%)
-   Smaller code means better icache footprint, which is one of the
-   major optimization goals in the Linux kernel currently.
+	  1: unlocked
+	  0: locked, no waiters
+   negative: locked, with potential waiters
 
- - the mutex subsystem is slightly faster and has better scalability for
-   contended workloads. On an 8-way x86 system, running a mutex-based
-   kernel and testing creat+unlink+close (of separate, per-task files)
-   in /tmp with 16 parallel tasks, the average number of ops/sec is:
+In its most basic form it also includes a wait-queue and a spinlock
+that serializes access to it. CONFIG_SMP systems can also include
+a pointer to the lock task owner (->owner) as well as a spinner MCS
+lock (->osq), both described below in (ii).
 
-    Semaphores:                        Mutexes:
+When acquiring a mutex, there are three possible paths that can be
+taken, depending on the state of the lock:
 
-    $ ./test-mutex V 16 10             $ ./test-mutex V 16 10
-    8 CPUs, running 16 tasks.          8 CPUs, running 16 tasks.
-    checking VFS performance.          checking VFS performance.
-    avg loops/sec:      34713          avg loops/sec:      84153
-    CPU utilization:    63%            CPU utilization:    22%
+(i) fastpath: tries to atomically acquire the lock by decrementing the
+    counter. If it was already taken by another task it goes to the next
+    possible path. This logic is architecture specific. On x86-64, the
+    locking fastpath is 2 instructions:
 
-   i.e. in this workload, the mutex based kernel was 2.4 times faster
-   than the semaphore based kernel, _and_ it also had 2.8 times less CPU
-   utilization. (In terms of 'ops per CPU cycle', the semaphore kernel
-   performed 551 ops/sec per 1% of CPU time used, while the mutex kernel
-   performed 3825 ops/sec per 1% of CPU time used - it was 6.9 times
-   more efficient.)
-
-   the scalability difference is visible even on a 2-way P4 HT box:
-
-    Semaphores:                        Mutexes:
-
-    $ ./test-mutex V 16 10             $ ./test-mutex V 16 10
-    4 CPUs, running 16 tasks.          8 CPUs, running 16 tasks.
-    checking VFS performance.          checking VFS performance.
-    avg loops/sec:      127659         avg loops/sec:      181082
-    CPU utilization:    100%           CPU utilization:    34%
-
-   (the straight performance advantage of mutexes is 41%, the per-cycle
-    efficiency of mutexes is 4.1 times better.)
-
- - there are no fastpath tradeoffs, the mutex fastpath is just as tight
-   as the semaphore fastpath. On x86, the locking fastpath is 2
-   instructions:
-
-    c0377ccb <mutex_lock>:
-    c0377ccb:       f0 ff 08                lock decl (%eax)
-    c0377cce:       78 0e                   js     c0377cde <.text..lock.mutex>
-    c0377cd0:       c3                      ret
+    0000000000000e10 <mutex_lock>:
+    e21:   f0 ff 0b                lock decl (%rbx)
+    e24:   79 08                   jns    e2e <mutex_lock+0x1e>
 
    the unlocking fastpath is equally tight:
 
-    c0377cd1 <mutex_unlock>:
-    c0377cd1:       f0 ff 00                lock incl (%eax)
-    c0377cd4:       7e 0f                   jle    c0377ce5 <.text..lock.mutex+0x7>
-    c0377cd6:       c3                      ret
-
- - 'struct mutex' semantics are well-defined and are enforced if
-   CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand have
-   virtually no debugging code or instrumentation. The mutex subsystem
-   checks and enforces the following rules:
-
-   * - only one task can hold the mutex at a time
-   * - only the owner can unlock the mutex
-   * - multiple unlocks are not permitted
-   * - recursive locking is not permitted
-   * - a mutex object must be initialized via the API
-   * - a mutex object must not be initialized via memset or copying
-   * - task may not exit with mutex held
-   * - memory areas where held locks reside must not be freed
-   * - held mutexes must not be reinitialized
-   * - mutexes may not be used in hardware or software interrupt
-   *   contexts such as tasklets and timers
-
-   furthermore, there are also convenience features in the debugging
-   code:
-
-   * - uses symbolic names of mutexes, whenever they are printed in debug output
-   * - point-of-acquire tracking, symbolic lookup of function names
-   * - list of all locks held in the system, printout of them
-   * - owner tracking
-   * - detects self-recursing locks and prints out all relevant info
-   * - detects multi-task circular deadlocks and prints out all affected
-   *   locks and tasks (and only those tasks)
+    0000000000000bc0 <mutex_unlock>:
+    bc8:   f0 ff 07                lock incl (%rdi)
+    bcb:   7f 0a                   jg     bd7 <mutex_unlock+0x17>
+
+
+(ii) midpath: aka optimistic spinning, tries to spin for acquisition
+     while the lock owner is running and there are no other tasks ready
+     to run that have higher priority (need_resched). The rationale is
+     that if the lock owner is running, it is likely to release the lock
+     soon. The mutex spinners are queued up using MCS lock so that only
+     one spinner can compete for the mutex.
+
+     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
+     with the desirable properties of being fair and with each cpu trying
+     to acquire the lock spinning on a local variable. It avoids expensive
+     cacheline bouncing that common test-and-set spinlock implementations
+     incur. An MCS-like lock is specially tailored for optimistic spinning
+     for sleeping lock implementation. An important feature of the customized
+     MCS lock is that it has the extra property that spinners are able to exit
+     the MCS spinlock queue when they need to reschedule. This further helps
+     avoid situations where MCS spinners that need to reschedule would continue
+     waiting to spin on mutex owner, only to go directly to slowpath upon
+     obtaining the MCS lock.
+
+
+(iii) slowpath: last resort, if the lock is still unable to be acquired,
+      the task is added to the wait-queue and sleeps until woken up by the
+      unlock path. Under normal circumstances it blocks as TASK_UNINTERRUPTIBLE.
+
+While formally kernel mutexes are sleepable locks, it is path (ii) that
+makes them more practically a hybrid type. By simply not interrupting a
+task and busy-waiting for a few cycles instead of immediately sleeping,
+the performance of this lock has been seen to significantly improve a
+number of workloads. Note that this technique is also used for rw-semaphores.
+
+Semantics
+---------
+
+The mutex subsystem checks and enforces the following rules:
+
+    - Only one task can hold the mutex at a time.
+    - Only the owner can unlock the mutex.
+    - Multiple unlocks are not permitted.
+    - Recursive locking/unlocking is not permitted.
+    - A mutex must only be initialized via the API (see below).
+    - A task may not exit with a mutex held.
+    - Memory areas where held locks reside must not be freed.
+    - Held mutexes must not be reinitialized.
+    - Mutexes may not be used in hardware or software interrupt
+      contexts such as tasklets and timers.
+
+These semantics are fully enforced when CONFIG DEBUG_MUTEXES is enabled.
+In addition, the mutex debugging code also implements a number of other
+features that make lock debugging easier and faster:
+
+    - Uses symbolic names of mutexes, whenever they are printed
+      in debug output.
+    - Point-of-acquire tracking, symbolic lookup of function names,
+      list of all locks held in the system, printout of them.
+    - Owner tracking.
+    - Detects self-recursing locks and prints out all relevant info.
+    - Detects multi-task circular deadlocks and prints out all affected
+      locks and tasks (and only those tasks).
+
+
+Interfaces
+----------
+Statically define the mutex:
+   DEFINE_MUTEX(name);
+
+Dynamically initialize the mutex:
+   mutex_init(mutex);
+
+Acquire the mutex, uninterruptible:
+   void mutex_lock(struct mutex *lock);
+   void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+   int  mutex_trylock(struct mutex *lock);
+
+Acquire the mutex, interruptible:
+   int mutex_lock_interruptible_nested(struct mutex *lock,
+				       unsigned int subclass);
+   int mutex_lock_interruptible(struct mutex *lock);
+
+Acquire the mutex, interruptible, if dec to 0:
+   int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+
+Unlock the mutex:
+   void mutex_unlock(struct mutex *lock);
+
+Test if the mutex is taken:
+   int mutex_is_locked(struct mutex *lock);
 
 Disadvantages
 -------------
 
-The stricter mutex API means you cannot use mutexes the same way you
-can use semaphores: e.g. they cannot be used from an interrupt context,
-nor can they be unlocked from a different context that which acquired
-it. [ I'm not aware of any other (e.g. performance) disadvantages from
-using mutexes at the moment, please let me know if you find any. ]
-
-Implementation of mutexes
--------------------------
-
-'struct mutex' is the new mutex type, defined in include/linux/mutex.h and
-implemented in kernel/locking/mutex.c. It is a counter-based mutex with a
-spinlock and a wait-list. The counter has 3 states: 1 for "unlocked", 0 for
-"locked" and negative numbers (usually -1) for "locked, potential waiters
-queued".
-
-the APIs of 'struct mutex' have been streamlined:
-
- DEFINE_MUTEX(name);
+Unlike its original design and purpose, 'struct mutex' is larger than
+most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
+as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
+'struct rw_semaphore' variant. Larger structure sizes mean more CPU
+cache and memory footprint.
 
- mutex_init(mutex);
+When to use mutexes
+-------------------
 
- void mutex_lock(struct mutex *lock);
- int  mutex_lock_interruptible(struct mutex *lock);
- int  mutex_trylock(struct mutex *lock);
- void mutex_unlock(struct mutex *lock);
- int  mutex_is_locked(struct mutex *lock);
- void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
- int  mutex_lock_interruptible_nested(struct mutex *lock,
-                                      unsigned int subclass);
- int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+Unless the strict semantics of mutexes are unsuitable and/or the critical
+region prevents the lock from being shared, always prefer them to any other
+locking primitive.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..bf7626f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -121,6 +121,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
diff --git a/arch/x86/include/asm/qrwlock.h b/arch/x86/include/asm/qrwlock.h
new file mode 100644
index 0000000..70f46f0
--- /dev/null
+++ b/arch/x86/include/asm/qrwlock.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_X86_QRWLOCK_H
+#define _ASM_X86_QRWLOCK_H
+
+#include <asm-generic/qrwlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#define queue_write_unlock queue_write_unlock
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+        barrier();
+        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
+}
+#endif
+
+#include <asm-generic/qrwlock.h>
+
+#endif /* _ASM_X86_QRWLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 0f62f54..54f1c80 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -187,6 +187,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 		cpu_relax();
 }
 
+#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -269,6 +270,9 @@ static inline void arch_write_unlock(arch_rwlock_t *rw)
 	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
 		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
+#else
+#include <asm/qrwlock.h>
+#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..73c4c00 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,6 +34,10 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
+#ifdef CONFIG_QUEUE_RWLOCK
+#include <asm-generic/qrwlock_types.h>
+#else
 #include <asm/rwlock.h>
+#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
new file mode 100644
index 0000000..6383d54
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,166 @@
+/*
+ * Queue read/write lock
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QRWLOCK_H
+#define __ASM_GENERIC_QRWLOCK_H
+
+#include <linux/atomic.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
+#include <asm-generic/qrwlock_types.h>
+
+/*
+ * Writer states & reader shift and bias
+ */
+#define	_QW_WAITING	1		/* A writer is waiting	   */
+#define	_QW_LOCKED	0xff		/* A writer holds the lock */
+#define	_QW_WMASK	0xff		/* Writer mask		   */
+#define	_QR_SHIFT	8		/* Reader count shift	   */
+#define _QR_BIAS	(1U << _QR_SHIFT)
+
+/*
+ * External function declarations
+ */
+extern void queue_read_lock_slowpath(struct qrwlock *lock);
+extern void queue_write_lock_slowpath(struct qrwlock *lock);
+
+/**
+ * queue_read_can_lock- would read_trylock() succeed?
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline int queue_read_can_lock(struct qrwlock *lock)
+{
+	return !(atomic_read(&lock->cnts) & _QW_WMASK);
+}
+
+/**
+ * queue_write_can_lock- would write_trylock() succeed?
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline int queue_write_can_lock(struct qrwlock *lock)
+{
+	return !atomic_read(&lock->cnts);
+}
+
+/**
+ * queue_read_trylock - try to acquire read lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_read_trylock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_read(&lock->cnts);
+	if (likely(!(cnts & _QW_WMASK))) {
+		cnts = (u32)atomic_add_return(_QR_BIAS, &lock->cnts);
+		if (likely(!(cnts & _QW_WMASK)))
+			return 1;
+		atomic_sub(_QR_BIAS, &lock->cnts);
+	}
+	return 0;
+}
+
+/**
+ * queue_write_trylock - try to acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_write_trylock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_read(&lock->cnts);
+	if (unlikely(cnts))
+		return 0;
+
+	return likely(atomic_cmpxchg(&lock->cnts,
+				     cnts, cnts | _QW_LOCKED) == cnts);
+}
+/**
+ * queue_read_lock - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline void queue_read_lock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_add_return(_QR_BIAS, &lock->cnts);
+	if (likely(!(cnts & _QW_WMASK)))
+		return;
+
+	/* The slowpath will decrement the reader count, if necessary. */
+	queue_read_lock_slowpath(lock);
+}
+
+/**
+ * queue_write_lock - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_lock(struct qrwlock *lock)
+{
+	/* Optimize for the unfair lock case where the fair flag is 0. */
+	if (atomic_cmpxchg(&lock->cnts, 0, _QW_LOCKED) == 0)
+		return;
+
+	queue_write_lock_slowpath(lock);
+}
+
+/**
+ * queue_read_unlock - release read lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_read_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Atomically decrement the reader count
+	 */
+	smp_mb__before_atomic();
+	atomic_sub(_QR_BIAS, &lock->cnts);
+}
+
+#ifndef queue_write_unlock
+/**
+ * queue_write_unlock - release write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	/*
+	 * If the writer field is atomic, it can be cleared directly.
+	 * Otherwise, an atomic subtraction will be used to clear it.
+	 */
+	smp_mb__before_atomic();
+	atomic_sub(_QW_LOCKED, &lock->cnts);
+}
+#endif
+
+/*
+ * Remapping rwlock architecture specific functions to the corresponding
+ * queue rwlock functions.
+ */
+#define arch_read_can_lock(l)	queue_read_can_lock(l)
+#define arch_write_can_lock(l)	queue_write_can_lock(l)
+#define arch_read_lock(l)	queue_read_lock(l)
+#define arch_write_lock(l)	queue_write_lock(l)
+#define arch_read_trylock(l)	queue_read_trylock(l)
+#define arch_write_trylock(l)	queue_write_trylock(l)
+#define arch_read_unlock(l)	queue_read_unlock(l)
+#define arch_write_unlock(l)	queue_write_unlock(l)
+
+#endif /* __ASM_GENERIC_QRWLOCK_H */
diff --git a/include/asm-generic/qrwlock_types.h b/include/asm-generic/qrwlock_types.h
new file mode 100644
index 0000000..4d76f24
--- /dev/null
+++ b/include/asm-generic/qrwlock_types.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_GENERIC_QRWLOCK_TYPES_H
+#define __ASM_GENERIC_QRWLOCK_TYPES_H
+
+#include <linux/types.h>
+#include <asm/spinlock_types.h>
+
+/*
+ * The queue read/write lock data structure
+ */
+
+typedef struct qrwlock {
+	atomic_t		cnts;
+	arch_spinlock_t		lock;
+} arch_rwlock_t;
+
+#define	__ARCH_RW_LOCK_UNLOCKED {		\
+	.cnts = ATOMIC_INIT(0),			\
+	.lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+}
+
+#endif /* __ASM_GENERIC_QRWLOCK_TYPES_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 03f3b05..8d79708 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -16,6 +16,7 @@
 
 #include <linux/atomic.h>
 
+struct optimistic_spin_queue;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -23,9 +24,17 @@ struct rw_semaphore;
 #else
 /* All arch specific implementations share the same struct */
 struct rw_semaphore {
-	long			count;
-	raw_spinlock_t		wait_lock;
-	struct list_head	wait_list;
+	long count;
+	raw_spinlock_t wait_lock;
+	struct list_head wait_list;
+#ifdef CONFIG_SMP
+	/*
+	 * Write owner. Used as a speculative check to see
+	 * if the owner is running on the cpu.
+	 */
+	struct task_struct *owner;
+	struct optimistic_spin_queue *osq; /* spinner MCS lock */
+#endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
@@ -55,11 +64,21 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
+#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
+#define __RWSEM_INITIALIZER(name)			\
+	{ RWSEM_UNLOCKED_VALUE,				\
+	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  LIST_HEAD_INIT((name).wait_list),		\
+	  NULL, /* owner */				\
+	  NULL /* mcs lock */                           \
+	  __RWSEM_DEP_MAP_INIT(name) }
+#else
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list)		\
 	  __RWSEM_DEP_MAP_INIT(name) }
+#endif
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..35536d9 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,10 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config ARCH_USE_QUEUE_RWLOCK
+	bool
+
+config QUEUE_RWLOCK
+	def_bool y if ARCH_USE_QUEUE_RWLOCK
+	depends on SMP
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index b8bdcd4..8541bfd 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -24,4 +24,5 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
 obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
 obj-$(CONFIG_LOCK_TORTURE_TEST) += locktorture.o
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
new file mode 100644
index 0000000..fb5b8ac
--- /dev/null
+++ b/kernel/locking/qrwlock.c
@@ -0,0 +1,133 @@
+/*
+ * Queue read/write lock
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <linux/mutex.h>
+#include <asm/qrwlock.h>
+
+/**
+ * rspin_until_writer_unlock - inc reader count & spin until writer is gone
+ * @lock  : Pointer to queue rwlock structure
+ * @writer: Current queue rwlock writer status byte
+ *
+ * In interrupt context or at the head of the queue, the reader will just
+ * increment the reader count & wait until the writer releases the lock.
+ */
+static __always_inline void
+rspin_until_writer_unlock(struct qrwlock *lock, u32 cnts)
+{
+	while ((cnts & _QW_WMASK) == _QW_LOCKED) {
+		arch_mutex_cpu_relax();
+		cnts = smp_load_acquire((u32 *)&lock->cnts);
+	}
+}
+
+/**
+ * queue_read_lock_slowpath - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+void queue_read_lock_slowpath(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	/*
+	 * Readers come here when they cannot get the lock without waiting
+	 */
+	if (unlikely(in_interrupt())) {
+		/*
+		 * Readers in interrupt context will spin until the lock is
+		 * available without waiting in the queue.
+		 */
+		cnts = smp_load_acquire((u32 *)&lock->cnts);
+		rspin_until_writer_unlock(lock, cnts);
+		return;
+	}
+	atomic_sub(_QR_BIAS, &lock->cnts);
+
+	/*
+	 * Put the reader into the wait queue
+	 */
+	arch_spin_lock(&lock->lock);
+
+	/*
+	 * At the head of the wait queue now, wait until the writer state
+	 * goes to 0 and then try to increment the reader count and get
+	 * the lock. It is possible that an incoming writer may steal the
+	 * lock in the interim, so it is necessary to check the writer byte
+	 * to make sure that the write lock isn't taken.
+	 */
+	while (atomic_read(&lock->cnts) & _QW_WMASK)
+		arch_mutex_cpu_relax();
+
+	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
+	rspin_until_writer_unlock(lock, cnts);
+
+	/*
+	 * Signal the next one in queue to become queue head
+	 */
+	arch_spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_lock_slowpath - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+void queue_write_lock_slowpath(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	/* Put the writer into the wait queue */
+	arch_spin_lock(&lock->lock);
+
+	/* Try to acquire the lock directly if no reader is present */
+	if (!atomic_read(&lock->cnts) &&
+	    (atomic_cmpxchg(&lock->cnts, 0, _QW_LOCKED) == 0))
+		goto unlock;
+
+	/*
+	 * Set the waiting flag to notify readers that a writer is pending,
+	 * or wait for a previous writer to go away.
+	 */
+	for (;;) {
+		cnts = atomic_read(&lock->cnts);
+		if (!(cnts & _QW_WMASK) &&
+		    (atomic_cmpxchg(&lock->cnts, cnts,
+				    cnts | _QW_WAITING) == cnts))
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+
+	/* When no more readers, set the locked flag */
+	for (;;) {
+		cnts = atomic_read(&lock->cnts);
+		if ((cnts == _QW_WAITING) &&
+		    (atomic_cmpxchg(&lock->cnts, _QW_WAITING,
+				    _QW_LOCKED) == _QW_WAITING))
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+unlock:
+	arch_spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index b4219ff..dacc321 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -5,11 +5,17 @@
  *
  * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
  * and Michel Lespinasse <walken@google.com>
+ *
+ * Optimistic spinning by Tim Chen <tim.c.chen@intel.com>
+ * and Davidlohr Bueso <davidlohr@hp.com>. Based on mutexes.
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/export.h>
+#include <linux/sched/rt.h>
+
+#include "mcs_spinlock.h"
 
 /*
  * Guide to the rw_semaphore's count field for common values.
@@ -76,6 +82,10 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
+#ifdef CONFIG_SMP
+	sem->owner = NULL;
+	sem->osq = NULL;
+#endif
 }
 
 EXPORT_SYMBOL(__init_rwsem);
@@ -190,7 +200,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 }
 
 /*
- * wait for the read lock to be granted
+ * Wait for the read lock to be granted
  */
 __visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
@@ -237,64 +247,221 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	return sem;
 }
 
+static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
+{
+	if (!(count & RWSEM_ACTIVE_MASK)) {
+		/* try acquiring the write lock */
+		if (sem->count == RWSEM_WAITING_BIAS &&
+		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+			if (!list_is_singular(&sem->wait_list))
+				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+			return true;
+		}
+	}
+	return false;
+}
+
+#ifdef CONFIG_SMP
 /*
- * wait until we successfully acquire the write lock
+ * Try to acquire write lock before the writer has been put on wait queue.
+ */
+static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
+{
+	long old, count = ACCESS_ONCE(sem->count);
+
+	while (true) {
+		if (!(count == 0 || count == RWSEM_WAITING_BIAS))
+			return false;
+
+		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
+		if (old == count)
+			return true;
+
+		count = old;
+	}
+}
+
+static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
+{
+	struct task_struct *owner;
+	bool on_cpu = true;
+
+	if (need_resched())
+		return 0;
+
+	rcu_read_lock();
+	owner = ACCESS_ONCE(sem->owner);
+	if (owner)
+		on_cpu = owner->on_cpu;
+	rcu_read_unlock();
+
+	/*
+	 * If sem->owner is not set, the rwsem owner may have
+	 * just acquired it and not set the owner yet or the rwsem
+	 * has been released.
+	 */
+	return on_cpu;
+}
+
+static inline bool owner_running(struct rw_semaphore *sem,
+				 struct task_struct *owner)
+{
+	if (sem->owner != owner)
+		return false;
+
+	/*
+	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
+	 * sem->owner still matches owner, if that fails, owner might
+	 * point to free()d memory, if it still matches, the rcu_read_lock()
+	 * ensures the memory stays valid.
+	 */
+	barrier();
+
+	return owner->on_cpu;
+}
+
+static noinline
+bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
+{
+	rcu_read_lock();
+	while (owner_running(sem, owner)) {
+		if (need_resched())
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+	rcu_read_unlock();
+
+	/*
+	 * We break out the loop above on need_resched() or when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when sem->owner is NULL.
+	 */
+	return sem->owner == NULL;
+}
+
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+{
+	struct task_struct *owner;
+	bool taken = false;
+
+	preempt_disable();
+
+	/* sem->wait_lock should not be held when doing optimistic spinning */
+	if (!rwsem_can_spin_on_owner(sem))
+		goto done;
+
+	if (!osq_lock(&sem->osq))
+		goto done;
+
+	while (true) {
+		owner = ACCESS_ONCE(sem->owner);
+		if (owner && !rwsem_spin_on_owner(sem, owner))
+			break;
+
+		/* wait_lock will be acquired if write_lock is obtained */
+		if (rwsem_try_write_lock_unqueued(sem)) {
+			taken = true;
+			break;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(current)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		arch_mutex_cpu_relax();
+	}
+	osq_unlock(&sem->osq);
+done:
+	preempt_enable();
+	return taken;
+}
+
+#else
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+{
+	return false;
+}
+#endif
+
+/*
+ * Wait until we successfully acquire the write lock
  */
 __visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	long count;
+	bool waiting = true; /* any queued threads before us */
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
 
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	/* undo write bias from down_write operation, stop active locking */
+	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
+
+	/* do optimistic spinning and steal lock if possible */
+	if (rwsem_optimistic_spin(sem))
+		return sem;
+
+	/*
+	 * Optimistic spinning failed, proceed to the slowpath
+	 * and block until we can acquire the sem.
+	 */
+	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_WRITE;
 
 	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* account for this before adding a new element to the list */
 	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
+		waiting = false;
+
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
+	if (waiting) {
+		count = ACCESS_ONCE(sem->count);
 
-	/* If there were already threads queued before us and there are no
-	 * active writers, the lock must be read owned; so we try to wake
-	 * any read locks that were queued ahead of us. */
-	if (count > RWSEM_WAITING_BIAS &&
-	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+		/*
+		 * If there were already threads queued before us and there are
+		 * no active writers, the lock must be read owned; so we try to
+		 * wake any read locks that were queued ahead of us.
+		 */
+		if (count > RWSEM_WAITING_BIAS)
+			sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+
+	} else
+		count = rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
 
 	/* wait until we successfully acquire the lock */
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (true) {
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
+		if (rwsem_try_write_lock(count, sem))
+			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 
 		/* Block until there are no active lockers. */
 		do {
 			schedule();
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	list_del(&waiter.list);
 	raw_spin_unlock_irq(&sem->wait_lock);
-	tsk->state = TASK_RUNNING;
 
 	return sem;
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index cfff143..42f806d 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -12,6 +12,27 @@
 
 #include <linux/atomic.h>
 
+#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+	sem->owner = current;
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+	sem->owner = NULL;
+}
+
+#else
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+}
+#endif
+
 /*
  * lock for reading
  */
@@ -48,6 +69,7 @@ void __sched down_write(struct rw_semaphore *sem)
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -59,8 +81,11 @@ int down_write_trylock(struct rw_semaphore *sem)
 {
 	int ret = __down_write_trylock(sem);
 
-	if (ret == 1)
+	if (ret == 1) {
 		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
+		rwsem_set_owner(sem);
+	}
+
 	return ret;
 }
 
@@ -85,6 +110,7 @@ void up_write(struct rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, 1, _RET_IP_);
 
+	rwsem_clear_owner(sem);
 	__up_write(sem);
 }
 
@@ -99,6 +125,7 @@ void downgrade_write(struct rw_semaphore *sem)
 	 * lockdep: a downgraded write will live on as a write
 	 * dependency.
 	 */
+	rwsem_clear_owner(sem);
 	__downgrade_write(sem);
 }
 
@@ -122,6 +149,7 @@ void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
 	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(_down_write_nest_lock);
@@ -141,6 +169,7 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write_nested);
