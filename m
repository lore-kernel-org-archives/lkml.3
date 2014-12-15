Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLOT2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:28:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaLOT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 27/96] sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks
Date: Mon, 15 Dec 2014 11:25:47 -0800
Message-Id: <1418671616-25482-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 1a17fdc4f4ed06b63fac1937470378a5441a663a ]

Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
implemented with a swap and cmpxchg is implemented with locks.
Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/atomic_32.h  |  2 +-
 arch/sparc/include/asm/cmpxchg_32.h | 12 ++----------
 arch/sparc/lib/atomic32.c           | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 905832a..a0ed182 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -21,7 +21,7 @@
 
 extern int __atomic_add_return(int, atomic_t *);
 extern int atomic_cmpxchg(atomic_t *, int, int);
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+extern int atomic_xchg(atomic_t *, int);
 extern int __atomic_add_unless(atomic_t *, int, int);
 extern void atomic_set(atomic_t *, int);
 
diff --git a/arch/sparc/include/asm/cmpxchg_32.h b/arch/sparc/include/asm/cmpxchg_32.h
index 1fae1a0..ae0f9a7 100644
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
+extern unsigned long __xchg_u32(volatile u32 *m, u32 new);
 extern void __xchg_called_with_bad_pointer(void);
 
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
index 1d32b54..8f2f94d 100644
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
1.9.1

