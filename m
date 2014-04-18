Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaDRNSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:18:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaDRNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:48 -0400
Date: Fri, 18 Apr 2014 06:09:01 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wvewbe8os3s1e4pt1cdotuee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        akpm@linux-foundation.org, starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        akpm@linux-foundation.org, starvik@axis.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,cris: Convert smp_mb__*()
Git-Commit-ID: 17b40213ab2b091fd5d2a9337eae62312608ad3d
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

Commit-ID:  17b40213ab2b091fd5d2a9337eae62312608ad3d
Gitweb:     http://git.kernel.org/tip/17b40213ab2b091fd5d2a9337eae62312608ad3d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:00 +0200

arch,cris: Convert smp_mb__*()

Cris fully relies on asm-generic/barrier.h, therefore its smp_mb() is
barrier(), thus we can use the default implementation that uses
smp_mb().

(Include asm/system.h and asm/barrier.h to avoid header dependency hell.)

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-wvewbe8os3s1e4pt1cdotuee@git.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/cris/include/asm/atomic.h | 8 ++------
 arch/cris/include/asm/bitops.h | 9 ++-------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 1056a5d..aa429ba 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -7,6 +7,8 @@
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
 #include <arch/atomic.h>
+#include <arch/system.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -151,10 +153,4 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return ret;
 }
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec()     barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc()     barrier()
-
 #endif
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 053c17b..bd49a54 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -21,6 +21,7 @@
 #include <arch/bitops.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * set_bit - Atomically set a bit in memory
@@ -42,7 +43,7 @@
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 
@@ -84,12 +85,6 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 	return retval;
 }
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()      barrier()
-#define smp_mb__after_clear_bit()       barrier()
-
 /**
  * test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
