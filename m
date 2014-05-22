Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaEVQ4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:56:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbaEVQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:16 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 01/18] asm-generic: io: implement relaxed accessor macros as conditional wrappers
Date: Thu, 22 May 2014 17:47:13 +0100
Message-Id: <1400777250-17335-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
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
 include/asm-generic/io.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc75edb..9ccedeb06522 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -53,18 +53,27 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 #endif
 
 #define readb __raw_readb
+#ifndef readb_relaxed
+#define readb_relaxed readb
+#endif
 
 #define readw readw
 static inline u16 readw(const volatile void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
+#ifndef readw_relaxed
+#define readw_relaxed readw
+#endif
 
 #define readl readl
 static inline u32 readl(const volatile void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
 }
+#ifndef readl_relaxed
+#define readl_relaxed readl
+#endif
 
 #ifndef __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
@@ -88,8 +97,19 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #endif
 
 #define writeb __raw_writeb
+#ifndef writeb_relaxed
+#define writeb_relaxed writeb
+#endif
+
 #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
+#ifndef writew_relaxed
+#define writew_relaxed writew
+#endif
+
 #define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
+#ifndef writel_relaxed
+#define writel_relaxed writel
+#endif
 
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
@@ -104,6 +124,9 @@ static inline u64 readq(const volatile void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
 }
+#ifndef readq_relaxed
+#define readq_relaxed readq
+#endif
 
 #ifndef __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
@@ -113,6 +136,9 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 #endif
 
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
+#ifndef writeq_relaxed
+#define writeq_relaxed writeq
+#endif
 #endif /* CONFIG_64BIT */
 
 #ifndef PCI_IOBASE
-- 
1.9.2

