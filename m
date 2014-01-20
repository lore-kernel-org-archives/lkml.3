Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaATLjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:39:00 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:35857 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaATLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:38:52 -0500
Date: Mon, 20 Jan 2014 12:38:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v3.14
Message-ID: <20140120113846.GA9575@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   # HEAD: 63b1a81699c2a45c9f737419b1ec1da0ecf92812 futexes: Fix futex_hashsize initialization

The main changes in this cycle are:

 - futex performance increases: larger hashes, smarter wakeups

 - mutex debugging improvements

 - lots of SMP ordering documentation updates

 - introduce the smp_load_acquire(), smp_store_release() primitives. 
   (There are WIP patches that make use of them - not yet merged.)

 - lockdep micro-optimizations

 - lockdep improvement: better cover IRQ contexts

 - liblockdep at last. We'll continue to monitor how useful this is.

 Thanks,

	Ingo

------------------>
Chuansheng Liu (1):
      mutexes: Give more informative mutex warning in the !lock->owner case

Davidlohr Bueso (2):
      futexes: Increase hash table size for better performance
      futexes: Avoid taking the hb->lock if there's nothing to wake up

Frederic Weisbecker (1):
      lockdep: Simplify a bit hardirq <-> softirq transitions

Heiko Carstens (1):
      futexes: Fix futex_hashsize initialization

Henrik Austad (1):
      Documentation/robust-futex-API: Count properly to 4

Ingo Molnar (2):
      Documentation/memory-barriers.txt: Fix a typo in the data dependency description
      Revert "smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency"

Jason Low (1):
      futexes: Clean up various details

Josh Boyer (1):
      smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency

Paul E. McKenney (7):
      Documentation/memory-barriers.txt: Add needed ACCESS_ONCE() calls to memory-barriers.txt
      Documentation/memory-barriers.txt: Add long atomic examples to memory-barriers.txt
      Documentation/memory-barriers.txt: Document ACCESS_ONCE()
      locking: Add an smp_mb__after_unlock_lock() for UNLOCK+BLOCK barrier
      Documentation/memory-barriers.txt: Downgrade UNLOCK+BLOCK
      rcu: Apply smp_mb__after_unlock_lock() to preserve grace periods
      powerpc: Full barrier for smp_mb__after_unlock_lock()

Peter Zijlstra (6):
      lockdep: Correctly annotate hardirq context in irq_exit()
      Documentation/memory-barriers.txt: Prohibit speculative writes
      locking/doc: Rename LOCK/UNLOCK to ACQUIRE/RELEASE
      arch: Move smp_mb__{before,after}_atomic_{inc,dec}.h into asm/atomic.h
      arch: Clean up asm/barrier.h implementations using asm-generic/barrier.h
      arch: Introduce smp_load_acquire(), smp_store_release()

Sasha Levin (9):
      lockdep: Be nice about building from userspace
      liblockdep: Wrap kernel/locking/lockdep.c to allow usage from userspace
      liblockdep: Add public headers for pthread_mutex_t implementation
      liblockdep: Add pthread_mutex_t test suite
      liblockdep: Add public headers for pthread_rwlock_t implementation
      liblockdep: Add pthread_rwlock_t test suite
      liblockdep: Support using LD_PRELOAD
      liblockdep: Add the 'lockdep' user-space utility
      liblockdep: Add a MAINTAINERS entry

Stephen Rothwell (1):
      arch: Re-sort some Kbuild files to hopefully help avoid some conflicts

Thomas Gleixner (1):
      futexes: Document multiprocessor ordering guarantees


 Documentation/memory-barriers.txt                  | 922 ++++++++++++++++-----
 Documentation/robust-futex-ABI.txt                 |   4 +-
 MAINTAINERS                                        |   5 +
 arch/alpha/include/asm/barrier.h                   |  25 +-
 arch/arc/include/asm/Kbuild                        |   1 +
 arch/arc/include/asm/atomic.h                      |   5 +
 arch/arc/include/asm/barrier.h                     |   5 -
 arch/arm/include/asm/barrier.h                     |  15 +
 arch/arm64/include/asm/barrier.h                   |  50 ++
 arch/avr32/include/asm/barrier.h                   |  17 +-
 arch/blackfin/include/asm/barrier.h                |  18 +-
 arch/cris/include/asm/Kbuild                       |   1 +
 arch/cris/include/asm/barrier.h                    |  25 -
 arch/frv/include/asm/barrier.h                     |   8 +-
 arch/hexagon/include/asm/Kbuild                    |   1 +
 arch/hexagon/include/asm/atomic.h                  |   6 +-
 arch/hexagon/include/asm/barrier.h                 |   4 -
 arch/ia64/include/asm/barrier.h                    |  23 +
 arch/m32r/include/asm/barrier.h                    |  80 +-
 arch/m68k/include/asm/barrier.h                    |  14 +-
 arch/metag/include/asm/barrier.h                   |  15 +
 arch/microblaze/include/asm/Kbuild                 |   1 +
 arch/microblaze/include/asm/barrier.h              |  27 -
 arch/mips/include/asm/barrier.h                    |  15 +
 arch/mn10300/include/asm/Kbuild                    |   1 +
 arch/mn10300/include/asm/barrier.h                 |  37 -
 arch/parisc/include/asm/Kbuild                     |   1 +
 arch/parisc/include/asm/barrier.h                  |  35 -
 arch/powerpc/include/asm/barrier.h                 |  21 +-
 arch/powerpc/include/asm/spinlock.h                |   2 +
 arch/s390/include/asm/barrier.h                    |  15 +
 arch/score/include/asm/Kbuild                      |   1 +
 arch/score/include/asm/barrier.h                   |  16 -
 arch/sh/include/asm/barrier.h                      |  21 +-
 arch/sparc/include/asm/barrier_32.h                |  12 +-
 arch/sparc/include/asm/barrier_64.h                |  15 +
 arch/tile/include/asm/barrier.h                    |  68 +-
 arch/unicore32/include/asm/barrier.h               |  11 +-
 arch/x86/include/asm/barrier.h                     |  43 +-
 arch/xtensa/include/asm/barrier.h                  |   9 +-
 include/asm-generic/barrier.h                      |  55 +-
 include/linux/compiler.h                           |   9 +
 include/linux/spinlock.h                           |  10 +
 kernel/futex.c                                     | 201 ++++-
 kernel/locking/lockdep.c                           |   4 +
 kernel/locking/mutex-debug.c                       |   7 +-
 kernel/rcu/tree.c                                  |  18 +-
 kernel/rcu/tree_plugin.h                           |  13 +
 kernel/softirq.c                                   |  49 +-
 tools/lib/lockdep/Makefile                         | 251 ++++++
 tools/lib/lockdep/common.c                         |  33 +
 tools/lib/lockdep/include/liblockdep/common.h      |  50 ++
 tools/lib/lockdep/include/liblockdep/mutex.h       |  70 ++
 tools/lib/lockdep/include/liblockdep/rwlock.h      |  86 ++
 tools/lib/lockdep/lockdep                          |   3 +
 tools/lib/lockdep/lockdep.c                        |   2 +
 tools/lib/lockdep/lockdep_internals.h              |   1 +
 tools/lib/lockdep/lockdep_states.h                 |   1 +
 tools/lib/lockdep/preload.c                        | 447 ++++++++++
 tools/lib/lockdep/rbtree.c                         |   1 +
 tools/lib/lockdep/run_tests.sh                     |  27 +
 tools/lib/lockdep/tests/AA.c                       |  13 +
 tools/lib/lockdep/tests/ABBA.c                     |  13 +
 tools/lib/lockdep/tests/ABBCCA.c                   |  15 +
 tools/lib/lockdep/tests/ABBCCDDA.c                 |  17 +
 tools/lib/lockdep/tests/ABCABC.c                   |  15 +
 tools/lib/lockdep/tests/ABCDBCDA.c                 |  17 +
 tools/lib/lockdep/tests/ABCDBDDA.c                 |  17 +
 tools/lib/lockdep/tests/WW.c                       |  13 +
 tools/lib/lockdep/tests/common.h                   |  12 +
 tools/lib/lockdep/tests/unlock_balance.c           |  12 +
 tools/lib/lockdep/uinclude/asm/hweight.h           |   3 +
 tools/lib/lockdep/uinclude/asm/sections.h          |   3 +
 tools/lib/lockdep/uinclude/linux/bitops.h          |   3 +
 tools/lib/lockdep/uinclude/linux/compiler.h        |   7 +
 tools/lib/lockdep/uinclude/linux/debug_locks.h     |  12 +
 tools/lib/lockdep/uinclude/linux/delay.h           |   3 +
 tools/lib/lockdep/uinclude/linux/export.h          |   7 +
 tools/lib/lockdep/uinclude/linux/ftrace.h          |   3 +
 tools/lib/lockdep/uinclude/linux/gfp.h             |   3 +
 tools/lib/lockdep/uinclude/linux/hardirq.h         |  11 +
 tools/lib/lockdep/uinclude/linux/hash.h            |   1 +
 tools/lib/lockdep/uinclude/linux/interrupt.h       |   3 +
 tools/lib/lockdep/uinclude/linux/irqflags.h        |  38 +
 tools/lib/lockdep/uinclude/linux/kallsyms.h        |  32 +
 tools/lib/lockdep/uinclude/linux/kern_levels.h     |  25 +
 tools/lib/lockdep/uinclude/linux/kernel.h          |  44 +
 tools/lib/lockdep/uinclude/linux/kmemcheck.h       |   8 +
 tools/lib/lockdep/uinclude/linux/linkage.h         |   3 +
 tools/lib/lockdep/uinclude/linux/list.h            |   1 +
 tools/lib/lockdep/uinclude/linux/lockdep.h         |  55 ++
 tools/lib/lockdep/uinclude/linux/module.h          |   6 +
 tools/lib/lockdep/uinclude/linux/mutex.h           |   3 +
 tools/lib/lockdep/uinclude/linux/poison.h          |   1 +
 tools/lib/lockdep/uinclude/linux/prefetch.h        |   6 +
 tools/lib/lockdep/uinclude/linux/proc_fs.h         |   3 +
 tools/lib/lockdep/uinclude/linux/rbtree.h          |   1 +
 .../lib/lockdep/uinclude/linux/rbtree_augmented.h  |   2 +
 tools/lib/lockdep/uinclude/linux/rcu.h             |  16 +
 tools/lib/lockdep/uinclude/linux/seq_file.h        |   3 +
 tools/lib/lockdep/uinclude/linux/spinlock.h        |  25 +
 tools/lib/lockdep/uinclude/linux/stacktrace.h      |  32 +
 tools/lib/lockdep/uinclude/linux/stringify.h       |   7 +
 tools/lib/lockdep/uinclude/linux/types.h           |  58 ++
 tools/lib/lockdep/uinclude/trace/events/lock.h     |   3 +
 105 files changed, 2825 insertions(+), 683 deletions(-)
 delete mode 100644 arch/cris/include/asm/barrier.h
 delete mode 100644 arch/microblaze/include/asm/barrier.h
 delete mode 100644 arch/mn10300/include/asm/barrier.h
 delete mode 100644 arch/parisc/include/asm/barrier.h
 delete mode 100644 arch/score/include/asm/barrier.h
 create mode 100644 tools/lib/lockdep/Makefile
 create mode 100644 tools/lib/lockdep/common.c
 create mode 100644 tools/lib/lockdep/include/liblockdep/common.h
 create mode 100644 tools/lib/lockdep/include/liblockdep/mutex.h
 create mode 100644 tools/lib/lockdep/include/liblockdep/rwlock.h
 create mode 100755 tools/lib/lockdep/lockdep
 create mode 100644 tools/lib/lockdep/lockdep.c
 create mode 100644 tools/lib/lockdep/lockdep_internals.h
 create mode 100644 tools/lib/lockdep/lockdep_states.h
 create mode 100644 tools/lib/lockdep/preload.c
 create mode 100644 tools/lib/lockdep/rbtree.c
 create mode 100644 tools/lib/lockdep/run_tests.sh
 create mode 100644 tools/lib/lockdep/tests/AA.c
 create mode 100644 tools/lib/lockdep/tests/ABBA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCDDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCABC.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBCDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBDDA.c
 create mode 100644 tools/lib/lockdep/tests/WW.c
 create mode 100644 tools/lib/lockdep/tests/common.h
 create mode 100644 tools/lib/lockdep/tests/unlock_balance.c
 create mode 100644 tools/lib/lockdep/uinclude/asm/hweight.h
 create mode 100644 tools/lib/lockdep/uinclude/asm/sections.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/bitops.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/compiler.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/debug_locks.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/delay.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/export.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/ftrace.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/gfp.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/hardirq.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/hash.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/interrupt.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/irqflags.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kallsyms.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kern_levels.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kernel.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/kmemcheck.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/linkage.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/list.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/lockdep.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/module.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/mutex.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/poison.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/prefetch.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/proc_fs.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/rcu.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/seq_file.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/spinlock.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/stacktrace.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/stringify.h
 create mode 100644 tools/lib/lockdep/uinclude/linux/types.h
 create mode 100644 tools/lib/lockdep/uinclude/trace/events/lock.h

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index c8c42e6..102dc19 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -194,18 +194,22 @@ There are some minimal guarantees that may be expected of a CPU:
  (*) On any given CPU, dependent memory accesses will be issued in order, with
      respect to itself.  This means that for:
 
-	Q = P; D = *Q;
+	ACCESS_ONCE(Q) = P; smp_read_barrier_depends(); D = ACCESS_ONCE(*Q);
 
      the CPU will issue the following memory operations:
 
 	Q = LOAD P, D = LOAD *Q
 
-     and always in that order.
+     and always in that order.  On most systems, smp_read_barrier_depends()
+     does nothing, but it is required for DEC Alpha.  The ACCESS_ONCE()
+     is required to prevent compiler mischief.  Please note that you
+     should normally use something like rcu_dereference() instead of
+     open-coding smp_read_barrier_depends().
 
  (*) Overlapping loads and stores within a particular CPU will appear to be
      ordered within that CPU.  This means that for:
 
-	a = *X; *X = b;
+	a = ACCESS_ONCE(*X); ACCESS_ONCE(*X) = b;
 
      the CPU will only issue the following sequence of memory operations:
 
@@ -213,7 +217,7 @@ There are some minimal guarantees that may be expected of a CPU:
 
      And for:
 
-	*X = c; d = *X;
+	ACCESS_ONCE(*X) = c; d = ACCESS_ONCE(*X);
 
      the CPU will only issue:
 
@@ -224,6 +228,12 @@ There are some minimal guarantees that may be expected of a CPU:
 
 And there are a number of things that _must_ or _must_not_ be assumed:
 
+ (*) It _must_not_ be assumed that the compiler will do what you want with
+     memory references that are not protected by ACCESS_ONCE().  Without
+     ACCESS_ONCE(), the compiler is within its rights to do all sorts
+     of "creative" transformations, which are covered in the Compiler
+     Barrier section.
+
  (*) It _must_not_ be assumed that independent loads and stores will be issued
      in the order given.  This means that for:
 
@@ -371,33 +381,44 @@ Memory barriers come in four basic varieties:
 
 And a couple of implicit varieties:
 
- (5) LOCK operations.
+ (5) ACQUIRE operations.
 
      This acts as a one-way permeable barrier.  It guarantees that all memory
-     operations after the LOCK operation will appear to happen after the LOCK
-     operation with respect to the other components of the system.
+     operations after the ACQUIRE operation will appear to happen after the
+     ACQUIRE operation with respect to the other components of the system.
+     ACQUIRE operations include LOCK operations and smp_load_acquire()
+     operations.
 
-     Memory operations that occur before a LOCK operation may appear to happen
-     after it completes.
+     Memory operations that occur before an ACQUIRE operation may appear to
+     happen after it completes.
 
-     A LOCK operation should almost always be paired with an UNLOCK operation.
+     An ACQUIRE operation should almost always be paired with a RELEASE
+     operation.
 
 
- (6) UNLOCK operations.
+ (6) RELEASE operations.
 
      This also acts as a one-way permeable barrier.  It guarantees that all
-     memory operations before the UNLOCK operation will appear to happen before
-     the UNLOCK operation with respect to the other components of the system.
+     memory operations before the RELEASE operation will appear to happen
+     before the RELEASE operation with respect to the other components of the
+     system. RELEASE operations include UNLOCK operations and
+     smp_store_release() operations.
 
-     Memory operations that occur after an UNLOCK operation may appear to
+     Memory operations that occur after a RELEASE operation may appear to
      happen before it completes.
 
-     LOCK and UNLOCK operations are guaranteed to appear with respect to each
-     other strictly in the order specified.
+     The use of ACQUIRE and RELEASE operations generally precludes the need
+     for other sorts of memory barrier (but note the exceptions mentioned in
+     the subsection "MMIO write barrier").  In addition, a RELEASE+ACQUIRE
+     pair is -not- guaranteed to act as a full memory barrier.  However, after
+     an ACQUIRE on a given variable, all memory accesses preceding any prior
+     RELEASE on that same variable are guaranteed to be visible.  In other
+     words, within a given variable's critical section, all accesses of all
+     previous critical sections for that variable are guaranteed to have
+     completed.
 
-     The use of LOCK and UNLOCK operations generally precludes the need for
-     other sorts of memory barrier (but note the exceptions mentioned in the
-     subsection "MMIO write barrier").
+     This means that ACQUIRE acts as a minimal "acquire" operation and
+     RELEASE acts as a minimal "release" operation.
 
 
 Memory barriers are only required where there's a possibility of interaction
@@ -450,14 +471,14 @@ The usage requirements of data dependency barriers are a little subtle, and
 it's not always obvious that they're needed.  To illustrate, consider the
 following sequence of events:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
