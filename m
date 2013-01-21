Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3AUKK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3AUKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:23 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 29/33] usb: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:22 +0100
Message-Id: <1358762966-20791-30-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:S4I2cW5hqxxOXNisSUTu4pOkw4l4wqtbGhlz1af535q
 8yr+YYyuN21HyMvQkZMvZCc2B5+rWd2yVP7ppuN6fOL3ORyWk3
 IJyLrd98q4fHmCo9aIxxE+01c40UGiVmmLLFizFy3gIQrD3PWk
 UG0/CZ6CLU9kghWvJ1DdLb4Ag5SMFiYbYHfhvwrxHWkfJhdOU7
 iJRGBOEdEPLFxsDHSgef1a+PrLLSeFAI/GU+3M2F9YdJZVSzA6
 alSVocS9ANPrGzTs8c2amZ1wDakym2G1yiEKpHWD8bBL4cTVsp
 QmgARNtDOIpcDRkWNlnQf/ddIy3+nDG2j25jO6h5i+vzvzTZD0
 VeI7QVm29nVnbJNh/fBTiNMhba8BZn4kD4woJQQSWGJBTwmnWX
 lwd1ayLCghZ7pxTZOr1YW72qgaRW6Ah29u+Tt+W1HEBbi9+u/u
 ydN+4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/chipidea/usbmisc_imx6q.c |  6 +++---
 drivers/usb/gadget/bcm63xx_udc.c     | 13 +++++++------
 drivers/usb/gadget/s3c-hsotg.c       |  7 +++----
 drivers/usb/gadget/s3c-hsudc.c       |  7 +++----
 drivers/usb/host/ehci-atmel.c        |  7 +++----
 drivers/usb/host/ehci-grlib.c        |  9 ++++-----
 drivers/usb/host/ehci-mxc.c          |  7 +++----
 drivers/usb/host/ehci-platform.c     |  7 ++++---
 drivers/usb/host/ehci-ppc-of.c       |  8 ++++----
 drivers/usb/host/ehci-sead3.c        |  8 ++++----
 drivers/usb/host/ehci-sh.c           |  7 +++----
 drivers/usb/host/ehci-vt8500.c       |  8 ++++----
 drivers/usb/host/ehci-xilinx-of.c    |  8 ++++----
 drivers/usb/host/ohci-nxp.c          |  7 +++----
 drivers/usb/host/ohci-platform.c     |  7 ++++---
 drivers/usb/host/ohci-s3c2410.c      |  7 +++----
 drivers/usb/musb/musb_dsps.c         |  7 +++----
 drivers/usb/musb/omap2430.c          |  4 +---
 drivers/usb/otg/mxs-phy.c            |  6 +++---
 drivers/usb/phy/mv_u3d_phy.c         |  8 +++-----
 drivers/usb/phy/omap-usb2.c          |  8 +++-----
 drivers/usb/renesas_usbhs/common.c   |  9 ++++-----
 22 files changed, 76 insertions(+), 89 deletions(-)

diff --git a/drivers/usb/chipidea/usbmisc_imx6q.c b/drivers/usb/chipidea/usbmisc_imx6q.c
index 845efe2..a1bce39 100644
--- a/drivers/usb/chipidea/usbmisc_imx6q.c
+++ b/drivers/usb/chipidea/usbmisc_imx6q.c
@@ -98,9 +98,9 @@ static int usbmisc_imx6q_probe(struct platform_device *pdev)
 	spin_lock_init(&data->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!data->base)
-		return -EADDRNOTAVAIL;
+	data->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->base))
+		return PTR_ERR(data->base);
 
 	data->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(data->clk)) {
diff --git a/drivers/usb/gadget/bcm63xx_udc.c b/drivers/usb/gadget/bcm63xx_udc.c
index 47a4993..8cc8253 100644
--- a/drivers/usb/gadget/bcm63xx_udc.c
+++ b/drivers/usb/gadget/bcm63xx_udc.c
@@ -2351,19 +2351,20 @@ static int bcm63xx_udc_probe(struct platform_device *pdev)
 		dev_err(dev, "error finding USBD resource\n");
 		return -ENXIO;
 	}
-	udc->usbd_regs = devm_request_and_ioremap(dev, res);
+
+	udc->usbd_regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(udc->usbd_regs))
+		return PTR_ERR(udc->usbd_regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res) {
 		dev_err(dev, "error finding IUDMA resource\n");
 		return -ENXIO;
 	}
-	udc->iudma_regs = devm_request_and_ioremap(dev, res);
 
