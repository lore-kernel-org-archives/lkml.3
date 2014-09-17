Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaIQLR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:17:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57342 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaIQLRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:17:55 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
Date: Wed, 17 Sep 2014 16:47:41 +0530
Message-Id: <1410952662-4297-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410952662-4297-1-git-send-email-gautam.vivek@samsung.com>
References: <1410952662-4297-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have completely moved from older USB-PHY drivers
to newer GENERIC-PHY drivers for PHYs available with USB controllers
on Exynos series of SoCs, we can remove the support for the same
in our host drivers too.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-exynos.c |   81 ++++++++++++----------------------------
 1 file changed, 23 insertions(+), 58 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 2eed9a4..99c5f5f 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -21,11 +21,8 @@
 #include <linux/of_gpio.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
-#include <linux/usb/phy.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <linux/usb/otg.h>
 
 #include "ehci.h"
 
@@ -47,9 +44,7 @@ static struct hc_driver __read_mostly exynos_ehci_hc_driver;
 
 struct exynos_ehci_hcd {
 	struct clk *clk;
-	struct usb_phy *phy;
-	struct usb_otg *otg;
-	struct phy *phy_g[PHY_NUMBER];
+	struct phy *phy[PHY_NUMBER];
 };
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
@@ -59,49 +54,39 @@ static int exynos_ehci_get_phy(struct device *dev,
 {
 	struct device_node *child;
 	struct phy *phy;
-	int phy_number;
-	int ret = 0;
+	int phy_num;
+	int ret;
 
 	for_each_available_child_of_node(dev->of_node, child) {
-		ret = of_property_read_u32(child, "reg", &phy_number);
+		ret = of_property_read_u32(child, "reg", &phy_num);
 		if (ret) {
 			dev_err(dev, "Failed to parse device tree\n");
 			of_node_put(child);
 			return ret;
 		}
 
-		if (phy_number >= PHY_NUMBER) {
+		if (phy_num >= PHY_NUMBER) {
 			dev_err(dev, "Invalid number of PHYs\n");
 			of_node_put(child);
 			return -EINVAL;
 		}
 
-		phy = devm_of_phy_get(dev, child, NULL);
+		exynos_ehci->phy[phy_num] = devm_of_phy_get(dev, child, NULL);
+		phy = exynos_ehci->phy[phy_num];
 		of_node_put(child);
-		if (IS_ERR(phy))
-			/* Lets fallback to older USB-PHYs */
-			goto usb_phy_old;
-		exynos_ehci->phy_g[phy_number] = phy;
-		/* Make the older PHYs unavailable */
-		exynos_ehci->phy = ERR_PTR(-ENXIO);
-	}
-
-	return 0;
-
-usb_phy_old:
-	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(exynos_ehci->phy)) {
-		ret = PTR_ERR(exynos_ehci->phy);
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
-		exynos_ehci->otg = exynos_ehci->phy->otg;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int exynos_ehci_phy_enable(struct device *dev)
@@ -111,16 +96,13 @@ static int exynos_ehci_phy_enable(struct device *dev)
 	int i;
 	int ret = 0;
 
-	if (!IS_ERR(exynos_ehci->phy))
-		return usb_phy_init(exynos_ehci->phy);
-
 	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ehci->phy_g[i]))
-			ret = phy_power_on(exynos_ehci->phy_g[i]);
+		if (!IS_ERR(exynos_ehci->phy[i]))
+			ret = phy_power_on(exynos_ehci->phy[i]);
 	if (ret)
 		for (i--; i >= 0; i--)
-			if (!IS_ERR(exynos_ehci->phy_g[i]))
-				phy_power_off(exynos_ehci->phy_g[i]);
+			if (!IS_ERR(exynos_ehci->phy[i]))
+				phy_power_off(exynos_ehci->phy[i]);
 
 	return ret;
 }
@@ -131,14 +113,9 @@ static void exynos_ehci_phy_disable(struct device *dev)
 	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
 	int i;
 
-	if (!IS_ERR(exynos_ehci->phy)) {
-		usb_phy_shutdown(exynos_ehci->phy);
-		return;
-	}
-
 	for (i = 0; i < PHY_NUMBER; i++)
-		if (!IS_ERR(exynos_ehci->phy_g[i]))
-			phy_power_off(exynos_ehci->phy_g[i]);
+		if (!IS_ERR(exynos_ehci->phy[i]))
+			phy_power_off(exynos_ehci->phy[i]);
 }
 
 static void exynos_setup_vbus_gpio(struct device *dev)
@@ -231,9 +208,6 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	err = exynos_ehci_phy_enable(&pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable USB phy\n");
@@ -273,9 +247,6 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	exynos_ehci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
@@ -298,9 +269,6 @@ static int exynos_ehci_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	exynos_ehci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
@@ -316,9 +284,6 @@ static int exynos_ehci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ehci->clk);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	ret = exynos_ehci_phy_enable(dev);
 	if (ret) {
 		dev_err(dev, "Failed to enable USB phy\n");
-- 
1.7.10.4