-	P = &B
-			Q = P;
-			D = *Q;
+	ACCESS_ONCE(P) = &B
+			      Q = ACCESS_ONCE(P);
+			      D = *Q;
 
 There's a clear data dependency here, and it would seem that by the end of the
 sequence, Q must be either &A or &B, and that:
@@ -477,15 +498,15 @@ Alpha).
 To deal with this, a data dependency barrier or better must be inserted
 between the address load and the data load:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
-	P = &B
-			Q = P;
-			<data dependency barrier>
-			D = *Q;
+	ACCESS_ONCE(P) = &B
+			      Q = ACCESS_ONCE(P);
+			      <data dependency barrier>
+			      D = *Q;
 
 This enforces the occurrence of one of the two implications, and prevents the
 third possibility from arising.
@@ -500,25 +521,26 @@ odd-numbered bank is idle, one can see the new value of the pointer P (&B),
 but the old value of the variable B (2).
 
 
-Another example of where data dependency barriers might by required is where a
+Another example of where data dependency barriers might be required is where a
 number is read from memory and then used to calculate the index for an array
 access:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ M[0] == 1, M[1] == 2, M[3] = 3, P == 0, Q == 3 }
 	M[1] = 4;
 	<write barrier>
-	P = 1
-			Q = P;
-			<data dependency barrier>
-			D = M[Q];
+	ACCESS_ONCE(P) = 1
+			      Q = ACCESS_ONCE(P);
+			      <data dependency barrier>
+			      D = M[Q];
 
 
-The data dependency barrier is very important to the RCU system, for example.
-See rcu_dereference() in include/linux/rcupdate.h.  This permits the current
-target of an RCU'd pointer to be replaced with a new modified target, without
-the replacement target appearing to be incompletely initialised.
+The data dependency barrier is very important to the RCU system,
+for example.  See rcu_assign_pointer() and rcu_dereference() in
+include/linux/rcupdate.h.  This permits the current target of an RCU'd
+pointer to be replaced with a new modified target, without the replacement
+target appearing to be incompletely initialised.
 
 See also the subsection on "Cache Coherency" for a more thorough example.
 
@@ -530,24 +552,190 @@ A control dependency requires a full read memory barrier, not simply a data
 dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
-	q = &a;
-	if (p) {
-		<data dependency barrier>
-		q = &b;
+	q = ACCESS_ONCE(a);
+	if (q) {
+		<data dependency barrier>  /* BUG: No data dependency!!! */
+		p = ACCESS_ONCE(b);
 	}
-	x = *q;
 
 This will not have the desired effect because there is no actual data
-dependency, but rather a control dependency that the CPU may short-circuit by
-attempting to predict the outcome in advance.  In such a case what's actually
-required is:
+dependency, but rather a control dependency that the CPU may short-circuit
+by attempting to predict the outcome in advance, so that other CPUs see
+the load from b as having happened before the load from a.  In such a
+case what's actually required is:
 
-	q = &a;
-	if (p) {
+	q = ACCESS_ONCE(a);
+	if (q) {
 		<read barrier>
-		q = &b;
+		p = ACCESS_ONCE(b);
+	}
+
+However, stores are not speculated.  This means that ordering -is- provided
+in the following example:
+
+	q = ACCESS_ONCE(a);
+	if (ACCESS_ONCE(q)) {
+		ACCESS_ONCE(b) = p;
+	}
+
+Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
+the compiler is within its rights to transform this example:
+
+	q = a;
+	if (q) {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something();
+	} else {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something_else();
+	}
+
+into this, which of course defeats the ordering:
+
+	b = p;
+	q = a;
+	if (q)
+		do_something();
+	else
+		do_something_else();
+
+Worse yet, if the compiler is able to prove (say) that the value of
+variable 'a' is always non-zero, it would be well within its rights
+to optimize the original example by eliminating the "if" statement
+as follows:
+
+	q = a;
+	b = p;  /* BUG: Compiler can reorder!!! */
+	do_something();
+
+The solution is again ACCESS_ONCE(), which preserves the ordering between
+the load from variable 'a' and the store to variable 'b':
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+You could also use barrier() to prevent the compiler from moving
+the stores to variable 'b', but barrier() would not prevent the
+compiler from proving to itself that a==1 always, so ACCESS_ONCE()
+is also needed.
+
+It is important to note that control dependencies absolutely require a
+a conditional.  For example, the following "optimized" version of
+the above example breaks ordering:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
+	if (q) {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something();
+	} else {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something_else();
 	}
-	x = *q;
+
+It is of course legal for the prior load to be part of the conditional,
+for example, as follows:
+
+	if (ACCESS_ONCE(a) > 0) {
+		ACCESS_ONCE(b) = q / 2;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = q / 3;
+		do_something_else();
+	}
+
+This will again ensure that the load from variable 'a' is ordered before the
+stores to variable 'b'.
+
+In addition, you need to be careful what you do with the local variable 'q',
+otherwise the compiler might be able to guess the value and again remove
+the needed conditional.  For example:
+
+	q = ACCESS_ONCE(a);
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+If MAX is defined to be 1, then the compiler knows that (q % MAX) is
+equal to zero, in which case the compiler is within its rights to
+transform the above code into the following:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;
+	do_something_else();
+
+This transformation loses the ordering between the load from variable 'a'
+and the store to variable 'b'.  If you are relying on this ordering, you
+should do something like the following:
+
+	q = ACCESS_ONCE(a);
+	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+Finally, control dependencies do -not- provide transitivity.  This is
+demonstrated by two related examples:
+
+	CPU 0                     CPU 1
+	=====================     =====================
+	r1 = ACCESS_ONCE(x);      r2 = ACCESS_ONCE(y);
+	if (r1 >= 0)              if (r2 >= 0)
+	  ACCESS_ONCE(y) = 1;       ACCESS_ONCE(x) = 1;
+
+	assert(!(r1 == 1 && r2 == 1));
+
+The above two-CPU example will never trigger the assert().  However,
+if control dependencies guaranteed transitivity (which they do not),
+then adding the following two CPUs would guarantee a related assertion:
+
+	CPU 2                     CPU 3
+	=====================     =====================
+	ACCESS_ONCE(x) = 2;       ACCESS_ONCE(y) = 2;
+
+	assert(!(r1 == 2 && r2 == 2 && x == 1 && y == 1)); /* FAILS!!! */
+
+But because control dependencies do -not- provide transitivity, the
+above assertion can fail after the combined four-CPU example completes.
+If you need the four-CPU example to provide ordering, you will need
+smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments.
+
+In summary:
+
+  (*) Control dependencies can order prior loads against later stores.
+      However, they do -not- guarantee any other sort of ordering:
+      Not prior loads against later loads, nor prior stores against
+      later anything.  If you need these other forms of ordering,
+      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
+      later loads, smp_mb().
+
+  (*) Control dependencies require at least one run-time conditional
+      between the prior load and the subsequent store.  If the compiler
+      is able to optimize the conditional away, it will have also
+      optimized away the ordering.  Careful use of ACCESS_ONCE() can
+      help to preserve the needed conditional.
+
+  (*) Control dependencies require that the compiler avoid reordering the
+      dependency into nonexistence.  Careful use of ACCESS_ONCE() or
+      barrier() can help to preserve your control dependency.  Please
+      see the Compiler Barrier section for more information.
+
+  (*) Control dependencies do -not- provide transitivity.  If you
+      need transitivity, use smp_mb().
 
 
 SMP BARRIER PAIRING
@@ -561,23 +749,23 @@ barrier, though a general barrier would also be viable.  Similarly a read
 barrier or a data dependency barrier should always be paired with at least an
 write barrier, though, again, a general barrier is viable:
 
-	CPU 1		CPU 2
-	===============	===============
-	a = 1;
+	CPU 1		      CPU 2
+	===============	      ===============
+	ACCESS_ONCE(a) = 1;
 	<write barrier>
-	b = 2;		x = b;
-			<read barrier>
-			y = a;
+	ACCESS_ONCE(b) = 2;   x = ACCESS_ONCE(b);
+			      <read barrier>
+			      y = ACCESS_ONCE(a);
 
 Or:
 
-	CPU 1		CPU 2
-	===============	===============================
+	CPU 1		      CPU 2
+	===============	      ===============================
 	a = 1;
 	<write barrier>
-	b = &a;		x = b;
-			<data dependency barrier>
-			y = *x;
+	ACCESS_ONCE(b) = &a;  x = ACCESS_ONCE(b);
+			      <data dependency barrier>
+			      y = *x;
 
 Basically, the read barrier always has to be there, even though it can be of
 the "weaker" type.
@@ -586,13 +774,13 @@ the "weaker" type.
 match the loads after the read barrier or the data dependency barrier, and vice
 versa:
 
-	CPU 1                           CPU 2
-	===============                 ===============
-	a = 1;           }----   --->{  v = c
-	b = 2;           }    \ /    {  w = d
-	<write barrier>        \        <read barrier>
-	c = 3;           }    / \    {  x = a;
-	d = 4;           }----   --->{  y = b;
+	CPU 1                               CPU 2
+	===================                 ===================
+	ACCESS_ONCE(a) = 1;  }----   --->{  v = ACCESS_ONCE(c);
+	ACCESS_ONCE(b) = 2;  }    \ /    {  w = ACCESS_ONCE(d);
+	<write barrier>            \        <read barrier>
+	ACCESS_ONCE(c) = 3;  }    / \    {  x = ACCESS_ONCE(a);
+	ACCESS_ONCE(d) = 4;  }----   --->{  y = ACCESS_ONCE(b);
 
 
 EXAMPLES OF MEMORY BARRIER SEQUENCES
@@ -882,12 +1070,12 @@ cache it for later use.
 
 Consider:
 
-	CPU 1	   		CPU 2
+	CPU 1			CPU 2
 	=======================	=======================
-	 	   		LOAD B
-	 	   		DIVIDE		} Divide instructions generally
-	 	   		DIVIDE		} take a long time to perform
-	 	   		LOAD A
+				LOAD B
+				DIVIDE		} Divide instructions generally
+				DIVIDE		} take a long time to perform
+				LOAD A
 
 Which might appear as this:
 
@@ -910,13 +1098,13 @@ Which might appear as this:
 Placing a read barrier or a data dependency barrier just before the second
 load:
 
-	CPU 1	   		CPU 2
+	CPU 1			CPU 2
 	=======================	=======================
-	 	   		LOAD B
-	 	   		DIVIDE
-	 	   		DIVIDE
+				LOAD B
+				DIVIDE
+				DIVIDE
 				<read barrier>
-	 	   		LOAD A
+				LOAD A
 
 will force any value speculatively obtained to be reconsidered to an extent
 dependent on the type of barrier used.  If there was no change made to the
@@ -1042,10 +1230,277 @@ compiler from moving the memory accesses either side of it to the other side:
 
 	barrier();
 
-This is a general barrier - lesser varieties of compiler barrier do not exist.
+This is a general barrier -- there are no read-read or write-write variants
+of barrier().  However, ACCESS_ONCE() can be thought of as a weak form
+for barrier() that affects only the specific accesses flagged by the
+ACCESS_ONCE().
+
+The barrier() function has the following effects:
+
+ (*) Prevents the compiler from reordering accesses following the
+     barrier() to precede any accesses preceding the barrier().
+     One example use for this property is to ease communication between
+     interrupt-handler code and the code that was interrupted.
+
+ (*) Within a loop, forces the compiler to load the variables used
+     in that loop's conditional on each pass through that loop.
+
+The ACCESS_ONCE() function can prevent any number of optimizations that,
+while perfectly safe in single-threaded code, can be fatal in concurrent
+code.  Here are some examples of these sorts of optimizations:
+
+ (*) The compiler is within its rights to merge successive loads from
+     the same variable.  Such merging can cause the compiler to "optimize"
+     the following code:
+
+	while (tmp = a)
+		do_something_with(tmp);
+
+     into the following code, which, although in some sense legitimate
+     for single-threaded code, is almost certainly not what the developer
+     intended:
+
+	if (tmp = a)
+		for (;;)
+			do_something_with(tmp);
+
+     Use ACCESS_ONCE() to prevent the compiler from doing this to you:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+ (*) The compiler is within its rights to reload a variable, for example,
+     in cases where high register pressure prevents the compiler from
+     keeping all data of interest in registers.  The compiler might
+     therefore optimize the variable 'tmp' out of our previous example:
+
+	while (tmp = a)
+		do_something_with(tmp);
+
+     This could result in the following code, which is perfectly safe in
+     single-threaded code, but can be fatal in concurrent code:
+
+	while (a)
+		do_something_with(a);
+
+     For example, the optimized version of this code could result in
+     passing a zero to do_something_with() in the case where the variable
+     a was modified by some other CPU between the "while" statement and
+     the call to do_something_with().
+
+     Again, use ACCESS_ONCE() to prevent the compiler from doing this:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+     Note that if the compiler runs short of registers, it might save
+     tmp onto the stack.  The overhead of this saving and later restoring
+     is why compilers reload variables.  Doing so is perfectly safe for
+     single-threaded code, so you need to tell the compiler about cases
+     where it is not safe.
+
+ (*) The compiler is within its rights to omit a load entirely if it knows
+     what the value will be.  For example, if the compiler can prove that
+     the value of variable 'a' is always zero, it can optimize this code:
+
+	while (tmp = a)
+		do_something_with(tmp);
 
-The compiler barrier has no direct effect on the CPU, which may then reorder
-things however it wishes.
+     Into this:
+
+	do { } while (0);
+
+     This transformation is a win for single-threaded code because it gets
+     rid of a load and a branch.  The problem is that the compiler will
+     carry out its proof assuming that the current CPU is the only one
+     updating variable 'a'.  If variable 'a' is shared, then the compiler's
+     proof will be erroneous.  Use ACCESS_ONCE() to tell the compiler
+     that it doesn't know as much as it thinks it does:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+     But please note that the compiler is also closely watching what you
+     do with the value after the ACCESS_ONCE().  For example, suppose you
+     do the following and MAX is a preprocessor macro with the value 1:
+
+	while ((tmp = ACCESS_ONCE(a)) % MAX)
+		do_something_with(tmp);
+
+     Then the compiler knows that the result of the "%" operator applied
+     to MAX will always be zero, again allowing the compiler to optimize
+     the code into near-nonexistence.  (It will still load from the
+     variable 'a'.)
+
+ (*) Similarly, the compiler is within its rights to omit a store entirely
+     if it knows that the variable already has the value being stored.
+     Again, the compiler assumes that the current CPU is the only one
+     storing into the variable, which can cause the compiler to do the
+     wrong thing for shared variables.  For example, suppose you have
+     the following:
+
+	a = 0;
+	/* Code that does not store to variable a. */
+	a = 0;
+
+     The compiler sees that the value of variable 'a' is already zero, so
+     it might well omit the second store.  This would come as a fatal
+     surprise if some other CPU might have stored to variable 'a' in the
+     meantime.
+
+     Use ACCESS_ONCE() to prevent the compiler from making this sort of
+     wrong guess:
+
+	ACCESS_ONCE(a) = 0;
+	/* Code that does not store to variable a. */
+	ACCESS_ONCE(a) = 0;
+
+ (*) The compiler is within its rights to reorder memory accesses unless
+     you tell it not to.  For example, consider the following interaction
+     between process-level code and an interrupt handler:
+
+	void process_level(void)
+	{
+		msg = get_message();
+		flag = true;
+	}
+
+	void interrupt_handler(void)
+	{
+		if (flag)
+			process_message(msg);
+	}
+
+     There is nothing to prevent the the compiler from transforming
+     process_level() to the following, in fact, this might well be a
+     win for single-threaded code:
+
+	void process_level(void)
+	{
+		flag = true;
+		msg = get_message();
+	}
+
+     If the interrupt occurs between these two statement, then
+     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
+     to prevent this as follows:
+
+	void process_level(void)
+	{
+		ACCESS_ONCE(msg) = get_message();
+		ACCESS_ONCE(flag) = true;
+	}
+
+	void interrupt_handler(void)
+	{
+		if (ACCESS_ONCE(flag))
+			process_message(ACCESS_ONCE(msg));
+	}
+
+     Note that the ACCESS_ONCE() wrappers in interrupt_handler()
+     are needed if this interrupt handler can itself be interrupted
+     by something that also accesses 'flag' and 'msg', for example,
+     a nested interrupt or an NMI.  Otherwise, ACCESS_ONCE() is not
+     needed in interrupt_handler() other than for documentation purposes.
+     (Note also that nested interrupts do not typically occur in modern
+     Linux kernels, in fact, if an interrupt handler returns with
+     interrupts enabled, you will get a WARN_ONCE() splat.)
+
+     You should assume that the compiler can move ACCESS_ONCE() past
+     code not containing ACCESS_ONCE(), barrier(), or similar primitives.
+
+     This effect could also be achieved using barrier(), but ACCESS_ONCE()
+     is more selective:  With ACCESS_ONCE(), the compiler need only forget
+     the contents of the indicated memory locations, while with barrier()
+     the compiler must discard the value of all memory locations that
+     it has currented cached in any machine registers.  Of course,
+     the compiler must also respect the order in which the ACCESS_ONCE()s
+     occur, though the CPU of course need not do so.
+
+ (*) The compiler is within its rights to invent stores to a variable,
+     as in the following example:
+
+	if (a)
+		b = a;
+	else
+		b = 42;
+
+     The compiler might save a branch by optimizing this as follows:
+
+	b = 42;
+	if (a)
+		b = a;
+
+     In single-threaded code, this is not only safe, but also saves
+     a branch.  Unfortunately, in concurrent code, this optimization
+     could cause some other CPU to see a spurious value of 42 -- even
+     if variable 'a' was never zero -- when loading variable 'b'.
+     Use ACCESS_ONCE() to prevent this as follows:
+
+	if (a)
+		ACCESS_ONCE(b) = a;
+	else
+		ACCESS_ONCE(b) = 42;
+
+     The compiler can also invent loads.  These are usually less
+     damaging, but they can result in cache-line bouncing and thus in
+     poor performance and scalability.  Use ACCESS_ONCE() to prevent
+     invented loads.
+
+ (*) For aligned memory locations whose size allows them to be accessed
+     with a single memory-reference instruction, prevents "load tearing"
+     and "store tearing," in which a single large access is replaced by
+     multiple smaller accesses.  For example, given an architecture having
+     16-bit store instructions with 7-bit immediate fields, the compiler
+     might be tempted to use two 16-bit store-immediate instructions to
+     implement the following 32-bit store:
+
+	p = 0x00010002;
+
+     Please note that GCC really does use this sort of optimization,
+     which is not surprising given that it would likely take more
+     than two instructions to build the constant and then store it.
+     This optimization can therefore be a win in single-threaded code.
+     In fact, a recent bug (since fixed) caused GCC to incorrectly use
+     this optimization in a volatile store.  In the absence of such bugs,
+     use of ACCESS_ONCE() prevents store tearing in the following example:
+
+	ACCESS_ONCE(p) = 0x00010002;
+
+     Use of packed structures can also result in load and store tearing,
+     as in this example:
+
+	struct __attribute__((__packed__)) foo {
+		short a;
+		int b;
+		short c;
+	};
+	struct foo foo1, foo2;
+	...
+
+	foo2.a = foo1.a;
+	foo2.b = foo1.b;
+	foo2.c = foo1.c;
+
+     Because there are no ACCESS_ONCE() wrappers and no volatile markings,
+     the compiler would be well within its rights to implement these three
+     assignment statements as a pair of 32-bit loads followed by a pair
+     of 32-bit stores.  This would result in load tearing on 'foo1.b'
+     and store tearing on 'foo2.b'.  ACCESS_ONCE() again prevents tearing
+     in this example:
+
+	foo2.a = foo1.a;
+	ACCESS_ONCE(foo2.b) = ACCESS_ONCE(foo1.b);
+	foo2.c = foo1.c;
+
+All that aside, it is never necessary to use ACCESS_ONCE() on a variable
+that has been marked volatile.  For example, because 'jiffies' is marked
+volatile, it is never necessary to say ACCESS_ONCE(jiffies).  The reason
+for this is that ACCESS_ONCE() is implemented as a volatile cast, which
+has no effect when its argument is already marked volatile.
+
+Please note that these compiler barriers have no direct effect on the CPU,
+which may then reorder things however it wishes.
 
 
 CPU MEMORY BARRIERS
