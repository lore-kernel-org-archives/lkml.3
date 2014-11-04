Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKDGRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:17:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50130 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKDGRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:17:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
Date: Tue, 4 Nov 2014 11:47:06 +0530
Message-ID: <1415081826-9297-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ghorbel@pivasoftware.com>

The USB OTG port does not work since v3.16 on omap platform.
This is a regression introduced by the commit
eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
 and remove).
This because the call to pm_runtime_enable() function is moved after the
call to devm_phy_create() function, which has side effect since later in
the subsequent calls of devm_phy_create() there is a check with
pm_runtime_enabled() to configure few things.

Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
Tested-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-usb2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 8c84298..f091576 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -258,14 +258,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
-	if (IS_ERR(generic_phy))
+	if (IS_ERR(generic_phy)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(generic_phy);
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
-	pm_runtime_enable(phy->dev);
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 			of_phy_simple_xlate);
 	if (IS_ERR(phy_provider)) {
-- 
1.7.9.5

