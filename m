Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaHNRYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:24:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaHNRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:24:02 -0400
Date: Thu, 14 Aug 2014 10:22:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d4608dd5b4ec13855680b89f719d8d4b2da92411@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        jcmvbkbc@gmail.com, chris@zankel.net, paulmck@linux.vnet.ibm.com,
        geert@linux-m68k.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, chris@zankel.net,
        jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        tglx@linutronix.de
In-Reply-To: <20140508135852.879575796@infradead.org>
References: <20140508135852.879575796@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,xtensa: Fold atomic_ops
Git-Commit-ID: d4608dd5b4ec13855680b89f719d8d4b2da92411
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

Commit-ID:  d4608dd5b4ec13855680b89f719d8d4b2da92411
Gitweb:     http://git.kernel.org/tip/d4608dd5b4ec13855680b89f719d8d4b2da92411
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 18:31:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:14 +0200

locking,arch,xtensa: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-xtensa@linux-xtensa.org
Link: http://lkml.kernel.org/r/20140508135852.879575796@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/xtensa/include/asm/atomic.h | 233 ++++++++++++++-------------------------
 1 file changed, 82 insertions(+), 151 deletions(-)

diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index e5103b4..6266766 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
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
-}
-
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
-
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
 
-/*
- * We use atomic_{add|sub}_return to define other functions.
- */
-
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
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
-
-	return vval;
-#endif
+#else /* XCHAL_HAVE_S32C1I */
+
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
 
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
+#endif /* XCHAL_HAVE_S32C1I */
 
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
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
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
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return vval;
-#endif
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
