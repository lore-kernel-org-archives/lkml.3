Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaHNRY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaHNRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:23:15 -0400
Date: Thu, 14 Aug 2014 10:21:56 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-15e3f6d782fc6ff7e004b40642ad895b91ae78bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de
In-Reply-To: <20140508135852.659342353@infradead.org>
References: <20140508135852.659342353@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,parisc: Fold atomic_ops
Git-Commit-ID: 15e3f6d782fc6ff7e004b40642ad895b91ae78bf
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

Commit-ID:  15e3f6d782fc6ff7e004b40642ad895b91ae78bf
Gitweb:     http://git.kernel.org/tip/15e3f6d782fc6ff7e004b40642ad895b91ae78bf
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 18:04:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:11 +0200

locking,arch,parisc: Fold atomic_ops

OK, no LoC saved in this case because sub was defined in terms of add.
Still do it because this also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-parisc@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135852.659342353@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/parisc/include/asm/atomic.h | 113 ++++++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 44 deletions(-)

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 0be2db2..219750b 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -55,24 +55,7 @@ extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
  * are atomic, so a reader never sees inconsistent values.
  */
 
-/* It's possible to reduce all atomic operations to either
- * __atomic_add_return, atomic_set and atomic_read (the latter
- * is there only for consistency).
- */
-
-static __inline__ int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
-
-	ret = (v->counter += i);
-
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
-
-static __inline__ void atomic_set(atomic_t *v, int i) 
+static __inline__ void atomic_set(atomic_t *v, int i)
 {
 	unsigned long flags;
 	_atomic_spin_lock_irqsave(v, flags);
@@ -115,16 +98,43 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
+#define ATOMIC_OP(op, c_op)						\
+static __inline__ void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
+
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
+
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-#define atomic_add(i,v)	((void)(__atomic_add_return(        (i),(v))))
-#define atomic_sub(i,v)	((void)(__atomic_add_return(-((int) (i)),(v))))
-#define atomic_inc(v)	((void)(__atomic_add_return(   1,(v))))
-#define atomic_dec(v)	((void)(__atomic_add_return(  -1,(v))))
+#define atomic_inc(v)	(atomic_add(   1,(v)))
+#define atomic_dec(v)	(atomic_add(  -1,(v)))
 
-#define atomic_add_return(i,v)	(__atomic_add_return( (i),(v)))
-#define atomic_sub_return(i,v)	(__atomic_add_return(-(i),(v)))
-#define atomic_inc_return(v)	(__atomic_add_return(   1,(v)))
-#define atomic_dec_return(v)	(__atomic_add_return(  -1,(v)))
+#define atomic_inc_return(v)	(atomic_add_return(   1,(v)))
+#define atomic_dec_return(v)	(atomic_add_return(  -1,(v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
@@ -148,18 +158,37 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define ATOMIC64_INIT(i) { (i) }
 
-static __inline__ s64
-__atomic64_add_return(s64 i, atomic64_t *v)
-{
-	s64 ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
+#define ATOMIC64_OP(op, c_op)						\
+static __inline__ void atomic64_##op(s64 i, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, c_op)					\
+static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\
+{									\
+	unsigned long flags;						\
+	s64 ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
 
-	ret = (v->counter += i);
+#define ATOMIC64_OPS(op, c_op) ATOMIC64_OP(op, c_op) ATOMIC64_OP_RETURN(op, c_op)
 
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
+ATOMIC64_OPS(add, +=)
+ATOMIC64_OPS(sub, -=)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static __inline__ void
 atomic64_set(atomic64_t *v, s64 i)
@@ -178,15 +207,11 @@ atomic64_read(const atomic64_t *v)
 	return (*(volatile long *)&(v)->counter);
 }
 
-#define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)(i)),(v))))
-#define atomic64_sub(i,v)	((void)(__atomic64_add_return(-((s64)(i)),(v))))
-#define atomic64_inc(v)		((void)(__atomic64_add_return(   1,(v))))
-#define atomic64_dec(v)		((void)(__atomic64_add_return(  -1,(v))))
+#define atomic64_inc(v)		(atomic64_add(   1,(v)))
+#define atomic64_dec(v)		(atomic64_add(  -1,(v)))
 
-#define atomic64_add_return(i,v)	(__atomic64_add_return( ((s64)(i)),(v)))
-#define atomic64_sub_return(i,v)	(__atomic64_add_return(-((s64)(i)),(v)))
-#define atomic64_inc_return(v)		(__atomic64_add_return(   1,(v)))
-#define atomic64_dec_return(v)		(__atomic64_add_return(  -1,(v)))
+#define atomic64_inc_return(v)		(atomic64_add_return(   1,(v)))
+#define atomic64_dec_return(v)		(atomic64_add_return(  -1,(v)))
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
