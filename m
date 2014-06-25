Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaFYMmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:42:39 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55290 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFYMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:42:36 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v3 1/2] usb: ehci-exynos: Make provision for vdd regulators
Date: Wed, 25 Jun 2014 18:12:24 +0530
Message-Id: <1403700144-30720-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAFp+6iF9GkKWDcqZNV58Z=U3ZDQdgYr8LJBF9t-BpJW90vsHdQ@mail.gmail.com>
References: <CAFp+6iF9GkKWDcqZNV58Z=U3ZDQdgYr8LJBF9t-BpJW90vsHdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate getting required 3.3V and 1.0V VDD supply for
EHCI controller on Exynos.

With the patches for regulators' nodes merged in 3.15:
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

 .../devicetree/bindings/usb/exynos-usb.txt         |    2 +
 drivers/usb/host/ehci-exynos.c                     |   55 +++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index a3b5990..b04b015 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -23,6 +23,8 @@ Required properties:
 Optional properties:
  - samsung,vbus-gpio:  if present, specifies the GPIO that
    needs to be pulled up for the bus to be powered.
+ - vdd33-supply: handle to 3.3V Vdd supply regulator for the controller.
+ - vdd10-supply: handle to 1.0V Vdd supply regulator for the controller.
 
 Example:
 
diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index d1c7621..b920642 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -21,6 +21,7 @@
 #include <linux/of_gpio.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
@@ -50,6 +51,8 @@ struct exynos_ehci_hcd {
 	struct usb_phy *phy;
 	struct usb_otg *otg;
 	struct phy *phy_g[PHY_NUMBER];
+	struct regulator *vdd33;
+	struct regulator *vdd10;
 };
 
 #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
@@ -193,7 +196,27 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 
 	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
 	if (err)
-		goto fail_clk;
+		goto fail_regulator1;
+
+	exynos_ehci->vdd33 = devm_regulator_get_optional(&pdev->dev, "vdd33");
+	if (!IS_ERR(exynos_ehci->vdd33)) {
+		err = regulator_enable(exynos_ehci->vdd33);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 3.3V Vdd supply\n");
+			goto fail_regulator1;
+		}
+	}
+
+	exynos_ehci->vdd10 = devm_regulator_get_optional(&pdev->dev, "vdd10");
+	if (!IS_ERR(exynos_ehci->vdd10)) {
+		err = regulator_enable(exynos_ehci->vdd10);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 1.0V Vdd supply\n");
+			goto fail_regulator2;
+		}
+	}
 
 skip_phy:
 
@@ -262,6 +285,10 @@ fail_add_hcd:
 fail_io:
 	clk_disable_unprepare(exynos_ehci->clk);
 fail_clk:
+	regulator_disable(exynos_ehci->vdd10);
+fail_regulator2:
+	regulator_disable(exynos_ehci->vdd33);
+fail_regulator1:
 	usb_put_hcd(hcd);
 	return err;
 }
@@ -280,6 +307,11 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
+	if (!IS_ERR(exynos_ehci->vdd33))
+		regulator_disable(exynos_ehci->vdd33);
+	if (!IS_ERR(exynos_ehci->vdd10))
+		regulator_disable(exynos_ehci->vdd10);
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -305,6 +337,11 @@ static int exynos_ehci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
+	if (!IS_ERR(exynos_ehci->vdd33))
+		regulator_disable(exynos_ehci->vdd33);
+	if (!IS_ERR(exynos_ehci->vdd10))
+		regulator_disable(exynos_ehci->vdd10);
+
 	return rc;
 }
 
@@ -314,6 +351,22 @@ static int exynos_ehci_resume(struct device *dev)
 	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
 	int ret;
 
+	if (!IS_ERR(exynos_ehci->vdd33)) {
+		ret = regulator_enable(exynos_ehci->vdd33);
+		if (ret) {
+			dev_err(dev, "Failed to enable 3.3V Vdd supply\n");
+			return ret;
+		}
+	}
+
+	if (!IS_ERR(exynos_ehci->vdd10)) {
+		ret = regulator_enable(exynos_ehci->vdd10);
+		if (ret) {
+			dev_err(dev, "Failed to enable 1.0V Vdd supply\n");
+			return ret;
+		}
+	}
+
 	clk_prepare_enable(exynos_ehci->clk);
 
 	if (exynos_ehci->otg)
-- 
1.7.10.4

