Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbaCSG4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:56:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52918 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaCSG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:26 -0400
Message-Id: <20140319065203.838756777@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/31] ia64: Fix up smp_mb__{before,after}_clear_bit
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-ia64-atomics.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 doesn't actually have acquire/release barriers, its a lie!

Add a comment explaining this and fix up the bitop barriers.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/include/asm/bitops.h       |    7 ++-----
 arch/ia64/include/uapi/asm/cmpxchg.h |    9 +++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -65,11 +65,8 @@ __set_bit (int nr, volatile void *addr)
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
 
-/*
- * clear_bit() has "acquire" semantics.
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do { /* skip */; } while (0)
+#define smp_mb__before_clear_bit()	barrier();
+#define smp_mb__after_clear_bit()	barrier();
 
 /**
  * clear_bit - Clears a bit in memory
--- a/arch/ia64/include/uapi/asm/cmpxchg.h
+++ b/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -118,6 +118,15 @@ extern long ia64_cmpxchg_called_with_bad
 #define cmpxchg_rel(ptr, o, n)	\
 	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
+/*
+ * Worse still - early processor implementations actually just ignored
+ * the acquire/release and did a full fence all the time.  Unfortunately
+ * this meant a lot of badly written code that used .acq when they really
+ * wanted .rel became legacy out in the wild - so when we made a cpu
+ * that strictly did the .acq or .rel ... all that code started breaking - so
+ * we had to back-pedal and keep the "legacy" behavior of a full fence :-(
+ */
+
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
 #define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))


