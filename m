Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbaGDJ7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:59:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33864 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030275AbaGDJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:13 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 5/6] phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove
Date: Fri, 4 Jul 2014 12:55:47 +0300
Message-ID: <1404467748-12154-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404467748-12154-1-git-send-email-rogerq@ti.com>
References: <1404467748-12154-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If probe fails then we need to call pm_runtime_disable() to balance
out the previous pm_runtime_enable() call. Else it will cause
unbalanced pm_runtime_enable() call in the succeding probe call.

This anomaly was observed when the call to devm_phy_create() failed
with -EPROBE_DEFER.

Balance out the pm_runtime_enable() call in .remove() as well.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-omap-usb2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..3a1d00e 100644
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
1.8.3.2

