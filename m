Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaBFNxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:53:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbaBFNwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:52:20 -0500
Message-Id: <20140206135001.256758416@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 14:48:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 4/5] arch: Generic atomic.h cleanup
References: <20140206134825.305510953@infradead.org>
Content-Disposition: inline; filename=peterz-arch-atomic-and-or.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should mostly be a NO-OP and only removes some duplication.
With a bit of effort these files could be further reduced.

Compile tested on everything I have a compiler for; missing are frv
and tile -- because they're special and I got tired.

XXX: split up in per arch patches?

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/atomic.h          |  217 ++++--------
 arch/arc/include/asm/atomic.h            |  156 +++-----
 arch/arm/include/asm/atomic.h            |  283 ++++++----------
 arch/arm64/include/asm/atomic.h          |  193 +++-------
 arch/avr32/include/asm/atomic.h          |   87 ++--
 arch/cris/include/arch-v10/arch/system.h |    2 
 arch/cris/include/asm/atomic.h           |   52 +-
 arch/hexagon/include/asm/atomic.h        |   65 +--
 arch/ia64/include/asm/atomic.h           |  182 ++++------
 arch/m32r/include/asm/atomic.h           |  140 +++----
 arch/m68k/include/asm/atomic.h           |  109 ++----
 arch/metag/include/asm/atomic_lnkget.h   |  118 ++----
 arch/metag/include/asm/atomic_lock1.h    |   73 +---
 arch/mips/include/asm/atomic.h           |  547 +++++++++----------------------
 arch/mn10300/include/asm/atomic.h        |  124 ++-----
 arch/parisc/include/asm/atomic.h         |  107 +++---
 arch/powerpc/include/asm/atomic.h        |  194 +++-------
 arch/sh/include/asm/atomic-grb.h         |  118 ++----
 arch/sh/include/asm/atomic-irq.h         |   63 +--
 arch/sh/include/asm/atomic-llsc.h        |  100 ++---
 arch/sparc/include/asm/atomic_32.h       |   19 -
 arch/sparc/include/asm/atomic_64.h       |   43 +-
 arch/sparc/include/asm/barrier_32.h      |    1 
 arch/sparc/include/asm/processor.h       |    2 
 arch/sparc/kernel/smp_64.c               |    2 
 arch/sparc/lib/atomic32.c                |   25 -
 arch/sparc/lib/atomic_64.S               |  159 +++------
 arch/sparc/lib/ksyms.c                   |   17 
 arch/xtensa/include/asm/atomic.h         |  227 ++++--------
 include/asm-generic/atomic.h             |  143 ++------
 30 files changed, 1341 insertions(+), 2227 deletions(-)

--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -29,145 +29,84 @@
  * branch back to restart the operation.
  */
 
-static __inline__ void atomic_add(int i, atomic_t * v)
-{
-	unsigned long temp;
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%1\n"
-	"	addl %0,%2,%0\n"
-	"	stl_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter)
-	:"Ir" (i), "m" (v->counter));
-}
-
-static __inline__ void atomic64_add(long i, atomic64_t * v)
-{
-	unsigned long temp;
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	addq %0,%2,%0\n"
-	"	stq_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter)
-	:"Ir" (i), "m" (v->counter));
-}
-
-static __inline__ void atomic_sub(int i, atomic_t * v)
-{
-	unsigned long temp;
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%1\n"
-	"	subl %0,%2,%0\n"
-	"	stl_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter)
-	:"Ir" (i), "m" (v->counter));
-}
-
-static __inline__ void atomic64_sub(long i, atomic64_t * v)
-{
-	unsigned long temp;
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	subq %0,%2,%0\n"
-	"	stq_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter)
-	:"Ir" (i), "m" (v->counter));
-}
-
-
-/*
- * Same as above, but return the result value
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	long temp, result;
-	smp_mb();
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%1\n"
-	"	addl %0,%3,%2\n"
-	"	addl %0,%3,%0\n"
-	"	stl_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter), "=&r" (result)
-	:"Ir" (i), "m" (v->counter) : "memory");
-	smp_mb();
-	return result;
-}
-
-static __inline__ long atomic64_add_return(long i, atomic64_t * v)
-{
-	long temp, result;
-	smp_mb();
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	addq %0,%3,%2\n"
-	"	addq %0,%3,%0\n"
-	"	stq_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter), "=&r" (result)
-	:"Ir" (i), "m" (v->counter) : "memory");
-	smp_mb();
-	return result;
-}
-
-static __inline__ long atomic_sub_return(int i, atomic_t * v)
-{
-	long temp, result;
-	smp_mb();
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%1\n"
-	"	subl %0,%3,%2\n"
-	"	subl %0,%3,%0\n"
-	"	stl_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter), "=&r" (result)
-	:"Ir" (i), "m" (v->counter) : "memory");
-	smp_mb();
-	return result;
-}
-
-static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
-{
-	long temp, result;
-	smp_mb();
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	subq %0,%3,%2\n"
-	"	subq %0,%3,%0\n"
-	"	stq_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (v->counter), "=&r" (result)
-	:"Ir" (i), "m" (v->counter) : "memory");
-	smp_mb();
-	return result;
-}
+#define ATOMIC_OP(op)							\
+static __inline__ void atomic_##op(int i, atomic_t * v)			\
+{									\
+	unsigned long temp;						\
+	__asm__ __volatile__(						\
+	"1:	ldl_l %0,%1\n"						\
+	"	" #op "l %0,%2,%0\n"					\
+	"	stl_c %0,%1\n"						\
+	"	beq %0,2f\n"						\
+	".subsection 2\n"						\
+	"2:	br 1b\n"						\
+	".previous"							\
+	:"=&r" (temp), "=m" (v->counter)				\
+	:"Ir" (i), "m" (v->counter));					\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	long temp, result;						\
+	smp_mb();							\
+	__asm__ __volatile__(						\
+	"1:	ldl_l %0,%1\n"						\
+	"	" #op "l %0,%3,%2\n"					\
+	"	" #op "l %0,%3,%0\n"					\
+	"	stl_c %0,%1\n"						\
+	"	beq %0,2f\n"						\
+	".subsection 2\n"						\
+	"2:	br 1b\n"						\
+	".previous"							\
+	:"=&r" (temp), "=m" (v->counter), "=&r" (result)		\
+	:"Ir" (i), "m" (v->counter) : "memory");			\
+	smp_mb();							\
+	return result;							\
+}
+
+#define ATOMIC64_OP(op)							\
+static __inline__ void atomic64_##op(long i, atomic64_t * v)		\
+{									\
+	unsigned long temp;						\
+	__asm__ __volatile__(						\
+	"1:	ldq_l %0,%1\n"						\
+	"	" #op "q %0,%2,%0\n"					\
+	"	stq_c %0,%1\n"						\
+	"	beq %0,2f\n"						\
+	".subsection 2\n"						\
+	"2:	br 1b\n"						\
+	".previous"							\
+	:"=&r" (temp), "=m" (v->counter)				\
+	:"Ir" (i), "m" (v->counter));					\
+}									\
+									\
+static __inline__ long atomic64_##op##_return(long i, atomic64_t * v)	\
+{									\
+	long temp, result;						\
+	smp_mb();							\
+	__asm__ __volatile__(						\
+	"1:	ldq_l %0,%1\n"						\
+	"	" #op "q %0,%3,%2\n"					\
+	"	" #op "q %0,%3,%0\n"					\
+	"	stq_c %0,%1\n"						\
+	"	beq %0,2f\n"						\
+	".subsection 2\n"						\
+	"2:	br 1b\n"						\
+	".previous"							\
+	:"=&r" (temp), "=m" (v->counter), "=&r" (result)		\
+	:"Ir" (i), "m" (v->counter) : "memory");			\
+	smp_mb();							\
+	return result;							\
+}
+
+#define ATOMIC_OPS(op)	ATOMIC_OP(op) ATOMIC64_OP(op)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC64_OP
+#undef ATOMIC_OP
 
 #define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -25,66 +25,41 @@
 
 #define atomic_set(v, i) (((v)->counter) = (i))
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	add     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	sub     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */	\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)							\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+									\
+	return temp;							\
 }
 
