Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3GOTyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:54:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11116 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3GOTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:54:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Jul 2013 12:53:15 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 1/9] usb: phy: tegra: Remove unnecessary 'dev' field
Date: Mon, 15 Jul 2013 22:53:41 +0300
Message-ID: <1373918029-28977-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct usb_phy already has a field for the device pointer, so this
unnecessary field can be removed.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c   | 27 +++++++++++++++------------
 include/linux/usb/tegra_usb_phy.h |  1 -
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 1a86da8..ddcac0b 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -211,7 +211,7 @@ static void set_phcd(struct tegra_usb_phy *phy, bool enable)
 
 static int utmip_pad_open(struct tegra_usb_phy *phy)
 {
-	phy->pad_clk = devm_clk_get(phy->dev, "utmi-pads");
+	phy->pad_clk = devm_clk_get(phy->u_phy.dev, "utmi-pads");
 	if (IS_ERR(phy->pad_clk)) {
 		pr_err("%s: can't get utmip pad clock\n", __func__);
 		return PTR_ERR(phy->pad_clk);
@@ -540,13 +540,15 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 
 	ret = gpio_direction_output(phy->reset_gpio, 0);
 	if (ret < 0) {
-		dev_err(phy->dev, "gpio %d not set to 0\n", phy->reset_gpio);
+		dev_err(phy->u_phy.dev, "gpio %d not set to 0\n",
+			phy->reset_gpio);
 		return ret;
 	}
 	msleep(5);
 	ret = gpio_direction_output(phy->reset_gpio, 1);
 	if (ret < 0) {
-		dev_err(phy->dev, "gpio %d not set to 1\n", phy->reset_gpio);
+		dev_err(phy->u_phy.dev, "gpio %d not set to 1\n",
+			phy->reset_gpio);
 		return ret;
 	}
 
@@ -649,29 +651,30 @@ static int ulpi_open(struct tegra_usb_phy *phy)
 {
 	int err;
 
-	phy->clk = devm_clk_get(phy->dev, "ulpi-link");
+	phy->clk = devm_clk_get(phy->u_phy.dev, "ulpi-link");
 	if (IS_ERR(phy->clk)) {
 		pr_err("%s: can't get ulpi clock\n", __func__);
 		return PTR_ERR(phy->clk);
 	}
 
-	err = devm_gpio_request(phy->dev, phy->reset_gpio, "ulpi_phy_reset_b");
+	err = devm_gpio_request(phy->u_phy.dev, phy->reset_gpio,
+		"ulpi_phy_reset_b");
 	if (err < 0) {
-		dev_err(phy->dev, "request failed for gpio: %d\n",
+		dev_err(phy->u_phy.dev, "request failed for gpio: %d\n",
 		       phy->reset_gpio);
 		return err;
 	}
 
 	err = gpio_direction_output(phy->reset_gpio, 0);
 	if (err < 0) {
-		dev_err(phy->dev, "gpio %d direction not set to output\n",
+		dev_err(phy->u_phy.dev, "gpio %d direction not set to output\n",
 		       phy->reset_gpio);
 		return err;
 	}
 
 	phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
 	if (!phy->ulpi) {
-		dev_err(phy->dev, "otg_ulpi_create returned NULL\n");
+		dev_err(phy->u_phy.dev, "otg_ulpi_create returned NULL\n");
 		err = -ENOMEM;
 		return err;
 	}
@@ -686,7 +689,7 @@ static int tegra_usb_phy_init(struct tegra_usb_phy *phy)
 	int i;
 	int err;
 
-	phy->pll_u = devm_clk_get(phy->dev, "pll_u");
+	phy->pll_u = devm_clk_get(phy->u_phy.dev, "pll_u");
 	if (IS_ERR(phy->pll_u)) {
 		pr_err("Can't get pll_u clock\n");
 		return PTR_ERR(phy->pll_u);
@@ -712,7 +715,7 @@ static int tegra_usb_phy_init(struct tegra_usb_phy *phy)
 	if (!IS_ERR(phy->vbus)) {
 		err = regulator_enable(phy->vbus);
 		if (err) {
-			dev_err(phy->dev,
+			dev_err(phy->u_phy.dev,
 				"failed to enable usb vbus regulator: %d\n", err);
 			goto fail;
 		}
@@ -919,7 +922,7 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 		tegra_phy->vbus = ERR_PTR(-ENODEV);
 	}
 
-	tegra_phy->dev = &pdev->dev;
+	tegra_phy->u_phy.dev = &pdev->dev;
 	err = tegra_usb_phy_init(tegra_phy);
 	if (err < 0)
 		return err;
@@ -952,7 +955,7 @@ static int tegra_usb_phy_match(struct device *dev, void *data)
 	struct tegra_usb_phy *tegra_phy = dev_get_drvdata(dev);
 	struct device_node *dn = data;
 
-	return (tegra_phy->dev->of_node == dn) ? 1 : 0;
+	return (tegra_phy->u_phy.dev->of_node == dn) ? 1 : 0;
 }
 
 struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 2b5fa94..c2bc710 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -60,7 +60,6 @@ struct tegra_usb_phy {
 	void *config;
 	struct usb_phy *ulpi;
 	struct usb_phy u_phy;
-	struct device *dev;
 	bool is_legacy_phy;
 	bool is_ulpi_phy;
 	int reset_gpio;
-- 
1.8.1.5

