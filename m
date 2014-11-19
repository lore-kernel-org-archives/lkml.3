Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbaKSWhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:37:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaKSUxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 025/141] sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks
Date: Wed, 19 Nov 2014 12:50:48 -0800
Message-Id: <20141119205151.475221428@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 1a17fdc4f4ed06b63fac1937470378a5441a663a ]

Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
implemented with a swap and cmpxchg is implemented with locks.
Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/atomic_32.h  |    2 +-
 arch/sparc/include/asm/cmpxchg_32.h |   12 ++----------
 arch/sparc/lib/atomic32.c           |   27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -22,7 +22,7 @@
 
 int __atomic_add_return(int, atomic_t *);
 int atomic_cmpxchg(atomic_t *, int, int);
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+int atomic_xchg(atomic_t *, int);
 int __atomic_add_unless(atomic_t *, int, int);
 void atomic_set(atomic_t *, int);
 
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
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -40,6 +40,19 @@ int __atomic_add_return(int i, atomic_t
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
@@ -132,3 +145,17 @@ unsigned long __cmpxchg_u32(volatile u32
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


