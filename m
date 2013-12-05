Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3LEMbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:31:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51174 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab3LEMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:30:23 -0500
X-AuditID: cbfee61a-b7f796d000004313-7d-52a071dd3570
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v4 4/9] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
Date: Thu, 05 Dec 2013 13:29:34 +0100
Message-id: <1386246579-25141-5-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd27hQuCDM5ctLBYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG6DYrjlsFjPO72OyWLSsldli7ZG77BZn
	+2+zWUxsmsZucX5LJ5PF4TftrBbrZ7xmseg4e5DdQcjjcl8vk8fOWXfZPe5c28Pm0bdlFaPH
	8RvbmTw+b5ILYIvisklJzcksSy3St0vgymiexV/w2bTi2OnHTA2MC7S6GDk5JARMJD5uX8YI
	YYtJXLi3nq2LkYtDSGA6o8TBZ6dZIJwOJonGVW9Zuxg5ONgENCVW3fMAaRARqJGYcusKO4jN
	LHCXSWL1RrChwgIJEnvWN4DFWQRUJRbMfQpm8wq4SOzs3cwGMkZCQEFiziQbkDCngKvEyomH
	wcJCQCVrrmhOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4jJ9J7WBc2WBxiFGA
	g1GJh/dF4vwgIdbEsuLK3EOMEhzMSiK8wjkLgoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwTq94uZPD9KHGlQ+9yWLXlrpF+fwsrtPiftHI0/Njb57q
	sR1THyx/9zdbO+TeP08t73TG+ZPPv75i3K+ZGeTm5+IoO+nGnuay2XLHLdrk6rKeHbR9ZWpe
	c1hIKOT+ssqUSzlJD+IFn3o8Wci0n89sv66Gdv7qx4eZVuc4dK3I3H2+3zjnnfV3JZbijERD
	Leai4kQA8JngW18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the phy provider used from the old usb phy specific to a new one
using the generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 ++++++++
 drivers/usb/host/ehci-exynos.c                     |   95 +++++++++++++-------
 2 files changed, 97 insertions(+), 33 deletions(-)

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
index e97c198..bb81809 100644
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
 
@@ -102,13 +132,24 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 					"samsung,exynos5440-ehci"))
 		goto skip_phy;
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(phy)) {
-		usb_put_hcd(hcd);
-		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
-		return -EPROBE_DEFER;
-	} else {
-		exynos_ehci->phy = phy;
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		err = of_property_read_u32(child, "reg", &phy_number);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to parse device tree\n");
+			return err;
+		}
+		if (phy_number >= PHY_NUMBER) {
+			dev_err(&pdev->dev, "Failed to parse device tree - number out of range\n");
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
 		exynos_ehci->otg = phy->otg;
 	}
 
@@ -149,11 +190,11 @@ skip_phy:
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
+		goto fail_phys_on;
+	}
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -172,8 +213,8 @@ skip_phy:
 	return 0;
 
 fail_add_hcd:
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
+fail_phys_on:
 fail_io:
 	clk_disable_unprepare(exynos_ehci->clk);
 fail_clk:
@@ -188,11 +229,7 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -212,11 +249,7 @@ static int exynos_ehci_suspend(struct device *dev)
 
 	rc = ehci_suspend(hcd, do_wakeup);
 
-	if (exynos_ehci->otg)
-		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
-
-	if (exynos_ehci->phy)
-		usb_phy_shutdown(exynos_ehci->phy);
+	exynos_phys_off(exynos_ehci->phy);
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
@@ -230,11 +263,7 @@ static int exynos_ehci_resume(struct device *dev)
 
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

