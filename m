Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaGBMEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:04:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47287 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaGBMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:04:21 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 5/6] phy: omap-usb2: Balance pm_runtime_enable() on probe failure
Date: Wed, 2 Jul 2014 15:03:57 +0300
Message-ID: <1404302638-3003-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404302638-3003-1-git-send-email-rogerq@ti.com>
References: <1404302638-3003-1-git-send-email-rogerq@ti.com>
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

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-omap-usb2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..c6f9809 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -265,15 +265,19 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
-	if (IS_ERR(generic_phy))
+	if (IS_ERR(generic_phy)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(generic_phy);
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 			of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
+	if (IS_ERR(phy_provider)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(phy_provider);
+	}
 
 	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
-- 
1.8.3.2

