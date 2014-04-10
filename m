Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031002AbaDJNZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:25:54 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58539 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030907AbaDJNZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:25:13 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kgene.kim@samsung.com, robh+dt@kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
Date: Thu, 10 Apr 2014 18:54:21 +0530
Message-Id: <1397136261-16408-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to consume phy provided by Generic phy framework.
Keeping the support for older usb-phy intact right now, in order
to prevent any functionality break in absence of relevant
device tree side change for ohci-exynos.
Once we move to new phy in the device nodes for ohci, we can
remove the support for older phys.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---

Based on 'usb-next' branch of Greg's usb tree.
Tested with local dt patches, similar to ehci dt changes posted by Kamil[1].
Tested on Exynos5250 smdk.

[1] [PATCH v6 4/8] dts: Add usb2phy to Exynos 5250
    https://lkml.org/lkml/2014/1/29/302

 .../devicetree/bindings/usb/exynos-usb.txt         |   14 ++++
 drivers/usb/host/ohci-exynos.c                     |   79 ++++++++++++++++++--
 2 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index d967ba1..ef0bc09 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -38,6 +38,10 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+ - port: if in the SoC there are OHCI phys, they should be listed here.
+One phy per port. Each port should have its reg entry with a consecutive
+number. Also it should contain phys and phy-names entries specifying the
+phy used by the port.
 
 Example:
 	usb@12120000 {
@@ -47,6 +51,16 @@ Example:
 
 		clocks = <&clock 285>;
 		clock-names = "usbhost";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+		    reg = <0>;
+		    phys = <&usb2phy 1>;
+		    phy-names = "host";
+		    status = "disabled";
+		};
+
 	};
 
 DWC3
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 68588d8..52eb821 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
@@ -37,6 +38,7 @@ struct exynos_ohci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct phy *phy_g;
 };
 
 static void exynos_ohci_phy_enable(struct platform_device *pdev)
@@ -57,12 +59,26 @@ static void exynos_ohci_phy_disable(struct platform_device *pdev)
 		usb_phy_shutdown(exynos_ohci->phy);
 }
 
+static int exynos_ohci_phyg_on(struct phy *phy, bool on)
+{
+	int ret = 0;
+
+	if (phy) {
+		if (on)
+			ret = phy_power_on(phy);
+		else
+			ret = phy_power_off(phy);
+	}
+
+	return ret;
+}
+
 static int exynos_ohci_probe(struct platform_device *pdev)
 {
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct resource *res;
-	struct usb_phy *phy;
+	struct device_node *child;
 	int irq;
 	int err;
 
@@ -88,16 +104,49 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 					"samsung,exynos5440-ohci"))
 		goto skip_phy;
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(phy)) {
-		usb_put_hcd(hcd);
-		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
-		return -EPROBE_DEFER;
+	exynos_ohci->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR(exynos_ohci->phy)) {
+		err = PTR_ERR(exynos_ohci->phy);
+		if (err == -ENXIO || err == -ENODEV) {
+			exynos_ohci->phy = NULL;
+		} else if (err == -EPROBE_DEFER) {
+			usb_put_hcd(hcd);
+			return err;
+		} else {
+			dev_err(&pdev->dev, "no usb2 phy configured\n");
+			usb_put_hcd(hcd);
+			return err;
+		}
 	} else {
-		exynos_ohci->phy = phy;
-		exynos_ohci->otg = phy->otg;
+		exynos_ohci->otg = exynos_ohci->phy->otg;
 	}
 
+	/* Getting generic phy:
+	 * We are keeping both types of phys as a part of transiting OHCI
+	 * to generic phy framework, so that in absence of supporting dts
+	 * changes the functionality doesn't break.
+	 * Once we move the ohci dt nodes to use new generic phys,
+	 * we can remove support for older PHY in this driver.
+	 */
+	child = of_get_next_child(pdev->dev.of_node, NULL);
+	exynos_ohci->phy_g = devm_of_phy_get(&pdev->dev, child, 0);
+	of_node_put(child);
+	if (IS_ERR(exynos_ohci->phy_g)) {
+		err = PTR_ERR(exynos_ohci->phy_g);
+		if (err == -ENOSYS || err == -ENODEV) {
+			exynos_ohci->phy_g = NULL;
+		} else if (err == -EPROBE_DEFER) {
+			usb_put_hcd(hcd);
+			return err;
+		} else {
+			dev_err(&pdev->dev, "no usb2 phy configured\n");
+			usb_put_hcd(hcd);
+			return err;
+		}
+	}
+
+	if (!exynos_ohci->phy && !exynos_ohci->phy_g)
+		dev_dbg(&pdev->dev, "Failed to get usb2 phy\n");
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
 
@@ -140,6 +189,11 @@ skip_phy:
 	platform_set_drvdata(pdev, hcd);
 
 	exynos_ohci_phy_enable(pdev);
+	err = exynos_ohci_phyg_on(exynos_ohci->phy_g, true);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable phy\n");
+		goto fail_io;
+	}
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
@@ -151,6 +205,7 @@ skip_phy:
 
 fail_add_hcd:
 	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phyg_on(exynos_ohci->phy_g, false);
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
@@ -169,6 +224,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
 	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phyg_on(exynos_ohci->phy_g, false);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -205,6 +261,7 @@ static int exynos_ohci_suspend(struct device *dev)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
 	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phyg_on(exynos_ohci->phy_g, false);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -218,6 +275,7 @@ static int exynos_ohci_resume(struct device *dev)
 	struct usb_hcd *hcd			= dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
 	struct platform_device *pdev		= to_platform_device(dev);
+	int ret;
 
 	clk_prepare_enable(exynos_ohci->clk);
 
@@ -225,6 +283,11 @@ static int exynos_ohci_resume(struct device *dev)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
 	exynos_ohci_phy_enable(pdev);
+	ret = exynos_ohci_phyg_on(exynos_ohci->phy_g, true);
+	if (ret) {
+		dev_err(dev, "Failed to enable phy\n");
+		return ret;
+	}
 
 	ohci_resume(hcd, false);
 
-- 
1.7.10.4

