Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaJMGZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:25:17 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46381 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaJMGZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:25:13 -0400
Date: Mon, 13 Oct 2014 08:24:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking/arch changes for v3.18
Message-ID: <20141013062459.GA9155@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-arch-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-arch-for-linus

   # HEAD: 2291059c852706c6f5ffb400366042b7625066cd locking,arch: Use ACCESS_ONCE() instead of cast to volatile in atomic_read()

This is a series kept separate from the main locking tree, which 
cleans up and improves various details in the atomics type 
handling:

 - Remove the unused atomic_or_long() method

 - Consolidate and compress atomic ops implementations between
   architectures, to reduce linecount and to make it easier to 
   add new ops.

 - Rewrite generic atomic support to only require cmpxchg() from 
   an architecture - generate all other methods from that.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (22):
      locking,x86: Kill atomic_or_long()
      locking,arch,alpha: Fold atomic_ops
      locking,arch,arc: Fold atomic_ops
      locking,arch,arm: Fold atomic_ops
      locking,arch,arm64: Fold atomic_ops
      locking,arch,avr32: Fold atomic_ops
      locking,arch,cris: Fold atomic_ops
      locking,arch,hexagon: Fold atomic_ops
      locking,arch,ia64: Fold atomic_ops
      locking,arch,m32r: Fold atomic_ops
      locking,arch,m68k: Fold atomic_ops
      locking,arch,metag: Fold atomic_ops
      locking,arch,mips: Fold atomic_ops
      locking,arch,mn10300: Fold atomic_ops
      locking,arch,parisc: Fold atomic_ops
      locking,arch,powerpc: Fold atomic_ops
      locking,arch,sh: Fold atomic_ops
      locking,arch,sparc: Fold atomic_ops
      locking,arch,xtensa: Fold atomic_ops
      locking,arch: Rewrite generic atomic support
      locking, sparc64: Fix atomics
      locking, mips: Fix atomics

Pranith Kumar (1):
      locking,arch: Use ACCESS_ONCE() instead of cast to volatile in atomic_read()


 arch/alpha/include/asm/atomic.h        | 217 +++++--------
 arch/arc/include/asm/atomic.h          | 184 ++++-------
 arch/arm/include/asm/atomic.h          | 307 ++++++++----------
 arch/arm64/include/asm/atomic.h        | 201 +++++-------
 arch/avr32/include/asm/atomic.h        | 125 ++++----
 arch/cris/include/asm/atomic.h         |  59 ++--
 arch/frv/include/asm/atomic.h          |   2 +-
 arch/hexagon/include/asm/atomic.h      |  68 ++--
 arch/ia64/include/asm/atomic.h         | 192 ++++++-----
 arch/m32r/include/asm/atomic.h         | 145 ++++-----
 arch/m68k/include/asm/atomic.h         | 111 +++----
 arch/metag/include/asm/atomic_lnkget.h | 121 +++----
 arch/metag/include/asm/atomic_lock1.h  |  76 ++---
 arch/mips/include/asm/atomic.h         | 561 +++++++++++----------------------
 arch/mn10300/include/asm/atomic.h      | 125 +++-----
 arch/parisc/include/asm/atomic.h       | 117 ++++---
 arch/powerpc/include/asm/atomic.h      | 198 +++++-------
 arch/sh/include/asm/atomic-grb.h       | 119 +++----
 arch/sh/include/asm/atomic-irq.h       |  62 ++--
 arch/sh/include/asm/atomic-llsc.h      | 101 +++---
 arch/sh/include/asm/atomic.h           |   2 +-
 arch/sparc/include/asm/atomic_32.h     |  19 +-
 arch/sparc/include/asm/atomic_64.h     |  49 +--
 arch/sparc/kernel/smp_64.c             |   2 +-
 arch/sparc/lib/atomic32.c              |  29 +-
 arch/sparc/lib/atomic_64.S             | 163 ++++------
 arch/sparc/lib/ksyms.c                 |  25 +-
 arch/x86/include/asm/atomic.h          |  17 +-
 arch/x86/include/asm/atomic64_64.h     |   2 +-
 arch/xtensa/include/asm/atomic.h       | 235 +++++---------
 include/asm-generic/atomic.h           | 194 ++++++------
 include/asm-generic/atomic64.h         |  20 +-
 lib/atomic64.c                         |  83 +++--
 33 files changed, 1611 insertions(+), 2320 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index ed60a1ee1ed3..8f8eafbedd7c 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -17,8 +17,8 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 #define atomic_set(v,i)		((v)->counter = (i))
 #define atomic64_set(v,i)	((v)->counter = (i))
@@ -29,145 +29,92 @@
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
 }
 
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
+
+#define ATOMIC64_OP_RETURN(op)						\
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
 }
 
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
+#define ATOMIC_OPS(opg)							\
+	ATOMIC_OP(opg)							\
+	ATOMIC_OP_RETURN(opg)						\
+	ATOMIC64_OP(opg)						\
+	ATOMIC64_OP_RETURN(opg)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
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
+#undef ATOMIC_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 #define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 83f03ca6caf6..173f303a868f 100644
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -25,79 +25,36 @@
 
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
-}
-
-/* add and also return the new value */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned int temp;
-
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
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	bic     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(addr), "ir"(mask)
-	: "cc");
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #asm_op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */	\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #asm_op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)							\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+									\
+	return temp;							\
 }
 
 #else	/* !CONFIG_ARC_HAS_LLSC */
@@ -126,6 +83,7 @@ static inline void atomic_set(atomic_t *v, int i)
 	v->counter = i;
 	atomic_ops_unlock(flags);
 }
+
 #endif
 
 /*
@@ -133,62 +91,46 @@ static inline void atomic_set(atomic_t *v, int i)
  * Locking would change to irq-disabling only (UP) and spinlocks (SMP)
  */
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	v->counter += i;
-	atomic_ops_unlock(flags);
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	atomic_ops_lock(flags);						\
+	v->counter c_op i;						\
+	atomic_ops_unlock(flags);					\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	v->counter -= i;
-	atomic_ops_unlock(flags);
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	unsigned long temp;						\
+									\
+	atomic_ops_lock(flags);						\
+	temp = v->counter;						\
+	temp c_op i;							\
+	v->counter = temp;						\
+	atomic_ops_unlock(flags);					\
+									\
+	return temp;							\
 }
 
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
+#endif /* !CONFIG_ARC_HAS_LLSC */
 
