Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaDFDTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 23:19:54 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60561 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaDFDTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 23:19:47 -0400
Message-ID: <1396754381.13341.4.camel@phoenix>
Subject: [PATCH RFC] leds: pca9685: Remove leds-pca9685 driver
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: Maximilian =?ISO-8859-1?Q?G=FCntner?= 
	<maximilian.guentner@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Date: Sun, 06 Apr 2014 11:19:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is replaced by pwm-pca9685 driver and there is no user uses this
driver in current tree. So remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I found there is a modalias conflict between leds-pca9685.ko and pwm-pca9685.ko.
I think this conflict will cause problem.
After checking the code, I think leds-pca9685 is replaced by pwm-pca9685.
Use git grep to check current tree and found there is no user uses leds-pca9685.
So this patch removes leds-pca9685 driver.

(I forgot to CC mailing list, so here is a resend)
Regards,
Axel
 drivers/leds/Kconfig                       |  10 --
 drivers/leds/Makefile                      |   1 -
 drivers/leds/leds-pca9685.c                | 213 -----------------------------
 include/linux/platform_data/leds-pca9685.h |  35 -----
 4 files changed, 259 deletions(-)
 delete mode 100644 drivers/leds/leds-pca9685.c
 delete mode 100644 include/linux/platform_data/leds-pca9685.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 2062682..3e8a92b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -297,16 +297,6 @@ config LEDS_PCA963X
 	  LED driver chip accessed via the I2C bus. Supported
 	  devices include PCA9633 and PCA9634
 
