Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaDRNLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:11:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaDRNLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:11:30 -0400
Date: Fri, 18 Apr 2014 06:10:20 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-dqnyo215kq38wi4xcxnbpjw3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        james.hogan@imgtec.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        james.hogan@imgtec.com, torvalds@linux-foundation.org,
        will.deacon@arm.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,metag: Convert smp_mb__*()
Git-Commit-ID: 40074dece684fc61ab72cfc1689d564cba1c5f64
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

Commit-ID:  40074dece684fc61ab72cfc1689d564cba1c5f64
Gitweb:     http://git.kernel.org/tip/40074dece684fc61ab72cfc1689d564cba1c5f64
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:38 +0200

arch,metag: Convert smp_mb__*()

Implement the new barriers; as per the old versions the metag atomic
imply a full barrier.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-dqnyo215kq38wi4xcxnbpjw3@git.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-metag@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/include/asm/atomic.h  | 6 +-----
 arch/metag/include/asm/barrier.h | 3 +++
 arch/metag/include/asm/bitops.h  | 6 ------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/metag/include/asm/atomic.h b/arch/metag/include/asm/atomic.h
index 307ecd2..470e365 100644
--- a/arch/metag/include/asm/atomic.h
+++ b/arch/metag/include/asm/atomic.h
@@ -4,6 +4,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #if defined(CONFIG_METAG_ATOMICITY_IRQSOFF)
 /* The simple UP case. */
@@ -39,11 +40,6 @@
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif
 
 #define atomic_dec_if_positive(v)       atomic_sub_if_positive(1, v)
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index 5d6b4b4..d1768c6 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -97,4 +97,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/metag/include/asm/bitops.h b/arch/metag/include/asm/bitops.h
index c0d0df0..2671134 100644
--- a/arch/metag/include/asm/bitops.h
+++ b/arch/metag/include/asm/bitops.h
@@ -5,12 +5,6 @@
 #include <asm/barrier.h>
 #include <asm/global_lock.h>
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #ifdef CONFIG_SMP
 /*
  * These functions are the basis of our bit ops.
