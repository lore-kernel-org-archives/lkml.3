Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaHNRU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:20:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaHNRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:20:55 -0400
Date: Thu, 14 Aug 2014 10:19:44 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d325209b6000dcd13404ee946d2292e15a56718c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, hskinnemoen@gmail.com, tglx@linutronix.de,
        egtvedt@samfundet.no
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, hskinnemoen@gmail.com, tglx@linutronix.de,
        egtvedt@samfundet.no
In-Reply-To: <20140531141445.GD16155@laptop.programming.kicks-ass.net>
References: <20140531141445.GD16155@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,avr32: Fold atomic_ops
Git-Commit-ID: d325209b6000dcd13404ee946d2292e15a56718c
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

Commit-ID:  d325209b6000dcd13404ee946d2292e15a56718c
Gitweb:     http://git.kernel.org/tip/d325209b6000dcd13404ee946d2292e15a56718c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 9 Apr 2014 21:51:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:05 +0200

locking,arch,avr32: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires the asm_op because of eor.

AVR32 is a bit special in that its ADD/SUB instructions are not
symmetric. Its SUB instruction allows for an 21bit immediate.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140531141445.GD16155@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/avr32/include/asm/atomic.h | 123 ++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 61 deletions(-)

diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 0780f3f..83e980a 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -22,30 +22,43 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
+#define ATOMIC_OP_RETURN(op, asm_op, asm_con)				\
+static inline int __atomic_##op##_return(int i, atomic_t *v)		\
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
+		: "=&r" (result), "=o" (v->counter)			\
+		: "m" (v->counter), #asm_con (i)			\
+		: "cc");						\
+									\
+	return result;							\
+}
+
+ATOMIC_OP_RETURN(sub, sub, rKs21)
+ATOMIC_OP_RETURN(add, add, r)
+
+#undef ATOMIC_OP_RETURN
+
 /*
- * atomic_sub_return - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
+ * Probably found the reason why we want to use sub with the signed 21-bit
+ * limit, it uses one less register than the add instruction that can add up to
+ * 32-bit values.
  *
- * Atomically subtracts @i from @v. Returns the resulting value.
+ * Both instructions are 32-bit, to use a 16-bit instruction the immediate is
+ * very small; 4 bit.
+ *
+ * sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
+ * add 32-bit, type II, adds two register values together.
  */
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
-}
+#define IS_21BIT_CONST(i)						\
+	(__builtin_constant_p(i) && ((i) >= -1048575) && ((i) <= 1048576))
 
 /*
  * atomic_add_return - add integer to atomic variable
@@ -56,51 +69,25 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
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
+	if (IS_21BIT_CONST(i))
+		return __atomic_sub_return(-i, v);
 
-	return result;
+	return __atomic_add_return(i, v);
 }
 
 /*
- * atomic_sub_unless - sub unless the number is a given value
+ * atomic_sub_return - subtract the atomic variable
+ * @i: integer value to subtract
  * @v: pointer of type atomic_t
- * @a: the amount to subtract from v...
- * @u: ...unless v is equal to u.
  *
- * Atomically subtract @a from @v, so long as it was not @u.
- * Returns the old value of @v.
-*/
-static inline void atomic_sub_unless(atomic_t *v, int a, int u)
+ * Atomically subtracts @i from @v. Returns the resulting value.
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
 {
-	int tmp;
+	if (IS_21BIT_CONST(i))
+		return __atomic_sub_return(i, v);
 
-	asm volatile(
-		"/* atomic_sub_unless */\n"
-		"1:	ssrf	5\n"
-		"	ld.w	%0, %2\n"
-		"	cp.w	%0, %4\n"
-		"	breq	1f\n"
-		"	sub	%0, %3\n"
-		"	stcond	%1, %0\n"
-		"	brne	1b\n"
-		"1:"
-		: "=&r"(tmp), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
-		: "cc", "memory");
+	return __atomic_add_return(-i, v);
 }
 
 /*
@@ -116,9 +103,21 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int tmp, old = atomic_read(v);
 
-	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
-		atomic_sub_unless(v, -a, u);
-	else {
+	if (IS_21BIT_CONST(a)) {
+		asm volatile(
+			"/* __atomic_sub_unless */\n"
+			"1:	ssrf	5\n"
+			"	ld.w	%0, %2\n"
+			"	cp.w	%0, %4\n"
+			"	breq	1f\n"
+			"	sub	%0, %3\n"
+			"	stcond	%1, %0\n"
+			"	brne	1b\n"
+			"1:"
+			: "=&r"(tmp), "=o"(v->counter)
+			: "m"(v->counter), "rKs21"(-a), "rKs21"(u)
+			: "cc", "memory");
+	} else {
 		asm volatile(
 			"/* __atomic_add_unless */\n"
 			"1:	ssrf	5\n"
@@ -137,6 +136,8 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return old;
 }
 
+#undef IS_21BIT_CONST
+
 /*
  * atomic_sub_if_positive - conditionally subtract integer from atomic variable
  * @i: integer value to subtract
