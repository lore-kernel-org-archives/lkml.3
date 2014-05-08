Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaEHOAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:43812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaEHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:44 -0400
Message-Id: <20140508135852.049922584@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 06/20] arch,avr32: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-avr32-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires the asm_op because of eor.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/avr32/include/asm/atomic.h |   96 ++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 52 deletions(-)

--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -22,58 +22,52 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-/*
- * atomic_sub_return - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v. Returns the resulting value.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result;
-
-	asm volatile(
-		"/* atomic_sub_return */\n"
-		"1:	ssrf	5\n"
-		"	ld.w	%0, %2\n"
-		"	sub	%0, %3\n"
-		"	stcond	%1, %0\n"
-		"	brne	1b"
-		: "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(i)
-		: "cc");
-
-	return result;
+#define ATOMIC_OP(op, asm_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int result;							\
+									\
+	asm volatile(							\
+		"/* atomic_" #op " */\n"				\
+		"1:	ssrf	5\n"					\
+		"	ld.w	%0, %2\n"				\
+		"	" #asm_op "	%0, %3\n"			\
+		"	stcond	%1, %0\n"				\
+		"	brne	1b"					\
+		: "=&r"(result), "=o"(v->counter)			\
+		: "m"(v->counter), "rKs21"(i)				\
+		: "cc");						\
+}									\
+
+#define ATOMIC_OP_RETURN(op, asm_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result;							\
+									\
+	asm volatile(							\
+		"/* atomic_" #op "_return */\n"				\
+		"1:	ssrf	5\n"					\
+		"	ld.w	%0, %2\n"				\
+		"	" #asm_op "	%0, %3\n"			\
+		"	stcond	%1, %0\n"				\
+		"	brne	1b"					\
+		: "=&r"(result), "=o"(v->counter)			\
+		: "m"(v->counter), "rKs21"(i)				\
+		: "cc");						\
+									\
+	return result;							\
 }
 
-/*
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v. Returns the resulting value.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int result;
-
-	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
-		result = atomic_sub_return(-i, v);
-	else
-		asm volatile(
-			"/* atomic_add_return */\n"
-			"1:	ssrf	5\n"
-			"	ld.w	%0, %1\n"
-			"	add	%0, %3\n"
-			"	stcond	%2, %0\n"
-			"	brne	1b"
-			: "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(i)
-			: "cc", "memory");
-
-	return result;
-}
+#define ATOMIC_OPS(op, asm_op)						\
+	ATOMIC_OP(op, asm_op)						\
+	ATOMIC_OP_RETURN(op, asm_op)
+
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /*
  * atomic_sub_unless - sub unless the number is a given value
@@ -168,8 +162,6 @@ static inline int atomic_sub_if_positive
 #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
 #define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
 
-#define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
-#define atomic_add(i, v)	(void)atomic_add_return(i, v)
 #define atomic_dec(v)		atomic_sub(1, (v))
 #define atomic_inc(v)		atomic_add(1, (v))
 


