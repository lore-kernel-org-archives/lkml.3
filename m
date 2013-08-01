Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3HAWFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:05:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3HAWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:05:39 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 31/51] DMA-API: media: omap3isp: use
 dma_coerce_mask_and_coherent()
Message-Id: <E1V50zf-0006si-20@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:05:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code sequence:
	isp->raw_dmamask = DMA_BIT_MASK(32);
	isp->dev->dma_mask = &isp->raw_dmamask;
	isp->dev->coherent_dma_mask = DMA_BIT_MASK(32);
bypasses the architectures check on the DMA mask.  It can be replaced
with dma_coerce_mask_and_coherent(), avoiding the direct initialization
of this mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/platform/omap3isp/isp.c |    6 +++---
 drivers/media/platform/omap3isp/isp.h |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index df3a0ec..1c36080 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2182,9 +2182,9 @@ static int isp_probe(struct platform_device *pdev)
 	isp->pdata = pdata;
 	isp->ref_count = 0;
 
-	isp->raw_dmamask = DMA_BIT_MASK(32);
-	isp->dev->dma_mask = &isp->raw_dmamask;
-	isp->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_coerce_mask_and_coherent(isp->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	platform_set_drvdata(pdev, isp);
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index cd3eff4..ce65d3a 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -152,7 +152,6 @@ struct isp_xclk {
  * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
  *                  regions.
  * @mmio_size: Array with ISP register regions size in bytes.
- * @raw_dmamask: Raw DMA mask
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
  * @crashed: Bitmask of crashed entities (indexed by entity ID)
@@ -190,8 +189,6 @@ struct isp_device {
 	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
 	resource_size_t mmio_size[OMAP3_ISP_IOMEM_LAST];
 
-	u64 raw_dmamask;
-
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
-- 
1.7.4.4

