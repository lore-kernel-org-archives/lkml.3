Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaEHOCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:02:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaEHOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:54 -0400
Message-Id: <20140508135852.879575796@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 19/20] arch,xtensa: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-xtensa-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Chris Zankel <chris@zankel.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/xtensa/include/asm/atomic.h |  231 +++++++++++++--------------------------
 1 file changed, 81 insertions(+), 150 deletions(-)

Index: linux-2.6/arch/xtensa/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/atomic.h
+++ linux-2.6/arch/xtensa/include/asm/atomic.h
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
+#else /* XCHAL_HAVE_S32C1I */
 
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
 
-/*
- * We use atomic_{add|sub}_return to define other functions.
- */
-
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
+#endif /* XCHAL_HAVE_S32C1I */
 
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	return vval;
-#endif
-}
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-static inline int atomic_sub_return(int i, atomic_t * v)
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
-			"       sub     %0, %0, %2\n"
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
-			"       sub     %0, %0, %1\n"
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
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result