@@ -1135,7 +1590,7 @@ There are some more advanced barrier functions:
 	clear_bit( ... );
 
      This prevents memory operations before the clear leaking to after it.  See
-     the subsection on "Locking Functions" with reference to UNLOCK operation
+     the subsection on "Locking Functions" with reference to RELEASE operation
      implications.
 
      See Documentation/atomic_ops.txt for more information.  See the "Atomic
@@ -1169,8 +1624,8 @@ provide more substantial guarantees, but these may not be relied upon outside
 of arch specific code.
 
 
-LOCKING FUNCTIONS
------------------
+ACQUIRING FUNCTIONS
+-------------------
 
 The Linux kernel has a number of locking constructs:
 
@@ -1181,65 +1636,107 @@ The Linux kernel has a number of locking constructs:
  (*) R/W semaphores
  (*) RCU
 
-In all cases there are variants on "LOCK" operations and "UNLOCK" operations
+In all cases there are variants on "ACQUIRE" operations and "RELEASE" operations
 for each construct.  These operations all imply certain barriers:
 
- (1) LOCK operation implication:
+ (1) ACQUIRE operation implication:
 
-     Memory operations issued after the LOCK will be completed after the LOCK
-     operation has completed.
+     Memory operations issued after the ACQUIRE will be completed after the
+     ACQUIRE operation has completed.
 
-     Memory operations issued before the LOCK may be completed after the LOCK
-     operation has completed.
+     Memory operations issued before the ACQUIRE may be completed after the
+     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
+     with a following ACQUIRE, orders prior loads against subsequent stores and
+     stores and prior stores against subsequent stores.  Note that this is
+     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
+     many architectures.
 
- (2) UNLOCK operation implication:
+ (2) RELEASE operation implication:
 
-     Memory operations issued before the UNLOCK will be completed before the
-     UNLOCK operation has completed.
+     Memory operations issued before the RELEASE will be completed before the
+     RELEASE operation has completed.
 
-     Memory operations issued after the UNLOCK may be completed before the
-     UNLOCK operation has completed.
+     Memory operations issued after the RELEASE may be completed before the
+     RELEASE operation has completed.
 
- (3) LOCK vs LOCK implication:
+ (3) ACQUIRE vs ACQUIRE implication:
 
-     All LOCK operations issued before another LOCK operation will be completed
-     before that LOCK operation.
+     All ACQUIRE operations issued before another ACQUIRE operation will be
+     completed before that ACQUIRE operation.
 
- (4) LOCK vs UNLOCK implication:
+ (4) ACQUIRE vs RELEASE implication:
 
-     All LOCK operations issued before an UNLOCK operation will be completed
-     before the UNLOCK operation.
+     All ACQUIRE operations issued before a RELEASE operation will be
+     completed before the RELEASE operation.
 
-     All UNLOCK operations issued before a LOCK operation will be completed
-     before the LOCK operation.
+ (5) Failed conditional ACQUIRE implication:
 
- (5) Failed conditional LOCK implication:
-
-     Certain variants of the LOCK operation may fail, either due to being
-     unable to get the lock immediately, or due to receiving an unblocked
+     Certain locking variants of the ACQUIRE operation may fail, either due to
+     being unable to get the lock immediately, or due to receiving an unblocked
      signal whilst asleep waiting for the lock to become available.  Failed
      locks do not imply any sort of barrier.
 
-Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
-equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
-
-[!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
-    barriers is that the effects of instructions outside of a critical section
-    may seep into the inside of the critical section.
+[!] Note: one of the consequences of lock ACQUIREs and RELEASEs being only
+one-way barriers is that the effects of instructions outside of a critical
+section may seep into the inside of the critical section.
 
-A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
-because it is possible for an access preceding the LOCK to happen after the
-LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
-two accesses can themselves then cross:
+An ACQUIRE followed by a RELEASE may not be assumed to be full memory barrier
+because it is possible for an access preceding the ACQUIRE to happen after the
+ACQUIRE, and an access following the RELEASE to happen before the RELEASE, and
+the two accesses can themselves then cross:
 
 	*A = a;
-	LOCK
-	UNLOCK
+	ACQUIRE M
+	RELEASE M
 	*B = b;
 
 may occur as:
 
-	LOCK, STORE *B, STORE *A, UNLOCK
+	ACQUIRE M, STORE *B, STORE *A, RELEASE M
+
+This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
+to the same lock variable, but only from the perspective of another CPU not
+holding that lock.
+
+In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
+memory barrier because it is possible for a preceding RELEASE to pass a
+later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
+of the compiler.  Note that deadlocks cannot be introduced by this
+interchange because if such a deadlock threatened, the RELEASE would
+simply complete.
+
+If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
+ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
+will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
+executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
+same variable.  The smp_mb__after_unlock_lock() primitive is free on many
+architectures.  Without smp_mb__after_unlock_lock(), the critical sections
+corresponding to the RELEASE and the ACQUIRE can cross:
+
+	*A = a;
+	RELEASE M
+	ACQUIRE N
+	*B = b;
+
+could occur as:
+
+	ACQUIRE N, STORE *B, STORE *A, RELEASE M
+
+With smp_mb__after_unlock_lock(), they cannot, so that:
+
+	*A = a;
+	RELEASE M
+	ACQUIRE N
+	smp_mb__after_unlock_lock();
+	*B = b;
+
+will always occur as either of the following:
+
+	STORE *A, RELEASE, ACQUIRE, STORE *B
+	STORE *A, ACQUIRE, RELEASE, STORE *B
+
+If the RELEASE and ACQUIRE were instead both operating on the same lock
+variable, only the first of these two alternatives can occur.
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
 systems, and so cannot be counted on in such a situation to actually achieve
@@ -1253,33 +1750,33 @@ As an example, consider the following:
 
 	*A = a;
 	*B = b;
-	LOCK
+	ACQUIRE
 	*C = c;
 	*D = d;
-	UNLOCK
+	RELEASE
 	*E = e;
 	*F = f;
 
 The following sequence of events is acceptable:
 
-	LOCK, {*F,*A}, *E, {*C,*D}, *B, UNLOCK
+	ACQUIRE, {*F,*A}, *E, {*C,*D}, *B, RELEASE
 
 	[+] Note that {*F,*A} indicates a combined access.
 
 But none of the following are:
 
-	{*F,*A}, *B,	LOCK, *C, *D,	UNLOCK, *E
-	*A, *B, *C,	LOCK, *D,	UNLOCK, *E, *F
-	*A, *B,		LOCK, *C,	UNLOCK, *D, *E, *F
-	*B,		LOCK, *C, *D,	UNLOCK, {*F,*A}, *E
+	{*F,*A}, *B,	ACQUIRE, *C, *D,	RELEASE, *E
+	*A, *B, *C,	ACQUIRE, *D,		RELEASE, *E, *F
+	*A, *B,		ACQUIRE, *C,		RELEASE, *D, *E, *F
+	*B,		ACQUIRE, *C, *D,	RELEASE, {*F,*A}, *E
 
 
 
 INTERRUPT DISABLING FUNCTIONS
 -----------------------------
 
-Functions that disable interrupts (LOCK equivalent) and enable interrupts
-(UNLOCK equivalent) will act as compiler barriers only.  So if memory or I/O
+Functions that disable interrupts (ACQUIRE equivalent) and enable interrupts
+(RELEASE equivalent) will act as compiler barriers only.  So if memory or I/O
 barriers are required in such a situation, they must be provided from some
 other means.
 
@@ -1418,75 +1915,81 @@ Other functions that imply barriers:
  (*) schedule() and similar imply full memory barriers.
 
 
-=================================
-INTER-CPU LOCKING BARRIER EFFECTS
-=================================
+===================================
+INTER-CPU ACQUIRING BARRIER EFFECTS
+===================================
 
 On SMP systems locking primitives give a more substantial form of barrier: one
 that does affect memory access ordering on other CPUs, within the context of
 conflict on any particular lock.
 
 
-LOCKS VS MEMORY ACCESSES
-------------------------
+ACQUIRES VS MEMORY ACCESSES
+---------------------------
 
 Consider the following: the system has a pair of spinlocks (M) and (Q), and
 three CPUs; then should the following sequence of events occur:
 
 	CPU 1				CPU 2
 	===============================	===============================
-	*A = a;				*E = e;
-	LOCK M				LOCK Q
-	*B = b;				*F = f;
-	*C = c;				*G = g;
-	UNLOCK M			UNLOCK Q
-	*D = d;				*H = h;
+	ACCESS_ONCE(*A) = a;		ACCESS_ONCE(*E) = e;
+	ACQUIRE M			ACQUIRE Q
+	ACCESS_ONCE(*B) = b;		ACCESS_ONCE(*F) = f;
+	ACCESS_ONCE(*C) = c;		ACCESS_ONCE(*G) = g;
+	RELEASE M			RELEASE Q
+	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*H) = h;
 
 Then there is no guarantee as to what order CPU 3 will see the accesses to *A
 through *H occur in, other than the constraints imposed by the separate locks
 on the separate CPUs. It might, for example, see:
 
-	*E, LOCK M, LOCK Q, *G, *C, *F, *A, *B, UNLOCK Q, *D, *H, UNLOCK M
+	*E, ACQUIRE M, ACQUIRE Q, *G, *C, *F, *A, *B, RELEASE Q, *D, *H, RELEASE M
 
 But it won't see any of:
 
-	*B, *C or *D preceding LOCK M
-	*A, *B or *C following UNLOCK M
-	*F, *G or *H preceding LOCK Q
-	*E, *F or *G following UNLOCK Q
+	*B, *C or *D preceding ACQUIRE M
+	*A, *B or *C following RELEASE M
+	*F, *G or *H preceding ACQUIRE Q
+	*E, *F or *G following RELEASE Q
 
 
 However, if the following occurs:
 
 	CPU 1				CPU 2
 	===============================	===============================
-	*A = a;
-	LOCK M		[1]
-	*B = b;
-	*C = c;
-	UNLOCK M	[1]
-	*D = d;				*E = e;
-					LOCK M		[2]
-					*F = f;
-					*G = g;
-					UNLOCK M	[2]
-					*H = h;
+	ACCESS_ONCE(*A) = a;
+	ACQUIRE M		     [1]
+	ACCESS_ONCE(*B) = b;
+	ACCESS_ONCE(*C) = c;
+	RELEASE M	     [1]
+	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*E) = e;
+					ACQUIRE M		     [2]
+					smp_mb__after_unlock_lock();
+					ACCESS_ONCE(*F) = f;
+					ACCESS_ONCE(*G) = g;
+					RELEASE M	     [2]
+					ACCESS_ONCE(*H) = h;
 
 CPU 3 might see:
 
-	*E, LOCK M [1], *C, *B, *A, UNLOCK M [1],
-		LOCK M [2], *H, *F, *G, UNLOCK M [2], *D
+	*E, ACQUIRE M [1], *C, *B, *A, RELEASE M [1],
+		ACQUIRE M [2], *H, *F, *G, RELEASE M [2], *D
 
 But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 
-	*B, *C, *D, *F, *G or *H preceding LOCK M [1]
-	*A, *B or *C following UNLOCK M [1]
-	*F, *G or *H preceding LOCK M [2]
-	*A, *B, *C, *E, *F or *G following UNLOCK M [2]
+	*B, *C, *D, *F, *G or *H preceding ACQUIRE M [1]
+	*A, *B or *C following RELEASE M [1]
+	*F, *G or *H preceding ACQUIRE M [2]
+	*A, *B, *C, *E, *F or *G following RELEASE M [2]
 
+Note that the smp_mb__after_unlock_lock() is critically important
+here: Without it CPU 3 might see some of the above orderings.
+Without smp_mb__after_unlock_lock(), the accesses are not guaranteed
+to be seen in order unless CPU 3 holds lock M.
 
-LOCKS VS I/O ACCESSES
----------------------
+
+ACQUIRES VS I/O ACCESSES
+------------------------
 
 Under certain circumstances (especially involving NUMA), I/O accesses within
 two spinlocked sections on two different CPUs may be seen as interleaved by the
@@ -1687,28 +2190,30 @@ explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
-	atomic_xchg();
-	atomic_cmpxchg();
-	atomic_inc_return();
-	atomic_dec_return();
-	atomic_add_return();
-	atomic_sub_return();
-	atomic_inc_and_test();
-	atomic_dec_and_test();
-	atomic_sub_and_test();
-	atomic_add_negative();
-	atomic_add_unless();	/* when succeeds (returns 1) */
+	atomic_xchg();			atomic_long_xchg();
+	atomic_cmpxchg();		atomic_long_cmpxchg();
+	atomic_inc_return();		atomic_long_inc_return();
+	atomic_dec_return();		atomic_long_dec_return();
+	atomic_add_return();		atomic_long_add_return();
+	atomic_sub_return();		atomic_long_sub_return();
+	atomic_inc_and_test();		atomic_long_inc_and_test();
+	atomic_dec_and_test();		atomic_long_dec_and_test();
+	atomic_sub_and_test();		atomic_long_sub_and_test();
+	atomic_add_negative();		atomic_long_add_negative();
 	test_and_set_bit();
 	test_and_clear_bit();
 	test_and_change_bit();
 
-These are used for such things as implementing LOCK-class and UNLOCK-class
+	/* when succeeds (returns 1) */
+	atomic_add_unless();		atomic_long_add_unless();
+
+These are used for such things as implementing ACQUIRE-class and RELEASE-class
 operations and adjusting reference counters towards object destruction, and as
 such the implicit memory barrier effects are necessary.
 
 
 The following operations are potential problems as they do _not_ imply memory
-barriers, but might be used for implementing such things as UNLOCK-class
+barriers, but might be used for implementing such things as RELEASE-class
 operations:
 
 	atomic_set();
@@ -1750,7 +2255,7 @@ The following operations are special locking primitives:
 	clear_bit_unlock();
 	__clear_bit_unlock();
 
-These implement LOCK-class and UNLOCK-class operations. These should be used in
+These implement ACQUIRE-class and RELEASE-class operations. These should be used in
 preference to other operations when implementing locking primitives, because
 their implementations can be optimised on many architectures.
 
@@ -1887,8 +2392,8 @@ functions:
      space should suffice for PCI.
 
      [*] NOTE! attempting to load from the same location as was written to may
-     	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
-     	 example.
+	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
+	 example.
 
      Used with prefetchable I/O memory, an mmiowb() barrier may be required to
      force stores to be ordered.
@@ -1955,19 +2460,19 @@ barriers for the most part act at the interface between the CPU and its cache
 	                          :
 	+--------+    +--------+  :   +--------+    +-----------+
 	|        |    |        |  :   |        |    |           |    +--------+
-	|  CPU   |    | Memory |  :   | CPU    |    |           |    |	      |
-	|  Core  |--->| Access |----->| Cache  |<-->|           |    |	      |
+	|  CPU   |    | Memory |  :   | CPU    |    |           |    |        |
+	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
 	|        |    | Queue  |  :   |        |    |           |--->| Memory |
