Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaDYLV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:21:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59115 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDYLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:21:23 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        kgene.kim@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: [PATCH v8 2/2] usb: ehci-exynos: Change to use phy provided by the generic phy framework
Date: Fri, 25 Apr 2014 16:51:13 +0530
Message-Id: <1398424873-20257-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
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
---

Changes from v7:
just edited in the commit message: s/ohci/ehci

Although the patch-series is named as 'v2' version, but
this patch is named as 'v7' since it is the next version of the patch
sent by Kamil:
[PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by the generic phy framework
https://lkml.org/lkml/2014/1/29/298

Changes from v6:
 - Added documentation for 'port' property including all its fields -
      reg, phys, phy-names.
 - Fixed looping in 'exynos_phys_on()' and renamed this function as
      exynos_ehci_phyg_on()
 - To avoid any regression because of movement from old usb-phy drivers
   to new generic phy framework, keeping the changes for old usb-phy driver
   intact, and just added support for phy provider from generic phy framework.
 - Separated out the phy-get related code from probe() to separate function
   exynos_ehci_get_phy().

 .../devicetree/bindings/usb/exynos-usb.txt         |   18 +++
 drivers/usb/host/ehci-exynos.c                     |  123 ++++++++++++++++++--
 2 files changed, 131 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index 03b7e43..4f368b0 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -12,6 +12,15 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+ - port: if in the SoC there are EHCI phys, they should be listed here.
+   One phy per port. Each port should have its 'reg' entry.
+	- reg: port number on EHCI controller, e.g
+	       On Exynos5250, port 0 is USB2.0 otg phy
+			      port 1 is HSIC phy0
+			      port 2 is HSIC phy1
+	- phys: from the *Generic PHY* bindings; specifying phy used by port.
+	- phy-names: from the *Generic PHY* bindings; specifying name of phy
+		     used by the port.
 
 Optional properties:
  - samsung,vbus-gpio:  if present, specifies the GPIO that
@@ -27,6 +36,15 @@ Example:
 
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
 	};
 
 OHCI
diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 7f425ac..fe0509b 100644
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
@@ -42,14 +43,78 @@
 static const char hcd_name[] = "ehci-exynos";
 static struct hc_driver __read_mostly exynos_ehci_hc_driver;
 
+#define PHY_NUMBER 3
 struct exynos_ehci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct phy *phy_g[PHY_NUMBER];
 };
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
 
+static int exynos_ehci_get_phy(struct platform_device *pdev,
+				struct exynos_ehci_hcd *exynos_ehci)
+{
+	struct device_node *child;
+	struct phy *phy;
+	int phy_number;
+	int ret = 0;
+
+	exynos_ehci->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR(exynos_ehci->phy)) {
+		ret = PTR_ERR(exynos_ehci->phy);
+		/* This is the case when PHY config is disabled */
+		if (ret == -ENXIO || ret == -ENODEV) {
+			dev_dbg(&pdev->dev, "Failed to get usb2 phy\n");
+			exynos_ehci->phy = NULL;
+			ret = 0;
+		} else if (ret == -EPROBE_DEFER) {
+			goto fail_phy;
+		} else {
+			dev_err(&pdev->dev, "no usb2 phy configured\n");
+			goto fail_phy;
+		}
+	} else {
+		exynos_ehci->otg = exynos_ehci->phy->otg;
+	}
+
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
+		exynos_ehci->phy_g[phy_number] = phy;
+	}
+
+fail_phy:
+	return ret;
+}
+
 static void exynos_setup_vbus_gpio(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -69,13 +134,40 @@ static void exynos_setup_vbus_gpio(struct platform_device *pdev)
 		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
 }
 
+static int exynos_ehci_phyg_on(struct phy *phy[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (phy[i])
+			ret = phy_power_on(phy[i]);
+	if (ret)
+		for (i--; i > 0; i--)
+			if (phy[i])
+				phy_power_off(phy[i]);
+
+	return ret;
+}
+
+static int exynos_ehci_phyg_off(struct phy *phy[])
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
 static int exynos_ehci_probe(struct platform_device *pdev)
 {
 	struct exynos_ehci_hcd *exynos_ehci;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
-	struct usb_phy *phy;
 	int irq;
 	int err;
 
@@ -102,15 +194,9 @@ static int exynos_ehci_probe(struct platform_device *pdev)
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
+	err = exynos_ehci_get_phy(pdev, exynos_ehci);
+	if (err)
+		goto fail_clk;
 
 skip_phy:
 
@@ -155,6 +241,14 @@ skip_phy:
 	if (exynos_ehci->phy)
 		usb_phy_init(exynos_ehci->phy);
 
+	if (exynos_ehci->phy_g) {
+		err = exynos_ehci_phyg_on(exynos_ehci->phy_g);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to enable phys\n");
+			goto fail_io;
+		}
+	}
+
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
 
@@ -175,6 +269,7 @@ skip_phy:
 fail_add_hcd:
 	if (exynos_ehci->phy)
 		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_ehci_phyg_off(exynos_ehci->phy_g);
 fail_io:
 	clk_disable_unprepare(exynos_ehci->clk);
 fail_clk:
@@ -195,6 +290,8 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 	if (exynos_ehci->phy)
 		usb_phy_shutdown(exynos_ehci->phy);
 
+	exynos_ehci_phyg_off(exynos_ehci->phy_g);
+
 	clk_disable_unprepare(exynos_ehci->clk);
 
 	usb_put_hcd(hcd);
@@ -221,6 +318,9 @@ static int exynos_ehci_suspend(struct device *dev)
 	if (exynos_ehci->phy)
 		usb_phy_shutdown(exynos_ehci->phy);
 
+	if (exynos_ehci->phy_g)
+		exynos_ehci_phyg_off(exynos_ehci->phy_g);
+
 	clk_disable_unprepare(exynos_ehci->clk);
 
 	return rc;
@@ -239,6 +339,9 @@ static int exynos_ehci_resume(struct device *dev)
 	if (exynos_ehci->phy)
 		usb_phy_init(exynos_ehci->phy);
 
+	if (exynos_ehci->phy_g)
+		exynos_ehci_phyg_on(exynos_ehci->phy_g);
+
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
 
-- 
1.7.10.4

