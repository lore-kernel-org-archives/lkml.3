Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaJMGaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:30:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39860 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaJMG36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:29:58 -0400
Date: Mon, 13 Oct 2014 08:29:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking tree changes for v3.18
Message-ID: <20141013062952.GA9385@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-core-for-linus

   # HEAD: 8acd91e8620836a56ff62028ed28ba629f2881a0 locking/lockdep: Revert qrwlock recusive stuff

The main updates in this cycle were:

 - mutex MCS refactoring finishing touches: improve comments,
   refactor and clean up code, reduce debug data structure 
   footprint, etc.

 - qrwlock finishing touches: remove old code, self-test updates.

 - small rwsem optimization

 - various smaller fixes/cleanups

 Thanks,

	Ingo

------------------>
Bart Van Assche (1):
      locking/spinlocks: Always evaluate the second argument of spin_lock_nested()

Davidlohr Bueso (8):
      locking/mutexes: Standardize arguments in lock/unlock slowpaths
      locking/mutexes: Document quick lock release when unlocking
      locking/mcs: Remove obsolete comment
      locking/mutexes: Refactor optimistic spinning code
      locking/mutexes: Use MUTEX_SPIN_ON_OWNER when appropriate
      locking/Documentation: Move locking related docs into Documentation/locking/
      locking/Documentation: Update locking/mutex-design.txt disadvantages
      locking/rwsem: Move EXPORT_SYMBOL() lines to follow function definition

Jason Low (1):
      locking/rwsem: Avoid double checking before try acquiring write lock

Mark Rustad (1):
      locking/semaphore: Resolve some shadow warnings

Peter Zijlstra (2):
      locking: Remove deprecated smp_mb__() barriers
      locking/lockdep: Revert qrwlock recusive stuff

Waiman Long (4):
      locking/lockdep: Restrict the use of recursive read_lock() with qrwlock
      locking/selftest: Support queued rwlock
      locking/rwlock, x86: Clean up asm/spinlock*.h to remove old rwlock code
      locking/rwlock, x86: Delete unused asm/rwlock.h and rwlock.S


 Documentation/00-INDEX                          |   2 +
 Documentation/DocBook/kernel-locking.tmpl       |   2 +-
 Documentation/{ => locking}/lockdep-design.txt  |   0
 Documentation/{ => locking}/lockstat.txt        |   2 +-
 Documentation/{ => locking}/mutex-design.txt    |   6 +-
 Documentation/{ => locking}/rt-mutex-design.txt |   0
 Documentation/{ => locking}/rt-mutex.txt        |   0
 Documentation/{ => locking}/spinlocks.txt       |  14 +-
 Documentation/{ => locking}/ww-mutex-design.txt |   0
 MAINTAINERS                                     |   4 +-
 arch/x86/include/asm/rwlock.h                   |  49 ---
 arch/x86/include/asm/spinlock.h                 |  81 +----
 arch/x86/include/asm/spinlock_types.h           |   4 -
 arch/x86/lib/Makefile                           |   1 -
 arch/x86/lib/rwlock.S                           |  44 ---
 drivers/gpu/drm/drm_modeset_lock.c              |   2 +-
 include/linux/atomic.h                          |  36 --
 include/linux/bitops.h                          |  20 --
 include/linux/lockdep.h                         |   2 +-
 include/linux/mutex.h                           |   4 +-
 include/linux/rwsem.h                           |   2 +-
 include/linux/spinlock.h                        |   8 +-
 kernel/locking/mcs_spinlock.h                   |   3 -
 kernel/locking/mutex.c                          | 416 +++++++++++++-----------
 kernel/locking/mutex.h                          |   2 +-
 kernel/locking/rtmutex.c                        |   2 +-
 kernel/locking/rwsem-xadd.c                     |  27 +-
 kernel/locking/semaphore.c                      |  12 +-
 kernel/sched/core.c                             |  16 -
 lib/Kconfig.debug                               |   4 +-
 30 files changed, 282 insertions(+), 483 deletions(-)
 rename Documentation/{ => locking}/lockdep-design.txt (100%)
 rename Documentation/{ => locking}/lockstat.txt (99%)
 rename Documentation/{ => locking}/mutex-design.txt (97%)
 rename Documentation/{ => locking}/rt-mutex-design.txt (100%)
 rename Documentation/{ => locking}/rt-mutex.txt (100%)
 rename Documentation/{ => locking}/spinlocks.txt (98%)
 rename Documentation/{ => locking}/ww-mutex-design.txt (100%)
 delete mode 100644 arch/x86/include/asm/rwlock.h
 delete mode 100644 arch/x86/lib/rwlock.S

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 27e67a98b7be..1750fcef1ab4 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -287,6 +287,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+locking/
+	- directory with info about kernel locking primitives
 lockstat.txt
 	- info on collecting statistics on locks (and contention).
 lockup-watchdogs.txt
diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index e584ee12a1e7..7c9cc4846cb6 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1972,7 +1972,7 @@ machines due to caching.
    <itemizedlist>
     <listitem>
      <para>
-       <filename>Documentation/spinlocks.txt</filename>: 
+       <filename>Documentation/locking/spinlocks.txt</filename>:
        Linus Torvalds' spinlocking tutorial in the kernel sources.
      </para>
     </listitem>
diff --git a/Documentation/lockdep-design.txt b/Documentation/locking/lockdep-design.txt
similarity index 100%
rename from Documentation/lockdep-design.txt
rename to Documentation/locking/lockdep-design.txt
diff --git a/Documentation/lockstat.txt b/Documentation/locking/lockstat.txt
similarity index 99%
rename from Documentation/lockstat.txt
rename to Documentation/locking/lockstat.txt
index 72d010689751..7428773a1e69 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/locking/lockstat.txt
@@ -12,7 +12,7 @@ Because things like lock contention can severely impact performance.
 - HOW
 
 Lockdep already has hooks in the lock functions and maps lock instances to
-lock classes. We build on that (see Documentation/lockdep-design.txt).
+lock classes. We build on that (see Documentation/lokcing/lockdep-design.txt).
 The graph below shows the relation between the lock functions and the various
 hooks therein.
 
diff --git a/Documentation/mutex-design.txt b/Documentation/locking/mutex-design.txt
similarity index 97%
rename from Documentation/mutex-design.txt
rename to Documentation/locking/mutex-design.txt
index ee231ed09ec6..60c482df1a38 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/locking/mutex-design.txt
@@ -145,9 +145,9 @@ Disadvantages
 
 Unlike its original design and purpose, 'struct mutex' is larger than
 most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
-as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
-'struct rw_semaphore' variant. Larger structure sizes mean more CPU
-cache and memory footprint.
+as large as 'struct semaphore' (24 bytes) and tied, along with rwsems,
+for the largest lock in the kernel. Larger structure sizes mean more
+CPU cache and memory footprint.
 
 When to use mutexes
 -------------------
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/locking/rt-mutex-design.txt
similarity index 100%
rename from Documentation/rt-mutex-design.txt
rename to Documentation/locking/rt-mutex-design.txt
diff --git a/Documentation/rt-mutex.txt b/Documentation/locking/rt-mutex.txt
similarity index 100%
rename from Documentation/rt-mutex.txt
rename to Documentation/locking/rt-mutex.txt
diff --git a/Documentation/spinlocks.txt b/Documentation/locking/spinlocks.txt
similarity index 98%
rename from Documentation/spinlocks.txt
rename to Documentation/locking/spinlocks.txt
index 97eaf5727178..ff35e40bdf5b 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/locking/spinlocks.txt
@@ -105,9 +105,9 @@ cheaper versions of the spinlocks. IFF you know that the spinlocks are
 	spin_unlock(&lock);
 
 (and the equivalent read-write versions too, of course). The spinlock will
-guarantee the same kind of exclusive access, and it will be much faster. 
+guarantee the same kind of exclusive access, and it will be much faster.
 This is useful if you know that the data in question is only ever
-manipulated from a "process context", ie no interrupts involved. 
+manipulated from a "process context", ie no interrupts involved.
 
 The reasons you mustn't use these versions if you have interrupts that
 play with the spinlock is that you can get deadlocks:
@@ -122,21 +122,21 @@ the other interrupt happens on another CPU, but it is _not_ ok if the
 interrupt happens on the same CPU that already holds the lock, because the
 lock will obviously never be released (because the interrupt is waiting
 for the lock, and the lock-holder is interrupted by the interrupt and will
-not continue until the interrupt has been processed). 
+not continue until the interrupt has been processed).
 
 (This is also the reason why the irq-versions of the spinlocks only need
 to disable the _local_ interrupts - it's ok to use spinlocks in interrupts
 on other CPU's, because an interrupt on another CPU doesn't interrupt the
 CPU that holds the lock, so the lock-holder can continue and eventually
-releases the lock). 
+releases the lock).
 
 Note that you can be clever with read-write locks and interrupts. For
 example, if you know that the interrupt only ever gets a read-lock, then
 you can use a non-irq version of read locks everywhere - because they
