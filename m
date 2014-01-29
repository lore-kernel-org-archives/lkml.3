Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaA2Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:31:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33433 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaA2Rao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:30:44 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-ce-52e93ac2a932
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by the
 generic phy framework
Date: Wed, 29 Jan 2014 18:29:34 +0100
Message-id: <1391016574-25237-9-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
References: <1391016574-25237-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd1DVi+DDO7M1rdYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBYTfgO1rZ/xmsWibfUHVouOswfZHUQ8Lvf1MnnsnHWX3ePO
	tT1sHv+OsXvMvvuD0aNvyypGj+M3tjN5fN4kF8ARxWWTkpqTWZZapG+XwJXx+ehkxoIlBhVv
	7n9ha2D8r9bFyMkhIWAicafjNQuELSZx4d56ti5GLg4hgUWMEhM+7WeGcDqYJG4uaWLtYuTg
	YBPQlFh1zwOkQUSgRmLKrSvsIDXMAl3MEhO2nWYDSQgLJEv8Xv0dbCqLgKrEgblnwOK8Ai4S
	jTOOgc2REFCQmDPJBiTMKeAq0THjIliJEFDJ6p41bBMYeRcwMqxiFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECA75Z1I7GFc2WBxiFOBgVOLhXXHxeZAQa2JZcWXuIUYJDmYlEd4ow5dBQrwp
	iZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhi5I04pPXk40edn
	jPeBPG/nS99/2/IuSmP6cVWz99esyzMmm/W/qbepSz8a0VP5ZcKi6zKMp2QFd112m7R2Q3K0
	Pft+hZQInonBn/f53P0ZGutvIHZn88m4xlKnaU83Sdven5X70XvSw61q3PvP7lilJROjK7Gm
	N00m2vLUCq2I5UrL9uUv99iixFKckWioxVxUnAgAqZuhAXUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the phy provider used from the old one using the USB phy
framework to a new one using the Generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   13 +++
 drivers/usb/host/ehci-exynos.c                     |   97 +++++++++++++-------
 2 files changed, 76 insertions(+), 34 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index d967ba1..25e199a 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -12,6 +12,10 @@ Required properties:
  - interrupts: interrupt number to the cpu.
  - clocks: from common clock binding: handle to usb clock.
  - clock-names: from common clock binding: Shall be "usbhost".
+  - port: if in the SoC there are EHCI phys, they should be listed here.
+One phy per port. Each port should have its reg entry with a consecutive
+number. Also it should contain phys and phy-names entries specifying the
+phy used by the port.
 
 Optional properties:
  - samsung,vbus-gpio:  if present, specifies the GPIO that
@@ -27,6 +31,15 @@ Example:
 
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
index d1d8c47..7c35501 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -19,12 +19,12 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <linux/usb/otg.h>
 
 #include "ehci.h"
 
@@ -42,10 +42,10 @@
 static const char hcd_name[] = "ehci-exynos";
 static struct hc_driver __read_mostly exynos_ehci_hc_driver;
 
+#define PHY_NUMBER 3
 struct exynos_ehci_hcd {
 	struct clk *clk;
-	struct usb_phy *phy;
-	struct usb_otg *otg;
+	struct phy *phy[PHY_NUMBER];
 };
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
@@ -69,13 +69,43 @@ static void exynos_setup_vbus_gpio(struct platform_device *pdev)
 		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
 }
 
+static int exynos_phys_on(struct phy *p[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (p[i])
+			ret = phy_power_on(p[i]);
+	if (ret)
+		for (i--; i > 0; i--)
+			if (p[i])
+				phy_power_off(p[i]);
+
+	return ret;
+}
+
+static int exynos_phys_off(struct phy *p[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
+		if (p[i])
+			ret = phy_power_off(p[i]);
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
+	struct phy *phy;
+	struct device_node *child;
+	int phy_number;
 	int irq;
 	int err;
 
@@ -102,14 +132,26 @@ static int exynos_ehci_probe(struct platform_device *pdev)
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
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		err = of_property_read_u32(child, "reg", &phy_number);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to parse device tree\n");
+			of_node_put(child);
+			return err;
+		}
+		if (phy_number >= PHY_NUMBER) {
+			dev_err(&pdev->dev, "Failed to parse device tree - number out of range\n");
+			of_node_put(child);
+			return -EINVAL;
+		}
+		phy = devm_of_phy_get(&pdev->dev, child, 0);
+		of_node_put(child);
+		if (IS_ERR(phy)) {
+			dev_err(&pdev->dev, "Failed to get phy number %d",
+								phy_number);
+			return PTR_ERR(phy);
+		}
+		exynos_ehci->phy[phy_number] = phy;
 	}
 
 skip_phy:
@@ -149,11 +191,11 @@ skip_phy:
 		goto fail_io;
 	}
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_init(exynos_ehci->phy);
+	err = exynos_phys_on(exynos_ehci->phy);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enabled phys\n");
+		goto fail_io;
+	}
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -173,8 +215,7 @@ skip_phy:
 	return 0;
 
 fail_add_hcd:
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
 fail_io:
 	clk_disable_unprepare(exynos_ehci->clk);
 fail_clk:
@@ -189,11 +230,7 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -213,11 +250,7 @@ static int exynos_ehci_suspend(struct device *dev)
 
 	rc = ehci_suspend(hcd, do_wakeup);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -231,11 +264,7 @@ static int exynos_ehci_resume(struct device *dev)
 
 	clk_prepare_enable(exynos_ehci->clk);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_init(exynos_ehci->phy);
+	exynos_phys_on(exynos_ehci->phy);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
-- 
1.7.9.5

