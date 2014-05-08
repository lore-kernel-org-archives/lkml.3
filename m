Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaEHODn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:03:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaEHOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:51 -0400
Message-Id: <20140508135852.171567636@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 08/20] arch,hexagon: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-hexagon-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, no LoC saved in this case because the !return variants were
defined in terms of the return ops. Still do it because this also
prepares for easy addition of new ops.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/hexagon/include/asm/atomic.h |   68 ++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/hexagon/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/hexagon/include/asm/atomic.h
+++ linux-2.6/arch/hexagon/include/asm/atomic.h
@@ -81,41 +81,47 @@ static inline int atomic_cmpxchg(atomic_
 	return __oldval;
 }
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int output;
-
-	__asm__ __volatile__ (
-		"1:	%0 = memw_locked(%1);\n"
-		"	%0 = add(%0,%2);\n"
-		"	memw_locked(%1,P3)=%0;\n"
-		"	if !P3 jump 1b;\n"
-		: "=&r" (output)
-		: "r" (&v->counter), "r" (i)
-		: "memory", "p3"
-	);
-	return output;
-
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int output;							\
+									\
+	__asm__ __volatile__ (						\
+		"1:	%0 = memw_locked(%1);\n"			\
+		"	%0 = "#op "(%0,%2);\n"				\
+		"	memw_locked(%1,P3)=%0;\n"			\
+		"	if !P3 jump 1b;\n"				\
+		: "=&r" (output)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory", "p3"					\
+	);								\
+}									\
+
+#define ATOMIC_OP_RETURN(op)							\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int output;							\
+									\
+	__asm__ __volatile__ (						\
+		"1:	%0 = memw_locked(%1);\n"			\
+		"	%0 = "#op "(%0,%2);\n"				\
+		"	memw_locked(%1,P3)=%0;\n"			\
+		"	if !P3 jump 1b;\n"				\
+		: "=&r" (output)					\
+		: "r" (&v->counter), "r" (i)				\
+		: "memory", "p3"					\
+	);								\
+	return output;							\
 }
 
-#define atomic_add(i, v) atomic_add_return(i, (v))
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int output;
-	__asm__ __volatile__ (
-		"1:	%0 = memw_locked(%1);\n"
-		"	%0 = sub(%0,%2);\n"
-		"	memw_locked(%1,P3)=%0\n"
-		"	if !P3 jump 1b;\n"
-		: "=&r" (output)
-		: "r" (&v->counter), "r" (i)
-		: "memory", "p3"
-	);
-	return output;
-}
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-#define atomic_sub(i, v) atomic_sub_return(i, (v))
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 /**
  * __atomic_add_unless - add unless the number is a given value


