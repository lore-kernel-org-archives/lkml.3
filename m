Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbbATH07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:26:59 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49339 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbATHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:09:51 -0500
From: Romain Perier <romain.perier@gmail.com>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, heiko@sntech.de,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: [PATCH v2 3/4] net: stmmac: dwmac-rk: Use standard devicetree property for phy regulator
Date: Tue, 20 Jan 2015 07:09:39 +0000
Message-Id: <1421737780-1533-4-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, dwmac-rk uses a custom propety "phy_regulator" to get the name of the
right regulator to use to power on or power off the phy. This commit converts the
driver to use phy-supply devicetree property and the corresponding API, it cleans
the code a bit and make it simpler to maintain. This also replaces the property
phy_regulator by the standard property phy-supply in rk3288-evb-rk808.dts.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/arm/boot/dts/rk3288-evb-rk808.dts         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 63 +++++++++-----------------
 2 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index 831a7aa..e1d3eeb 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -161,7 +161,7 @@
 };
 
 &gmac {
-	phy_regulator = "vcc_phy";
+	phy-supply = <&vcc_phy>;
 	phy-mode = "rgmii";
 	clock_in_out = "input";
 	snps,reset-gpio = <&gpio4 7 0>;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 06e1637..6249a4e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -32,7 +32,7 @@
 struct rk_priv_data {
 	struct platform_device *pdev;
 	int phy_iface;
-	char regulator[32];
+	struct regulator *regulator;
 
 	bool clk_enabled;
 	bool clock_input;
@@ -287,46 +287,25 @@ static int gmac_clk_enable(struct rk_priv_data *bsp_priv, bool enable)
 
 static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
 {
-	struct regulator *ldo;
-	char *ldostr = bsp_priv->regulator;
+	struct regulator *ldo = bsp_priv->regulator;
 	int ret;
 	struct device *dev = &bsp_priv->pdev->dev;
 
-	if (!ldostr) {
-		dev_err(dev, "%s: no ldo found\n", __func__);
+	if (!ldo) {
+		dev_err(dev, "%s: no regulator found\n", __func__);
 		return -1;
 	}
 
-	ldo = regulator_get(NULL, ldostr);
-	if (!ldo) {
-		dev_err(dev, "\n%s get ldo %s failed\n", __func__, ldostr);
+	if (enable) {
+		ret = regulator_enable(ldo);
+		if (ret)
+			dev_err(dev, "%s: fail to enable phy-supply\n",
+				__func__);
 	} else {
-		if (enable) {
-			if (!regulator_is_enabled(ldo)) {
-				ret = regulator_enable(ldo);
-				if (ret != 0)
-					dev_err(dev, "%s: fail to enable %s\n",
-						__func__, ldostr);
-				else
-					dev_info(dev, "turn on ldo done.\n");
-			} else {
-				dev_warn(dev, "%s is enabled before enable",
-					 ldostr);
-			}
-		} else {
-			if (regulator_is_enabled(ldo)) {
-				ret = regulator_disable(ldo);
-				if (ret != 0)
-					dev_err(dev, "%s: fail to disable %s\n",
-						__func__, ldostr);
-				else
-					dev_info(dev, "turn off ldo done.\n");
-			} else {
-				dev_warn(dev, "%s is disabled before disable",
-					 ldostr);
-			}
-		}
-		regulator_put(ldo);
+		ret = regulator_disable(ldo);
+		if (ret)
+			dev_err(dev, "%s: fail to disable phy-supply\n",
+				__func__);
 	}
 
 	return 0;
@@ -346,14 +325,14 @@ static void *rk_gmac_setup(struct platform_device *pdev)
 
 	bsp_priv->phy_iface = of_get_phy_mode(dev->of_node);
 
-	ret = of_property_read_string(dev->of_node, "phy_regulator", &strings);
-	if (ret) {
-		dev_warn(dev, "%s: Can not read property: phy_regulator.\n",
-			 __func__);
-	} else {
-		dev_info(dev, "%s: PHY power controlled by regulator(%s).\n",
-			 __func__, strings);
-		strcpy(bsp_priv->regulator, strings);
+	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
+	if (IS_ERR(bsp_priv->regulator)) {
+		if (PTR_ERR(bsp_priv->regulator) == -EPROBE_DEFER) {
+			dev_err(dev, "phy regulator is not available yet, deferred probing\n");
+			return ERR_PTR(-EPROBE_DEFER);
+		}
+		dev_err(dev, "no regulator found\n");
+		bsp_priv->regulator = NULL;
 	}
 
 	ret = of_property_read_string(dev->of_node, "clock_in_out", &strings);
-- 
1.9.1

