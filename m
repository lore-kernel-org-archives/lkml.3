Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaEHOA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaEHOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:52 -0400
Message-Id: <20140508135852.825281379@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 18/20] arch,sparc: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-sparc-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/sparc/include/asm/atomic_32.h  |   19 +--
 arch/sparc/include/asm/atomic_64.h  |   49 +++++-----
 arch/sparc/include/asm/barrier_32.h |    1 
 arch/sparc/include/asm/processor.h  |    2 
 arch/sparc/kernel/smp_64.c          |    2 
 arch/sparc/lib/atomic32.c           |   25 +++--
 arch/sparc/lib/atomic_64.S          |  175 +++++++++++++++---------------------
 arch/sparc/lib/ksyms.c              |   25 +++--
 8 files changed, 140 insertions(+), 158 deletions(-)

Index: linux-2.6/arch/sparc/include/asm/atomic_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/atomic_32.h
+++ linux-2.6/arch/sparc/include/asm/atomic_32.h
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
 
Index: linux-2.6/arch/sparc/include/asm/atomic_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/atomic_64.h
+++ linux-2.6/arch/sparc/include/asm/atomic_64.h
@@ -20,27 +20,28 @@
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
+extern void atomic64_##op(long, atomic64_t *);
 
-#define atomic_inc_return(v) atomic_add_ret(1, v)
-#define atomic64_inc_return(v) atomic64_add_ret(1, v)
+#define ATOMIC_OP_RETURN(op)						\
+extern int atomic_##op##_return(int, atomic_t *);			\
+extern long atomic64_##op##_return(long, atomic64_t *);
 
-#define atomic_sub_return(i, v) atomic_sub_ret(i, v)
-#define atomic64_sub_return(i, v) atomic64_sub_ret(i, v)
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-#define atomic_add_return(i, v) atomic_add_ret(i, v)
-#define atomic64_add_return(i, v) atomic64_add_ret(i, v)
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
+#define atomic_dec_return(v)   atomic_sub_return(1, v)
+#define atomic64_dec_return(v) atomic64_sub_return(1, v)
+
+#define atomic_inc_return(v)   atomic_add_return(1, v)
+#define atomic64_inc_return(v) atomic64_add_return(1, v)
 
 /*
  * atomic_inc_and_test - increment and test
@@ -53,11 +54,11 @@ extern long atomic64_sub_ret(long, atomi
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
@@ -65,8 +66,8 @@ extern long atomic64_sub_ret(long, atomi
 #define atomic_dec(v) atomic_sub(1, v)
 #define atomic64_dec(v) atomic64_sub(1, v)
 
-#define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
-#define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
+#define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
+#define atomic64_add_negative(i, v) (atomic64_add_return(i, v) < 0)
 
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
Index: linux-2.6/arch/sparc/include/asm/barrier_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/barrier_32.h
+++ linux-2.6/arch/sparc/include/asm/barrier_32.h
@@ -1,7 +1,6 @@
 #ifndef __SPARC_BARRIER_H
 #define __SPARC_BARRIER_H
 
-#include <asm/processor.h> /* for nop() */
 #include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
Index: linux-2.6/arch/sparc/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/processor.h
+++ linux-2.6/arch/sparc/include/asm/processor.h
@@ -6,6 +6,4 @@
 #include <asm/processor_32.h>
 #endif
 
-#define nop() 		__asm__ __volatile__ ("nop")
-
 #endif
Index: linux-2.6/arch/sparc/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_64.c
+++ linux-2.6/arch/sparc/kernel/smp_64.c
@@ -1148,7 +1148,7 @@ static unsigned long penguins_are_doing_
 
 void smp_capture(void)
 {
-	int result = atomic_add_ret(1, &smp_capture_depth);
+	int result = atomic_add_return(1, &smp_capture_depth);
 
 	if (result == 1) {
 		int ncpus = num_online_cpus();
Index: linux-2.6/arch/sparc/lib/atomic32.c
===================================================================
--- linux-2.6.orig/arch/sparc/lib/atomic32.c
+++ linux-2.6/arch/sparc/lib/atomic32.c
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
Index: linux-2.6/arch/sparc/lib/atomic_64.S
===================================================================
--- linux-2.6.orig/arch/sparc/lib/atomic_64.S
+++ linux-2.6/arch/sparc/lib/atomic_64.S
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
-
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
-
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
+
+#define ATOMIC_OP_RETURN(op)						\
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
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
+
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
+	 add	%g1, %o0, %o0;						\
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
Index: linux-2.6/arch/sparc/lib/ksyms.c
===================================================================
--- linux-2.6.orig/arch/sparc/lib/ksyms.c
+++ linux-2.6/arch/sparc/lib/ksyms.c
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


