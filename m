Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbaCSNEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:04:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933962AbaCSNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:11 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 14/16] backlight: atmel-pwm-bl: remove obsolete driver
Date: Wed, 19 Mar 2014 14:03:27 +0100
Message-Id: <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel-pwm-bl driver is now obsolete. It is not used by any mainlined boards
and is replaced by the generic pwm_bl with the pawm-atmel driver using the
generic PWM framework.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/video/backlight/Kconfig        |  11 --
 drivers/video/backlight/Makefile       |   1 -
 drivers/video/backlight/atmel-pwm-bl.c | 223 ---------------------------------
 include/linux/atmel-pwm-bl.h           |  43 -------
 4 files changed, 278 deletions(-)
 delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
 delete mode 100644 include/linux/atmel-pwm-bl.h

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 5a3eb2ecb525..9bd32b7a7561 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -178,17 +178,6 @@ config BACKLIGHT_ATMEL_LCDC
 	  If in doubt, it's safe to enable this option; it doesn't kick
 	  in unless the board's description says it's wired that way.
 
-config BACKLIGHT_ATMEL_PWM
-	tristate "Atmel PWM backlight control"
-	depends on ATMEL_PWM
-	help
-	  Say Y here if you want to use the PWM peripheral in Atmel AT91 and
-	  AVR32 devices. This driver will need additional platform data to know
-	  which PWM instance to use and how to configure it.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called atmel-pwm-bl.
-
 config BACKLIGHT_EP93XX
 	tristate "Cirrus EP93xx Backlight Driver"
 	depends on FB_EP93XX
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index bb820024f346..351451dbb607 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_BACKLIGHT_ADP8860)		+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)		+= adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_APPLE)		+= apple_bl.o
 obj-$(CONFIG_BACKLIGHT_AS3711)		+= as3711_bl.o
-obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)	+= atmel-pwm-bl.o
 obj-$(CONFIG_BACKLIGHT_BD6107)		+= bd6107.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH)	+= cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE)	+= backlight.o
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
deleted file mode 100644
index 261b1a4ec3d8..000000000000
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ /dev/null
@@ -1,223 +0,0 @@
-/*
- * Copyright (C) 2008 Atmel Corporation
- *
- * Backlight driver using Atmel PWM peripheral.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- */
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/fb.h>
-#include <linux/gpio.h>
-#include <linux/backlight.h>
-#include <linux/atmel_pwm.h>
-#include <linux/atmel-pwm-bl.h>
-#include <linux/slab.h>
-
-struct atmel_pwm_bl {
-	const struct atmel_pwm_bl_platform_data	*pdata;
-	struct backlight_device			*bldev;
-	struct platform_device			*pdev;
-	struct pwm_channel			pwmc;
-	int					gpio_on;
-};
-
-static void atmel_pwm_bl_set_gpio_on(struct atmel_pwm_bl *pwmbl, int on)
-{
-	if (!gpio_is_valid(pwmbl->gpio_on))
-		return;
-
-	gpio_set_value(pwmbl->gpio_on, on ^ pwmbl->pdata->on_active_low);
-}
-
-static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
-{
-	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	int intensity = bd->props.brightness;
-	int pwm_duty;
-
-	if (bd->props.power != FB_BLANK_UNBLANK)
-		intensity = 0;
-	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
-		intensity = 0;
-
-	if (pwmbl->pdata->pwm_active_low)
-		pwm_duty = pwmbl->pdata->pwm_duty_min + intensity;
-	else
-		pwm_duty = pwmbl->pdata->pwm_duty_max - intensity;
-
-	if (pwm_duty > pwmbl->pdata->pwm_duty_max)
-		pwm_duty = pwmbl->pdata->pwm_duty_max;
-	if (pwm_duty < pwmbl->pdata->pwm_duty_min)
-		pwm_duty = pwmbl->pdata->pwm_duty_min;
-
-	if (!intensity) {
-		atmel_pwm_bl_set_gpio_on(pwmbl, 0);
-		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
-		pwm_channel_disable(&pwmbl->pwmc);
-	} else {
-		pwm_channel_enable(&pwmbl->pwmc);
-		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
-		atmel_pwm_bl_set_gpio_on(pwmbl, 1);
-	}
-
-	return 0;
-}
-
-static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
-{
-	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	u32 cdty;
-	u32 intensity;
-
-	cdty = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
-	if (pwmbl->pdata->pwm_active_low)
-		intensity = cdty - pwmbl->pdata->pwm_duty_min;
-	else
-		intensity = pwmbl->pdata->pwm_duty_max - cdty;
-
-	return intensity & 0xffff;
-}
-
-static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
-{
-	unsigned long pwm_rate = pwmbl->pwmc.mck;
-	unsigned long prescale = DIV_ROUND_UP(pwm_rate,
-			(pwmbl->pdata->pwm_frequency *
-			 pwmbl->pdata->pwm_compare_max)) - 1;
-
-	/*
-	 * Prescale must be power of two and maximum 0xf in size because of
-	 * hardware limit. PWM speed will be:
-	 *	PWM module clock speed / (2 ^ prescale).
-	 */
-	prescale = fls(prescale);
-	if (prescale > 0xf)
-		prescale = 0xf;
-
-	pwm_channel_writel(&pwmbl->pwmc, PWM_CMR, prescale);
-	pwm_channel_writel(&pwmbl->pwmc, PWM_CDTY,
-			pwmbl->pdata->pwm_duty_min +
-			pwmbl->bldev->props.brightness);
-	pwm_channel_writel(&pwmbl->pwmc, PWM_CPRD,
-			pwmbl->pdata->pwm_compare_max);
-
-	dev_info(&pwmbl->pdev->dev, "Atmel PWM backlight driver (%lu Hz)\n",
-		pwmbl->pwmc.mck / pwmbl->pdata->pwm_compare_max /
-		(1 << prescale));
-
-	return pwm_channel_enable(&pwmbl->pwmc);
-}
-
-static const struct backlight_ops atmel_pwm_bl_ops = {
-	.get_brightness = atmel_pwm_bl_get_intensity,
-	.update_status  = atmel_pwm_bl_set_intensity,
-};
-
-static int atmel_pwm_bl_probe(struct platform_device *pdev)
-{
-	struct backlight_properties props;
-	const struct atmel_pwm_bl_platform_data *pdata;
-	struct backlight_device *bldev;
-	struct atmel_pwm_bl *pwmbl;
-	unsigned long flags;
-	int retval;
-
-	pdata = dev_get_platdata(&pdev->dev);
-	if (!pdata)
-		return -ENODEV;
-
-	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
-			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0)
-		return -EINVAL;
-
-	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
-				GFP_KERNEL);
-	if (!pwmbl)
-		return -ENOMEM;
-
-	pwmbl->pdev = pdev;
-	pwmbl->pdata = pdata;
-	pwmbl->gpio_on = pdata->gpio_on;
-
-	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
-	if (retval)
-		return retval;
-
-	if (gpio_is_valid(pwmbl->gpio_on)) {
-		/* Turn display off by default. */
-		if (pdata->on_active_low)
-			flags = GPIOF_OUT_INIT_HIGH;
-		else
-			flags = GPIOF_OUT_INIT_LOW;
-
-		retval = devm_gpio_request_one(&pdev->dev, pwmbl->gpio_on,
-						flags, "gpio_atmel_pwm_bl");
-		if (retval)
-			goto err_free_pwm;
-	}
-
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.type = BACKLIGHT_RAW;
-	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
-	bldev = devm_backlight_device_register(&pdev->dev, "atmel-pwm-bl",
-					&pdev->dev, pwmbl, &atmel_pwm_bl_ops,
-					&props);
-	if (IS_ERR(bldev)) {
-		retval = PTR_ERR(bldev);
-		goto err_free_pwm;
-	}
-
-	pwmbl->bldev = bldev;
-
-	platform_set_drvdata(pdev, pwmbl);
-
-	/* Power up the backlight by default at middle intesity. */
-	bldev->props.power = FB_BLANK_UNBLANK;
-	bldev->props.brightness = bldev->props.max_brightness / 2;
-
-	retval = atmel_pwm_bl_init_pwm(pwmbl);
-	if (retval)
-		goto err_free_pwm;
-
-	atmel_pwm_bl_set_intensity(bldev);
-
-	return 0;
-
-err_free_pwm:
-	pwm_channel_free(&pwmbl->pwmc);
-
-	return retval;
-}
-
-static int atmel_pwm_bl_remove(struct platform_device *pdev)
-{
-	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
-
-	atmel_pwm_bl_set_gpio_on(pwmbl, 0);
-	pwm_channel_disable(&pwmbl->pwmc);
-	pwm_channel_free(&pwmbl->pwmc);
-
-	return 0;
-}
-
-static struct platform_driver atmel_pwm_bl_driver = {
-	.driver = {
-		.name = "atmel-pwm-bl",
-	},
-	/* REVISIT add suspend() and resume() */
-	.probe = atmel_pwm_bl_probe,
-	.remove = atmel_pwm_bl_remove,
-};
-
-module_platform_driver(atmel_pwm_bl_driver);
-
-MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
-MODULE_DESCRIPTION("Atmel PWM backlight driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:atmel-pwm-bl");
diff --git a/include/linux/atmel-pwm-bl.h b/include/linux/atmel-pwm-bl.h
deleted file mode 100644
index 0153a47806c2..000000000000
--- a/include/linux/atmel-pwm-bl.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Copyright (C) 2007 Atmel Corporation
- *
- * Driver for the AT32AP700X PS/2 controller (PSIF).
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- */
-
-#ifndef __INCLUDE_ATMEL_PWM_BL_H
-#define __INCLUDE_ATMEL_PWM_BL_H
-
-/**
- * struct atmel_pwm_bl_platform_data
- * @pwm_channel: which PWM channel in the PWM module to use.
- * @pwm_frequency: PWM frequency to generate, the driver will try to be as
- *	close as the prescaler allows.
- * @pwm_compare_max: value to use in the PWM channel compare register.
- * @pwm_duty_max: maximum duty cycle value, must be less than or equal to
- *	pwm_compare_max.
- * @pwm_duty_min: minimum duty cycle value, must be less than pwm_duty_max.
- * @pwm_active_low: set to one if the low part of the PWM signal increases the
- *	brightness of the backlight.
- * @gpio_on: GPIO line to control the backlight on/off, set to -1 if not used.
- * @on_active_low: set to one if the on/off signal is on when GPIO is low.
- *
- * This struct must be added to the platform device in the board code. It is
- * used by the atmel-pwm-bl driver to setup the GPIO to control on/off and the
- * PWM device.
- */
-struct atmel_pwm_bl_platform_data {
-	unsigned int pwm_channel;
-	unsigned int pwm_frequency;
-	unsigned int pwm_compare_max;
-	unsigned int pwm_duty_max;
-	unsigned int pwm_duty_min;
-	unsigned int pwm_active_low;
-	int gpio_on;
-	unsigned int on_active_low;
-};
-
-#endif /* __INCLUDE_ATMEL_PWM_BL_H */
-- 
1.8.3.2

