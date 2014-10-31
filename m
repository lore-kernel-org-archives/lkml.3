Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbaJaN0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:26:50 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51863 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbaJaN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:26:47 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jwerner@google.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v7 1/2] usb: host: xhci-plat: Get PHYs for xhci's hcds
Date: Fri, 31 Oct 2014 18:56:28 +0530
Message-Id: <1414761989-21088-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
References: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host controller by itself may sometimes need to handle PHY
and re-initialize it to re-configure some of the PHY parameters
to get full support out of the PHY controller.
Therefore, facilitate getting the two possible PHYs, viz.
USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3), and initialize them.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/xhci-plat.c |   74 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 3d78b0c..5207d5b 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 #include <linux/slab.h>
 #include <linux/usb/xhci_pdriver.h>
 
@@ -129,10 +130,41 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			goto put_hcd;
 	}
 
+	/* Get possile USB 2.0 type PHY (UTMI+) available with xhci */
+	hcd->phy = devm_phy_get(&pdev->dev, "usb2-phy");
+	if (IS_ERR(hcd->phy)) {
+		ret = PTR_ERR(hcd->phy);
+		if (ret == -EPROBE_DEFER) {
+			goto disable_clk;
+		} else if (ret != -ENOSYS && ret != -ENODEV) {
+			hcd->phy = NULL;
+			dev_warn(&pdev->dev,
+				 "Error retrieving usb2 phy: %d\n", ret);
+		}
+	}
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto disable_clk;
 
+	/*
+	 * Initialize and power-on USB 2.0 PHY
+	 * FIXME: Isn't this a hacky way of initializing the PHY again ?
+	 * xhci's parent would have already initialized the PHY, but we
+	 * wanna do it again.
+	 */
+	hcd->phy->init_count = 0;
+	ret = phy_init(hcd->phy);
+	if (ret)
+		goto dealloc_usb2_hcd;
+
+	hcd->phy->power_count = 0;
+	ret = phy_power_on(hcd->phy);
+	if (ret) {
+		phy_exit(hcd->phy);
+		goto dealloc_usb2_hcd;
+	}
+
 	device_wakeup_enable(hcd->self.controller);
 
 	/* USB 2.0 roothub is stored in the platform_device now. */
@@ -158,12 +190,41 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
+	/* Get possile USB 3.0 type PHY (PIPE3) available with xhci */
+	xhci->shared_hcd->phy = devm_phy_get(&pdev->dev, "usb3-phy");
+	if (IS_ERR(xhci->shared_hcd->phy)) {
+		ret = PTR_ERR(xhci->shared_hcd->phy);
+		if (ret == -EPROBE_DEFER) {
+			goto put_usb3_hcd;
+		} else if (ret != -ENOSYS && ret != -ENODEV) {
+			xhci->shared_hcd->phy = NULL;
+			dev_warn(&pdev->dev,
+				 "Error retrieving usb3 phy: %d\n", ret);
+		}
+	}
+
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto put_usb3_hcd;
 
+	/* Initialize and power-on USB 3.0 PHY */
+	xhci->shared_hcd->phy->init_count = 0;
+	ret = phy_init(xhci->shared_hcd->phy);
+	if (ret)
+		goto dealloc_usb3_hcd;
+
+	xhci->shared_hcd->phy->power_count = 0;
+	ret = phy_power_on(xhci->shared_hcd->phy);
+	if (ret) {
+		phy_exit(xhci->shared_hcd->phy);
+		goto dealloc_usb3_hcd;
+	}
+
 	return 0;
 
+dealloc_usb3_hcd:
+	usb_remove_hcd(xhci->shared_hcd);
+
 put_usb3_hcd:
 	usb_put_hcd(xhci->shared_hcd);
 
@@ -186,9 +247,15 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	struct clk *clk = xhci->clk;
 
+	phy_power_off(xhci->shared_hcd->phy);
+	phy_exit(xhci->shared_hcd->phy);
+
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
+	phy_power_off(hcd->phy);
+	phy_exit(hcd->phy);
+
 	usb_remove_hcd(hcd);
 	if (!IS_ERR(clk))
 		clk_disable_unprepare(clk);
@@ -204,6 +271,8 @@ static int xhci_plat_suspend(struct device *dev)
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 
+	phy_exit(hcd->phy);
+
 	return xhci_suspend(xhci);
 }
 
@@ -211,6 +280,11 @@ static int xhci_plat_resume(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	int ret;
+
+	ret = phy_init(hcd->phy);
+	if (ret)
+		return ret;
 
 	return xhci_resume(xhci, 0);
 }
-- 
1.7.10.4

