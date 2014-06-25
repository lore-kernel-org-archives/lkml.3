Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaFYMoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:44:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44000 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:43:58 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v3 2/2] usb: ohci-exynos: Make provision for vdd regulators
Date: Wed, 25 Jun 2014 18:13:55 +0530
Message-Id: <1403700235-30763-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402064411-18244-2-git-send-email-gautam.vivek@samsung.com>
References: <1402064411-18244-2-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate getting required 3.3V and 1.0V VDD supply for
OHCI controller on Exynos.

With patches for regulators' nodes merged in 3.15:
c8c253f ARM: dts: Add regulator entries to smdk5420
275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
the exynos systems turn on only minimal number of regulators.

Until now, the VDD regulator supplies were either turned on
by the bootloader, or the regulators were enabled by default
in the kernel, so that the controller drivers did not need to
care about turning on these regulators on their own.
This was rather bad about these controller drivers.
So ensuring now that the controller driver requests the necessary
VDD regulators (if available, unless there are direct VDD rails),
and enable them so as to make them working.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---

Changes from v2:
 - replaced devm_regulator_get() with devm_regulator_get_optional().
 - Added Documentation for the vdd supplies for the controller.
 - Re-did the commit message.

 .../devicetree/bindings/usb/exynos-usb.txt         |    4 ++
 drivers/usb/host/ohci-exynos.c                     |   55 +++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index b04b015..3991c50 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -63,6 +63,10 @@ Required properties:
 			      port 2 is HSIC phy1
 	- phys: from the *Generic PHY* bindings, specifying phy used by port.
 
+Optional properties:
+ - vdd33-supply: handle to 3.3V Vdd supply regulator for the controller.
+ - vdd10-supply: handle to 1.0V Vdd supply regulator for the controller.
+
 Example:
 	usb@12120000 {
 		compatible = "samsung,exynos4210-ohci";
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 060a6a4..57c807c 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/regulator/consumer.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
@@ -41,6 +42,8 @@ struct exynos_ohci_hcd {
 	struct usb_phy *phy;
 	struct usb_otg *otg;
 	struct phy *phy_g[PHY_NUMBER];
+	struct regulator *vdd33;
+	struct regulator *vdd10;
 };
 
 static int exynos_ohci_get_phy(struct device *dev,
@@ -172,7 +175,27 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 
 	err = exynos_ohci_get_phy(&pdev->dev, exynos_ohci);
 	if (err)
-		goto fail_clk;
+		goto fail_regulator1;
+
+	exynos_ohci->vdd33 = devm_regulator_get_optional(&pdev->dev, "vdd33");
+	if (!IS_ERR(exynos_ohci->vdd33)) {
+		err = regulator_enable(exynos_ohci->vdd33);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 3.3V Vdd supply\n");
+			goto fail_regulator1;
+		}
+	}
+
+	exynos_ohci->vdd10 = devm_regulator_get_optional(&pdev->dev, "vdd10");
+	if (!IS_ERR(exynos_ohci->vdd10)) {
+		err = regulator_enable(exynos_ohci->vdd10);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 1.0V Vdd supply\n");
+			goto fail_regulator2;
+		}
+	}
 
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
@@ -233,6 +256,10 @@ fail_add_hcd:
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
+	regulator_disable(exynos_ohci->vdd10);
+fail_regulator2:
+	regulator_disable(exynos_ohci->vdd33);
+fail_regulator1:
 	usb_put_hcd(hcd);
 	return err;
 }
@@ -251,6 +278,11 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	if (!IS_ERR(exynos_ohci->vdd33))
+		regulator_disable(exynos_ohci->vdd33);
+	if (!IS_ERR(exynos_ohci->vdd10))
+		regulator_disable(exynos_ohci->vdd10);
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -282,6 +314,11 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	if (!IS_ERR(exynos_ohci->vdd33))
+		regulator_disable(exynos_ohci->vdd33);
+	if (!IS_ERR(exynos_ohci->vdd10))
+		regulator_disable(exynos_ohci->vdd10);
+
 	return 0;
 }
 
@@ -291,6 +328,22 @@ static int exynos_ohci_resume(struct device *dev)
 	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
 	int ret;
 
+	if (!IS_ERR(exynos_ohci->vdd33)) {
+		ret = regulator_enable(exynos_ohci->vdd33);
+		if (ret) {
+			dev_err(dev, "Failed to enable 3.3V Vdd supply\n");
+			return ret;
+		}
+	}
+
+	if (!IS_ERR(exynos_ohci->vdd10)) {
+		ret = regulator_enable(exynos_ohci->vdd10);
+		if (ret) {
+			dev_err(dev, "Failed to enable 1.0V Vdd supply\n");
+			return ret;
+		}
+	}
+
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (exynos_ohci->otg)
-- 
1.7.10.4

