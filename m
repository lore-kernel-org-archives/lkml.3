Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3LNNIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:08:06 -0500
Received: from smtp27.mail.ru ([94.100.176.180]:47612 "EHLO smtp27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab3LNNIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:08:00 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/3] mfd: mc13xxx: Simplify "probe" & "remove"
Date: Sat, 14 Dec 2013 17:03:12 +0400
Message-Id: <1387026192-21234-3-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies "probe" and "remove" functions by moving
some initialization code in the driver core.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/mc13xxx-core.c | 36 +++++++++++++++++-------------------
 drivers/mfd/mc13xxx-i2c.c  | 18 ++++--------------
 drivers/mfd/mc13xxx-spi.c  | 19 ++++++-------------
 drivers/mfd/mc13xxx.h      |  6 ++----
 4 files changed, 29 insertions(+), 50 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index b0c7cb0..06e64b6 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -636,42 +636,36 @@ static inline int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 }
 #endif
 
-int mc13xxx_common_init(struct mc13xxx *mc13xxx,
-		struct mc13xxx_platform_data *pdata, int irq)
+int mc13xxx_common_init(struct device *dev)
 {
+	struct mc13xxx_platform_data *pdata = dev_get_platdata(dev);
+	struct mc13xxx *mc13xxx = dev_get_drvdata(dev);
 	int ret;
 	u32 revision;
 
-	mc13xxx_lock(mc13xxx);
+	mc13xxx->dev = dev;
 
 	ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
 	if (ret)
-		goto err_revision;
+		return ret;
 
 	mc13xxx->variant->print_revision(mc13xxx, revision);
 
 	/* mask all irqs */
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		return ret;
 
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		return ret;
 
-	ret = request_threaded_irq(irq, NULL, mc13xxx_irq_thread,
+	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
-
-	if (ret) {
-err_mask:
-err_revision:
-		mc13xxx_unlock(mc13xxx);
+	if (ret)
 		return ret;
-	}
-
-	mc13xxx->irq = irq;
 
-	mc13xxx_unlock(mc13xxx);
+	mutex_init(&mc13xxx->lock);
 
 	if (mc13xxx_probe_flags_dt(mc13xxx) < 0 && pdata)
 		mc13xxx->flags = pdata->flags;
@@ -707,13 +701,17 @@ err_revision:
 }
 EXPORT_SYMBOL_GPL(mc13xxx_common_init);
 
-void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
+int mc13xxx_common_exit(struct device *dev)
 {
+	struct mc13xxx *mc13xxx = dev_get_drvdata(dev);
+
 	free_irq(mc13xxx->irq, mc13xxx);
+	mfd_remove_devices(dev);
+	mutex_destroy(&mc13xxx->lock);
 
-	mfd_remove_devices(mc13xxx->dev);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(mc13xxx_common_cleanup);
+EXPORT_SYMBOL_GPL(mc13xxx_common_exit);
 
 MODULE_DESCRIPTION("Core driver for Freescale MC13XXX PMIC");
 MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index 898bd33..ae3addb 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/mc13xxx.h>
 #include <linux/of.h>
@@ -60,7 +59,6 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct mc13xxx *mc13xxx;
-	struct mc13xxx_platform_data *pdata = dev_get_platdata(&client->dev);
 	int ret;
 
 	mc13xxx = devm_kzalloc(&client->dev, sizeof(*mc13xxx), GFP_KERNEL);
@@ -69,15 +67,13 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 
 	dev_set_drvdata(&client->dev, mc13xxx);
 
-	mc13xxx->dev = &client->dev;
-	mutex_init(&mc13xxx->lock);
+	mc13xxx->irq = client->irq;
 
 	mc13xxx->regmap = devm_regmap_init_i2c(client,
 					       &mc13xxx_regmap_i2c_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
-		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-				ret);
+		dev_err(&client->dev, "Failed to initialize regmap: %d\n", ret);
 		return ret;
 	}
 
@@ -89,18 +85,12 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 		mc13xxx->variant = (void *)id->driver_data;
 	}
 
-	ret = mc13xxx_common_init(mc13xxx, pdata, client->irq);
-
-	return ret;
+	return mc13xxx_common_init(&client->dev);
 }
 
 static int mc13xxx_i2c_remove(struct i2c_client *client)
 {
-	struct mc13xxx *mc13xxx = dev_get_drvdata(&client->dev);
-
-	mc13xxx_common_cleanup(mc13xxx);
-
-	return 0;
+	return mc13xxx_common_exit(&client->dev);
 }
 
 static struct i2c_driver mc13xxx_i2c_driver = {
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index cbcc86d..38ab678 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -13,7 +13,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/mc13xxx.h>
@@ -129,26 +128,24 @@ static struct regmap_bus regmap_mc13xxx_bus = {
 static int mc13xxx_spi_probe(struct spi_device *spi)
 {
 	struct mc13xxx *mc13xxx;
-	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
 	int ret;
 
 	mc13xxx = devm_kzalloc(&spi->dev, sizeof(*mc13xxx), GFP_KERNEL);
 	if (!mc13xxx)
 		return -ENOMEM;
 
-	spi_set_drvdata(spi, mc13xxx);
+	dev_set_drvdata(&spi->dev, mc13xxx);
+
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
 
-	mc13xxx->dev = &spi->dev;
-	mutex_init(&mc13xxx->lock);
+	mc13xxx->irq = spi->irq;
 
 	mc13xxx->regmap = devm_regmap_init(&spi->dev, &regmap_mc13xxx_bus,
 					   &spi->dev,
 					   &mc13xxx_regmap_spi_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
-		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-				ret);
+		dev_err(&spi->dev, "Failed to initialize regmap: %d\n", ret);
 		return ret;
 	}
 
@@ -163,16 +160,12 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 		mc13xxx->variant = (void *)id_entry->driver_data;
 	}
 
-	return mc13xxx_common_init(mc13xxx, pdata, spi->irq);
+	return mc13xxx_common_init(&spi->dev);
 }
 
 static int mc13xxx_spi_remove(struct spi_device *spi)
 {
-	struct mc13xxx *mc13xxx = spi_get_drvdata(spi);
-
-	mc13xxx_common_cleanup(mc13xxx);
-
-	return 0;
+	return mc13xxx_common_exit(&spi->dev);
 }
 
 static struct spi_driver mc13xxx_spi_driver = {
diff --git a/drivers/mfd/mc13xxx.h b/drivers/mfd/mc13xxx.h
index 460ec5c..ae7f165 100644
--- a/drivers/mfd/mc13xxx.h
+++ b/drivers/mfd/mc13xxx.h
@@ -43,9 +43,7 @@ struct mc13xxx {
 	int adcflags;
 };
 
-int mc13xxx_common_init(struct mc13xxx *mc13xxx,
-		struct mc13xxx_platform_data *pdata, int irq);
-
-void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx);
+int mc13xxx_common_init(struct device *dev);
+int mc13xxx_common_exit(struct device *dev);
 
 #endif /* __DRIVERS_MFD_MC13XXX_H */
-- 
1.8.3.2

