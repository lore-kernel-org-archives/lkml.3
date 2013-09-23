Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3IWO2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:28:31 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43871 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3IWO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:27:58 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pcmcia@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/7] pcmcia: at91_cf: fix deferred probe from __init
Date: Mon, 23 Sep 2013 16:27:29 +0200
Message-Id: <1379946452-25649-5-git-send-email-jhovold@gmail.com>
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

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/pcmcia/at91_cf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index b8f5acf..de24232 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -245,7 +245,7 @@ static int at91_cf_dt_init(struct platform_device *pdev)
 }
 #endif
 
-static int __init at91_cf_probe(struct platform_device *pdev)
+static int at91_cf_probe(struct platform_device *pdev)
 {
 	struct at91_cf_socket	*cf;
 	struct at91_cf_data	*board = pdev->dev.platform_data;
@@ -354,7 +354,7 @@ fail0a:
 	return status;
 }
 
-static int __exit at91_cf_remove(struct platform_device *pdev)
+static int at91_cf_remove(struct platform_device *pdev)
 {
 	struct at91_cf_socket	*cf = platform_get_drvdata(pdev);
 
@@ -404,14 +404,13 @@ static struct platform_driver at91_cf_driver = {
 		.owner		= THIS_MODULE,
 		.of_match_table = of_match_ptr(at91_cf_dt_ids),
 	},
-	.remove		= __exit_p(at91_cf_remove),
+	.probe		= at91_cf_probe,
+	.remove		= at91_cf_remove,
 	.suspend	= at91_cf_suspend,
 	.resume		= at91_cf_resume,
 };
 
-/*--------------------------------------------------------------------------*/
-
-module_platform_driver_probe(at91_cf_driver, at91_cf_probe);
+module_platform_driver(at91_cf_driver);
 
 MODULE_DESCRIPTION("AT91 Compact Flash Driver");
 MODULE_AUTHOR("David Brownell");
-- 
1.8.3.2