-config LEDS_PCA9685
-	tristate "LED support for PCA9685 I2C chip"
-	depends on LEDS_CLASS
-	depends on I2C
-	help
-	  This option enables support for LEDs connected to the PCA9685
-	  LED driver chip accessed via the I2C bus.
-	  The PCA9685 offers 12-bit PWM (4095 levels of brightness) on
-	  16 individual channels.
-
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3cd76db..8979b0b 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_PCA963X)		+= leds-pca963x.o
-obj-$(CONFIG_LEDS_PCA9685)		+= leds-pca9685.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
diff --git a/drivers/leds/leds-pca9685.c b/drivers/leds/leds-pca9685.c
deleted file mode 100644
index 6e1ef3a..0000000
--- a/drivers/leds/leds-pca9685.c
+++ /dev/null
@@ -1,213 +0,0 @@
-/*
- * Copyright 2013 Maximilian Güntner <maximilian.guentner@gmail.com>
- *
- * This file is subject to the terms and conditions of version 2 of
- * the GNU General Public License.  See the file COPYING in the main
- * directory of this archive for more details.
- *
- * Based on leds-pca963x.c driver by
- * Peter Meerwald <p.meerwald@bct-electronic.com>
- *
- * Driver for the NXP PCA9685 12-Bit PWM LED driver chip.
- *
- */
-
-#include <linux/ctype.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/i2c.h>
-#include <linux/leds.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/workqueue.h>
-
-#include <linux/platform_data/leds-pca9685.h>
-
-/* Register Addresses */
-#define PCA9685_MODE1 0x00
-#define PCA9685_MODE2 0x01
-#define PCA9685_LED0_ON_L 0x06
-#define PCA9685_ALL_LED_ON_L 0xFA
-
-/* MODE1 Register */
-#define PCA9685_ALLCALL 0x00
-#define PCA9685_SLEEP   0x04
-#define PCA9685_AI      0x05
-
-/* MODE2 Register */
-#define PCA9685_INVRT   0x04
-#define PCA9685_OUTDRV  0x02
-
-static const struct i2c_device_id pca9685_id[] = {
-	{ "pca9685", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, pca9685_id);
-
-struct pca9685_led {
-	struct i2c_client *client;
-	struct work_struct work;
-	u16 brightness;
-	struct led_classdev led_cdev;
-	int led_num; /* 0-15 */
-	char name[32];
-};
-
-static void pca9685_write_msg(struct i2c_client *client, u8 *buf, u8 len)
-{
-	struct i2c_msg msg = {
-		.addr = client->addr,
-		.flags = 0x00,
-		.len = len,
-		.buf = buf
-	};
-	i2c_transfer(client->adapter, &msg, 1);
-}
-
-static void pca9685_all_off(struct i2c_client *client)
-{
-	u8 i2c_buffer[5] = {PCA9685_ALL_LED_ON_L, 0x00, 0x00, 0x00, 0x10};
-	pca9685_write_msg(client, i2c_buffer, 5);
-}
-
-static void pca9685_led_work(struct work_struct *work)
-{
-	struct pca9685_led *pca9685;
-	u8 i2c_buffer[5];
-
-	pca9685 = container_of(work, struct pca9685_led, work);
-	i2c_buffer[0] = PCA9685_LED0_ON_L + 4 * pca9685->led_num;
-	/*
-	 * 4095 is the maximum brightness, so we set the ON time to 0x1000
-	 * which disables the PWM generator for that LED
-	 */
-	if (pca9685->brightness == 4095)
-		*((__le16 *)(i2c_buffer+1)) = cpu_to_le16(0x1000);
-	else
-		*((__le16 *)(i2c_buffer+1)) = 0x0000;
-
-	if (pca9685->brightness == 0)
-		*((__le16 *)(i2c_buffer+3)) = cpu_to_le16(0x1000);
-	else if (pca9685->brightness == 4095)
-		*((__le16 *)(i2c_buffer+3)) = 0x0000;
-	else
-		*((__le16 *)(i2c_buffer+3)) = cpu_to_le16(pca9685->brightness);
-
-	pca9685_write_msg(pca9685->client, i2c_buffer, 5);
-}
-
-static void pca9685_led_set(struct led_classdev *led_cdev,
-		enum led_brightness value)
-{
-	struct pca9685_led *pca9685;
-	pca9685 = container_of(led_cdev, struct pca9685_led, led_cdev);
-	pca9685->brightness = value;
-
-	schedule_work(&pca9685->work);
-}
-
-static int pca9685_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
-{
-	struct pca9685_led *pca9685;
-	struct pca9685_platform_data *pdata;
-	int err;
-	u8 i;
-
-	pdata = dev_get_platdata(&client->dev);
-	if (pdata) {
-		if (pdata->leds.num_leds < 1 || pdata->leds.num_leds > 15) {
-			dev_err(&client->dev, "board info must claim 1-16 LEDs");
-			return -EINVAL;
-		}
-	}
-
-	pca9685 = devm_kzalloc(&client->dev, 16 * sizeof(*pca9685), GFP_KERNEL);
-	if (!pca9685)
-		return -ENOMEM;
-
-	i2c_set_clientdata(client, pca9685);
-	pca9685_all_off(client);
-
-	for (i = 0; i < 16; i++) {
-		pca9685[i].client = client;
-		pca9685[i].led_num = i;
-		pca9685[i].name[0] = '\0';
-		if (pdata && i < pdata->leds.num_leds) {
-			if (pdata->leds.leds[i].name)
-				strncpy(pca9685[i].name,
-					pdata->leds.leds[i].name,
-					sizeof(pca9685[i].name)-1);
-			if (pdata->leds.leds[i].default_trigger)
-				pca9685[i].led_cdev.default_trigger =
-					pdata->leds.leds[i].default_trigger;
-		}
-		if (strlen(pca9685[i].name) == 0) {
-			/*
-			 * Write adapter and address to the name as well.
-			 * Otherwise multiple chips attached to one host would
-			 * not work.
-			 */
-			snprintf(pca9685[i].name, sizeof(pca9685[i].name),
-					"pca9685:%d:x%.2x:%d",
-					client->adapter->nr, client->addr, i);
-		}
-		pca9685[i].led_cdev.name = pca9685[i].name;
-		pca9685[i].led_cdev.max_brightness = 0xfff;
-		pca9685[i].led_cdev.brightness_set = pca9685_led_set;
-
-		INIT_WORK(&pca9685[i].work, pca9685_led_work);
-		err = led_classdev_register(&client->dev, &pca9685[i].led_cdev);
-		if (err < 0)
-			goto exit;
-	}
-
-	if (pdata)
-		i2c_smbus_write_byte_data(client, PCA9685_MODE2,
-			pdata->outdrv << PCA9685_OUTDRV |
-			pdata->inverted << PCA9685_INVRT);
-	else
-		i2c_smbus_write_byte_data(client, PCA9685_MODE2,
-			PCA9685_TOTEM_POLE << PCA9685_OUTDRV);
-	/* Enable Auto-Increment, enable oscillator, ALLCALL/SUBADDR disabled */
-	i2c_smbus_write_byte_data(client, PCA9685_MODE1, BIT(PCA9685_AI));
-
-	return 0;
-
-exit:
-	while (i--) {
-		led_classdev_unregister(&pca9685[i].led_cdev);
-		cancel_work_sync(&pca9685[i].work);
-	}
-	return err;
-}
-
-static int pca9685_remove(struct i2c_client *client)
-{
-	struct pca9685_led *pca9685 = i2c_get_clientdata(client);
-	u8 i;
-
-	for (i = 0; i < 16; i++) {
-		led_classdev_unregister(&pca9685[i].led_cdev);
-		cancel_work_sync(&pca9685[i].work);
-	}
-	pca9685_all_off(client);
-	return 0;
-}
-
-static struct i2c_driver pca9685_driver = {
-	.driver = {
-		.name = "leds-pca9685",
-		.owner = THIS_MODULE,
-	},
-	.probe = pca9685_probe,
-	.remove = pca9685_remove,
-	.id_table = pca9685_id,
-};
-
-module_i2c_driver(pca9685_driver);
-
-MODULE_AUTHOR("Maximilian Güntner <maximilian.guentner@gmail.com>");
-MODULE_DESCRIPTION("PCA9685 LED Driver");
-MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/leds-pca9685.h b/include/linux/platform_data/leds-pca9685.h
deleted file mode 100644
index 778e9e4..0000000
--- a/include/linux/platform_data/leds-pca9685.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * Copyright 2013 Maximilian Güntner <maximilian.guentner@gmail.com>
- *
- * This file is subject to the terms and conditions of version 2 of
- * the GNU General Public License.  See the file COPYING in the main
- * directory of this archive for more details.
- *
- * Based on leds-pca963x.h by Peter Meerwald <p.meerwald@bct-electronic.com>
- *
- * LED driver for the NXP PCA9685 PWM chip
- *
- */
-
-#ifndef __LINUX_PCA9685_H
-#define __LINUX_PCA9685_H
-
-#include <linux/leds.h>
-
-enum pca9685_outdrv {
-	PCA9685_OPEN_DRAIN,
-	PCA9685_TOTEM_POLE,
-};
-
-enum pca9685_inverted {
-	PCA9685_NOT_INVERTED,
-	PCA9685_INVERTED,
-};
-
-struct pca9685_platform_data {
-	struct led_platform_data leds;
-	enum pca9685_outdrv outdrv;
-	enum pca9685_inverted inverted;
-};
-
-#endif /* __LINUX_PCA9685_H */
-- 
1.8.3.2



