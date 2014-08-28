Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369AbaH1ICn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:02:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49209 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936346AbaH1ICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:38 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 3/5] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
Date: Thu, 28 Aug 2014 13:31:58 +0530
Message-Id: <1409212920-28526-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Exynos SoCs have a separate regulator controlling a
Boost 5V supply which goes as input for VBUS regulator.
So adding a control for the same in driver, to enable
vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 685c108..a6d0cb7 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -176,6 +176,7 @@ struct exynos5_usbdrd_phy {
 	u32 extrefclk;
 	struct clk *ref_clk;
 	struct regulator *vbus;
+	struct regulator *vbus_boost;
 };
 
 static inline
@@ -457,11 +458,19 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 	clk_prepare_enable(phy_drd->ref_clk);
 
 	/* Enable VBUS supply */
+	if (phy_drd->vbus_boost) {
+		ret = regulator_enable(phy_drd->vbus_boost);
+		if (ret) {
+			dev_err(phy_drd->dev,
+				"Failed to enable VBUS boost supply\n");
+			goto fail_vbus;
+		}
+	}
 	if (phy_drd->vbus) {
 		ret = regulator_enable(phy_drd->vbus);
 		if (ret) {
 			dev_err(phy_drd->dev, "Failed to enable VBUS supply\n");
-			goto fail_vbus;
+			goto fail_vbus_boost;
 		}
 	}
 
@@ -470,6 +479,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 	return 0;
 
+fail_vbus_boost:
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
 fail_vbus:
 	clk_disable_unprepare(phy_drd->ref_clk);
 	if (!IS_ERR(phy_drd->pipeclk))
@@ -493,6 +505,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Disable VBUS supply */
 	if (phy_drd->vbus)
 		regulator_disable(phy_drd->vbus);
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
 
 	clk_disable_unprepare(phy_drd->ref_clk);
 	if (!IS_ERR(phy_drd->pipeclk))
@@ -645,7 +659,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		break;
 	}
 
-	/* Get Vbus regulator */
+	/* Get Vbus regulators */
 	phy_drd->vbus = devm_regulator_get(dev, "vbus");
 	if (IS_ERR(phy_drd->vbus)) {
 		ret = PTR_ERR(phy_drd->vbus);
@@ -655,6 +669,15 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		dev_warn(dev, "Failed to get VBUS supply regulator\n");
 		phy_drd->vbus = NULL;
 	}
+	phy_drd->vbus_boost = devm_regulator_get(dev, "vbus-boost");
+	if (IS_ERR(phy_drd->vbus_boost)) {
+		ret = PTR_ERR(phy_drd->vbus_boost);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		dev_warn(dev, "Failed to get VBUS boost supply regulator\n");
+		phy_drd->vbus_boost = NULL;
+	}
 
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
-- 
1.7.10.4

