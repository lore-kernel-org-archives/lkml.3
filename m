Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab3BAUnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:43:41 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21481 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab3BAUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:36 -0500
Message-ID: <201302012043.r11KhZFs024379@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 15:21:41 -0500
Subject: [PATCH] tile: fix memcpy_*io functions for allnoconfig
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tilepro without CONFIG_PCI, we can't provide inlines of these
functions, as we don't have readl/writel.

In addition, fix memset_io() signature to take a volatile void *.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 865e529..aaa423d 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -250,7 +250,9 @@ static inline void writeq(u64 val, unsigned long addr)
 #define iowrite32 writel
 #define iowrite64 writeq
 
-static inline void memset_io(void *dst, int val, size_t len)
+#if CHIP_HAS_MMIO() || defined(CONFIG_PCI)
+
+static inline void memset_io(volatile void *dst, int val, size_t len)
 {
 	int x;
 	BUG_ON((unsigned long)dst & 0x3);
@@ -277,6 +279,8 @@ static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
 		writel(*(u32 *)(src + x), dst + x);
 }
 
+#endif
+
 /*
  * The Tile architecture does not support IOPORT, even with PCI.
  * Unfortunately we can't yet simply not declare these methods,
-- 
1.7.10.3

