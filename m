Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3ISNGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:06:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41212 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab3ISNG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:06:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 04/15] phy: omap-pipe3: use generic clock names
Date: Thu, 19 Sep 2013 16:05:32 +0300
Message-ID: <1379595943-14622-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1379595943-14622-1-git-send-email-rogerq@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

As this driver is no longer USB specific use generic clock names.

[Roger Q]
- Fix PLL_SD_SHIFT from 9 to 10
- As optclk and wkupclk may not be always required, don't bail out
if they aren't available.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-omap-pipe3.c |   71 +++++++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/phy/phy-omap-pipe3.c b/drivers/phy/phy-omap-pipe3.c
index 63de0f8..807ab8a 100644
--- a/drivers/phy/phy-omap-pipe3.c
+++ b/drivers/phy/phy-omap-pipe3.c
@@ -37,15 +37,15 @@
 #define	PLL_CONFIGURATION4	0x00000020
 
 #define	PLL_REGM_MASK		0x001FFE00
-#define	PLL_REGM_SHIFT		0x9
+#define	PLL_REGM_SHIFT		9
 #define	PLL_REGM_F_MASK		0x0003FFFF
-#define	PLL_REGM_F_SHIFT	0x0
+#define	PLL_REGM_F_SHIFT	0
 #define	PLL_REGN_MASK		0x000001FE
-#define	PLL_REGN_SHIFT		0x1
+#define	PLL_REGN_SHIFT		1
 #define	PLL_SELFREQDCO_MASK	0x0000000E
-#define	PLL_SELFREQDCO_SHIFT	0x1
+#define	PLL_SELFREQDCO_SHIFT	1
 #define	PLL_SD_MASK		0x0003FC00
-#define	PLL_SD_SHIFT		0x9
+#define	PLL_SD_SHIFT		10
 #define	SET_PLL_GO		0x1
 #define	PLL_TICOPWDN		0x10000
 #define	PLL_LOCK		0x2
@@ -232,23 +232,21 @@ static int omap_pipe3_probe(struct platform_device *pdev)
 
 	phy->dev		= &pdev->dev;
 
-	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
-	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
-		return PTR_ERR(phy->wkupclk);
-	}
-	clk_prepare(phy->wkupclk);
+	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
+	if (IS_ERR(phy->wkupclk))
+		dev_dbg(&pdev->dev, "unable to get wkupclk\n");
+	else
+		clk_prepare(phy->wkupclk);
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
-	if (IS_ERR(phy->optclk)) {
-		dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
-		return PTR_ERR(phy->optclk);
-	}
-	clk_prepare(phy->optclk);
+	phy->optclk = devm_clk_get(phy->dev, "optclk");
+	if (IS_ERR(phy->optclk))
+		dev_dbg(&pdev->dev, "unable to get optclk\n");
+	else
+		clk_prepare(phy->optclk);
 
-	phy->sys_clk = devm_clk_get(phy->dev, "sys_clkin");
+	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
 	if (IS_ERR(phy->sys_clk)) {
-		pr_err("%s: unable to get sys_clkin\n", __func__);
+		dev_err(&pdev->dev, "unable to get sysclk\n");
 		return -EINVAL;
 	}
 
@@ -290,8 +288,10 @@ static int omap_pipe3_remove(struct platform_device *pdev)
 {
 	struct omap_pipe3 *phy = platform_get_drvdata(pdev);
 
-	clk_unprepare(phy->wkupclk);
-	clk_unprepare(phy->optclk);
+	if (!IS_ERR(phy->wkupclk))
+		clk_unprepare(phy->wkupclk);
+	if (!IS_ERR(phy->optclk))
+		clk_unprepare(phy->optclk);
 	if (!pm_runtime_suspended(&pdev->dev))
 		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -305,8 +305,10 @@ static int omap_pipe3_runtime_suspend(struct device *dev)
 {
 	struct omap_pipe3	*phy = dev_get_drvdata(dev);
 
-	clk_disable(phy->wkupclk);
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->wkupclk))
+		clk_disable(phy->wkupclk);
+	if (!IS_ERR(phy->optclk))
+		clk_disable(phy->optclk);
 
 	return 0;
 }
@@ -316,22 +318,27 @@ static int omap_pipe3_runtime_resume(struct device *dev)
 	u32 ret = 0;
 	struct omap_pipe3	*phy = dev_get_drvdata(dev);
 
-	ret = clk_enable(phy->optclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
-		goto err1;
+	if (!IS_ERR(phy->optclk)) {
+		ret = clk_enable(phy->optclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
+			goto err1;
+		}
 	}
 
-	ret = clk_enable(phy->wkupclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
-		goto err2;
+	if (!IS_ERR(phy->wkupclk)) {
+		ret = clk_enable(phy->wkupclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+			goto err2;
+		}
 	}
 
 	return 0;
 
 err2:
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->optclk))
+		clk_disable(phy->optclk);
 
 err1:
 	return ret;
-- 
1.7.4.1

