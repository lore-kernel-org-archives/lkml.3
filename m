Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3KFN6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:58:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:58:23 -0500
Date: Wed, 6 Nov 2013 14:57:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131106135736.GK10651@twins.programming.kicks-ass.net>
References: <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
 <20131104191127.GW16117@laptop.programming.kicks-ass.net>
 <20131104205344.GW3947@linux.vnet.ibm.com>
 <20131106123946.GJ10651@twins.programming.kicks-ass.net>
 <CAMuHMdXZjQJvT7R4ODbDNBgAVwPUBPjB6UoR66_sNuFx7opUDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXZjQJvT7R4ODbDNBgAVwPUBPjB6UoR66_sNuFx7opUDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:51:10PM +0100, Geert Uytterhoeven wrote:
> This is screaming for a default implementation in asm-generic.

Right you are... how about a little something like this?

There's a few archs I didn't fully merge with the generic one because of
weird nop implementations.

asm volatile ("nop" :: ) vs asm volatile ("nop" ::: "memory") and the
like. They probably can (and should) use the regular asm volatile
("nop") but I misplaced the toolchains for many of the weird archs so I
didn't attempt.

Also fixed a silly mistake in the return type definition for most
smp_load_acquire() implementions: typeof(p) vs typeof(*p).

---
Subject: arch: Introduce smp_load_acquire(), smp_store_release()
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 4 Nov 2013 20:18:11 +0100

A number of situations currently require the heavyweight smp_mb(),
even though there is no need to order prior stores against later
loads.  Many architectures have much cheaper ways to handle these
situations, but the Linux kernel currently has no portable way
to make use of them.

This commit therefore supplies smp_load_acquire() and
smp_store_release() to remedy this situation.  The new
smp_load_acquire() primitive orders the specified load against
any subsequent reads or writes, while the new smp_store_release()
primitive orders the specifed store against any prior reads or
writes.  These primitives allow array-based circular FIFOs to be
implemented without an smp_mb(), and also allow a theoretical
hole in rcu_assign_pointer() to be closed at no additional
expense on most architectures.

In addition, the RCU experience transitioning from explicit
smp_read_barrier_depends() and smp_wmb() to rcu_dereference()
and rcu_assign_pointer(), respectively resulted in substantial
improvements in readability.  It therefore seems likely that
replacing other explicit barriers with smp_load_acquire() and
smp_store_release() will provide similar benefits.  It appears
that roughly half of the explicit barriers in core kernel code
might be so replaced.


Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/memory-barriers.txt     |  157 +++++++++++++++++-----------------
 arch/alpha/include/asm/barrier.h      |   25 +----
 arch/arc/include/asm/Kbuild           |    1 
 arch/arc/include/asm/atomic.h         |    5 +
 arch/arc/include/asm/barrier.h        |   42 ---------
 arch/arm/include/asm/barrier.h        |   15 +++
 arch/arm64/include/asm/barrier.h      |   50 ++++++++++
 arch/avr32/include/asm/barrier.h      |   17 +--
 arch/blackfin/include/asm/barrier.h   |   18 ---
 arch/cris/include/asm/Kbuild          |    1 
 arch/cris/include/asm/barrier.h       |   25 -----
 arch/frv/include/asm/barrier.h        |    8 -
 arch/h8300/include/asm/barrier.h      |   21 ----
 arch/hexagon/include/asm/Kbuild       |    1 
 arch/hexagon/include/asm/barrier.h    |   41 --------
 arch/ia64/include/asm/barrier.h       |   49 ++++++++++
 arch/m32r/include/asm/barrier.h       |   80 -----------------
 arch/m68k/include/asm/barrier.h       |   14 ---
 arch/metag/include/asm/barrier.h      |   15 +++
 arch/microblaze/include/asm/Kbuild    |    1 
 arch/microblaze/include/asm/barrier.h |   27 -----
 arch/mips/include/asm/barrier.h       |   15 +++
 arch/mn10300/include/asm/Kbuild       |    1 
 arch/mn10300/include/asm/barrier.h    |   37 --------
 arch/parisc/include/asm/Kbuild        |    1 
 arch/parisc/include/asm/barrier.h     |   35 -------
 arch/powerpc/include/asm/barrier.h    |   21 ++++
 arch/s390/include/asm/barrier.h       |   15 +++
 arch/score/include/asm/Kbuild         |    1 
 arch/score/include/asm/barrier.h      |   16 ---
 arch/sh/include/asm/barrier.h         |   21 ----
 arch/sparc/include/asm/barrier_32.h   |   11 --
 arch/sparc/include/asm/barrier_64.h   |   15 +++
 arch/tile/include/asm/barrier.h       |   68 --------------
 arch/unicore32/include/asm/barrier.h  |   11 --
 arch/x86/include/asm/barrier.h        |   15 +++
 arch/xtensa/include/asm/barrier.h     |    9 -
 include/asm-generic/barrier.h         |   55 +++++++++--
 include/linux/compiler.h              |    9 +
 39 files changed, 375 insertions(+), 594 deletions(-)

