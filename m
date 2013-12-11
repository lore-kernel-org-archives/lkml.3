Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LKXuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:50:52 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59524 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3LKXur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:50:47 -0500
From: Olof Johansson <olof@lixom.net>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH 1/2] net: eth: davinci_cpdma: 64-bit phys/dma_addr_t cleanup
Date: Wed, 11 Dec 2013 15:51:20 -0800
Message-Id: <1386805882-25360-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the below warnings when building with ARM_LPAE enabled, which
gives longer dma_addr_t by default:

drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_desc_pool_create':
drivers/net/ethernet/ti/davinci_cpdma.c:182:3: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]
drivers/net/ethernet/ti/davinci_cpdma.c: In function 'desc_phys':
drivers/net/ethernet/ti/davinci_cpdma.c:222:25: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/net/ethernet/ti/davinci_cpdma.c:223:8: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/net/ethernet/ti/davinci_cpdma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 90a7946..b041a87 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -81,7 +81,7 @@ struct cpdma_desc {
 };
 
 struct cpdma_desc_pool {
-	u32			phys;
+	phys_addr_t		phys;
 	u32			hw_addr;
 	void __iomem		*iomap;		/* ioremap map */
 	void			*cpumap;	/* dma_alloc map */
@@ -219,8 +219,7 @@ static inline dma_addr_t desc_phys(struct cpdma_desc_pool *pool,
 {
 	if (!desc)
 		return 0;
-	return pool->hw_addr + (__force dma_addr_t)desc -
-			    (__force dma_addr_t)pool->iomap;
+	return pool->hw_addr + (__force long)desc - (__force long)pool->iomap;
 }
 
 static inline struct cpdma_desc __iomem *
-- 
1.7.10.4

