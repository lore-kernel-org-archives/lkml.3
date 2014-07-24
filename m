Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbaGXWAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:00:34 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40434 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbaGXWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <fec81db0dd6e08e1e07d3b7c00cb933b2ab63ab3.1405602280.git.andreas.werner@men.de>
References: <cover.1405602280.git.andreas.werner@men.de> <fec81db0dd6e08e1e07d3b7c00cb933b2ab63ab3.1405602280.git.andreas.werner@men.de>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 24 Jul 2014 15:00:09 -0700
Message-ID: <CAK5ve-KG=dBgrBLQ2ejZ3XZip-gk2_5PfmpdKi6d6=B9hMDH1g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] drivers/leds/leds-menf21bmc: introduce MEN
 14F021P00 BMC LED driver
To: Andreas Werner <andreas.werner@men.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>, wim@iguana.be,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 6:18 AM, Andreas Werner <andreas.werner@men.de> wrote:
> Added driver to support the 14F021P00 BMC LEDs.
> The BMC is a Board Management Controll include four LEDs which
> can be switched on and off.
>
> This driver use the I2C interface to the BMC using the menf21bmc MFD Core driver.
>
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>  drivers/leds/Kconfig          |   6 ++
>  drivers/leds/Makefile         |   1 +
>  drivers/leds/leds-menf21bmc.c | 134 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 141 insertions(+)
>  create mode 100644 drivers/leds/leds-menf21bmc.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 27cf0cd..d38ff3f 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -458,6 +458,12 @@ config LEDS_OT200
>           This option enables support for the LEDs on the Bachmann OT200.
>           Say Y to enable LEDs on the Bachmann OT200.
>
> +config LEDS_MENF21BMC
> +       tristate "LED support for the MEN 14F021P00 BMC"
> +       depends on LEDS_CLASS && MFD_MENF21BMC

I think it also depends on I2C.

> +       help
> +         Say Y here to include support for the MEN 14F021P00 BMC LEDs.
> +
>  comment "LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)"
>
>  config LEDS_BLINKM
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 3c03666..cadc433 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_LEDS_MAX8997)            += leds-max8997.o
>  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
>  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
>  obj-$(CONFIG_LEDS_VERSATILE)           += leds-versatile.o
> +obj-$(CONFIG_LEDS_MENF21BMC)           += leds-menf21bmc.o
>
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> diff --git a/drivers/leds/leds-menf21bmc.c b/drivers/leds/leds-menf21bmc.c
> new file mode 100644
> index 0000000..5eaa119
> --- /dev/null
> +++ b/drivers/leds/leds-menf21bmc.c
> @@ -0,0 +1,134 @@
> +/*
> + *  MEN 14F021P00 Board Management Controller (BMC) LEDs Driver.
> + *
> + *  This is the core LED driver of the MEN 14F021P00 BMC.
> + *  There are four LEDs available which can be switched on and off.
> + *  STATUS LED, HOT SWAP LED, USER LED 1, USER LED 2
> + *
> + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> + *  Author: Andreas Werner <andreas.werner@men.de>
> + *  All rights reserved.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/i2c.h>
> +
> +#define BMC_CMD_LED_GET_SET    0xA0
> +#define BMC_BIT_LED_STATUS     BIT(0)
> +#define BMC_BIT_LED_HOTSWAP    BIT(1)
> +#define BMC_BIT_LED_USER1      BIT(2)
> +#define BMC_BIT_LED_USER2      BIT(3)
> +
> +struct menf21bmc_led {
> +       struct led_classdev cdev;
> +       u8 led_bit;
> +       const char *name;
> +       struct i2c_client *i2c_client;
> +};
> +
> +static struct menf21bmc_led leds[] = {
> +       {
> +               .name = "menf21bmc:led_status",
> +               .led_bit = BMC_BIT_LED_STATUS,
> +       },
> +       {
> +               .name = "menf21bmc:led_hotswap",
> +               .led_bit = BMC_BIT_LED_HOTSWAP,
> +       },
> +       {
> +               .name = "menf21bmc:led_user1",
> +               .led_bit = BMC_BIT_LED_USER1,
> +       },
> +       {
> +               .name = "menf21bmc:led_user2",
> +               .led_bit = BMC_BIT_LED_USER2,
> +       }
> +};
> +
> +static DEFINE_MUTEX(led_lock);
> +
> +static void
> +menf21bmc_led_set(struct led_classdev *led_cdev, enum led_brightness value)
> +{
> +       int led_val;
> +       struct menf21bmc_led *led = container_of(led_cdev,
> +                                       struct menf21bmc_led, cdev);
> +
> +       mutex_lock(&led_lock);
> +       led_val = i2c_smbus_read_byte_data(led->i2c_client,
> +                                               BMC_CMD_LED_GET_SET);
> +       if (led_val < 0)
> +               goto err_out;
> +
> +       if (value == LED_OFF)
> +               led_val &= ~led->led_bit;
> +       else
> +               led_val |= led->led_bit;
> +
> +       i2c_smbus_write_byte_data(led->i2c_client,
> +                                       BMC_CMD_LED_GET_SET, led_val);
> +err_out:
> +       mutex_unlock(&led_lock);
> +}
> +
> +static int menf21bmc_led_probe(struct platform_device *pdev)
> +{
> +       int i;
> +       int ret;
> +       struct i2c_client *i2c_client = to_i2c_client(pdev->dev.parent);
> +
> +       for (i = 0; i < ARRAY_SIZE(leds); i++) {
> +               leds[i].cdev.name = leds[i].name;
> +               leds[i].cdev.brightness_set = menf21bmc_led_set;
> +               leds[i].i2c_client = i2c_client;
> +               ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
> +               if (ret < 0)
> +                       goto err_free_leds;
> +       }
> +       dev_info(&pdev->dev, "MEN 140F21P00 BMC LED device enabled\n");
> +
> +       return 0;
> +
> +err_free_leds:
> +       dev_err(&pdev->dev, "failed to register LED device\n");
> +
> +       for (i = i - 1; i >= 0; i--)
> +               led_classdev_unregister(&leds[i].cdev);
> +
> +       return ret;
> +}
> +
> +static int menf21bmc_led_remove(struct platform_device *pdev)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(leds); i++)
> +               led_classdev_unregister(&leds[i].cdev);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver menf21bmc_led = {
> +       .probe          = menf21bmc_led_probe,
> +       .remove         = menf21bmc_led_remove,
> +       .driver         = {
> +               .name           = "menf21bmc_led",
> +               .owner          = THIS_MODULE,
> +       },
> +};
> +

This is not a normal platform driver, it should be a I2C driver.

> +module_platform_driver(menf21bmc_led);

So please move to use module_i2c_driver.

Thanks,
-Bryan

> +
> +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> +MODULE_DESCRIPTION("MEN 14F021P00 BMC led driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:menf21bmc_led");
> --
> 2.0.1
>
