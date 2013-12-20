Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3LTNZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:25:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29341 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LTNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:24:59 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-cd-52b44529c565
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
Subject: [PATCH v5 4/9] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
Date: Fri, 20 Dec 2013 14:24:10 +0100
Message-id: <1387545857-9472-5-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV1N1y1BBv1vrC2W7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0Bii2aw6bxYzz+5gsFi1rZbZYe+Quu8XZ
	/ttsFhObprFbnN/SyWRx+E07q8WE30Bt62e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l97hz
	bQ+bx79j7B6z7/5g9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGW0909jKVhlVnH3
	jFwD4ymtLkZODgkBE4kZ15YxQ9hiEhfurWfrYuTiEBKYzijR/GwKlNPBJHH8xX7GLkYODjYB
	TYlV9zxAGkQEaiSm3LrCDlLDLNDFLDFh22k2kISwQILEjTnf2EFsFgFViRs7l4Bt4BVwlri6
	8QszyBwJAQWJOZNsQMKcAi4SMxcvAmsVAir5ffYR6wRG3gWMDKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxggP+mdQOxpUNFocYBTgYlXh4G2w3BwmxJpYVV+YeYpTgYFYS4e3X3hIkxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgbFttijHG+nS8qDC
	Y2vdXhYJPeYQ0hKQYGudlOQtJ7Hf5skttf+1Kyy9869mHc31rxNYv/D2vcfCD7vZJL3lTrot
	XRLpwWt38aGrxLIpV784h018wvfg8xZ56RWtxitN1WtD5z9Vj8tPFXzvtPWJa4P6PfHT0Wm8
	M36lOEzcodzp5p+U3jFtmhJLcUaioRZzUXEiAEmGEOF0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the phy provider used from the old one using the USB phy
framework to a new one using the Generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 +++++++
 drivers/usb/host/ehci-exynos.c                     |   97 +++++++++++++-------
 2 files changed, 98 insertions(+), 34 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-ehci.txt b/Documentation/devicetree/bindings/usb/usb-ehci.txt
index fa18612..413f7cd 100644
--- a/Documentation/devicetree/bindings/usb/usb-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-ehci.txt
@@ -14,6 +14,10 @@ If controller implementation operates with big endian descriptors,
 If both big endian registers and descriptors are used by the controller
 implementation, "big-endian" property can be specified instead of having
 both "big-endian-regs" and "big-endian-desc".
+  - port: if in the SoC there are EHCI phys, they should be listed here.
+One phy per port. Each port should have its reg entry with a consecutive
+number. Also it should contain phys and phy-names entries specifying the
+phy used by the port.
 
 Example (Sequoia 440EPx):
     ehci@e0000300 {
@@ -23,3 +27,34 @@ Example (Sequoia 440EPx):
 	   reg = <0 e0000300 90 0 e0000390 70>;
 	   big-endian;
    };
+
+Example (Exynos 4212):
+    ehci@12580000 {
+        compatible = "samsung,exynos4210-ehci";
+        reg = <0x12580000 0x20000>;
+        interrupts = <0 70 0>;
+        clocks = <&clock 304>, <&clock 305>;
+        clock-names = "usbhost", "otg";
+        status = "disabled";
+        #address-cells = <1>;
+        #size-cells = <0>;
+        port@0 {
+            reg = <0>;
+            phys = <&usb2phy 1>;
+            phy-names = "host";
+            status = "disabled";
+        };
+        port@1 {
+            reg = <1>;
+            phys = <&usb2phy 2>;
+            phy-names = "hsic0";
+            status = "disabled";
+        };
+        port@2 {
+            reg = <2>;
+            phys = <&usb2phy 3>;
+            phy-names = "hsic1";
+            status = "disabled";
+        };
+    };
+
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

