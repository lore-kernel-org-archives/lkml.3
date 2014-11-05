Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaKEOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:53:40 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:47843 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbaKEOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:53:37 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks
Date: Wed,  5 Nov 2014 15:52:08 +0100
Message-Id: <1415199128-22339-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
implemented with a swap and cmpxchg is implemented with locks.
Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/include/asm/atomic_32.h  |    2 +-
 arch/sparc/include/asm/cmpxchg_32.h |   12 ++----------
 arch/sparc/lib/atomic32.c           |   27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 765c177..0e69b7e 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -22,7 +22,7 @@
 
 int atomic_add_return(int, atomic_t *);
 int atomic_cmpxchg(atomic_t *, int, int);
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+int atomic_xchg(atomic_t *, int);
 int __atomic_add_unless(atomic_t *, int, int);
 void atomic_set(atomic_t *, int);
 
diff --git a/arch/sparc/include/asm/cmpxchg_32.h b/arch/sparc/include/asm/cmpxchg_32.h
index 32c29a1..d38b52d 100644
--- a/arch/sparc/include/asm/cmpxchg_32.h
+++ b/arch/sparc/include/asm/cmpxchg_32.h
@@ -11,22 +11,14 @@
 #ifndef __ARCH_SPARC_CMPXCHG__
 #define __ARCH_SPARC_CMPXCHG__
 
-static inline unsigned long xchg_u32(__volatile__ unsigned long *m, unsigned long val)
-{
-	__asm__ __volatile__("swap [%2], %0"
-			     : "=&r" (val)
-			     : "0" (val), "r" (m)
-			     : "memory");
-	return val;
-}
-
+unsigned long __xchg_u32(volatile u32 *m, u32 new);
 void __xchg_called_with_bad_pointer(void);
 
 static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr, int size)
 {
 	switch (size) {
 	case 4:
-		return xchg_u32(ptr, x);
+		return __xchg_u32(ptr, x);
 	}
 	__xchg_called_with_bad_pointer();
 	return x;
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index a7c418a..71cd65a 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -45,6 +45,19 @@ ATOMIC_OP(add, +=)
 
 #undef ATOMIC_OP
 
+int atomic_xchg(atomic_t *v, int new)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+	ret = v->counter;
+	v->counter = new;
+	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
+	return ret;
+}
+EXPORT_SYMBOL(atomic_xchg);
+
 int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	int ret;
@@ -137,3 +150,17 @@ unsigned long __cmpxchg_u32(volatile u32 *ptr, u32 old, u32 new)
 	return (unsigned long)prev;
 }
 EXPORT_SYMBOL(__cmpxchg_u32);
+
+unsigned long __xchg_u32(volatile u32 *ptr, u32 new)
+{
+	unsigned long flags;
+	u32 prev;
+
+	spin_lock_irqsave(ATOMIC_HASH(ptr), flags);
+	prev = *ptr;
+	*ptr = new;
+	spin_unlock_irqrestore(ATOMIC_HASH(ptr), flags);
+
+	return (unsigned long)prev;
+}
+EXPORT_SYMBOL(__xchg_u32);
-- 
1.7.10.4

