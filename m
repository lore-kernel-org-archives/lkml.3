Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaFEOlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:41:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaFEOlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:41:09 -0400
Date: Thu, 5 Jun 2014 07:40:15 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-9161f5409798d52aa8598ff12575fde2327bed84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1401338203.2618.11.camel@buesod1.americas.hpqcorp.net>
References: <1401338203.2618.11.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes: Documentation update/rewrite
Git-Commit-ID: 9161f5409798d52aa8598ff12575fde2327bed84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9161f5409798d52aa8598ff12575fde2327bed84
Gitweb:     http://git.kernel.org/tip/9161f5409798d52aa8598ff12575fde2327bed84
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 28 May 2014 21:36:43 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 13:29:37 +0200

locking/mutexes: Documentation update/rewrite

Our mutexes have gone a long ways since the original
implementation back in 2005/2006. However, the mutex-design.txt
document is still stuck in the past, to the point where most of
the information there is practically useless and, more
important, simply incorrect. This patch pretty much rewrites it
to resemble what we have nowadays.

Since regular semaphores are almost much extinct in the kernel
(most users now rely on mutexes or rwsems), it no longer makes
sense to have such a close comparison, which was copied from
most of the cover letter when Ingo introduced the generic mutex
subsystem.

Note that ww_mutexes are intentionally left out, leaving things
as generic as possible.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: tim.c.chen@linux.intel.com
Cc: paulmck@linux.vnet.ibm.com
Cc: waiman.long@hp.com
Cc: jason.low2@hp.com
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1401338203.2618.11.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/mutex-design.txt | 252 ++++++++++++++++++++++-------------------
 1 file changed, 135 insertions(+), 117 deletions(-)

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