-/* add and also return the new value */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned int temp;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	add     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-
-	return temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	sub     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-
-	return temp;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 {
@@ -133,51 +108,34 @@ static inline void atomic_set(atomic_t *
  * Locking would change to irq-disabling only (UP) and spinlocks (SMP)
  */
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	v->counter += i;
-	atomic_ops_unlock(flags);
+#define ATOMIC_OP(opn, op)						\
+static inline void atomic_##opn(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	atomic_ops_lock(flags);						\
+	v->counter op i;						\
+	atomic_ops_unlock(flags);					\
+}									\
+									\
+static inline int atomic_##opn##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	unsigned long temp;						\
+									\
+	atomic_ops_lock(flags);						\
+	temp = v->counter;						\
+	temp op i;							\
+	v->counter = temp;						\
+	atomic_ops_unlock(flags);					\
+									\
+	return temp;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-	atomic_ops_lock(flags);
-	v->counter -= i;
-	atomic_ops_unlock(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	unsigned long temp;
-
-	atomic_ops_lock(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	atomic_ops_unlock(flags);
-
-	return temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	unsigned long temp;
-
-	atomic_ops_lock(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	atomic_ops_unlock(flags);
-
-	return temp;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 {
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -37,83 +37,51 @@
  * store exclusive to ensure that these are atomic.  We may loop
  * to ensure that the update happens.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	prefetchw(&v->counter);
-	__asm__ __volatile__("@ atomic_add\n"
-"1:	ldrex	%0, [%3]\n"
-"	add	%0, %0, %4\n"
-"	strex	%1, %0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "Ir" (i)
-	: "cc");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	smp_mb();
-
-	__asm__ __volatile__("@ atomic_add_return\n"
-"1:	ldrex	%0, [%3]\n"
-"	add	%0, %0, %4\n"
-"	strex	%1, %0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "Ir" (i)
-	: "cc");
-
-	smp_mb();
 
-	return result;
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	prefetchw(&v->counter);
-	__asm__ __volatile__("@ atomic_sub\n"
-"1:	ldrex	%0, [%3]\n"
-"	sub	%0, %0, %4\n"
-"	strex	%1, %0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "Ir" (i)
-	: "cc");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	prefetchw(&v->counter);						\
+	__asm__ __volatile__("@ atomic_" #op "\n"			\
+"1:	ldrex	%0, [%3]\n"						\
+"	" #op "	%0, %0, %4\n"						\
+"	strex	%1, %0, [%3]\n"						\
+"	teq	%1, #0\n"						\
+"	bne	1b"							\
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
+	: "r" (&v->counter), "Ir" (i)					\
+	: "cc");							\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	smp_mb();							\
+									\
+	__asm__ __volatile__("@ atomic_" #op "_return\n"		\
+"1:	ldrex	%0, [%3]\n"						\
+"	" #op "	%0, %0, %4\n"						\
+"	strex	%1, %0, [%3]\n"						\
+"	teq	%1, #0\n"						\
+"	bne	1b"							\
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
+	: "r" (&v->counter), "Ir" (i)					\
+	: "cc");							\
+									\
+	smp_mb();							\
+									\
+	return result;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	smp_mb();
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	__asm__ __volatile__("@ atomic_sub_return\n"
-"1:	ldrex	%0, [%3]\n"
-"	sub	%0, %0, %4\n"
-"	strex	%1, %0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "Ir" (i)
-	: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
@@ -144,33 +112,33 @@ static inline int atomic_cmpxchg(atomic_
 #error SMP not supported on pre-ARMv6 CPUs
 #endif
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int val;
-
-	raw_local_irq_save(flags);
-	val = v->counter;
-	v->counter = val += i;
-	raw_local_irq_restore(flags);
-
-	return val;
+#define ATOMIC_OP(opn, op)						\
+static inline void atomic_##opn(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter op i;						\
+	raw_local_irq_restore(flags);					\
+}									\
+									\
+static inline int atomic_##opn##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int val;							\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter op i;						\
+	val = v->counter;						\
+	raw_local_irq_restore(flags);					\
+									\
+	return val;							\
 }
-#define atomic_add(i, v)	(void) atomic_add_return(i, v)
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int val;
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-	raw_local_irq_save(flags);
-	val = v->counter;
-	v->counter = val -= i;
-	raw_local_irq_restore(flags);
-
-	return val;
-}
-#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
@@ -270,87 +238,52 @@ static inline void atomic64_set(atomic64
 }
 #endif
 
-static inline void atomic64_add(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	prefetchw(&v->counter);
-	__asm__ __volatile__("@ atomic64_add\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	adds	%Q0, %Q0, %Q4\n"
-"	adc	%R0, %R0, %R4\n"
-"	strexd	%1, %0, %H0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	: "cc");
+#define ATOMIC64_OP(opn, op1, op2)					\
+static inline void atomic64_##opn(long long i, atomic64_t *v)		\
+{									\
+	long long result;						\
+	unsigned long tmp;						\
+									\
+	prefetchw(&v->counter);						\
+	__asm__ __volatile__("@ atomic64_" #opn "\n"			\
+"1:	ldrexd	%0, %H0, [%3]\n"					\
+"	" #op1 " %Q0, %Q0, %Q4\n"					\
+"	" #op2 " %R0, %R0, %R4\n"					\
+"	strexd	%1, %0, %H0, [%3]\n"					\
+"	teq	%1, #0\n"						\
+"	bne	1b"							\
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
+	: "r" (&v->counter), "r" (i)					\
+	: "cc");							\
+}									\
+									\
+static inline long long atomic64_##opn##_return(long long i, atomic64_t *v) \
+{									\
+	long long result;						\
+	unsigned long tmp;						\
+									\
+	smp_mb();							\
+									\
+	__asm__ __volatile__("@ atomic64_" #opn "_return\n"		\
+"1:	ldrexd	%0, %H0, [%3]\n"					\
+"	" #op1 " %Q0, %Q0, %Q4\n"					\
+"	" #op2 " %R0, %R0, %R4\n"					\
+"	strexd	%1, %0, %H0, [%3]\n"					\
+"	teq	%1, #0\n"						\
+"	bne	1b"							\
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
+	: "r" (&v->counter), "r" (i)					\
+	: "cc");							\
+									\
+	smp_mb();							\
+									\
+	return result;							\
 }
 
-static inline long long atomic64_add_return(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	smp_mb();
-
-	__asm__ __volatile__("@ atomic64_add_return\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	adds	%Q0, %Q0, %Q4\n"
-"	adc	%R0, %R0, %R4\n"
-"	strexd	%1, %0, %H0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	: "cc");
+ATOMIC64_OP(add, adds, adc)
+ATOMIC64_OP(sub, subs, sbc)
 
-	smp_mb();
-
-	return result;
-}
-
-static inline void atomic64_sub(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	prefetchw(&v->counter);
-	__asm__ __volatile__("@ atomic64_sub\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	subs	%Q0, %Q0, %Q4\n"
-"	sbc	%R0, %R0, %R4\n"
-"	strexd	%1, %0, %H0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	: "cc");
-}
-
-static inline long long atomic64_sub_return(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	smp_mb();
-
-	__asm__ __volatile__("@ atomic64_sub_return\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	subs	%Q0, %Q0, %Q4\n"
-"	sbc	%R0, %R0, %R4\n"
-"	strexd	%1, %0, %H0, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#undef ATOMIC64_OP
 
 static inline long long atomic64_cmpxchg(atomic64_t *ptr, long long old,
 					long long new)
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -43,71 +43,45 @@
  * store exclusive to ensure that these are atomic.  We may loop
  * to ensure that the update happens.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_add\n"
-"1:	ldxr	%w0, %2\n"
-"	add	%w0, %w0, %w3\n"
-"	stxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_add_return\n"
-"1:	ldxr	%w0, %2\n"
-"	add	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc", "memory");
-
-	smp_mb();
-	return result;
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
 
-	asm volatile("// atomic_sub\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "\n"				\
+"1:	ldxr	%w0, %2\n"						\
+"	" #op "	%w0, %w0, %w3\n"					\
+"	stxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "cc");							\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "_return\n"			\
+"1:	ldxr	%w0, %2\n"						\
+"	" #op "	%w0, %w0, %w3\n"					\
+"	stlxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "cc", "memory");						\
+									\
+	smp_mb();							\
+	return result;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	asm volatile("// atomic_sub_return\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc", "memory");
-
-	smp_mb();
-	return result;
-}
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
@@ -162,71 +136,44 @@ static inline int __atomic_add_unless(at
 #define atomic64_read(v)	(*(volatile long long *)&(v)->counter)
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
-static inline void atomic64_add(u64 i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_add\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc");
+#define ATOMIC64_OP(op)							\
+static inline void atomic64_##op(long i, atomic64_t *v)			\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "\n"				\
+"1:	ldxr	%0, %2\n"						\
+"	" #op "	%0, %0, %3\n"						\
+"	stxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "cc");							\
+}									\
+									\
+static inline long atomic64_##op##_return(long i, atomic64_t *v)	\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "_return\n"			\
+"1:	ldxr	%0, %2\n"						\
+"	" #op "	%0, %0, %3\n"						\
+"	stlxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "cc", "memory");						\
+									\
+	smp_mb();							\
+	return result;							\
 }
 
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_add_return\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc", "memory");
+ATOMIC64_OP(add)
+ATOMIC64_OP(sub)
 
-	smp_mb();
-	return result;
-}
-
-static inline void atomic64_sub(u64 i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_sub\n"
-"1:	ldxr	%0, %2\n"
-"	sub	%0, %0, %3\n"
-"	stxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc");
-}
-
-static inline long atomic64_sub_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_sub_return\n"
-"1:	ldxr	%0, %2\n"
-"	sub	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "cc", "memory");
-
-	smp_mb();
-	return result;
-}
+#undef ATOMIC64_OP
 
 static inline long atomic64_cmpxchg(atomic64_t *ptr, long old, long new)
 {
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -22,58 +22,45 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-/*
- * atomic_sub_return - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v. Returns the resulting value.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result;
-
-	asm volatile(
-		"/* atomic_sub_return */\n"
-		"1:	ssrf	5\n"
-		"	ld.w	%0, %2\n"
-		"	sub	%0, %3\n"
-		"	stcond	%1, %0\n"
-		"	brne	1b"
-		: "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(i)
-		: "cc");
-
-	return result;
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int result;							\
+									\
+	asm volatile(							\
+		"/* atomic_" #op " */\n"				\
+		"1:	ssrf	5\n"					\
+		"	ld.w	%0, %2\n"				\
+		"	" #op "	%0, %3\n"				\
+		"	stcond	%1, %0\n"				\
+		"	brne	1b"					\
+		: "=&r"(result), "=o"(v->counter)			\
+		: "m"(v->counter), "rKs21"(i)				\
+		: "cc");						\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result;							\
+									\
+	asm volatile(							\
+		"/* atomic_" #op "_return */\n"				\
+		"1:	ssrf	5\n"					\
+		"	ld.w	%0, %2\n"				\
+		"	" #op "	%0, %3\n"				\
+		"	stcond	%1, %0\n"				\
+		"	brne	1b"					\
+		: "=&r"(result), "=o"(v->counter)			\
+		: "m"(v->counter), "rKs21"(i)				\
+		: "cc");						\
+									\
+	return result;							\
 }
 
-/*
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v. Returns the resulting value.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int result;
-
-	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
-		result = atomic_sub_return(-i, v);
-	else
-		asm volatile(
-			"/* atomic_add_return */\n"
-			"1:	ssrf	5\n"
-			"	ld.w	%0, %1\n"
-			"	add	%0, %3\n"
-			"	stcond	%2, %0\n"
-			"	brne	1b"
-			: "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(i)
-			: "cc", "memory");
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	return result;
-}
+#undef ATOMIC_OP
 
 /*
  * atomic_sub_unless - sub unless the number is a given value
@@ -168,8 +155,6 @@ static inline int atomic_sub_if_positive
 #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
 #define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
 
-#define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
-#define atomic_add(i, v)	(void)atomic_add_return(i, v)
 #define atomic_dec(v)		atomic_sub(1, (v))
 #define atomic_inc(v)		atomic_add(1, (v))
 
--- a/arch/cris/include/arch-v10/arch/system.h
+++ b/arch/cris/include/arch-v10/arch/system.h
@@ -36,8 +36,6 @@ static inline unsigned long _get_base(ch
   return 0;
 }
 
-#define nop() __asm__ __volatile__ ("nop");
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 #define tas(ptr) (xchg((ptr),1))
 
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -21,44 +21,32 @@
 
 /* These should be written in asm but we do it in C for now. */
 
-static inline void atomic_add(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	cris_atomic_save(v, flags);
-	v->counter += i;
-	cris_atomic_restore(v, flags);
+#define ATOMIC_OP(opn, op)						\
+static inline void atomic_##opn(int i, volatile atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	cris_atomic_save(v, flags);					\
+	v->counter op i;						\
+	cris_atomic_restore(v, flags);					\
+}									\
+									\
+static inline int atomic_##opn##_return(int i, volatile atomic_t *v)	\
+{									\
+	unsigned long flags;						\
+	int retval;							\
+	cris_atomic_save(v, flags);					\
+	retval = (v->counter op i);					\
+	cris_atomic_restore(v, flags);					\
+	return retval;							\
 }
 
-static inline void atomic_sub(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	cris_atomic_save(v, flags);
-	v->counter -= i;
-	cris_atomic_restore(v, flags);
-}
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-static inline int atomic_add_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter += i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
+#undef ATOMIC_OP
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
-static inline int atomic_sub_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter -= i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
-
 static inline int atomic_sub_and_test(int i, volatile atomic_t *v)
 {
 	int retval;
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -81,41 +81,42 @@ static inline int atomic_cmpxchg(atomic_
 	return __oldval;
 }
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int output;
-
-	__asm__ __volatile__ (
-		"1:	%0 = memw_locked(%1);\n"
-		"	%0 = add(%0,%2);\n"
-		"	memw_locked(%1,P3)=%0;\n"
-		"	if !P3 jump 1b;\n"
-		: "=&r" (output)
-		: "r" (&v->counter), "r" (i)
-		: "memory", "p3"
-	);
-	return output;
-
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int output;							\
+									\
+	__asm__ __volatile__ (						\
+		"1:	%0 = memw_locked(%1);\n"			\
+		"	%0 = "#op "(%0,%2);\n"				\
+		"	memw_locked(%1,P3)=%0;\n"			\
+		"	if !P3 jump 1b;\n"				\
+		: "=&r" (output)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory", "p3"					\
+	);								\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int output;							\
+									\
+	__asm__ __volatile__ (						\
+		"1:	%0 = memw_locked(%1);\n"			\
+		"	%0 = "#op "(%0,%2);\n"				\
+		"	memw_locked(%1,P3)=%0;\n"			\
+		"	if !P3 jump 1b;\n"				\
+		: "=&r" (output)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory", "p3"					\
+	);								\
+	return output;							\
 }
 
-#define atomic_add(i, v) atomic_add_return(i, (v))
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int output;
-	__asm__ __volatile__ (
-		"1:	%0 = memw_locked(%1);\n"
-		"	%0 = sub(%0,%2);\n"
-		"	memw_locked(%1,P3)=%0\n"
-		"	if !P3 jump 1b;\n"
-		: "=&r" (output)
-		: "r" (&v->counter), "r" (i)
-		: "memory", "p3"
-	);
-	return output;
-}
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-#define atomic_sub(i, v) atomic_sub_return(i, (v))
+#undef ATOMIC_OP
 
 /**
  * __atomic_add_unless - add unless the number is a given value
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -26,61 +26,93 @@
 #define atomic_set(v,i)		(((v)->counter) = (i))
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
-static __inline__ int
-ia64_atomic_add (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
+#define ATOMIC_OP(opn, op)						\
+static __inline__ int							\
+ia64_atomic_##opn (int i, atomic_t *v)					\
+{									\
+	__s32 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic_read(v);					\
+		new = old op i;						\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old); \
+	return new;							\
 }
 
-static __inline__ long
-ia64_atomic64_add (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
+ATOMIC_OP(add, +)
+ATOMIC_OP(sub, -)
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
+#undef ATOMIC_OP
 
-static __inline__ int
-ia64_atomic_sub (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
+#define atomic_add_return(i,v)						\
+({									\
+	int __ia64_aar_i = (i);						\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
+	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
+	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
+	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
+		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
+		: ia64_atomic_add(__ia64_aar_i, v);			\
+})
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
+#define atomic_sub_return(i,v)						\
+({									\
+	int __ia64_asr_i = (i);						\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
+	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
+	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
+	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
+		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
+		: ia64_atomic_sub(__ia64_asr_i, v);			\
+})
+
+#define ATOMIC64_OP(opn, op)						\
+static __inline__ long							\
+ia64_atomic64_##opn (__s64 i, atomic64_t *v)				\
+{									\
+	__s64 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic64_read(v);					\
+		new = old op i;						\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old); \
+	return new;							\
 }
 
-static __inline__ long
-ia64_atomic64_sub (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
+ATOMIC64_OP(add, +)
+ATOMIC64_OP(sub, -)
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
+#undef ATOMIC64_OP
+
+#define atomic64_add_return(i,v)					\
+({									\
+	long __ia64_aar_i = (i);					\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
+	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
+	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
+	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
+		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
+		: ia64_atomic64_add(__ia64_aar_i, v);			\
+})
+
+#define atomic64_sub_return(i,v)					\
+({									\
+	long __ia64_asr_i = (i);					\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
+	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
+	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
+	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
+		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
+		: ia64_atomic64_sub(__ia64_asr_i, v);			\
+})
 
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
@@ -122,30 +154,6 @@ static __inline__ long atomic64_add_unle
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#define atomic_add_return(i,v)						\
-({									\
-	int __ia64_aar_i = (i);						\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
-	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
-	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
-	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
-		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
-		: ia64_atomic_add(__ia64_aar_i, v);			\
-})
-
-#define atomic64_add_return(i,v)					\
-({									\
-	long __ia64_aar_i = (i);					\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
-	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
-	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
-	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
-		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
-		: ia64_atomic64_add(__ia64_aar_i, v);			\
-})
-
 /*
  * Atomically add I to V and return TRUE if the resulting value is
  * negative.
@@ -162,30 +170,6 @@ atomic64_add_negative (__s64 i, atomic64
 	return atomic64_add_return(i, v) < 0;
 }
 
-#define atomic_sub_return(i,v)						\
-({									\
-	int __ia64_asr_i = (i);						\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
-	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
-	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
-	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
-		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
-		: ia64_atomic_sub(__ia64_asr_i, v);			\
-})
-
-#define atomic64_sub_return(i,v)					\
-({									\
-	long __ia64_asr_i = (i);					\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
-	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
-	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
-	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
-		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
-		: ia64_atomic64_sub(__ia64_asr_i, v);			\
-})
-
 #define atomic_dec_return(v)		atomic_sub_return(1, (v))
 #define atomic_inc_return(v)		atomic_add_return(1, (v))
 #define atomic64_dec_return(v)		atomic64_sub_return(1, (v))
@@ -198,13 +182,13 @@ atomic64_add_negative (__s64 i, atomic64
 #define atomic64_dec_and_test(v)	(atomic64_sub_return(1, (v)) == 0)
 #define atomic64_inc_and_test(v)	(atomic64_add_return(1, (v)) == 0)
 
-#define atomic_add(i,v)			atomic_add_return((i), (v))
-#define atomic_sub(i,v)			atomic_sub_return((i), (v))
+#define atomic_add(i,v)			(void)atomic_add_return((i), (v))
+#define atomic_sub(i,v)			(void)atomic_sub_return((i), (v))
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
 
-#define atomic64_add(i,v)		atomic64_add_return((i), (v))
-#define atomic64_sub(i,v)		atomic64_sub_return((i), (v))
+#define atomic64_add(i,v)		(void)atomic64_add_return((i), (v))
+#define atomic64_sub(i,v)		(void)atomic64_sub_return((i), (v))
 #define atomic64_inc(v)			atomic64_add(1, (v))
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -39,85 +39,59 @@
  */
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
-/**
- * atomic_add_return - add integer to atomic variable and return it
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and return (@i + @v).
- */
-static __inline__ int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int result;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# atomic_add_return		\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		M32R_LOCK" %0, @%1;		\n\t"
-		"add	%0, %2;			\n\t"
-		M32R_UNLOCK" %0, @%1;		\n\t"
-		: "=&r" (result)
-		: "r" (&v->counter), "r" (i)
-		: "memory"
 #ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	return result;
+#define __ATOMIC_CLOBBER	, "r4"
+#else
+#define __ATOMIC_CLOBBER
+#endif
+
+#define ATOMIC_OP(op)							\
+static __inline__ void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+	int result;							\
+									\
+	local_irq_save(flags);						\
+	__asm__ __volatile__ (						\
+		"# atomic_" #op "		\n\t"			\
+		DCACHE_CLEAR("%0", "r4", "%1")				\
+		M32R_LOCK" %0, @%1;		\n\t"			\
+		#op " %0, %2;			\n\t"			\
+		M32R_UNLOCK" %0, @%1;		\n\t"			\
+		: "=&r" (result)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory"						\
+		__ATOMIC_CLOBBER					\
+	);								\
+	local_irq_restore(flags);					\
+}									\
+									\
+static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int result;							\
+									\
+	local_irq_save(flags);						\
+	__asm__ __volatile__ (						\
+		"# atomic_" #op "_return	\n\t"			\
+		DCACHE_CLEAR("%0", "r4", "%1")				\
+		M32R_LOCK" %0, @%1;		\n\t"			\
+		#op " %0, %2;			\n\t"			\
+		M32R_UNLOCK" %0, @%1;		\n\t"			\
+		: "=&r" (result)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory"						\
+		__ATOMIC_CLOBBER					\
+	);								\
+	local_irq_restore(flags);					\
+									\
+	return result;							\
 }
 
-/**
- * atomic_sub_return - subtract integer from atomic variable and return it
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and return (@v - @i).
- */
-static __inline__ int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int result;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# atomic_sub_return		\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		M32R_LOCK" %0, @%1;		\n\t"
-		"sub	%0, %2;			\n\t"
-		M32R_UNLOCK" %0, @%1;		\n\t"
-		: "=&r" (result)
-		: "r" (&v->counter), "r" (i)
-		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	return result;
-}
-
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-#define atomic_add(i,v) ((void) atomic_add_return((i), (v)))
-
-/**
- * atomic_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-#define atomic_sub(i,v) ((void) atomic_sub_return((i), (v)))
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
@@ -151,9 +125,7 @@ static __inline__ int atomic_inc_return(
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -181,9 +153,7 @@ static __inline__ int atomic_dec_return(
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -280,9 +250,7 @@ static __inline__ void atomic_clear_mask
 		: "=&r" (tmp)
 		: "r" (addr), "r" (~mask)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r5"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 }
@@ -302,9 +270,7 @@ static __inline__ void atomic_set_mask(u
 		: "=&r" (tmp)
 		: "r" (addr), "r" (mask)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r5"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 }
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -30,16 +30,55 @@
 #define	ASM_DI	"di"
 #endif
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__asm__ __volatile__("addl %1,%0" : "+m" (*v) : ASM_DI (i));
-}
+#ifdef CONFIG_RMW_INSNS
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
+#define ATOMIC_OP(op, cop)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#op "l %1,%0" : "+m" (*v) : ASM_DI (i));	\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int t, tmp;							\
+									\
+	__asm__ __volatile__(						\
+			"1:	movel %2,%1\n"				\
+			"	" #op "l %3,%1\n"			\
+			"	casl %2,%1,%0\n"			\
+			"	jne 1b"					\
+			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
+			: "g" (i), "2" (atomic_read(v)));		\
+	return t;							\
+}
+
+#else
+
+#define ATOMIC_OP(op, cop)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#op "l %1,%0" : "+m" (*v) : ASM_DI (i));	\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long flags;						\
+	int t;								\
+									\
+	local_irq_save(flags);						\
+	t = (v->counter cop i);						\
+	local_irq_restore(flags);					\
+									\
+	return t;							\
 }
 
+#endif /* CONFIG_RMW_INSNS */
+
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
+
+#undef ATOMIC_OP
+
 static inline void atomic_inc(atomic_t *v)
 {
 	__asm__ __volatile__("addql #1,%0" : "+m" (*v));
@@ -76,67 +115,11 @@ static inline int atomic_inc_and_test(at
 
 #ifdef CONFIG_RMW_INSNS
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	addl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	subl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 #else /* !CONFIG_RMW_INSNS */
 
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t += i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t -= i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	unsigned long flags;
--- a/arch/metag/include/asm/atomic_lnkget.h
+++ b/arch/metag/include/asm/atomic_lnkget.h
@@ -27,85 +27,51 @@ static inline int atomic_read(const atom
 	return temp;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	ADD	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	SUB	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int result, temp;
-
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	ADD	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-
-	smp_mb();
-
-	return result;
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int temp;							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %0, [%1]\n"				\
+		"	" #op "	%0, %0, %2\n"				\
+		"	LNKSETD [%1], %0\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ	1b\n"					\
+		: "=&d" (temp)						\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result, temp;						\
+									\
+	smp_mb();							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %1, [%2]\n"				\
+		"	" #op "	%1, %1, %3\n"				\
+		"	LNKSETD [%2], %1\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ 1b\n"					\
+		: "=&d" (temp), "=&da" (result)				\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+									\
+	smp_mb();							\
+									\
+	return result;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result, temp;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	SUB	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/metag/include/asm/atomic_lock1.h
+++ b/arch/metag/include/asm/atomic_lock1.h
@@ -37,55 +37,36 @@ static inline int atomic_set(atomic_t *v
 	return i;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter += i;
-	__global_unlock1(flags);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter -= i;
-	__global_unlock1(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
-
-	__global_lock1(flags);
-	result = v->counter;
-	result += i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
-
-	return result;
+#define ATOMIC_OP(opn, op)						\
+static inline void atomic_##opn(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	fence();							\
+	v->counter op i;						\
+	__global_unlock1(flags);					\
+}									\
+									\
+static inline int atomic_##opn##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long result;						\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	result = v->counter;						\
+	result op i;							\
+	fence();							\
+	v->counter = result;						\
+	__global_unlock1(flags);					\
+									\
+	return result;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
-
-	__global_lock1(flags);
-	result = v->counter;
-	result -= i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-	return result;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -40,195 +40,96 @@
  */
 #define atomic_set(v, i)		((v)->counter = (i))
 
-/*
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static __inline__ void atomic_add(int i, atomic_t * v)
-{
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		int temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%0, %1		# atomic_add		\n"
-		"	addu	%0, %2					\n"
-		"	sc	%0, %1					\n"
-		"	beqzl	%0, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		int temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	ll	%0, %1		# atomic_add	\n"
-			"	addu	%0, %2				\n"
-			"	sc	%0, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!temp));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		v->counter += i;
-		raw_local_irq_restore(flags);
-	}
+#define ATOMIC_OP(op, aop, cop)							\
+static __inline__ void atomic_##op(int i, atomic_t * v)				\
+{										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		int temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	mips3					\n"	\
+		"1:	ll	%0, %1		# atomic_" #op "	\n"	\
+		"	" #aop " %0, %2					\n"	\
+		"	sc	%0, %1					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (temp), "+m" (v->counter)				\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		int temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	mips3				\n"	\
+			"	ll	%0, %1		# atomic_" #op "\n"	\
+			"	" #aop " %0, %2				\n"	\
+			"	sc	%0, %1				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (temp), "+m" (v->counter)			\
+			: "Ir" (i));						\
+		} while (unlikely(!temp));					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		v->counter cop i;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+}										\
+										\
+static __inline__ int atomic_##op##_return(int i, atomic_t * v)			\
+{										\
+	int result;								\
+										\
+	smp_mb__before_llsc();							\
+										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		int temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	mips3					\n"	\
+		"1:	ll	%1, %2		# atomic_" #op "_return	\n"	\
+		"	" #aop " %0, %1, %3				\n"	\
+		"	sc	%0, %2					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	addu	%0, %1, %3				\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		int temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	mips3				\n"	\
+			"	ll	%1, %2	# atomic_" #op "_return	\n"	\
+			"	" #aop " %0, %1, %3			\n"	\
+			"	sc	%0, %2				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (result), "=&r" (temp), "+m" (v->counter)	\
+			: "Ir" (i));						\
+		} while (unlikely(!result));					\
+										\
+		result = temp + i;						\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		result = v->counter;						\
+		result cop i;							\
+		v->counter = result;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+										\
+	smp_llsc_mb();								\
+										\
+	return result;								\
 }
 
-/*
- * atomic_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static __inline__ void atomic_sub(int i, atomic_t * v)
-{
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		int temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%0, %1		# atomic_sub		\n"
-		"	subu	%0, %2					\n"
-		"	sc	%0, %1					\n"
-		"	beqzl	%0, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		int temp;
+ATOMIC_OP(add, addu, +=)
+ATOMIC_OP(sub, subu, -=)
 
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	ll	%0, %1		# atomic_sub	\n"
-			"	subu	%0, %2				\n"
-			"	sc	%0, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!temp));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		v->counter -= i;
-		raw_local_irq_restore(flags);
-	}
-}
-
-/*
- * Same as above, but return the result value
- */
-static __inline__ int atomic_add_return(int i, atomic_t * v)
-{
-	int result;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		int temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# atomic_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		int temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	ll	%1, %2	# atomic_add_return	\n"
-			"	addu	%0, %1, %3			\n"
-			"	sc	%0, %2				\n"
-			"	.set	mips0				\n"
-			: "=&r" (result), "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!result));
-
-		result = temp + i;
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		result = v->counter;
-		result += i;
-		v->counter = result;
-		raw_local_irq_restore(flags);
-	}
-
-	smp_llsc_mb();
-
-	return result;
-}
-
-static __inline__ int atomic_sub_return(int i, atomic_t * v)
-{
-	int result;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		int temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# atomic_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
-		: "Ir" (i), "m" (v->counter)
-		: "memory");
-
-		result = temp - i;
-	} else if (kernel_uses_llsc) {
-		int temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	ll	%1, %2	# atomic_sub_return	\n"
-			"	subu	%0, %1, %3			\n"
-			"	sc	%0, %2				\n"
-			"	.set	mips0				\n"
-			: "=&r" (result), "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!result));
-
-		result = temp - i;
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		result = v->counter;
-		result -= i;
-		v->counter = result;
-		raw_local_irq_restore(flags);
-	}
-
-	smp_llsc_mb();
-
-	return result;
-}
+#undef ATOMIC_OP
 
 /*
  * atomic_sub_if_positive - conditionally subtract integer from atomic variable
@@ -407,195 +308,97 @@ static __inline__ int __atomic_add_unles
  */
 #define atomic64_set(v, i)	((v)->counter = (i))
 
-/*
- * atomic64_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic64_t
- *
- * Atomically adds @i to @v.
- */
-static __inline__ void atomic64_add(long i, atomic64_t * v)
-{
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	lld	%0, %1		# atomic64_add		\n"
-		"	daddu	%0, %2					\n"
-		"	scd	%0, %1					\n"
-		"	beqzl	%0, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		long temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	lld	%0, %1		# atomic64_add	\n"
-			"	daddu	%0, %2				\n"
-			"	scd	%0, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!temp));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		v->counter += i;
-		raw_local_irq_restore(flags);
-	}
-}
-
-/*
- * atomic64_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic64_t
- *
- * Atomically subtracts @i from @v.
- */
-static __inline__ void atomic64_sub(long i, atomic64_t * v)
-{
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	lld	%0, %1		# atomic64_sub		\n"
-		"	dsubu	%0, %2					\n"
-		"	scd	%0, %1					\n"
-		"	beqzl	%0, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		long temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	lld	%0, %1		# atomic64_sub	\n"
-			"	dsubu	%0, %2				\n"
-			"	scd	%0, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (temp), "+m" (v->counter)
-			: "Ir" (i));
-		} while (unlikely(!temp));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		v->counter -= i;
-		raw_local_irq_restore(flags);
-	}
-}
-
-/*
- * Same as above, but return the result value
- */
-static __inline__ long atomic64_add_return(long i, atomic64_t * v)
-{
-	long result;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# atomic64_add_return	\n"
-		"	daddu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	daddu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "+m" (v->counter)
-		: "Ir" (i));
-	} else if (kernel_uses_llsc) {
-		long temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	lld	%1, %2	# atomic64_add_return	\n"
-			"	daddu	%0, %1, %3			\n"
-			"	scd	%0, %2				\n"
-			"	.set	mips0				\n"
-			: "=&r" (result), "=&r" (temp), "=m" (v->counter)
-			: "Ir" (i), "m" (v->counter)
-			: "memory");
-		} while (unlikely(!result));
-
-		result = temp + i;
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		result = v->counter;
-		result += i;
-		v->counter = result;
-		raw_local_irq_restore(flags);
-	}
-
-	smp_llsc_mb();
-
-	return result;
+#define ATOMIC64_OP(op, aop, cop)						\
+static __inline__ void atomic64_##op(long i, atomic64_t * v)			\
+{										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		long temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	mips3					\n"	\
+		"1:	lld	%0, %1		# atomic64_" #op "	\n"	\
+		"	" #aop " %0, %2					\n"	\
+		"	scd	%0, %1					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (temp), "+m" (v->counter)				\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		long temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	mips3				\n"	\
+			"	lld	%0, %1		# atomic64_" #op "\n"	\
+			"	" #aop " %0, %2				\n"	\
+			"	scd	%0, %1				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (temp), "+m" (v->counter)			\
+			: "Ir" (i));						\
+		} while (unlikely(!temp));					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		v->counter cop i;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+}										\
+										\
+static __inline__ long atomic64_##op##_return(long i, atomic64_t * v)		\
+{										\
+	long result;								\
+										\
+	smp_mb__before_llsc();							\
+										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		long temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	mips3					\n"	\
+		"1:	lld	%1, %2		# atomic64_" #op "_return\n"	\
+		"	" #aop " %0, %1, %3				\n"	\
+		"	scd	%0, %2					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	" #aop " %0, %1, %3				\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		long temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	mips3				\n"	\
+			"	lld	%1, %2	# atomic64_" #op "_return\n"	\
+			"	" #aop " %0, %1, %3			\n"	\
+			"	scd	%0, %2				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (result), "=&r" (temp), "=m" (v->counter)	\
+			: "Ir" (i), "m" (v->counter)				\
+			: "memory");						\
+		} while (unlikely(!result));					\
+										\
+		result = temp + i;						\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		result = v->counter;						\
+		result cop i;							\
+		v->counter = result;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+										\
+	smp_llsc_mb();								\
+										\
+	return result;								\
 }
 
-static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
-{
-	long result;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# atomic64_sub_return	\n"
-		"	dsubu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	dsubu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
-		: "Ir" (i), "m" (v->counter)
-		: "memory");
-	} else if (kernel_uses_llsc) {
-		long temp;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	lld	%1, %2	# atomic64_sub_return	\n"
-			"	dsubu	%0, %1, %3			\n"
-			"	scd	%0, %2				\n"
-			"	.set	mips0				\n"
-			: "=&r" (result), "=&r" (temp), "=m" (v->counter)
-			: "Ir" (i), "m" (v->counter)
-			: "memory");
-		} while (unlikely(!result));
+ATOMIC64_OP(add, daddu, +=)
+ATOMIC64_OP(sub, dsubu, -=)
 
