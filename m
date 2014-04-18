Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDRNHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:07:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38769 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaDRNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:07:28 -0400
Date: Fri, 18 Apr 2014 06:05:39 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1widdkdsb3c1titq8jez6g3g@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, realmz6@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        realmz6@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,blackfin: Convert smp_mb__*()
Git-Commit-ID: b7bb7d9b28f6278625fbe7892b8c7799bb12a26a
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

Commit-ID:  b7bb7d9b28f6278625fbe7892b8c7799bb12a26a
Gitweb:     http://git.kernel.org/tip/b7bb7d9b28f6278625fbe7892b8c7799bb12a26a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:34 +0200

arch,blackfin: Convert smp_mb__*()

Blackfin's atomic primitives do not imply a full barrier as whitnessed
from its SMP smp_mb__{before,after}_clear_bit() implementations.

However since !SMP smp_mb() reduces to barrier() remove everything and
rely on the asm-generic/barrier.h implentation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-1widdkdsb3c1titq8jez6g3g@git.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/blackfin/include/asm/barrier.h |  3 +++
 arch/blackfin/include/asm/bitops.h  | 14 ++------------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
index 19283a1..4200068 100644
--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -27,6 +27,9 @@
 
 #endif /* !CONFIG_SMP */
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #include <asm-generic/barrier.h>
 
 #endif /* _BLACKFIN_BARRIER_H */
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index 0ca40dd..b298b65 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -27,21 +27,17 @@
 
 #include <asm-generic/bitops/ext2-atomic.h>
 
+#include <asm/barrier.h>
+
 #ifndef CONFIG_SMP
 #include <linux/irqflags.h>
-
 /*
  * clear_bit may not imply a memory barrier
  */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
 #include <asm-generic/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
 #else
 
-#include <asm/barrier.h>
 #include <asm/byteorder.h>	/* swab32 */
 #include <linux/linkage.h>
 
@@ -101,12 +97,6 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
 }
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #define test_bit __skip_test_bit
 #include <asm-generic/bitops/non-atomic.h>
 #undef test_bit
