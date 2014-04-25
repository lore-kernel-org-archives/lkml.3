Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaDYLS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:18:27 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44985 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaDYLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:18:18 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        kgene.kim@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: [PATCH v2 1/2] usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
Date: Fri, 25 Apr 2014 16:48:02 +0530
Message-Id: <1398424683-20168-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398424683-20168-1-git-send-email-gautam.vivek@samsung.com>
References: <1398424683-20168-1-git-send-email-gautam.vivek@samsung.com>
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

Changes from v1:
 - Made two separate routines for exynos_ohci_phyg_on() and
   exynos_ohci_phyg_off().
 - Separated out the phy-get related code from probe() to separate function
   exynos_ehci_get_phy().
 - Using proper error labels in the code.

 .../devicetree/bindings/usb/exynos-usb.txt         |   19 +++
 drivers/usb/host/ohci-exynos.c                     |  123 ++++++++++++++++++--
 2 files changed, 132 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index d967ba1..03b7e43 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -38,6 +38,15 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+ - port: if in the SoC there are OHCI phys, they should be listed here.
+   One phy per port. Each port should have its 'reg' entry.
+	- reg: port number on OHCI controller, e.g
+	       On Exynos5250, port 0 is USB2.0 otg phy
+			      port 1 is HSIC phy0
+			      port 2 is HSIC phy1
+	- phys: from the *Generic PHY* bindings specifying phy used by port.
+	- phy-names: from the *Generic PHY* bindings specifying name of phy
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
index 68588d8..eac47cb 100644
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
@@ -33,12 +34,111 @@ static struct hc_driver __read_mostly exynos_ohci_hc_driver;
 
 #define to_exynos_ohci(hcd) (struct exynos_ohci_hcd *)(hcd_to_ohci(hcd)->priv)
 
+#define PHY_NUMBER 3
 struct exynos_ohci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct phy *phy_g[PHY_NUMBER];
 };
 
+static int exynos_ohci_get_phy(struct platform_device *pdev,
+				struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct device_node *child;
+	struct phy *phy;
+	int phy_number;
+	int ret = 0;
+
+	exynos_ohci->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR(exynos_ohci->phy)) {
+		ret = PTR_ERR(exynos_ohci->phy);
+		/* This is the case when PHY config is disabled */
+		if (ret == -ENXIO || ret == -ENODEV) {
+			dev_dbg(&pdev->dev, "Failed to get usb2 phy\n");
+			exynos_ohci->phy = NULL;
+			ret = 0;
+		} else if (ret == -EPROBE_DEFER) {
+			goto fail_phy;
+		} else {
+			dev_err(&pdev->dev, "no usb2 phy configured\n");
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
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		ret = of_property_read_u32(child, "reg", &phy_number);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to parse device tree\n");
+			of_node_put(child);
+			goto fail_phy;
+		}
+		if (phy_number >= PHY_NUMBER) {
+			dev_err(&pdev->dev, "Invalid number of PHYs\n");
+			of_node_put(child);
+			ret = -EINVAL;
+			goto fail_phy;
+		}
+		phy = devm_of_phy_get(&pdev->dev, child, 0);
+		of_node_put(child);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			/* This is the case when PHY config is disabled */
+			if (ret == -ENOSYS || ret == -ENODEV) {
+				dev_dbg(&pdev->dev, "Failed to get usb2 phy\n");
+				phy = NULL;
+				ret = 0;
+			} else if (ret == -EPROBE_DEFER) {
+				goto fail_phy;
+			} else {
+				dev_err(&pdev->dev, "no usb2 phy configured\n");
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
+static int exynos_ohci_phyg_on(struct phy *phy[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (phy[i])
+			ret = phy_power_on(phy[i]);
+	if (ret)
+		for (i--; i >= 0; i--)
+			if (phy[i])
+				phy_power_off(phy[i]);
+
+	return ret;
+}
+
+static int exynos_ohci_phyg_off(struct phy *phy[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (phy[i])
+			ret = phy_power_off(phy[i]);
+
+	return ret;
+}
+
 static void exynos_ohci_phy_enable(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
@@ -46,6 +146,11 @@ static void exynos_ohci_phy_enable(struct platform_device *pdev)
 
 	if (exynos_ohci->phy)
 		usb_phy_init(exynos_ohci->phy);
+
+	if (exynos_ohci->phy_g)
+		if (exynos_ohci_phyg_on(exynos_ohci->phy_g))
+			dev_warn(&pdev->dev, "Failed to enable phy\n");
+
 }
 
 static void exynos_ohci_phy_disable(struct platform_device *pdev)
@@ -55,6 +160,10 @@ static void exynos_ohci_phy_disable(struct platform_device *pdev)
 
 	if (exynos_ohci->phy)
 		usb_phy_shutdown(exynos_ohci->phy);
+
+	if (exynos_ohci->phy_g)
+		if (exynos_ohci_phyg_off(exynos_ohci->phy_g))
+			dev_warn(&pdev->dev, "Failed to enable phy\n");
 }
 
 static int exynos_ohci_probe(struct platform_device *pdev)
@@ -62,7 +171,6 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct resource *res;
-	struct usb_phy *phy;
 	int irq;
 	int err;
 
@@ -88,15 +196,9 @@ static int exynos_ohci_probe(struct platform_device *pdev)
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
+	err = exynos_ohci_get_phy(pdev, exynos_ohci);
+	if (err)
+		goto fail_clk;
 
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
@@ -151,6 +253,7 @@ skip_phy:
 
 fail_add_hcd:
 	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phyg_off(exynos_ohci->phy_g);
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
-- 
1.7.10.4

