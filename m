Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaHNRWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:22:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaHNRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:22:06 -0400
Date: Thu, 14 Aug 2014 10:21:09 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d6dfe2509da935a15583cace7cd3837b1e8addef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, james.hogan@imgtec.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        james.hogan@imgtec.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140508135852.453864110@infradead.org>
References: <20140508135852.453864110@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,metag: Fold atomic_ops
Git-Commit-ID: d6dfe2509da935a15583cace7cd3837b1e8addef
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

Commit-ID:  d6dfe2509da935a15583cace7cd3837b1e8addef
Gitweb:     http://git.kernel.org/tip/d6dfe2509da935a15583cace7cd3837b1e8addef
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 19:08:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:09 +0200

locking,arch,metag: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-metag@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135852.453864110@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/include/asm/atomic_lnkget.h | 121 +++++++++++++--------------------
 arch/metag/include/asm/atomic_lock1.h  |  76 +++++++++------------
 2 files changed, 77 insertions(+), 120 deletions(-)

diff --git a/arch/metag/include/asm/atomic_lnkget.h b/arch/metag/include/asm/atomic_lnkget.h
index d2e60a1..948d868 100644
--- a/arch/metag/include/asm/atomic_lnkget.h
+++ b/arch/metag/include/asm/atomic_lnkget.h
@@ -27,85 +27,56 @@ static inline int atomic_read(const atomic_t *v)
 	return temp;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	ADD	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int temp;							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %0, [%1]\n"				\
+		"	" #op "	%0, %0, %2\n"				\
+		"	LNKSETD [%1], %0\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ	1b\n"					\
+		: "=&d" (temp)						\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+}									\
+
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result, temp;						\
+									\
+	smp_mb();							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %1, [%2]\n"				\
+		"	" #op "	%1, %1, %3\n"				\
+		"	LNKSETD [%2], %1\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ 1b\n"					\
+		: "=&d" (temp), "=&da" (result)				\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+									\
+	smp_mb();							\
+									\
+	return result;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int temp;
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	SUB	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-}
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int result, temp;
-
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	ADD	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-
-	smp_mb();
-
-	return result;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result, temp;
-
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	SUB	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
diff --git a/arch/metag/include/asm/atomic_lock1.h b/arch/metag/include/asm/atomic_lock1.h
index e578955..f5d5898 100644
--- a/arch/metag/include/asm/atomic_lock1.h
+++ b/arch/metag/include/asm/atomic_lock1.h
@@ -37,55 +37,41 @@ static inline int atomic_set(atomic_t *v, int i)
 	return i;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter += i;
-	__global_unlock1(flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	fence();							\
+	v->counter c_op i;						\
+	__global_unlock1(flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long result;						\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	result = v->counter;						\
+	result c_op i;							\
+	fence();							\
+	v->counter = result;						\
+	__global_unlock1(flags);					\
+									\
+	return result;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-	__global_lock1(flags);
-	fence();
-	v->counter -= i;
-	__global_unlock1(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-	__global_lock1(flags);
-	result = v->counter;
-	result += i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
-
-	return result;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
-
-	__global_lock1(flags);
-	result = v->counter;
-	result -= i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
-
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
