Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaBQI7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52626 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaBQI7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:40 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 8/8] phy: let phy_provider_register be the last step in registering PHY
Date: Mon, 17 Feb 2014 14:29:25 +0530
Message-ID: <1392627565-1829-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registering phy_provider before creating the PHY can result in PHY
callbacks being invoked which will lead to aborts. In order to avoid this
invoke phy_provider_register after phy_create and phy_set_drvdata.

Reported-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/phy-exynos-dp-video.c   |    8 ++++----
 drivers/phy/phy-exynos-mipi-video.c |   10 +++++-----
 drivers/phy/phy-mvebu-sata.c        |   10 +++++-----
 drivers/phy/phy-omap-usb2.c         |   10 +++++-----
 drivers/phy/phy-twl4030-usb.c       |   10 +++++-----
 5 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 1dbe6ce..0786fef 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -76,10 +76,6 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(state->regs))
 		return PTR_ERR(state->regs);
 
-	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
 	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
 	if (IS_ERR(phy)) {
 		dev_err(dev, "failed to create Display Port PHY\n");
@@ -87,6 +83,10 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
 	}
 	phy_set_drvdata(phy, state);
 
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	return 0;
 }
 
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index 0c5efab..7f13932 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -134,11 +134,6 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, state);
 	spin_lock_init(&state->slock);
 
-	phy_provider = devm_of_phy_provider_register(dev,
-					exynos_mipi_video_phy_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
 	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
 		struct phy *phy = devm_phy_create(dev,
 					&exynos_mipi_video_phy_ops, NULL);
@@ -152,6 +147,11 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 		phy_set_drvdata(phy, &state->phys[i]);
 	}
 
+	phy_provider = devm_of_phy_provider_register(dev,
+					exynos_mipi_video_phy_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	return 0;
 }
 
diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index d43786f..d70ecd6 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -99,17 +99,17 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
-	phy_provider = devm_of_phy_provider_register(&pdev->dev,
-						     of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
 	phy = devm_phy_create(&pdev->dev, &phy_mvebu_sata_ops, NULL);
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
 	phy_set_drvdata(phy, priv);
 
+	phy_provider = devm_of_phy_provider_register(&pdev->dev,
+						     of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	/* The boot loader may of left it on. Turn it off. */
 	phy_mvebu_sata_power_off(phy);
 
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index bfc5c33..7699752 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -177,11 +177,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
-	phy_provider = devm_of_phy_provider_register(phy->dev,
-			of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
 	control_node = of_parse_phandle(node, "ctrl-module", 0);
 	if (!control_node) {
 		dev_err(&pdev->dev, "Failed to get control device phandle\n");
@@ -214,6 +209,11 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	phy_set_drvdata(generic_phy, phy);
 
+	phy_provider = devm_of_phy_provider_register(phy->dev,
+			of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
 	if (IS_ERR(phy->wkupclk)) {
 		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index ab64182..2e0e9b3 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -695,11 +695,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
-	phy_provider = devm_of_phy_provider_register(twl->dev,
-		of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
 	phy = devm_phy_create(twl->dev, &ops, init_data);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
@@ -708,6 +703,11 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 
 	phy_set_drvdata(phy, twl);
 
+	phy_provider = devm_of_phy_provider_register(twl->dev,
+		of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
 
-- 
1.7.10.4