-		result = temp - i;
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		result = v->counter;
-		result -= i;
-		v->counter = result;
-		raw_local_irq_restore(flags);
-	}
-
-	smp_llsc_mb();
-
-	return result;
-}
+#undef ATOMIC64_OP
 
 /*
  * atomic64_sub_if_positive - conditionally subtract integer from atomic variable
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -33,7 +33,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_read(v)	(ACCESS_ONCE((v)->counter))
 
@@ -43,102 +42,57 @@
  * @i: required value
  *
  * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	add	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
-
-#else
-	unsigned long flags;
-
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval += i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
 	return retval;
 }
 
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	sub	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
-
-#else
-	unsigned long flags;
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval -= i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
-	return retval;
-}
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
+
+#undef ATOMIC_OP
 
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	return atomic_add_return(i, v) < 0;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
 static inline void atomic_inc(atomic_t *v)
 {
 	atomic_add_return(1, v);
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -55,24 +55,7 @@ extern arch_spinlock_t __atomic_hash[ATO
  * are atomic, so a reader never sees inconsistent values.
  */
 
-/* It's possible to reduce all atomic operations to either
- * __atomic_add_return, atomic_set and atomic_read (the latter
- * is there only for consistency).
- */
-
-static __inline__ int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
-
-	ret = (v->counter += i);
-
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
-
-static __inline__ void atomic_set(atomic_t *v, int i) 
+static __inline__ void atomic_set(atomic_t *v, int i)
 {
 	unsigned long flags;
 	_atomic_spin_lock_irqsave(v, flags);
@@ -115,16 +98,38 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
+#define ATOMIC_OP(op, cop)						\
+static __inline__ void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter cop i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+									\
+static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter cop i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
+
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-#define atomic_add(i,v)	((void)(__atomic_add_return(        (i),(v))))
-#define atomic_sub(i,v)	((void)(__atomic_add_return(-((int) (i)),(v))))
-#define atomic_inc(v)	((void)(__atomic_add_return(   1,(v))))
-#define atomic_dec(v)	((void)(__atomic_add_return(  -1,(v))))
-
-#define atomic_add_return(i,v)	(__atomic_add_return( (i),(v)))
-#define atomic_sub_return(i,v)	(__atomic_add_return(-(i),(v)))
-#define atomic_inc_return(v)	(__atomic_add_return(   1,(v)))
-#define atomic_dec_return(v)	(__atomic_add_return(  -1,(v)))
+#undef ATOMIC_OP
+
+#define atomic_inc(v)	(atomic_add(   1,(v)))
+#define atomic_dec(v)	(atomic_add(  -1,(v)))
+
+#define atomic_inc_return(v)	(atomic_add_return(   1,(v)))
+#define atomic_dec_return(v)	(atomic_add_return(  -1,(v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
@@ -148,18 +153,32 @@ static __inline__ int __atomic_add_unles
 
 #define ATOMIC64_INIT(i) { (i) }
 
-static __inline__ s64
-__atomic64_add_return(s64 i, atomic64_t *v)
-{
-	s64 ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
+#define ATOMIC64_OP(op, cop)						\
+static __inline__ void atomic64_##op(s64 i, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter cop i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+									\
+static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\
+{									\
+	unsigned long flags;						\
+	s64 ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter cop i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
 
-	ret = (v->counter += i);
+ATOMIC64_OP(add, +=)
+ATOMIC64_OP(sub, -=)
 
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
+#undef ATOMIC64_OP
 
 static __inline__ void
 atomic64_set(atomic64_t *v, s64 i)
@@ -178,15 +197,11 @@ atomic64_read(const atomic64_t *v)
 	return (*(volatile long *)&(v)->counter);
 }
 
-#define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)(i)),(v))))
-#define atomic64_sub(i,v)	((void)(__atomic64_add_return(-((s64)(i)),(v))))
-#define atomic64_inc(v)		((void)(__atomic64_add_return(   1,(v))))
-#define atomic64_dec(v)		((void)(__atomic64_add_return(  -1,(v))))
-
-#define atomic64_add_return(i,v)	(__atomic64_add_return( ((s64)(i)),(v)))
-#define atomic64_sub_return(i,v)	(__atomic64_add_return(-((s64)(i)),(v)))
-#define atomic64_inc_return(v)		(__atomic64_add_return(   1,(v)))
-#define atomic64_dec_return(v)		(__atomic64_add_return(  -1,(v)))
+#define atomic64_inc(v)		(atomic64_add(   1,(v)))
+#define atomic64_dec(v)		(atomic64_add(  -1,(v)))
+
+#define atomic64_inc_return(v)		(atomic64_add_return(   1,(v)))
+#define atomic64_dec_return(v)		(atomic64_add_return(  -1,(v)))
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -26,76 +26,48 @@ static __inline__ void atomic_set(atomic
 	__asm__ __volatile__("stw%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
 }
 
-static __inline__ void atomic_add(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%3		# atomic_add\n\
-	add	%0,%2,%0\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
+#define ATOMIC_OP(op, aop)						\
+static __inline__ void atomic_##op(int a, atomic_t *v)			\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	lwarx	%0,0,%3		# atomic_" #op "\n"			\
+	#aop " %0,%2,%0\n"						\
+	PPC405_ERR77(0,%3)						\
+"	stwcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
+}									\
+									\
+static __inline__ int atomic_##op##_return(int a, atomic_t *v)		\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	lwarx	%0,0,%2		# atomic_" #op "_return\n"		\
+	#aop " %0,%1,%0\n"						\
+	PPC405_ERR77(0,%2)						\
+"	stwcx.	%0,0,%2 \n"						\
+"	bne-	1b\n"							\
+	PPC_ATOMIC_EXIT_BARRIER						\
+	: "=&r" (t)							\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc", "memory");						\
+									\
+	return t;							\
 }
 
-static __inline__ int atomic_add_return(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	lwarx	%0,0,%2		# atomic_add_return\n\
-	add	%0,%1,%0\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
+ATOMIC_OP(add, add)
+ATOMIC_OP(sub, subf)
 
-	return t;
-}
+#undef ATOMIC_OP
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
-static __inline__ void atomic_sub(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%3		# atomic_sub\n\
-	subf	%0,%2,%0\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ int atomic_sub_return(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	lwarx	%0,0,%2		# atomic_sub_return\n\
-	subf	%0,%1,%0\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
-
 static __inline__ void atomic_inc(atomic_t *v)
 {
 	int t;
@@ -289,72 +261,46 @@ static __inline__ void atomic64_set(atom
 	__asm__ __volatile__("std%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
 }
 
-static __inline__ void atomic64_add(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%3		# atomic64_add\n\
-	add	%0,%2,%0\n\
-	stdcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
+#define ATOMIC64_OP(op, aop)						\
+static __inline__ void atomic64_##op(long a, atomic64_t *v)		\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	ldarx	%0,0,%3		# atomic64_" #op "\n"			\
+	#aop " %0,%2,%0\n"						\
+"	stdcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
+}									\
+									\
+static __inline__ long atomic64_##op##_return(long a, atomic64_t *v)	\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	ldarx	%0,0,%2		# atomic64_" #op "_return\n"		\
+	#aop " %0,%1,%0\n"						\
+"	stdcx.	%0,0,%2 \n"						\
+"	bne-	1b\n"							\
+	PPC_ATOMIC_EXIT_BARRIER						\
+	: "=&r" (t)							\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc", "memory");						\
+									\
+	return t;							\
 }
 
-static __inline__ long atomic64_add_return(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	ldarx	%0,0,%2		# atomic64_add_return\n\
-	add	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
+ATOMIC64_OP(add, add)
+ATOMIC64_OP(add, subf)
 
-	return t;
-}
+#undef ATOMIC64_OP
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
-static __inline__ void atomic64_sub(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%3		# atomic64_sub\n\
-	subf	%0,%2,%0\n\
-	stdcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ long atomic64_sub_return(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	ldarx	%0,0,%2		# atomic64_sub_return\n\
-	subf	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
-
 static __inline__ void atomic64_inc(atomic64_t *v)
 {
 	long t;
--- a/arch/sh/include/asm/atomic-grb.h
+++ b/arch/sh/include/asm/atomic-grb.h
@@ -1,85 +1,51 @@
 #ifndef __ASM_SH_ATOMIC_GRB_H
 #define __ASM_SH_ATOMIC_GRB_H
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   add     %2,   %0      \n\t" /* add */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov     r15,  r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   sub     %2,   %0      \n\t" /* sub */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   add     %2,   %0      \n\t" /* add */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
-
-	return tmp;
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int tmp;							\
+									\
+	__asm__ __volatile__ (						\
+		"   .align 2              \n\t"				\
+		"   mova    1f,   r0      \n\t" /* r0 = end point */	\
+		"   mov    r15,   r1      \n\t" /* r1 = saved sp */	\
+		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */	\
+		"   mov.l  @%1,   %0      \n\t" /* load  old value */	\
+		" " #op "   %2,   %0      \n\t" /* $op */		\
+		"   mov.l   %0,   @%1     \n\t" /* store new value */	\
+		"1: mov     r1,   r15     \n\t" /* LOGOUT */		\
+		: "=&r" (tmp),						\
+		  "+r"  (v)						\
+		: "r"   (i)						\
+		: "memory" , "r0", "r1");				\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int tmp;							\
+									\
+	__asm__ __volatile__ (						\
+		"   .align 2              \n\t"				\
+		"   mova    1f,   r0      \n\t" /* r0 = end point */	\
+		"   mov    r15,   r1      \n\t" /* r1 = saved sp */	\
+		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */	\
+		"   mov.l  @%1,   %0      \n\t" /* load  old value */	\
+		" " #op "   %2,   %0      \n\t" /* $op */		\
+		"   mov.l   %0,   @%1     \n\t" /* store new value */	\
+		"1: mov     r1,   r15     \n\t" /* LOGOUT */		\
+		: "=&r" (tmp),						\
+		  "+r"  (v)						\
+		: "r"   (i)						\
+		: "memory" , "r0", "r1");				\
+									\
+	return tmp;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   sub     %2,   %0      \n\t" /* sub */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory", "r0", "r1");
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	return tmp;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -8,49 +8,34 @@
  * forward to code at the end of this object's .text section, then
  * branch back to restart the operation.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
 
-	raw_local_irq_save(flags);
-	v->counter += i;
-	raw_local_irq_restore(flags);
+#define ATOMIC_OP(op, cop)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter cop i;						\
+	raw_local_irq_restore(flags);					\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long temp, flags;					\
+									\
+	raw_local_irq_save(flags);					\
+	temp = v->counter;						\
+	temp cop i;							\
+	v->counter = temp;						\
+	raw_local_irq_restore(flags);					\
+									\
+	return temp;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter -= i;
-	raw_local_irq_restore(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
-
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
 
-	return temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
-
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/sh/include/asm/atomic-llsc.h
+++ b/arch/sh/include/asm/atomic-llsc.h
@@ -2,39 +2,6 @@
 #define __ASM_SH_ATOMIC_LLSC_H
 
 /*
- * To get proper branch prediction for the main line, we must branch
- * forward to code at the end of this object's .text section, then
- * branch back to restart the operation.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_add	\n"
-"	add	%1, %0				\n"
-"	movco.l	%0, @%2				\n"
-"	bf	1b				\n"
-	: "=&z" (tmp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_sub	\n"
-"	sub	%1, %0				\n"
-"	movco.l	%0, @%2				\n"
-"	bf	1b				\n"
-	: "=&z" (tmp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
-}
-
-/*
  * SH-4A note:
  *
  * We basically get atomic_xxx_return() for free compared with
@@ -42,39 +9,48 @@ static inline void atomic_sub(int i, ato
  * encoding, so the retval is automatically set without having to
  * do any special work.
  */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_add_return	\n"
-"	add	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
+/*
+ * To get proper branch prediction for the main line, we must branch
+ * forward to code at the end of this object's .text section, then
+ * branch back to restart the operation.
+ */
 
-	return temp;
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+									\
+	__asm__ __volatile__ (						\
+"1:	movli.l @%2, %0		! atomic_" #op "\n"			\
+"	" #op "	%1, %0				\n"			\
+"	movco.l	%0, @%2				\n"			\
+"	bf	1b				\n"			\
+	: "=&z" (tmp)							\
+	: "r" (i), "r" (&v->counter)					\
+	: "t");								\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long temp;						\
+									\
+	__asm__ __volatile__ (						\
+"1:	movli.l @%2, %0		! atomic_" #op "_return	\n"		\
+"	" #op "	%1, %0					\n"		\
+"	movco.l	%0, @%2					\n"		\
+"	bf	1b					\n"		\
+"	synco						\n"		\
+	: "=&z" (temp)							\
+	: "r" (i), "r" (&v->counter)					\
+	: "t");								\
+									\
+	return temp;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long temp;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_sub_return	\n"
-"	sub	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
-
-	return temp;
-}
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -20,7 +20,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-extern int __atomic_add_return(int, atomic_t *);
+extern int atomic_add_return(int, atomic_t *);
 extern int atomic_cmpxchg(atomic_t *, int, int);
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 extern int __atomic_add_unless(atomic_t *, int, int);
@@ -28,15 +28,14 @@ extern void atomic_set(atomic_t *, int);
 
 #define atomic_read(v)          (*(volatile int *)&(v)->counter)
 
-#define atomic_add(i, v)	((void)__atomic_add_return( (int)(i), (v)))
-#define atomic_sub(i, v)	((void)__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc(v)		((void)__atomic_add_return(        1, (v)))
-#define atomic_dec(v)		((void)__atomic_add_return(       -1, (v)))
-
-#define atomic_add_return(i, v)	(__atomic_add_return( (int)(i), (v)))
-#define atomic_sub_return(i, v)	(__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc_return(v)	(__atomic_add_return(        1, (v)))
-#define atomic_dec_return(v)	(__atomic_add_return(       -1, (v)))
+#define atomic_add(i, v)	((void)atomic_add_return( (int)(i), (v)))
+#define atomic_sub(i, v)	((void)atomic_add_return(-(int)(i), (v)))
+#define atomic_inc(v)		((void)atomic_add_return(        1, (v)))
+#define atomic_dec(v)		((void)atomic_add_return(       -1, (v)))
+
+#define atomic_sub_return(i, v)	(atomic_add_return(-(int)(i), (v)))
+#define atomic_inc_return(v)	(atomic_add_return(        1, (v)))
+#define atomic_dec_return(v)	(atomic_add_return(       -1, (v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -20,27 +20,22 @@
 #define atomic_set(v, i)	(((v)->counter) = i)
 #define atomic64_set(v, i)	(((v)->counter) = i)
 
-extern void atomic_add(int, atomic_t *);
-extern void atomic64_add(long, atomic64_t *);
-extern void atomic_sub(int, atomic_t *);
-extern void atomic64_sub(long, atomic64_t *);
-
-extern int atomic_add_ret(int, atomic_t *);
-extern long atomic64_add_ret(long, atomic64_t *);
-extern int atomic_sub_ret(int, atomic_t *);
-extern long atomic64_sub_ret(long, atomic64_t *);
-
-#define atomic_dec_return(v) atomic_sub_ret(1, v)
-#define atomic64_dec_return(v) atomic64_sub_ret(1, v)
+#define ATOMIC_OP(op)							\
+extern void atomic_##op(int, atomic_t *);				\
+extern void atomic64_##op(long, atomic64_t *);				\
+extern int atomic_##op##_return(int, atomic_t *);			\
+extern long atomic64_##op##_return(long, atomic64_t *);
+
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-#define atomic_inc_return(v) atomic_add_ret(1, v)
-#define atomic64_inc_return(v) atomic64_add_ret(1, v)
+#undef ATOMIC_OP
 
-#define atomic_sub_return(i, v) atomic_sub_ret(i, v)
-#define atomic64_sub_return(i, v) atomic64_sub_ret(i, v)
+#define atomic_dec_return(v)   atomic_sub_return(1, v)
+#define atomic64_dec_return(v) atomic64_sub_return(1, v)
 
-#define atomic_add_return(i, v) atomic_add_ret(i, v)
-#define atomic64_add_return(i, v) atomic64_add_ret(i, v)
+#define atomic_inc_return(v)   atomic_add_return(1, v)
+#define atomic64_inc_return(v) atomic64_add_return(1, v)
 
 /*
  * atomic_inc_and_test - increment and test
@@ -53,11 +48,11 @@ extern long atomic64_sub_ret(long, atomi
 #define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
 #define atomic64_inc_and_test(v) (atomic64_inc_return(v) == 0)
 
-#define atomic_sub_and_test(i, v) (atomic_sub_ret(i, v) == 0)
-#define atomic64_sub_and_test(i, v) (atomic64_sub_ret(i, v) == 0)
+#define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
+#define atomic64_sub_and_test(i, v) (atomic64_sub_return(i, v) == 0)
 
-#define atomic_dec_and_test(v) (atomic_sub_ret(1, v) == 0)
-#define atomic64_dec_and_test(v) (atomic64_sub_ret(1, v) == 0)
+#define atomic_dec_and_test(v) (atomic_sub_return(1, v) == 0)
+#define atomic64_dec_and_test(v) (atomic64_sub_return(1, v) == 0)
 
 #define atomic_inc(v) atomic_add(1, v)
 #define atomic64_inc(v) atomic64_add(1, v)
@@ -65,8 +60,8 @@ extern long atomic64_sub_ret(long, atomi
 #define atomic_dec(v) atomic_sub(1, v)
 #define atomic64_dec(v) atomic64_sub(1, v)
 
-#define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
-#define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
+#define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
+#define atomic64_add_negative(i, v) (atomic64_add_return(i, v) < 0)
 
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -1,7 +1,6 @@
 #ifndef __SPARC_BARRIER_H
 #define __SPARC_BARRIER_H
 
-#include <asm/processor.h> /* for nop() */
 #include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
--- a/arch/sparc/include/asm/processor.h
+++ b/arch/sparc/include/asm/processor.h
@@ -6,6 +6,4 @@
 #include <asm/processor_32.h>
 #endif
 
-#define nop() 		__asm__ __volatile__ ("nop")
-
 #endif
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1150,7 +1150,7 @@ static unsigned long penguins_are_doing_
 
 void smp_capture(void)
 {
-	int result = atomic_add_ret(1, &smp_capture_depth);
+	int result = atomic_add_return(1, &smp_capture_depth);
 
 	if (result == 1) {
 		int ncpus = num_online_cpus();
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -27,18 +27,23 @@ static DEFINE_SPINLOCK(dummy);
 
 #endif /* SMP */
 
-int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+#define ATOMIC_OP(op, cop)						\
+int atomic_##op##_return(int i, atomic_t *v)				\
+{									\
+	int ret;							\
+	unsigned long flags;						\
+	spin_lock_irqsave(ATOMIC_HASH(v), flags);			\
+									\
+	ret = (v->counter cop i);					\
+									\
+	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);			\
+	return ret;							\
+}									\
+EXPORT_SYMBOL(atomic_##op##_return);
 
-	ret = (v->counter += i);
+ATOMIC_OP(add, +=)
 
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
-	return ret;
-}
-EXPORT_SYMBOL(__atomic_add_return);
+#undef ATOMIC_OP
 
 int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
--- a/arch/sparc/lib/atomic_64.S
+++ b/arch/sparc/lib/atomic_64.S
@@ -14,109 +14,66 @@
 	 * memory barriers, and a second which returns
 	 * a value and does the barriers.
 	 */
-ENTRY(atomic_add) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	add	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_add)
-
-ENTRY(atomic_sub) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	sub	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_sub)
 
-ENTRY(atomic_add_ret) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	add	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 add	%g1, %o0, %g1
-	retl
-	 sra	%g1, 0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_add_ret)
+#define ATOMIC_OP(op)							\
+ENTRY(atomic_##op) /* %o0 = increment, %o1 = atomic_ptr */		\
+	BACKOFF_SETUP(%o2);						\
+1:	lduw	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	cas	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 nop;								\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic_##op);							\
+									\
+ENTRY(atomic_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	lduw	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	cas	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
+	 add	%g1, %o0, %g1;						\
+	retl;								\
+	 sra	%g1, 0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic_##op##_return);
+
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
+
+#define ATOMIC64_OP(op)							\
+ENTRY(atomic64_##op) /* %o0 = increment, %o1 = atomic_ptr */		\
+	BACKOFF_SETUP(%o2);						\
+1:	ldx	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	casx	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 nop;								\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic64_##op);							\
+									\
+ENTRY(atomic64_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	ldx	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	casx	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 add	%g1, %o0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic64_##op##_return);
 
-ENTRY(atomic_sub_ret) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	sub	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 sub	%g1, %o0, %g1
-	retl
-	 sra	%g1, 0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_sub_ret)
-
-ENTRY(atomic64_add) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	add	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_add)
-
-ENTRY(atomic64_sub) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	sub	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_sub)
-
-ENTRY(atomic64_add_ret) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	add	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 add	%g1, %o0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_add_ret)
-
-ENTRY(atomic64_sub_ret) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	sub	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 sub	%g1, %o0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_sub_ret)
+ATOMIC64_OP(add)
+ATOMIC64_OP(sub)
 
 ENTRY(atomic64_dec_if_positive) /* %o0 = atomic_ptr */
 	BACKOFF_SETUP(%o2)
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -99,14 +99,15 @@ EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
 /* Atomic counter implementation. */
-EXPORT_SYMBOL(atomic_add);
-EXPORT_SYMBOL(atomic_add_ret);
-EXPORT_SYMBOL(atomic_sub);
-EXPORT_SYMBOL(atomic_sub_ret);
-EXPORT_SYMBOL(atomic64_add);
-EXPORT_SYMBOL(atomic64_add_ret);
-EXPORT_SYMBOL(atomic64_sub);
-EXPORT_SYMBOL(atomic64_sub_ret);
+#define ATOMIC_OP(op)							\
+EXPORT_SYMBOL(atomic_##op);						\
+EXPORT_SYMBOL(atomic_##op##_return);					\
+EXPORT_SYMBOL(atomic64_##op);						\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
+
 EXPORT_SYMBOL(atomic64_dec_if_positive);
 
 /* Atomic bit operations. */
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -58,165 +58,90 @@
  */
 #define atomic_set(v,i)		((v)->counter = (i))
 
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic_add(int i, atomic_t * v)
-{
 #if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       add     %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (i), "a" (v)
-			: "memory"
-			);
-#else
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15, "__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       add     %0, %0, %1\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval)
-			: "a" (i), "a" (v)
-			: "a15", "memory"
-			);
-#endif
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t * v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	__asm__ __volatile__(						\
+			"1:     l32i    %1, %3, 0\n"			\
+			"       wsr     %1, scompare1\n"		\
+			"       " #op " %0, %1, %2\n"			\
+			"       s32c1i  %0, %3, 0\n"			\
+			"       bne     %0, %1, 1b\n"			\
+			: "=&a" (result), "=&a" (tmp)			\
+			: "a" (i), "a" (v)				\
+			: "memory"					\
+			);						\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	__asm__ __volatile__(						\
+			"1:     l32i    %1, %3, 0\n"			\
+			"       wsr     %1, scompare1\n"		\
+			"       " #op " %0, %1, %2\n"			\
+			"       s32c1i  %0, %3, 0\n"			\
+			"       bne     %0, %1, 1b\n"			\
+			"       " #op " %0, %0, %2\n"			\
+			: "=&a" (result), "=&a" (tmp)			\
+			: "a" (i), "a" (v)				\
+			: "memory"					\
+			);						\
+									\
+	return result;							\
 }
 
-/**
- * atomic_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic_sub(int i, atomic_t *v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
+#else /* XCHAL_HAVE_S32C1I */
 
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       sub     %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (i), "a" (v)
-			: "memory"
-			);
-#else
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15, "__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       sub     %0, %0, %1\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval)
-			: "a" (i), "a" (v)
-			: "a15", "memory"
-			);
-#endif
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t * v)			\
+{									\
+	unsigned int vval;						\
+									\
+	__asm__ __volatile__(						\
+			"       rsil    a15, "__stringify(LOCKLEVEL)"\n"\
+			"       l32i    %0, %2, 0\n"			\
+			"       " #op " %0, %0, %1\n"			\
+			"       s32i    %0, %2, 0\n"			\
+			"       wsr     a15, ps\n"			\
+			"       rsync\n"				\
+			: "=&a" (vval)					\
+			: "a" (i), "a" (v)				\
+			: "a15", "memory"				\
+			);						\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned int vval;						\
+									\
+	__asm__ __volatile__(						\
+			"       rsil    a15,"__stringify(LOCKLEVEL)"\n"	\
+			"       l32i    %0, %2, 0\n"			\
+			"       " #op " %0, %0, %1\n"			\
+			"       s32i    %0, %2, 0\n"			\
+			"       wsr     a15, ps\n"			\
+			"       rsync\n"				\
+			: "=&a" (vval)					\
+			: "a" (i), "a" (v)				\
+			: "a15", "memory"				\
+			);						\
+									\
+	return vval;							\
 }
 
-/*
- * We use atomic_{add|sub}_return to define other functions.
- */
+#endif /* XCHAL_HAVE_S32C1I */
 
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
+ATOMIC_OP(add)
+ATOMIC_OP(sub)
 
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       add     %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			"       add     %0, %0, %2\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (i), "a" (v)
-			: "memory"
-			);
-
-	return result;
-#else
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15,"__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       add     %0, %0, %1\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval)
-			: "a" (i), "a" (v)
-			: "a15", "memory"
-			);
-
-	return vval;
-#endif
-}
-
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       sub     %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			"       sub     %0, %0, %2\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (i), "a" (v)
-			: "memory"
-			);
-
-	return result;
-#else
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15,"__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       sub     %0, %0, %1\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval)
-			: "a" (i), "a" (v)
-			: "a15", "memory"
-			);
-
-	return vval;
-#endif
-}
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -19,13 +19,60 @@
 #include <asm/barrier.h>
 
 #ifdef CONFIG_SMP
