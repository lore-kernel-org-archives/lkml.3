Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab3HAWNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:13:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39822 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3HAWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:13:39 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 39/51] DMA-API: others: use dma_set_coherent_mask()
Message-Id: <E1V517Q-0006tV-4z@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:13:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct way for a driver to specify the coherent DMA mask is
not to directly access the field in the struct device, but to use
dma_set_coherent_mask().  Only arch and bus code should access this
member directly.

Convert all direct write accesses to using the correct API.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/ata/pata_ixp4xx_cf.c             |    5 ++++-
 drivers/gpu/drm/exynos/exynos_drm_drv.c  |    7 ++++++-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c |    5 +++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index dcc6b24..ad5ecf2 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -144,6 +144,7 @@ static int ixp4xx_pata_probe(struct platform_device *pdev)
 	struct ata_host *host;
 	struct ata_port *ap;
 	struct ixp4xx_pata_data *data = pdev->dev.platform_data;
+	int ret;
 
 	cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -157,7 +158,9 @@ static int ixp4xx_pata_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* acquire resources and fill host */
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index ca2729a..e9fb6c8 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -287,7 +287,12 @@ static struct drm_driver exynos_drm_driver = {
 
 static int exynos_drm_platform_probe(struct platform_device *pdev)
 {
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	int ret;
+
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	exynos_drm_driver.num_ioctls = DRM_ARRAY_SIZE(exynos_ioctls);
 
 	return drm_platform_init(&exynos_drm_driver, pdev);
diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index 9b794c9..ce837ae 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -664,8 +664,9 @@ static int omap_dmm_probe(struct platform_device *dev)
 	}
 
 	/* set dma mask for device */
-	/* NOTE: this is a workaround for the hwmod not initializing properly */
-	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto fail;
 
 	omap_dmm->dummy_pa = page_to_phys(omap_dmm->dummy_page);
 
-- 
1.7.4.4

