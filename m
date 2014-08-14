Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaHNRUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:20:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbaHNRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:19:58 -0400
Date: Thu, 14 Aug 2014 10:19:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-f7d11e93ee97a37da1947b7c4e1794705a6f360c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de
In-Reply-To: <20140508135851.886055622@infradead.org>
References: <20140508135851.886055622@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,arc: Fold atomic_ops
Git-Commit-ID: f7d11e93ee97a37da1947b7c4e1794705a6f360c
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

Commit-ID:  f7d11e93ee97a37da1947b7c4e1794705a6f360c
Gitweb:     http://git.kernel.org/tip/f7d11e93ee97a37da1947b7c4e1794705a6f360c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 16:29:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:03 +0200

locking,arch,arc: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Link: http://lkml.kernel.org/r/20140508135851.886055622@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arc/include/asm/atomic.h | 184 +++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 121 deletions(-)

diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 83f03ca..173f303 100644
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