-	|        |    |        |  :   |        |    |           |    |	      |
-	+--------+    +--------+  :   +--------+    |           |    | 	      |
+	|        |    |        |  :   |        |    |           |    |        |
+	+--------+    +--------+  :   +--------+    |           |    |        |
 	                          :                 | Cache     |    +--------+
 	                          :                 | Coherency |
 	                          :                 | Mechanism |    +--------+
 	+--------+    +--------+  :   +--------+    |           |    |	      |
 	|        |    |        |  :   |        |    |           |    |        |
 	|  CPU   |    | Memory |  :   | CPU    |    |           |--->| Device |
-	|  Core  |--->| Access |----->| Cache  |<-->|           |    | 	      |
-	|        |    | Queue  |  :   |        |    |           |    | 	      |
+	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
+	|        |    | Queue  |  :   |        |    |           |    |        |
 	|        |    |        |  :   |        |    |           |    +--------+
 	+--------+    +--------+  :   +--------+    +-----------+
 	                          :
@@ -2090,7 +2595,7 @@ CPU's caches by some other cache event:
 	p = &v;		q = p;
 			<D:request p>
 	<B:modify p=&v>	<D:commit p=&v>
-		  	<D:read p>
+			<D:read p>
 			x = *q;
 			<C:read *q>	Reads from v before v updated in cache
 			<C:unbusy>
@@ -2115,7 +2620,7 @@ queue before processing any further requests:
 	p = &v;		q = p;
 			<D:request p>
 	<B:modify p=&v>	<D:commit p=&v>
-		  	<D:read p>
+			<D:read p>
 			smp_read_barrier_depends()
 			<C:unbusy>
 			<C:commit v=2>
@@ -2177,11 +2682,11 @@ A programmer might take it for granted that the CPU will perform memory
 operations in exactly the order specified, so that if the CPU is, for example,
 given the following piece of code to execute:
 
-	a = *A;
-	*B = b;
-	c = *C;
-	d = *D;
-	*E = e;
+	a = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*B) = b;
+	c = ACCESS_ONCE(*C);
+	d = ACCESS_ONCE(*D);
+	ACCESS_ONCE(*E) = e;
 
 they would then expect that the CPU will complete the memory operation for each
 instruction before moving on to the next one, leading to a definite sequence of
@@ -2228,12 +2733,12 @@ However, it is guaranteed that a CPU will be self-consistent: it will see its
 _own_ accesses appear to be correctly ordered, without the need for a memory
 barrier.  For instance with the following code:
 
-	U = *A;
-	*A = V;
-	*A = W;
-	X = *A;
-	*A = Y;
-	Z = *A;
+	U = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*A) = V;
+	ACCESS_ONCE(*A) = W;
+	X = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*A) = Y;
+	Z = ACCESS_ONCE(*A);
 
 and assuming no intervention by an external influence, it can be assumed that
 the final result will appear to be:
@@ -2250,7 +2755,12 @@ accesses:
 
 in that order, but, without intervention, the sequence may have almost any
 combination of elements combined or discarded, provided the program's view of
-the world remains consistent.
+the world remains consistent.  Note that ACCESS_ONCE() is -not- optional
+in the above example, as there are architectures where a given CPU might
+interchange successive loads to the same location.  On such architectures,
+ACCESS_ONCE() does whatever is necessary to prevent this, for example, on
+Itanium the volatile casts used by ACCESS_ONCE() cause GCC to emit the
+special ld.acq and st.rel instructions that prevent such reordering.
 
 The compiler may also combine, discard or defer elements of the sequence before
 the CPU even sees them.
@@ -2264,13 +2774,13 @@ may be reduced to:
 
 	*A = W;
 
-since, without a write barrier, it can be assumed that the effect of the
-storage of V to *A is lost.  Similarly:
+since, without either a write barrier or an ACCESS_ONCE(), it can be
+assumed that the effect of the storage of V to *A is lost.  Similarly:
 
 	*A = Y;
 	Z = *A;
 
-may, without a memory barrier, be reduced to:
+may, without a memory barrier or an ACCESS_ONCE(), be reduced to:
 
 	*A = Y;
 	Z = Y;
diff --git a/Documentation/robust-futex-ABI.txt b/Documentation/robust-futex-ABI.txt
index fd1cd8a..16eb314f 100644
--- a/Documentation/robust-futex-ABI.txt
+++ b/Documentation/robust-futex-ABI.txt
@@ -146,8 +146,8 @@ On removal:
  1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be removed,
  2) remove the lock entry for this lock from the 'head' list,
- 2) release the futex lock, and
- 2) clear the 'lock_op_pending' word.
+ 3) release the futex lock, and
+ 4) clear the 'lock_op_pending' word.
 
 On exit, the kernel will consider the address stored in
 'list_op_pending' and the address of each 'lock word' found by walking
diff --git a/MAINTAINERS b/MAINTAINERS
index 31a0462..d6cf726 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5141,6 +5141,11 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	tools/lguest/
 
+LIBLOCKDEP
+M:	Sasha Levin <sasha.levin@oracle.com>
+S:	Maintained
+F:	tools/lib/lockdep/
+
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
diff --git a/arch/alpha/include/asm/barrier.h b/arch/alpha/include/asm/barrier.h
index ce8860a..3832bdb 100644
--- a/arch/alpha/include/asm/barrier.h
+++ b/arch/alpha/include/asm/barrier.h
@@ -3,33 +3,18 @@
 
 #include <asm/compiler.h>
 
-#define mb() \
-__asm__ __volatile__("mb": : :"memory")
+#define mb()	__asm__ __volatile__("mb": : :"memory")
+#define rmb()	__asm__ __volatile__("mb": : :"memory")
+#define wmb()	__asm__ __volatile__("wmb": : :"memory")
 
-#define rmb() \
-__asm__ __volatile__("mb": : :"memory")
-
-#define wmb() \
-__asm__ __volatile__("wmb": : :"memory")
-
-#define read_barrier_depends() \
-__asm__ __volatile__("mb": : :"memory")
+#define read_barrier_depends() __asm__ __volatile__("mb": : :"memory")
 
 #ifdef CONFIG_SMP
 #define __ASM_SMP_MB	"\tmb\n"
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define __ASM_SMP_MB
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
 #endif
 
-#define set_mb(var, value) \
-do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif		/* __BARRIER_H */
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 5943f7f..9ae21c1 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -1,4 +1,5 @@
 generic-y += auxvec.h
+generic-y += barrier.h
 generic-y += bugs.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 83f03ca..03e494f 100644
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -190,6 +190,11 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 /**
  * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
index f6cb7c4..c32245c 100644
--- a/arch/arc/include/asm/barrier.h
+++ b/arch/arc/include/asm/barrier.h
@@ -30,11 +30,6 @@
 #define smp_wmb()       barrier()
 #endif
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #define smp_read_barrier_depends()      do { } while (0)
 
 #endif
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 60f15e2..2f59f74 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -59,6 +59,21 @@
 #define smp_wmb()	dmb(ishst)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
 
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index d4a6333..78e20ba 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -35,10 +35,60 @@
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #else
+
 #define smp_mb()	asm volatile("dmb ish" : : : "memory")
 #define smp_rmb()	asm volatile("dmb ishld" : : : "memory")
 #define smp_wmb()	asm volatile("dmb ishst" : : : "memory")
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("stlr %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("stlr %1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1;						\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("ldar %w0, %1"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	case 8:								\
+		asm volatile ("ldar %0, %1"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	}								\
+	___p1;								\
+})
+
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
index 0961275..7151007 100644
--- a/arch/avr32/include/asm/barrier.h
+++ b/arch/avr32/include/asm/barrier.h
@@ -8,22 +8,15 @@
 #ifndef __ASM_AVR32_BARRIER_H
 #define __ASM_AVR32_BARRIER_H
 
-#define nop()			asm volatile("nop")
-
-#define mb()			asm volatile("" : : : "memory")
-#define rmb()			mb()
-#define wmb()			asm volatile("sync 0" : : : "memory")
-#define read_barrier_depends()  do { } while(0)
-#define set_mb(var, value)      do { var = value; mb(); } while(0)
+/*
+ * Weirdest thing ever.. no full barrier, but it has a write barrier!
+ */
+#define wmb()	asm volatile("sync 0" : : : "memory")
 
 #ifdef CONFIG_SMP
 # error "The AVR32 port does not support SMP"
-#else
-# define smp_mb()		barrier()
-# define smp_rmb()		barrier()
-# define smp_wmb()		barrier()
-# define smp_read_barrier_depends() do { } while(0)
 #endif
 
+#include <asm-generic/barrier.h>
 
 #endif /* __ASM_AVR32_BARRIER_H */
diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
index ebb1895..19283a1 100644
--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -23,26 +23,10 @@
 # define rmb()	do { barrier(); smp_check_barrier(); } while (0)
 # define wmb()	do { barrier(); smp_mark_barrier(); } while (0)
 # define read_barrier_depends()	do { barrier(); smp_check_barrier(); } while (0)
-#else
-# define mb()	barrier()
-# define rmb()	barrier()
-# define wmb()	barrier()
-# define read_barrier_depends()	do { } while (0)
 #endif
 
-#else /* !CONFIG_SMP */
-
-#define mb()	barrier()
-#define rmb()	barrier()
-#define wmb()	barrier()
-#define read_barrier_depends()	do { } while (0)
-
 #endif /* !CONFIG_SMP */
 
-#define smp_mb()  mb()
-#define smp_rmb() rmb()
-#define smp_wmb() wmb()
-#define set_mb(var, value) do { var = value; mb(); } while (0)
-#define smp_read_barrier_depends()	read_barrier_depends()
+#include <asm-generic/barrier.h>
 
 #endif /* _BLACKFIN_BARRIER_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index b06caf6..199b1a9 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -3,6 +3,7 @@ header-y += arch-v10/
 header-y += arch-v32/
 
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
diff --git a/arch/cris/include/asm/barrier.h b/arch/cris/include/asm/barrier.h
deleted file mode 100644
index 198ad7f..0000000
--- a/arch/cris/include/asm/barrier.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __ASM_CRIS_BARRIER_H
-#define __ASM_CRIS_BARRIER_H
-
-#define nop() __asm__ __volatile__ ("nop");
-
-#define barrier() __asm__ __volatile__("": : :"memory")
-#define mb() barrier()
-#define rmb() mb()
-#define wmb() mb()
-#define read_barrier_depends() do { } while(0)
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#define smp_read_barrier_depends()     read_barrier_depends()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#define smp_read_barrier_depends()     do { } while(0)
-#endif
-
-#endif /* __ASM_CRIS_BARRIER_H */
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
index 06776ad..abbef47 100644
--- a/arch/frv/include/asm/barrier.h
+++ b/arch/frv/include/asm/barrier.h
@@ -17,13 +17,7 @@
 #define mb()			asm volatile ("membar" : : :"memory")
 #define rmb()			asm volatile ("membar" : : :"memory")
 #define wmb()			asm volatile ("membar" : : :"memory")
-#define read_barrier_depends()	do { } while (0)
 
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#define set_mb(var, value) \
-	do { var = (value); barrier(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* _ASM_BARRIER_H */
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 67c3450..ada843c 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -2,6 +2,7 @@
 header-y += ucontext.h
 
 generic-y += auxvec.h
+generic-y += barrier.h
 generic-y += bug.h
 generic-y += bugs.h
 generic-y += clkdev.h
diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index 8a64ff2..7aae4cb 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -160,8 +160,12 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, (v)) == 0)
 #define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
 
-
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 #endif
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
index 1041a8e..4e863da 100644
--- a/arch/hexagon/include/asm/barrier.h
+++ b/arch/hexagon/include/asm/barrier.h
@@ -29,10 +29,6 @@
 #define smp_read_barrier_depends()	barrier()
 #define smp_wmb()			barrier()
 #define smp_mb()			barrier()
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
 
 /*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
 #define set_mb(var, value) \
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index 60576e0..d0a69aa 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -45,14 +45,37 @@
 # define smp_rmb()	rmb()
 # define smp_wmb()	wmb()
 # define smp_read_barrier_depends()	read_barrier_depends()
+
 #else
+
 # define smp_mb()	barrier()
 # define smp_rmb()	barrier()
 # define smp_wmb()	barrier()
 # define smp_read_barrier_depends()	do { } while(0)
+
 #endif
 
 /*
+ * IA64 GCC turns volatile stores into st.rel and volatile loads into ld.acq no
+ * need for asm trickery!
+ */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
+/*
  * XXX check on this ---I suspect what Linus really wants here is
  * acquire vs release semantics but we can't discuss this stuff with
  * Linus just yet.  Grrr...
diff --git a/arch/m32r/include/asm/barrier.h b/arch/m32r/include/asm/barrier.h
index 6976621..1a40265 100644
--- a/arch/m32r/include/asm/barrier.h
+++ b/arch/m32r/include/asm/barrier.h
@@ -11,84 +11,6 @@
 
 #define nop()  __asm__ __volatile__ ("nop" : : )
 
-/*
- * Memory barrier.
- *
- * mb() prevents loads and stores being reordered across this point.
- * rmb() prevents loads being reordered across this point.
- * wmb() prevents stores being reordered across this point.
- */
-#define mb()   barrier()
-#define rmb()  mb()
-#define wmb()  mb()
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      b = 2;
- *      memory_barrier();
- *      p = &b;                         q = p;
- *                                      read_barrier_depends();
- *                                      d = *q;
- * </programlisting>
- *
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      a = 2;
- *      memory_barrier();
- *      b = 3;                          y = b;
- *                                      read_barrier_depends();
- *                                      x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
+#include <asm-generic/barrier.h>
 
 #endif /* _ASM_M32R_BARRIER_H */
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
index 445ce22..15c5f77 100644
--- a/arch/m68k/include/asm/barrier.h
+++ b/arch/m68k/include/asm/barrier.h
@@ -1,20 +1,8 @@
 #ifndef _M68K_BARRIER_H
 #define _M68K_BARRIER_H
 
-/*
- * Force strict CPU ordering.
- * Not really required on m68k...
- */
 #define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define read_barrier_depends()	((void)0)
-#define set_mb(var, value)	({ (var) = (value); wmb(); })
 
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	((void)0)
+#include <asm-generic/barrier.h>
 
 #endif /* _M68K_BARRIER_H */
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c90bfc6..5d6b4b4 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -82,4 +82,19 @@ static inline void fence(void)
 #define smp_read_barrier_depends()     do { } while (0)
 #define set_mb(var, value) do { var = value; smp_mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index ce0bbf8..a824265 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,4 +1,5 @@
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
deleted file mode 100644
index df5be3e8..0000000
--- a/arch/microblaze/include/asm/barrier.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_BARRIER_H
-#define _ASM_MICROBLAZE_BARRIER_H
-
-#define nop()                  asm volatile ("nop")
-
-#define smp_read_barrier_depends()	do {} while (0)
-#define read_barrier_depends()		do {} while (0)
-
-#define mb()			barrier()
-#define rmb()			mb()
-#define wmb()			mb()
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
-
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-#endif /* _ASM_MICROBLAZE_BARRIER_H */
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index f26d8e1..e1aa4e4 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -180,4 +180,19 @@
 #define nudge_writes() mb()
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 74742dc..032143e 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,4 +1,5 @@
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
deleted file mode 100644
index 2bd97a5..0000000
--- a/arch/mn10300/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* MN10300 memory barrier definitions
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_BARRIER_H
-#define _ASM_BARRIER_H
-
-#define nop()	asm volatile ("nop")
-
-#define mb()	asm volatile ("": : :"memory")
-#define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define set_mb(var, value)  do { xchg(&var, value); } while (0)
-#else  /* CONFIG_SMP */
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#endif /* CONFIG_SMP */
-
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#endif /* _ASM_BARRIER_H */
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index a603b9e..34b0be4 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,5 @@
 
+generic-y += barrier.h
 generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
 	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
diff --git a/arch/parisc/include/asm/barrier.h b/arch/parisc/include/asm/barrier.h
deleted file mode 100644
index e77d834..0000000
--- a/arch/parisc/include/asm/barrier.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef __PARISC_BARRIER_H
-#define __PARISC_BARRIER_H
-
-/*
-** This is simply the barrier() macro from linux/kernel.h but when serial.c
-** uses tqueue.h uses smp_mb() defined using barrier(), linux/kernel.h
-** hasn't yet been included yet so it fails, thus repeating the macro here.
-**
-** PA-RISC architecture allows for weakly ordered memory accesses although
-** none of the processors use it. There is a strong ordered bit that is
-** set in the O-bit of the page directory entry. Operating systems that
-** can not tolerate out of order accesses should set this bit when mapping
-** pages. The O-bit of the PSW should also be set to 1 (I don't believe any
-** of the processor implemented the PSW O-bit). The PCX-W ERS states that
-** the TLB O-bit is not implemented so the page directory does not need to
-** have the O-bit set when mapping pages (section 3.1). This section also
-** states that the PSW Y, Z, G, and O bits are not implemented.
-** So it looks like nothing needs to be done for parisc-linux (yet).
-** (thanks to chada for the above comment -ggg)
-**
-** The __asm__ op below simple prevents gcc/ld from reordering
-** instructions across the mb() "call".
-*/
-#define mb()		__asm__ __volatile__("":::"memory")	/* barrier() */
-#define rmb()		mb()
-#define wmb()		mb()
-#define smp_mb()	mb()
-#define smp_rmb()	mb()
-#define smp_wmb()	mb()
-#define smp_read_barrier_depends()	do { } while(0)
-#define read_barrier_depends()		do { } while(0)
-
-#define set_mb(var, value)		do { var = value; mb(); } while (0)
-
-#endif /* __PARISC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index ae78225..f89da80 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -45,11 +45,15 @@
 #    define SMPWMB      eieio
 #endif
 
+#define __lwsync()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+
 #define smp_mb()	mb()
