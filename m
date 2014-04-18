Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaDRNKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:10:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:10:34 -0400
Date: Fri, 18 Apr 2014 06:09:40 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-hyp7yj68cmqz1nqbfpr541ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tony.luck@intel.com, akinobu.mita@gmail.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, akinobu.mita@gmail.com, tony.luck@intel.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,ia64: Convert smp_mb__*()
Git-Commit-ID: 0cd64efb61f1e68be26bd5121ccff3c779dc488b
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

Commit-ID:  0cd64efb61f1e68be26bd5121ccff3c779dc488b
Gitweb:     http://git.kernel.org/tip/0cd64efb61f1e68be26bd5121ccff3c779dc488b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:35 +0200

arch,ia64: Convert smp_mb__*()

ia64 atomic ops are full barriers; implement the new
smp_mb__{before,after}_atomic().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-hyp7yj68cmqz1nqbfpr541ca@git.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/atomic.h  | 7 +------
 arch/ia64/include/asm/barrier.h | 3 +++
 arch/ia64/include/asm/bitops.h  | 6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 6e6fe18..0f8bf48 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
 
 
 #define ATOMIC_INIT(i)		{ (i) }
@@ -208,10 +209,4 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define atomic64_inc(v)			atomic64_add(1, (v))
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* _ASM_IA64_ATOMIC_H */
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index d0a69aa..a48957c 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -55,6 +55,9 @@
 
 #endif
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 /*
  * IA64 GCC turns volatile stores into st.rel and volatile loads into ld.acq no
  * need for asm trickery!
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index feb8117..71e8145 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -65,9 +66,6 @@ __set_bit (int nr, volatile void *addr)
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
 
-#define smp_mb__before_clear_bit()	barrier();
-#define smp_mb__after_clear_bit()	barrier();
-
 /**
  * clear_bit - Clears a bit in memory
  * @nr: Bit to clear
@@ -75,7 +73,7 @@ __set_bit (int nr, volatile void *addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __inline__ void