-	if (!udc->usbd_regs || !udc->iudma_regs) {
-		dev_err(dev, "error requesting resources\n");
-		return -ENXIO;
-	}
+	udc->iudma_regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(udc->iudma_regs))
+		return PTR_ERR(udc->iudma_regs);
 
 	spin_lock_init(&udc->lock);
 	INIT_WORK(&udc->ep0_wq, bcm63xx_ep0_process);
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 439c3f9..de80fa6 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3525,10 +3525,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	hsotg->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hsotg->regs) {
-		dev_err(dev, "cannot map registers\n");
-		ret = -ENXIO;
+	hsotg->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hsotg->regs)) {
+		ret = PTR_ERR(hsotg->regs);
 		goto err_clk;
 	}
 
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 52379b1..94ca33b 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1295,10 +1295,9 @@ static int s3c_hsudc_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	hsudc->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hsudc->regs) {
-		dev_err(dev, "error mapping device register area\n");
-		ret = -EBUSY;
+	hsudc->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hsudc->regs)) {
+		ret = PTR_ERR(hsudc->regs);
 		goto err_res;
 	}
 
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 27639487..f3beac4 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -143,10 +143,9 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
-		retval = -EFAULT;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		retval = PTR_ERR(hcd->regs);
 		goto fail_request_resource;
 	}
 
diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
index 1fc8929..5d75de9 100644
--- a/drivers/usb/host/ehci-grlib.c
+++ b/drivers/usb/host/ehci-grlib.c
@@ -25,7 +25,7 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-
+#include <linux/err.h>
 #include <linux/signal.h>
 
 #include <linux/of_irq.h>
@@ -118,10 +118,9 @@ static int ehci_hcd_grlib_probe(struct platform_device *op)
 		goto err_irq;
 	}
 
-	hcd->regs = devm_request_and_ioremap(&op->dev, &res);
-	if (!hcd->regs) {
-		pr_err("%s: devm_request_and_ioremap failed\n", __FILE__);
-		rv = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&op->dev, &res);
+	if (IS_ERR(hcd->regs)) {
+		rv = PTR_ERR(hcd->regs);
 		goto err_ioremap;
 	}
 
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index ec7f5d2..4f506af 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -128,10 +128,9 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hcd->regs) {
-		dev_err(dev, "error mapping memory\n");
-		ret = -EFAULT;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto err_alloc;
 	}
 
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 58fa0c9..ca75063 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -18,6 +18,7 @@
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/hrtimer.h>
 #include <linux/io.h>
@@ -104,9 +105,9 @@ static int ehci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
-	hcd->regs = devm_request_and_ioremap(&dev->dev, res_mem);
-	if (!hcd->regs) {
-		err = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
+	if (IS_ERR(hcd->regs)) {
+		err = PTR_ERR(hcd->regs);
 		goto err_put_hcd;
 	}
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 45aceef..56dc732 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -12,6 +12,7 @@
  * This file is licenced under the GPL.
  */
 
+#include <linux/err.h>
 #include <linux/signal.h>
 
 #include <linux/of.h>
@@ -121,10 +122,9 @@ static int ehci_hcd_ppc_of_probe(struct platform_device *op)
 		goto err_irq;
 	}
 
-	hcd->regs = devm_request_and_ioremap(&op->dev, &res);
-	if (!hcd->regs) {
-		pr_err("%s: devm_request_and_ioremap failed\n", __FILE__);
-		rv = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&op->dev, &res);
+	if (IS_ERR(hcd->regs)) {
+		rv = PTR_ERR(hcd->regs);
 		goto err_ioremap;
 	}
 
diff --git a/drivers/usb/host/ehci-sead3.c b/drivers/usb/host/ehci-sead3.c
index efad02d..f55477c 100644
--- a/drivers/usb/host/ehci-sead3.c
+++ b/drivers/usb/host/ehci-sead3.c
@@ -19,6 +19,7 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/err.h>
 #include <linux/platform_device.h>
 
 static int ehci_sead3_setup(struct usb_hcd *hcd)
@@ -112,10 +113,9 @@ static int ehci_hcd_sead3_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hcd->regs) {
-		pr_debug("ioremap failed");
-		ret = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto err1;
 	}
 
diff --git a/drivers/usb/host/ehci-sh.c b/drivers/usb/host/ehci-sh.c
index 0c90a24..3565a30 100644
--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -118,10 +118,9 @@ static int ehci_hcd_sh_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
-		ret = -ENXIO;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto fail_request_resource;
 	}
 
diff --git a/drivers/usb/host/ehci-vt8500.c b/drivers/usb/host/ehci-vt8500.c
index 11695d5..7ecf709 100644
--- a/drivers/usb/host/ehci-vt8500.c
+++ b/drivers/usb/host/ehci-vt8500.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -96,10 +97,9 @@ static int vt8500_ehci_drv_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hcd->regs) {
-		pr_debug("ioremap failed");
-		ret = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto err1;
 	}
 
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 4f285e8..d845e3b 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/signal.h>
 
 #include <linux/of.h>
@@ -159,10 +160,9 @@ static int ehci_hcd_xilinx_of_probe(struct platform_device *op)
 		goto err_irq;
 	}
 
-	hcd->regs = devm_request_and_ioremap(&op->dev, &res);
-	if (!hcd->regs) {
-		pr_err("%s: devm_request_and_ioremap failed\n", __FILE__);
-		rv = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&op->dev, &res);
+	if (IS_ERR(hcd->regs)) {
+		rv = PTR_ERR(hcd->regs);
 		goto err_irq;
 	}
 
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 2344040..f4988fb 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -306,10 +306,9 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 		goto out8;
 	}
 
-	hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!hcd->regs) {
-		dev_err(&pdev->dev, "Failed to devm_request_and_ioremap\n");
-		ret =  -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto out8;
 	}
 	hcd->rsrc_start = res->start;
diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 084503b..c3e7287 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -13,6 +13,7 @@
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
+#include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/usb/ohci_pdriver.h>
 
@@ -127,9 +128,9 @@ static int ohci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
-	hcd->regs = devm_request_and_ioremap(&dev->dev, res_mem);
-	if (!hcd->regs) {
-		err = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
+	if (IS_ERR(hcd->regs)) {
+		err = PTR_ERR(hcd->regs);
 		goto err_put_hcd;
 	}
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
diff --git a/drivers/usb/host/ohci-s3c2410.c b/drivers/usb/host/ohci-s3c2410.c
index ad0f552..e125770 100644
--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -351,10 +351,9 @@ static int usb_hcd_s3c2410_probe(const struct hc_driver *driver,
 	hcd->rsrc_start = dev->resource[0].start;
 	hcd->rsrc_len	= resource_size(&dev->resource[0]);
 
-	hcd->regs = devm_request_and_ioremap(&dev->dev, &dev->resource[0]);
-	if (!hcd->regs) {
-		dev_err(&dev->dev, "devm_request_and_ioremap failed\n");
-		retval = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&dev->dev, &dev->resource[0]);
+	if (IS_ERR(hcd->regs)) {
+		retval = PTR_ERR(hcd->regs);
 		goto err_put;
 	}
 
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index f7d764d..99f470d 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -500,10 +500,9 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
 	resources[0].end = resources[0].start + SZ_4 - 1;
 	resources[0].flags = IORESOURCE_MEM;
 
-	glue->usb_ctrl[id] = devm_request_and_ioremap(&pdev->dev, resources);
-	if (glue->usb_ctrl[id] == NULL) {
-		dev_err(dev, "Failed to obtain usb_ctrl%d memory\n", id);
-		ret = -ENODEV;
+	glue->usb_ctrl[id] = devm_ioremap_resource(&pdev->dev, resources);
+	if (IS_ERR(glue->usb_ctrl[id])) {
+		ret = PTR_ERR(glue->usb_ctrl[id]);
 		goto err0;
 	}
 
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index da00af4..acd5f9d 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -523,9 +523,7 @@ static int omap2430_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 
-	glue->control_otghs = devm_request_and_ioremap(&pdev->dev, res);
-	if (glue->control_otghs == NULL)
-		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
+	glue->control_otghs = devm_ioremap_resource(&pdev->dev, res);
 
 	if (np) {
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
diff --git a/drivers/usb/otg/mxs-phy.c b/drivers/usb/otg/mxs-phy.c
index 7630272..60df28a 100644
--- a/drivers/usb/otg/mxs-phy.c
+++ b/drivers/usb/otg/mxs-phy.c
@@ -115,9 +115,9 @@ static int mxs_phy_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -EBUSY;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
diff --git a/drivers/usb/phy/mv_u3d_phy.c b/drivers/usb/phy/mv_u3d_phy.c
index eaddbe3..9d85991 100644
--- a/drivers/usb/phy/mv_u3d_phy.c
+++ b/drivers/usb/phy/mv_u3d_phy.c
@@ -283,11 +283,9 @@ static int mv_u3d_phy_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	phy_base = devm_request_and_ioremap(dev, res);
-	if (!phy_base) {
-		dev_err(dev, "%s: register mapping failed\n", __func__);
-		return -ENXIO;
-	}
+	phy_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy_base))
+		return PTR_ERR(phy_base);
 
 	mv_u3d_phy = devm_kzalloc(dev, sizeof(*mv_u3d_phy), GFP_KERNEL);
 	if (!mv_u3d_phy)
diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index 26ae8f4..2fdb8ed 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -168,11 +168,9 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 
-	phy->control_dev = devm_request_and_ioremap(&pdev->dev, res);
-	if (phy->control_dev == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENXIO;
-	}
+	phy->control_dev = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(phy->control_dev))
+		return PTR_ERR(phy->control_dev);
 
 	phy->is_suspended	= 1;
 	omap_usb_phy_power(phy, 0);
diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index 38bce04..cfd2050 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -14,6 +14,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  */
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
@@ -443,11 +444,9 @@ static int usbhs_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->base) {
-		dev_err(&pdev->dev, "ioremap error.\n");
-		return -ENOMEM;
-	}
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
 
 	/*
 	 * care platform info
-- 
1.8.1.1

