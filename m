Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaEHO4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:56:43 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/2] mtd/onenand: fix build warning for dma type
Date: Thu,  8 May 2014 16:56:14 +0200
Message-Id: <1399560990-1402858-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uGSMCz6JxnT9PBEX1eOpY8fD+Ceaw+p5ixMBIUxyRUR
 vlfYRk02XEA8YVHZZrrUShoy05FJcWvI9pA+OkPxYeYXK/k5/K
 bn6sblkrPQcje/fCS6c1FdjQeWFId+kEwG0NHk8QZ/4zTvE2UL
 KefWqLuN42lf3RY2jQ+diLXTegAAKaMK8kvRQsnb10gNb9ytHC
 X8cajSWNhr22HQRQ2PIznEl0qJhg9Y1lqcY5KY3g03BwYnQqIe
 wLgiMKSXFxyAlnEQyrbGRDPWjZD6o9xFuhggNbvXjcW0uNRRQv
 NWhTeNSd/uYmLAvhZ4Q8T8aYLFOPBTeBpUL62RVVufipteJvOn
 t+cxLeuUBD/7P1Q1wliVBLWOcoAD0ePw5A2STRqhd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The samsung onenand driver passes around a dma address token
through a void pointer, which is incorrect and leads to
warnings like this one:

onenand/samsung.c:548:2: warning: passing argument 1 of '__fswab32' makes integer from pointer without a cast [enabled by default]
  writel(src, base + S5PC110_DMA_SRC_ADDR);
  ^

This patch makes it use dma_addr_t here, which is more appropriate.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/onenand/samsung.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index b1a792f..efb819c 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -537,9 +537,9 @@ static int onenand_write_bufferram(struct mtd_info *mtd, int area,
 	return 0;
 }
 
-static int (*s5pc110_dma_ops)(void *dst, void *src, size_t count, int direction);
+static int (*s5pc110_dma_ops)(dma_addr_t dst, dma_addr_t src, size_t count, int direction);
 
-static int s5pc110_dma_poll(void *dst, void *src, size_t count, int direction)
+static int s5pc110_dma_poll(dma_addr_t dst, dma_addr_t src, size_t count, int direction)
 {
 	void __iomem *base = onenand->dma_addr;
 	int status;
@@ -605,7 +605,7 @@ static irqreturn_t s5pc110_onenand_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int s5pc110_dma_irq(void *dst, void *src, size_t count, int direction)
+static int s5pc110_dma_irq(dma_addr_t dst, dma_addr_t src, size_t count, int direction)
 {
 	void __iomem *base = onenand->dma_addr;
 	int status;
@@ -686,7 +686,7 @@ static int s5pc110_read_bufferram(struct mtd_info *mtd, int area,
 		dev_err(dev, "Couldn't map a %d byte buffer for DMA\n", count);
 		goto normal;
 	}
-	err = s5pc110_dma_ops((void *) dma_dst, (void *) dma_src,
+	err = s5pc110_dma_ops(dma_dst, dma_src,
 			count, S5PC110_DMA_DIR_READ);
 
 	if (page_dma)
-- 
1.8.3.2

