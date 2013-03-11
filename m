Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3CKRoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:44:00 -0400
Received: from smtp-out-222.synserver.de ([212.40.185.222]:1075 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:43:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32201
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/4] tty: mrst_max3110: Use dev_pm_ops
Date: Mon, 11 Mar 2013 18:44:51 +0100
Message-Id: <1363023892-15957-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1363023892-15957-1-git-send-email-lars@metafoo.de>
References: <1363023892-15957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume for the
mrst_max3110 driver.

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/tty/serial/mrst_max3110.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index f641c23..9b6ef20 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -743,9 +743,10 @@ static struct uart_driver serial_m3110_reg = {
 	.cons		= &serial_m3110_console,
 };
 
-#ifdef CONFIG_PM
-static int serial_m3110_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int serial_m3110_suspend(struct device *dev)
 {
+	struct spi_device *spi = to_spi_device(dev);
 	struct uart_max3110 *max = spi_get_drvdata(spi);
 
 	disable_irq(max->irq);
@@ -754,8 +755,9 @@ static int serial_m3110_suspend(struct spi_device *spi, pm_message_t state)
 	return 0;
 }
 
-static int serial_m3110_resume(struct spi_device *spi)
+static int serial_m3110_resume(struct device *dev)
 {
+	struct spi_device *spi = to_spi_device(dev);
 	struct uart_max3110 *max = spi_get_drvdata(spi);
 
 	max3110_out(max, max->cur_conf);
@@ -763,9 +765,13 @@ static int serial_m3110_resume(struct spi_device *spi)
 	enable_irq(max->irq);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(serial_m3110_pm_ops, serial_m3110_suspend,
+			serial_m3110_resume);
+#define SERIAL_M3110_PM_OPS (&serial_m3110_pm_ops)
+
 #else
-#define serial_m3110_suspend	NULL
-#define serial_m3110_resume	NULL
+#define SERIAL_M3110_PM_OPS NULL
 #endif
 
 static int serial_m3110_probe(struct spi_device *spi)
@@ -872,11 +878,10 @@ static struct spi_driver uart_max3110_driver = {
 	.driver = {
 			.name	= "spi_max3111",
 			.owner	= THIS_MODULE,
+			.pm	= SERIAL_M3110_PM_OPS,
 	},
 	.probe		= serial_m3110_probe,
 	.remove		= serial_m3110_remove,
-	.suspend	= serial_m3110_suspend,
-	.resume		= serial_m3110_resume,
 };
 
 static int __init serial_m3110_init(void)
-- 
1.8.0