-	return temp;
-}
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+ATOMIC_OP(and, &=, and)
 
-	atomic_ops_lock(flags);
-	*addr &= ~mask;
-	atomic_ops_unlock(flags);
-}
+#define atomic_clear_mask(mask, v) atomic_and(~(mask), (v))
 
-#endif /* !CONFIG_ARC_HAS_LLSC */
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * __atomic_add_unless - add unless the number is a given value
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 3040359094d9..e22c11970b7b 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -27,7 +27,7 @@
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
 #if __LINUX_ARM_ARCH__ >= 6
@@ -37,84 +37,47 @@
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
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	smp_mb();
-	prefetchw(&v->counter);
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
-
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
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	smp_mb();
-	prefetchw(&v->counter);
-
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
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	prefetchw(&v->counter);						\
+	__asm__ __volatile__("@ atomic_" #op "\n"			\
+"1:	ldrex	%0, [%3]\n"						\
+"	" #asm_op "	%0, %0, %4\n"					\
+"	strex	%1, %0, [%3]\n"						\
+"	teq	%1, #0\n"						\
+"	bne	1b"							\
+	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
+	: "r" (&v->counter), "Ir" (i)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	smp_mb();							\
+	prefetchw(&v->counter);						\
+									\
+	__asm__ __volatile__("@ atomic_" #op "_return\n"		\
+"1:	ldrex	%0, [%3]\n"						\
+"	" #asm_op "	%0, %0, %4\n"					\
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
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
@@ -174,33 +137,29 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
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
-}
-#define atomic_add(i, v)	(void) atomic_add_return(i, v)
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int val;
-
-	raw_local_irq_save(flags);
-	val = v->counter;
-	v->counter = val -= i;
-	raw_local_irq_restore(flags);
-
-	return val;
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter c_op i;						\
+	raw_local_irq_restore(flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int val;							\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter c_op i;						\
+	val = v->counter;						\
+	raw_local_irq_restore(flags);					\
+									\
+	return val;							\
 }
-#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
 
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
@@ -228,6 +187,17 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #endif /* __LINUX_ARM_ARCH__ */
 
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 #define atomic_inc(v)		atomic_add(1, v)
@@ -300,89 +270,60 @@ static inline void atomic64_set(atomic64_t *v, long long i)
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
-}
-
-static inline long long atomic64_add_return(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	smp_mb();
-	prefetchw(&v->counter);
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
-
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
+#define ATOMIC64_OP(op, op1, op2)					\
+static inline void atomic64_##op(long long i, atomic64_t *v)		\
+{									\
+	long long result;						\
+	unsigned long tmp;						\
+									\
+	prefetchw(&v->counter);						\
+	__asm__ __volatile__("@ atomic64_" #op "\n"			\
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
+
+#define ATOMIC64_OP_RETURN(op, op1, op2)				\
+static inline long long atomic64_##op##_return(long long i, atomic64_t *v) \
+{									\
+	long long result;						\
+	unsigned long tmp;						\
+									\
+	smp_mb();							\
+	prefetchw(&v->counter);						\
+									\
+	__asm__ __volatile__("@ atomic64_" #op "_return\n"		\
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
 
-static inline long long atomic64_sub_return(long long i, atomic64_t *v)
-{
-	long long result;
-	unsigned long tmp;
-
-	smp_mb();
-	prefetchw(&v->counter);
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
+#define ATOMIC64_OPS(op, op1, op2)					\
+	ATOMIC64_OP(op, op1, op2)					\
+	ATOMIC64_OP_RETURN(op, op1, op2)
 
-	smp_mb();
+ATOMIC64_OPS(add, adds, adc)
+ATOMIC64_OPS(sub, subs, sbc)
 
-	return result;
-}
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static inline long long atomic64_cmpxchg(atomic64_t *ptr, long long old,
 					long long new)
diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 65f1569ac96e..7047051ded40 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -35,7 +35,7 @@
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
 /*
@@ -43,69 +43,51 @@
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
-	: "Ir" (i));
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
-	: "memory");
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
-	: "Ir" (i));
+#define ATOMIC_OP(op, asm_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "\n"				\
+"1:	ldxr	%w0, %2\n"						\
+"	" #asm_op "	%w0, %w0, %w3\n"				\
+"	stxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i));							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, asm_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "_return\n"			\
+"1:	ldxr	%w0, %2\n"						\
+"	" #asm_op "	%w0, %w0, %w3\n"				\
+"	stlxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "memory");							\
+									\
+	smp_mb();							\
+	return result;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
+#define ATOMIC_OPS(op, asm_op)						\
+	ATOMIC_OP(op, asm_op)						\
+	ATOMIC_OP_RETURN(op, asm_op)
 
-	asm volatile("// atomic_sub_return\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, sub)
 
-	smp_mb();
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
@@ -157,72 +139,53 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
  */
 #define ATOMIC64_INIT(i) { (i) }
 
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
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
-	: "Ir" (i));
+#define ATOMIC64_OP(op, asm_op)						\
+static inline void atomic64_##op(long i, atomic64_t *v)			\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "\n"				\
+"1:	ldxr	%0, %2\n"						\
+"	" #asm_op "	%0, %0, %3\n"					\
+"	stxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i));							\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, asm_op)					\
+static inline long atomic64_##op##_return(long i, atomic64_t *v)	\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "_return\n"			\
+"1:	ldxr	%0, %2\n"						\
+"	" #asm_op "	%0, %0, %3\n"					\
+"	stlxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "memory");							\
+									\
+	smp_mb();							\
+	return result;							\
 }
 
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
+#define ATOMIC64_OPS(op, asm_op)					\
+	ATOMIC64_OP(op, asm_op)						\
+	ATOMIC64_OP_RETURN(op, asm_op)
 
-	asm volatile("// atomic64_add_return\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(sub, sub)
 
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
-	: "Ir" (i));
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
-	: "memory");
-
-	smp_mb();
-	return result;
-}
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static inline long atomic64_cmpxchg(atomic64_t *ptr, long old, long new)
 {
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 0780f3f2415b..2d07ce1c5327 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -19,33 +19,46 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
+#define ATOMIC_OP_RETURN(op, asm_op, asm_con)				\
+static inline int __atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result;							\
+									\
+	asm volatile(							\
+		"/* atomic_" #op "_return */\n"				\
+		"1:	ssrf	5\n"					\
+		"	ld.w	%0, %2\n"				\
+		"	" #asm_op "	%0, %3\n"			\
+		"	stcond	%1, %0\n"				\
+		"	brne	1b"					\
+		: "=&r" (result), "=o" (v->counter)			\
+		: "m" (v->counter), #asm_con (i)			\
+		: "cc");						\
+									\
+	return result;							\
+}
+
+ATOMIC_OP_RETURN(sub, sub, rKs21)
+ATOMIC_OP_RETURN(add, add, r)
+
+#undef ATOMIC_OP_RETURN
+
 /*
- * atomic_sub_return - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
+ * Probably found the reason why we want to use sub with the signed 21-bit
+ * limit, it uses one less register than the add instruction that can add up to
+ * 32-bit values.
  *
- * Atomically subtracts @i from @v. Returns the resulting value.
+ * Both instructions are 32-bit, to use a 16-bit instruction the immediate is
+ * very small; 4 bit.
+ *
+ * sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
+ * add 32-bit, type II, adds two register values together.
  */
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
-}
+#define IS_21BIT_CONST(i)						\
+	(__builtin_constant_p(i) && ((i) >= -1048575) && ((i) <= 1048576))
 
 /*
  * atomic_add_return - add integer to atomic variable
@@ -56,51 +69,25 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
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
+	if (IS_21BIT_CONST(i))
+		return __atomic_sub_return(-i, v);
 
-	return result;
+	return __atomic_add_return(i, v);
 }
 
 /*
- * atomic_sub_unless - sub unless the number is a given value
+ * atomic_sub_return - subtract the atomic variable
+ * @i: integer value to subtract
  * @v: pointer of type atomic_t
- * @a: the amount to subtract from v...
- * @u: ...unless v is equal to u.
  *
- * Atomically subtract @a from @v, so long as it was not @u.
- * Returns the old value of @v.
-*/
-static inline void atomic_sub_unless(atomic_t *v, int a, int u)
+ * Atomically subtracts @i from @v. Returns the resulting value.
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
 {
-	int tmp;
+	if (IS_21BIT_CONST(i))
+		return __atomic_sub_return(i, v);
 
-	asm volatile(
-		"/* atomic_sub_unless */\n"
-		"1:	ssrf	5\n"
-		"	ld.w	%0, %2\n"
-		"	cp.w	%0, %4\n"
-		"	breq	1f\n"
-		"	sub	%0, %3\n"
-		"	stcond	%1, %0\n"
-		"	brne	1b\n"
-		"1:"
-		: "=&r"(tmp), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
-		: "cc", "memory");
+	return __atomic_add_return(-i, v);
 }
 
 /*
@@ -116,9 +103,21 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int tmp, old = atomic_read(v);
 
-	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
-		atomic_sub_unless(v, -a, u);
-	else {
+	if (IS_21BIT_CONST(a)) {
+		asm volatile(
+			"/* __atomic_sub_unless */\n"
+			"1:	ssrf	5\n"
+			"	ld.w	%0, %2\n"
+			"	cp.w	%0, %4\n"
+			"	breq	1f\n"
+			"	sub	%0, %3\n"
+			"	stcond	%1, %0\n"
+			"	brne	1b\n"
+			"1:"
+			: "=&r"(tmp), "=o"(v->counter)
+			: "m"(v->counter), "rKs21"(-a), "rKs21"(u)
+			: "cc", "memory");
+	} else {
 		asm volatile(
 			"/* __atomic_add_unless */\n"
 			"1:	ssrf	5\n"
@@ -137,6 +136,8 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return old;
 }
 
+#undef IS_21BIT_CONST
+
 /*
  * atomic_sub_if_positive - conditionally subtract integer from atomic variable
  * @i: integer value to subtract
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index aa429baebaf9..279766a70664 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -17,48 +17,41 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v) (*(volatile int *)&(v)->counter)
+#define atomic_read(v) ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i) (((v)->counter) = (i))
 
 /* These should be written in asm but we do it in C for now. */
 
-static inline void atomic_add(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	cris_atomic_save(v, flags);
-	v->counter += i;
-	cris_atomic_restore(v, flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, volatile atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	cris_atomic_save(v, flags);					\
+	v->counter c_op i;						\
+	cris_atomic_restore(v, flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, volatile atomic_t *v)	\
+{									\
+	unsigned long flags;						\
+	int retval;							\
+	cris_atomic_save(v, flags);					\
+	retval = (v->counter c_op i);					\
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
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-static inline int atomic_add_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter += i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-static inline int atomic_sub_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter -= i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
+#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
 static inline int atomic_sub_and_test(int i, volatile atomic_t *v)
 {
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index f6c3a1690101..102190a61d65 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -31,7 +31,7 @@
  */
 
 #define ATOMIC_INIT(i)		{ (i) }
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
 
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index de916b11bff5..93d07025f183 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -94,41 +94,47 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
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
+
+#define ATOMIC_OP_RETURN(op)							\
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-#define atomic_sub(i, v) atomic_sub_return(i, (v))
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * __atomic_add_unless - add unless the number is a given value
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 0f8bf48dadf3..0bf03501fe5c 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -21,68 +21,100 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
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
+#define ATOMIC_OP(op, c_op)						\
+static __inline__ int							\
+ia64_atomic_##op (int i, atomic_t *v)					\
+{									\
+	__s32 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic_read(v);					\
+		new = old c_op i;					\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old); \
+	return new;							\
 }
 
-static __inline__ long
-ia64_atomic64_add (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
+ATOMIC_OP(add, +)
+ATOMIC_OP(sub, -)
 
-static __inline__ int
-ia64_atomic_sub (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
-}
+#undef ATOMIC_OP
 
-static __inline__ long
-ia64_atomic64_sub (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
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
+
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
+#define ATOMIC64_OP(op, c_op)						\
+static __inline__ long							\
+ia64_atomic64_##op (__s64 i, atomic64_t *v)				\
+{									\
+	__s64 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic64_read(v);					\
+		new = old c_op i;					\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old); \
+	return new;							\
 }
 
+ATOMIC64_OP(add, +)
+ATOMIC64_OP(sub, -)
+
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
+
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
@@ -123,30 +155,6 @@ static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 
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
@@ -163,30 +171,6 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
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
@@ -199,13 +183,13 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
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
 
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 8ad0ed4182a5..31bb74adba08 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -28,7 +28,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 
 /**
  * atomic_set - set atomic variable
@@ -39,85 +39,64 @@
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
-
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-#define atomic_add(i,v) ((void) atomic_add_return((i), (v)))
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-/**
- * atomic_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-#define atomic_sub(i,v) ((void) atomic_sub_return((i), (v)))
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
@@ -151,9 +130,7 @@ static __inline__ int atomic_inc_return(atomic_t *v)
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -181,9 +158,7 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -280,9 +255,7 @@ static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
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
@@ -302,9 +275,7 @@ static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
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
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 55695212a2ae..e85f047fb072 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -17,7 +17,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 /*
@@ -30,16 +30,57 @@
 #define	ASM_DI	"di"
 #endif
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__asm__ __volatile__("addl %1,%0" : "+m" (*v) : ASM_DI (i));
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
+}									\
+
+#ifdef CONFIG_RMW_INSNS
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int t, tmp;							\
+									\
+	__asm__ __volatile__(						\
+			"1:	movel %2,%1\n"				\
+			"	" #asm_op "l %3,%1\n"			\
+			"	casl %2,%1,%0\n"			\
+			"	jne 1b"					\
+			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
+			: "g" (i), "2" (atomic_read(v)));		\
+	return t;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
+#else
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long flags;						\
+	int t;								\
+									\
+	local_irq_save(flags);						\
+	t = (v->counter c_op i);					\
+	local_irq_restore(flags);					\
+									\
+	return t;							\
 }
 
+#endif /* CONFIG_RMW_INSNS */
+
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 static inline void atomic_inc(atomic_t *v)
 {
 	__asm__ __volatile__("addql #1,%0" : "+m" (*v));
@@ -76,67 +117,11 @@ static inline int atomic_inc_and_test(atomic_t *v)
 
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
diff --git a/arch/metag/include/asm/atomic_lnkget.h b/arch/metag/include/asm/atomic_lnkget.h
index d2e60a18986c..948d8688643c 100644
--- a/arch/metag/include/asm/atomic_lnkget.h
+++ b/arch/metag/include/asm/atomic_lnkget.h
@@ -27,85 +27,56 @@ static inline int atomic_read(const atomic_t *v)
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int temp;
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
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
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result, temp;
-
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
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/metag/include/asm/atomic_lock1.h b/arch/metag/include/asm/atomic_lock1.h
index e578955e674b..f5d5898c1020 100644
--- a/arch/metag/include/asm/atomic_lock1.h
+++ b/arch/metag/include/asm/atomic_lock1.h
@@ -37,55 +37,41 @@ static inline int atomic_set(atomic_t *v, int i)
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
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	fence();							\
+	v->counter c_op i;						\
+	__global_unlock1(flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long result;						\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	result = v->counter;						\
+	result c_op i;							\
+	fence();							\
+	v->counter = result;						\
+	__global_unlock1(flags);					\
+									\
+	return result;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
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
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-	__global_lock1(flags);
-	result = v->counter;
-	result += i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
-
-	return result;
-}
-
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
-
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 37b2befe651a..6dd6bfc607e9 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -29,7 +29,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 
 /*
  * atomic_set - set atomic variable
@@ -40,195 +40,103 @@
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
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
-}
-
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
-		"	.set	arch=r4000				\n"
-		"1:	ll	%0, %1		# atomic_sub		\n"
-		"	subu	%0, %2					\n"
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
-			"	.set	arch=r4000			\n"
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
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
+#define ATOMIC_OP(op, c_op, asm_op)						\
+static __inline__ void atomic_##op(int i, atomic_t * v)				\
+{										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		int temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	arch=r4000				\n"	\
+		"1:	ll	%0, %1		# atomic_" #op "	\n"	\
+		"	" #asm_op " %0, %2				\n"	\
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
+			"	.set	arch=r4000			\n"	\
+			"	ll	%0, %1		# atomic_" #op "\n"	\
+			"	" #asm_op " %0, %2			\n"	\
+			"	sc	%0, %1				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (temp), "+m" (v->counter)			\
+			: "Ir" (i));						\
+		} while (unlikely(!temp));					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		v->counter c_op i;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+}										\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)					\
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
+		"	.set	arch=r4000				\n"	\
+		"1:	ll	%1, %2		# atomic_" #op "_return	\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
+		"	sc	%0, %2					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		int temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	arch=r4000			\n"	\
+			"	ll	%1, %2	# atomic_" #op "_return	\n"	\
+			"	" #asm_op " %0, %1, %3			\n"	\
+			"	sc	%0, %2				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (result), "=&r" (temp), "+m" (v->counter)	\
+			: "Ir" (i));						\
+		} while (unlikely(!result));					\
+										\
+		result = temp; result c_op i;					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		result = v->counter;						\
+		result c_op i;							\
+		v->counter = result;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+										\
+	smp_llsc_mb();								\
+										\
+	return result;								\
 }
 
-static __inline__ int atomic_sub_return(int i, atomic_t * v)
-{
-	int result;
+#define ATOMIC_OPS(op, c_op, asm_op)						\
+	ATOMIC_OP(op, c_op, asm_op)						\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
 
-	smp_mb__before_llsc();
+ATOMIC_OPS(add, +=, addu)
+ATOMIC_OPS(sub, -=, subu)
 
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		int temp;
-
-		__asm__ __volatile__(
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /*
  * atomic_sub_if_positive - conditionally subtract integer from atomic variable
@@ -398,7 +306,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
  * @v: pointer of type atomic64_t
  *
  */
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 /*
  * atomic64_set - set atomic variable
@@ -407,195 +315,104 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
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
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
+#define ATOMIC64_OP(op, c_op, asm_op)						\
+static __inline__ void atomic64_##op(long i, atomic64_t * v)			\
+{										\
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {				\
+		long temp;							\
+										\
+		__asm__ __volatile__(						\
+		"	.set	arch=r4000				\n"	\
+		"1:	lld	%0, %1		# atomic64_" #op "	\n"	\
+		"	" #asm_op " %0, %2				\n"	\
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
+			"	.set	arch=r4000			\n"	\
+			"	lld	%0, %1		# atomic64_" #op "\n"	\
+			"	" #asm_op " %0, %2			\n"	\
+			"	scd	%0, %1				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (temp), "+m" (v->counter)			\
+			: "Ir" (i));						\
+		} while (unlikely(!temp));					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		v->counter c_op i;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+}										\
+
+#define ATOMIC64_OP_RETURN(op, c_op, asm_op)					\
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
+		"	.set	arch=r4000				\n"	\
+		"1:	lld	%1, %2		# atomic64_" #op "_return\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
+		"	scd	%0, %2					\n"	\
+		"	beqzl	%0, 1b					\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
+		"	.set	mips0					\n"	\
+		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
+		: "Ir" (i));							\
+	} else if (kernel_uses_llsc) {						\
+		long temp;							\
+										\
+		do {								\
+			__asm__ __volatile__(					\
+			"	.set	arch=r4000			\n"	\
+			"	lld	%1, %2	# atomic64_" #op "_return\n"	\
+			"	" #asm_op " %0, %1, %3			\n"	\
+			"	scd	%0, %2				\n"	\
+			"	.set	mips0				\n"	\
+			: "=&r" (result), "=&r" (temp), "=m" (v->counter)	\
+			: "Ir" (i), "m" (v->counter)				\
+			: "memory");						\
+		} while (unlikely(!result));					\
+										\
+		result = temp; result c_op i;					\
+	} else {								\
+		unsigned long flags;						\
+										\
+		raw_local_irq_save(flags);					\
+		result = v->counter;						\
+		result c_op i;							\
+		v->counter = result;						\
+		raw_local_irq_restore(flags);					\
+	}									\
+										\
+	smp_llsc_mb();								\
+										\
+	return result;								\
 }
 
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
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
+#define ATOMIC64_OPS(op, c_op, asm_op)						\
+	ATOMIC64_OP(op, c_op, asm_op)						\
+	ATOMIC64_OP_RETURN(op, c_op, asm_op)
 
-	smp_mb__before_llsc();
+ATOMIC64_OPS(add, +=, daddu)
+ATOMIC64_OPS(sub, -=, dsubu)
 
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		long temp;
-
-		__asm__ __volatile__(
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
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
-}
-
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
-		"	.set	arch=r4000				\n"
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
-			"	.set	arch=r4000			\n"
-			"	lld	%1, %2	# atomic64_sub_return	\n"
-			"	dsubu	%0, %1, %3			\n"
-			"	scd	%0, %2				\n"
-			"	.set	mips0				\n"
-			: "=&r" (result), "=&r" (temp), "=m" (v->counter)
-			: "Ir" (i), "m" (v->counter)
-			: "memory");
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
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 /*
  * atomic64_sub_if_positive - conditionally subtract integer from atomic variable
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index cadeb1e2cdfc..5be655e83e70 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -33,7 +33,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_read(v)	(ACCESS_ONCE((v)->counter))
 
@@ -43,102 +42,62 @@
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
+}
 
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval += i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
-	return retval;
+#define ATOMIC_OP_RETURN(op)						\
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
+	return retval;							\
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
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
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
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
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 0be2db2c7d44..226f8ca993f6 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -55,24 +55,7 @@ extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
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
@@ -84,7 +67,7 @@ static __inline__ void atomic_set(atomic_t *v, int i)
 
 static __inline__ int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /* exported interface */
@@ -115,16 +98,43 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
+#define ATOMIC_OP(op, c_op)						\
+static __inline__ void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
+
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
+
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-#define atomic_add(i,v)	((void)(__atomic_add_return(        (i),(v))))
-#define atomic_sub(i,v)	((void)(__atomic_add_return(-((int) (i)),(v))))
-#define atomic_inc(v)	((void)(__atomic_add_return(   1,(v))))
-#define atomic_dec(v)	((void)(__atomic_add_return(  -1,(v))))
+#define atomic_inc(v)	(atomic_add(   1,(v)))
+#define atomic_dec(v)	(atomic_add(  -1,(v)))
 
-#define atomic_add_return(i,v)	(__atomic_add_return( (i),(v)))
-#define atomic_sub_return(i,v)	(__atomic_add_return(-(i),(v)))
-#define atomic_inc_return(v)	(__atomic_add_return(   1,(v)))
-#define atomic_dec_return(v)	(__atomic_add_return(  -1,(v)))
+#define atomic_inc_return(v)	(atomic_add_return(   1,(v)))
+#define atomic_dec_return(v)	(atomic_add_return(  -1,(v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
@@ -148,18 +158,37 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define ATOMIC64_INIT(i) { (i) }
 
-static __inline__ s64
-__atomic64_add_return(s64 i, atomic64_t *v)
-{
-	s64 ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
+#define ATOMIC64_OP(op, c_op)						\
+static __inline__ void atomic64_##op(s64 i, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, c_op)					\
+static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\
+{									\
+	unsigned long flags;						\
+	s64 ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
 
-	ret = (v->counter += i);
+#define ATOMIC64_OPS(op, c_op) ATOMIC64_OP(op, c_op) ATOMIC64_OP_RETURN(op, c_op)
 
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
+ATOMIC64_OPS(add, +=)
+ATOMIC64_OPS(sub, -=)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static __inline__ void
 atomic64_set(atomic64_t *v, s64 i)
@@ -175,18 +204,14 @@ atomic64_set(atomic64_t *v, s64 i)
 static __inline__ s64
 atomic64_read(const atomic64_t *v)
 {
-	return (*(volatile long *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
-#define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)(i)),(v))))
-#define atomic64_sub(i,v)	((void)(__atomic64_add_return(-((s64)(i)),(v))))
-#define atomic64_inc(v)		((void)(__atomic64_add_return(   1,(v))))
-#define atomic64_dec(v)		((void)(__atomic64_add_return(  -1,(v))))
+#define atomic64_inc(v)		(atomic64_add(   1,(v)))
+#define atomic64_dec(v)		(atomic64_add(  -1,(v)))
 
-#define atomic64_add_return(i,v)	(__atomic64_add_return( ((s64)(i)),(v)))
-#define atomic64_sub_return(i,v)	(__atomic64_add_return(-((s64)(i)),(v)))
-#define atomic64_inc_return(v)		(__atomic64_add_return(   1,(v)))
-#define atomic64_dec_return(v)		(__atomic64_add_return(  -1,(v)))
+#define atomic64_inc_return(v)		(atomic64_add_return(   1,(v)))
+#define atomic64_dec_return(v)		(atomic64_add_return(  -1,(v)))
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 28992d012926..512d2782b043 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -26,76 +26,53 @@ static __inline__ void atomic_set(atomic_t *v, int i)
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
+#define ATOMIC_OP(op, asm_op)						\
+static __inline__ void atomic_##op(int a, atomic_t *v)			\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	lwarx	%0,0,%3		# atomic_" #op "\n"			\
+	#asm_op " %0,%2,%0\n"						\
+	PPC405_ERR77(0,%3)						\
+"	stwcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, asm_op)					\
+static __inline__ int atomic_##op##_return(int a, atomic_t *v)		\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	lwarx	%0,0,%2		# atomic_" #op "_return\n"		\
+	#asm_op " %0,%1,%0\n"						\
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
+#define ATOMIC_OPS(op, asm_op) ATOMIC_OP(op, asm_op) ATOMIC_OP_RETURN(op, asm_op)
 
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
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, subf)
 
-	return t;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
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
@@ -289,71 +266,50 @@ static __inline__ void atomic64_set(atomic64_t *v, long i)
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
+#define ATOMIC64_OP(op, asm_op)						\
+static __inline__ void atomic64_##op(long a, atomic64_t *v)		\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	ldarx	%0,0,%3		# atomic64_" #op "\n"			\
+	#asm_op " %0,%2,%0\n"						\
+"	stdcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
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
-
-	return t;
+#define ATOMIC64_OP_RETURN(op, asm_op)					\
+static __inline__ long atomic64_##op##_return(long a, atomic64_t *v)	\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	ldarx	%0,0,%2		# atomic64_" #op "_return\n"		\
+	#asm_op " %0,%1,%0\n"						\
+"	stdcx.	%0,0,%2 \n"						\
+"	bne-	1b\n"							\
+	PPC_ATOMIC_EXIT_BARRIER						\
+	: "=&r" (t)							\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc", "memory");						\
+									\
+	return t;							\
 }
 
-#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
-
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
+#define ATOMIC64_OPS(op, asm_op) ATOMIC64_OP(op, asm_op) ATOMIC64_OP_RETURN(op, asm_op)
 
-static __inline__ long atomic64_sub_return(long a, atomic64_t *v)
-{
-	long t;
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(sub, subf)
 
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
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
-	return t;
-}
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
 static __inline__ void atomic64_inc(atomic64_t *v)
 {
diff --git a/arch/sh/include/asm/atomic-grb.h b/arch/sh/include/asm/atomic-grb.h
index a273c88578fc..97a5fda83450 100644
--- a/arch/sh/include/asm/atomic-grb.h
+++ b/arch/sh/include/asm/atomic-grb.h
@@ -1,85 +1,56 @@
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
+#define ATOMIC_OP_RETURN(op)						\
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return tmp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/sh/include/asm/atomic-irq.h b/arch/sh/include/asm/atomic-irq.h
index 9f7c56609e53..61d107523f06 100644
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -8,49 +8,39 @@
  * forward to code at the end of this object's .text section, then
  * branch back to restart the operation.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter += i;
-	raw_local_irq_restore(flags);
-}
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter -= i;
-	raw_local_irq_restore(flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter c_op i;						\
+	raw_local_irq_restore(flags);					\
 }
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
-
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long temp, flags;					\
+									\
+	raw_local_irq_save(flags);					\
+	temp = v->counter;						\
+	temp c_op i;							\
+	v->counter = temp;						\
+	raw_local_irq_restore(flags);					\
+									\
+	return temp;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-	return temp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/sh/include/asm/atomic-llsc.h b/arch/sh/include/asm/atomic-llsc.h
index 4b00b78e3f4f..8575dccb9ef7 100644
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
@@ -42,39 +9,53 @@ static inline void atomic_sub(int i, atomic_t *v)
  * encoding, so the retval is automatically set without having to
  * do any special work.
  */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp;
+/*
+ * To get proper branch prediction for the main line, we must branch
+ * forward to code at the end of this object's .text section, then
+ * branch back to restart the operation.
+ */
 
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_add_return	\n"
-"	add	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
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
+}
 
-	return temp;
+#define ATOMIC_OP_RETURN(op)						\
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_sub_return	\n"
-"	sub	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return temp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index f57b8a6743b3..05b9f74ce2d5 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -14,7 +14,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)		((v)->counter = (i))
 
 #if defined(CONFIG_GUSA_RB)
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7aed2be45b44..765c1776ec9f 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -20,23 +20,22 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-int __atomic_add_return(int, atomic_t *);
+int atomic_add_return(int, atomic_t *);
 int atomic_cmpxchg(atomic_t *, int, int);
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 int __atomic_add_unless(atomic_t *, int, int);
 void atomic_set(atomic_t *, int);
 
-#define atomic_read(v)          (*(volatile int *)&(v)->counter)
+#define atomic_read(v)          ACCESS_ONCE((v)->counter)
 
-#define atomic_add(i, v)	((void)__atomic_add_return( (int)(i), (v)))
-#define atomic_sub(i, v)	((void)__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc(v)		((void)__atomic_add_return(        1, (v)))
-#define atomic_dec(v)		((void)__atomic_add_return(       -1, (v)))
+#define atomic_add(i, v)	((void)atomic_add_return( (int)(i), (v)))
+#define atomic_sub(i, v)	((void)atomic_add_return(-(int)(i), (v)))
+#define atomic_inc(v)		((void)atomic_add_return(        1, (v)))
+#define atomic_dec(v)		((void)atomic_add_return(       -1, (v)))
 
-#define atomic_add_return(i, v)	(__atomic_add_return( (int)(i), (v)))
-#define atomic_sub_return(i, v)	(__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc_return(v)	(__atomic_add_return(        1, (v)))
-#define atomic_dec_return(v)	(__atomic_add_return(       -1, (v)))
+#define atomic_sub_return(i, v)	(atomic_add_return(-(int)(i), (v)))
+#define atomic_inc_return(v)	(atomic_add_return(        1, (v)))
+#define atomic_dec_return(v)	(atomic_add_return(       -1, (v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index bb894c8bec56..4082749913ce 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -14,33 +14,34 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 #define atomic_set(v, i)	(((v)->counter) = i)
 #define atomic64_set(v, i)	(((v)->counter) = i)
 
-void atomic_add(int, atomic_t *);
-void atomic64_add(long, atomic64_t *);
-void atomic_sub(int, atomic_t *);
-void atomic64_sub(long, atomic64_t *);
+#define ATOMIC_OP(op)							\
+void atomic_##op(int, atomic_t *);					\
+void atomic64_##op(long, atomic64_t *);
 
-int atomic_add_ret(int, atomic_t *);
-long atomic64_add_ret(long, atomic64_t *);
-int atomic_sub_ret(int, atomic_t *);
-long atomic64_sub_ret(long, atomic64_t *);
+#define ATOMIC_OP_RETURN(op)						\
+int atomic_##op##_return(int, atomic_t *);				\
+long atomic64_##op##_return(long, atomic64_t *);
 
-#define atomic_dec_return(v) atomic_sub_ret(1, v)
-#define atomic64_dec_return(v) atomic64_sub_ret(1, v)
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-#define atomic_inc_return(v) atomic_add_ret(1, v)
-#define atomic64_inc_return(v) atomic64_add_ret(1, v)
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-#define atomic_sub_return(i, v) atomic_sub_ret(i, v)
-#define atomic64_sub_return(i, v) atomic64_sub_ret(i, v)
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-#define atomic_add_return(i, v) atomic_add_ret(i, v)
-#define atomic64_add_return(i, v) atomic64_add_ret(i, v)
+#define atomic_dec_return(v)   atomic_sub_return(1, v)
+#define atomic64_dec_return(v) atomic64_sub_return(1, v)
+
+#define atomic_inc_return(v)   atomic_add_return(1, v)
+#define atomic64_inc_return(v) atomic64_add_return(1, v)
 
 /*
  * atomic_inc_and_test - increment and test
@@ -53,11 +54,11 @@ long atomic64_sub_ret(long, atomic64_t *);
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
@@ -65,8 +66,8 @@ long atomic64_sub_ret(long, atomic64_t *);
 #define atomic_dec(v) atomic_sub(1, v)
 #define atomic64_dec(v) atomic64_sub(1, v)
 
-#define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
-#define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
+#define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
+#define atomic64_add_negative(i, v) (atomic64_add_return(i, v) < 0)
 
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 41aa2478f3ca..32dab009915f 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1138,7 +1138,7 @@ static unsigned long penguins_are_doing_time;
 
 void smp_capture(void)
 {
-	int result = atomic_add_ret(1, &smp_capture_depth);
+	int result = atomic_add_return(1, &smp_capture_depth);
 
 	if (result == 1) {
 		int ncpus = num_online_cpus();
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index 1d32b54089aa..a7c418ac26af 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -27,18 +27,23 @@ static DEFINE_SPINLOCK(dummy);
 
 #endif /* SMP */
 
-int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
-
-	ret = (v->counter += i);
-
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
-	return ret;
-}
-EXPORT_SYMBOL(__atomic_add_return);
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
+
+ATOMIC_OP(add, +=)
+
+#undef ATOMIC_OP
 
 int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
diff --git a/arch/sparc/lib/atomic_64.S b/arch/sparc/lib/atomic_64.S
index 85c233d0a340..05dac43907d1 100644
--- a/arch/sparc/lib/atomic_64.S
+++ b/arch/sparc/lib/atomic_64.S
@@ -14,109 +14,80 @@
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
+#define ATOMIC_OP_RETURN(op)						\
+ENTRY(atomic_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	lduw	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	cas	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
+	 op	%g1, %o0, %g1;						\
+	retl;								\
+	 sra	%g1, 0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic_##op##_return);
 
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
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
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
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
+#define ATOMIC64_OP_RETURN(op)						\
+ENTRY(atomic64_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	ldx	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	casx	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 op	%g1, %o0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic64_##op##_return);
+
+#define ATOMIC64_OPS(op) ATOMIC64_OP(op) ATOMIC64_OP_RETURN(op)
+
+ATOMIC64_OPS(add)
+ATOMIC64_OPS(sub)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 ENTRY(atomic64_dec_if_positive) /* %o0 = atomic_ptr */
 	BACKOFF_SETUP(%o2)
diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 323335b9cd2b..1d649a95660c 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -99,14 +99,23 @@ EXPORT_SYMBOL(___copy_in_user);
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
+EXPORT_SYMBOL(atomic64_##op);
+
+#define ATOMIC_OP_RETURN(op)						\
+EXPORT_SYMBOL(atomic_##op##_return);					\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 EXPORT_SYMBOL(atomic64_dec_if_positive);
 
 /* Atomic bit operations. */
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 6dd1c7dd0473..5e5cd123fdfb 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -24,7 +24,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /**
@@ -219,21 +219,6 @@ static inline short int atomic_inc_short(short int *v)
 	return *v;
 }
 
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 46e9052bbd28..f8d273e18516 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -18,7 +18,7 @@
  */
 static inline long atomic64_read(const atomic64_t *v)
 {
-	return (*(volatile long *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /**
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index e5103b47a8ce..00b7d46b35b8 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -47,7 +47,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 
 /**
  * atomic_set - set atomic variable
@@ -58,165 +58,96 @@
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
-}
-
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
-
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
 
-/*
- * We use atomic_{add|sub}_return to define other functions.
- */
-
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
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
+#else /* XCHAL_HAVE_S32C1I */
+
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
 
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
+#endif /* XCHAL_HAVE_S32C1I */
 
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return vval;
-#endif
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 9c79e7603459..1973ad2b13f4 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -18,14 +18,100 @@
 #include <asm/cmpxchg.h>
 #include <asm/barrier.h>
 
+/*
+ * atomic_$op() - $op integer to atomic variable
+ * @i: integer value to $op
+ * @v: pointer to the atomic variable
+ *
+ * Atomically $ops @i to @v. Does not strictly guarantee a memory-barrier, use
+ * smp_mb__{before,after}_atomic().
+ */
+
+/*
+ * atomic_$op_return() - $op interer to atomic variable and returns the result
+ * @i: integer value to $op
+ * @v: pointer to the atomic variable
+ *
+ * Atomically $ops @i to @v. Does imply a full memory barrier.
+ */
+
 #ifdef CONFIG_SMP
-/* Force people to define core atomics */
-# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
-     !defined(atomic_clear_mask) || !defined(atomic_set_mask)
-#  error "SMP requires a little arch-specific magic"
-# endif
+
+/* we can build all atomic primitives from cmpxchg */
+
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int c, old;							\
+									\
+	c = v->counter;							\
+	while ((old = cmpxchg(&v->counter, c, c c_op i)) != c)		\
+		c = old;						\
+}
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int c, old;							\
+									\
+	c = v->counter;							\
+	while ((old = cmpxchg(&v->counter, c, c c_op i)) != c)		\
+		c = old;						\
+									\
+	return c c_op i;						\
+}
+
+#else
+
+#include <linux/irqflags.h>
+
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter = v->counter c_op i;					\
+	raw_local_irq_restore(flags);					\
+}
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	raw_local_irq_save(flags);					\
+	ret = (v->counter = v->counter c_op i);				\
+	raw_local_irq_restore(flags);					\
+									\
+	return ret;							\
+}
+
+#endif /* CONFIG_SMP */
+
+#ifndef atomic_add_return
+ATOMIC_OP_RETURN(add, +)
+#endif
+
+#ifndef atomic_sub_return
+ATOMIC_OP_RETURN(sub, -)
+#endif
+
+#ifndef atomic_clear_mask
+ATOMIC_OP(and, &)
+#define atomic_clear_mask(i, v) atomic_and(~(i), (v))
 #endif
 
+#ifndef atomic_set_mask
+#define CONFIG_ARCH_HAS_ATOMIC_OR
+ATOMIC_OP(or, |)
+#define atomic_set_mask(i, v)	atomic_or((i), (v))
+#endif
+
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
@@ -33,8 +119,6 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#ifdef __KERNEL__
-
 /**
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
@@ -42,7 +126,7 @@
  * Atomically reads the value of @v.
  */
 #ifndef atomic_read
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #endif
 
 /**
@@ -56,52 +140,6 @@
 
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
@@ -139,49 +177,11 @@ static inline void atomic_dec(atomic_t *v)
 
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-  int c, old;
-  c = atomic_read(v);
-  while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
-    c = old;
-  return c;
-}
-
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
+	int c, old;
+	c = atomic_read(v);
+	while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
+		c = old;
+	return c;
 }
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
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
index b18ce4f9ee3d..30ad9c86cebb 100644
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -20,10 +20,22 @@ typedef struct {
 
 extern long long atomic64_read(const atomic64_t *v);
 extern void	 atomic64_set(atomic64_t *v, long long i);
-extern void	 atomic64_add(long long a, atomic64_t *v);
-extern long long atomic64_add_return(long long a, atomic64_t *v);
-extern void	 atomic64_sub(long long a, atomic64_t *v);
-extern long long atomic64_sub_return(long long a, atomic64_t *v);
+
+#define ATOMIC64_OP(op)							\
+extern void	 atomic64_##op(long long a, atomic64_t *v);
+
+#define ATOMIC64_OP_RETURN(op)						\
+extern long long atomic64_##op##_return(long long a, atomic64_t *v);
+
+#define ATOMIC64_OPS(op)	ATOMIC64_OP(op) ATOMIC64_OP_RETURN(op)
+
+ATOMIC64_OPS(add)
+ATOMIC64_OPS(sub)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
+
 extern long long atomic64_dec_if_positive(atomic64_t *v);
 extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
 extern long long atomic64_xchg(atomic64_t *v, long long new);
diff --git a/lib/atomic64.c b/lib/atomic64.c
index 08a4f068e61e..1298c05ef528 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -70,53 +70,42 @@ void atomic64_set(atomic64_t *v, long long i)
 }
 EXPORT_SYMBOL(atomic64_set);
 
-void atomic64_add(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-long long atomic64_add_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
-
-void atomic64_sub(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_sub);
-
-long long atomic64_sub_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_sub_return);
+#define ATOMIC64_OP(op, c_op)						\
+void atomic64_##op(long long a, atomic64_t *v)				\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	v->counter c_op a;						\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+}									\
+EXPORT_SYMBOL(atomic64_##op);
+
+#define ATOMIC64_OP_RETURN(op, c_op)					\
+long long atomic64_##op##_return(long long a, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+	long long val;							\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	val = (v->counter c_op a);					\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+	return val;							\
+}									\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+#define ATOMIC64_OPS(op, c_op)						\
+	ATOMIC64_OP(op, c_op)						\
+	ATOMIC64_OP_RETURN(op, c_op)
+
+ATOMIC64_OPS(add, +=)
+ATOMIC64_OPS(sub, -=)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
