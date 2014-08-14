Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHNRTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:19:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaHNRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:19:54 -0400
Date: Thu, 14 Aug 2014 10:18:48 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-b93c7b8c5b281bf3646d6c5b6e05249b98cc5ab7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20140508135851.832107183@infradead.org>
References: <20140508135851.832107183@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,alpha: Fold atomic_ops
Git-Commit-ID: b93c7b8c5b281bf3646d6c5b6e05249b98cc5ab7
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

Commit-ID:  b93c7b8c5b281bf3646d6c5b6e05249b98cc5ab7
Gitweb:     http://git.kernel.org/tip/b93c7b8c5b281bf3646d6c5b6e05249b98cc5ab7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 16:25:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:03 +0200

locking,arch,alpha: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135851.832107183@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/atomic.h | 213 +++++++++++++++-------------------------
 1 file changed, 80 insertions(+), 133 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index ed60a1e..6fbb53a 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
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
