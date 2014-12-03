Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaLCLlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:41:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaLCL1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/101] pcmcia: at91_cf: fix deferred probe from __init
Date: Wed,  3 Dec 2014 12:26:38 +0100
Message-Id: <ae04c8258c710aefb297b079a84ccbec318822d4.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 16a7c7cfd21cca8a260b63467e4f5c6a6d548b09 upstream.

Move probe out of __init section and don't use platform_driver_probe
which cannot be used with deferred probing.

Since commit e9354576 ("gpiolib: Defer failed gpio requests by default")
this driver might return -EPROBE_DEFER if a gpio_request fails.

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pcmcia/at91_cf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index b8f5acf02261..de24232c5191 100644
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
2.1.3