-don't block on each other (and thus there is no dead-lock wrt interrupts. 
-But when you do the write-lock, you have to use the irq-safe version. 
+don't block on each other (and thus there is no dead-lock wrt interrupts.
+But when you do the write-lock, you have to use the irq-safe version.
 
-For an example of being clever with rw-locks, see the "waitqueue_lock" 
+For an example of being clever with rw-locks, see the "waitqueue_lock"
 handling in kernel/sched/core.c - nothing ever _changes_ a wait-queue from
 within an interrupt, they only read the queue in order to know whom to
 wake up. So read-locks are safe (which is good: they are very common
diff --git a/Documentation/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
similarity index 100%
rename from Documentation/ww-mutex-design.txt
rename to Documentation/locking/ww-mutex-design.txt
diff --git a/MAINTAINERS b/MAINTAINERS
index 1acc624ecfd7..aac481fcbf5c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5523,8 +5523,8 @@ M:	Ingo Molnar <mingo@redhat.com>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
-F:	Documentation/lockdep*.txt
-F:	Documentation/lockstat.txt
+F:	Documentation/locking/lockdep*.txt
+F:	Documentation/locking/lockstat.txt
 F:	include/linux/lockdep.h
 F:	kernel/locking/
 
diff --git a/arch/x86/include/asm/rwlock.h b/arch/x86/include/asm/rwlock.h
deleted file mode 100644
index a5370a03d90c..000000000000
--- a/arch/x86/include/asm/rwlock.h
+++ /dev/null
@@ -1,49 +0,0 @@
-#ifndef _ASM_X86_RWLOCK_H
-#define _ASM_X86_RWLOCK_H
-
-#include <asm/asm.h>
-
-#if CONFIG_NR_CPUS <= 2048
-
-#ifndef __ASSEMBLY__
-typedef union {
-	s32 lock;
-	s32 write;
-} arch_rwlock_t;
-#endif
-
-#define RW_LOCK_BIAS		0x00100000
-#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##l)
-#define READ_LOCK_ATOMIC(n)	atomic_##n
-#define WRITE_LOCK_ADD(n)	__ASM_FORM_COMMA(addl n)
-#define WRITE_LOCK_SUB(n)	__ASM_FORM_COMMA(subl n)
-#define WRITE_LOCK_CMP		RW_LOCK_BIAS
-
-#else /* CONFIG_NR_CPUS > 2048 */
-
-#include <linux/const.h>
-
-#ifndef __ASSEMBLY__
-typedef union {
-	s64 lock;
-	struct {
-		u32 read;
-		s32 write;
-	};
-} arch_rwlock_t;
-#endif
-
-#define RW_LOCK_BIAS		(_AC(1,L) << 32)
-#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##q)
-#define READ_LOCK_ATOMIC(n)	atomic64_##n
-#define WRITE_LOCK_ADD(n)	__ASM_FORM(incl)
-#define WRITE_LOCK_SUB(n)	__ASM_FORM(decl)
-#define WRITE_LOCK_CMP		1
-
-#endif /* CONFIG_NR_CPUS */
-
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
-
-/* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
-
-#endif /* _ASM_X86_RWLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 54f1c8068c02..9295016485c9 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -187,7 +187,6 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 		cpu_relax();
 }
 
-#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -198,91 +197,15 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
  * irq-safe write-lock, but readers can get non-irqsafe
  * read-locks.
  *
- * On x86, we implement read-write locks as a 32-bit counter
- * with the high bit (sign) being the "contended" bit.
+ * On x86, we implement read-write locks using the generic qrwlock with
+ * x86 specific optimization.
  */
 
-/**
- * read_can_lock - would read_trylock() succeed?
- * @lock: the rwlock in question.
- */
-static inline int arch_read_can_lock(arch_rwlock_t *lock)
-{
-	return lock->lock > 0;
-}
-
-/**
- * write_can_lock - would write_trylock() succeed?
- * @lock: the rwlock in question.
- */
-static inline int arch_write_can_lock(arch_rwlock_t *lock)
-{
-	return lock->write == WRITE_LOCK_CMP;
-}
-
-static inline void arch_read_lock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(dec) " (%0)\n\t"
-		     "jns 1f\n"
-		     "call __read_lock_failed\n\t"
-		     "1:\n"
-		     ::LOCK_PTR_REG (rw) : "memory");
-}
-
-static inline void arch_write_lock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX WRITE_LOCK_SUB(%1) "(%0)\n\t"
-		     "jz 1f\n"
-		     "call __write_lock_failed\n\t"
-		     "1:\n"
-		     ::LOCK_PTR_REG (&rw->write), "i" (RW_LOCK_BIAS)
-		     : "memory");
-}
-
-static inline int arch_read_trylock(arch_rwlock_t *lock)
-{
-	READ_LOCK_ATOMIC(t) *count = (READ_LOCK_ATOMIC(t) *)lock;
-
-	if (READ_LOCK_ATOMIC(dec_return)(count) >= 0)
-		return 1;
-	READ_LOCK_ATOMIC(inc)(count);
-	return 0;
-}
-
-static inline int arch_write_trylock(arch_rwlock_t *lock)
-{
-	atomic_t *count = (atomic_t *)&lock->write;
-
-	if (atomic_sub_and_test(WRITE_LOCK_CMP, count))
-		return 1;
-	atomic_add(WRITE_LOCK_CMP, count);
-	return 0;
-}
-
-static inline void arch_read_unlock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(inc) " %0"
-		     :"+m" (rw->lock) : : "memory");
-}
-
-static inline void arch_write_unlock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
-		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
-}
-#else
 #include <asm/qrwlock.h>
