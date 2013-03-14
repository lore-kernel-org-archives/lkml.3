Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3CNGYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:24:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42314 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3CNGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:24:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 2/4] usb: otg: twl4030: use devres API for regulator get and request irq
Date: Thu, 14 Mar 2013 11:53:57 +0530
Message-ID: <1363242239-1061-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363242239-1061-1-git-send-email-kishon@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used devres APIs devm_request_threaded_irq and devm_regulator_get for
requesting irq and for getting regulator respectively.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/twl4030-usb.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 04b732e2..5b20bb4 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -470,7 +470,7 @@ static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 	/* Initialize 3.1V regulator */
 	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
 
-	twl->usb3v1 = regulator_get(twl->dev, "usb3v1");
+	twl->usb3v1 = devm_regulator_get(twl->dev, "usb3v1");
 	if (IS_ERR(twl->usb3v1))
 		return -ENODEV;
 
@@ -479,18 +479,18 @@ static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 	/* Initialize 1.5V regulator */
 	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
 
-	twl->usb1v5 = regulator_get(twl->dev, "usb1v5");
+	twl->usb1v5 = devm_regulator_get(twl->dev, "usb1v5");
 	if (IS_ERR(twl->usb1v5))
-		goto fail1;
+		return -ENODEV;
 
 	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
 
 	/* Initialize 1.8V regulator */
 	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
 
-	twl->usb1v8 = regulator_get(twl->dev, "usb1v8");
+	twl->usb1v8 = devm_regulator_get(twl->dev, "usb1v8");
 	if (IS_ERR(twl->usb1v8))
-		goto fail2;
+		return -ENODEV;
 
 	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
@@ -499,14 +499,6 @@ static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 			 TWL4030_PM_MASTER_PROTECT_KEY);
 
 	return 0;
-
-fail2:
-	regulator_put(twl->usb1v5);
-	twl->usb1v5 = NULL;
-fail1:
-	regulator_put(twl->usb3v1);
-	twl->usb3v1 = NULL;
-	return -ENODEV;
 }
 
 static ssize_t twl4030_usb_vbus_show(struct device *dev,
@@ -695,9 +687,9 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	 * need both handles, otherwise just one suffices.
 	 */
 	twl->irq_enabled = true;
-	status = request_threaded_irq(twl->irq, NULL, twl4030_usb_irq,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
-			IRQF_ONESHOT, "twl4030_usb", twl);
+	status = devm_request_threaded_irq(twl->dev, twl->irq, NULL,
+			twl4030_usb_irq, IRQF_TRIGGER_FALLING |
+			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "twl4030_usb", twl);
 	if (status < 0) {
 		dev_dbg(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq, status);
@@ -716,7 +708,6 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 	int val;
 
 	cancel_delayed_work(&twl->id_workaround_work);
-	free_irq(twl->irq, twl);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
 	/* set transceiver mode to power on defaults */
@@ -738,9 +729,6 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 
 	if (!twl->asleep)
 		twl4030_phy_power(twl, 0);
-	regulator_put(twl->usb1v5);
-	regulator_put(twl->usb1v8);
-	regulator_put(twl->usb3v1);
 
 	return 0;
 }
-- 
1.7.10.4

