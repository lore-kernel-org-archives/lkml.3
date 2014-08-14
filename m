Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaHNRVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:21:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaHNRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:35 -0400
Date: Thu, 14 Aug 2014 10:20:39 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c9ebe21b204f95e3aba84ee91c8b9347d73806f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, takata@linux-m32r.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, takata@linux-m32r.org
In-Reply-To: <20140508135852.318635136@infradead.org>
References: <20140508135852.318635136@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,m32r: Fold atomic_ops
Git-Commit-ID: c9ebe21b204f95e3aba84ee91c8b9347d73806f1
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

Commit-ID:  c9ebe21b204f95e3aba84ee91c8b9347d73806f1
Gitweb:     http://git.kernel.org/tip/c9ebe21b204f95e3aba84ee91c8b9347d73806f1
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 19:02:22 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:08 +0200

locking,arch,m32r: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-m32r-ja@ml.linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org
Link: http://lkml.kernel.org/r/20140508135852.318635136@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/m32r/include/asm/atomic.h | 143 ++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 86 deletions(-)

diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 8ad0ed4..3946b2c 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
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
