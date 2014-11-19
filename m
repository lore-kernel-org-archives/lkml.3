Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaKSP2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:28:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:1978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbaKSP2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:28:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639756164"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv5 3/7] phy: twl4030: use the new lookup method
Date: Wed, 19 Nov 2014 17:28:19 +0200
Message-Id: <1416410903-162369-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creates the lookup separately. Hard coding the consumer as
it can't be anything else except musb.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/phy/phy-twl4030-usb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index e2698d29..0d20fe0 100644
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
2.1.3