-#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+#define smp_rmb()	__lwsync()
 #define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
+#define __lwsync()	barrier()
+
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
@@ -65,4 +69,19 @@
 #define data_barrier(x)	\
 	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	__lwsync();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	__lwsync();							\
+	___p1;								\
+})
+
 #endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5f54a74..f6e78d6 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -28,6 +28,8 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
+#define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
+
 #define arch_spin_is_locked(x)		((x)->slock != 0)
 
 #ifdef CONFIG_PPC64
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 16760ee..578680f 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -32,4 +32,19 @@
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index f3414ad..fe7471e 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 header-y +=
 
+generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
deleted file mode 100644
index 0eacb64..0000000
--- a/arch/score/include/asm/barrier.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_SCORE_BARRIER_H
-#define _ASM_SCORE_BARRIER_H
-
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#define set_mb(var, value) 		do {var = value; wmb(); } while (0)
-
-#endif /* _ASM_SCORE_BARRIER_H */
diff --git a/arch/sh/include/asm/barrier.h b/arch/sh/include/asm/barrier.h
index 72c103d..4371530 100644
--- a/arch/sh/include/asm/barrier.h
+++ b/arch/sh/include/asm/barrier.h
@@ -26,29 +26,14 @@
 #if defined(CONFIG_CPU_SH4A) || defined(CONFIG_CPU_SH5)
 #define mb()		__asm__ __volatile__ ("synco": : :"memory")
 #define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("synco": : :"memory")
+#define wmb()		mb()
 #define ctrl_barrier()	__icbi(PAGE_OFFSET)
-#define read_barrier_depends()	do { } while(0)
 #else
-#define mb()		__asm__ __volatile__ ("": : :"memory")
-#define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("": : :"memory")
 #define ctrl_barrier()	__asm__ __volatile__ ("nop;nop;nop;nop;nop;nop;nop;nop")
-#define read_barrier_depends()	do { } while(0)
-#endif
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
 #endif
 
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 
+#include <asm-generic/barrier.h>
+
 #endif /* __ASM_SH_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_32.h b/arch/sparc/include/asm/barrier_32.h
index c1b7665..ae69eda 100644
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -1,15 +1,7 @@
 #ifndef __SPARC_BARRIER_H
 #define __SPARC_BARRIER_H
 
-/* XXX Change this if we ever use a PSO mode kernel. */
-#define mb()	__asm__ __volatile__ ("" : : : "memory")
-#define rmb()	mb()
-#define wmb()	mb()
-#define read_barrier_depends()	do { } while(0)
-#define set_mb(__var, __value)  do { __var = __value; mb(); } while(0)
-#define smp_mb()	__asm__ __volatile__("":::"memory")
-#define smp_rmb()	__asm__ __volatile__("":::"memory")
-#define smp_wmb()	__asm__ __volatile__("":::"memory")
-#define smp_read_barrier_depends()	do { } while(0)
+#include <asm/processor.h> /* for nop() */
+#include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index 95d4598..b5aad96 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -53,4 +53,19 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
 
 #define smp_read_barrier_depends()	do { } while(0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index a9a73da..b5a05d0 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -22,59 +22,6 @@
 #include <arch/spr_def.h>
 #include <asm/timex.h>
 
-/*
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- */
-#define read_barrier_depends()	do { } while (0)
-
 #define __sync()	__insn_mf()
 
 #include <hv/syscall_public.h>
@@ -125,20 +72,7 @@ mb_incoherent(void)
 #define mb()		fast_mb()
 #define iob()		fast_iob()
 
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#endif
-
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_TILE_BARRIER_H */
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
index a6620e5..83d6a52 100644
--- a/arch/unicore32/include/asm/barrier.h
+++ b/arch/unicore32/include/asm/barrier.h
@@ -14,15 +14,6 @@
 #define dsb() __asm__ __volatile__ ("" : : : "memory")
 #define dmb() __asm__ __volatile__ ("" : : : "memory")
 
-#define mb()				barrier()
-#define rmb()				barrier()
-#define wmb()				barrier()
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define read_barrier_depends()		do { } while (0)
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define set_mb(var, value)		do { var = value; smp_mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* __UNICORE_BARRIER_H__ */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index c6cd358..04a4890 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -92,12 +92,53 @@
 #endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-#else
+#else /* !SMP */
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
+#endif /* SMP */
+
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+
+/*
+ * For either of these options x86 doesn't have a strong TSO memory
+ * model and we should fall back to full barriers.
+ */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
+#else /* regular x86 TSO memory ordering */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif
 
 /*
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
index ef02167..e1ee6b5 100644
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -9,21 +9,14 @@
 #ifndef _XTENSA_SYSTEM_H
 #define _XTENSA_SYSTEM_H
 
-#define smp_read_barrier_depends() do { } while(0)
-#define read_barrier_depends() do { } while(0)
-
 #define mb()  ({ __asm__ __volatile__("memw" : : : "memory"); })
 #define rmb() barrier()
 #define wmb() mb()
 
 #ifdef CONFIG_SMP
 #error smp_* not defined
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
 #endif
 
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* _XTENSA_SYSTEM_H */
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 639d7a4..6f692f8 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -1,4 +1,5 @@
-/* Generic barrier definitions, based on MN10300 definitions.
+/*
+ * Generic barrier definitions, originally based on MN10300 definitions.
  *
  * It should be possible to use these on really simple architectures,
  * but it serves more as a starting point for new ports.
@@ -16,35 +17,65 @@
 
 #ifndef __ASSEMBLY__
 
-#define nop() asm volatile ("nop")
+#include <linux/compiler.h>
+
+#ifndef nop
+#define nop()	asm volatile ("nop")
+#endif
 
 /*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
+ * Force strict CPU ordering. And yes, this is required on UP too when we're
+ * talking to devices.
  *
- * This implementation only contains a compiler barrier.
+ * Fall back to compiler barriers if nothing better is provided.
  */
 
-#define mb()	asm volatile ("": : :"memory")
+#ifndef mb
+#define mb()	barrier()
+#endif
+
+#ifndef rmb
 #define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
+#endif
+
+#ifndef wmb
+#define wmb()	mb()
+#endif
+
+#ifndef read_barrier_depends
+#define read_barrier_depends()		do { } while (0)
+#endif
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#endif
+
+#ifndef set_mb
+#define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
 #endif
 
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
 
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
 
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 92669cd..fe7a686 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -298,6 +298,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Is this type a native word size -- useful for atomic operations */
+#ifndef __native_word
+# define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
+#endif
+
 /* Compile time object size, -1 for unknown */
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
@@ -337,6 +342,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define compiletime_assert(condition, msg) \
 	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
 
+#define compiletime_assert_atomic_type(t)				\
+	compiletime_assert(__native_word(t),				\
+		"Need native word sized stores/loads for atomicity.")
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 75f3494..3f2867f 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -130,6 +130,16 @@ do {								\
 #define smp_mb__before_spinlock()	smp_wmb()
 #endif
 
+/*
+ * Place this after a lock-acquisition primitive to guarantee that
+ * an UNLOCK+LOCK pair act as a full barrier.  This guarantee applies
+ * if the UNLOCK and LOCK are executed by the same CPU or if the
+ * UNLOCK and LOCK operate on the same lock variable.
+ */
+#ifndef smp_mb__after_unlock_lock
+#define smp_mb__after_unlock_lock()	do { } while (0)
+#endif
+
 /**
  * raw_spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/kernel/futex.c b/kernel/futex.c
index f6ff019..1ddc449 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -63,14 +63,101 @@
 #include <linux/sched/rt.h>
 #include <linux/hugetlb.h>
 #include <linux/freezer.h>
+#include <linux/bootmem.h>
 
 #include <asm/futex.h>
 
 #include "locking/rtmutex_common.h"
 
-int __read_mostly futex_cmpxchg_enabled;
+/*
+ * Basic futex operation and ordering guarantees:
+ *
+ * The waiter reads the futex value in user space and calls
+ * futex_wait(). This function computes the hash bucket and acquires
+ * the hash bucket lock. After that it reads the futex user space value
+ * again and verifies that the data has not changed. If it has not changed
+ * it enqueues itself into the hash bucket, releases the hash bucket lock
+ * and schedules.
+ *
+ * The waker side modifies the user space value of the futex and calls
+ * futex_wake(). This function computes the hash bucket and acquires the
+ * hash bucket lock. Then it looks for waiters on that futex in the hash
+ * bucket and wakes them.
+ *
+ * In futex wake up scenarios where no tasks are blocked on a futex, taking
+ * the hb spinlock can be avoided and simply return. In order for this
+ * optimization to work, ordering guarantees must exist so that the waiter
+ * being added to the list is acknowledged when the list is concurrently being
+ * checked by the waker, avoiding scenarios like the following:
+ *
+ * CPU 0                               CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *   uval = *futex;
+ *                                     *futex = newval;
+ *                                     sys_futex(WAKE, futex);
+ *                                       futex_wake(futex);
+ *                                       if (queue_empty())
+ *                                         return;
+ *   if (uval == val)
+ *      lock(hash_bucket(futex));
+ *      queue();
+ *     unlock(hash_bucket(futex));
+ *     schedule();
+ *
+ * This would cause the waiter on CPU 0 to wait forever because it
+ * missed the transition of the user space value from val to newval
+ * and the waker did not find the waiter in the hash bucket queue.
+ *
+ * The correct serialization ensures that a waiter either observes
+ * the changed user space value before blocking or is woken by a
+ * concurrent waker:
+ *
+ * CPU 0                                 CPU 1
+ * val = *futex;
+ * sys_futex(WAIT, futex, val);
+ *   futex_wait(futex, val);
+ *
+ *   waiters++;
+ *   mb(); (A) <-- paired with -.
+ *                              |
+ *   lock(hash_bucket(futex));  |
+ *                              |
+ *   uval = *futex;             |
+ *                              |        *futex = newval;
+ *                              |        sys_futex(WAKE, futex);
+ *                              |          futex_wake(futex);
+ *                              |
+ *                              `------->  mb(); (B)
+ *   if (uval == val)
+ *     queue();
+ *     unlock(hash_bucket(futex));
+ *     schedule();                         if (waiters)
+ *                                           lock(hash_bucket(futex));
+ *                                           wake_waiters(futex);
+ *                                           unlock(hash_bucket(futex));
+ *
+ * Where (A) orders the waiters increment and the futex value read -- this
+ * is guaranteed by the head counter in the hb spinlock; and where (B)
+ * orders the write to futex and the waiters read -- this is done by the
+ * barriers in get_futex_key_refs(), through either ihold or atomic_inc,
+ * depending on the futex type.
+ *
+ * This yields the following case (where X:=waiters, Y:=futex):
+ *
+ *	X = Y = 0
+ *
+ *	w[X]=1		w[Y]=1
+ *	MB		MB
+ *	r[Y]=y		r[X]=x
+ *
+ * Which guarantees that x==0 && y==0 is impossible; which translates back into
+ * the guarantee that we cannot both miss the futex variable change and the
+ * enqueue.
+ */
 
-#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
+int __read_mostly futex_cmpxchg_enabled;
 
 /*
  * Futex flags used to encode options to functions and preserve them across
@@ -149,9 +236,41 @@ static const struct futex_q futex_q_init = {
 struct futex_hash_bucket {
 	spinlock_t lock;
 	struct plist_head chain;
-};
+} ____cacheline_aligned_in_smp;
 
-static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
+static unsigned long __read_mostly futex_hashsize;
+
+static struct futex_hash_bucket *futex_queues;
+
+static inline void futex_get_mm(union futex_key *key)
+{
+	atomic_inc(&key->private.mm->mm_count);
+	/*
+	 * Ensure futex_get_mm() implies a full barrier such that
+	 * get_futex_key() implies a full barrier. This is relied upon
+	 * as full barrier (B), see the ordering comment above.
+	 */
+	smp_mb__after_atomic_inc();
+}
+
+static inline bool hb_waiters_pending(struct futex_hash_bucket *hb)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * Tasks trying to enter the critical region are most likely
+	 * potential waiters that will be added to the plist. Ensure
+	 * that wakers won't miss to-be-slept tasks in the window between
+	 * the wait call and the actual plist_add.
+	 */
+	if (spin_is_locked(&hb->lock))
+		return true;
+	smp_rmb(); /* Make sure we check the lock state first */
+
+	return !plist_head_empty(&hb->chain);
+#else
+	return true;
+#endif
+}
 
 /*
  * We hash on the keys returned from get_futex_key (see below).
@@ -161,7 +280,7 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
 	u32 hash = jhash2((u32*)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+	return &futex_queues[hash & (futex_hashsize - 1)];
 }
 
 /*
@@ -187,10 +306,10 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode);
+		ihold(key->shared.inode); /* implies MB (B) */
 		break;
 	case FUT_OFF_MMSHARED:
-		atomic_inc(&key->private.mm->mm_count);
+		futex_get_mm(key); /* implies MB (B) */
 		break;
 	}
 }
@@ -264,7 +383,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	if (!fshared) {
 		key->private.mm = mm;
 		key->private.address = address;
-		get_futex_key_refs(key);
+		get_futex_key_refs(key);  /* implies MB (B) */
 		return 0;
 	}
 
@@ -371,7 +490,7 @@ again:
 		key->shared.pgoff = basepage_index(page);
 	}
 
-	get_futex_key_refs(key);
+	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
 	unlock_page(page_head);
@@ -598,13 +717,10 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	struct task_struct *p;
 	pid_t pid = uval & FUTEX_TID_MASK;
 
-	head = &hb->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex(&this->key, key)) {
 			/*
 			 * Another waiter already exists - bump up
@@ -986,7 +1102,6 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
 
@@ -998,10 +1113,14 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
+
+	/* Make sure we really have tasks to wakeup */
+	if (!hb_waiters_pending(hb))
+		goto out_put_key;
+
 	spin_lock(&hb->lock);
-	head = &hb->chain;
 
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex (&this->key, &key)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1019,6 +1138,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
+out_put_key:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1034,7 +1154,6 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret;
 
@@ -1082,9 +1201,7 @@ retry_private:
 		goto retry;
 	}
 
