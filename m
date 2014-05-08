Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaEHOD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:03:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaEHOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:51 -0400
Message-Id: <20140508135851.832107183@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>
Subject: [PATCH 02/20] arch,alpha: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-alpha-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/atomic.h |  225 +++++++++++++++-------------------------
 1 file changed, 86 insertions(+), 139 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/atomic.h
+++ linux-2.6/arch/alpha/include/asm/atomic.h
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
+}
+
+#define ATOMIC_OPS(opg)							\
+	ATOMIC_OP(opg)							\
+	ATOMIC_OP_RETURN(opg)						\
+	ATOMIC64_OP(opg)						\
+	ATOMIC64_OP_RETURN(opg)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 #define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))