-/* Force people to define core atomics */
-# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
-     !defined(atomic_clear_mask) || !defined(atomic_set_mask)
-#  error "SMP requires a little arch-specific magic"
-# endif
+
+/* we can build all atomic primitives from cmpxchg */
+
+#define GEN_ATOMIC_OP(op, cop)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int c, old;							\
+									\
+	c = v->counter;							\
+	while ((old = cmpxchg(&v->counter, c, c cop i)) != c)		\
+		c = old;						\
+									\
+	return c cop i;							\
+}
+
+#else
+
+#include <linux/irqflags.h>
+
+#define GEN_ATOMIC_OP(op, cop)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	raw_local_irq_save(flags);					\
+	ret = (v->counter cop i);					\
+	raw_local_irq_restore(flags);					\
+									\
+	return ret;							\
+}
+
+#endif /* CONFIG_SMP */
+
+#ifndef atomic_add_return
+GEN_ATOMIC_OP(add, +)
+#endif
+
+#ifndef atomic_sub_return
+GEN_ATOMIC_OP(sub, -)
+#endif
+
+#ifndef atomic_clear_mask
+GEN_ATOMIC_OP(and, &)
+#define atomic_clear_mask(i, v) (void)atomic_and_return(~(i), (v))
+#endif
+
+#ifndef atomic_set_mask
+GEN_ATOMIC_OP(or, |)
+#define atomic_set_mask(i, v)	(void)atomic_or_return((i), (v))
 #endif
 
