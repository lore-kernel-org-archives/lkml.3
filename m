Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaK0G0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41712 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbaK0G0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:48 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/25] phy: exynos5-usbdrd: Add pipe-clk, utmi-clk and itp-clk support
Date: Thu, 27 Nov 2014 11:56:11 +0530
Message-ID: <1417069577-1169-20-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Gautam <gautam.vivek@samsung.com>

Exynos7 SoC has now separate gate control for 125MHz pipe3 phy
clock, as well as 60MHz utmi phy clock.
Additionally, separate gate control is available for the clock
used for ITP (Isochronous Transfer Packet) generation.

So get the same and control in the phy-exynos5-usbdrd driver.

Suggested-by: Anton Tikhomirov <av.tikhomirov@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    6 ++
 drivers/phy/phy-exynos5-usbdrd.c                   |  104 ++++++++++++++++----
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 15e0f2c..d5bad92 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -128,6 +128,7 @@ Required properties:
 - compatible : Should be set to one of the following supported values:
 	- "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
 	- "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
+	- "samsung,exynos7-usbdrd-phy" - for exynos7 SoC.
 - reg : Register offset and length of USB DRD PHY register set;
 - clocks: Clock IDs array as required by the controller
 - clock-names: names of clocks correseponding to IDs in the clock property;
@@ -138,6 +139,11 @@ Required properties:
 	       PHY operations, associated by phy name. It is used to
 	       determine bit values for clock settings register.
 	       For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
