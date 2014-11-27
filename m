Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaK0G0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34497 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaK0G0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:44 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/25] phy: twl4030: use the new lookup method
Date: Thu, 27 Nov 2014 11:56:08 +0530
Message-ID: <1417069577-1169-17-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Creates the lookup separately. Hard coding the consumer as
it can't be anything else except musb.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 7b04bef..c45a3aa 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -644,7 +644,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
 	struct phy_provider	*phy_provider;
-	struct phy_init_data	*init_data = NULL;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
 	if (!twl)
@@ -655,7 +654,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 				(enum twl4030_usb_mode *)&twl->usb_mode);
 	else if (pdata) {
 		twl->usb_mode = pdata->usb_mode;
-		init_data = pdata->init_data;
 	} else {
 		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
 		return -EINVAL;
@@ -680,7 +678,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
-	phy = devm_phy_create(twl->dev, NULL, &ops, init_data);
+	phy = devm_phy_create(twl->dev, NULL, &ops, NULL);
 	if (IS_ERR(phy)) {
 		dev_dbg(&pdev->dev, "Failed to create PHY\n");
 		return PTR_ERR(phy);
@@ -733,6 +731,11 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		return status;
 	}
 
+	if (pdata)
+		err = phy_create_lookup(phy, "usb", "musb-hdrc.0");
+	if (err)
+		return err;
+
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(twl->dev);
 
-- 
1.7.9.5

