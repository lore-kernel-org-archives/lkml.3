Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaEHOAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaEHOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:52 -0400
Message-Id: <20140508135852.318635136@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 10/20] arch,m32r: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-m32r-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/m32r/include/asm/atomic.h |  151 ++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 90 deletions(-)

Index: linux-2.6/arch/m32r/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/atomic.h
+++ linux-2.6/arch/m32r/include/asm/atomic.h
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
 #ifdef CONFIG_CHIP_M32700_TS1
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
+}
+
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
@@ -151,9 +130,7 @@ static __inline__ int atomic_inc_return(
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -181,9 +158,7 @@ static __inline__ int atomic_dec_return(
 		: "=&r" (result)
 		: "r" (&v->counter)
 		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
+		__ATOMIC_CLOBBER
 	);
 	local_irq_restore(flags);
 
@@ -280,9 +255,7 @@ static __inline__ void atomic_clear_mask
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
@@ -302,9 +275,7 @@ static __inline__ void atomic_set_mask(u
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


