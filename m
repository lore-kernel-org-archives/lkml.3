Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDRNGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:06:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaDRNGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:06:50 -0400
Date: Fri, 18 Apr 2014 06:05:10 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8p5iclqgy78al33kck3ht7nr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        catalin.marinas@arm.com, rmk+kernel@arm.linux.org.uk,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, torvalds@linux-foundation.org,
        will.deacon@arm.com, peterz@infradead.org, rmk+kernel@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, gang.chen@asianux.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,arm64: Convert smp_mb__*()
Git-Commit-ID: 8715466b602729061394df18864ea64b97951589
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

Commit-ID:  8715466b602729061394df18864ea64b97951589
Gitweb:     http://git.kernel.org/tip/8715466b602729061394df18864ea64b97951589
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:33 +0200

arch,arm64: Convert smp_mb__*()

AARGH64 uses ll/sc primitives that do not imply any barriers for the
normal atomics, therefore smp_mb__{before,after} should be a full
barrier.

Since AARGH64 doesn't use asm-generic/barrier.h, add the required
definitions to its asm/barrier.h.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-8p5iclqgy78al33kck3ht7nr@git.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm64/include/asm/atomic.h  | 5 -----
 arch/arm64/include/asm/barrier.h | 3 +++
 arch/arm64/include/asm/bitops.h  | 9 ---------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 0237f08..57e8cb4 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -152,11 +152,6 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 /*
  * 64-bit atomic operations.
  */
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 66eb764..48b9e70 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -98,6 +98,9 @@ do {									\
 #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
 #define nop()		asm volatile("nop");
 
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_BARRIER_H */
diff --git a/arch/arm64/include/asm/bitops.h b/arch/arm64/include/asm/bitops.h
index aa5b59d..9c19594 100644
--- a/arch/arm64/include/asm/bitops.h
+++ b/arch/arm64/include/asm/bitops.h
@@ -17,17 +17,8 @@
 #define __ASM_BITOPS_H
 
 #include <linux/compiler.h>
-
 #include <asm/barrier.h>
 
-/*
- * clear_bit may not imply a memory barrier
- */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
-
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
