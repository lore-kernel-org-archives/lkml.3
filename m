Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaFBBpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:45:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57471 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaFBBpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:45:46 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Russell King <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        HyoJun Im <hyojun.im@lge.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH] arm: dma-mapping: fix potential build error under !CMA
Date: Mon,  2 Jun 2014 10:45:28 +0900
Message-Id: <1401673528-19077-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes build error under !CONFIG_CMA. dev_get_cma_area can be used
when CMA is disabled when the bellow patch is appied.

"arm: dma-mapping: add checking cma area initialized"
https://lkml.org/lkml/2014/5/22/35

arch/arm/mm/dma-mapping.c: In function 'atomic_pool_init':
arch/arm/mm/dma-mapping.c:361:2: error: implicit declaration of function
 'dev_get_cma_area' [-Werror=implicit-function-declaration]

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm/include/asm/dma-contiguous.h |    2 +-
 include/asm-generic/dma-contiguous.h  |   13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/dma-contiguous.h b/arch/arm/include/asm/dma-contiguous.h
index 3ed37b4..56c17bc 100644
--- a/arch/arm/include/asm/dma-contiguous.h
+++ b/arch/arm/include/asm/dma-contiguous.h
@@ -2,11 +2,11 @@
 #define ASMARM_DMA_CONTIGUOUS_H
 
 #ifdef __KERNEL__
-#ifdef CONFIG_CMA
 
 #include <linux/types.h>
 #include <asm-generic/dma-contiguous.h>
 
+#ifdef CONFIG_CMA
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
 
 #endif
diff --git a/include/asm-generic/dma-contiguous.h b/include/asm-generic/dma-contiguous.h
index 294b1e7..3d48460 100644
--- a/include/asm-generic/dma-contiguous.h
+++ b/include/asm-generic/dma-contiguous.h
@@ -2,11 +2,11 @@
 #define ASM_DMA_CONTIGUOUS_H
 
 #ifdef __KERNEL__
-#ifdef CONFIG_CMA
 
 #include <linux/device.h>
 #include <linux/dma-contiguous.h>
 
+#ifdef CONFIG_CMA
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	if (dev && dev->cma_area)
@@ -22,7 +22,16 @@ static inline void dev_set_cma_area(struct device *dev, struct cma *cma)
 		dma_contiguous_default_area = cma;
 }
 
-#endif
+#else
+static inline struct cma *dev_get_cma_area(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void dev_set_cma_area(struct device *dev, struct cma *cma)
+{
+}
 #endif
 
 #endif
+#endif
-- 
1.7.9.5

