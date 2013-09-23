Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3IWO2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:28:34 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35539 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3IWO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:27:58 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pcmcia@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 5/7] usb: gadget: pxa25x_udc: fix deferred probe from __init
Date: Mon, 23 Sep 2013 16:27:30 +0200
Message-Id: <1379946452-25649-6-git-send-email-jhovold@gmail.com>
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
this driver might return -EPROBE_DEFER if a gpio_request fails.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/gadget/pxa25x_udc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index cc92074..0ac6064 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -2054,7 +2054,7 @@ static struct pxa25x_udc memory = {
 /*
  *	probe - binds to the platform device
  */
-static int __init pxa25x_udc_probe(struct platform_device *pdev)
+static int pxa25x_udc_probe(struct platform_device *pdev)
 {
 	struct pxa25x_udc *dev = &memory;
 	int retval, irq;
@@ -2203,7 +2203,7 @@ static void pxa25x_udc_shutdown(struct platform_device *_dev)
 	pullup_off();
 }
 
-static int __exit pxa25x_udc_remove(struct platform_device *pdev)
+static int pxa25x_udc_remove(struct platform_device *pdev)
 {
 	struct pxa25x_udc *dev = platform_get_drvdata(pdev);
 
@@ -2294,7 +2294,8 @@ static int pxa25x_udc_resume(struct platform_device *dev)
 
 static struct platform_driver udc_driver = {
 	.shutdown	= pxa25x_udc_shutdown,
-	.remove		= __exit_p(pxa25x_udc_remove),
+	.probe		= pxa25x_udc_probe,
+	.remove		= pxa25x_udc_remove,
 	.suspend	= pxa25x_udc_suspend,
 	.resume		= pxa25x_udc_resume,
 	.driver		= {
@@ -2303,7 +2304,7 @@ static struct platform_driver udc_driver = {
 	},
 };
 
-module_platform_driver_probe(udc_driver, pxa25x_udc_probe);
+module_platform_driver(udc_driver);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Frank Becker, Robert Schwebel, David Brownell");
-- 
1.8.3.2

