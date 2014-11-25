Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaKYKvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:51:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaKYKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 233/254] sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks
Date: Tue, 25 Nov 2014 10:39:43 +0000
Message-Id: <1416912004-5928-234-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

commit 1a17fdc4f4ed06b63fac1937470378a5441a663a upstream.

Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
implemented with a swap and cmpxchg is implemented with locks.
Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/include/asm/atomic_32.h  |  2 +-
 arch/sparc/include/asm/cmpxchg_32.h | 12 ++----------
 arch/sparc/lib/atomic32.c           | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7aed2be45b44..2701fb68a24f 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -22,7 +22,7 @@
 
 int __atomic_add_return(int, atomic_t *);
 int atomic_cmpxchg(atomic_t *, int, int);
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+int atomic_xchg(atomic_t *, int);
 int __atomic_add_unless(atomic_t *, int, int);
 void atomic_set(atomic_t *, int);
 
diff --git a/arch/sparc/include/asm/cmpxchg_32.h b/arch/sparc/include/asm/cmpxchg_32.h
index 32c29a133f9d..d38b52dca216 100644
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
index 1d32b54089aa..8f2f94d53434 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -40,6 +40,19 @@ int __atomic_add_return(int i, atomic_t *v)
 }
 EXPORT_SYMBOL(__atomic_add_return);
 
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
@@ -132,3 +145,17 @@ unsigned long __cmpxchg_u32(volatile u32 *ptr, u32 old, u32 new)
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
2.1.0

