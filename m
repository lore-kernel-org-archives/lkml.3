Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaEGEB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:01:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56204 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753004AbaEGEBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:01:55 -0400
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
Subject: [PATCH 3/7] phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
Date: Tue,  6 May 2014 22:50:19 -0500
Message-Id: <1399434623-20383-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB phy controller in the A31 differs mostly from the older controllers
because it has a clock dedicated for each phy, while the older ones were having
a single clock for all the phys.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index e6e6c4ba7145..1d83abe07a29 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -61,16 +61,17 @@
 #define MAX_PHYS			3
 
 struct sun4i_usb_phy_data {
-	struct clk *clk;
 	void __iomem *base;
 	struct mutex mutex;
 	int num_phys;
 	u32 disc_thresh;
+	bool dedicated_clocks;
 	struct sun4i_usb_phy {
 		struct phy *phy;
 		void __iomem *pmu;
 		struct regulator *vbus;
 		struct reset_control *reset;
+		struct clk *clk;
 		int index;
 	} phys[MAX_PHYS];
 };
@@ -146,13 +147,13 @@ static int sun4i_usb_phy_init(struct phy *_phy)
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
 
@@ -170,11 +171,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
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
@@ -230,6 +230,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	struct regulator *vbus;
 	struct resource *res;
 	struct phy *phy;
+	struct clk *clk;
 	char name[16];
 	int i;
 
@@ -249,15 +250,20 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 	else
 		data->disc_thresh = 2;
 
+	if (of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
+		data->dedicated_clocks = true;
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_ctrl");
 	data->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->clk = devm_clk_get(dev, "usb_phy");
-	if (IS_ERR(data->clk)) {
-		dev_err(dev, "could not get usb_phy clock\n");
-		return PTR_ERR(data->clk);
+	if (!data->dedicated_clocks) {
+		clk = devm_clk_get(dev, "usb_phy");
+		if (IS_ERR(clk)) {
+			dev_err(dev, "could not get usb_phy clock\n");
+			return PTR_ERR(clk);
+		}
 	}
 
 	/* Skip 0, 0 is the phy for otg which is not yet supported. */
@@ -270,6 +276,15 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 			vbus = NULL;
 		}
 
+		if (data->dedicated_clocks) {
+			snprintf(name, sizeof(name), "usb%d_phy", i);
+			clk = devm_clk_get(dev, name);
+			if (IS_ERR(clk)) {
+				dev_err(dev, "failed to get clock %s\n", name);
+				return PTR_ERR(clk);
+			}
+		}
+
 		snprintf(name, sizeof(name), "usb%d_reset", i);
 		reset = devm_reset_control_get(dev, name);
 		if (IS_ERR(reset)) {
@@ -296,6 +311,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 		data->phys[i].pmu = pmu;
 		data->phys[i].vbus = vbus;
 		data->phys[i].reset = reset;
+		data->phys[i].clk = clk;
 		data->phys[i].index = i;
 		phy_set_drvdata(phy, &data->phys[i]);
 	}
@@ -311,6 +327,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 static const struct of_device_id sun4i_usb_phy_of_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-usb-phy" },
 	{ .compatible = "allwinner,sun5i-a13-usb-phy" },
+	{ .compatible = "allwinner,sun6i-a31-usb-phy" },
 	{ .compatible = "allwinner,sun7i-a20-usb-phy" },
 	{ },
 };
-- 
1.9.1

