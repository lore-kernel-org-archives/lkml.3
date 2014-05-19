Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaESP6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:58:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36514 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaESP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:58:52 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: [PATCH] rtc: fix potential race condition and remove build errors
Date: Mon, 19 May 2014 21:28:20 +0530
Message-Id: <1400515100-9185-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes the following build errors reported by kbuild test
robot by selecting REGMAP_SPI in Kconfig file

>drivers/built-in.o: In function `ds1343_probe':
>rtc-ds1343.c:(.text+0x1baf8f): undefined reference to `devm_regmap_init_spi'

also it avoids the potential race condition by avoiding
bailing out of driver in probe after registering with
rtc subsystem

also the set_alarm , read_alarm and
alarm_irq_enable returns error if irq registration
fails in probe

also the sysfs will not create entry for alarm if
irq registration fails in probe

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/rtc/Kconfig      |  1 +
 drivers/rtc/rtc-ds1343.c | 38 ++++++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index ae78408..0754f5c 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -574,6 +574,7 @@ config RTC_DRV_DS1305
 	  will be called rtc-ds1305.
 
 config RTC_DRV_DS1343
+	select REGMAP_SPI
 	tristate "Dallas/Maxim DS1343/DS1344"
 	help
 	  If you say yes here you get support for the
diff --git a/drivers/rtc/rtc-ds1343.c b/drivers/rtc/rtc-ds1343.c
index 8ccc750..c371918 100644
--- a/drivers/rtc/rtc-ds1343.c
+++ b/drivers/rtc/rtc-ds1343.c
@@ -80,6 +80,7 @@ struct ds1343_priv {
 	struct regmap *map;
 	struct mutex mutex;
 	unsigned int irqen;
+	int irq;
 	int alarm_sec;
 	int alarm_min;
 	int alarm_hour;
@@ -262,28 +263,32 @@ static DEVICE_ATTR(trickle_charger, S_IRUGO, ds1343_show_tricklecharger, NULL);
 
 static int ds1343_sysfs_register(struct device *dev)
 {
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
 	int err;
 
 	err = device_create_file(dev, &dev_attr_glitch_filter);
 	if (err)
 		return err;
 
-	err = device_create_file(dev, &dev_attr_alarm_status);
+	err = device_create_file(dev, &dev_attr_trickle_charger);
 	if (err)
 		goto error1;
 
+	if (priv->irq <= 0)
+		return err;
+
 	err = device_create_file(dev, &dev_attr_alarm_mode);
 	if (err)
 		goto error2;
 
-	err = device_create_file(dev, &dev_attr_trickle_charger);
+	err = device_create_file(dev, &dev_attr_alarm_status);
 	if (!err)
 		return err;
 
 	device_remove_file(dev, &dev_attr_alarm_mode);
 
 error2:
-	device_remove_file(dev, &dev_attr_alarm_status);
+	device_remove_file(dev, &dev_attr_trickle_charger);
 
 error1:
 	device_remove_file(dev, &dev_attr_glitch_filter);
@@ -293,10 +298,16 @@ error1:
 
 static void ds1343_sysfs_unregister(struct device *dev)
 {
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
 	device_remove_file(dev, &dev_attr_glitch_filter);
+	device_remove_file(dev, &dev_attr_trickle_charger);
+
+	if (priv->irq <= 0)
+		return;
+
 	device_remove_file(dev, &dev_attr_alarm_status);
 	device_remove_file(dev, &dev_attr_alarm_mode);
-	device_remove_file(dev, &dev_attr_trickle_charger);
 }
 
 static int ds1343_read_time(struct device *dev, struct rtc_time *dt)
@@ -415,11 +426,10 @@ static int ds1343_update_alarm(struct device *dev)
 static int ds1343_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 	unsigned int stat;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -450,10 +460,9 @@ out:
 static int ds1343_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -476,10 +485,9 @@ static int ds1343_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 static int ds1343_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -593,18 +601,20 @@ static int ds1343_probe(struct spi_device *spi)
 		return PTR_ERR(priv->rtc);
 	}
 
-	if (spi->irq >= 0) {
+	priv->irq = spi->irq;
+
+	if (priv->irq >= 0) {
 		res = devm_request_threaded_irq(&spi->dev, spi->irq, NULL,
 						ds1343_thread,
 						IRQF_NO_SUSPEND | IRQF_ONESHOT,
 						"ds1343", priv);
 		if (res) {
+			priv->irq = -1;
 			dev_err(&spi->dev,
 				"unable to request irq for rtc ds1343\n");
-			return res;
+		} else {
+			device_set_wakeup_capable(&spi->dev, 1);
 		}
-
-		device_set_wakeup_capable(&spi->dev, 1);
 	}
 
 	res = ds1343_sysfs_register(&spi->dev);
-- 
1.8.3.2