+	- optional clocks: Exynos7 SoC has now following additional
+			   gate clocks available:
+			   - phy_pipe: for PIPE3 phy
+			   - phy_utmi: for UTMI+ phy
+			   - itp: for ITP generation
 - samsung,pmu-syscon: phandle for PMU system controller interface, used to
 		      control pmu registers for power isolation.
 - #phy-cells : from the generic PHY bindings, must be 1;
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index b3ca3bc..99ba56d 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -141,6 +141,7 @@ struct exynos5_usbdrd_phy_drvdata {
 	const struct exynos5_usbdrd_phy_config *phy_cfg;
 	u32 pmu_offset_usbdrd0_phy;
 	u32 pmu_offset_usbdrd1_phy;
+	bool has_common_clk_gate;
 };
 
 /**
@@ -148,6 +149,9 @@ struct exynos5_usbdrd_phy_drvdata {
  * @dev: pointer to device instance of this platform device
  * @reg_phy: usb phy controller register memory base
  * @clk: phy clock for register access
+ * @pipeclk: clock for pipe3 phy
+ * @utmiclk: clock for utmi+ phy
+ * @itpclk: clock for ITP generation
  * @drv_data: pointer to SoC level driver data structure
  * @phys[]: array for 'EXYNOS5_DRDPHYS_NUM' number of PHY
  *	    instances each with its 'phy' and 'phy_cfg'.
@@ -155,12 +159,14 @@ struct exynos5_usbdrd_phy_drvdata {
  *	       reference clocks' for SS and HS operations
  * @ref_clk: reference clock to PHY block from which PHY's
  *	     operational clocks are derived
- * @ref_rate: rate of above reference clock
  */
 struct exynos5_usbdrd_phy {
 	struct device *dev;
 	void __iomem *reg_phy;
 	struct clk *clk;
+	struct clk *pipeclk;
+	struct clk *utmiclk;
+	struct clk *itpclk;
 	const struct exynos5_usbdrd_phy_drvdata *drv_data;
 	struct phy_usb_instance {
 		struct phy *phy;
@@ -447,6 +453,11 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 	dev_dbg(phy_drd->dev, "Request to power_on usbdrd_phy phy\n");
 
 	clk_prepare_enable(phy_drd->ref_clk);
+	if (!phy_drd->drv_data->has_common_clk_gate) {
+		clk_prepare_enable(phy_drd->pipeclk);
+		clk_prepare_enable(phy_drd->utmiclk);
+		clk_prepare_enable(phy_drd->itpclk);
+	}
 
 	/* Enable VBUS supply */
 	if (phy_drd->vbus) {
@@ -464,6 +475,11 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 fail_vbus:
 	clk_disable_unprepare(phy_drd->ref_clk);
+	if (!phy_drd->drv_data->has_common_clk_gate) {
+		clk_disable_unprepare(phy_drd->itpclk);
+		clk_disable_unprepare(phy_drd->utmiclk);
+		clk_disable_unprepare(phy_drd->pipeclk);
+	}
 
 	return ret;
 }
@@ -483,6 +499,11 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 		regulator_disable(phy_drd->vbus);
 
 	clk_disable_unprepare(phy_drd->ref_clk);
+	if (!phy_drd->drv_data->has_common_clk_gate) {
+		clk_disable_unprepare(phy_drd->itpclk);
+		clk_disable_unprepare(phy_drd->pipeclk);
+		clk_disable_unprepare(phy_drd->utmiclk);
+	}
 
 	return 0;
 }
@@ -506,6 +527,57 @@ static struct phy_ops exynos5_usbdrd_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static int exynos5_usbdrd_phy_clk_handle(struct exynos5_usbdrd_phy *phy_drd)
+{
+	unsigned long ref_rate;
+	int ret;
+
+	phy_drd->clk = devm_clk_get(phy_drd->dev, "phy");
+	if (IS_ERR(phy_drd->clk)) {
+		dev_err(phy_drd->dev, "Failed to get phy clock\n");
+		return PTR_ERR(phy_drd->clk);
+	}
+
+	phy_drd->ref_clk = devm_clk_get(phy_drd->dev, "ref");
+	if (IS_ERR(phy_drd->ref_clk)) {
+		dev_err(phy_drd->dev, "Failed to get phy reference clock\n");
+		return PTR_ERR(phy_drd->ref_clk);
+	}
+	ref_rate = clk_get_rate(phy_drd->ref_clk);
+
+	ret = exynos5_rate_to_clk(ref_rate, &phy_drd->extrefclk);
+	if (ret) {
+		dev_err(phy_drd->dev, "Clock rate (%ld) not supported\n",
+			ref_rate);
+		return ret;
+	}
+
+	if (!phy_drd->drv_data->has_common_clk_gate) {
+		phy_drd->pipeclk = devm_clk_get(phy_drd->dev, "phy_pipe");
+		if (IS_ERR(phy_drd->pipeclk)) {
+			dev_info(phy_drd->dev,
+				 "PIPE3 phy operational clock not specified\n");
+			phy_drd->pipeclk = NULL;
+		}
+
+		phy_drd->utmiclk = devm_clk_get(phy_drd->dev, "phy_utmi");
+		if (IS_ERR(phy_drd->utmiclk)) {
+			dev_info(phy_drd->dev,
+				 "UTMI phy operational clock not specified\n");
+			phy_drd->utmiclk = NULL;
+		}
+
+		phy_drd->itpclk = devm_clk_get(phy_drd->dev, "itp");
+		if (IS_ERR(phy_drd->itpclk)) {
+			dev_info(phy_drd->dev,
+				 "ITP clock from main OSC not specified\n");
+			phy_drd->itpclk = NULL;
+		}
+	}
+
+	return 0;
+}
+
 static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 	{
 		.id		= EXYNOS5_DRDPHY_UTMI,
@@ -525,11 +597,19 @@ static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
+	.has_common_clk_gate	= true,
 };
 
 static const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
+	.has_common_clk_gate	= true,
+};
+
+static const struct exynos5_usbdrd_phy_drvdata exynos7_usbdrd_phy = {
+	.phy_cfg		= phy_cfg_exynos5,
+	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
+	.has_common_clk_gate	= false,
 };
 
 static const struct of_device_id exynos5_usbdrd_phy_of_match[] = {
@@ -539,6 +619,9 @@ static const struct of_device_id exynos5_usbdrd_phy_of_match[] = {
 	}, {
 		.compatible = "samsung,exynos5420-usbdrd-phy",
 		.data = &exynos5420_usbdrd_phy
+	}, {
+		.compatible = "samsung,exynos7-usbdrd-phy",
+		.data = &exynos7_usbdrd_phy
 	},
 	{ },
 };
@@ -555,7 +638,6 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 	const struct exynos5_usbdrd_phy_drvdata *drv_data;
 	struct regmap *reg_pmu;
 	u32 pmu_offset;
-	unsigned long ref_rate;
 	int i, ret;
 	int channel;
 
@@ -576,23 +658,9 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 	drv_data = match->data;
 	phy_drd->drv_data = drv_data;
 
-	phy_drd->clk = devm_clk_get(dev, "phy");
-	if (IS_ERR(phy_drd->clk)) {
-		dev_err(dev, "Failed to get clock of phy controller\n");
-		return PTR_ERR(phy_drd->clk);
-	}
-
-	phy_drd->ref_clk = devm_clk_get(dev, "ref");
-	if (IS_ERR(phy_drd->ref_clk)) {
-		dev_err(dev, "Failed to get reference clock of usbdrd phy\n");
-		return PTR_ERR(phy_drd->ref_clk);
-	}
-	ref_rate = clk_get_rate(phy_drd->ref_clk);
-
-	ret = exynos5_rate_to_clk(ref_rate, &phy_drd->extrefclk);
+	ret = exynos5_usbdrd_phy_clk_handle(phy_drd);
 	if (ret) {
-		dev_err(phy_drd->dev, "Clock rate (%ld) not supported\n",
-			ref_rate);
+		dev_err(dev, "Failed to initialize clocks\n");
 		return ret;
 	}
 
-- 
1.7.9.5

