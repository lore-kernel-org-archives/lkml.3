Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaJGKT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:19:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51446 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaJGKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:19:55 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 3/4] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
Date: Tue,  7 Oct 2014 15:49:35 +0530
Message-Id: <1412677176-3850-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Exynos SoCs have a separate regulator controlling a
Boost 5V supply which goes as input for VBUS regulator.
So adding a control for the same in driver, to enable
vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 013ee84..57e8a0a 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -176,6 +176,7 @@ struct exynos5_usbdrd_phy {
 	u32 extrefclk;
 	struct clk *ref_clk;
 	struct regulator *vbus;
+	struct regulator *vbus_boost;
 };
 
 static inline
@@ -455,11 +456,20 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
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
+
 	if (phy_drd->vbus) {
 		ret = regulator_enable(phy_drd->vbus);
 		if (ret) {
 			dev_err(phy_drd->dev, "Failed to enable VBUS supply\n");
-			goto fail_vbus;
+			goto fail_vbus_boost;
 		}
 	}
 
@@ -468,6 +478,10 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 	return 0;
 
+fail_vbus_boost:
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
+
 fail_vbus:
 	clk_disable_unprepare(phy_drd->ref_clk);
 	clk_disable_unprepare(phy_drd->pipeclk);
@@ -489,6 +503,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Disable VBUS supply */
 	if (phy_drd->vbus)
 		regulator_disable(phy_drd->vbus);
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
 
 	clk_disable_unprepare(phy_drd->ref_clk);
 	clk_disable_unprepare(phy_drd->pipeclk);
@@ -644,7 +660,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		break;
 	}
 
-	/* Get Vbus regulator */
+	/* Get Vbus regulators */
 	phy_drd->vbus = devm_regulator_get(dev, "vbus");
 	if (IS_ERR(phy_drd->vbus)) {
 		ret = PTR_ERR(phy_drd->vbus);
@@ -655,6 +671,16 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
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
+
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
-- 
1.7.10.4

