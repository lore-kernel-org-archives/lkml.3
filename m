Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbaEFATc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:19:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41480 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757230AbaEFAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:35 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 05/20] usb: host: xhci-plat: Add clocks support
Date: Tue,  6 May 2014 02:14:00 +0200
Message-Id: <1399335255-589-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform (such as the Armada 38x ones) can gate the clock of
their USB controller. This patch add the support for the clock, by
enabling them during probe and disabling them on remove.

As not all platforms have clock support then enabling and disabling
the clocks have been placed in separate functions. Then if the clocks
are not supported we still can use the same calls, and there is no

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/xhci-plat.c | 57 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index f5351af4b2c5..bb37b941c8ec 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -11,6 +11,7 @@
  * version 2 as published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -19,6 +20,10 @@
 
 #include "xhci.h"
 
+struct xhci_plat_priv {
+	struct clk *clk;
+};
+
 static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
 	/*
@@ -38,7 +43,8 @@ static int xhci_plat_setup(struct usb_hcd *hcd)
 static const struct hc_driver xhci_plat_xhci_driver = {
 	.description =		"xhci-hcd",
 	.product_desc =		"xHCI Host Controller",
-	.hcd_priv_size =	sizeof(struct xhci_hcd *),
+	.hcd_priv_size =	sizeof(struct xhci_hcd *) +
+				sizeof(struct xhci_plat_priv),
 
 	/*
 	 * generic hardware linkage
@@ -85,6 +91,40 @@ static const struct hc_driver xhci_plat_xhci_driver = {
 	.bus_resume =		xhci_bus_resume,
 };
 
+static int xhci_plat_enable_clk(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct xhci_plat_priv *priv = (struct xhci_plat_priv *) xhci->priv;
+
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+
+	/*
+	 * Not all platforms have a clk so it is not an error if the
+	 * clock does not exists.
+	 */
+	if (IS_ERR(priv->clk))
+		return 0;
+
+	return clk_prepare_enable(priv->clk);
+}
+
+static void xhci_plat_disable_clk(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct xhci_plat_priv *priv = (struct xhci_plat_priv *) xhci->priv;
+
+	/*
+	 * Not all platforms have a clk so it is not an error if the
+	 * clock does not exists.
+	 */
+	if (IS_ERR(priv->clk))
+		return;
+
+	clk_disable_unprepare(priv->clk);
+}
+
 static int xhci_plat_probe(struct platform_device *pdev)
 {
 	const struct hc_driver	*driver;
@@ -118,7 +158,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd)
-		return -ENOMEM;
+		ret = -ENOMEM;
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
@@ -140,6 +180,13 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto unmap_registers;
+
+	ret = xhci_plat_enable_clk(pdev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "error enabling clocks\n");
+		goto dealloc_usb2_hcd;
+	}
+
 	device_wakeup_enable(hcd->self.controller);
 
 	/* USB 2.0 roothub is stored in the platform_device now. */
@@ -149,7 +196,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			dev_name(&pdev->dev), hcd);
 	if (!xhci->shared_hcd) {
 		ret = -ENOMEM;
-		goto dealloc_usb2_hcd;
+		goto disable_clk;
 	}
 
 	/*
@@ -170,6 +217,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
 put_usb3_hcd:
 	usb_put_hcd(xhci->shared_hcd);
 
+disable_clk:
+	xhci_plat_disable_clk(pdev);
+
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);
 
@@ -193,6 +243,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
+	xhci_plat_disable_clk(dev);
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-- 
1.8.1.2

