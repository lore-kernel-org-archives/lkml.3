Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaGJGZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:25:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55133 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaGJGZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:29 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove
Date: Thu, 10 Jul 2014 11:55:03 +0530
Message-ID: <1404973503-3310-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404973503-3310-1-git-send-email-kishon@ti.com>
References: <1404973503-3310-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

If probe fails then we need to call pm_runtime_disable() to balance
out the previous pm_runtime_enable() call. Else it will cause
unbalanced pm_runtime_enable() call in the succeding probe call.

This anomaly was observed when the call to devm_phy_create() failed
with -EPROBE_DEFER.

Balance out the pm_runtime_enable() call in .remove() as well.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-usb2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 2063d54..34b3961 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -262,7 +262,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
-	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
 	if (IS_ERR(generic_phy))
@@ -270,10 +269,13 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	phy_set_drvdata(generic_phy, phy);
 
+	pm_runtime_enable(phy->dev);
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 			of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
+	if (IS_ERR(phy_provider)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(phy_provider);
+	}
 
 	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
@@ -317,6 +319,7 @@ static int omap_usb2_remove(struct platform_device *pdev)
 	if (!IS_ERR(phy->optclk))
 		clk_unprepare(phy->optclk);
 	usb_remove_phy(&phy->phy);
+	pm_runtime_disable(phy->dev);
 
 	return 0;
 }
-- 
1.7.9.5

