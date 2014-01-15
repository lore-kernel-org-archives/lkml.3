Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaAOHOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:14:36 -0500
Received: from ozlabs.org ([203.10.76.45]:46309 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaAOHOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:14:34 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: Michael Neuling <mikey@neuling.org>, Linus Torvalds <torvalds@osdl.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] powerpc: Add support for the optimised lockref implementation
Date: Wed, 15 Jan 2014 18:14:28 +1100
Message-Id: <1389770069-28733-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the architecture support required to enable the
optimised implementation of lockrefs.

That's as simple as defining arch_spin_value_unlocked() and selecting
the Kconfig option.

We also define cmpxchg64_relaxed(), because the lockref code does not
need the cmpxchg to have barrier semantics.

Using Linus' test case[1] on one system I see a 4x improvement for the
basic enablement, and a further 1.3x for cmpxchg64_relaxed(), for a
total of 5.3x vs the baseline.

On another system I see more like 2x improvement.

[1]: http://marc.info/?l=linux-fsdevel&m=137782380714721&w=4

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/Kconfig                | 1 +
 arch/powerpc/include/asm/cmpxchg.h  | 1 +
 arch/powerpc/include/asm/spinlock.h | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..b34b53d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
+	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff --git a/arch/powerpc/include/asm/cmpxchg.h b/arch/powerpc/include/asm/cmpxchg.h
index e245aab..d463c68 100644
--- a/arch/powerpc/include/asm/cmpxchg.h
+++ b/arch/powerpc/include/asm/cmpxchg.h
@@ -300,6 +300,7 @@ __cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
 	cmpxchg_local((ptr), (o), (n));					\
   })
+#define cmpxchg64_relaxed	cmpxchg64_local
 #else
 #include <asm-generic/cmpxchg-local.h>
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5f54a74..5162f8c 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -54,6 +54,11 @@
 #define SYNC_IO
 #endif
 
+static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
+{
+	return lock.slock == 0;
+}
+
 /*
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
-- 
1.8.3.2

