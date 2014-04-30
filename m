Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbaD3FUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:20:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60047 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaD3FUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:20:16 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v4 3/4] usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
Date: Wed, 30 Apr 2014 10:49:51 +0530
Message-Id: <1398835192-21634-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398835192-21634-1-git-send-email-gautam.vivek@samsung.com>
References: <1398835192-21634-1-git-send-email-gautam.vivek@samsung.com>
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

Changes from v3:
 - Calling usb_phy_shutdown() when exynos_ohci_phy_enable() is failing.
 - Made exynos_ohci_phy_disable() return void, since its return value
   did not serve any purpose.
 - Calling clk_disable_unprepare() in exynos_ohci_resume() when
   exynos_ohci_phy_enable() is failed.

 .../devicetree/bindings/usb/exynos-usb.txt         |   19 +++
 drivers/usb/host/ohci-exynos.c                     |  128 +++++++++++++++++---
 2 files changed, 132 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index d967ba1..a90c973 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -38,6 +38,15 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+ - port: if in the SoC there are OHCI phys, they should be listed here.
+   One phy per port. Each port should have following entries:
+	- reg: port number on OHCI controller, e.g
+	       On Exynos5250, port 0 is USB2.0 otg phy
+			      port 1 is HSIC phy0
+			      port 2 is HSIC phy1
+	- phys: from the *Generic PHY* bindings, specifying phy used by port.
+	- phy-names: from the *Generic PHY* bindings, specifying name of phy
+		     used by the port.
 
 Example:
 	usb@12120000 {
@@ -47,6 +56,16 @@ Example:
 
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
index 05f00e3..f90bf9a 100644
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
@@ -33,28 +34,122 @@ static struct hc_driver __read_mostly exynos_ohci_hc_driver;
 
 #define to_exynos_ohci(hcd) (struct exynos_ohci_hcd *)(hcd_to_ohci(hcd)->priv)
 
+#define PHY_NUMBER 3
 struct exynos_ohci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct phy *phy_g[PHY_NUMBER];
 };
 
-static void exynos_ohci_phy_enable(struct device *dev)
+static int exynos_ohci_get_phy(struct device *dev,
+				struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct device_node *child;
+	struct phy *phy;
+	int phy_number;
+	int ret = 0;
+
+	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR(exynos_ohci->phy)) {
+		ret = PTR_ERR(exynos_ohci->phy);
+		/* This is the case when PHY config is disabled */
+		if (ret == -ENXIO || ret == -ENODEV) {
+			dev_dbg(dev, "Failed to get usb2 phy\n");
+			exynos_ohci->phy = NULL;
+			ret = 0;
+		} else if (ret == -EPROBE_DEFER) {
+			goto fail_phy;
+		} else {
+			dev_err(dev, "no usb2 phy configured\n");
+			goto fail_phy;
+		}
+	} else {
+		exynos_ohci->otg = exynos_ohci->phy->otg;
+	}
+
+	/* Getting generic phy:
+	 * We are keeping both types of phys as a part of transiting OHCI
+	 * to generic phy framework, so that in absence of supporting dts
+	 * changes the functionality doesn't break.
+	 * Once we move the ohci dt nodes to use new generic phys,
+	 * we can remove support for older PHY in this driver.
+	 */
+	for_each_available_child_of_node(dev->of_node, child) {
+		ret = of_property_read_u32(child, "reg", &phy_number);
+		if (ret) {
+			dev_err(dev, "Failed to parse device tree\n");
+			of_node_put(child);
+			goto fail_phy;
+		}
+		if (phy_number >= PHY_NUMBER) {
+			dev_err(dev, "Invalid number of PHYs\n");
+			of_node_put(child);
+			ret = -EINVAL;
+			goto fail_phy;
+		}
+		phy = devm_of_phy_get(dev, child, 0);
+		of_node_put(child);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			/* This is the case when PHY config is disabled */
+			if (ret == -ENOSYS || ret == -ENODEV) {
+				dev_dbg(dev, "Failed to get usb2 phy\n");
+				phy = NULL;
+				ret = 0;
+			} else if (ret == -EPROBE_DEFER) {
+				goto fail_phy;
+			} else {
+				dev_err(dev, "no usb2 phy configured\n");
+				goto fail_phy;
+			}
+		}
+		exynos_ohci->phy_g[phy_number] = phy;
+	}
+
+fail_phy:
+	return ret;
+}
+
+static int exynos_ohci_phy_enable(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
+	int i;
+	int ret = 0;
 
-	if (exynos_ohci->phy)
-		usb_phy_init(exynos_ohci->phy);
+	if (exynos_ohci->phy) {
+		ret = usb_phy_init(exynos_ohci->phy);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (exynos_ohci->phy_g[i])
+			ret = phy_power_on(exynos_ohci->phy_g[i]);
+	if (ret) {
+		for (i--; i >= 0; i--)
+			if (exynos_ohci->phy_g[i])
+				phy_power_off(exynos_ohci->phy_g[i]);
+		if (exynos_ohci->phy)
+			usb_phy_shutdown(exynos_ohci->phy);
+	}
+
+	return ret;
 }
 
 static void exynos_ohci_phy_disable(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
+	int i;
 
 	if (exynos_ohci->phy)
 		usb_phy_shutdown(exynos_ohci->phy);
+
+	for (i = 0; i < PHY_NUMBER; i++)
+		if (exynos_ohci->phy_g[i])
+			phy_power_off(exynos_ohci->phy_g[i]);
 }
 
 static int exynos_ohci_probe(struct platform_device *pdev)
@@ -62,7 +157,6 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct resource *res;
-	struct usb_phy *phy;
 	int irq;
 	int err;
 
@@ -88,15 +182,9 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 					"samsung,exynos5440-ohci"))
 		goto skip_phy;
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(phy)) {
-		usb_put_hcd(hcd);
-		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
-		return -EPROBE_DEFER;
-	} else {
-		exynos_ohci->phy = phy;
-		exynos_ohci->otg = phy->otg;
-	}
+	err = exynos_ohci_get_phy(&pdev->dev, exynos_ohci);
+	if (err)
+		goto fail_clk;
 
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
@@ -139,7 +227,11 @@ skip_phy:
 
 	platform_set_drvdata(pdev, hcd);
 
-	exynos_ohci_phy_enable(&pdev->dev);
+	err = exynos_ohci_phy_enable(&pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable USB phy\n");
+		goto fail_io;
+	}
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
@@ -210,13 +302,19 @@ static int exynos_ohci_resume(struct device *dev)
 {
 	struct usb_hcd *hcd			= dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
+	int ret;
 
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
-	exynos_ohci_phy_enable(dev);
+	ret = exynos_ohci_phy_enable(dev);
+	if (ret) {
+		dev_err(dev, "Failed to enable USB phy\n");
+		clk_disable_unprepare(exynos_ohci->clk);
+		return ret;
+	}
 
 	ohci_resume(hcd, false);
 
-- 
1.7.10.4

