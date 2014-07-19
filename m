Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbaGSM77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 08:59:59 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:46176 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbaGSM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 08:59:58 -0400
Date: Sat, 19 Jul 2014 14:59:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: reorder funtions to form logical groups
Message-ID: <20140719125937.GA18566@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718205953.GA21964@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 929c64c1aaf378b767e0ed89826b6bb12449df15 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 19 Jul 2014 14:47:43 +0200
Subject: [PATCH] asm-generic/io.h: reorder funtions to form logical groups

Reoder the functions so the various functions are grouped
according to how they access memoy.
For example __raw_{read,write}* are now all grouped.

The benefit of this grouping is that one can easier find all
IO accessors of one type.
To do so a few more #ifdef CONFIG_64BIT had to be used.

Add a small boiler plate comment for some of the groups to
better let them stand out.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Hi Thierry.

This is my attempt to bring some order into io.h
with respect to the order the functions are defined in.

In a follow-up mail I also said we should delete the _p variants
of some methods but I then learned they are for slow IO access.
So these I have left as is.

And introducing static inline for all functions that are pure macro
substitution is also left out for now.

Please consider if you will take this as a follow-on patch.

	Sam

 include/asm-generic/io.h | 126 +++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 53 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index b2ea16b..5c84db4 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -24,10 +24,10 @@
 #define mmiowb() do {} while (0)
 #endif
 
-/*****************************************************************************/
 /*
- * readX/writeX() are used to access memory mapped devices. On some
- * architectures the memory mapped IO stuff needs to be accessed
+ * raw_{read,write}{b,w,l,q} access memory in native endian.
+ *
+ * On some architectures the memory mapped IO stuff needs to be accessed
  * differently. On the simple architectures, we just read/write the
  * memory location directly.
  */
@@ -55,25 +55,16 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 }
 #endif
 
-#ifndef readb
-#define readb __raw_readb
-#endif
-
-#ifndef readw
-#define readw readw
-static inline u16 readw(const volatile void __iomem *addr)
+#ifdef CONFIG_64BIT
+#ifndef __raw_readq
+#define __raw_readq __raw_readq
+static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
-	return __le16_to_cpu(__raw_readw(addr));
+	return *(const volatile u64 __force *) addr;
 }
 #endif
+#endif /* CONFIG_64BIT */
 
-#ifndef readl
-#define readl readl
-static inline u32 readl(const volatile void __iomem *addr)
-{
-	return __le32_to_cpu(__raw_readl(addr));
-}
-#endif
 
 #ifndef __raw_writeb
 #define __raw_writeb __raw_writeb
@@ -99,27 +90,42 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 }
 #endif
 
-#ifndef writeb
-#define writeb __raw_writeb
+#ifdef CONFIG_64BIT
+#ifndef __raw_writeq
+#define __raw_writeq __raw_writeq
+static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
+{
+	*(volatile u64 __force *) addr = b;
+}
 #endif
+#endif /* CONFIG_64BIT */
 
-#ifndef writew
-#define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
+
+/*
+ * {read,write}{b,w,l,q} access little endian memory
+ * and return result in native endian
+ */
+#ifndef readb
+#define readb __raw_readb
 #endif
 
-#ifndef writel
-#define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
+#ifndef readw
+#define readw readw
+static inline u16 readw(const volatile void __iomem *addr)
+{
+	return __le16_to_cpu(__raw_readw(addr));
+}
 #endif
 
-#ifdef CONFIG_64BIT
-#ifndef __raw_readq
-#define __raw_readq __raw_readq
-static inline u64 __raw_readq(const volatile void __iomem *addr)
+#ifndef readl
+#define readl readl
+static inline u32 readl(const volatile void __iomem *addr)
 {
-	return *(const volatile u64 __force *) addr;
+	return __le32_to_cpu(__raw_readl(addr));
 }
 #endif
 
+#ifdef CONFIG_64BIT
 #ifndef readq
 #define readq readq
 static inline u64 readq(const volatile void __iomem *addr)
@@ -127,20 +133,31 @@ static inline u64 readq(const volatile void __iomem *addr)
 	return __le64_to_cpu(__raw_readq(addr));
 }
 #endif
+#endif /* CONFIG_64BIT */
 
-#ifndef __raw_writeq
-#define __raw_writeq __raw_writeq
-static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
-{
-	*(volatile u64 __force *) addr = b;
-}
+
+#ifndef writeb
+#define writeb __raw_writeb
+#endif
+
+#ifndef writew
+#define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
+#endif
+
+#ifndef writel
+#define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
 #endif
 
+#ifdef CONFIG_64BIT
 #ifndef writeq
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+
+/*
+ * {read,write}s{b,w,l.q}b access native memory in chunks specified by count
+ */
 #ifndef readsb
 #define readsb readsb
 static inline void readsb(const void __iomem *addr, void *buffer, int count)
@@ -183,6 +200,23 @@ static inline void readsl(const void __iomem *addr, void *buffer, int count)
 }
 #endif
 
+#ifdef CONFIG_64BIT
+#ifndef readsq
+#define readsq readsq
+static inline void readsq(const void __iomem *addr, void *buffer, int count)
+{
+	if (count) {
+		u64 *buf = buffer;
+		do {
+			u64 x = __raw_readq(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+#endif /* CONFIG_64BIT */
+
+
 #ifndef writesb
 #define writesb writesb
 static inline void writesb(void __iomem *addr, const void *buffer, int count)
@@ -223,20 +257,6 @@ static inline void writesl(void __iomem *addr, const void *buffer, int count)
 #endif
 
 #ifdef CONFIG_64BIT
-#ifndef readsq
-#define readsq readsq
-static inline void readsq(const void __iomem *addr, void *buffer, int count)
-{
-	if (count) {
-		u64 *buf = buffer;
-		do {
-			u64 x = __raw_readq(addr);
-			*buf++ = x;
-		} while (--count);
-	}
-}
-#endif
-
 #ifndef writesq
 #define writesq writesq
 static inline void writesq(void __iomem *addr, const void *buffer, int count)
@@ -356,6 +376,10 @@ static inline void outl(u32 b, unsigned long addr)
 #define ioread16(addr)		readw(addr)
 #define ioread32(addr)		readl(addr)
 
+#define iowrite8(v, addr)	writeb((v), (addr))
+#define iowrite16(v, addr)	writew((v), (addr))
+#define iowrite32(v, addr)	writel((v), (addr))
+
 #ifndef ioread16be
 #define ioread16be(addr)	__be16_to_cpu(__raw_readw(addr))
 #endif
@@ -364,10 +388,6 @@ static inline void outl(u32 b, unsigned long addr)
 #define ioread32be(addr)	__be32_to_cpu(__raw_readl(addr))
 #endif
 
-#define iowrite8(v, addr)	writeb((v), (addr))
-#define iowrite16(v, addr)	writew((v), (addr))
-#define iowrite32(v, addr)	writel((v), (addr))
-
 #ifndef iowrite16be
 #define iowrite16be(v, addr)	__raw_writew(__cpu_to_be16(v), addr)
 #endif
-- 
1.9.3

