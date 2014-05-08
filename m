Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaEHOCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:02:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaEHOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:55 -0400
Message-Id: <20140508135852.521548500@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Maciej W. Rozycki" <macro@codesourcery.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 13/20] arch,mips: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-mips-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@codesourcery.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/mips/include/asm/atomic.h |  565 +++++++++++++----------------------------
 1 file changed, 191 insertions(+), 374 deletions(-)

--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
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
+		"	addu	%0, %1, %3				\n"	\
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
+		result = temp + i;						\
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
+#define ATOMIC_OPS(op, c_op, asm_op)						\
+	ATOMIC_OP(op, c_op, asm_op)						\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, addu)
+ATOMIC_OPS(sub, -=, subu)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /*
  * atomic_sub_if_positive - conditionally subtract integer from atomic variable
@@ -407,195 +315,104 @@ static __inline__ int __atomic_add_unles
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
+		result = temp + i;						\
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
-
-	smp_mb__before_llsc();
-
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
+#define ATOMIC64_OPS(op, c_op, asm_op)						\
+	ATOMIC64_OP(op, c_op, asm_op)						\
+	ATOMIC64_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC64_OPS(add, +=, daddu)
+ATOMIC64_OPS(sub, -=, dsubu)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 /*
  * atomic64_sub_if_positive - conditionally subtract integer from atomic variable


