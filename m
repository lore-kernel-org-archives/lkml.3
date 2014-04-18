Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaDRNFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:05:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDRNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:05:47 -0400
Date: Fri, 18 Apr 2014 06:04:55 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-yijo7sglsl7uusbp13upcuvo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        victor.kamensky@linaro.org, will.deacon@arm.com,
        torvalds@linux-foundation.org, catalin.marinas@arm.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, gang.chen@asianux.com, nico@linaro.org,
        tglx@linutronix.de, albin.tonnerre@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        victor.kamensky@linaro.org, catalin.marinas@arm.com,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        gang.chen@asianux.com, linux@arm.linux.org.uk, nico@linaro.org,
        tglx@linutronix.de, albin.tonnerre@arm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,arm: Convert smp_mb__*()
Git-Commit-ID: 030d0178bdbd237c1f0577f03bbc1d7140a75044
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

Commit-ID:  030d0178bdbd237c1f0577f03bbc1d7140a75044
Gitweb:     http://git.kernel.org/tip/030d0178bdbd237c1f0577f03bbc1d7140a75044
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Mar 2014 17:11:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:32 +0200

arch,arm: Convert smp_mb__*()

ARM uses ll/sc primitives that do not imply barriers for all regular
atomic ops, therefore smp_mb__{before,after} need be a full barrier.

Since ARM doesn't use asm-generic/barrier.h include the required
definitions in its asm/barrier.h

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-yijo7sglsl7uusbp13upcuvo@git.kernel.org
Cc: Albin Tonnerre <albin.tonnerre@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/atomic.h  | 5 -----
 arch/arm/include/asm/barrier.h | 3 +++
 arch/arm/include/asm/bitops.h  | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 9a92fd7..3040359 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -241,11 +241,6 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #ifndef CONFIG_GENERIC_ATOMIC64
 typedef struct {
 	long long counter;
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 2f59f74..c6a3e73 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -79,5 +79,8 @@ do {									\
 
 #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
 
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index b2e298a..5638099 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -25,9 +25,7 @@
 
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
-
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 /*
  * These functions are the basis of our bit ops.
