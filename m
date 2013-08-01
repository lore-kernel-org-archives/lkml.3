Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3HAWHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:07:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39804 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3HAWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:07:38 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 33/51] DMA-API: net: nxp/lpc_eth: use
 dma_coerce_mask_and_coherent()
Message-Id: <E1V511b-0006st-Aa@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:07:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code sequence:
	pldat->pdev->dev.coherent_dma_mask = 0xFFFFFFFF;
	pldat->pdev->dev.dma_mask = &pldat->pdev->dev.coherent_dma_mask;
bypasses the architectures check on the DMA mask.  It can be replaced
with dma_coerce_mask_and_coherent(), avoiding the direct initialization
of this mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index a061b93..ba3ca18 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1399,8 +1399,10 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	}
 
 	if (pldat->dma_buff_base_v == 0) {
-		pldat->pdev->dev.coherent_dma_mask = 0xFFFFFFFF;
-		pldat->pdev->dev.dma_mask = &pldat->pdev->dev.coherent_dma_mask;
+		ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (ret)
+			goto err_out_free_irq;
+
 		pldat->dma_buff_size = PAGE_ALIGN(pldat->dma_buff_size);
 
 		/* Allocate a chunk of memory for the DMA ethernet buffers
-- 
1.7.4.4

