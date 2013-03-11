Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3CKRnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:43:11 -0400
Received: from smtp-out-222.synserver.de ([212.40.185.222]:1073 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3CKRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:43:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32201
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/4] tty: max310x: Use dev_pm_ops
Date: Mon, 11 Mar 2013 18:44:50 +0100
Message-Id: <1363023892-15957-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1363023892-15957-1-git-send-email-lars@metafoo.de>
References: <1363023892-15957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume for the
max310x driver.

Cc: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/tty/serial/max310x.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 0c2422c..8941e64 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -881,12 +881,14 @@ static struct uart_ops max310x_ops = {
 	.verify_port	= max310x_verify_port,
 };
 
-static int max310x_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+
+static int max310x_suspend(struct device *dev)
 {
 	int ret;
-	struct max310x_port *s = dev_get_drvdata(&spi->dev);
+	struct max310x_port *s = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "Suspend\n");
+	dev_dbg(dev, "Suspend\n");
 
 	ret = uart_suspend_port(&s->uart, &s->port);
 
@@ -905,11 +907,11 @@ static int max310x_suspend(struct spi_device *spi, pm_message_t state)
 	return ret;
 }
 
-static int max310x_resume(struct spi_device *spi)
+static int max310x_resume(struct device *dev)
 {
-	struct max310x_port *s = dev_get_drvdata(&spi->dev);
+	struct max310x_port *s = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "Resume\n");
+	dev_dbg(dev, "Resume\n");
 
 	if (s->pdata->suspend)
 		s->pdata->suspend(0);
@@ -928,6 +930,13 @@ static int max310x_resume(struct spi_device *spi)
 	return uart_resume_port(&s->uart, &s->port);
 }
 
+static SIMPLE_DEV_PM_OPS(max310x_pm_ops, max310x_suspend, max310x_resume);
+#define MAX310X_PM_OPS (&max310x_pm_ops)
+
+#else
+#define MAX310X_PM_OPS NULL
+#endif
+
 #ifdef CONFIG_GPIOLIB
 static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
@@ -1242,11 +1251,10 @@ static struct spi_driver max310x_driver = {
 	.driver = {
 		.name	= "max310x",
 		.owner	= THIS_MODULE,
+		.pm	= MAX310X_PM_OPS,
 	},
 	.probe		= max310x_probe,
 	.remove		= max310x_remove,
-	.suspend	= max310x_suspend,
-	.resume		= max310x_resume,
 	.id_table	= max310x_id_table,
 };
 module_spi_driver(max310x_driver);
-- 
1.8.0

