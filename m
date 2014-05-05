Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaEEFCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:02:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61981 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaEEFCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:02:37 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v12 4/4] usb: ehci-exynos: Change to use phy provided by the generic phy framework
Date: Mon,  5 May 2014 10:32:28 +0530
Message-Id: <1399266148-31729-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399034855-9686-5-git-send-email-gautam.vivek@samsung.com>
References: <1399034855-9686-5-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

Add the phy provider, supplied by new Exynos-usb2phy using
Generic phy framework.
Keeping the support for older USB phy intact right now, in order
to prevent any functionality break in absence of relevant
device tree side change for ehci-exynos.
Once we move to new phy in the device nodes for ehci, we can
remove the support for older phys.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
[gautam.vivek@samsung.com: Addressed review comments from mailing list]
[gautam.vivek@samsung.com: Kept the code for old usb-phy, and just
added support for new exynos5-usb2phy in generic phy framework]
[gautam.vivek@samsung.com: Edited the commit message]
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---

Changes from v11:
 - Removed setting phy explicitly to error pointer.
 - Changed error check to '-ENOSYS' instead of '-ENXIO' in failure case of
   devm_of_phy_get().

Changes from v10:
 - Removed 'phy-names' property from the bindings since we don't need it.
 - Restructured exynos_ehci_get_phy() function to handle error codes as
   well as return relevant error codes effectively.
 - Added IS_ERR() check for PHYs in exynos_ehci_phy_enable()/disable().

Changes from v9:
 - Calling usb_phy_shutdown() when exynos_ehci_phy_enable() is failing.
 - Made exynos_ehci_phy_disable() return void, since its return value
   did not serve any purpose.
 - Calling clk_disable_unprepare() in exynos_ehci_resume() when
   exynos_ehci_phy_enable() is failed.

 .../devicetree/bindings/usb/exynos-usb.txt         |   15 +++
 drivers/usb/host/ehci-exynos.c                     |  129 +++++++++++++++++---
 2 files changed, 124 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index 49a9c6f..a3b5990 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -12,6 +12,13 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+ - port: if in the SoC there are EHCI phys, they should be listed here.
+   One phy per port. Each port should have following entries:
+	- reg: port number on EHCI controller, e.g
+	       On Exynos5250, port 0 is USB2.0 otg phy
+			      port 1 is HSIC phy0
+			      port 2 is HSIC phy1
+	- phys: from the *Generic PHY* bindings; specifying phy used by port.
 
 Optional properties:
  - samsung,vbus-gpio:  if present, specifies the GPIO that
@@ -27,6 +34,14 @@ Example:
 
 		clocks = <&clock 285>;
 		clock-names = "usbhost";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+		    reg = <0>;
+		    phys = <&usb2phy 1>;
+		    status = "disabled";
+		};
 	};
 
 OHCI
diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 4d763dc..c7081c7 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
@@ -42,14 +43,104 @@
 static const char hcd_name[] = "ehci-exynos";
 static struct hc_driver __read_mostly exynos_ehci_hc_driver;
 
+#define PHY_NUMBER 3
+
 struct exynos_ehci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct phy *phy_g[PHY_NUMBER];
 };
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
 
