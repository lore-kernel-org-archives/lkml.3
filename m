Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaHNOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:25:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61643 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaHNOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:41 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 6/7] usb: host: ehci-exynos: Remove unnecessary usb-phy support
Date: Thu, 14 Aug 2014 19:53:59 +0530
Message-Id: <1408026240-28365-7-git-send-email-gautam.vivek@samsung.com>
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
This should fix the issue on ehci-exynos, wherein in the absence of
SAMSUNG_USB2PHY config symbol, we ended up getting the NOP_USB_XCEIV phy
when the same is enabled. And thus the PHYs are not configured properly.

Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-exynos.c |   53 ++++++----------------------------------
 1 file changed, 8 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index cda0a2f..54944cc 100644
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
@@ -62,18 +57,6 @@ static int exynos_ehci_get_phy(struct device *dev,
 	int phy_number;
 	int ret = 0;
 
-	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(exynos_ehci->phy)) {
-		ret = PTR_ERR(exynos_ehci->phy);
-		if (ret != -ENXIO && ret != -ENODEV) {
-			dev_err(dev, "no usb2 phy configured\n");
-			return ret;
-		}
-		dev_dbg(dev, "Failed to get usb2 phy\n");
-	} else {
-		exynos_ehci->otg = exynos_ehci->phy->otg;
-	}
-
 	for_each_available_child_of_node(dev->of_node, child) {
 		ret = of_property_read_u32(child, "reg", &phy_number);
 		if (ret) {
@@ -98,7 +81,7 @@ static int exynos_ehci_get_phy(struct device *dev,
 			}
 			dev_dbg(dev, "Failed to get usb2 phy\n");
 		}
-		exynos_ehci->phy_g[phy_number] = phy;
+		exynos_ehci->phy[phy_number] = phy;
 	}
 
 	return ret;
@@ -111,16 +94,13 @@ static int exynos_ehci_phy_enable(struct device *dev)
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
@@ -131,14 +111,9 @@ static void exynos_ehci_phy_disable(struct device *dev)
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
@@ -231,9 +206,6 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	err = exynos_ehci_phy_enable(&pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable USB phy\n");
@@ -273,9 +245,6 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	exynos_ehci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
@@ -298,9 +267,6 @@ static int exynos_ehci_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	exynos_ehci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
@@ -316,9 +282,6 @@ static int exynos_ehci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ehci->clk);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
 	ret = exynos_ehci_phy_enable(dev);
 	if (ret) {
 		dev_err(dev, "Failed to enable USB phy\n");
-- 
1.7.10.4

