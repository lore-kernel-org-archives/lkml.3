Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaGUOLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:11:46 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37587 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932396AbaGUOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:11:43 -0400
Message-ID: <53CD1FC1.4020100@iki.fi>
Date: Mon, 21 Jul 2014 17:12:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:29.0) Gecko/20100101 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v4 16/21] leds: Add support for max77693 mfd flash
 cell
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com> <1405087464-13762-17-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1405087464-13762-17-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Thanks for the patchset.

Jacek Anaszewski wrote:
> This patch adds led-flash support to Maxim max77693 chipset.
> A device can be exposed to user space through LED subsystem
> sysfs interface or through V4L2 subdevice when the support
> for V4L2 Flash sub-devices is enabled. Device supports up to
> two leds which can work in flash and torch mode. Leds can
> be triggered externally or by software.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/leds/Kconfig         |    9 +
>  drivers/leds/Makefile        |    1 +
>  drivers/leds/leds-max77693.c | 1070 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/max77693.c       |    5 +-
>  include/linux/mfd/max77693.h |   40 ++
>  5 files changed, 1124 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/leds/leds-max77693.c
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 5032c6f..794055e 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -457,6 +457,15 @@ config LEDS_TCA6507
>  	  LED driver chips accessed via the I2C bus.
>  	  Driver support brightness control and hardware-assisted blinking.
>  
> +config LEDS_MAX77693
> +	tristate "LED support for MAX77693 Flash"
> +	depends on LEDS_CLASS_FLASH
> +	depends on MFD_MAX77693
> +	help
> +	  This option enables support for the flash part of the MAX77693
> +	  multifunction device. It has build in control for two leds in flash
> +	  and torch mode.
> +
>  config LEDS_MAX8997
>  	tristate "LED support for MAX8997 PMIC"
>  	depends on LEDS_CLASS && MFD_MAX8997
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 237c5ba..da1a4ba 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
>  obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
>  obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
> +obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
>  obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
>  obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
>  obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
> diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
> new file mode 100644
> index 0000000..38a2398
> --- /dev/null
> +++ b/drivers/leds/leds-max77693.c
> @@ -0,0 +1,1070 @@
> +/*
> + * LED Flash Class driver for the flash cell of max77693 mfd.
> + *
> + *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
> + *
> + *	Authors: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *		 Andrzej Hajda <a.hajda@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#include <asm/div64.h>
> +#include <linux/led-class-flash.h>
> +#include <linux/led-flash-manager.h>
> +#include <linux/mfd/max77693.h>
> +#include <linux/mfd/max77693-private.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-flash.h>
> +
> +#define MAX77693_LED_NAME_1		"max77693-flash_1"
> +#define MAX77693_LED_NAME_2		"max77693-flash_2"
> +
> +#define MAX77693_TORCH_IOUT_BITS	4
> +
> +#define MAX77693_TORCH_NO_TIMER		0x40
> +#define MAX77693_FLASH_TIMER_LEVEL	0x80
> +
> +#define MAX77693_FLASH_EN_OFF		0
> +#define MAX77693_FLASH_EN_FLASH		1
> +#define MAX77693_FLASH_EN_TORCH		2
> +#define MAX77693_FLASH_EN_ON		3
> +
> +#define MAX77693_FLASH_EN1_SHIFT	6
> +#define MAX77693_FLASH_EN2_SHIFT	4
> +#define MAX77693_TORCH_EN1_SHIFT	2
> +#define MAX77693_TORCH_EN2_SHIFT	0

Which registers are these definitions related to? Could they be defined
next to the registers instead?

You could parameterise these macros, e.g.

#define MAX77693_FLASH_EN_SHIFT(a)	(6 - ((a) - 1) * 2)

> +#define MAX77693_FLASH_LOW_BATTERY_EN	0x80
> +
> +#define MAX77693_FLASH_BOOST_FIXED	0x04
> +#define MAX77693_FLASH_BOOST_LEDNUM_2	0x80
> +
> +#define MAX77693_FLASH_TIMEOUT_MIN	62500
> +#define MAX77693_FLASH_TIMEOUT_MAX	1000000
> +#define MAX77693_FLASH_TIMEOUT_STEP	62500
> +
> +#define MAX77693_TORCH_TIMEOUT_MIN	262000
> +#define MAX77693_TORCH_TIMEOUT_MAX	15728000
> +
> +#define MAX77693_FLASH_IOUT_MIN		15625
> +#define MAX77693_FLASH_IOUT_MAX_1LED	1000000
> +#define MAX77693_FLASH_IOUT_MAX_2LEDS	625000
> +#define MAX77693_FLASH_IOUT_STEP	15625
> +
> +#define MAX77693_TORCH_IOUT_MIN		15625
> +#define MAX77693_TORCH_IOUT_MAX		250000
> +#define MAX77693_TORCH_IOUT_STEP	15625
> +
> +#define MAX77693_FLASH_VSYS_MIN		2400
> +#define MAX77693_FLASH_VSYS_MAX		3400
> +#define MAX77693_FLASH_VSYS_STEP	33
> +
> +#define MAX77693_FLASH_VOUT_MIN		3300
> +#define MAX77693_FLASH_VOUT_MAX		5500
> +#define MAX77693_FLASH_VOUT_STEP	25
> +#define MAX77693_FLASH_VOUT_RMIN	0x0c
> +
> +#define MAX77693_LED_STATUS_FLASH_ON	(1 << 3)
> +#define MAX77693_LED_STATUS_TORCH_ON	(1 << 2)
> +
> +#define MAX77693_LED_FLASH_INT_FLED2_OPEN	(1 << 0)
> +#define MAX77693_LED_FLASH_INT_FLED2_SHORT	(1 << 1)
> +#define MAX77693_LED_FLASH_INT_FLED1_OPEN	(1 << 2)
> +#define MAX77693_LED_FLASH_INT_FLED1_SHORT	(1 << 3)
> +#define MAX77693_LED_FLASH_INT_OVER_CURRENT	(1 << 4)
> +
> +#define MAX77693_MODE_OFF			0
> +#define MAX77693_MODE_FLASH1			(1 << 0)
> +#define MAX77693_MODE_FLASH2			(1 << 1)
> +#define MAX77693_MODE_TORCH1			(1 << 2)
> +#define MAX77693_MODE_TORCH2			(1 << 3)
> +#define MAX77693_MODE_FLASH_EXTERNAL1		(1 << 4)
> +#define MAX77693_MODE_FLASH_EXTERNAL2		(1 << 5)
> +
> +enum {
> +	FLED1,
> +	FLED2
> +};
> +
> +enum {
> +	FLASH,
> +	TORCH
> +};
> +
> +struct max77693_led {
> +	struct regmap *regmap;
> +	struct platform_device *pdev;
> +	struct max77693_led_platform_data *pdata;
> +	struct mutex lock;
> +
> +	struct led_classdev_flash ldev1;
> +	struct work_struct work1_brightness_set;
> +	struct v4l2_flash *v4l2_flash1;
> +
> +	struct led_classdev_flash ldev2;
> +	struct work_struct work2_brightness_set;
> +	struct v4l2_flash *v4l2_flash2;
> +
> +	unsigned int torch1_brightness;
> +	unsigned int torch2_brightness;
> +	unsigned int flash1_timeout;
> +	unsigned int flash2_timeout;

Could you use e.g. an array of structs instead? You could remove a lot
of redundant code operating on the other led.

> +	unsigned int current_flash_timeout;
> +	unsigned int mode_flags;
> +	u8 torch_iout_reg;
> +	bool iout_joint;
> +};

...

> +static int max77693_led_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
> +	struct max77693_led *led;
> +	struct max77693_led_platform_data *p;
> +	int ret;
> +
> +	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->pdev = pdev;
> +	led->regmap = iodev->regmap;
> +	platform_set_drvdata(pdev, led);
> +	ret = max77693_led_get_platform_data(led);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	p = led->pdata;
> +	mutex_init(&led->lock);
> +
> +	if (p->num_leds == 1 && p->fleds[FLED1] && p->fleds[FLED2])
> +		led->iout_joint = true;
> +
> +	ret = max77693_setup(led);
> +	if (ret < 0)
> +		return ret;

goto err_register_led1;

> +	if (led->iout_joint || p->fleds[FLED1]) {
> +		ret = max77693_register_led1(led);
> +		if (ret < 0)
> +			goto err_register_led1;
> +	}
> +
> +	if (!led->iout_joint && p->fleds[FLED2]) {
> +		ret = max77693_register_led2(led);
> +		if (ret < 0)
> +			goto err_register_led2;
> +	}
> +
> +	return 0;
> +
> +err_register_led2:
> +	if (!p->fleds[FLED1])
> +		goto err_register_led1;
> +	v4l2_flash_release(led->v4l2_flash1);
> +	led_classdev_flash_unregister(&led->ldev1);
> +err_register_led1:
> +	mutex_destroy(&led->lock);
> +
> +	return ret;
> +}

...

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
