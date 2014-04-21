Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaDUMRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:17:04 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33184 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDUMRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:17:01 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Mon, 21 Apr 2014 17:46:42 +0530
Message-Id: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Facilitate getting required 3.3V and 1.0V VDD supply for
OHCI controller on Exynos.

With patches for regulators' nodes merged in 3.15:
c8c253f ARM: dts: Add regulator entries to smdk5420
275dcd2 ARM: dts: add max77686 pmic node for smdk5250,

certain perripherals will now need to ensure that,
they request VDD regulators in their drivers, and enable
them so as to make them working.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
---

Based on 'usb-next' branch of Greg's usb tree.

 drivers/usb/host/ohci-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 68588d8..e2e72a8 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/usb.h>
@@ -37,6 +38,8 @@ struct exynos_ohci_hcd {
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
+	struct regulator *vdd33;
+	struct regulator *vdd10;
 };
 
 static void exynos_ohci_phy_enable(struct platform_device *pdev)
@@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 		exynos_ohci->otg = phy->otg;
 	}
 
+	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
+	if (IS_ERR(exynos_ohci->vdd33)) {
+		err = PTR_ERR(exynos_ohci->vdd33);
+		goto fail_regulator1;
+	}
+	err = regulator_enable(exynos_ohci->vdd33);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
+		goto fail_regulator1;
+	}
+
+	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
+	if (IS_ERR(exynos_ohci->vdd10)) {
+		err = PTR_ERR(exynos_ohci->vdd10);
+		goto fail_regulator2;
+	}
+	err = regulator_enable(exynos_ohci->vdd10);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
+		goto fail_regulator2;
+	}
+
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
 
@@ -154,6 +179,10 @@ fail_add_hcd:
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
@@ -172,6 +201,9 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	regulator_disable(exynos_ohci->vdd10);
+	regulator_disable(exynos_ohci->vdd33);
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -208,6 +240,9 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	regulator_disable(exynos_ohci->vdd10);
+	regulator_disable(exynos_ohci->vdd33);
+
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	return 0;
@@ -218,6 +253,18 @@ static int exynos_ohci_resume(struct device *dev)
 	struct usb_hcd *hcd			= dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
 	struct platform_device *pdev		= to_platform_device(dev);
+	int ret;
+
+	ret = regulator_enable(exynos_ohci->vdd33);
+	if (ret) {
+		dev_err(dev, "Failed to enable VDD33 supply\n");
+		return ret;
+	}
+	ret = regulator_enable(exynos_ohci->vdd10);
+	if (ret) {
+		dev_err(dev, "Failed to enable VDD10 supply\n");
+		return ret;
+	}
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-- 
1.7.10.4

