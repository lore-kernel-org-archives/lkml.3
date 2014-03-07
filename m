Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaCGF5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:57:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38813 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaCGF5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:57:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v3] phy: ti-pipe3: cleanup clock handling
Date: Fri, 7 Mar 2014 11:27:09 +0530
Message-ID: <1394171829-13577-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

As this driver is no longer USB specific, use generic clock names.
- Fix PLL_SD_SHIFT from 9 to 10
- Don't separate prepare/unprepare clock from enable/disable. This
  ensures optimal power savings.

Signed-off-by: Roger Quadros <rogerq@ti.com> 
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v2:
* Kept only the drivers/phy part in this patch

 drivers/phy/phy-ti-pipe3.c |   55 ++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index fd029b1..211703c 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -45,7 +45,7 @@
 #define	PLL_SELFREQDCO_MASK	0x0000000E
 #define	PLL_SELFREQDCO_SHIFT	0x1
 #define	PLL_SD_MASK		0x0003FC00
-#define	PLL_SD_SHIFT		0x9
+#define	PLL_SD_SHIFT		10
 #define	SET_PLL_GO		0x1
 #define	PLL_TICOPWDN		0x10000
 #define	PLL_LOCK		0x2
@@ -72,7 +72,7 @@ struct ti_pipe3 {
 	struct device		*control_dev;
 	struct clk		*wkupclk;
 	struct clk		*sys_clk;
-	struct clk		*optclk;
+	struct clk		*refclk;
 };
 
 struct pipe3_dpll_map {
@@ -270,23 +270,21 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 	phy->dev		= &pdev->dev;
 
-	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+		dev_err(&pdev->dev, "unable to get wkupclk\n");
 		return PTR_ERR(phy->wkupclk);
 	}
-	clk_prepare(phy->wkupclk);
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
-	if (IS_ERR(phy->optclk)) {
-		dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
-		return PTR_ERR(phy->optclk);
+	phy->refclk = devm_clk_get(phy->dev, "refclk");
+	if (IS_ERR(phy->refclk)) {
+		dev_err(&pdev->dev, "unable to get refclk\n");
+		return PTR_ERR(phy->refclk);
 	}
-	clk_prepare(phy->optclk);
 
-	phy->sys_clk = devm_clk_get(phy->dev, "sys_clkin");
+	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
 	if (IS_ERR(phy->sys_clk)) {
-		pr_err("%s: unable to get sys_clkin\n", __func__);
+		dev_err(&pdev->dev, "unable to get sysclk\n");
 		return -EINVAL;
 	}
 
@@ -326,10 +324,6 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 static int ti_pipe3_remove(struct platform_device *pdev)
 {
-	struct ti_pipe3 *phy = platform_get_drvdata(pdev);
-
-	clk_unprepare(phy->wkupclk);
-	clk_unprepare(phy->optclk);
 	if (!pm_runtime_suspended(&pdev->dev))
 		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -343,8 +337,10 @@ static int ti_pipe3_runtime_suspend(struct device *dev)
 {
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	clk_disable(phy->wkupclk);
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->wkupclk))
+		clk_disable_unprepare(phy->wkupclk);
+	if (!IS_ERR(phy->refclk))
+		clk_disable_unprepare(phy->refclk);
 
 	return 0;
 }
@@ -354,22 +350,27 @@ static int ti_pipe3_runtime_resume(struct device *dev)
 	u32 ret = 0;
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	ret = clk_enable(phy->optclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
-		goto err1;
+	if (!IS_ERR(phy->refclk)) {
+		ret = clk_prepare_enable(phy->refclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
+			goto err1;
+		}
 	}
 
-	ret = clk_enable(phy->wkupclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
-		goto err2;
+	if (!IS_ERR(phy->wkupclk)) {
+		ret = clk_prepare_enable(phy->wkupclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+			goto err2;
+		}
 	}
 
 	return 0;
 
 err2:
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->refclk))
+		clk_disable_unprepare(phy->refclk);
 
 err1:
 	return ret;
-- 
1.7.9.5