-#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
-#undef READ_LOCK_SIZE
-#undef READ_LOCK_ATOMIC
-#undef WRITE_LOCK_ADD
-#undef WRITE_LOCK_SUB
-#undef WRITE_LOCK_CMP
-
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 73c4c007200f..5f9d7572d82b 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,10 +34,6 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
-#ifdef CONFIG_QUEUE_RWLOCK
 #include <asm-generic/qrwlock_types.h>
-#else
-#include <asm/rwlock.h>
-#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4d4f96a27638..7ef9a30e7dac 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -20,7 +20,6 @@ lib-y := delay.o misc.o cmdline.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-$(CONFIG_SMP) += rwlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
diff --git a/arch/x86/lib/rwlock.S b/arch/x86/lib/rwlock.S
deleted file mode 100644
index 1cad22139c88..000000000000
--- a/arch/x86/lib/rwlock.S
+++ /dev/null
@@ -1,44 +0,0 @@
-/* Slow paths of read/write spinlocks. */
-
-#include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/rwlock.h>
-
-#ifdef CONFIG_X86_32
-# define __lock_ptr eax
-#else
-# define __lock_ptr rdi
-#endif
-
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	FRAME
-0:	LOCK_PREFIX
-	WRITE_LOCK_ADD($RW_LOCK_BIAS) (%__lock_ptr)
-1:	rep; nop
-	cmpl	$WRITE_LOCK_CMP, (%__lock_ptr)
-	jne	1b
-	LOCK_PREFIX
-	WRITE_LOCK_SUB($RW_LOCK_BIAS) (%__lock_ptr)
-	jnz	0b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-END(__write_lock_failed)
-
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	FRAME
-0:	LOCK_PREFIX
-	READ_LOCK_SIZE(inc) (%__lock_ptr)
-1:	rep; nop
-	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
-	js	1b
-	LOCK_PREFIX
-	READ_LOCK_SIZE(dec) (%__lock_ptr)
-	js	0b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-END(__read_lock_failed)
diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 0dc57d5ecd10..3a02e5e3e9f3 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -35,7 +35,7 @@
  * of extra utility/tracking out of our acquire-ctx.  This is provided
  * by drm_modeset_lock / drm_modeset_acquire_ctx.
  *
- * For basic principles of ww_mutex, see: Documentation/ww-mutex-design.txt
+ * For basic principles of ww_mutex, see: Documentation/locking/ww-mutex-design.txt
  *
  * The basic usage pattern is to:
  *
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fef3a809e7cf..5b08a8540ecf 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,42 +3,6 @@
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
 
