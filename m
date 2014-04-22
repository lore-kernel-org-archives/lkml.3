Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaDVLY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:24:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43514 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbaDVLYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:24:46 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, sylvester.nawrocki@gmail.com
Subject: [PATCH v6 2/2] phy: exynos5-usbdrd: Add facility for VBUS supply
Date: Tue, 22 Apr 2014 16:54:30 +0530
Message-Id: <1398165871-20326-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398165871-20326-1-git-send-email-gautam.vivek@samsung.com>
References: <1398165871-20326-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to enable/disable VBUS controlled by a
regulator, to enable vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Mistakenly sent a WIP patchset in v5 version of this patch, that gives
build errors. So fixed those.

Changes from v5:
 - Removed any mention about sclk_usbphy30* in the driver.

 drivers/phy/phy-exynos5-usbdrd.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index ca1f6ab..ad94c98 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 
 /* Exynos USB PHY registers */
 #define EXYNOS5_FSEL_9MHZ6		0x0
@@ -171,6 +172,7 @@ struct exynos5_usbdrd_phy {
 	unsigned int extrefclk;
 	struct clk *ref_clk;
 	unsigned long ref_rate;
+	struct regulator *vbus;
 };
 
 #define to_usbdrd_phy(inst) \
@@ -441,6 +443,7 @@ static int exynos5_usbdrd_phy_exit(struct phy *phy)
 
 static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 {
+	int ret;
 	struct phy_usb_instance *inst = phy_get_drvdata(phy);
 	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
 
@@ -448,10 +451,24 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 	clk_prepare_enable(phy_drd->ref_clk);
 
+	/* Enable VBUS supply */
+	if (phy_drd->vbus) {
+		ret = regulator_enable(phy_drd->vbus);
+		if (ret) {
+			dev_err(phy_drd->dev, "Failed to enable VBUS supply\n");
+			goto fail_vbus;
+		}
+	}
+
 	/* Power-on PHY*/
 	inst->phy_cfg->phy_isol(inst, 0);
 
 	return 0;
+
+fail_vbus:
+	clk_disable_unprepare(phy_drd->ref_clk);
+
+	return ret;
 }
 
 static int exynos5_usbdrd_phy_power_off(struct phy *phy)
@@ -464,6 +481,10 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Power-off the PHY */
 	inst->phy_cfg->phy_isol(inst, 1);
 
+	/* Disable VBUS supply */
+	if (phy_drd->vbus)
+		regulator_disable(phy_drd->vbus);
+
 	clk_disable_unprepare(phy_drd->ref_clk);
 
 	return 0;
@@ -534,7 +555,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 	const struct exynos5_usbdrd_phy_drvdata *drv_data;
 	struct regmap *reg_pmu;
 	u32 pmu_offset;
-	int i;
+	int i, ret;
 
 	phy_drd = devm_kzalloc(dev, sizeof(*phy_drd), GFP_KERNEL);
 	if (!phy_drd)
@@ -577,6 +598,17 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(reg_pmu);
 	}
 
+	/* Get required GPIO for vbus */
+	phy_drd->vbus = devm_regulator_get(dev, "vbus");
+	if (IS_ERR(phy_drd->vbus)) {
+		ret = PTR_ERR(phy_drd->vbus);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		dev_warn(dev, "Failed to get VBUS supply regulator\n");
+		phy_drd->vbus = NULL;
+	}
+
 	if (of_property_read_u32(node, "samsung,pmu-offset", &pmu_offset)) {
 		dev_err(dev, "Missing pmu-offset for phy isolation\n");
 		return -EINVAL;
-- 
1.7.10.4

