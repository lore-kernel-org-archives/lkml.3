Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaHNRWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:22:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaHNRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:22:36 -0400
Date: Thu, 14 Aug 2014 10:21:40 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e69a0ef76627005e3e83d0e086e6bb1d247bb65b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        yasutake.koichi@jp.panasonic.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        yasutake.koichi@jp.panasonic.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20140508135852.605324173@infradead.org>
References: <20140508135852.605324173@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,mn10300: Fold atomic_ops
Git-Commit-ID: e69a0ef76627005e3e83d0e086e6bb1d247bb65b
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

Commit-ID:  e69a0ef76627005e3e83d0e086e6bb1d247bb65b
Gitweb:     http://git.kernel.org/tip/e69a0ef76627005e3e83d0e086e6bb1d247bb65b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 17:59:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:10 +0200

locking,arch,mn10300: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-am33-list@redhat.com
Link: http://lkml.kernel.org/r/20140508135852.605324173@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mn10300/include/asm/atomic.h | 125 +++++++++++++-------------------------
 1 file changed, 42 insertions(+), 83 deletions(-)

diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index cadeb1e..5be655e 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -33,7 +33,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_read(v)	(ACCESS_ONCE((v)->counter))
 
@@ -43,102 +42,62 @@
  * @i: required value
  *
  * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	add	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
-
-#else
-	unsigned long flags;
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
+}
 
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval += i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
-	return retval;
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
+	return retval;							\
 }
 
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	sub	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-#else
-	unsigned long flags;
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval -= i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
-	return retval;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	return atomic_add_return(i, v) < 0;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
 static inline void atomic_inc(atomic_t *v)
 {
 	atomic_add_return(1, v);