-/*
- * Provide __deprecated wrappers for the new interface, avoid flag day changes.
- * We need the ugly external functions to break header recursion hell.
- */
-#ifndef smp_mb__before_atomic_inc
-static inline void __deprecated smp_mb__before_atomic_inc(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_atomic_inc
-static inline void __deprecated smp_mb__after_atomic_inc(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
-#ifndef smp_mb__before_atomic_dec
-static inline void __deprecated smp_mb__before_atomic_dec(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_atomic_dec
-static inline void __deprecated smp_mb__after_atomic_dec(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
 /**
  * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cbc5833fb221..be5fd38bd5a0 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -32,26 +32,6 @@ extern unsigned long __sw_hweight64(__u64 w);
  */
 #include <asm/bitops.h>
 
-/*
- * Provide __deprecated wrappers for the new interface, avoid flag day changes.
- * We need the ugly external functions to break header recursion hell.
- */
-#ifndef smp_mb__before_clear_bit
-static inline void __deprecated smp_mb__before_clear_bit(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_clear_bit
-static inline void __deprecated smp_mb__after_clear_bit(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
 	     (bit) < (size);					\
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f920d7..f388481201cd 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
- * see Documentation/lockdep-design.txt for more details.
+ * see Documentation/locking/lockdep-design.txt for more details.
  */
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 8d5535c58cc2..cc31498fc526 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -52,7 +52,7 @@ struct mutex {
 	atomic_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_MUTEX_SPIN_ON_OWNER)
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -133,7 +133,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 
 /*
  * See kernel/locking/mutex.c for detailed documentation of these APIs.
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 035d3c57fc8a..8f498cdde280 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -149,7 +149,7 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * static then another method for expressing nested locking is
  * the explicit definition of lock class keys and the use of
  * lockdep_set_class() at lock initialization time.
- * See Documentation/lockdep-design.txt for more details.)
+ * See Documentation/locking/lockdep-design.txt for more details.)
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3f2867ff0ced..262ba4ef9a8e 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -197,7 +197,13 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
+/*
+ * Always evaluate the 'subclass' argument to avoid that the compiler
+ * warns about set-but-not-used variables when building with
+ * CONFIG_DEBUG_LOCK_ALLOC=n and with W=1.
+ */
+# define raw_spin_lock_nested(lock, subclass)		\
+	_raw_spin_lock(((void)(subclass), (lock)))
 # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
 #endif
 
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 23e89c5930e9..4d60986fcbee 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -56,9 +56,6 @@ do {									\
  * If the lock has already been acquired, then this will proceed to spin
  * on this node->locked until the previous lock holder sets the node->locked
  * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
 static inline
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ae712b25e492..dadbf88c22c4 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -15,7 +15,7 @@
  *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
  *    and Sven Dietrich.
  *
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #include <linux/mutex.h>
 #include <linux/ww_mutex.h>
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
@@ -180,6 +266,129 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	 */
 	return retval;
 }
+
+/*
+ * Atomically try to take the lock when it is available
+ */
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
+		goto done;
+
+	if (!osq_lock(&lock->osq))
+		goto done;
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
+			lock_acquired(&lock->dep_map, ip);
+
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
+done:
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
@@ -277,91 +486,6 @@ __mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
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
@@ -378,104 +502,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
+		/* got the lock, yay! */
+		preempt_enable();
+		return 0;
 	}
-	osq_unlock(&lock->osq);
-slowpath:
-	/*
-	 * If we fell out of the spin path because of need_resched(),
-	 * reschedule now, before we try-lock the mutex. This avoids getting
-	 * scheduled out right after we obtained the mutex.
-	 */
-	if (need_resched())
-		schedule_preempt_disabled();
-#endif
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	/*
@@ -679,15 +711,21 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
  * Release the lock, slowpath:
  */
 static inline void
-__mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
+__mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
 	/*
-	 * some architectures leave the lock unlocked in the fastpath failure
+	 * As a performance measurement, release the lock before doing other
+	 * wakeup related duties to follow. This allows other tasks to acquire
+	 * the lock sooner, while still handling cleanups in past unlock calls.
+	 * This can be done as we do not enforce strict equivalence between the
+	 * mutex counter and wait_list.
+	 *
+	 *
+	 * Some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
-	 * unlock it here
+	 * unlock it here - as the lock counter is currently 0 or negative.
 	 */
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
@@ -716,7 +754,9 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 __visible void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
-	__mutex_unlock_common_slowpath(lock_count, 1);
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	__mutex_unlock_common_slowpath(lock, 1);
 }
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/kernel/locking/mutex.h b/kernel/locking/mutex.h
index 4115fbf83b12..5cda397607f2 100644
--- a/kernel/locking/mutex.h
+++ b/kernel/locking/mutex.h
@@ -16,7 +16,7 @@
 #define mutex_remove_waiter(lock, waiter, ti) \
 		__list_del((waiter)->list.prev, (waiter)->list.next)
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 static inline void mutex_set_owner(struct mutex *lock)
 {
 	lock->owner = current;
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a0ea2a141b3b..7c98873a3077 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
  *  Copyright (C) 2006 Esben Nielsen
  *
- *  See Documentation/rt-mutex-design.txt for details.
+ *  See Documentation/locking/rt-mutex-design.txt for details.
  */
 #include <linux/spinlock.h>
 #include <linux/export.h>
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index d6203faf2eb1..7628c3fc37ca 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -246,19 +246,22 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_down_read_failed);
 
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
-	if (!(count & RWSEM_ACTIVE_MASK)) {
-		/* try acquiring the write lock */
-		if (sem->count == RWSEM_WAITING_BIAS &&
-		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
-			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
-			if (!list_is_singular(&sem->wait_list))
-				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
-			return true;
-		}
+	/*
+	 * Try acquiring the write lock. Check count first in order
+	 * to reduce unnecessary expensive cmpxchg() operations.
+	 */
+	if (count == RWSEM_WAITING_BIAS &&
+	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+		if (!list_is_singular(&sem->wait_list))
+			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		return true;
 	}
+
 	return false;
 }
 
@@ -465,6 +468,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_down_write_failed);
 
 /*
  * handle waking up a waiter on the semaphore
@@ -485,6 +489,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_wake);
 
 /*
  * downgrade a write lock into a read lock
@@ -506,8 +511,4 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	return sem;
 }
-
-EXPORT_SYMBOL(rwsem_down_read_failed);
-EXPORT_SYMBOL(rwsem_down_write_failed);
-EXPORT_SYMBOL(rwsem_wake);
 EXPORT_SYMBOL(rwsem_downgrade_wake);
diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index 6815171a4fff..b8120abe594b 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -36,7 +36,7 @@
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
 static noinline int __down_killable(struct semaphore *sem);
-static noinline int __down_timeout(struct semaphore *sem, long jiffies);
+static noinline int __down_timeout(struct semaphore *sem, long timeout);
 static noinline void __up(struct semaphore *sem);
 
 /**
@@ -145,14 +145,14 @@ EXPORT_SYMBOL(down_trylock);
 /**
  * down_timeout - acquire the semaphore within a specified time
  * @sem: the semaphore to be acquired
- * @jiffies: how long to wait before failing
+ * @timeout: how long to wait before failing
  *
  * Attempts to acquire the semaphore.  If no more tasks are allowed to
  * acquire the semaphore, calling this function will put the task to sleep.
  * If the semaphore is not released within the specified number of jiffies,
  * this function returns -ETIME.  It returns 0 if the semaphore was acquired.
  */
-int down_timeout(struct semaphore *sem, long jiffies)
+int down_timeout(struct semaphore *sem, long timeout)
 {
 	unsigned long flags;
 	int result = 0;
@@ -161,7 +161,7 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
-		result = __down_timeout(sem, jiffies);
+		result = __down_timeout(sem, timeout);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -248,9 +248,9 @@ static noinline int __sched __down_killable(struct semaphore *sem)
 	return __down_common(sem, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
 }
 
-static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
+static noinline int __sched __down_timeout(struct semaphore *sem, long timeout)
 {
-	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
+	return __down_common(sem, TASK_UNINTERRUPTIBLE, timeout);
 }
 
 static noinline void __sched __up(struct semaphore *sem)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575a2208..76c518c9b3a7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -90,22 +90,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
-#ifdef smp_mb__before_atomic
-void __smp_mb__before_atomic(void)
-{
-	smp_mb__before_atomic();
-}
-EXPORT_SYMBOL(__smp_mb__before_atomic);
-#endif
-
-#ifdef smp_mb__after_atomic
-void __smp_mb__after_atomic(void)
-{
-	smp_mb__after_atomic();
-}
-EXPORT_SYMBOL(__smp_mb__after_atomic);
-#endif
-
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 901096d31c66..9b94a063e26c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -924,7 +924,7 @@ config PROVE_LOCKING
 	 the proof of observed correctness is also maintained for an
 	 arbitrary combination of these separate locking variants.
 
-	 For more details, see Documentation/lockdep-design.txt.
+	 For more details, see Documentation/locking/lockdep-design.txt.
 
 config LOCKDEP
 	bool
@@ -945,7 +945,7 @@ config LOCK_STAT
 	help
 	 This feature enables tracking lock contention points
 
-	 For more details, see Documentation/lockstat.txt
+	 For more details, see Documentation/locking/lockstat.txt
 
 	 This also enables lock events required by "perf lock",
 	 subcommand of perf.
