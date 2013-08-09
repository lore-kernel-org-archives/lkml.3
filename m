Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031198Ab3HIVAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:00:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26155 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031163Ab3HIVAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:00:10 -0400
Message-ID: <201308092100.r79L09Lc011274@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:53:50 -0400
Subject: [PATCH] tile: fix some -Wsign-compare warnings
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally the build doesn't include these warnings, but at one
point I built with -Wsign-compare, and noticed a few things that
are technically bugs.  This change fixes those things.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h          | 6 +++---
 arch/tile/include/asm/mmzone.h      | 2 +-
 arch/tile/include/asm/spinlock_64.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 73b319e..9fe4349 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -255,7 +255,7 @@ static inline void writeq(u64 val, unsigned long addr)
 
 static inline void memset_io(volatile void *dst, int val, size_t len)
 {
-	int x;
+	size_t x;
 	BUG_ON((unsigned long)dst & 0x3);
 	val = (val & 0xff) * 0x01010101;
 	for (x = 0; x < len; x += 4)
@@ -265,7 +265,7 @@ static inline void memset_io(volatile void *dst, int val, size_t len)
 static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
 				 size_t len)
 {
-	int x;
+	size_t x;
 	BUG_ON((unsigned long)src & 0x3);
 	for (x = 0; x < len; x += 4)
 		*(u32 *)(dst + x) = readl(src + x);
@@ -274,7 +274,7 @@ static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
 static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
 				size_t len)
 {
-	int x;
+	size_t x;
 	BUG_ON((unsigned long)dst & 0x3);
 	for (x = 0; x < len; x += 4)
 		writel(*(u32 *)(src + x), dst + x);
diff --git a/arch/tile/include/asm/mmzone.h b/arch/tile/include/asm/mmzone.h
index 9d3dbce..804f109 100644
--- a/arch/tile/include/asm/mmzone.h
+++ b/arch/tile/include/asm/mmzone.h
@@ -42,7 +42,7 @@ static inline int pfn_to_nid(unsigned long pfn)
 
 #define kern_addr_valid(kaddr)	virt_addr_valid((void *)kaddr)
 
-static inline int pfn_valid(int pfn)
+static inline int pfn_valid(unsigned long pfn)
 {
 	int nid = pfn_to_nid(pfn);
 
diff --git a/arch/tile/include/asm/spinlock_64.h b/arch/tile/include/asm/spinlock_64.h
index 5f8b6a0..9a12b9c 100644
--- a/arch/tile/include/asm/spinlock_64.h
+++ b/arch/tile/include/asm/spinlock_64.h
@@ -27,7 +27,7 @@
  * Return the "current" portion of a ticket lock value,
  * i.e. the number that currently owns the lock.
  */
-static inline int arch_spin_current(u32 val)
+static inline u32 arch_spin_current(u32 val)
 {
 	return val >> __ARCH_SPIN_CURRENT_SHIFT;
 }
@@ -36,7 +36,7 @@ static inline int arch_spin_current(u32 val)
  * Return the "next" portion of a ticket lock value,
  * i.e. the number that the next task to try to acquire the lock will get.
  */
-static inline int arch_spin_next(u32 val)
+static inline u32 arch_spin_next(u32 val)
 {
 	return val & __ARCH_SPIN_NEXT_MASK;
 }
-- 
1.8.3.1

