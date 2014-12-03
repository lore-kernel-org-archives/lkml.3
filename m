Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaLCLvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:51:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaLCL1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 015/101] sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks
Date: Wed,  3 Dec 2014 12:25:37 +0100
Message-Id: <1c854a6cd16b5096200fb47d1418b1d20f7df6bd.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1a17fdc4f4ed06b63fac1937470378a5441a663a ]

Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
implemented with a swap and cmpxchg is implemented with locks.
Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/include/asm/atomic_32.h  |  2 +-
 arch/sparc/include/asm/cmpxchg_32.h | 12 ++----------
 arch/sparc/lib/atomic32.c           | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 905832aa9e9e..a0ed182ae73c 100644
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
index 1fae1a02e3c2..ae0f9a7a314d 100644
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
2.1.3

