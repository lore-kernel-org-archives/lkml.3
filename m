Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaHNRV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaHNRVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:05 -0400
Date: Thu, 14 Aug 2014 10:19:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7179e30ef66a5bae91592ae7fbacf3df6c627dd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        starvik@axis.com, tglx@linutronix.de
In-Reply-To: <20140508135852.104572724@infradead.org>
References: <20140508135852.104572724@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,cris: Fold atomic_ops
Git-Commit-ID: 7179e30ef66a5bae91592ae7fbacf3df6c627dd6
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

Commit-ID:  7179e30ef66a5bae91592ae7fbacf3df6c627dd6
Gitweb:     http://git.kernel.org/tip/7179e30ef66a5bae91592ae7fbacf3df6c627dd6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 18:19:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:06 +0200

locking,arch,cris: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-cris-kernel@axis.com
Link: http://lkml.kernel.org/r/20140508135852.104572724@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/cris/include/asm/atomic.h | 57 ++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index aa429ba..0033f9d 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -22,43 +22,36 @@
 
 /* These should be written in asm but we do it in C for now. */
 
-static inline void atomic_add(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	cris_atomic_save(v, flags);
-	v->counter += i;
-	cris_atomic_restore(v, flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, volatile atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	cris_atomic_save(v, flags);					\
+	v->counter c_op i;						\
+	cris_atomic_restore(v, flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, volatile atomic_t *v)	\
+{									\
+	unsigned long flags;						\
+	int retval;							\
+	cris_atomic_save(v, flags);					\
+	retval = (v->counter c_op i);					\
+	cris_atomic_restore(v, flags);					\
+	return retval;							\
 }
 
-static inline void atomic_sub(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	cris_atomic_save(v, flags);
-	v->counter -= i;
-	cris_atomic_restore(v, flags);
-}
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-static inline int atomic_add_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter += i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-static inline int atomic_sub_return(int i, volatile atomic_t *v)
-{
-	unsigned long flags;
-	int retval;
-	cris_atomic_save(v, flags);
-	retval = (v->counter -= i);
-	cris_atomic_restore(v, flags);
-	return retval;
-}
+#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
 static inline int atomic_sub_and_test(int i, volatile atomic_t *v)
 {