+static int exynos_ehci_get_phy(struct device *dev,
+				struct exynos_ehci_hcd *exynos_ehci)
+{
+	struct device_node *child;
+	struct phy *phy;
+	int phy_number;
+	int ret = 0;
+
+	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR(exynos_ehci->phy)) {
+		ret = PTR_ERR(exynos_ehci->phy);
+		if (ret != -ENXIO && ret != -ENODEV) {
+			dev_err(dev, "no usb2 phy configured\n");
+			return ret;
+		}
+		dev_dbg(dev, "Failed to get usb2 phy\n");
+	} else {
+		exynos_ehci->otg = exynos_ehci->phy->otg;
+	}
+
+	for_each_available_child_of_node(dev->of_node, child) {
+		ret = of_property_read_u32(child, "reg", &phy_number);
+		if (ret) {
+			dev_err(dev, "Failed to parse device tree\n");
+			of_node_put(child);
+			return ret;
+		}
+
+		if (phy_number >= PHY_NUMBER) {
+			dev_err(dev, "Invalid number of PHYs\n");
+			of_node_put(child);
+			return -EINVAL;
+		}
+
+		phy = devm_of_phy_get(dev, child, 0);
+		of_node_put(child);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			if (ret != -ENOSYS && ret != -ENODEV) {
+				dev_err(dev, "no usb2 phy configured\n");
+				return ret;
+			}
+			dev_dbg(dev, "Failed to get usb2 phy\n");
+		}
+		exynos_ehci->phy_g[phy_number] = phy;
+	}
+
+	return ret;
+}
+
+static int exynos_ehci_phy_enable(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
+	int i;
+	int ret = 0;
+
+	if (!IS_ERR(exynos_ehci->phy))
+		return usb_phy_init(exynos_ehci->phy);
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (!IS_ERR(exynos_ehci->phy_g[i]))
+			ret = phy_power_on(exynos_ehci->phy_g[i]);
+	if (ret)
+		for (i--; i >= 0; i--)
+			if (!IS_ERR(exynos_ehci->phy_g[i]))
+				phy_power_off(exynos_ehci->phy_g[i]);
+
+	return ret;
+}
+
+static void exynos_ehci_phy_disable(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
+	int i;
+
+	if (!IS_ERR(exynos_ehci->phy)) {
+		usb_phy_shutdown(exynos_ehci->phy);
+		return;
+	}
+
+	for (i = 0; i < PHY_NUMBER; i++)
+		if (!IS_ERR(exynos_ehci->phy_g[i]))
+			phy_power_off(exynos_ehci->phy_g[i]);
+}
+
 static void exynos_setup_vbus_gpio(struct device *dev)
 {
 	int err;
@@ -74,7 +165,6 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
-	struct usb_phy *phy;
 	int irq;
 	int err;
 
@@ -101,15 +191,9 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 					"samsung,exynos5440-ehci"))
 		goto skip_phy;
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(phy)) {
-		usb_put_hcd(hcd);
-		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
-		return -EPROBE_DEFER;
-	} else {
-		exynos_ehci->phy = phy;
-		exynos_ehci->otg = phy->otg;
-	}
+	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
+	if (err)
+		goto fail_clk;
 
 skip_phy:
 
@@ -151,8 +235,11 @@ skip_phy:
 	if (exynos_ehci->otg)
 		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
 
-	if (exynos_ehci->phy)
-		usb_phy_init(exynos_ehci->phy);
+	err = exynos_ehci_phy_enable(&pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable USB phy\n");
+		goto fail_io;
+	}
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -172,8 +259,7 @@ skip_phy:
 	return 0;
 
 fail_add_hcd:
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_ehci_phy_disable(&pdev->dev);
 fail_io:
 	clk_disable_unprepare(exynos_ehci->clk);
 fail_clk:
@@ -191,8 +277,7 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 	if (exynos_ehci->otg)
 		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
 
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_ehci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -217,8 +302,7 @@ static int exynos_ehci_suspend(struct device *dev)
 	if (exynos_ehci->otg)
 		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
 
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_ehci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -229,14 +313,19 @@ static int exynos_ehci_resume(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
+	int ret;
 
 	clk_prepare_enable(exynos_ehci->clk);
 
 	if (exynos_ehci->otg)
 		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
 
-	if (exynos_ehci->phy)
-		usb_phy_init(exynos_ehci->phy);
+	ret = exynos_ehci_phy_enable(dev);
+	if (ret) {
+		dev_err(dev, "Failed to enable USB phy\n");
+		clk_disable_unprepare(exynos_ehci->clk);
+		return ret;
+	}
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
-- 
1.7.10.4

