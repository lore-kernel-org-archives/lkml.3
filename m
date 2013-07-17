Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989Ab3GQBPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:15:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3GQBPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:15:49 -0400
Date: Tue, 16 Jul 2013 18:15:30 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        james.t.kukunas@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, james.t.kukunas@intel.com, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, bitops:
  Change bitops to be native operand size
Git-Commit-ID: 9b710506a03b01a9fdd83962912bc9d8237b82e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Jul 2013 18:15:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b710506a03b01a9fdd83962912bc9d8237b82e8
Gitweb:     http://git.kernel.org/tip/9b710506a03b01a9fdd83962912bc9d8237b82e8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 16 Jul 2013 15:20:14 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Jul 2013 15:24:04 -0700

x86, bitops: Change bitops to be native operand size

Change the bitops operation to be naturally "long", i.e. 63 bits on
the 64-bit kernel.  Additional bugs are likely to crop up in the
future.

We already have bugs which machines with > 16 TiB of memory in a
single node, as can happen if memory is interleaved.  The x86 bitop
operations take a signed index, so using an unsigned type is not an
option.

Jim Kukunas measured the effect of this patch on kernel size: it adds
2779 bytes to the allyesconfig kernel.  Some of that probably could be
elided by replacing the inline functions with macros which select the
32-bit type if the index is a 32-bit value, something like:

In that case we could also use "Jr" constraints for the 64-bit
version.

However, this would more than double the amount of code for a
relatively small gain.

Note that we can't use ilog2() for _BITOPS_LONG_SHIFT, as that causes
a recursive header inclusion problem.

The change to constant_test_bit() should both generate better code and
give correct result for negative bit indicies.  As previously written
the compiler had to generate extra code to create the proper wrong
result for negative values.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jim Kukunas <james.t.kukunas@intel.com>
Link: http://lkml.kernel.org/n/tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org
---
 arch/x86/include/asm/bitops.h      | 46 ++++++++++++++++++++++----------------
 arch/x86/include/asm/sync_bitops.h | 24 ++++++++++----------
 2 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 6dfd019..41639ce 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,14 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
+#if BITS_PER_LONG == 32
+# define _BITOPS_LONG_SHIFT 5
+#elif BITS_PER_LONG == 64
+# define _BITOPS_LONG_SHIFT 6
+#else
+# error "Unexpected BITS_PER_LONG"
+#endif
+
 #define BIT_64(n)			(U64_C(1) << (n))
 
 /*
@@ -59,7 +67,7 @@
  * restricted to acting on a single-word quantity.
  */
 static __always_inline void
-set_bit(unsigned int nr, volatile unsigned long *addr)
+set_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -81,7 +89,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -97,7 +105,7 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
-clear_bit(int nr, volatile unsigned long *addr)
+clear_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -118,13 +126,13 @@ clear_bit(int nr, volatile unsigned long *addr)
  * clear_bit() is atomic and implies release semantics before the memory
  * operation. It can be used for an unlock.
  */
-static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -141,7 +149,7 @@ static inline void __clear_bit(int nr, volatile unsigned long *addr)
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void __clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -159,7 +167,7 @@ static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -173,7 +181,7 @@ static inline void __change_bit(int nr, volatile unsigned long *addr)
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
@@ -194,7 +202,7 @@ static inline void change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -212,7 +220,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  * This is the same as test_and_set_bit on x86.
  */
 static __always_inline int
-test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+test_and_set_bit_lock(long nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -226,7 +234,7 @@ test_and_set_bit_lock(int nr, volatile unsigned long *addr)
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -245,7 +253,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -272,7 +280,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
  * accessed from a hypervisor on the same CPU if running in a VM: don't change
  * this without also updating arch/x86/kernel/kvm.c
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -284,7 +292,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -304,7 +312,7 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -315,13 +323,13 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
 {
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(addr[nr / BITS_PER_LONG])) != 0;
+	return ((1UL << (nr & (BITS_PER_LONG-1))) &
+		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
+static inline int variable_test_bit(long nr, volatile const unsigned long *addr)
 {
 	int oldbit;
 
diff --git a/arch/x86/include/asm/sync_bitops.h b/arch/x86/include/asm/sync_bitops.h
index 9d09b40..05af3b3 100644
--- a/arch/x86/include/asm/sync_bitops.h
+++ b/arch/x86/include/asm/sync_bitops.h
@@ -26,9 +26,9 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_set_bit(int nr, volatile unsigned long *addr)
+static inline void sync_set_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btsl %1,%0"
+	asm volatile("lock; bts %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -44,9 +44,9 @@ static inline void sync_set_bit(int nr, volatile unsigned long *addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
+static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btrl %1,%0"
+	asm volatile("lock; btr %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -61,9 +61,9 @@ static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_change_bit(int nr, volatile unsigned long *addr)
+static inline void sync_change_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btcl %1,%0"
+	asm volatile("lock; btc %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -77,11 +77,11 @@ static inline void sync_change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btsl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; bts %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
@@ -95,11 +95,11 @@ static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btrl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; btr %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
@@ -113,11 +113,11 @@ static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btcl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; btc %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
