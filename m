Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaHTNs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:48:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25615 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaHTNoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:11 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7c-53f4a629f874
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 3/3] leds: Add driver for AAT1290 current regulator
Date: Wed, 20 Aug 2014 15:43:41 +0200
Message-id: <1408542221-375-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3NZV+CDbq28lpsnLGe1eLozolM
	FvOPnGO16L36nNHibNMbdovLu+awWWx9s47RomfDVlaL3buesjpweuycdZfdY8/8H6wefVtW
	MXp83iQXwBLFZZOSmpNZllqkb5fAlbHq5gm2gif5FQt72tgaGKfHdjFyckgImEg8evOLDcIW
	k7hwbz2YLSQwnVHi+rqCLkYuILudSaLnw00mkASbgKHEzxevwWwRgXKJnvfP2ECKmAVWM0rc
	2fqVFSQhLOAl8ejnB2YQm0VAVaJrxzOwBl4BN4l5S6YB2RxA2xQk5kyyAQlzCrhLnO04ygyx
	2E3ifvMmpgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfXM+kdjKsaLA4xCnAw
	KvHw3lj0JViINbGsuDL3EKMEB7OSCG97J1CINyWxsiq1KD++qDQntfgQozQHi5I478FW60Ah
	gfTEktTs1NSC1CKYLBMHp1QDY8F5929ry+b53uNc/LTNf/1vZrfrQcEbJ3Pve7r48IZM9gv3
	tCuvyd7kfXQvxySx0Hi6+AfuHyW+6/vfqGx8IPt+/utXlod35X1OXSGgLvpxu7fkrlmPLkfq
	mvqlPi+yULpxQ8hV+MSSc+b5P1n+x0/qmPJpadHqhYdUnsSZJX/fkdDPEJZ6sECJpTgj0VCL
	uag4EQDTr/i6KwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the 1.5A Step-Up
Current Regulator for Flash LEDs. The device is
programmed through a Skyworks' proprietary AS2Cwire
serial digital interface.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig        |    6 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-aat1290.c |  448 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 455 insertions(+)
 create mode 100644 drivers/leds/leds-aat1290.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 27031ab..b54a1fc 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -51,6 +51,12 @@ config LEDS_88PM860X
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
 
+config LEDS_AAT1290
+	tristate "LED support for the AAT1290"
+	depends on LEDS_CLASS_FLASH
+	help
+	 This option enables support for the LEDs on the AAT1290.
+
 config LEDS_LM3530
 	tristate "LCD Backlight driver for LM3530"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 8d7acec..d20f46d 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
