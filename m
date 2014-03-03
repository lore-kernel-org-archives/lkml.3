Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaCCPMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:12:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42214 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbaCCPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:08:22 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <tony@atomide.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 03/12] phy: ti-pipe3: cleanup clock handling
Date: Mon, 3 Mar 2014 17:07:25 +0200
Message-ID: <1393859254-10937-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393859254-10937-1-git-send-email-rogerq@ti.com>
References: <1393859254-10937-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this driver is no longer USB specific, use generic clock names.
- Fix PLL_SD_SHIFT from 9 to 10
- As optclk and wkupclk may not be always required, don't bail out
if they aren't available.
- Don't separate prepare/unprepare clock from enable/disable. This
ensures optimal power savings.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-ti-pipe3.c | 57 ++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 54859fc..3662e28 100644
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
@@ -270,23 +270,17 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
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
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
-	if (IS_ERR(phy->optclk)) {
-		dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
-		return PTR_ERR(phy->optclk);
-	}
-	clk_prepare(phy->optclk);
+	phy->optclk = devm_clk_get(phy->dev, "optclk");
+	if (IS_ERR(phy->optclk))
+		dev_dbg(&pdev->dev, "unable to get optclk\n");
 
-	phy->sys_clk = devm_clk_get(phy->dev, "sys_clkin");
+	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
 	if (IS_ERR(phy->sys_clk)) {
-		pr_err("%s: unable to get sys_clkin\n", __func__);
+		dev_err(&pdev->dev, "unable to get sysclk\n");
 		return -EINVAL;
 	}
 
@@ -326,10 +320,6 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 static int ti_pipe3_remove(struct platform_device *pdev)
 {
-	struct ti_pipe3 *phy = platform_get_drvdata(pdev);
-
-	clk_unprepare(phy->wkupclk);
-	clk_unprepare(phy->optclk);
 	if (!pm_runtime_suspended(&pdev->dev))
 		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -343,8 +333,10 @@ static int ti_pipe3_runtime_suspend(struct device *dev)
 {
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	clk_disable(phy->wkupclk);
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->wkupclk))
+		clk_disable_unprepare(phy->wkupclk);
+	if (!IS_ERR(phy->optclk))
+		clk_disable_unprepare(phy->optclk);
 
 	return 0;
 }
@@ -354,22 +346,27 @@ static int ti_pipe3_runtime_resume(struct device *dev)
 	u32 ret = 0;
 	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
-	ret = clk_enable(phy->optclk);
-	if (ret) {
-		dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
-		goto err1;
+	if (!IS_ERR(phy->optclk)) {
+		ret = clk_prepare_enable(phy->optclk);
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
+		ret = clk_prepare_enable(phy->wkupclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
+			goto err2;
+		}
 	}
 
 	return 0;
 
 err2:
-	clk_disable(phy->optclk);
+	if (!IS_ERR(phy->optclk))
+		clk_disable_unprepare(phy->optclk);
 
 err1:
 	return ret;
-- 
1.8.3.2