--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -371,33 +371,35 @@ VARIETIES OF MEMORY BARRIER
 
 And a couple of implicit varieties:
 
- (5) LOCK operations.
+ (5) ACQUIRE operations.
 
      This acts as a one-way permeable barrier.  It guarantees that all memory
-     operations after the LOCK operation will appear to happen after the LOCK
-     operation with respect to the other components of the system.
+     operations after the ACQUIRE operation will appear to happen after the
+     ACQUIRE operation with respect to the other components of the system.
 
-     Memory operations that occur before a LOCK operation may appear to happen
-     after it completes.
+     Memory operations that occur before a ACQUIRE operation may appear to
+     happen after it completes.
 
-     A LOCK operation should almost always be paired with an UNLOCK operation.
+     A ACQUIRE operation should almost always be paired with an RELEASE
+     operation.
 
 
- (6) UNLOCK operations.
+ (6) RELEASE operations.
 
      This also acts as a one-way permeable barrier.  It guarantees that all
-     memory operations before the UNLOCK operation will appear to happen before
-     the UNLOCK operation with respect to the other components of the system.
+     memory operations before the RELEASE operation will appear to happen
+     before the RELEASE operation with respect to the other components of the
+     system.
 
-     Memory operations that occur after an UNLOCK operation may appear to
+     Memory operations that occur after an RELEASE operation may appear to
      happen before it completes.
 
-     LOCK and UNLOCK operations are guaranteed to appear with respect to each
-     other strictly in the order specified.
+     ACQUIRE and RELEASE operations are guaranteed to appear with respect to
+     each other strictly in the order specified.
 
-     The use of LOCK and UNLOCK operations generally precludes the need for
-     other sorts of memory barrier (but note the exceptions mentioned in the
-     subsection "MMIO write barrier").
+     The use of ACQUIRE and RELEASE operations generally precludes the need
+     for other sorts of memory barrier (but note the exceptions mentioned in
+     the subsection "MMIO write barrier").
 
 
 Memory barriers are only required where there's a possibility of interaction
@@ -1135,7 +1137,7 @@ CPU from reordering them.
 	clear_bit( ... );
 
      This prevents memory operations before the clear leaking to after it.  See
-     the subsection on "Locking Functions" with reference to UNLOCK operation
+     the subsection on "Locking Functions" with reference to RELEASE operation
      implications.
 
      See Documentation/atomic_ops.txt for more information.  See the "Atomic
@@ -1181,65 +1183,66 @@ LOCKING FUNCTIONS
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
+     ACQUIRE operation has completed.
 
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
+     All ACQUIRE operations issued before an RELEASE operation will be
+     completed before the RELEASE operation.
 
-     All UNLOCK operations issued before a LOCK operation will be completed
-     before the LOCK operation.
+     All RELEASE operations issued before a ACQUIRE operation will be
+     completed before the ACQUIRE operation.
 
- (5) Failed conditional LOCK implication:
+ (5) Failed conditional ACQUIRE implication:
 
-     Certain variants of the LOCK operation may fail, either due to being
+     Certain variants of the ACQUIRE operation may fail, either due to being
      unable to get the lock immediately, or due to receiving an unblocked
      signal whilst asleep waiting for the lock to become available.  Failed
      locks do not imply any sort of barrier.
 
-Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
-equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
+Therefore, from (1), (2) and (4) an RELEASE followed by an unconditional
+ACQUIRE is equivalent to a full barrier, but a ACQUIRE followed by an RELEASE
+is not.
 
 [!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
     barriers is that the effects of instructions outside of a critical section
     may seep into the inside of the critical section.
 
-A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
-because it is possible for an access preceding the LOCK to happen after the
-LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
-two accesses can themselves then cross:
+A ACQUIRE followed by an RELEASE may not be assumed to be full memory barrier
+because it is possible for an access preceding the ACQUIRE to happen after the
+ACQUIRE, and an access following the RELEASE to happen before the RELEASE, and
+the two accesses can themselves then cross:
 
 	*A = a;
-	LOCK
-	UNLOCK
+	ACQUIRE
+	RELEASE
 	*B = b;
 
 may occur as:
 
-	LOCK, STORE *B, STORE *A, UNLOCK
+	ACQUIRE, STORE *B, STORE *A, RELEASE
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
 systems, and so cannot be counted on in such a situation to actually achieve
@@ -1253,33 +1256,33 @@ See also the section on "Inter-CPU locki
 
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
 
@@ -1436,24 +1439,24 @@ Consider the following: the system has a
 	CPU 1				CPU 2
 	===============================	===============================
 	*A = a;				*E = e;
-	LOCK M				LOCK Q
+	ACQUIRE M			ACQUIRE Q
 	*B = b;				*F = f;
 	*C = c;				*G = g;
-	UNLOCK M			UNLOCK Q
+	RELEASE M			RELEASE Q
 	*D = d;				*H = h;
 
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
@@ -1461,28 +1464,28 @@ through *H occur in, other than the cons
 	CPU 1				CPU 2
 	===============================	===============================
 	*A = a;
-	LOCK M		[1]
+	ACQUIRE M	[1]
 	*B = b;
 	*C = c;
-	UNLOCK M	[1]
+	RELEASE M	[1]
 	*D = d;				*E = e;
-					LOCK M		[2]
+					ACQUIRE M	[2]
 					*F = f;
 					*G = g;
-					UNLOCK M	[2]
+					RELEASE M	[2]
 					*H = h;
 
 CPU 3 might see:
 
-	*E, LOCK M [1], *C, *B, *A, UNLOCK M [1],
-		LOCK M [2], *H, *F, *G, UNLOCK M [2], *D
+	*E, ACQUIRE M [1], *C, *B, *A, RELEASE M [1],
+	    ACQUIRE M [2], *H, *F, *G, RELEASE M [2], *D
 
 But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 
-	*B, *C, *D, *F, *G or *H preceding LOCK M [1]
-	*A, *B or *C following UNLOCK M [1]
-	*F, *G or *H preceding LOCK M [2]
-	*A, *B, *C, *E, *F or *G following UNLOCK M [2]
+	*B, *C, *D, *F, *G or *H preceding ACQUIRE M [1]
+	*A, *B or *C following RELEASE M [1]
+	*F, *G or *H preceding ACQUIRE M [2]
+	*A, *B, *C, *E, *F or *G following RELEASE M [2]
 
 
 LOCKS VS I/O ACCESSES
@@ -1702,13 +1705,13 @@ about the state (old or new) implies an
 	test_and_clear_bit();
 	test_and_change_bit();
 
-These are used for such things as implementing LOCK-class and UNLOCK-class
+These are used for such things as implementing ACQUIRE-class and RELEASE-class
 operations and adjusting reference counters towards object destruction, and as
 such the implicit memory barrier effects are necessary.
 
 
 The following operations are potential problems as they do _not_ imply memory
-barriers, but might be used for implementing such things as UNLOCK-class
+barriers, but might be used for implementing such things as RELEASE-class
 operations:
 
 	atomic_set();
@@ -1750,9 +1753,9 @@ barriers are needed or not.
 	clear_bit_unlock();
 	__clear_bit_unlock();
 
-These implement LOCK-class and UNLOCK-class operations. These should be used in
-preference to other operations when implementing locking primitives, because
-their implementations can be optimised on many architectures.
+These implement ACQUIRE-class and RELEASE-class operations. These should be
+used in preference to other operations when implementing locking primitives,
+because their implementations can be optimised on many architectures.
 
 [!] Note that special memory barrier primitives are available for these
 situations because on some CPUs the atomic instructions used imply full memory
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
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -47,3 +47,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -190,6 +190,11 @@ static inline void atomic_clear_mask(uns
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 /**
  * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
--- a/arch/arc/include/asm/barrier.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_BARRIER_H
-#define __ASM_BARRIER_H
-
-#ifndef __ASSEMBLY__
-
-/* TODO-vineetg: Need to see what this does, don't we need sync anywhere */
-#define mb() __asm__ __volatile__ ("" : : : "memory")
-#define rmb() mb()
-#define wmb() mb()
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-#define read_barrier_depends()  mb()
-
-/* TODO-vineetg verify the correctness of macros here */
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#endif
-
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#define smp_read_barrier_depends()      do { } while (0)
-
-#endif
-
-#endif
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
 
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -35,11 +35,59 @@
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
-#endif
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("stlr %w1, [%0]"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("stlr %1, [%0]"				\
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
+		asm volatile ("ldar %w0, [%1]"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	case 8:								\
+		asm volatile ("ldar %0, [%1]"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	}								\
+	___p1;								\
+})
 
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
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
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -12,3 +12,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
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
--- a/arch/h8300/include/asm/barrier.h
+++ b/arch/h8300/include/asm/barrier.h
@@ -3,27 +3,8 @@
 
 #define nop()  asm volatile ("nop"::)
 
-/*
- * Force strict CPU ordering.
- * Not really required on H8...
- */
-#define mb()   asm volatile (""   : : :"memory")
-#define rmb()  asm volatile (""   : : :"memory")
-#define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value) do { xchg(&var, value); } while (0)
 
-#define read_barrier_depends()	do { } while (0)
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
-#endif
+#include <asm-generic/barrier.h>
 
 #endif /* _H8300_BARRIER_H */
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -54,3 +54,4 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
--- a/arch/hexagon/include/asm/barrier.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Memory barrier definitions for the Hexagon architecture
- *
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef _ASM_BARRIER_H
-#define _ASM_BARRIER_H
-
-#define rmb()				barrier()
-#define read_barrier_depends()		barrier()
-#define wmb()				barrier()
-#define mb()				barrier()
-#define smp_rmb()			barrier()
-#define smp_read_barrier_depends()	barrier()
-#define smp_wmb()			barrier()
-#define smp_mb()			barrier()
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
-
-#endif /* _ASM_BARRIER_H */
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -45,11 +45,60 @@
 # define smp_rmb()	rmb()
 # define smp_wmb()	wmb()
 # define smp_read_barrier_depends()	read_barrier_depends()
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("st4.rel [%0]=%1"				\
+				: "=r" (p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("st8.rel [%0]=%1"				\
+				: "=r" (p) : "r" (v) : "memory");	\
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
+		asm volatile ("ld4.acq %0=[%1]"				\
+				: "=r" (___p1) : "r" (p) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("ld8.acq %0=[%1]"				\
+				: "=r" (___p1) : "r" (p) : "memory");	\
+		break;							\
+	}								\
+	___p1;								\
+})
+
 #else
+
 # define smp_mb()	barrier()
 # define smp_rmb()	barrier()
 # define smp_wmb()	barrier()
 # define smp_read_barrier_depends()	do { } while(0)
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
 #endif
 
 /*
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
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
 generic-y += preempt.h
+generic-y += barrier.h
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
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += barrier.h
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
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += word-at-a-time.h auxvec.h u
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += barrier.h
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
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
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
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -1,15 +1,6 @@
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
+#include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -53,4 +53,19 @@ do {	__asm__ __volatile__("ba,pt	%%xcc,
 
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
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -100,6 +100,21 @@
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
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
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
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
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -1,4 +1,5 @@
-/* Generic barrier definitions, based on MN10300 definitions.
+/*
+ * Generic barrier definitions, based on MN10300 definitions.
  *
  * It should be possible to use these on really simple architectures,
  * but it serves more as a starting point for new ports.
@@ -16,35 +17,67 @@
 
 #ifndef __ASSEMBLY__
 
-#define nop() asm volatile ("nop")
+#include <asm/compiler.h>
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
-#define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
+#ifndef mb
+#define mb()	barrier()
+#endif
+
+#ifndef rmb
+#define rmb()	barrier()
+#endif
+
+#ifndef wmb
+#define wmb()	barrier()
+#endif
+
+#ifndef read_barrier_depends
+#define read_barrier_depends()		do {} while (0)
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
+#define smp_read_barrier_depends()	do {} while (0)
 #endif
 
+#ifndef set_mb
 #define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#endif
+
 #define set_wmb(var, value) do { var = value; wmb(); } while (0)
 
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
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
 
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -298,6 +298,11 @@ void ftrace_likely_update(struct ftrace_
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
@@ -337,6 +342,10 @@ void ftrace_likely_update(struct ftrace_
 #define compiletime_assert(condition, msg) \
 	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
 
+#define compiletime_assert_atomic_type(t)				\
+	compiletime_assert(__native_word(t),				\
+		"Need native word sized stores/loads for atomicity.")
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
