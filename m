Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaHNRVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:21:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaHNRVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:05 -0400
Date: Thu, 14 Aug 2014 10:20:11 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-50f853e38b0b90a5703ab14b70e20eb5a8ccd5de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
In-Reply-To: <20140508135852.171567636@infradead.org>
References: <20140508135852.171567636@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,hexagon: Fold atomic_ops
Git-Commit-ID: 50f853e38b0b90a5703ab14b70e20eb5a8ccd5de
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

Commit-ID:  50f853e38b0b90a5703ab14b70e20eb5a8ccd5de
Gitweb:     http://git.kernel.org/tip/50f853e38b0b90a5703ab14b70e20eb5a8ccd5de
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 18:20:26 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:06 +0200

locking,arch,hexagon: Fold atomic_ops

OK, no LoC saved in this case because the !return variants were
defined in terms of the return ops. Still do it because this also
prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-hexagon@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135852.171567636@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/hexagon/include/asm/atomic.h | 68 +++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index de916b1..93d0702 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -94,41 +94,47 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
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
