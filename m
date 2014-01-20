Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaATJHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:07:53 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62160 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaATJHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:07:07 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: [PATCH 1/2] serial: samsung: Move uart_register_driver call to device probe
Date: Mon, 20 Jan 2014 14:32:34 +0530
Message-Id: <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart_register_driver call binds the driver to a specific device
node through tty_register_driver call. This should typically happen
during device probe call.

In a multiplatform scenario, it is possible that multiple serial
drivers are part of the kernel. Currently the driver registration fails
if multiple serial drivers with same default major/minor numbers are
included in the kernel.

A typical case is observed with amba-pl011 and samsung-uart drivers.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/tty/serial/samsung.c |   40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c1af04d..f8f41dc 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1283,6 +1283,14 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto probe_err;
 
+	if (!s3c24xx_uart_drv.state) {
+		ret = uart_register_driver(&s3c24xx_uart_drv);
+		if (ret < 0) {
+			pr_err("Failed to register Samsung UART driver\n");
+			return ret;
+		}
+	}
+
 	dbg("%s: adding port\n", __func__);
 	uart_add_one_port(&s3c24xx_uart_drv, &ourport->port);
 	platform_set_drvdata(pdev, &ourport->port);
@@ -1315,6 +1323,8 @@ static int s3c24xx_serial_remove(struct platform_device *dev)
 		uart_remove_one_port(&s3c24xx_uart_drv, port);
 	}
 
+	uart_unregister_driver(&s3c24xx_uart_drv);
+
 	return 0;
 }
 
@@ -1814,35 +1824,7 @@ static struct platform_driver samsung_serial_driver = {
 	},
 };
 
-/* module initialisation code */
-
-static int __init s3c24xx_serial_modinit(void)
-{
-	int ret;
-
-	ret = uart_register_driver(&s3c24xx_uart_drv);
-	if (ret < 0) {
-		pr_err("Failed to register Samsung UART driver\n");
-		return ret;
-	}
-
-	ret = platform_driver_register(&samsung_serial_driver);
-	if (ret < 0) {
-		pr_err("Failed to register platform driver\n");
-		uart_unregister_driver(&s3c24xx_uart_drv);
-	}
-
-	return ret;
-}
-
-static void __exit s3c24xx_serial_modexit(void)
-{
-	platform_driver_unregister(&samsung_serial_driver);
-	uart_unregister_driver(&s3c24xx_uart_drv);
-}
-
-module_init(s3c24xx_serial_modinit);
-module_exit(s3c24xx_serial_modexit);
+module_platform_driver(samsung_serial_driver);
 
 MODULE_ALIAS("platform:samsung-uart");
 MODULE_DESCRIPTION("Samsung SoC Serial port driver");
-- 
1.7.9.5