+obj-$(CONFIG_LEDS_AAT1290)		+= leds-aat1290.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
new file mode 100644
index 0000000..2cc6fb3
--- /dev/null
+++ b/drivers/leds/leds-aat1290.c
@@ -0,0 +1,448 @@
+/*
+ *	LED Flash Class driver for the AAT1290
+ *	1.5A Step-Up Current Regulator for Flash LEDs
+ *
+ *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-manager.h>
+#include <linux/leds.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of.h>
+#include <media/v4l2-flash.h>
+#include <linux/workqueue.h>
+
+#define AAT1290_LED_NAME		"aat1290"
+#define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
+#define AAT1290_FLASH_SAFETY_TIMER_ADDR	18
+#define AAT1290_MOVIE_MODE_CONFIG_ADDR	19
+#define AAT1290_MM_CURRENT_RATIO_ADDR	20
+#define AAT1290_LATCH_TIME_US		500
+#define AAT1290_EN_SET_TICK_TIME_US	1
+#define AAT1290_MOVIE_MODE_OFF		1
+#define AAT1290_MOVIE_MODE_ON		3
+#define AAT1290_MAX_MM_CURR_PERCENT_0	16
+#define AAT1290_MAX_MM_CURR_PERCENT_100 1
+#define AAT1290_FLASH_TM_NUM_LEVELS	16
+
+#define AAT1290_MM_TO_FL_1_92	1
+#define AAT1290_MM_TO_FL_3_7	2
+#define AAT1290_MM_TO_FL_5_5	3
+#define AAT1290_MM_TO_FL_7_3	4
+#define AAT1290_MM_TO_FL_9	5
+#define AAT1290_MM_TO_FL_10_7	6
+#define AAT1290_MM_TO_FL_12_4	7
+#define AAT1290_MM_TO_FL_14	8
+#define AAT1290_MM_TO_FL_15_9	9
+#define AAT1290_MM_TO_FL_17_5	10
+#define AAT1290_MM_TO_FL_19_1	11
+#define AAT1290_MM_TO_FL_20_8	12
+#define AAT1290_MM_TO_FL_22_4	13
+#define AAT1290_MM_TO_FL_24	14
+#define AAT1290_MM_TO_FL_25_6	15
+#define AAT1290_MM_TO_FL_OFF	16
+
+struct aat1290_led_settings {
+	struct led_flash_setting torch_brightness;
+	struct led_flash_setting flash_brightness;
+	struct led_flash_setting flash_timeout;
+};
+
+struct aat1290_led {
+	struct platform_device *pdev;
+	struct mutex lock;
+
+	struct led_classdev_flash ldev;
+	struct v4l2_flash *v4l2_flash;
+
+	int flen_gpio;
+	int en_set_gpio;
+
+	u32 max_flash_tm;
+	bool movie_mode;
+
+	unsigned int torch_brightness;
+	unsigned int flash_timeout;
+	struct work_struct work_brightness_set;
+};
+
+static struct aat1290_led *ldev_to_led(struct led_classdev_flash *ldev)
+{
+	return container_of(ldev, struct aat1290_led, ldev);
+}
+
+static void aat1290_as2cwire_write(struct aat1290_led *led, int addr, int value)
+{
+	int i;
+
+	gpio_set_value(led->flen_gpio, 0);
+	gpio_set_value(led->en_set_gpio, 0);
+
+	udelay(10);
+
+	/* write address */
+	for (i = 0; i < addr; ++i) {
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpio_set_value(led->en_set_gpio, 0);
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpio_set_value(led->en_set_gpio, 1);
+	}
+
+	udelay(AAT1290_LATCH_TIME_US);
+
+	/* write data */
+	for (i = 0; i < value; ++i) {
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpio_set_value(led->en_set_gpio, 0);
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpio_set_value(led->en_set_gpio, 1);
+	}
+
+	udelay(AAT1290_LATCH_TIME_US);
+}
+
+static void aat1290_set_flash_safety_timer(struct aat1290_led *led,
+					unsigned int micro_sec)
+{
+	struct led_classdev_flash *flash = &led->ldev;
+	struct led_flash_setting *flash_tm = &flash->timeout;
+	int flash_tm_reg = AAT1290_FLASH_TM_NUM_LEVELS -
+				(micro_sec / flash_tm->step) + 1;
+
+	aat1290_as2cwire_write(led, AAT1290_FLASH_SAFETY_TIMER_ADDR,
+							flash_tm_reg);
+}
+
+static void aat1290_brightness_set(struct aat1290_led *led,
+					enum led_brightness brightness)
+{
+	mutex_lock(&led->lock);
+
+	if (brightness == 0) {
+		gpio_set_value(led->flen_gpio, 0);
+		gpio_set_value(led->en_set_gpio, 0);
+		goto unlock;
+	}
+
+	if (!led->movie_mode) {
+		aat1290_as2cwire_write(led, AAT1290_MM_CURRENT_RATIO_ADDR,
+					AAT1290_MM_TO_FL_1_92);
+		led->movie_mode = true;
+	}
+
+	aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CURRENT_ADDR,
+				AAT1290_MAX_MM_CURR_PERCENT_0 - brightness);
+	aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CONFIG_ADDR,
+				AAT1290_MOVIE_MODE_ON);
+unlock:
+	mutex_unlock(&led->lock);
+}
+
+/* LED subsystem callbacks */
+
+static void aat1290_brightness_set_work(struct work_struct *work)
+{
+	struct aat1290_led *led =
+		container_of(work, struct aat1290_led, work_brightness_set);
+
+	aat1290_brightness_set(led, led->torch_brightness);
+}
+
+static void aat1290_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
+{
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	struct aat1290_led *led = ldev_to_led(flash);
+
+	led->torch_brightness = brightness;
+	schedule_work(&led->work_brightness_set);
+}
+
+static int aat1290_torch_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
+{
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	struct aat1290_led *led = ldev_to_led(flash);
+
+	aat1290_brightness_set(led, brightness);
+
+	return 0;
+}
+
+static int aat1290_led_flash_strobe_set(struct led_classdev_flash *flash,
+					 bool state)
+
+{
+	struct aat1290_led *led = ldev_to_led(flash);
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *timeout = &flash->timeout;
+
+	mutex_lock(&led->lock);
+
+	if (state == 0) {
+		gpio_set_value(led->flen_gpio, 0);
+		gpio_set_value(led->en_set_gpio, 0);
+		goto unlock;
+	}
+
+	aat1290_set_flash_safety_timer(led, timeout->val);
+
+	/*
+	 * To reenter movie mode after a flash event the part
+	 * must be cycled off and back on to reset the movie
+	 * mode and reprogrammed via the AS2Cwire. Therefore
+	 * the brightness value needs to be updated here to
+	 * reflect the actual state.
+	 */
+	led_cdev->brightness = 0;
+	led->movie_mode = false;
+
+	gpio_set_value(led->flen_gpio, 1);
+
+unlock:
+	mutex_unlock(&led->lock);
+
+	return 0;
+}
+
+static int aat1290_led_flash_timeout_set(struct led_classdev_flash *flash,
+						u32 timeout)
+{
+	/*
+	 * Don't do anything - flash timeout is cached in the led-class-flash
+	 * core and will be applied in the strobe_set op, as writing the
+	 * safety timer register spuriously turns the torch mode on.
+	 */
+
+	return 0;
+}
+
+static int aat1290_led_parse_dt(struct aat1290_led *led,
+				struct device *dev)
+{
+	int ret;
+	char *pname = "flash-timeout";
+
+	ret = of_property_read_u32(dev->of_node, pname, &led->max_flash_tm);
+	if (ret) {
+		dev_err(dev, "Unable to get property '%s'(%d)\n", pname, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void aat1290_init_flash_settings(struct aat1290_led *led,
+					 struct aat1290_led_settings *s)
+{
+	struct led_flash_setting *setting;
+
+	/* Init flash intensity setting */
+	setting = &s->torch_brightness;
+	/*
+	 * Torch current is adjustable in logarithmic fashion and thus
+	 * it is not possible to define fixed step in microamperes.
+	 * Instead led brightness levels are used to make possible
+	 * setting all the supported levels from V4L2 Flash sub-device.
+	 */
+	setting->min = 1;
+	setting->max = AAT1290_MAX_MM_CURR_PERCENT_0 -
+		       AAT1290_MAX_MM_CURR_PERCENT_100;
+	setting->step = 1;
+	setting->val = setting->max;
+
+	/* Init flash timeout setting */
+	setting = &s->flash_timeout;
+	setting->min = led->max_flash_tm / AAT1290_FLASH_TM_NUM_LEVELS;
+	setting->max = setting->min * AAT1290_FLASH_TM_NUM_LEVELS;
+	setting->step = setting->min;
+	setting->val = setting->max;
+}
+
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+static void aat1290_init_v4l2_ctrl_config(struct aat1290_led_settings *s,
+					struct v4l2_flash_ctrl_config *config)
+{
+	struct led_flash_setting *setting;
+	struct v4l2_ctrl_config *c;
+
+	c = &config->torch_intensity;
+	setting = &s->torch_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_timeout;
+	setting = &s->flash_timeout;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+}
+#else
+#define aat1290_init_v4l2_ctrl_config(s, config)
+#endif
+
+const struct led_flash_ops flash_ops = {
+	.strobe_set = aat1290_led_flash_strobe_set,
+	.timeout_set = aat1290_led_flash_timeout_set,
+};
+
+static int aat1290_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *dev_node = pdev->dev.of_node;
+	struct aat1290_led *led;
+	struct led_classdev *led_cdev;
+	struct led_classdev_flash *flash;
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+	struct v4l2_flash_ctrl_config v4l2_flash_config;
+#endif
+	struct aat1290_led_settings settings;
+	int flen_gpio, enset_gpio, ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->pdev = pdev;
+	platform_set_drvdata(pdev, led);
+
+	if (!dev_node)
+		return -ENXIO;
+
+	flen_gpio = of_get_gpio(dev_node, 0);
+	if (gpio_is_valid(flen_gpio)) {
+		ret = gpio_request_one(flen_gpio, GPIOF_DIR_OUT,
+						"aat1290_flen");
+		if (ret < 0) {
+			dev_err(dev,
+				"failed to request GPIO %d, error %d\n",
+							flen_gpio, ret);
+			goto error_gpio_flen;
+		}
+	}
+	led->flen_gpio = flen_gpio;
+
+	enset_gpio = of_get_gpio(dev_node, 1);
+	if (gpio_is_valid(enset_gpio)) {
+		ret = gpio_request_one(enset_gpio, GPIOF_DIR_OUT,
+						"aat1290_en_set");
+		if (ret < 0) {
+			dev_err(dev,
+				"failed to request GPIO %d, error %d\n",
+							enset_gpio, ret);
+			goto error_gpio_en_set;
+		}
+	}
+	led->en_set_gpio = enset_gpio;
+
+	ret = aat1290_led_parse_dt(led, &pdev->dev);
+	if (ret < 0)
+		goto error_gpio_en_set;
+
+	mutex_init(&led->lock);
+
+	flash = &led->ldev;
+
+	/* Init flash settings */
+	aat1290_init_flash_settings(led, &settings);
+
+	flash->timeout = settings.flash_timeout;
+
+	/* Init V4L2 Flash controls basing on initialized settings */
+	aat1290_init_v4l2_ctrl_config(&settings, &v4l2_flash_config);
+
+	/* Init led class */
+	led_cdev = &flash->led_cdev;
+	led_cdev->name = AAT1290_LED_NAME;
+	led_cdev->brightness_set = aat1290_led_brightness_set;
+	led_cdev->torch_brightness_set = aat1290_torch_brightness_set;
+	led_cdev->max_brightness = settings.torch_brightness.max;
+	led_cdev->flags |= LED_DEV_CAP_FLASH;
+
+	INIT_WORK(&led->work_brightness_set, aat1290_brightness_set_work);
+
+	flash->ops = &flash_ops;
+
+	/* Register in the LED subsystem. */
+	ret = led_classdev_flash_register(&pdev->dev, flash, dev->of_node);
+	if (ret < 0)
+		goto error_gpio_en_set;
+
+	/* Create V4L2 Flash subdev. */
+	led->v4l2_flash = v4l2_flash_init(flash,
+			      &v4l2_flash_config,
+			      led_get_v4l2_flash_ops());
+	if (IS_ERR(led->v4l2_flash)) {
+		ret = PTR_ERR(led->v4l2_flash);
+		goto error_v4l2_flash_init;
+	}
+
+	return ret;
+
+error_v4l2_flash_init:
+	led_classdev_flash_unregister(flash);
+error_gpio_en_set:
+	if (gpio_is_valid(enset_gpio))
+		gpio_free(enset_gpio);
+error_gpio_flen:
+	if (gpio_is_valid(flen_gpio))
+		gpio_free(flen_gpio);
+	mutex_destroy(&led->lock);
+
+	return ret;
+}
+
+static int aat1290_led_remove(struct platform_device *pdev)
+{
+	struct aat1290_led *led = platform_get_drvdata(pdev);
+
+	v4l2_flash_release(led->v4l2_flash);
+	led_classdev_flash_unregister(&led->ldev);
+	cancel_work_sync(&led->work_brightness_set);
+
+	if (gpio_is_valid(led->en_set_gpio))
+		gpio_free(led->en_set_gpio);
+	if (gpio_is_valid(led->flen_gpio))
+		gpio_free(led->flen_gpio);
+
+	mutex_destroy(&led->lock);
+
+	return 0;
+}
+
+static struct of_device_id aat1290_led_dt_match[] = {
+	{.compatible = "skyworks,aat1290"},
+	{},
+};
+
+static struct platform_driver aat1290_led_driver = {
+	.probe		= aat1290_led_probe,
+	.remove		= aat1290_led_remove,
+	.driver		= {
+		.name	= "aat1290-led",
+		.owner	= THIS_MODULE,
+		.of_match_table = aat1290_led_dt_match,
+	},
+};
+
+module_platform_driver(aat1290_led_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("Skyworks Current Regulator for Flash LEDs");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

