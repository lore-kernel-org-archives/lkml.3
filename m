Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaFFOUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:20:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33844 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFFOUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:20:21 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2 1/2] usb: ehci-exynos: Make provision for vdd regulators
Date: Fri,  6 Jun 2014 19:50:10 +0530
Message-Id: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate getting required 3.3V and 1.0V VDD supply for
EHCI controller on Exynos.

With patches for regulators' nodes merged in 3.15:
c8c253f ARM: dts: Add regulator entries to smdk5420
275dcd2 ARM: dts: add max77686 pmic node for smdk5250,

certain perripherals will now need to ensure that,
they request VDD regulators in their drivers, and enable
them so as to make them working.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
---

Changes from v1:
 - Addressed review comments for making the regulators optional,
   and thus refactored the checks for the obtained regulators.

 drivers/usb/host/ehci-exynos.c |   59 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index d1c7621..b788ddd 100644
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
@@ -193,7 +196,31 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 
 	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
 	if (err)
-		goto fail_clk;
+		goto fail_regulator1;
+
+	exynos_ehci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
+	if (!IS_ERR(exynos_ehci->vdd33)) {
+		err = regulator_enable(exynos_ehci->vdd33);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 3.3V Vdd supply\n");
+			goto fail_regulator1;
+		}
+	} else {
+		dev_warn(&pdev->dev, "Regulator 3.3V Vdd supply not found\n");
+	}
+
+	exynos_ehci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
+	if (!IS_ERR(exynos_ehci->vdd10)) {
+		err = regulator_enable(exynos_ehci->vdd10);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 1.0V Vdd supply\n");
+			goto fail_regulator2;
+		}
+	} else {
+		dev_warn(&pdev->dev, "Regulator 1.0V Vdd supply not found\n");
+	}
 
 skip_phy:
 
@@ -262,6 +289,10 @@ fail_add_hcd:
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
@@ -280,6 +311,11 @@ static int exynos_ehci_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
+	if (!IS_ERR(exynos_ehci->vdd33))
+		regulator_disable(exynos_ehci->vdd33);
+	if (!IS_ERR(exynos_ehci->vdd10))
+		regulator_disable(exynos_ehci->vdd10);
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -305,6 +341,11 @@ static int exynos_ehci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ehci->clk);
 
+	if (!IS_ERR(exynos_ehci->vdd33))
+		regulator_disable(exynos_ehci->vdd33);
+	if (!IS_ERR(exynos_ehci->vdd10))
+		regulator_disable(exynos_ehci->vdd10);
+
 	return rc;
 }
 
@@ -314,6 +355,22 @@ static int exynos_ehci_resume(struct device *dev)
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

