Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbbAMMYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:24:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57426 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbAMMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:23:34 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 2/4] phy: ti-pipe3: Fix SATA across suspend/resume
Date: Tue, 13 Jan 2015 14:23:20 +0200
Message-ID: <1421151802-7396-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421151802-7396-1-git-send-email-rogerq@ti.com>
References: <1421151802-7396-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failed test case: Boot without SATA drive connected. Suspend/resume
the board and then connect SATA drive. It fails to enumerate.

Due to Errata i783 "SATA Lockup After SATA DPLL Unlock/Relock"
we can't allow SATA DPLL to be in the unlocked state.
The SATA refclk (sata_ref_clk) is the source of the SATA_DPLL.
This clock is being controlled only by the AHCI SATA driver and is
shut off during system suspend (if the SATA drive was not already attached)
causing the SATA DPLL to be unlocked and so causing errata i783.

To prevent sata_ref_clk from being disabled, we add the control of
this clock to the SATA PHY driver and prevent it from being disabled.

This also fixes the issue of SATA not working on OMAP5/DRA7 when
AHCI platform driver is built as a module.

NOTE: Device tree changes also required for OMAP5 & DRA7.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-ti-pipe3.c | 57 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index e60ff14..456dec2 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -85,6 +85,7 @@ struct ti_pipe3 {
 	struct pipe3_dpll_map	*dpll_map;
 	u8			id;
 	bool enabled;
+	bool refclk_enabled;	/* this flag is needed specifically for SATA */
 	spinlock_t lock;	/* serialize clock enable/disable */
 };
 
@@ -333,21 +334,24 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 		}
 	}
 
+	phy->refclk = devm_clk_get(phy->dev, "refclk");
+	if (IS_ERR(phy->refclk)) {
+		dev_err(&pdev->dev, "unable to get refclk\n");
+		/* older DTBs have missing refclk in SATA PHY
+		 * so don't bail out in case of SATA PHY.
+		 */
+		if (!of_device_is_compatible(node, "ti,phy-pipe3-sata"))
+			return PTR_ERR(phy->refclk);
+	}
+
 	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
 		phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 		if (IS_ERR(phy->wkupclk)) {
 			dev_err(&pdev->dev, "unable to get wkupclk\n");
 			return PTR_ERR(phy->wkupclk);
 		}
-
-		phy->refclk = devm_clk_get(phy->dev, "refclk");
-		if (IS_ERR(phy->refclk)) {
-			dev_err(&pdev->dev, "unable to get refclk\n");
-			return PTR_ERR(phy->refclk);
-		}
 	} else {
 		phy->wkupclk = ERR_PTR(-ENODEV);
-		phy->refclk = ERR_PTR(-ENODEV);
 	}
 
 	if (of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
@@ -428,6 +432,29 @@ static int ti_pipe3_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
+static int ti_pipe3_enable_refclk(struct ti_pipe3 *phy)
+{
+	if (!IS_ERR(phy->refclk) && !phy->refclk_enabled) {
+		int ret;
+
+		ret = clk_prepare_enable(phy->refclk);
+		if (ret) {
+			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
+			return ret;
+		}
+		phy->refclk_enabled = true;
+	}
+
+	return 0;
+}
+
+static void ti_pipe3_disable_refclk(struct ti_pipe3 *phy)
+{
+	if (!IS_ERR(phy->refclk))
+		clk_disable_unprepare(phy->refclk);
+
+	phy->refclk_enabled = false;
+}
 
 static int ti_pipe3_enable_clocks(struct ti_pipe3 *phy)
 {
@@ -438,13 +465,9 @@ static int ti_pipe3_enable_clocks(struct ti_pipe3 *phy)
 	if (phy->enabled)
 		goto err1;
 
-	if (!IS_ERR(phy->refclk)) {
-		ret = clk_prepare_enable(phy->refclk);
-		if (ret) {
-			dev_err(phy->dev, "Failed to enable refclk %d\n", ret);
-			goto err1;
-		}
-	}
+	ret = ti_pipe3_enable_refclk(phy);
+	if (ret)
+		goto err1;
 
 	if (!IS_ERR(phy->wkupclk)) {
 		ret = clk_prepare_enable(phy->wkupclk);
@@ -474,6 +497,7 @@ err2:
 	if (!IS_ERR(phy->refclk))
 		clk_disable_unprepare(phy->refclk);
 
+	ti_pipe3_disable_refclk(phy);
 err1:
 	spin_unlock_irqrestore(&phy->lock, flags);
 	return ret;
@@ -491,8 +515,9 @@ static void ti_pipe3_disable_clocks(struct ti_pipe3 *phy)
 
 	if (!IS_ERR(phy->wkupclk))
 		clk_disable_unprepare(phy->wkupclk);
-	if (!IS_ERR(phy->refclk))
-		clk_disable_unprepare(phy->refclk);
+	/* Don't disable refclk for SATA PHY due to Errata i783 */
+	if (!of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
+		ti_pipe3_disable_refclk(phy);
 	if (!IS_ERR(phy->div_clk))
 		clk_disable_unprepare(phy->div_clk);
 	phy->enabled = false;
-- 
2.1.0

