Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513Ab3HIGqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:46:09 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37217 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030396Ab3HIGqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:46:05 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bryan Wu <cooloney@gmail.com>,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 4/4] leds-pca9633: Rename to leds-pca963x
Date: Fri,  9 Aug 2013 08:45:44 +0200
Message-Id: <1376030744-22645-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376030744-22645-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1376030744-22645-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver now supports the chips pca9633 and pca9634, therefore we
rename the files to more genereic and meaningul names

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/leds/Kconfig                       |    2 +-
 drivers/leds/Makefile                      |    2 +-
 drivers/leds/leds-pca9633.c                |  249 ----------------------------
 drivers/leds/leds-pca963x.c                |  249 ++++++++++++++++++++++++++++
 include/linux/platform_data/leds-pca9633.h |   35 ----
 include/linux/platform_data/leds-pca963x.h |   36 ++++
 6 files changed, 287 insertions(+), 286 deletions(-)
 delete mode 100644 drivers/leds/leds-pca9633.c
 create mode 100644 drivers/leds/leds-pca963x.c
 delete mode 100644 include/linux/platform_data/leds-pca9633.h
 create mode 100644 include/linux/platform_data/leds-pca963x.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 023af58..d5cb477 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -279,7 +279,7 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
-config LEDS_PCA9633
+config LEDS_PCA963X
 	tristate "LED support for PCA963x I2C chip"
 	depends on LEDS_CLASS
 	depends on I2C
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index ac28977..26f9c13 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
-obj-$(CONFIG_LEDS_PCA9633)		+= leds-pca9633.o
+obj-$(CONFIG_LEDS_PCA963X)		+= leds-pca963x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
deleted file mode 100644
index 9bf33d8..0000000
--- a/drivers/leds/leds-pca9633.c
+++ /dev/null
@@ -1,249 +0,0 @@
-/*
- * Copyright 2011 bct electronic GmbH
- * Copyright 2013 Qtechnology/AS
- *
- * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
- * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
- *
- * Based on leds-pca955x.c
- *
- * This file is subject to the terms and conditions of version 2 of
- * the GNU General Public License.  See the file COPYING in the main
- * directory of this archive for more details.
- *
- * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
- * LED driver for the PCA9634 I2C LED driver (7-bit slave address set by hw.)
- *
- */
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
-#include <linux/err.h>
-#include <linux/i2c.h>
-#include <linux/workqueue.h>
-#include <linux/slab.h>
-#include <linux/platform_data/leds-pca9633.h>
-
-/* LED select registers determine the source that drives LED outputs */
-#define PCA9633_LED_OFF		0x0	/* LED driver off */
-#define PCA9633_LED_ON		0x1	/* LED driver on */
-#define PCA9633_LED_PWM		0x2	/* Controlled through PWM */
-#define PCA9633_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
-
-#define PCA9633_MODE1		0x00
-#define PCA9633_MODE2		0x01
-#define PCA9633_PWM_BASE	0x02
-
-enum pca9633_type {
-	pca9633,
-	pca9634,
-};
-
-struct pca9633_chipdef {
-	u8			ledout_base;
-	int			n_leds;
-};
-
-static struct pca9633_chipdef pca9633_chipdefs[] = {
-	[pca9633] = {
-		.ledout_base	= 0x8,
-		.n_leds		= 4,
-	},
-	[pca9634] = {
-		.ledout_base	= 0xc,
-		.n_leds		= 8,
-	},
-};
-
-static const struct i2c_device_id pca9633_id[] = {
-	{ "pca9633", pca9633 },
-	{ "pca9634", pca9634 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, pca9633_id);
-
-struct pca9633_led;
-
-struct pca9633 {
-	struct pca9633_chipdef *chipdef;
-	struct mutex mutex;
-	struct i2c_client *client;
-	struct pca9633_led *leds;
-};
-
-struct pca9633_led {
-	struct pca9633 *chip;
-	struct work_struct work;
-	enum led_brightness brightness;
-	struct led_classdev led_cdev;
-	int led_num; /* 0 .. 7 potentially */
-	char name[32];
-};
-
-static void pca9633_led_work(struct work_struct *work)
-{
-	struct pca9633_led *pca9633 = container_of(work,
-		struct pca9633_led, work);
-	u8 ledout_addr = pca9633->chip->chipdef->ledout_base
-		+ (pca9633->led_num / 4);
-	u8 ledout;
-	int shift = 2 * (pca9633->led_num % 4);
-	u8 mask = 0x3 << shift;
-
-	mutex_lock(&pca9633->chip->mutex);
-	ledout = i2c_smbus_read_byte_data(pca9633->chip->client, ledout_addr);
-	switch (pca9633->brightness) {
-	case LED_FULL:
-		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
-			(ledout & ~mask) | (PCA9633_LED_ON << shift));
-		break;
-	case LED_OFF:
-		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
-			ledout & ~mask);
-		break;
-	default:
-		i2c_smbus_write_byte_data(pca9633->chip->client,
-			PCA9633_PWM_BASE + pca9633->led_num,
-			pca9633->brightness);
-		i2c_smbus_write_byte_data(pca9633->chip->client, ledout_addr,
-			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
-		break;
-	}
-	mutex_unlock(&pca9633->chip->mutex);
-}
-
-static void pca9633_led_set(struct led_classdev *led_cdev,
-	enum led_brightness value)
-{
-	struct pca9633_led *pca9633;
-
-	pca9633 = container_of(led_cdev, struct pca9633_led, led_cdev);
-
-	pca9633->brightness = value;
-
-	/*
-	 * Must use workqueue for the actual I/O since I2C operations
-	 * can sleep.
-	 */
-	schedule_work(&pca9633->work);
-}
-
-static int pca9633_probe(struct i2c_client *client,
-					const struct i2c_device_id *id)
-{
-	struct pca9633 *pca9633_chip;
-	struct pca9633_led *pca9633;
-	struct pca9633_platform_data *pdata;
-	struct pca9633_chipdef *chip;
-	int i, err;
-
-	chip = &pca9633_chipdefs[id->driver_data];
-	pdata = client->dev.platform_data;
-
-	if (pdata && (pdata->leds.num_leds < 1 ||
-				 pdata->leds.num_leds > chip->n_leds)) {
-		dev_err(&client->dev, "board info must claim 1-%d LEDs",
-								chip->n_leds);
-		return -EINVAL;
-	}
-
-	pca9633_chip = devm_kzalloc(&client->dev, sizeof(*pca9633_chip),
-								GFP_KERNEL);
-	if (!pca9633_chip)
-		return -ENOMEM;
-	pca9633 = devm_kzalloc(&client->dev, chip->n_leds * sizeof(*pca9633),
-								GFP_KERNEL);
-	if (!pca9633)
-		return -ENOMEM;
-
-	i2c_set_clientdata(client, pca9633_chip);
-
-	mutex_init(&pca9633_chip->mutex);
-	pca9633_chip->chipdef = chip;
-	pca9633_chip->client = client;
-	pca9633_chip->leds = pca9633;
-
-	/* Turn off LEDs by default*/
-	i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
-	if (chip->n_leds > 4)
-		i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
-
-	for (i = 0; i < chip->n_leds; i++) {
-		pca9633[i].led_num = i;
-		pca9633[i].chip = pca9633_chip;
-
-		/* Platform data can specify LED names and default triggers */
-		if (pdata && i < pdata->leds.num_leds) {
-			if (pdata->leds.leds[i].name)
-				snprintf(pca9633[i].name,
-					 sizeof(pca9633[i].name), "pca9633:%s",
-					 pdata->leds.leds[i].name);
-			if (pdata->leds.leds[i].default_trigger)
-				pca9633[i].led_cdev.default_trigger =
-					pdata->leds.leds[i].default_trigger;
-		}
-		if (!pdata || i >= pdata->leds.num_leds ||
-						!pdata->leds.leds[i].name)
-			snprintf(pca9633[i].name, sizeof(pca9633[i].name),
-				 "pca9633:%d:%.2x:%d", client->adapter->nr,
-				 client->addr, i);
-
-		pca9633[i].led_cdev.name = pca9633[i].name;
-		pca9633[i].led_cdev.brightness_set = pca9633_led_set;
-
-		INIT_WORK(&pca9633[i].work, pca9633_led_work);
-
-		err = led_classdev_register(&client->dev, &pca9633[i].led_cdev);
-		if (err < 0)
-			goto exit;
-	}
-
-	/* Disable LED all-call address and set normal mode */
-	i2c_smbus_write_byte_data(client, PCA9633_MODE1, 0x00);
-
-	/* Configure output: open-drain or totem pole (push-pull) */
-	if (pdata && pdata->outdrv == PCA9633_OPEN_DRAIN)
-		i2c_smbus_write_byte_data(client, PCA9633_MODE2, 0x01);
-
-	return 0;
-
-exit:
-	while (i--) {
-		led_classdev_unregister(&pca9633[i].led_cdev);
-		cancel_work_sync(&pca9633[i].work);
-	}
-
-	return err;
-}
-
-static int pca9633_remove(struct i2c_client *client)
-{
-	struct pca9633 *pca9633 = i2c_get_clientdata(client);
-	int i;
-
-	for (i = 0; i < pca9633->chipdef->n_leds; i++) {
-		led_classdev_unregister(&pca9633->leds[i].led_cdev);
-		cancel_work_sync(&pca9633->leds[i].work);
-	}
-
-	return 0;
-}
-
-static struct i2c_driver pca9633_driver = {
-	.driver = {
-		.name	= "leds-pca9633",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= pca9633_probe,
-	.remove	= pca9633_remove,
-	.id_table = pca9633_id,
-};
-
-module_i2c_driver(pca9633_driver);
-
-MODULE_AUTHOR("Peter Meerwald <p.meerwald@bct-electronic.com>");
-MODULE_DESCRIPTION("PCA9633 LED driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-pca963x.c b/drivers/leds/leds-pca963x.c
new file mode 100644
index 0000000..98ca0ed
--- /dev/null
+++ b/drivers/leds/leds-pca963x.c
@@ -0,0 +1,249 @@
+/*
+ * Copyright 2011 bct electronic GmbH
+ * Copyright 2013 Qtechnology/AS
+ *
+ * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
+ *
+ * Based on leds-pca955x.c
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for the PCA963x I2C LED driver (7-bit slave address 0x62)
+ * LED driver for the PCA9634 I2C LED driver (7-bit slave address set by hw.)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/platform_data/leds-pca963x.h>
+
+/* LED select registers determine the source that drives LED outputs */
+#define PCA963X_LED_OFF		0x0	/* LED driver off */
+#define PCA963X_LED_ON		0x1	/* LED driver on */
+#define PCA963X_LED_PWM		0x2	/* Controlled through PWM */
+#define PCA963X_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
+
+#define PCA963X_MODE1		0x00
+#define PCA963X_MODE2		0x01
+#define PCA963X_PWM_BASE	0x02
+
+enum pca963x_type {
+	pca9633,
+	pca9634,
+};
+
+struct pca963x_chipdef {
+	u8			ledout_base;
+	int			n_leds;
+};
+
+static struct pca963x_chipdef pca963x_chipdefs[] = {
+	[pca9633] = {
+		.ledout_base	= 0x8,
+		.n_leds		= 4,
+	},
+	[pca9634] = {
+		.ledout_base	= 0xc,
+		.n_leds		= 8,
+	},
+};
+
+static const struct i2c_device_id pca963x_id[] = {
+	{ "pca9633", pca9633 },
+	{ "pca9634", pca9634 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pca963x_id);
+
+struct pca963x_led;
+
+struct pca963x {
+	struct pca963x_chipdef *chipdef;
+	struct mutex mutex;
+	struct i2c_client *client;
+	struct pca963x_led *leds;
+};
+
+struct pca963x_led {
+	struct pca963x *chip;
+	struct work_struct work;
+	enum led_brightness brightness;
+	struct led_classdev led_cdev;
+	int led_num; /* 0 .. 7 potentially */
+	char name[32];
+};
+
+static void pca963x_led_work(struct work_struct *work)
+{
+	struct pca963x_led *pca963x = container_of(work,
+		struct pca963x_led, work);
+	u8 ledout_addr = pca963x->chip->chipdef->ledout_base
+		+ (pca963x->led_num / 4);
+	u8 ledout;
+	int shift = 2 * (pca963x->led_num % 4);
+	u8 mask = 0x3 << shift;
+
+	mutex_lock(&pca963x->chip->mutex);
+	ledout = i2c_smbus_read_byte_data(pca963x->chip->client, ledout_addr);
+	switch (pca963x->brightness) {
+	case LED_FULL:
+		i2c_smbus_write_byte_data(pca963x->chip->client, ledout_addr,
+			(ledout & ~mask) | (PCA963X_LED_ON << shift));
+		break;
+	case LED_OFF:
+		i2c_smbus_write_byte_data(pca963x->chip->client, ledout_addr,
+			ledout & ~mask);
+		break;
+	default:
+		i2c_smbus_write_byte_data(pca963x->chip->client,
+			PCA963X_PWM_BASE + pca963x->led_num,
+			pca963x->brightness);
+		i2c_smbus_write_byte_data(pca963x->chip->client, ledout_addr,
+			(ledout & ~mask) | (PCA963X_LED_PWM << shift));
+		break;
+	}
+	mutex_unlock(&pca963x->chip->mutex);
+}
+
+static void pca963x_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct pca963x_led *pca963x;
+
+	pca963x = container_of(led_cdev, struct pca963x_led, led_cdev);
+
+	pca963x->brightness = value;
+
+	/*
+	 * Must use workqueue for the actual I/O since I2C operations
+	 * can sleep.
+	 */
+	schedule_work(&pca963x->work);
+}
+
+static int pca963x_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct pca963x *pca963x_chip;
+	struct pca963x_led *pca963x;
+	struct pca963x_platform_data *pdata;
+	struct pca963x_chipdef *chip;
+	int i, err;
+
+	chip = &pca963x_chipdefs[id->driver_data];
+	pdata = client->dev.platform_data;
+
+	if (pdata && (pdata->leds.num_leds < 1 ||
+				 pdata->leds.num_leds > chip->n_leds)) {
+		dev_err(&client->dev, "board info must claim 1-%d LEDs",
+								chip->n_leds);
+		return -EINVAL;
+	}
+
+	pca963x_chip = devm_kzalloc(&client->dev, sizeof(*pca963x_chip),
+								GFP_KERNEL);
+	if (!pca963x_chip)
+		return -ENOMEM;
+	pca963x = devm_kzalloc(&client->dev, chip->n_leds * sizeof(*pca963x),
+								GFP_KERNEL);
+	if (!pca963x)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pca963x_chip);
+
+	mutex_init(&pca963x_chip->mutex);
+	pca963x_chip->chipdef = chip;
+	pca963x_chip->client = client;
+	pca963x_chip->leds = pca963x;
+
+	/* Turn off LEDs by default*/
+	i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
+	if (chip->n_leds > 4)
+		i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
+
+	for (i = 0; i < chip->n_leds; i++) {
+		pca963x[i].led_num = i;
+		pca963x[i].chip = pca963x_chip;
+
+		/* Platform data can specify LED names and default triggers */
+		if (pdata && i < pdata->leds.num_leds) {
+			if (pdata->leds.leds[i].name)
+				snprintf(pca963x[i].name,
+					 sizeof(pca963x[i].name), "pca963x:%s",
+					 pdata->leds.leds[i].name);
+			if (pdata->leds.leds[i].default_trigger)
+				pca963x[i].led_cdev.default_trigger =
+					pdata->leds.leds[i].default_trigger;
+		}
+		if (!pdata || i >= pdata->leds.num_leds ||
+						!pdata->leds.leds[i].name)
+			snprintf(pca963x[i].name, sizeof(pca963x[i].name),
+				 "pca963x:%d:%.2x:%d", client->adapter->nr,
+				 client->addr, i);
+
+		pca963x[i].led_cdev.name = pca963x[i].name;
+		pca963x[i].led_cdev.brightness_set = pca963x_led_set;
+
+		INIT_WORK(&pca963x[i].work, pca963x_led_work);
+
+		err = led_classdev_register(&client->dev, &pca963x[i].led_cdev);
+		if (err < 0)
+			goto exit;
+	}
+
+	/* Disable LED all-call address and set normal mode */
+	i2c_smbus_write_byte_data(client, PCA963X_MODE1, 0x00);
+
+	/* Configure output: open-drain or totem pole (push-pull) */
+	if (pdata && pdata->outdrv == PCA963X_OPEN_DRAIN)
+		i2c_smbus_write_byte_data(client, PCA963X_MODE2, 0x01);
+
+	return 0;
+
+exit:
+	while (i--) {
+		led_classdev_unregister(&pca963x[i].led_cdev);
+		cancel_work_sync(&pca963x[i].work);
+	}
+
+	return err;
+}
+
+static int pca963x_remove(struct i2c_client *client)
+{
+	struct pca963x *pca963x = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < pca963x->chipdef->n_leds; i++) {
+		led_classdev_unregister(&pca963x->leds[i].led_cdev);
+		cancel_work_sync(&pca963x->leds[i].work);
+	}
+
+	return 0;
+}
+
+static struct i2c_driver pca963x_driver = {
+	.driver = {
+		.name	= "leds-pca963x",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pca963x_probe,
+	.remove	= pca963x_remove,
+	.id_table = pca963x_id,
+};
+
+module_i2c_driver(pca963x_driver);
+
+MODULE_AUTHOR("Peter Meerwald <p.meerwald@bct-electronic.com>");
+MODULE_DESCRIPTION("PCA963X LED driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/leds-pca9633.h b/include/linux/platform_data/leds-pca9633.h
deleted file mode 100644
index c5bf29b..0000000
--- a/include/linux/platform_data/leds-pca9633.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * PCA9633 LED chip driver.
- *
- * Copyright 2012 bct electronic GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef __LINUX_PCA9633_H
-#define __LINUX_PCA9633_H
-#include <linux/leds.h>
-
-enum pca9633_outdrv {
-	PCA9633_OPEN_DRAIN,
-	PCA9633_TOTEM_POLE, /* aka push-pull */
-};
-
-struct pca9633_platform_data {
-	struct led_platform_data leds;
-	enum pca9633_outdrv outdrv;
-};
-
-#endif /* __LINUX_PCA9633_H*/
diff --git a/include/linux/platform_data/leds-pca963x.h b/include/linux/platform_data/leds-pca963x.h
new file mode 100644
index 0000000..f2d527d
--- /dev/null
+++ b/include/linux/platform_data/leds-pca963x.h
@@ -0,0 +1,36 @@
+/*
+ * PCA963X LED chip driver.
+ *
+ * Copyright 2012 bct electronic GmbH
+ * Copyright 2013 Qtechnology A/S
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_PCA963X_H
+#define __LINUX_PCA963X_H
+#include <linux/leds.h>
+
+enum pca963x_outdrv {
+	PCA963X_OPEN_DRAIN,
+	PCA963X_TOTEM_POLE, /* aka push-pull */
+};
+
+struct pca963x_platform_data {
+	struct led_platform_data leds;
+	enum pca963x_outdrv outdrv;
+};
+
+#endif /* __LINUX_PCA963X_H*/
-- 
1.7.10.4

