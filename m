Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaIREZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 00:25:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46478 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaIREZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 00:25:22 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v4 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy support
Date: Thu, 18 Sep 2014 09:55:15 +0530
Message-Id: <1411014315-17914-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <001501cfd26f54983d0$%han@samsung.com>
References: <001501cfd26f54983d0$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have completely moved from older USB-PHY drivers
to newer GENERIC-PHY drivers for PHYs available with USB controllers
on Exynos series of SoCs, we can remove the support for the same
in our host drivers too.

We also defer the probe for our host in case we end up getting
EPROBE_DEFER error when getting PHYs.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---

Changes since v3:
 - Addressed review comments by Alan:
   -- Skipped renaming 'phy_number' variable,
   -- resorted to just adding minimal change required for phy assignment.
   -- updated patch description to mention EPROBE_DEFER support.

 drivers/usb/host/ohci-exynos.c |   81 ++++++++++------------------------------
 1 file changed, 20 insertions(+), 61 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 7c48e3f..e8bf4bb 100644
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
@@ -49,15 +44,9 @@ static int exynos_ohci_get_phy(struct device *dev,
 	struct device_node *child;
 	struct phy *phy;
 	int phy_number;
-	int ret = 0;
+	int ret;
 
-	/*
-	 * Getting generic phy:
-	 * We are keeping both types of phys as a part of transiting OHCI
-	 * to generic phy framework, so as to maintain backward compatibilty
-	 * with old DTB too.
-	 * We fallback to older USB-PHYs when we fail to get generic PHYs.
-	 */
+	/* Get PHYs for the controller */
 	for_each_available_child_of_node(dev->of_node, child) {
 		ret = of_property_read_u32(child, "reg", &phy_number);
 		if (ret) {
@@ -73,31 +62,21 @@ static int exynos_ohci_get_phy(struct device *dev,
 		}
 
 		phy = devm_of_phy_get(dev, child, NULL);
+		exynos_ohci->phy[phy_number] = phy;
 		of_node_put(child);
-		if (IS_ERR(phy))
-			/* Lets fallback to older USB-PHYs */
-			goto usb_phy_old;
-		exynos_ohci->phy_g[phy_number] = phy;
-		/* Make the older PHYs unavailable */
-		exynos_ohci->phy = ERR_PTR(-ENXIO);
-	}
-
-	return 0;
-
-usb_phy_old:
-	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(exynos_ohci->phy)) {
-		ret = PTR_ERR(exynos_ohci->phy);
-		if (ret != -ENXIO && ret != -ENODEV) {
-			dev_err(dev, "no usb2 phy configured\n");
-			return ret;
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			if (ret == -EPROBE_DEFER) {
+				return ret;
+			} else if (ret != -ENOSYS && ret != -ENODEV) {
+				dev_err(dev,
+					"Error retrieving usb2 phy: %d\n", ret);
+				return PTR_ERR(phy);
+			}
 		}
-		dev_dbg(dev, "Failed to get usb2 phy\n");
-	} else {
-		exynos_ohci->otg = exynos_ohci->phy->otg;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int exynos_ohci_phy_enable(struct device *dev)
@@ -107,16 +86,13 @@ static int exynos_ohci_phy_enable(struct device *dev)
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
@@ -127,14 +103,9 @@ static void exynos_ohci_phy_disable(struct device *dev)
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
@@ -206,9 +177,6 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	platform_set_drvdata(pdev, hcd);
 
 	err = exynos_ohci_phy_enable(&pdev->dev);
@@ -241,9 +209,6 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -272,9 +237,6 @@ static int exynos_ohci_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	exynos_ohci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
@@ -290,9 +252,6 @@ static int exynos_ohci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-	if (exynos_ohci->otg)
-		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
-
 	ret = exynos_ohci_phy_enable(dev);
 	if (ret) {
 		dev_err(dev, "Failed to enable USB phy\n");
-- 
1.7.10.4

