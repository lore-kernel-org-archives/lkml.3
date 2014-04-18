Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaDRNPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:15:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaDRNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:12:43 -0400
Date: Fri, 18 Apr 2014 06:11:23 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-gg2ffgq32sjgy9b8lj6m3hsc@git.kernel.org>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, mahesh@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, mahesh@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,powerpc: Convert smp_mb__*()
Git-Commit-ID: c645073f7e4f073e1ebcd0f0d91652c4468b8364
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

Commit-ID:  c645073f7e4f073e1ebcd0f0d91652c4468b8364
Gitweb:     http://git.kernel.org/tip/c645073f7e4f073e1ebcd0f0d91652c4468b8364
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:41 +0200

arch,powerpc: Convert smp_mb__*()

Powerpc allows reordering over its ll/sc implementation. Implement the
two new barriers as appropriate.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-gg2ffgq32sjgy9b8lj6m3hsc@git.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/atomic.h  | 6 +-----
 arch/powerpc/include/asm/barrier.h | 3 +++
 arch/powerpc/include/asm/bitops.h  | 6 +-----
 arch/powerpc/kernel/crash.c        | 2 +-
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index e3b1d41..28992d0 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -8,6 +8,7 @@
 #ifdef __KERNEL__
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
@@ -270,11 +271,6 @@ static __inline__ int atomic_dec_if_positive(atomic_t *v)
 }
 #define atomic_dec_if_positive atomic_dec_if_positive
 
-#define smp_mb__before_atomic_dec()     smp_mb()
-#define smp_mb__after_atomic_dec()      smp_mb()
-#define smp_mb__before_atomic_inc()     smp_mb()
-#define smp_mb__after_atomic_inc()      smp_mb()
-
 #ifdef __powerpc64__
 
 #define ATOMIC64_INIT(i)	{ (i) }
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index f89da80..bab79a1 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -84,4 +84,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()     smp_mb()
+#define smp_mb__after_atomic()      smp_mb()
+
 #endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index a5e9a7d..bd3bd57 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -51,11 +51,7 @@
 #define PPC_BIT(bit)		(1UL << PPC_BITLSHIFT(bit))
 #define PPC_BITMASK(bs, be)	((PPC_BIT(bs) - PPC_BIT(be)) | PPC_BIT(bs))
 
-/*
- * clear_bit doesn't imply a memory barrier
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 /* Macro for generating the ***_bits() functions */
 #define DEFINE_BITOP(fn, op, prefix)		\
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 18d7c80..51dbace 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -81,7 +81,7 @@ void crash_ipi_callback(struct pt_regs *regs)
 	}
 
 	atomic_inc(&cpus_in_crash);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/*
 	 * Starting the kdump boot.
