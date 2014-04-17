Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaDQNpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48838 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbaDQNo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:57 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 01/18] asm-generic: io: implement relaxed accessor macros as conditional wrappers
Date: Thu, 17 Apr 2014 14:44:04 +0100
Message-Id: <1397742261-15621-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{read,write}{b,w,l,q}_relaxed are implemented by some architectures in
order to permit memory-mapped I/O accesses with weaker barrier semantics
than the non-relaxed variants.

This patch adds wrappers to asm-generic so that drivers can rely on the
relaxed accessors being available, even if they don't always provide
weaker ordering guarantees. Since some architectures both include
asm-generic/io.h and define some relaxed accessors, the definitions here
are conditional for the time being.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/io.h | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc75edb..6a93889aeb0d 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -52,15 +52,24 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 }
 #endif
 
-#define readb __raw_readb
+#define readb		__raw_readb
+#ifndef readb_relaxed
+#define readb_relaxed	readb
+#endif
 
-#define readw readw
+#define readw		readw
+#ifndef readw_relaxed
+#define readw_relaxed	readw
+#endif
 static inline u16 readw(const volatile void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
 
-#define readl readl
+#define readl		readl
+#ifndef readl_relaxed
+#define readl_relaxed	readl
+#endif
 static inline u32 readl(const volatile void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
@@ -87,9 +96,21 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 }
 #endif
 
-#define writeb __raw_writeb
-#define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
-#define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
+#define writeb		__raw_writeb
+#define writew(b,addr)	__raw_writew(__cpu_to_le16(b),addr)
+#define writel(b,addr)	__raw_writel(__cpu_to_le32(b),addr)
+
+#ifndef writeb_relaxed
+#define writeb_relaxed	writeb
+#endif
+
+#ifndef writew_relaxed
+#define writew_relaxed	writew
+#endif
+
+#ifndef writel_relaxed
+#define writel_relaxed	writel
+#endif
 
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
@@ -99,7 +120,10 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 }
 #endif
 
-#define readq readq
+#define readq		readq
+#ifndef readq_relaxed
+#define readq_relaxed	readq
+#endif
 static inline u64 readq(const volatile void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
@@ -113,6 +137,9 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 #endif
 
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
+#ifndef writeq_relaxed
+#define writeq_relaxed	writeq
+#endif
 #endif /* CONFIG_64BIT */
 
 #ifndef PCI_IOBASE
-- 
1.9.1