-	head = &hb1->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (match_futex (&this->key, &key1)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1097,10 +1214,8 @@ retry_private:
 	}
 
 	if (op_ret > 0) {
-		head = &hb2->chain;
-
 		op_ret = 0;
-		plist_for_each_entry_safe(this, next, head, list) {
+		plist_for_each_entry_safe(this, next, &hb2->chain, list) {
 			if (match_futex (&this->key, &key2)) {
 				if (this->pi_state || this->rt_waiter) {
 					ret = -EINVAL;
@@ -1270,7 +1385,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	int drop_count = 0, task_count = 0, ret;
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head1;
 	struct futex_q *this, *next;
 	u32 curval2;
 
@@ -1393,8 +1507,7 @@ retry_private:
 		}
 	}
 
-	head1 = &hb1->chain;
-	plist_for_each_entry_safe(this, next, head1, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (task_count - nr_wake >= nr_requeue)
 			break;
 
@@ -1489,12 +1602,12 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
-	spin_lock(&hb->lock);
+	spin_lock(&hb->lock); /* implies MB (A) */
 	return hb;
 }
 
 static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
@@ -1867,7 +1980,7 @@ retry_private:
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (ret) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -1881,7 +1994,7 @@ retry_private:
 	}
 
 	if (uval != val) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 		ret = -EWOULDBLOCK;
 	}
 
@@ -2029,7 +2142,7 @@ retry_private:
 			 * Task is exiting and we just wait for the
 			 * exit to complete.
 			 */
-			queue_unlock(&q, hb);
+			queue_unlock(hb);
 			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
@@ -2081,7 +2194,7 @@ retry_private:
 	goto out_put_key;
 
 out_unlock_put_key:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 out_put_key:
 	put_futex_key(&q.key);
@@ -2091,7 +2204,7 @@ out:
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (ret)
@@ -2113,7 +2226,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	u32 uval, vpid = task_pid_vnr(current);
 	int ret;
@@ -2153,9 +2265,7 @@ retry:
 	 * Ok, other tasks may need to be woken up - check waiters
 	 * and do the wakeup if necessary:
 	 */
-	head = &hb->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (!match_futex (&this->key, &key))
 			continue;
 		ret = wake_futex_pi(uaddr, uval, this);
@@ -2734,8 +2844,21 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 static int __init futex_init(void)
 {
 	u32 curval;
-	int i;
+	unsigned int futex_shift;
+	unsigned long i;
+
+#if CONFIG_BASE_SMALL
+	futex_hashsize = 16;
+#else
+	futex_hashsize = roundup_pow_of_two(256 * num_possible_cpus());
+#endif
 
+	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
+					       futex_hashsize, 0,
+					       futex_hashsize < 256 ? HASH_SMALL : 0,
+					       &futex_shift, NULL,
+					       futex_hashsize, futex_hashsize);
+	futex_hashsize = 1UL << futex_shift;
 	/*
 	 * This will fail and we want it. Some arch implementations do
 	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
@@ -2749,7 +2872,7 @@ static int __init futex_init(void)
 	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 576ba75..eb8a547 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -590,6 +590,7 @@ static int very_verbose(struct lock_class *class)
 /*
  * Is this the address of a static object:
  */
+#ifdef __KERNEL__
 static int static_obj(void *obj)
 {
 	unsigned long start = (unsigned long) &_stext,
@@ -616,6 +617,7 @@ static int static_obj(void *obj)
 	 */
 	return is_module_address(addr) || is_module_percpu_address(addr);
 }
+#endif
 
 /*
  * To make lock name printouts unique, we calculate a unique
@@ -4115,6 +4117,7 @@ void debug_check_no_locks_held(void)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
+#ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
 	struct task_struct *g, *p;
@@ -4172,6 +4175,7 @@ retry:
 		read_unlock(&tasklist_lock);
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
+#endif
 
 /*
  * Careful: only use this function if you are sure that
diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 7e3443f..faf6f5b 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -75,7 +75,12 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
+	if (!lock->owner)
+		DEBUG_LOCKS_WARN_ON(!lock->owner);
+	else
+		DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dd08198..a6205a0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1133,8 +1133,10 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	 * hold it, acquire the root rcu_node structure's lock in order to
 	 * start one (if needed).
 	 */
-	if (rnp != rnp_root)
+	if (rnp != rnp_root) {
 		raw_spin_lock(&rnp_root->lock);
+		smp_mb__after_unlock_lock();
+	}
 
 	/*
 	 * Get a new grace-period number.  If there really is no grace
@@ -1354,6 +1356,7 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 		local_irq_restore(flags);
 		return;
 	}
+	smp_mb__after_unlock_lock();
 	__note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
@@ -1368,6 +1371,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	if (rsp->gp_flags == 0) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
@@ -1409,6 +1413,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -1463,6 +1468,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
@@ -1480,6 +1486,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1505,6 +1512,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
+		smp_mb__after_unlock_lock();
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
@@ -1515,6 +1523,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
+	smp_mb__after_unlock_lock();
 	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
@@ -1749,6 +1758,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 		rnp_c = rnp;
 		rnp = rnp->parent;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
@@ -1778,6 +1788,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
 	    rnp->completed == rnp->gpnum) {
 
@@ -1992,6 +2003,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		smp_mb__after_unlock_lock();
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
@@ -2202,6 +2214,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		cond_resched();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -2231,6 +2244,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	rnp = rcu_get_root(rsp);
 	if (rnp->qsmask == 0) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 	}
 }
@@ -2263,6 +2277,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 
 	/* Reached the root of the rcu_node tree, acquire lock. */
 	raw_spin_lock_irqsave(&rnp_old->lock, flags);
+	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		rsp->n_force_qs_lh++;
@@ -2378,6 +2393,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			struct rcu_node *rnp_root = rcu_get_root(rsp);
 
 			raw_spin_lock(&rnp_root->lock);
+			smp_mb__after_unlock_lock();
 			rcu_start_gp(rsp);
 			raw_spin_unlock(&rnp_root->lock);
 		} else {
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 08a7652..506a7a9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -204,6 +204,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -312,6 +313,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	mask = rnp->grpmask;
 	raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	raw_spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	smp_mb__after_unlock_lock();
 	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
@@ -381,6 +383,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		for (;;) {
 			rnp = t->rcu_blocked_node;
 			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
+			smp_mb__after_unlock_lock();
 			if (rnp == t->rcu_blocked_node)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
@@ -605,6 +608,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	while (!list_empty(lp)) {
 		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
 		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+		smp_mb__after_unlock_lock();
 		list_del(&t->rcu_node_entry);
 		t->rcu_blocked_node = rnp_root;
 		list_add(&t->rcu_node_entry, lp_root);
@@ -629,6 +633,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * in this case.
 	 */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+	smp_mb__after_unlock_lock();
 	if (rnp_root->boost_tasks != NULL &&
 	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
 	    rnp_root->boost_tasks != rnp_root->exp_tasks)
@@ -772,6 +777,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 	unsigned long mask;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -787,6 +793,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 		rnp = rnp->parent;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
+		smp_mb__after_unlock_lock();
 		rnp->expmask &= ~mask;
 	}
 }
@@ -806,6 +813,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 	int must_wait = 0;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	if (list_empty(&rnp->blkd_tasks)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
@@ -886,6 +894,7 @@ void synchronize_rcu_expedited(void)
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
+		smp_mb__after_unlock_lock();
 		rnp->expmask = rnp->qsmaskinit;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
@@ -1191,6 +1200,7 @@ static int rcu_boost(struct rcu_node *rnp)
 		return 0;  /* Nothing left to boost. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 
 	/*
 	 * Recheck under the lock: all tasks in need of boosting
@@ -1377,6 +1387,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_BOOST_PRIO;
@@ -1769,6 +1780,7 @@ static void rcu_prepare_for_idle(int cpu)
 			continue;
 		rnp = rdp->mynode;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		smp_mb__after_unlock_lock();
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
@@ -2209,6 +2221,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	struct rcu_node *rnp = rdp->mynode;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	smp_mb__after_unlock_lock();
 	c = rcu_start_future_gp(rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..9a4500e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -211,14 +211,48 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 #define MAX_SOFTIRQ_RESTART 10
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/*
+ * When we run softirqs from irq_exit() and thus on the hardirq stack we need
+ * to keep the lockdep irq context tracking as tight as possible in order to
+ * not miss-qualify lock contexts and miss possible deadlocks.
+ */
+
+static inline bool lockdep_softirq_start(void)
+{
+	bool in_hardirq = false;
+
+	if (trace_hardirq_context(current)) {
+		in_hardirq = true;
+		trace_hardirq_exit();
+	}
+
+	lockdep_softirq_enter();
+
+	return in_hardirq;
+}
+
+static inline void lockdep_softirq_end(bool in_hardirq)
+{
+	lockdep_softirq_exit();
+
+	if (in_hardirq)
+		trace_hardirq_enter();
+}
+#else
+static inline bool lockdep_softirq_start(void) { return false; }
+static inline void lockdep_softirq_end(bool in_hardirq) { }
+#endif
+
 asmlinkage void __do_softirq(void)
 {
-	struct softirq_action *h;
-	__u32 pending;
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
-	int cpu;
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
+	struct softirq_action *h;
+	bool in_hardirq;
+	__u32 pending;
+	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -231,7 +265,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	in_hardirq = lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -278,16 +312,13 @@ restart:
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_exit();
-
+	lockdep_softirq_end(in_hardirq);
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	WARN_ON_ONCE(in_interrupt());
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-
-
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
@@ -375,13 +406,13 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	preempt_count_sub(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 }
 
 /*
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
new file mode 100644
index 0000000..da8b7aa
--- /dev/null
+++ b/tools/lib/lockdep/Makefile
@@ -0,0 +1,251 @@
+# liblockdep version
+LL_VERSION = 0
+LL_PATCHLEVEL = 0
+LL_EXTRAVERSION = 1
+
+# file format version
+FILE_VERSION = 1
+
+MAKEFLAGS += --no-print-directory
+
+
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
+INSTALL = install
+
+# Use DESTDIR for installing into a different root directory.
+# This is useful for building a package. The program will be
+# installed in this directory as if it was the root directory.
+# Then the build tool can move it later.
+DESTDIR ?=
+DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
+
+prefix ?= /usr/local
+libdir_relative = lib
+libdir = $(prefix)/$(libdir_relative)
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+
+export DESTDIR DESTDIR_SQ INSTALL
+
+# copy a bit from Linux kbuild
+
+ifeq ("$(origin V)", "command line")
+  VERBOSE = $(V)
+endif
+ifndef VERBOSE
+  VERBOSE = 0
+endif
+
+ifeq ("$(origin O)", "command line")
+  BUILD_OUTPUT := $(O)
+endif
+
+ifeq ($(BUILD_SRC),)
+ifneq ($(BUILD_OUTPUT),)
+
+define build_output
+	$(if $(VERBOSE:1=),@)$(MAKE) -C $(BUILD_OUTPUT)	\
+	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
+endef
+
+saved-output := $(BUILD_OUTPUT)
+BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
+$(if $(BUILD_OUTPUT),, \
+     $(error output directory "$(saved-output)" does not exist))
+
+all: sub-make
+
+gui: force
+	$(call build_output, all_cmd)
+
+$(filter-out gui,$(MAKECMDGOALS)): sub-make
+
+sub-make: force
+	$(call build_output, $(MAKECMDGOALS))
+
+
+# Leave processing to above invocation of make
+skip-makefile := 1
+
+endif # BUILD_OUTPUT
+endif # BUILD_SRC
+
+# We process the rest of the Makefile if this is the final invocation of make
+ifeq ($(skip-makefile),)
+
+srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
+objtree		:= $(CURDIR)
+src		:= $(srctree)
+obj		:= $(objtree)
+
+export prefix libdir bindir src obj
+
+# Shell quotes
+libdir_SQ = $(subst ','\'',$(libdir))
+bindir_SQ = $(subst ','\'',$(bindir))
+
+LIB_FILE = liblockdep.a liblockdep.so
+BIN_FILE = lockdep
+
+CONFIG_INCLUDES =
+CONFIG_LIBS	=
+CONFIG_FLAGS	=
+
+OBJ		= $@
+N		=
+
+export Q VERBOSE
+
+LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
+
+INCLUDES = -I. -I/usr/local/include -I./uinclude $(CONFIG_INCLUDES)
+
+# Set compile option CFLAGS if not set elsewhere
+CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
+
+override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
+
+ifeq ($(VERBOSE),1)
+  Q =
+  print_compile =
+  print_app_build =
+  print_fpic_compile =
+  print_shared_lib_compile =
+  print_install =
+else
+  Q = @
+  print_compile =		echo '  CC                 '$(OBJ);
+  print_app_build =		echo '  BUILD              '$(OBJ);
+  print_fpic_compile =		echo '  CC FPIC            '$(OBJ);
+  print_shared_lib_compile =	echo '  BUILD SHARED LIB   '$(OBJ);
+  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(OBJ);
+  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+endif
+
+do_fpic_compile =					\
+	($(print_fpic_compile)				\
+	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
+
+do_app_build =						\
+	($(print_app_build)				\
+	$(CC) $^ -rdynamic -o $@ $(CONFIG_LIBS) $(LIBS))
+
+do_compile_shared_library =			\
+	($(print_shared_lib_compile)		\
+	$(CC) --shared $^ -o $@ -lpthread -ldl)
+
+do_build_static_lib =				\
+	($(print_static_lib_build)		\
+	$(RM) $@;  $(AR) rcs $@ $^)
+
+
+define do_compile
+	$(print_compile)						\
+	$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
+endef
+
+$(obj)/%.o: $(src)/%.c
+	$(Q)$(call do_compile)
+
+%.o: $(src)/%.c
+	$(Q)$(call do_compile)
+
+PEVENT_LIB_OBJS = common.o lockdep.o preload.o rbtree.o
+
+ALL_OBJS = $(PEVENT_LIB_OBJS)
+
+CMD_TARGETS = $(LIB_FILE)
+
+TARGETS = $(CMD_TARGETS)
+
+
+all: all_cmd
+
+all_cmd: $(CMD_TARGETS)
+
+liblockdep.so: $(PEVENT_LIB_OBJS)
+	$(Q)$(do_compile_shared_library)
+
+liblockdep.a: $(PEVENT_LIB_OBJS)
+	$(Q)$(do_build_static_lib)
+
+$(PEVENT_LIB_OBJS): %.o: $(src)/%.c
+	$(Q)$(do_fpic_compile)
+
+## make deps
+
+all_objs := $(sort $(ALL_OBJS))
+all_deps := $(all_objs:%.o=.%.d)
+
+# let .d file also depends on the source and header files
+define check_deps
+		@set -e; $(RM) $@; \
+		$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
+		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
+		$(RM) $@.$$$$
+endef
+
+$(all_deps): .%.d: $(src)/%.c
+	$(Q)$(call check_deps)
+
+$(all_objs) : %.o : .%.d
+
+dep_includes := $(wildcard $(all_deps))
+
+ifneq ($(dep_includes),)
+ include $(dep_includes)
+endif
+
+### Detect environment changes
+TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
+
+tags:	force
+	$(RM) tags
+	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
+
+TAGS:	force
+	$(RM) TAGS
+	find . -name '*.[ch]' | xargs etags \
+	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
+
+define do_install
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+endef
+
+install_lib: all_cmd
+	$(Q)$(call do_install,$(LIB_FILE),$(libdir_SQ))
+	$(Q)$(call do_install,$(BIN_FILE),$(bindir_SQ))
+
+install: install_lib
+
+clean:
+	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
+	$(RM) tags TAGS
+
+endif # skip-makefile
+
+PHONY += force
+force:
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# information in a variable so we can use it in if_changed and friends.
+.PHONY: $(PHONY)
diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
new file mode 100644
index 0000000..8ef602f
--- /dev/null
+++ b/tools/lib/lockdep/common.c
@@ -0,0 +1,33 @@
+#include <stddef.h>
+#include <stdbool.h>
+#include <linux/compiler.h>
+#include <linux/lockdep.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+static __thread struct task_struct current_obj;
+
+/* lockdep wants these */
+bool debug_locks = true;
+bool debug_locks_silent;
+
+__attribute__((constructor)) static void liblockdep_init(void)
+{
+	lockdep_init();
+}
+
+__attribute__((destructor)) static void liblockdep_exit(void)
+{
+	debug_check_no_locks_held(&current_obj);
+}
+
+struct task_struct *__curr(void)
+{
+	if (current_obj.pid == 0) {
+		/* Makes lockdep output pretty */
+		prctl(PR_GET_NAME, current_obj.comm);
+		current_obj.pid = syscall(__NR_gettid);
+	}
+
+	return &current_obj;
+}
diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
new file mode 100644
index 0000000..0bda630
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -0,0 +1,50 @@
+#ifndef _LIBLOCKDEP_COMMON_H
+#define _LIBLOCKDEP_COMMON_H
+
+#include <pthread.h>
+
+#define NR_LOCKDEP_CACHING_CLASSES 2
+#define MAX_LOCKDEP_SUBCLASSES 8UL
+
+#ifndef CALLER_ADDR0
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#endif
+
+#ifndef _RET_IP_
+#define _RET_IP_ CALLER_ADDR0
+#endif
+
+#ifndef _THIS_IP_
+#define _THIS_IP_ ({ __label__ __here; __here: (unsigned long)&&__here; })
+#endif
+
+struct lockdep_subclass_key {
+	char __one_byte;
+};
+
+struct lock_class_key {
+	struct lockdep_subclass_key subkeys[MAX_LOCKDEP_SUBCLASSES];
+};
+
+struct lockdep_map {
+	struct lock_class_key	*key;
+	struct lock_class	*class_cache[NR_LOCKDEP_CACHING_CLASSES];
+	const char		*name;
+#ifdef CONFIG_LOCK_STAT
+	int			cpu;
+	unsigned long		ip;
+#endif
+};
+
+void lockdep_init_map(struct lockdep_map *lock, const char *name,
+			struct lock_class_key *key, int subclass);
+void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+			int trylock, int read, int check,
+			struct lockdep_map *nest_lock, unsigned long ip);
+void lock_release(struct lockdep_map *lock, int nested,
+			unsigned long ip);
+
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+#endif
diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
new file mode 100644
index 0000000..c342f70
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/mutex.h
@@ -0,0 +1,70 @@
+#ifndef _LIBLOCKDEP_MUTEX_H
+#define _LIBLOCKDEP_MUTEX_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblockdep_pthread_mutex {
+	pthread_mutex_t mutex;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblockdep_pthread_mutex liblockdep_pthread_mutex_t;
+
+#define LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(mtx)			\
+		(const struct liblockdep_pthread_mutex) {		\
+	.mutex = PTHREAD_MUTEX_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#mtx, &((&(mtx))->dep_map)),	\
+}
+
+static inline int __mutex_init(liblockdep_pthread_mutex_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_mutexattr_t *__mutexattr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+	return pthread_mutex_init(&lock->mutex, __mutexattr);
+}
+
+#define liblockdep_pthread_mutex_init(mutex, mutexattr)		\
+({								\
+	static struct lock_class_key __key;			\
+								\
+	__mutex_init((mutex), #mutex, &__key, (mutexattr));	\
+})
+
+static inline int liblockdep_pthread_mutex_lock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_mutex_lock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
+	return pthread_mutex_unlock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
+{
+	return pthread_mutex_destroy(&lock->mutex);
+}
+
+#ifdef __USE_LIBLOCKDEP
+
+#define pthread_mutex_t         liblockdep_pthread_mutex_t
+#define pthread_mutex_init      liblockdep_pthread_mutex_init
+#define pthread_mutex_lock      liblockdep_pthread_mutex_lock
+#define pthread_mutex_unlock    liblockdep_pthread_mutex_unlock
+#define pthread_mutex_trylock   liblockdep_pthread_mutex_trylock
+#define pthread_mutex_destroy   liblockdep_pthread_mutex_destroy
+
+#endif
+
+#endif
diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
new file mode 100644
index 0000000..a680ab8
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
@@ -0,0 +1,86 @@
+#ifndef _LIBLOCKDEP_RWLOCK_H
+#define _LIBLOCKDEP_RWLOCK_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblockdep_pthread_rwlock {
+	pthread_rwlock_t rwlock;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblockdep_pthread_rwlock liblockdep_pthread_rwlock_t;
+
+#define LIBLOCKDEP_PTHREAD_RWLOCK_INITIALIZER(rwl)			\
+		(struct liblockdep_pthread_rwlock) {			\
+	.rwlock = PTHREAD_RWLOCK_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#rwl, &((&(rwl))->dep_map)),	\
+}
+
+static inline int __rwlock_init(liblockdep_pthread_rwlock_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_rwlockattr_t *attr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+
+	return pthread_rwlock_init(&lock->rwlock, attr);
+}
+
+#define liblockdep_pthread_rwlock_init(lock, attr)		\
+({							\
+	static struct lock_class_key __key;		\
+							\
+	__rwlock_init((lock), #lock, &__key, (attr));	\
+})
+
+static inline int liblockdep_pthread_rwlock_rdlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 2, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_rdlock(&lock->rwlock);
+
+}
+
+static inline int liblockdep_pthread_rwlock_unlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
+	return pthread_rwlock_unlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_wrlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_wrlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_tryrdlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 2, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_tryrdlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_rwlock_trywlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_trywlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_rwlock_destroy(liblockdep_pthread_rwlock_t *lock)
+{
+	return pthread_rwlock_destroy(&lock->rwlock);
+}
+
+#ifdef __USE_LIBLOCKDEP
+
+#define pthread_rwlock_t		liblockdep_pthread_rwlock_t
+#define pthread_rwlock_init		liblockdep_pthread_rwlock_init
+#define pthread_rwlock_rdlock		liblockdep_pthread_rwlock_rdlock
+#define pthread_rwlock_unlock		liblockdep_pthread_rwlock_unlock
+#define pthread_rwlock_wrlock		liblockdep_pthread_rwlock_wrlock
+#define pthread_rwlock_tryrdlock	liblockdep_pthread_rwlock_tryrdlock
+#define pthread_rwlock_trywlock		liblockdep_pthread_rwlock_trywlock
+#define pthread_rwlock_destroy		liblockdep_rwlock_destroy
+
+#endif
+
+#endif
diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
new file mode 100755
index 0000000..49af9fe
--- /dev/null
+++ b/tools/lib/lockdep/lockdep
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+LD_PRELOAD="./liblockdep.so $LD_PRELOAD" "$@"
diff --git a/tools/lib/lockdep/lockdep.c b/tools/lib/lockdep/lockdep.c
new file mode 100644
index 0000000..f42b7e9
--- /dev/null
+++ b/tools/lib/lockdep/lockdep.c
@@ -0,0 +1,2 @@
+#include <linux/lockdep.h>
+#include "../../../kernel/locking/lockdep.c"
diff --git a/tools/lib/lockdep/lockdep_internals.h b/tools/lib/lockdep/lockdep_internals.h
new file mode 100644
index 0000000..29d0c95
--- /dev/null
+++ b/tools/lib/lockdep/lockdep_internals.h
@@ -0,0 +1 @@
+#include "../../../kernel/locking/lockdep_internals.h"
diff --git a/tools/lib/lockdep/lockdep_states.h b/tools/lib/lockdep/lockdep_states.h
new file mode 100644
index 0000000..248d235
--- /dev/null
+++ b/tools/lib/lockdep/lockdep_states.h
@@ -0,0 +1 @@
+#include "../../../kernel/locking/lockdep_states.h"
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
new file mode 100644
index 0000000..f8465a8
--- /dev/null
+++ b/tools/lib/lockdep/preload.c
@@ -0,0 +1,447 @@
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <stdio.h>
+#include <dlfcn.h>
+#include <stdlib.h>
+#include <sysexits.h>
+#include "include/liblockdep/mutex.h"
+#include "../../../include/linux/rbtree.h"
+
+/**
+ * struct lock_lookup - liblockdep's view of a single unique lock
+ * @orig: pointer to the original pthread lock, used for lookups
+ * @dep_map: lockdep's dep_map structure
+ * @key: lockdep's key structure
+ * @node: rb-tree node used to store the lock in a global tree
+ * @name: a unique name for the lock
+ */
+struct lock_lookup {
+	void *orig; /* Original pthread lock, used for lookups */
+	struct lockdep_map dep_map; /* Since all locks are dynamic, we need
+				     * a dep_map and a key for each lock */
+	/*
+	 * Wait, there's no support for key classes? Yup :(
+	 * Most big projects wrap the pthread api with their own calls to
+	 * be compatible with different locking methods. This means that
+	 * "classes" will be brokes since the function that creates all
+	 * locks will point to a generic locking function instead of the
+	 * actual code that wants to do the locking.
+	 */
+	struct lock_class_key key;
+	struct rb_node node;
+#define LIBLOCKDEP_MAX_LOCK_NAME 22
+	char name[LIBLOCKDEP_MAX_LOCK_NAME];
+};
+
+/* This is where we store our locks */
+static struct rb_root locks = RB_ROOT;
+static pthread_rwlock_t locks_rwlock = PTHREAD_RWLOCK_INITIALIZER;
+
+/* pthread mutex API */
+
+#ifdef __GLIBC__
+extern int __pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
+extern int __pthread_mutex_lock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_trylock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_unlock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_destroy(pthread_mutex_t *mutex);
+#else
+#define __pthread_mutex_init	NULL
+#define __pthread_mutex_lock	NULL
+#define __pthread_mutex_trylock	NULL
+#define __pthread_mutex_unlock	NULL
+#define __pthread_mutex_destroy	NULL
+#endif
+static int (*ll_pthread_mutex_init)(pthread_mutex_t *mutex,
+			const pthread_mutexattr_t *attr)	= __pthread_mutex_init;
+static int (*ll_pthread_mutex_lock)(pthread_mutex_t *mutex)	= __pthread_mutex_lock;
+static int (*ll_pthread_mutex_trylock)(pthread_mutex_t *mutex)	= __pthread_mutex_trylock;
+static int (*ll_pthread_mutex_unlock)(pthread_mutex_t *mutex)	= __pthread_mutex_unlock;
+static int (*ll_pthread_mutex_destroy)(pthread_mutex_t *mutex)	= __pthread_mutex_destroy;
+
+/* pthread rwlock API */
+
+#ifdef __GLIBC__
+extern int __pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
+extern int __pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
+#else
+#define __pthread_rwlock_init		NULL
+#define __pthread_rwlock_destroy	NULL
+#define __pthread_rwlock_wrlock		NULL
+#define __pthread_rwlock_trywrlock	NULL
+#define __pthread_rwlock_rdlock		NULL
+#define __pthread_rwlock_tryrdlock	NULL
+#define __pthread_rwlock_unlock		NULL
+#endif
+
+static int (*ll_pthread_rwlock_init)(pthread_rwlock_t *rwlock,
+			const pthread_rwlockattr_t *attr)		= __pthread_rwlock_init;
+static int (*ll_pthread_rwlock_destroy)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_destroy;
+static int (*ll_pthread_rwlock_rdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_rdlock;
+static int (*ll_pthread_rwlock_tryrdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_tryrdlock;
+static int (*ll_pthread_rwlock_trywrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_trywrlock;
+static int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_wrlock;
+static int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_unlock;
+
+enum { none, prepare, done, } __init_state;
+static void init_preload(void);
+static void try_init_preload(void)
+{
+	if (!__init_state != done)
+		init_preload();
+}
+
+static struct rb_node **__get_lock_node(void *lock, struct rb_node **parent)
+{
+	struct rb_node **node = &locks.rb_node;
+	struct lock_lookup *l;
+
+	*parent = NULL;
+
+	while (*node) {
+		l = rb_entry(*node, struct lock_lookup, node);
+
+		*parent = *node;
+		if (lock < l->orig)
+			node = &l->node.rb_left;
+		else if (lock > l->orig)
+			node = &l->node.rb_right;
+		else
+			return node;
+	}
+
+	return node;
+}
+
+#ifndef LIBLOCKDEP_STATIC_ENTRIES
+#define LIBLOCKDEP_STATIC_ENTRIES	1024
+#endif
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+static struct lock_lookup __locks[LIBLOCKDEP_STATIC_ENTRIES];
+static int __locks_nr;
+
+static inline bool is_static_lock(struct lock_lookup *lock)
+{
+	return lock >= __locks && lock < __locks + ARRAY_SIZE(__locks);
+}
+
+static struct lock_lookup *alloc_lock(void)
+{
+	if (__init_state != done) {
+		/*
+		 * Some programs attempt to initialize and use locks in their
+		 * allocation path. This means that a call to malloc() would
+		 * result in locks being initialized and locked.
+		 *
+		 * Why is it an issue for us? dlsym() below will try allocating
+		 * to give us the original function. Since this allocation will
+		 * result in a locking operations, we have to let pthread deal
+		 * with it, but we can't! we don't have the pointer to the
+		 * original API since we're inside dlsym() trying to get it
+		 */
+
+		int idx = __locks_nr++;
+		if (idx >= ARRAY_SIZE(__locks)) {
+			fprintf(stderr,
+		"LOCKDEP error: insufficient LIBLOCKDEP_STATIC_ENTRIES\n");
+			exit(EX_UNAVAILABLE);
+		}
+		return __locks + idx;
+	}
+
+	return malloc(sizeof(struct lock_lookup));
+}
+
+static inline void free_lock(struct lock_lookup *lock)
+{
+	if (likely(!is_static_lock(lock)))
+		free(lock);
+}
+
+/**
+ * __get_lock - find or create a lock instance
+ * @lock: pointer to a pthread lock function
+ *
+ * Try to find an existing lock in the rbtree using the provided pointer. If
+ * one wasn't found - create it.
+ */
+static struct lock_lookup *__get_lock(void *lock)
+{
+	struct rb_node **node, *parent;
+	struct lock_lookup *l;
+
+	ll_pthread_rwlock_rdlock(&locks_rwlock);
+	node = __get_lock_node(lock, &parent);
+	ll_pthread_rwlock_unlock(&locks_rwlock);
+	if (*node) {
+		return rb_entry(*node, struct lock_lookup, node);
+	}
+
+	/* We didn't find the lock, let's create it */
+	l = alloc_lock();
+	if (l == NULL)
+		return NULL;
+
+	l->orig = lock;
+	/*
+	 * Currently the name of the lock is the ptr value of the pthread lock,
+	 * while not optimal, it makes debugging a bit easier.
+	 *
+	 * TODO: Get the real name of the lock using libdwarf
+	 */
+	sprintf(l->name, "%p", lock);
+	lockdep_init_map(&l->dep_map, l->name, &l->key, 0);
+
+	ll_pthread_rwlock_wrlock(&locks_rwlock);
+	/* This might have changed since the last time we fetched it */
+	node = __get_lock_node(lock, &parent);
+	rb_link_node(&l->node, parent, node);
+	rb_insert_color(&l->node, &locks);
+	ll_pthread_rwlock_unlock(&locks_rwlock);
+
+	return l;
+}
+
+static void __del_lock(struct lock_lookup *lock)
+{
+	ll_pthread_rwlock_wrlock(&locks_rwlock);
+	rb_erase(&lock->node, &locks);
+	ll_pthread_rwlock_unlock(&locks_rwlock);
+	free_lock(lock);
+}
+
+int pthread_mutex_init(pthread_mutex_t *mutex,
+			const pthread_mutexattr_t *attr)
+{
+	int r;
+
+	/*
+	 * We keep trying to init our preload module because there might be
+	 * code in init sections that tries to touch locks before we are
+	 * initialized, in that case we'll need to manually call preload
+	 * to get us going.
+	 *
+	 * Funny enough, kernel's lockdep had the same issue, and used
+	 * (almost) the same solution. See look_up_lock_class() in
+	 * kernel/locking/lockdep.c for details.
+	 */
+	try_init_preload();
+
+	r = ll_pthread_mutex_init(mutex, attr);
+	if (r == 0)
+		/*
+		 * We do a dummy initialization here so that lockdep could
+		 * warn us if something fishy is going on - such as
+		 * initializing a held lock.
+		 */
+		__get_lock(mutex);
+
+	return r;
+}
+
+int pthread_mutex_lock(pthread_mutex_t *mutex)
+{
+	int r;
+
+	try_init_preload();
+
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL,
+			(unsigned long)_RET_IP_);
+	/*
+	 * Here's the thing with pthread mutexes: unlike the kernel variant,
+	 * they can fail.
+	 *
+	 * This means that the behaviour here is a bit different from what's
+	 * going on in the kernel: there we just tell lockdep that we took the
+	 * lock before actually taking it, but here we must deal with the case
+	 * that locking failed.
+	 *
+	 * To do that we'll "release" the lock if locking failed - this way
+	 * we'll get lockdep doing the correct checks when we try to take
+	 * the lock, and if that fails - we'll be back to the correct
+	 * state by releasing it.
+	 */
+	r = ll_pthread_mutex_lock(mutex);
+	if (r)
+		lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_mutex_trylock(pthread_mutex_t *mutex)
+{
+	int r;
+
+	try_init_preload();
+
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	r = ll_pthread_mutex_trylock(mutex);
+	if (r)
+		lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_mutex_unlock(pthread_mutex_t *mutex)
+{
+	int r;
+
+	try_init_preload();
+
+	lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
+	/*
+	 * Just like taking a lock, only in reverse!
+	 *
+	 * If we fail releasing the lock, tell lockdep we're holding it again.
+	 */
+	r = ll_pthread_mutex_unlock(mutex);
+	if (r)
+		lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_mutex_destroy(pthread_mutex_t *mutex)
+{
+	try_init_preload();
+
+	/*
+	 * Let's see if we're releasing a lock that's held.
+	 *
+	 * TODO: Hook into free() and add that check there as well.
+	 */
+	debug_check_no_locks_freed(mutex, mutex + sizeof(*mutex));
+	__del_lock(__get_lock(mutex));
+	return ll_pthread_mutex_destroy(mutex);
+}
+
+/* This is the rwlock part, very similar to what happened with mutex above */
+int pthread_rwlock_init(pthread_rwlock_t *rwlock,
+			const pthread_rwlockattr_t *attr)
+{
+	int r;
+
+	try_init_preload();
+
+	r = ll_pthread_rwlock_init(rwlock, attr);
+	if (r == 0)
+		__get_lock(rwlock);
+
+	return r;
+}
+
+int pthread_rwlock_destroy(pthread_rwlock_t *rwlock)
+{
+	try_init_preload();
+
+	debug_check_no_locks_freed(rwlock, rwlock + sizeof(*rwlock));
+	__del_lock(__get_lock(rwlock));
+	return ll_pthread_rwlock_destroy(rwlock);
+}
+
+int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock)
+{
+	int r;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 2, 2, NULL, (unsigned long)_RET_IP_);
+	r = ll_pthread_rwlock_rdlock(rwlock);
+	if (r)
+		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock)
+{
+	int r;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 2, 2, NULL, (unsigned long)_RET_IP_);
+	r = ll_pthread_rwlock_tryrdlock(rwlock);
+	if (r)
+		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock)
+{
+	int r;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	r = ll_pthread_rwlock_trywrlock(rwlock);
+	if (r)
+                lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock)
+{
+	int r;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	r = ll_pthread_rwlock_wrlock(rwlock);
+	if (r)
+		lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)
+{
+	int r;
+
+        init_preload();
+
+	lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
+	r = ll_pthread_rwlock_unlock(rwlock);
+	if (r)
+		lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+
+	return r;
+}
+
+__attribute__((constructor)) static void init_preload(void)
+{
+	if (__init_state != done)
+		return;
+
+#ifndef __GLIBC__
+	__init_state = prepare;
+
+	ll_pthread_mutex_init = dlsym(RTLD_NEXT, "pthread_mutex_init");
+	ll_pthread_mutex_lock = dlsym(RTLD_NEXT, "pthread_mutex_lock");
+	ll_pthread_mutex_trylock = dlsym(RTLD_NEXT, "pthread_mutex_trylock");
+	ll_pthread_mutex_unlock = dlsym(RTLD_NEXT, "pthread_mutex_unlock");
+	ll_pthread_mutex_destroy = dlsym(RTLD_NEXT, "pthread_mutex_destroy");
+
+	ll_pthread_rwlock_init = dlsym(RTLD_NEXT, "pthread_rwlock_init");
+	ll_pthread_rwlock_destroy = dlsym(RTLD_NEXT, "pthread_rwlock_destroy");
+	ll_pthread_rwlock_rdlock = dlsym(RTLD_NEXT, "pthread_rwlock_rdlock");
+	ll_pthread_rwlock_tryrdlock = dlsym(RTLD_NEXT, "pthread_rwlock_tryrdlock");
+	ll_pthread_rwlock_wrlock = dlsym(RTLD_NEXT, "pthread_rwlock_wrlock");
+	ll_pthread_rwlock_trywrlock = dlsym(RTLD_NEXT, "pthread_rwlock_trywrlock");
+	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
+#endif
+
+	printf("%p\n", ll_pthread_mutex_trylock);fflush(stdout);
+
+	lockdep_init();
+
+	__init_state = done;
+}
diff --git a/tools/lib/lockdep/rbtree.c b/tools/lib/lockdep/rbtree.c
new file mode 100644
index 0000000..f7f4303
--- /dev/null
+++ b/tools/lib/lockdep/rbtree.c
@@ -0,0 +1 @@
+#include "../../../lib/rbtree.c"
diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
new file mode 100644
index 0000000..5334ad9
--- /dev/null
+++ b/tools/lib/lockdep/run_tests.sh
@@ -0,0 +1,27 @@
+#! /bin/bash
+
+make &> /dev/null
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -pthread -lpthread $i liblockdep.a -Iinclude -D__USE_LIBLOCKDEP &> /dev/null
+	echo -ne "$testname... "
+	if [ $(timeout 1 ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -pthread -lpthread -Iinclude $i &> /dev/null
+	echo -ne "(PRELOAD) $testname... "
+	if [ $(timeout 1 ./lockdep ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
new file mode 100644
index 0000000..0f782ff
--- /dev/null
+++ b/tools/lib/lockdep/tests/AA.c
@@ -0,0 +1,13 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_lock(&b);
+	pthread_mutex_lock(&a);
+}
diff --git a/tools/lib/lockdep/tests/ABBA.c b/tools/lib/lockdep/tests/ABBA.c
new file mode 100644
index 0000000..07f0e29
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBA.c
@@ -0,0 +1,13 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, a);
+}
diff --git a/tools/lib/lockdep/tests/ABBCCA.c b/tools/lib/lockdep/tests/ABBCCA.c
new file mode 100644
index 0000000..843db09
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCA.c
@@ -0,0 +1,15 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, a);
+}
diff --git a/tools/lib/lockdep/tests/ABBCCDDA.c b/tools/lib/lockdep/tests/ABBCCDDA.c
new file mode 100644
index 0000000..33620e2
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCDDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/ABCABC.c b/tools/lib/lockdep/tests/ABCABC.c
new file mode 100644
index 0000000..3fee51e
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCABC.c
@@ -0,0 +1,15 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, a);
+	LOCK_UNLOCK_2(b, c);
+}
diff --git a/tools/lib/lockdep/tests/ABCDBCDA.c b/tools/lib/lockdep/tests/ABCDBCDA.c
new file mode 100644
index 0000000..427ba56
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/ABCDBDDA.c b/tools/lib/lockdep/tests/ABCDBDDA.c
new file mode 100644
index 0000000..680c6cf
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBDDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
new file mode 100644
index 0000000..d44f77d
--- /dev/null
+++ b/tools/lib/lockdep/tests/WW.c
@@ -0,0 +1,13 @@
+#include <liblockdep/rwlock.h>
+
+void main(void)
+{
+	pthread_rwlock_t a, b;
+
+	pthread_rwlock_init(&a, NULL);
+	pthread_rwlock_init(&b, NULL);
+
+	pthread_rwlock_wrlock(&a);
+	pthread_rwlock_rdlock(&b);
+	pthread_rwlock_wrlock(&a);
+}
diff --git a/tools/lib/lockdep/tests/common.h b/tools/lib/lockdep/tests/common.h
new file mode 100644
index 0000000..d89e94d
--- /dev/null
+++ b/tools/lib/lockdep/tests/common.h
@@ -0,0 +1,12 @@
+#ifndef _LIBLOCKDEP_TEST_COMMON_H
+#define _LIBLOCKDEP_TEST_COMMON_H
+
+#define LOCK_UNLOCK_2(a, b)			\
+	do {					\
+		pthread_mutex_lock(&(a));	\
+		pthread_mutex_lock(&(b));	\
+		pthread_mutex_unlock(&(b));	\
+		pthread_mutex_unlock(&(a));	\
+	} while(0)
+
+#endif
diff --git a/tools/lib/lockdep/tests/unlock_balance.c b/tools/lib/lockdep/tests/unlock_balance.c
new file mode 100644
index 0000000..0bc62de
--- /dev/null
+++ b/tools/lib/lockdep/tests/unlock_balance.c
@@ -0,0 +1,12 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a;
+
+	pthread_mutex_init(&a, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_unlock(&a);
+	pthread_mutex_unlock(&a);
+}
diff --git a/tools/lib/lockdep/uinclude/asm/hweight.h b/tools/lib/lockdep/uinclude/asm/hweight.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/asm/hweight.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/asm/sections.h b/tools/lib/lockdep/uinclude/asm/sections.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/asm/sections.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/bitops.h b/tools/lib/lockdep/uinclude/linux/bitops.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/bitops.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/compiler.h b/tools/lib/lockdep/uinclude/linux/compiler.h
new file mode 100644
index 0000000..7ac838a
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/compiler.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_COMPILER_H_
+#define _LIBLOCKDEP_LINUX_COMPILER_H_
+
+#define __used		__attribute__((__unused__))
+#define unlikely
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/debug_locks.h b/tools/lib/lockdep/uinclude/linux/debug_locks.h
new file mode 100644
index 0000000..f38eb64
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/debug_locks.h
@@ -0,0 +1,12 @@
+#ifndef _LIBLOCKDEP_DEBUG_LOCKS_H_
+#define _LIBLOCKDEP_DEBUG_LOCKS_H_
+
+#include <stddef.h>
+#include <linux/compiler.h>
+
+#define DEBUG_LOCKS_WARN_ON(x) (x)
+
+extern bool debug_locks;
+extern bool debug_locks_silent;
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/delay.h b/tools/lib/lockdep/uinclude/linux/delay.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/delay.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/export.h b/tools/lib/lockdep/uinclude/linux/export.h
new file mode 100644
index 0000000..6bdf349
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/export.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_EXPORT_H_
+#define _LIBLOCKDEP_LINUX_EXPORT_H_
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/ftrace.h b/tools/lib/lockdep/uinclude/linux/ftrace.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/ftrace.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/gfp.h b/tools/lib/lockdep/uinclude/linux/gfp.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/gfp.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/hardirq.h b/tools/lib/lockdep/uinclude/linux/hardirq.h
new file mode 100644
index 0000000..c8f3f8f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/hardirq.h
@@ -0,0 +1,11 @@
+#ifndef _LIBLOCKDEP_LINUX_HARDIRQ_H_
+#define _LIBLOCKDEP_LINUX_HARDIRQ_H_
+
+#define SOFTIRQ_BITS	0UL
+#define HARDIRQ_BITS	0UL
+#define SOFTIRQ_SHIFT	0UL
+#define HARDIRQ_SHIFT	0UL
+#define hardirq_count()	0UL
+#define softirq_count()	0UL
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/hash.h b/tools/lib/lockdep/uinclude/linux/hash.h
new file mode 100644
index 0000000..0f84798
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/hash.h
@@ -0,0 +1 @@
+#include "../../../include/linux/hash.h"
diff --git a/tools/lib/lockdep/uinclude/linux/interrupt.h b/tools/lib/lockdep/uinclude/linux/interrupt.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/interrupt.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/irqflags.h b/tools/lib/lockdep/uinclude/linux/irqflags.h
new file mode 100644
index 0000000..6cc296f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/irqflags.h
@@ -0,0 +1,38 @@
+#ifndef _LIBLOCKDEP_LINUX_TRACE_IRQFLAGS_H_
+#define _LIBLOCKDEP_LINUX_TRACE_IRQFLAGS_H_
+
+# define trace_hardirq_context(p)	0
+# define trace_softirq_context(p)	0
+# define trace_hardirqs_enabled(p)	0
+# define trace_softirqs_enabled(p)	0
+# define trace_hardirq_enter()		do { } while (0)
+# define trace_hardirq_exit()		do { } while (0)
+# define lockdep_softirq_enter()	do { } while (0)
+# define lockdep_softirq_exit()		do { } while (0)
+# define INIT_TRACE_IRQFLAGS
+
+# define stop_critical_timings() do { } while (0)
+# define start_critical_timings() do { } while (0)
+
+#define raw_local_irq_disable() do { } while (0)
+#define raw_local_irq_enable() do { } while (0)
+#define raw_local_irq_save(flags) ((flags) = 0)
+#define raw_local_irq_restore(flags) do { } while (0)
+#define raw_local_save_flags(flags) ((flags) = 0)
+#define raw_irqs_disabled_flags(flags) do { } while (0)
+#define raw_irqs_disabled() 0
+#define raw_safe_halt()
+
+#define local_irq_enable() do { } while (0)
+#define local_irq_disable() do { } while (0)
+#define local_irq_save(flags) ((flags) = 0)
+#define local_irq_restore(flags) do { } while (0)
+#define local_save_flags(flags)	((flags) = 0)
+#define irqs_disabled() (1)
+#define irqs_disabled_flags(flags) (0)
+#define safe_halt() do { } while (0)
+
+#define trace_lock_release(x, y)
+#define trace_lock_acquire(a, b, c, d, e, f, g)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kallsyms.h b/tools/lib/lockdep/uinclude/linux/kallsyms.h
new file mode 100644
index 0000000..b0f2dbd
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kallsyms.h
@@ -0,0 +1,32 @@
+#ifndef _LIBLOCKDEP_LINUX_KALLSYMS_H_
+#define _LIBLOCKDEP_LINUX_KALLSYMS_H_
+
+#include <linux/kernel.h>
+#include <stdio.h>
+
+#define KSYM_NAME_LEN 128
+
+struct module;
+
+static inline const char *kallsyms_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname, char *namebuf)
+{
+	return NULL;
+}
+
+#include <execinfo.h>
+#include <stdlib.h>
+static inline void print_ip_sym(unsigned long ip)
+{
+	char **name;
+
+	name = backtrace_symbols((void **)&ip, 1);
+
+	printf("%s\n", *name);
+
+	free(name);
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kern_levels.h b/tools/lib/lockdep/uinclude/linux/kern_levels.h
new file mode 100644
index 0000000..3b9bade
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kern_levels.h
@@ -0,0 +1,25 @@
+#ifndef __KERN_LEVELS_H__
+#define __KERN_LEVELS_H__
+
+#define KERN_SOH	""		/* ASCII Start Of Header */
+#define KERN_SOH_ASCII	''
+
+#define KERN_EMERG	KERN_SOH ""	/* system is unusable */
+#define KERN_ALERT	KERN_SOH ""	/* action must be taken immediately */
+#define KERN_CRIT	KERN_SOH ""	/* critical conditions */
+#define KERN_ERR	KERN_SOH ""	/* error conditions */
+#define KERN_WARNING	KERN_SOH ""	/* warning conditions */
+#define KERN_NOTICE	KERN_SOH ""	/* normal but significant condition */
+#define KERN_INFO	KERN_SOH ""	/* informational */
+#define KERN_DEBUG	KERN_SOH ""	/* debug-level messages */
+
+#define KERN_DEFAULT	KERN_SOH ""	/* the default kernel loglevel */
+
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define KERN_CONT	""
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kernel.h b/tools/lib/lockdep/uinclude/linux/kernel.h
new file mode 100644
index 0000000..a11e3c3
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kernel.h
@@ -0,0 +1,44 @@
+#ifndef _LIBLOCKDEP_LINUX_KERNEL_H_
+#define _LIBLOCKDEP_LINUX_KERNEL_H_
+
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/rcu.h>
+#include <linux/hardirq.h>
+#include <linux/kern_levels.h>
+
+#ifndef container_of
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define WARN_ON(x) (x)
+#define WARN_ON_ONCE(x) (x)
+#define likely(x) (x)
+#define WARN(x, y, z) (x)
+#define uninitialized_var(x) x
+#define __init
+#define noinline
+#define list_add_tail_rcu list_add_tail
+
+#ifndef CALLER_ADDR0
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#endif
+
+#ifndef _RET_IP_
+#define _RET_IP_ CALLER_ADDR0
+#endif
+
+#ifndef _THIS_IP_
+#define _THIS_IP_ ({ __label__ __here; __here: (unsigned long)&&__here; })
+#endif
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kmemcheck.h b/tools/lib/lockdep/uinclude/linux/kmemcheck.h
new file mode 100644
index 0000000..94d598b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kmemcheck.h
@@ -0,0 +1,8 @@
+#ifndef _LIBLOCKDEP_LINUX_KMEMCHECK_H_
+#define _LIBLOCKDEP_LINUX_KMEMCHECK_H_
+
+static inline void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/linkage.h b/tools/lib/lockdep/uinclude/linux/linkage.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/linkage.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/list.h b/tools/lib/lockdep/uinclude/linux/list.h
new file mode 100644
index 0000000..6e9ef31
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/list.h
@@ -0,0 +1 @@
+#include "../../../include/linux/list.h"
diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
new file mode 100644
index 0000000..d0f5d6e
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
@@ -0,0 +1,55 @@
+#ifndef _LIBLOCKDEP_LOCKDEP_H_
+#define _LIBLOCKDEP_LOCKDEP_H_
+
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <string.h>
+#include <limits.h>
+#include <linux/utsname.h>
+
+
+#define MAX_LOCK_DEPTH 2000UL
+
+#include "../../../include/linux/lockdep.h"
+
+struct task_struct {
+	u64 curr_chain_key;
+	int lockdep_depth;
+	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
+	gfp_t lockdep_reclaim_gfp;
+	int pid;
+	char comm[17];
+};
+
+extern struct task_struct *__curr(void);
+
+#define current (__curr())
+
+#define debug_locks_off() 1
+#define task_pid_nr(tsk) ((tsk)->pid)
+
+#define KSYM_NAME_LEN 128
+#define printk printf
+
+#define list_del_rcu list_del
+
+#define atomic_t unsigned long
+#define atomic_inc(x) ((*(x))++)
+
+static struct new_utsname *init_utsname(void)
+{
+	static struct new_utsname n = (struct new_utsname) {
+		.release = "liblockdep",
+		.version = LIBLOCKDEP_VERSION,
+	};
+
+	return &n;
+}
+
+#define print_tainted() ""
+#define static_obj(x) 1
+
+#define debug_show_all_locks()
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/module.h b/tools/lib/lockdep/uinclude/linux/module.h
new file mode 100644
index 0000000..09c7a7b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/module.h
@@ -0,0 +1,6 @@
+#ifndef _LIBLOCKDEP_LINUX_MODULE_H_
+#define _LIBLOCKDEP_LINUX_MODULE_H_
+
+#define module_param(name, type, perm)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/mutex.h b/tools/lib/lockdep/uinclude/linux/mutex.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/mutex.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/poison.h b/tools/lib/lockdep/uinclude/linux/poison.h
new file mode 100644
index 0000000..0c27bdf
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/poison.h
@@ -0,0 +1 @@
+#include "../../../include/linux/poison.h"
diff --git a/tools/lib/lockdep/uinclude/linux/prefetch.h b/tools/lib/lockdep/uinclude/linux/prefetch.h
new file mode 100644
index 0000000..d73fe6f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/prefetch.h
@@ -0,0 +1,6 @@
+#ifndef _LIBLOCKDEP_LINUX_PREFETCH_H_
+#define _LIBLOCKDEP_LINUX_PREFETCH_H
+
+static inline void prefetch(void *a __attribute__((unused))) { }
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/proc_fs.h b/tools/lib/lockdep/uinclude/linux/proc_fs.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/proc_fs.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/rbtree.h b/tools/lib/lockdep/uinclude/linux/rbtree.h
new file mode 100644
index 0000000..965901d
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rbtree.h
@@ -0,0 +1 @@
+#include "../../../include/linux/rbtree.h"
diff --git a/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h b/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
new file mode 100644
index 0000000..c375947
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rbtree_augmented.h
@@ -0,0 +1,2 @@
+#define __always_inline
+#include "../../../include/linux/rbtree_augmented.h"
diff --git a/tools/lib/lockdep/uinclude/linux/rcu.h b/tools/lib/lockdep/uinclude/linux/rcu.h
new file mode 100644
index 0000000..4c99fcb
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rcu.h
@@ -0,0 +1,16 @@
+#ifndef _LIBLOCKDEP_RCU_H_
+#define _LIBLOCKDEP_RCU_H_
+
+int rcu_scheduler_active;
+
+static inline int rcu_lockdep_current_cpu_online(void)
+{
+	return 1;
+}
+
+static inline int rcu_is_cpu_idle(void)
+{
+	return 1;
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/seq_file.h b/tools/lib/lockdep/uinclude/linux/seq_file.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/seq_file.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
diff --git a/tools/lib/lockdep/uinclude/linux/spinlock.h b/tools/lib/lockdep/uinclude/linux/spinlock.h
new file mode 100644
index 0000000..68c1aa2
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/spinlock.h
@@ -0,0 +1,25 @@
+#ifndef _LIBLOCKDEP_SPINLOCK_H_
+#define _LIBLOCKDEP_SPINLOCK_H_
+
+#include <pthread.h>
+#include <stdbool.h>
+
+#define arch_spinlock_t pthread_mutex_t
+#define __ARCH_SPIN_LOCK_UNLOCKED PTHREAD_MUTEX_INITIALIZER
+
+static inline void arch_spin_lock(arch_spinlock_t *mutex)
+{
+	pthread_mutex_lock(mutex);
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *mutex)
+{
+	pthread_mutex_unlock(mutex);
+}
+
+static inline bool arch_spin_is_locked(arch_spinlock_t *mutex)
+{
+	return true;
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/stacktrace.h b/tools/lib/lockdep/uinclude/linux/stacktrace.h
new file mode 100644
index 0000000..39aecc6
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/stacktrace.h
@@ -0,0 +1,32 @@
+#ifndef _LIBLOCKDEP_LINUX_STACKTRACE_H_
+#define _LIBLOCKDEP_LINUX_STACKTRACE_H_
+
+#include <execinfo.h>
+
+struct stack_trace {
+	unsigned int nr_entries, max_entries;
+	unsigned long *entries;
+	int skip;
+};
+
+static inline void print_stack_trace(struct stack_trace *trace, int spaces)
+{
+	backtrace_symbols_fd((void **)trace->entries, trace->nr_entries, 1);
+}
+
+#define save_stack_trace(trace)	\
+	((trace)->nr_entries =	\
+		backtrace((void **)(trace)->entries, (trace)->max_entries))
+
+static inline int dump_stack(void)
+{
+	void *array[64];
+	size_t size;
+
+	size = backtrace(array, 64);
+	backtrace_symbols_fd(array, size, 1);
+
+	return 0;
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/stringify.h b/tools/lib/lockdep/uinclude/linux/stringify.h
new file mode 100644
index 0000000..05dfcd1
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/stringify.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_STRINGIFY_H_
+#define _LIBLOCKDEP_LINUX_STRINGIFY_H_
+
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/types.h b/tools/lib/lockdep/uinclude/linux/types.h
new file mode 100644
index 0000000..929938f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/types.h
@@ -0,0 +1,58 @@
+#ifndef _LIBLOCKDEP_LINUX_TYPES_H_
+#define _LIBLOCKDEP_LINUX_TYPES_H_
+
+#include <stdbool.h>
+#include <stddef.h>
+
+#define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
+#include <asm/types.h>
+
+struct page;
+struct kmem_cache;
+
+typedef unsigned gfp_t;
+
+typedef __u64 u64;
+typedef __s64 s64;
+
+typedef __u32 u32;
+typedef __s32 s32;
+
+typedef __u16 u16;
+typedef __s16 s16;
+
+typedef __u8  u8;
+typedef __s8  s8;
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
+
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/trace/events/lock.h b/tools/lib/lockdep/uinclude/trace/events/lock.h
new file mode 100644
index 0000000..fab00ff
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/trace/events/lock.h
@@ -0,0 +1,3 @@
+
+/* empty file */
+
