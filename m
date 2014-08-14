Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaHNOYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:50 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38393 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbaHNOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:45 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 7/7] usb: host: ohci-exynos: Remove unnecessary usb-phy support
Date: Thu, 14 Aug 2014 19:54:00 +0530
Message-Id: <1408026240-28365-8-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have completely moved from older USB-PHY drivers
to newer GENERIC-PHY drivers for PHYs available with USB controllers
on Exynos series of SoCs, we can remove the support for the same
in our host drivers too.
This should fix the issue on ohci-exynos, wherein in the absence of
SAMSUNG_USB2PHY config symbol, we ended up getting the NOP_USB_XCEIV phy
when the same is enabled. And thus the PHYs are not configured properly.

Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ohci-exynos.c |   64 ++++++----------------------------------
 1 file changed, 9 insertions(+), 55 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index a72ab8f..0199a8b 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -19,11 +19,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
-#include <linux/usb/phy.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <linux/usb/otg.h>
 
 #include "ohci.h"
 
@@ -38,9 +35,7 @@ static struct hc_driver __read_mostly exynos_ohci_hc_driver;
 
 struct exynos_ohci_hcd {
 	struct clk *clk;
-	struct usb_phy *phy;
-	struct usb_otg *otg;
-	struct phy *phy_g[PHY_NUMBER];
+	struct phy *phy[PHY_NUMBER];
 };
 
 static int exynos_ohci_get_phy(struct device *dev,
@@ -51,28 +46,7 @@ static int exynos_ohci_get_phy(struct device *dev,
 	int phy_number;
 	int ret = 0;
 
-	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(exynos_ohci->phy)) {
-		ret = PTR_ERR(exynos_ohci->phy);
-		if (ret != -ENXIO && ret != -ENODEV) {
-			dev_err(dev, "no usb2 phy configured\n");
-			return ret;
-		}
-		dev_dbg(dev, "Failed to get usb2 phy\n");
-	} else {
-		exynos_ohci->otg = exynos_ohci->phy->otg;
-	}
-
-	/*
-	 * Getting generic phy:
-	 * We are keeping both types of phys as a part of transiting OHCI
-	 * to generic phy framework, so as to maintain backward compatibilty
-	 * with old DTB.
-	 * If there are existing devices using DTB files built from them,
-	 * to remove the support for old bindings in this driver,
-	 * we need to make sure that such devices have their DTBs
-	 * updated to ones built from new DTS.
-	 */
+	/* Get the generic phys */
 	for_each_available_child_of_node(dev->of_node, child) {
 		ret = of_property_read_u32(child, "reg", &phy_number);
 		if (ret) {
@@ -97,7 +71,7 @@ static int exynos_ohci_get_phy(struct device *dev,
 			}
 			dev_dbg(dev, "Failed to get usb2 phy\n");
 		}
-		exynos_ohci->phy_g[phy_number] = phy;
+		exynos_ohci->phy[phy_number] = phy;
 	}
 
 	return ret;
@@ -110,16 +84,13 @@ static int exynos_ohci_phy_enable(struct device *dev)
 	int i;
 	int ret = 0;
 
-	if (!IS_ERR(exynos_ohci->phy))
-		return usb_phy_init(exynos_ohci->phy);
-
 	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ohci->phy_g[i]))
-			ret = phy_power_on(exynos_ohci->phy_g[i]);
+		if (!IS_ERR(exynos_ohci->phy[i]))
+			ret = phy_power_on(exynos_ohci->phy[i]);
 	if (ret)
 		for (i--; i >= 0; i--)
-			if (!IS_ERR(exynos_ohci->phy_g[i]))
-				phy_power_off(exynos_ohci->phy_g[i]);
+			if (!IS_ERR(exynos_ohci->phy[i]))
+				phy_power_off(exynos_ohci->phy[i]);
 
 	return ret;
 }
@@ -130,14 +101,9 @@ static void exynos_ohci_phy_disable(struct device *dev)
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 	int i;
 
-	if (!IS_ERR(exynos_ohci->phy)) {
-		usb_phy_shutdown(exynos_ohci->phy);
-		return;
-	}
-
 	for (i = 0; i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ohci->phy_g[i]))
-			phy_power_off(exynos_ohci->phy_g[i]);
+		if (!IS_ERR(exynos_ohci->phy[i]))
+			phy_power_off(exynos_ohci->phy[i]);
 }
 
 static int exynos_ohci_probe(struct platform_device *pdev)
@@ -209,9 +175,6 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	platform_set_drvdata(pdev, hcd);
 
 	err = exynos_ohci_phy_enable(&pdev->dev);
@@ -244,9 +207,6 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -275,9 +235,6 @@ static int exynos_ohci_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -293,9 +250,6 @@ static int exynos_ohci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	ret = exynos_ohci_phy_enable(dev);
 	if (ret) {
 		dev_err(dev, "Failed to enable USB phy\n");
-- 
1.7.10.4

