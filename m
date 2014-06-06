Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaFFOU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:20:29 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33676 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaFFOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:20:25 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2 2/2] usb: ohci-exynos: Make provision for vdd regulators
Date: Fri,  6 Jun 2014 19:50:11 +0530
Message-Id: <1402064411-18244-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
References: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
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

Changes from v1:
 - Addressed review comments for making the regulators optional,
   and thus refactored the checks for the obtained regulators.

 drivers/usb/host/ohci-exynos.c |   59 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 060a6a4..01f7c43 100644
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
@@ -172,7 +175,31 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 
 	err = exynos_ohci_get_phy(&pdev->dev, exynos_ohci);
 	if (err)
-		goto fail_clk;
+		goto fail_regulator1;
+
+	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
+	if (!IS_ERR(exynos_ohci->vdd33)) {
+		err = regulator_enable(exynos_ohci->vdd33);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 3.3V Vdd supply\n");
+			goto fail_regulator1;
+		}
+	} else {
+		dev_warn(&pdev->dev, "Regulator 3.3V Vdd supply not found\n");
+	}
+
+	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
+	if (!IS_ERR(exynos_ohci->vdd10)) {
+		err = regulator_enable(exynos_ohci->vdd10);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to enable 1.0V Vdd supply\n");
+			goto fail_regulator2;
+		}
+	} else {
+		dev_warn(&pdev->dev, "Regulator 1.0V Vdd supply not found\n");
+	}
 
 skip_phy:
 	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
@@ -233,6 +260,10 @@ fail_add_hcd:
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
@@ -251,6 +282,11 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	if (!IS_ERR(exynos_ohci->vdd33))
+		regulator_disable(exynos_ohci->vdd33);
+	if (!IS_ERR(exynos_ohci->vdd10))
+		regulator_disable(exynos_ohci->vdd10);
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -282,6 +318,11 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
+	if (!IS_ERR(exynos_ohci->vdd33))
+		regulator_disable(exynos_ohci->vdd33);
+	if (!IS_ERR(exynos_ohci->vdd10))
+		regulator_disable(exynos_ohci->vdd10);
+
 	return 0;
 }
 
@@ -291,6 +332,22 @@ static int exynos_ohci_resume(struct device *dev)
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

