Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3KHSvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:51:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35788 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab3KHSvj (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Fri, 8 Nov 2013 13:51:39 -0500
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Fri,  8 Nov 2013 18:51:26 +0000
Message-Id: <1383936686-24041-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383936686-24041-1-git-send-email-broonie@kernel.org>
References: <1383936686-24041-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 86.134.146.207
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm831x: Use PM ops for shutdown
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

This helps move us towards removing the bus custom operations.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/wm831x-i2c.c | 8 +++++---
 drivers/mfd/wm831x-spi.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index 2b29cae..a4cbefe 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -64,11 +64,13 @@ static int wm831x_i2c_suspend(struct device *dev)
 	return wm831x_device_suspend(wm831x);
 }
 
-static void wm831x_i2c_shutdown(struct i2c_client *i2c)
+static int wm831x_i2c_poweroff(struct device *dev)
 {
-	struct wm831x *wm831x = i2c_get_clientdata(i2c);
+	struct wm831x *wm831x = dev_get_drvdata(dev);
 
 	wm831x_device_shutdown(wm831x);
+
+	return 0;
 }
 
 static const struct i2c_device_id wm831x_i2c_id[] = {
@@ -85,6 +87,7 @@ MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
 
 static const struct dev_pm_ops wm831x_pm_ops = {
 	.suspend = wm831x_i2c_suspend,
+	.poweroff = wm831x_i2c_poweroff,
 };
 
 static struct i2c_driver wm831x_i2c_driver = {
@@ -95,7 +98,6 @@ static struct i2c_driver wm831x_i2c_driver = {
 	},
 	.probe = wm831x_i2c_probe,
 	.remove = wm831x_i2c_remove,
-	.shutdown = wm831x_i2c_shutdown,
 	.id_table = wm831x_i2c_id,
 };
 
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 07de3cc..b8a5e3b 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -66,16 +66,19 @@ static int wm831x_spi_suspend(struct device *dev)
 	return wm831x_device_suspend(wm831x);
 }
 
-static void wm831x_spi_shutdown(struct spi_device *spi)
+static int wm831x_spi_poweroff(struct device *dev)
 {
-	struct wm831x *wm831x = spi_get_drvdata(spi);
+	struct wm831x *wm831x = dev_get_drvdata(dev);
 
 	wm831x_device_shutdown(wm831x);
+
+	return 0;
 }
 
 static const struct dev_pm_ops wm831x_spi_pm = {
 	.freeze = wm831x_spi_suspend,
 	.suspend = wm831x_spi_suspend,
+	.poweroff = wm831x_spi_poweroff,
 };
 
 static const struct spi_device_id wm831x_spi_ids[] = {
@@ -99,7 +102,6 @@ static struct spi_driver wm831x_spi_driver = {
 	.id_table	= wm831x_spi_ids,
 	.probe		= wm831x_spi_probe,
 	.remove		= wm831x_spi_remove,
-	.shutdown	= wm831x_spi_shutdown,
 };
 
 static int __init wm831x_spi_init(void)
-- 
1.8.4.2

