Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaHNRVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:21:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHNRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:48 -0400
Date: Thu, 14 Aug 2014 10:20:53 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d839bae4269aea46bff4133066a411cfba5c7c46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de
In-Reply-To: <20140509091646.GO30445@twins.programming.kicks-ass.net>
References: <20140509091646.GO30445@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,m68k: Fold atomic_ops
Git-Commit-ID: d839bae4269aea46bff4133066a411cfba5c7c46
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

Commit-ID:  d839bae4269aea46bff4133066a411cfba5c7c46
Gitweb:     http://git.kernel.org/tip/d839bae4269aea46bff4133066a411cfba5c7c46
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 19:06:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:08 +0200

locking,arch,m68k: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires asm_op due to eor.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-m68k@lists.linux-m68k.org
Link: http://lkml.kernel.org/r/20140509091646.GO30445@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/m68k/include/asm/atomic.h | 109 ++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 62 deletions(-)

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 5569521..663d4ba 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -30,16 +30,57 @@
 #define	ASM_DI	"di"
 #endif
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__asm__ __volatile__("addl %1,%0" : "+m" (*v) : ASM_DI (i));
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
+}									\
+
+#ifdef CONFIG_RMW_INSNS
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int t, tmp;							\
+									\
+	__asm__ __volatile__(						\
+			"1:	movel %2,%1\n"				\
+			"	" #asm_op "l %3,%1\n"			\
+			"	casl %2,%1,%0\n"			\
+			"	jne 1b"					\
+			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
+			: "g" (i), "2" (atomic_read(v)));		\
+	return t;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
+#else
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long flags;						\
+	int t;								\
+									\
+	local_irq_save(flags);						\
+	t = (v->counter c_op i);					\
+	local_irq_restore(flags);					\
+									\
+	return t;							\
 }
 
+#endif /* CONFIG_RMW_INSNS */
+
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 static inline void atomic_inc(atomic_t *v)
 {
 	__asm__ __volatile__("addql #1,%0" : "+m" (*v));
@@ -76,67 +117,11 @@ static inline int atomic_inc_and_test(atomic_t *v)
 
 #ifdef CONFIG_RMW_INSNS
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	addl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	subl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 #else /* !CONFIG_RMW_INSNS */
 
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t += i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t -= i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	unsigned long flags;
