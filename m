Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3HAWKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:10:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39813 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab3HAWKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:10:40 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 36/51] DMA-API: usb: use dma_set_coherent_mask()
Message-Id: <E1V514V-0006tD-Nw@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:10:11 +0100
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
 drivers/usb/chipidea/ci_hdrc_imx.c |    5 +++--
 drivers/usb/dwc3/dwc3-exynos.c     |    5 +++--
 drivers/usb/gadget/lpc32xx_udc.c   |    4 +++-
 drivers/usb/host/ehci-atmel.c      |    5 +++--
 drivers/usb/host/ehci-octeon.c     |    4 +++-
 drivers/usb/host/ehci-omap.c       |    8 +++++---
 drivers/usb/host/ehci-orion.c      |    5 +++--
 drivers/usb/host/ehci-platform.c   |    7 ++++---
 drivers/usb/host/ehci-s5p.c        |    5 +++--
 drivers/usb/host/ehci-spear.c      |    5 +++--
 drivers/usb/host/ehci-tegra.c      |    5 +++--
 drivers/usb/host/ohci-at91.c       |    7 ++++---
 drivers/usb/host/ohci-exynos.c     |    5 +++--
 drivers/usb/host/ohci-nxp.c        |    4 +++-
 drivers/usb/host/ohci-octeon.c     |    4 +++-
 drivers/usb/host/ohci-omap3.c      |    8 +++++---
 drivers/usb/host/ohci-pxa27x.c     |    6 ++++--
 drivers/usb/host/ohci-spear.c      |    5 +++--
 drivers/usb/host/uhci-platform.c   |    5 +++--
 19 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 14362c0..1c47edd 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -159,8 +159,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto err;
 
 	if (usbmisc_ops && usbmisc_ops->init) {
 		ret = usbmisc_ops->init(&pdev->dev);
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 8ce9d7f..7553ae4 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -117,8 +117,9 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	 */
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto err1;
 
 	platform_set_drvdata(pdev, exynos);
 
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index 67128be..6a2a65a 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -3078,7 +3078,9 @@ static int __init lpc32xx_udc_probe(struct platform_device *pdev)
 		 udc->isp1301_i2c_client->addr);
 
 	pdev->dev.dma_mask = &lpc32xx_usbd_dmamask;
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval)
+		goto resource_fail;
 
 	udc->board = &lpc32xx_usbddata;
 
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 3b645ff..5831a88 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -92,8 +92,9 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval)
+		goto fail_create_hcd;
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
diff --git a/drivers/usb/host/ehci-octeon.c b/drivers/usb/host/ehci-octeon.c
index 45cc001..323a02b 100644
--- a/drivers/usb/host/ehci-octeon.c
+++ b/drivers/usb/host/ehci-octeon.c
@@ -116,8 +116,10 @@ static int ehci_octeon_drv_probe(struct platform_device *pdev)
 	 * We can DMA from anywhere. But the descriptors must be in
 	 * the lower 4GB.
 	 */
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	pdev->dev.dma_mask = &ehci_octeon_dma_mask;
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	hcd = usb_create_hcd(&ehci_octeon_hc_driver, &pdev->dev, "octeon");
 	if (!hcd)
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 9bd7dfe..922e193 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -104,7 +104,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	struct resource	*res;
 	struct usb_hcd	*hcd;
 	void __iomem *regs;
-	int ret = -ENODEV;
+	int ret;
 	int irq;
 	int i;
 	struct omap_hcd	*omap;
@@ -146,9 +146,11 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	 */
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
+	ret = -ENODEV;
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, dev,
 			dev_name(dev));
 	if (!hcd) {
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 1a450aa..d7fbad0 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -182,8 +182,9 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (err)
+		goto err1;
 
 	if (!request_mem_region(res->start, resource_size(res),
 				ehci_orion_hc_driver.description)) {
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 5196d72..2c6004e 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -78,7 +78,7 @@ static int ehci_platform_probe(struct platform_device *dev)
 	struct resource *res_mem;
 	struct usb_ehci_pdata *pdata;
 	int irq;
-	int err = -ENOMEM;
+	int err;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -91,8 +91,9 @@ static int ehci_platform_probe(struct platform_device *dev)
 		dev->dev.platform_data = &ehci_platform_defaults;
 	if (!dev->dev.dma_mask)
 		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
-	if (!dev->dev.coherent_dma_mask)
-		dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	err = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	pdata = dev->dev.platform_data;
 
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 7cc26e6..97127db 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -91,8 +91,9 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	s5p_setup_vbus_gpio(pdev);
 
diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 1cf0adb..6839e15 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -83,8 +83,9 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval)
+		goto fail;
 
 	usbh_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 6ee7ef7..ade3650 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -373,8 +373,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	setup_vbus_gpio(pdev, pdata);
 
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9677f68..e4a801d 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -507,7 +507,7 @@ MODULE_DEVICE_TABLE(of, at91_ohci_dt_ids);
 static int ohci_at91_of_init(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	int i, gpio;
+	int i, gpio, ret;
 	enum of_gpio_flags flags;
 	struct at91_usbh_data	*pdata;
 	u32 ports;
@@ -521,8 +521,9 @@ static int ohci_at91_of_init(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index b0b542c..42d6730 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -116,8 +116,9 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	exynos_ohci = devm_kzalloc(&pdev->dev, sizeof(struct exynos_ohci_hcd),
 					GFP_KERNEL);
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 7d7d507..5f82db4 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -226,8 +226,10 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto fail_disable;
 
 	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (nxp)\n", hcd_name);
 	if (usb_disabled()) {
diff --git a/drivers/usb/host/ohci-octeon.c b/drivers/usb/host/ohci-octeon.c
index 342dc7e..ac1dea1 100644
--- a/drivers/usb/host/ohci-octeon.c
+++ b/drivers/usb/host/ohci-octeon.c
@@ -127,8 +127,10 @@ static int ohci_octeon_drv_probe(struct platform_device *pdev)
 	}
 
 	/* Ohci is a 32-bit device. */
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	hcd = usb_create_hcd(&ohci_octeon_hc_driver, &pdev->dev, "octeon");
 	if (!hcd)
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index 8f71357..e767a01 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -132,7 +132,7 @@ static int ohci_hcd_omap3_probe(struct platform_device *pdev)
 	struct usb_hcd		*hcd = NULL;
 	void __iomem		*regs = NULL;
 	struct resource		*res;
-	int			ret = -ENODEV;
+	int			ret;
 	int			irq;
 
 	if (usb_disabled())
@@ -168,9 +168,11 @@ static int ohci_hcd_omap3_probe(struct platform_device *pdev)
 	 */
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto err_io;
 
+	ret = -ENODEV;
 	hcd = usb_create_hcd(&ohci_omap3_hc_driver, dev,
 			dev_name(dev));
 	if (!hcd) {
diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index 3a9c01d..88c97db 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -287,6 +287,7 @@ static int ohci_pxa_of_init(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct pxaohci_platform_data *pdata;
 	u32 tmp;
+	int ret;
 
 	if (!np)
 		return 0;
@@ -297,8 +298,9 @@ static int ohci_pxa_of_init(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index cc9dd9e..195a0a1 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -113,8 +113,9 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (retval)
+		goto fail;
 
 	usbh_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index d033a0e..048912d 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -77,8 +77,9 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 	 */
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	if (!pdev->dev.coherent_dma_mask)
-		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
 
 	hcd = usb_create_hcd(&uhci_platform_hc_driver, &pdev->dev,
 			pdev->name);
-- 
1.7.4.4

