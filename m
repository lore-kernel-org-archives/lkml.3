Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDRNNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:13:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaDRNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:13:32 -0400
Date: Fri, 18 Apr 2014 06:12:50 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e9rqjxr1m1ejsob9p433kmji@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        jcmvbkbc@gmail.com, chris@zankel.net, paulmck@linux.vnet.ibm.com,
        geert@linux-m68k.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
        peterz@infradead.org, chris@zankel.net, jcmvbkbc@gmail.com,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,xtensa: Convert smp_mb__*()
Git-Commit-ID: 09a01c0ccb1837abb28afcfdd668fa0dfabed928
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

Commit-ID:  09a01c0ccb1837abb28afcfdd668fa0dfabed928
Gitweb:     http://git.kernel.org/tip/09a01c0ccb1837abb28afcfdd668fa0dfabed928
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:47 +0200

arch,xtensa: Convert smp_mb__*()

Xtensa SMP has compare-and-swap which is fully serializing, therefore
its exising smp_mb__{before,after}_clear_bit() appear unduly heavy.

Implement the new barriers as barrier().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-e9rqjxr1m1ejsob9p433kmji@git.kernel.org
Cc: Chris Zankel <chris@zankel.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-xtensa@linux-xtensa.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/xtensa/include/asm/atomic.h  | 7 +------
 arch/xtensa/include/asm/barrier.h | 3 +++
 arch/xtensa/include/asm/bitops.h  | 4 +---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index e7fb447..e5103b4 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -19,6 +19,7 @@
 #ifdef __KERNEL__
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
@@ -387,12 +388,6 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 #endif
 }
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
index 0a24b04..5b88774 100644
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -13,6 +13,9 @@
 #define rmb() barrier()
 #define wmb() mb()
 
+#define smp_mb__before_atomic()		barrier()
+#define smp_mb__after_atomic()		barrier()
+
 #include <asm-generic/barrier.h>
 
 #endif /* _XTENSA_SYSTEM_H */
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 7b6873a..3f44fa2 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -21,9 +21,7 @@
 
 #include <asm/processor.h>
 #include <asm/byteorder.h>
-
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops/non-atomic.h>
 
