Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3IWO3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:29:52 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40549 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3IWO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:27:56 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pcmcia@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 6/7] usb: phy: gpio-vbus: fix deferred probe from __init
Date: Mon, 23 Sep 2013 16:27:31 +0200
Message-Id: <1379946452-25649-7-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379946452-25649-1-git-send-email-jhovold@gmail.com>
References: <20130923134028.GF21013@sirena.org.uk>
 <1379946452-25649-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move probe out of __init section and don't use platform_driver_probe
which cannot be used with deferred probing.

Since commit e9354576 ("gpiolib: Defer failed gpio requests by default")
and 04bf3011 ("regulator: Support driver probe deferral") this driver
might return -EPROBE_DEFER if a gpio_request or regulator_get fails.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/phy/phy-gpio-vbus-usb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index b2f29c9..02799a5 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -241,7 +241,7 @@ static int gpio_vbus_set_suspend(struct usb_phy *phy, int suspend)
 
 /* platform driver interface */
 
-static int __init gpio_vbus_probe(struct platform_device *pdev)
+static int gpio_vbus_probe(struct platform_device *pdev)
 {
 	struct gpio_vbus_mach_info *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_vbus_data *gpio_vbus;
@@ -349,7 +349,7 @@ err_gpio:
 	return err;
 }
 
-static int __exit gpio_vbus_remove(struct platform_device *pdev)
+static int gpio_vbus_remove(struct platform_device *pdev)
 {
 	struct gpio_vbus_data *gpio_vbus = platform_get_drvdata(pdev);
 	struct gpio_vbus_mach_info *pdata = dev_get_platdata(&pdev->dev);
@@ -398,8 +398,6 @@ static const struct dev_pm_ops gpio_vbus_dev_pm_ops = {
 };
 #endif
 
-/* NOTE:  the gpio-vbus device may *NOT* be hotplugged */
-
 MODULE_ALIAS("platform:gpio-vbus");
 
 static struct platform_driver gpio_vbus_driver = {
@@ -410,10 +408,11 @@ static struct platform_driver gpio_vbus_driver = {
 		.pm = &gpio_vbus_dev_pm_ops,
 #endif
 	},
-	.remove  = __exit_p(gpio_vbus_remove),
+	.probe		= gpio_vbus_probe,
+	.remove		= gpio_vbus_remove,
 };
 
-module_platform_driver_probe(gpio_vbus_driver, gpio_vbus_probe);
+module_platform_driver(gpio_vbus_driver);
 
 MODULE_DESCRIPTION("simple GPIO controlled OTG transceiver driver");
 MODULE_AUTHOR("Philipp Zabel");
-- 
1.8.3.2

