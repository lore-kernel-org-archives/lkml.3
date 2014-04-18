Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaDRNNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:13:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaDRNN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:13:27 -0400
Date: Fri, 18 Apr 2014 06:12:37 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-knswsr5mldkr0w1lrdxvc81w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, walken@google.com, jesse.brandeburg@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, jesse.brandeburg@intel.com, walken@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,x86: Convert smp_mb__*()
Git-Commit-ID: d00a569284b1340c16fe2c148099e077ea09ebc9
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

Commit-ID:  d00a569284b1340c16fe2c148099e077ea09ebc9
Gitweb:     http://git.kernel.org/tip/d00a569284b1340c16fe2c148099e077ea09ebc9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:46 +0200

arch,x86: Convert smp_mb__*()

x86 is strongly ordered and all its atomic ops imply a full barrier.

Implement the two new primitives as the old ones were.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-knswsr5mldkr0w1lrdxvc81w@git.kernel.org
Cc: Dave Jones <davej@redhat.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/atomic.h      | 7 +------
 arch/x86/include/asm/barrier.h     | 4 ++++
 arch/x86/include/asm/bitops.h      | 6 ++----
 arch/x86/include/asm/sync_bitops.h | 2 +-
 arch/x86/kernel/apic/hw_nmi.c      | 2 +-
 5 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index b17f4f4..6dd1c7d 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -7,6 +7,7 @@
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 #include <asm/rmwcc.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -243,12 +244,6 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
 		     : "memory")
 
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
 #else
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 69bbb48..5c7198c 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -137,6 +137,10 @@ do {									\
 
 #endif
 
+/* Atomic operations are already serializing on x86 */
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 9fc1af7..afcd35d 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 #include <asm/rmwcc.h>
+#include <asm/barrier.h>
 
 #if BITS_PER_LONG == 32
 # define _BITOPS_LONG_SHIFT 5
@@ -102,7 +103,7 @@ static inline void __set_bit(long nr, volatile unsigned long *addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
@@ -156,9 +157,6 @@ static inline void __clear_bit_unlock(long nr, volatile unsigned long *addr)
 	__clear_bit(nr, addr);
 }
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 /**
  * __change_bit - Toggle a bit in memory
  * @nr: the bit to change
diff --git a/arch/x86/include/asm/sync_bitops.h b/arch/x86/include/asm/sync_bitops.h
index 05af3b3..f28a24b 100644
--- a/arch/x86/include/asm/sync_bitops.h
+++ b/arch/x86/include/asm/sync_bitops.h
@@ -41,7 +41,7 @@ static inline void sync_set_bit(long nr, volatile unsigned long *addr)
  *
  * sync_clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..eab6704 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -57,7 +57,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	}
 
 	clear_bit(0, &backtrace_flag);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static int __kprobes
