Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaHNRWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:22:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaHNRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:22:29 -0400
Date: Thu, 14 Aug 2014 10:21:25 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ef31563e950c60bb41b97c2b61c32de874f3c949@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, macro@codesourcery.com,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, macro@codesourcery.com,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20140508135852.521548500@infradead.org>
References: <20140508135852.521548500@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,mips: Fold atomic_ops
Git-Commit-ID: ef31563e950c60bb41b97c2b61c32de874f3c949
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

Commit-ID:  ef31563e950c60bb41b97c2b61c32de874f3c949
Gitweb:     http://git.kernel.org/tip/ef31563e950c60bb41b97c2b61c32de874f3c949
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 17:56:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:09 +0200

locking,arch,mips: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maciej W. Rozycki <macro@codesourcery.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20140508135852.521548500@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/include/asm/atomic.h | 557 ++++++++++++++---------------------------
 1 file changed, 187 insertions(+), 370 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 37b2bef..476fe3b 100644
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