+#undef GEN_ATOMIC_OP
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
@@ -33,8 +80,6 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#ifdef __KERNEL__
-
 /**
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
@@ -56,52 +101,6 @@
 
 #include <linux/irqflags.h>
 
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- */
-#ifndef atomic_add_return
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	raw_local_irq_save(flags); /* Don't trace it in an irqsoff handler */
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
-}
-#endif
-
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- */
-#ifndef atomic_sub_return
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	raw_local_irq_save(flags); /* Don't trace it in an irqsoff handler */
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
-}
-#endif
-
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	return atomic_add_return(i, v) < 0;
@@ -146,42 +145,4 @@ static inline int __atomic_add_unless(at
   return c;
 }
 
-/**
- * atomic_clear_mask - Atomically clear bits in atomic variable
- * @mask: Mask of the bits to be cleared
- * @v: pointer of type atomic_t
- *
- * Atomically clears the bits set in @mask from @v
- */
-#ifndef atomic_clear_mask
-static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	mask = ~mask;
-	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	v->counter &= mask;
-	raw_local_irq_restore(flags);
-}
-#endif
-
-/**
- * atomic_set_mask - Atomically set bits in atomic variable
- * @mask: Mask of the bits to be set
- * @v: pointer of type atomic_t
- *
- * Atomically sets the bits set in @mask in @v
- */
-#ifndef atomic_set_mask
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	v->counter |= mask;
-	raw_local_irq_restore(flags);
-}
-#endif
-
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */


