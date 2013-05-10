Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3EJIRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:34 -0400
Received: from sauhun.de ([89.238.76.85]:60567 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3EJIRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:30 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [RFC 30/42] drivers/usb/host: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:15 +0200
Message-Id: <1368173847-5661-31-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/usb/host/ehci-atmel.c    |    9 +--------
 drivers/usb/host/ehci-mxc.c      |    8 +-------
 drivers/usb/host/ehci-platform.c |    6 +-----
 drivers/usb/host/ehci-sh.c       |   10 +---------
 drivers/usb/host/ohci-nxp.c      |    6 ------
 drivers/usb/host/ohci-platform.c |    7 +------
 6 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 6642009..62bf3e6 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -101,17 +101,10 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 		goto fail_create_hcd;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		retval = -ENODEV;
-		goto fail_request_resource;
-	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		retval = PTR_ERR(hcd->regs);
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c369767..04be939 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -68,16 +68,10 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Found HC with no register addr. Check setup!\n");
-		ret = -ENODEV;
-		goto err_alloc;
-	}
-
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index f47f259..9466aea 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -95,11 +95,6 @@ static int ehci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "no irq provided");
 		return irq;
 	}
-	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res_mem) {
-		dev_err(&dev->dev, "no memory resource provided");
-		return -ENXIO;
-	}
 
 	if (pdata->power_on) {
 		err = pdata->power_on(dev);
@@ -117,6 +112,7 @@ static int ehci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
+	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
 	if (IS_ERR(hcd->regs)) {
 		err = PTR_ERR(hcd->regs);
diff --git a/drivers/usb/host/ehci-sh.c b/drivers/usb/host/ehci-sh.c
index b44d716..7b7809a 100644
--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -86,15 +86,6 @@ static int ehci_hcd_sh_probe(struct platform_device *pdev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(&pdev->dev));
-		ret = -ENODEV;
-		goto fail_create_hcd;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_err(&pdev->dev,
@@ -117,6 +108,7 @@ static int ehci_hcd_sh_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index f4988fb..f303cb0 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -300,12 +300,6 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Failed to get MEM resource\n");
-		ret =  -ENOMEM;
-		goto out8;
-	}
-
 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index c3e7287..6656420 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -106,12 +106,6 @@ static int ohci_platform_probe(struct platform_device *dev)
 		return irq;
 	}
 
-	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res_mem) {
-		dev_err(&dev->dev, "no memory resource provided");
-		return -ENXIO;
-	}
-
 	if (pdata->power_on) {
 		err = pdata->power_on(dev);
 		if (err < 0)
@@ -128,6 +122,7 @@ static int ohci_platform_probe(struct platform_device *dev)
 	hcd->rsrc_start = res_mem->start;
 	hcd->rsrc_len = resource_size(res_mem);
 
+	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
 	if (IS_ERR(hcd->regs)) {
 		err = PTR_ERR(hcd->regs);
-- 
1.7.10.4

