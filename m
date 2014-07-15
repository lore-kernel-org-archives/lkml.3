Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaGORIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37012 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 75/94] phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove
Date: Tue, 15 Jul 2014 20:01:30 +0300
Message-Id: <1405443709-15288-75-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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
1.7.10.4

