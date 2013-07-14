Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3GNNAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 09:00:15 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48580 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3GNNAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 09:00:13 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: [PATCH] x86/asm: avoid mnemonics without type suffix
Date: Sun, 14 Jul 2013 18:26:02 +0530
Message-Id: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1c54d77 (x86: partial unification of asm-x86/bitops.h, 2008-01-30)
changed a bunch of btrl/btsl instructions to btr/bts, with the following
justification:

  The inline assembly for the bit operations has been changed to remove
  explicit sizing hints on the instructions, so the assembler will pick
  the appropriate instruction forms depending on the architecture and
  the context.

Unfortunately, GNU as does no such thing, and the AT&T syntax manual
[1] contains no references to any such inference.  As evidenced by the
following experiment, gas always disambiguates btr/bts to btrl/btsl.
Feed the following input to gas:

  btrl	$1, 0
  btr	$1, 0
  btsl	$1, 0
  bts	$1, 0

Check that btr matches btrl, and bts matches btsl in both cases:

  $ as --32 -a in.s
  $ as --64 -a in.s

To avoid giving readers the illusion of such an inference, and for
clarity, change btr/bts back to btrl/btsl.  Also, llvm-mc refuses to
disambiguate btr/bts automatically.

[1]: http://docs.oracle.com/cd/E19253-01/817-5477/817-5477.pdf

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eli Friedman <eli.friedman@gmail.com>
Cc: Jim Grosbach <grosbach@apple.com>
Cc: Stephen Checkoway <s@pahtak.org>
Cc: LLVMdev <llvmdev@cs.uiuc.edu>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 We discussed this pretty extensively on LLVMDev, but I'm still not
 sure that I haven't missed something.

 arch/x86/include/asm/bitops.h | 16 ++++++++--------
 arch/x86/include/asm/percpu.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 6dfd019..6ed3d1e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -67,7 +67,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
 			: "iq" ((u8)CONST_MASK(nr))
 			: "memory");
 	} else {
-		asm volatile(LOCK_PREFIX "bts %1,%0"
+		asm volatile(LOCK_PREFIX "btsl %1,%0"
 			: BITOP_ADDR(addr) : "Ir" (nr) : "memory");
 	}
 }
@@ -83,7 +83,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
  */
 static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
-	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
+	asm volatile("btsl %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
 /**
@@ -104,7 +104,7 @@ clear_bit(int nr, volatile unsigned long *addr)
 			: CONST_MASK_ADDR(nr, addr)
 			: "iq" ((u8)~CONST_MASK(nr)));
 	} else {
-		asm volatile(LOCK_PREFIX "btr %1,%0"
+		asm volatile(LOCK_PREFIX "btrl %1,%0"
 			: BITOP_ADDR(addr)
 			: "Ir" (nr));
 	}
@@ -126,7 +126,7 @@ static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
 
 static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
-	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
+	asm volatile("btrl %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
@@ -198,7 +198,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
+	asm volatile(LOCK_PREFIX "btsl %2,%1\n\t"
 		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
 	return oldbit;
@@ -230,7 +230,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm("bts %2,%1\n\t"
+	asm("btsl %2,%1\n\t"
 	    "sbb %0,%0"
 	    : "=r" (oldbit), ADDR
 	    : "Ir" (nr));
@@ -249,7 +249,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
+	asm volatile(LOCK_PREFIX "btrl %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
@@ -276,7 +276,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("btr %2,%1\n\t"
+	asm volatile("btrl %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit), ADDR
 		     : "Ir" (nr));
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0da5200..fda54c9 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -490,7 +490,7 @@ do {									\
 #define x86_test_and_clear_bit_percpu(bit, var)				\
 ({									\
 	int old__;							\
-	asm volatile("btr %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
+	asm volatile("btrl %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
 		     : "=r" (old__), "+m" (var)				\
 		     : "dIr" (bit));					\
 	old__;								\
-- 
1.8.3.2.736.g869de25

