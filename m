Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaELTfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:35:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32948 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbaELTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:35:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 4/8] phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
Date: Mon, 12 May 2014 21:34:30 +0200
Message-Id: <1399923274-6017-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB phy controller in the A31 differs mostly from the older controllers
because it has a clock dedicated for each phy, while the older ones were having
a single clock for all the phys.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/phy/phy-sun4i-usb.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 81896409c4bd..e15715aeec24 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -61,7 +61,6 @@
 #define MAX_PHYS			3
 
 struct sun4i_usb_phy_data {
-	struct clk *clk;
 	void __iomem *base;
 	struct mutex mutex;
 	int num_phys;
@@ -71,6 +70,7 @@ struct sun4i_usb_phy_data {
 		void __iomem *pmu;
 		struct regulator *vbus;
 		struct reset_control *reset;
+		struct clk *clk;
 		int index;
 	} phys[MAX_PHYS];
 };
@@ -146,13 +146,13 @@ static int sun4i_usb_phy_init(struct phy *_phy)
 	struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
 	int ret;
 
-	ret = clk_prepare_enable(data->clk);
+	ret = clk_prepare_enable(phy->clk);
 	if (ret)
 		return ret;
 
 	ret = reset_control_deassert(phy->reset);
 	if (ret) {
-		clk_disable_unprepare(data->clk);
+		clk_disable_unprepare(phy->clk);
 		return ret;
 	}
 
@@ -170,11 +170,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
 static int sun4i_usb_phy_exit(struct phy *_phy)
 {
 	struct sun4i_usb_phy *phy = phy_get_drvdata(_phy);
-	struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
 
 	sun4i_usb_phy_passby(phy, 0);
 	reset_control_assert(phy->reset);
-	clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(phy->clk);
 
 	return 0;
 }
@@ -225,6 +224,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct phy_provider *phy_provider;
+	bool dedicated_clocks;
 	struct resource *res;
 	int i;
 
@@ -244,17 +244,16 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	else
 		data->disc_thresh = 2;
 
+	if (of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
+		dedicated_clocks = true;
+	else
+		dedicated_clocks = false;
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_ctrl");
 	data->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->clk = devm_clk_get(dev, "usb_phy");
-	if (IS_ERR(data->clk)) {
-		dev_err(dev, "could not get usb_phy clock\n");
-		return PTR_ERR(data->clk);
-	}
-
 	/* Skip 0, 0 is the phy for otg which is not yet supported. */
 	for (i = 1; i < data->num_phys; i++) {
 		struct sun4i_usb_phy *phy = data->phys + i;
@@ -268,6 +267,17 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 			phy->vbus = NULL;
 		}
 
+		if (dedicated_clocks)
+			snprintf(name, sizeof(name), "usb%d_phy", i);
+		else
+			strlcpy(name, "usb_phy", sizeof(name));
+
+		phy->clk = devm_clk_get(dev, name);
+		if (IS_ERR(phy->clk)) {
+			dev_err(dev, "failed to get clock %s\n", name);
+			return PTR_ERR(phy->clk);
+		}
+
 		snprintf(name, sizeof(name), "usb%d_reset", i);
 		phy->reset = devm_reset_control_get(dev, name);
 		if (IS_ERR(phy->reset)) {
@@ -307,6 +317,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 static const struct of_device_id sun4i_usb_phy_of_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-usb-phy" },
 	{ .compatible = "allwinner,sun5i-a13-usb-phy" },
+	{ .compatible = "allwinner,sun6i-a31-usb-phy" },
 	{ .compatible = "allwinner,sun7i-a20-usb-phy" },
 	{ },
 };
-- 
1.9.3

