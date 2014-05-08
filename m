Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaEHODA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:03:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaEHOAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:53 -0400
Message-Id: <20140508135852.104572724@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>
Subject: [PATCH 07/20] arch,cris: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-cris-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/cris/include/arch-v10/arch/system.h |    2 -
 arch/cris/include/asm/atomic.h           |   57 +++++++++++++------------------
 2 files changed, 25 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/cris/include/arch-v10/arch/system.h
===================================================================
--- linux-2.6.orig/arch/cris/include/arch-v10/arch/system.h
+++ linux-2.6/arch/cris/include/arch-v10/arch/system.h
@@ -36,8 +36,6 @@ static inline unsigned long _get_base(ch
   return 0;
 }
 
-#define nop() __asm__ __volatile__ ("nop");
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 #define tas(ptr) (xchg((ptr),1))
 
Index: linux-2.6/arch/cris/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/atomic.h
+++ linux-2.6/arch/cris/include/asm/atomic.h
@@ -21,43 +21,36 @@
 
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


