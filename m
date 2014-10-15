Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaJOUiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:38:12 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50151 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaJOUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:38:11 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: Patrick Palka <patrick@parcs.ath.cx>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH] Fix the x86 specializations of atomic_[set|clear]_mask
Date: Wed, 15 Oct 2014 16:38:01 -0400
Message-Id: <1413405481-28818-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a number of issues with these specializations:

  1. The memory operand inside the asm specification is erroneously
  declared read-only instead of read-write.

  2. There is no reason to require the 1st operand of andl/orl to be
  inside a register; the 1st operand could also be an immediate operand.
  So change its specification from "r" to "ir".

  3. Since addr is supposed to be an atomic_t *, the memory operand
  should be addr->counter and not *addr.

  4. These specializations should be inline functions instead of macros.

  5. Finally, the "memory" clobbers are unnecessary, so they should be
  removed.  (This is in line with the other atomic functions such as
  atomic_add and atomic_sub, the likes of which do not have a "memory"
  clobber.)

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 arch/x86/include/asm/atomic.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 5e5cd12..83ae239 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -219,15 +219,19 @@ static inline short int atomic_inc_short(short int *v)
 	return *v;
 }
 
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+static inline void atomic_clear_mask(int mask, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "andl %1, %0"
+		     : "+m" (v->counter)
+		     : "ir" (~mask));
+}
 
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
-		     : "memory")
+static inline void atomic_set_mask(int mask, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "orl %1, %0"
+		     : "+m" (v->counter)
+		     : "ir" (mask));
+}
 
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
-- 
2.1.2.443.g670a3c1

