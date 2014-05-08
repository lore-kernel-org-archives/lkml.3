Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaEHOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:05:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaEHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:45 -0400
Message-Id: <20140508135851.939725247@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Albin Tonnerre <albin.tonnerre@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chen Gang <gang.chen@asianux.com>, Nicolas Pitre <nico@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH 04/20] arch,arm: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-arm-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires the asm_op because of eor.

Cc: Albin Tonnerre <albin.tonnerre@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm/include/asm/atomic.h |  313 +++++++++++++++++-------------------------
 1 file changed, 127 insertions(+), 186 deletions(-)

--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
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
-
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
@@ -174,33 +137,29 @@ static inline int __atomic_add_unless(at
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
-}
-#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
 
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
@@ -228,6 +187,17 @@ static inline int __atomic_add_unless(at
 
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
@@ -300,89 +270,60 @@ static inline void atomic64_set(atomic64
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
-}
-
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
-
-	smp_mb();
-
-	return result;
-}
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
+}
+
+#define ATOMIC64_OPS(op, op1, op2)					\
+	ATOMIC64_OP(op, op1, op2)					\
+	ATOMIC64_OP_RETURN(op, op1, op2)
+
+ATOMIC64_OPS(add, adds, adc)
+ATOMIC64_OPS(sub, subs, sbc)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static inline long long atomic64_cmpxchg(atomic64_t *ptr, long long old,
 					long long new)


