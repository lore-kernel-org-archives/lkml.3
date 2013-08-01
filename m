Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3HAWMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:12:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39819 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab3HAWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:12:38 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 38/51] DMA-API: staging: use dma_set_coherent_mask()
Message-Id: <E1V516S-0006tP-0m@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:12:12 +0100
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
 drivers/staging/dwc2/platform.c        |    5 +++--
 drivers/staging/imx-drm/imx-drm-core.c |    8 ++++++--
 drivers/staging/imx-drm/ipuv3-crtc.c   |    4 +++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dwc2/platform.c b/drivers/staging/dwc2/platform.c
index 44cce2f..7a14f02 100644
--- a/drivers/staging/dwc2/platform.c
+++ b/drivers/staging/dwc2/platform.c
@@ -100,8 +100,9 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	 */
 	if (!dev->dev.dma_mask)
 		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
-	if (!dev->dev.coherent_dma_mask)
-		dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval)
+		return retval;
 
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0) {
diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 9854a1d..81b7234 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -815,6 +815,12 @@ static struct drm_driver imx_drm_driver = {
 
 static int imx_drm_platform_probe(struct platform_device *pdev)
 {
+	int ret;
+
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	imx_drm_device->dev = &pdev->dev;
 
 	return drm_platform_init(&imx_drm_driver, pdev);
@@ -857,8 +863,6 @@ static int __init imx_drm_init(void)
 		goto err_pdev;
 	}
 
-	imx_drm_pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32),
-
 	ret = platform_driver_register(&imx_drm_pdrv);
 	if (ret)
 		goto err_pdrv;
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 9176a81..4e66f67 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -522,7 +522,9 @@ static int ipu_drm_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	ipu_crtc = devm_kzalloc(&pdev->dev, sizeof(*ipu_crtc), GFP_KERNEL);
 	if (!ipu_crtc)
-- 
1.7.4.4

