Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3EJJpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:45:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3EJJpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:45:18 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] usb: phy: Fix NULL pointer exception during usb_get_phy
Date: Fri, 10 May 2013 15:15:08 +0530
Message-ID: <1368179108-13139-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Jarzmik <robert.jarzmik@free.fr>

Upon initialisation (driver probe) a NULL pointer exception
is triggered. This is due to lack of initialisation of
device field in phy structure, which is used by phy
framework in usb_get_phy().

Fix it by initialising the device field.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/phy-fsl-usb.c       |    1 +
 drivers/usb/phy/phy-gpio-vbus-usb.c |    1 +
 drivers/usb/phy/phy-isp1301.c       |    1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index 97b9308..e771baf 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -799,6 +799,7 @@ static int fsl_otg_conf(struct platform_device *pdev)
 
 	/* initialize the otg structure */
 	fsl_otg_tc->phy.label = DRIVER_DESC;
+	fsl_otg_tc->phy.dev = &pdev->dev;
 	fsl_otg_tc->phy.set_power = fsl_otg_set_power;
 
 	fsl_otg_tc->phy.otg->phy = &fsl_otg_tc->phy;
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index 4c76074..e014b38 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -266,6 +266,7 @@ static int __init gpio_vbus_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gpio_vbus);
 	gpio_vbus->dev = &pdev->dev;
 	gpio_vbus->phy.label = "gpio-vbus";
+	gpio_vbus->phy.dev = gpio_vbus->dev;
 	gpio_vbus->phy.set_power = gpio_vbus_set_power;
 	gpio_vbus->phy.set_suspend = gpio_vbus_set_suspend;
 	gpio_vbus->phy.state = OTG_STATE_UNDEFINED;
diff --git a/drivers/usb/phy/phy-isp1301.c b/drivers/usb/phy/phy-isp1301.c
index 225ae6c..8a55b37 100644
--- a/drivers/usb/phy/phy-isp1301.c
+++ b/drivers/usb/phy/phy-isp1301.c
@@ -102,6 +102,7 @@ static int isp1301_probe(struct i2c_client *client,
 	mutex_init(&isp->mutex);
 
 	phy = &isp->phy;
+	phy->dev = &client->dev;
 	phy->label = DRV_NAME;
 	phy->init = isp1301_phy_init;
 	phy->set_vbus = isp1301_phy_set_vbus;
-- 
1.7.10.4

