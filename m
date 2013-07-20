Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3GTUXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:23:04 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61833 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3GTUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E815CE@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815CE@DQHE06.ent.ti.com>
Date: Sat, 20 Jul 2013 22:23:01 +0200
Message-ID: <CACRpkdZyd_FgDowfFrvxq3RUH6mmYya8ANLS5y8Qh8ertSB+UQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: add LP3943 I2C GPIO expander driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 4:38 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> +++ b/drivers/gpio/gpio-lp3943.c
> @@ -0,0 +1,224 @@
> +/*
> + * TI/National Semiconductor LP3943 GPIO driver
> + *
> + *                     Copyright (C) 2013 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/lp3943.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>

#include <linus/bitops.h>

> +#define to_lp3943_gpio(_chip)  container_of(_chip, struct lp3943_gpio, chip)
> +
> +enum lp3943_gpios {
> +       LP3943_GPIO1,
> +       LP3943_GPIO2,
> +       LP3943_GPIO3,
> +       LP3943_GPIO4,
> +       LP3943_GPIO5,
> +       LP3943_GPIO6,
> +       LP3943_GPIO7,
> +       LP3943_GPIO8,
> +       LP3943_GPIO9,
> +       LP3943_GPIO10,
> +       LP3943_GPIO11,
> +       LP3943_GPIO12,
> +       LP3943_GPIO13,
> +       LP3943_GPIO14,
> +       LP3943_GPIO15,
> +       LP3943_GPIO16,
> +       LP3943_MAX_GPIO,
> +};
> +
> +struct lp3943_gpio {
> +       struct gpio_chip chip;
> +       struct lp3943 *l;
> +       bool is_input[LP3943_MAX_GPIO];

Please do this instead:
u16 is_input;


> +static int lp3943_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct lp3943_gpio *lg = to_lp3943_gpio(chip);
> +       const struct lp3943_reg_cfg *mux = lg->l->mux_cfg;
> +       u8 addr;
> +       u8 mask;
> +       u8 shift;
> +
> +       lg->is_input[offset] = true;

So it would be:
lg->is_input |= BIT(offset);

> +       addr  = mux[offset].reg;
> +       mask  = mux[offset].mask;
> +       shift = mux[offset].shift;
> +
> +       return lp3943_update_bits(lg->l, addr, mask, LP3943_GPIO_IN << shift);
> +}
> +
> +static int lp3943_get_gpio_in_status(struct lp3943_gpio *lg,
> +                               struct gpio_chip *chip, unsigned offset)
> +{
> +       u8 addr;
> +       u8 read;
> +       int err;
> +
> +       switch (offset) {
> +       case LP3943_GPIO1 ... LP3943_GPIO8:
> +               addr = LP3943_REG_GPIO_A;
> +               break;
> +       case LP3943_GPIO9 ... LP3943_GPIO16:
> +               addr = LP3943_REG_GPIO_B;
> +               offset = offset - 8;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       err = lp3943_read_byte(lg->l, addr, &read);
> +       if (err)
> +               return err;
> +
> +       if (read & (1 << offset))
> +               return 1;
> +       else
> +               return 0;

Just:
return !!(read & BIT(offset));

> +}
> +
> +static int lp3943_get_gpio_out_status(struct lp3943_gpio *lg,
> +                               struct gpio_chip *chip, unsigned offset)
> +{
> +       const struct lp3943_reg_cfg *mux = lg->l->mux_cfg;
> +       u8 addr  = mux[offset].reg;
> +       u8 mask  = mux[offset].mask;
> +       u8 shift = mux[offset].shift;
> +       u8 read;
> +       int err;
> +
> +       err = lp3943_read_byte(lg->l, addr, &read);
> +       if (err)
> +               return err;
> +
> +       read = (read & mask) >> shift;
> +
> +       if (read == LP3943_GPIO_OUT_HIGH)
> +               return 1;
> +       else if (read == LP3943_GPIO_OUT_LOW)
> +               return 0;
> +       else
> +               return -EINVAL;
> +}
> +
> +static int lp3943_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct lp3943_gpio *lg = to_lp3943_gpio(chip);
> +
> +       /*
> +        * Limitation:
> +        *   LP3943 doesn't have the GPIO direction register. It provides
> +        *   only input and output status registers.
> +        *   So, direction info is required to handle the 'get' operation.
> +        *   This variable is updated whenever the direction is changed and
> +        *   it is used here.
> +        */
> +
> +       if (lg->is_input[offset])

if (lg->is_input & BIT(offset))

> +               return lp3943_get_gpio_in_status(lg, chip, offset);
> +       else
> +               return lp3943_get_gpio_out_status(lg, chip, offset);
> +}
> +
> +static void lp3943_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       struct lp3943_gpio *lg = to_lp3943_gpio(chip);
> +       const struct lp3943_reg_cfg *mux = lg->l->mux_cfg;
> +       u8 addr;
> +       u8 mask;
> +       u8 shift;
> +       u8 data;
> +
> +       addr  = mux[offset].reg;
> +       mask  = mux[offset].mask;
> +       shift = mux[offset].shift;
> +
> +       if (value)
> +               data = LP3943_GPIO_OUT_HIGH;
> +       else
> +               data = LP3943_GPIO_OUT_LOW;
> +
> +       lp3943_update_bits(lg->l, addr, mask, data << shift);
> +}
> +
> +static int lp3943_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
> +                                       int value)
> +{
> +       struct lp3943_gpio *lg = to_lp3943_gpio(chip);
> +
> +       lp3943_gpio_set(chip, offset, value);
> +       lg->is_input[offset] = false;

lg->is_input &= ~BIT(offset);

> +
> +       return 0;
> +}
> +
> +static const struct gpio_chip lp3943_gpio_chip = {
> +       .label                  = "lp3943",
> +       .owner                  = THIS_MODULE,
> +       .direction_input        = lp3943_gpio_direction_input,
> +       .get                    = lp3943_gpio_get,
> +       .direction_output       = lp3943_gpio_direction_output,
> +       .set                    = lp3943_gpio_set,
> +       .base                   = -1,
> +       .ngpio                  = LP3943_MAX_GPIO,
> +       .can_sleep              = 1,
> +};
> +
> +static int lp3943_gpio_probe(struct platform_device *pdev)
> +{
> +       struct lp3943 *l = dev_get_drvdata(pdev->dev.parent);
> +       struct lp3943_gpio *lg;
> +       int ret;
> +
> +       lg = devm_kzalloc(&pdev->dev, sizeof(struct lp3943_gpio), GFP_KERNEL);
> +       if (!lg)
> +               return -ENOMEM;
> +
> +       lg->l = l;
> +       lg->chip = lp3943_gpio_chip;
> +       lg->chip.dev = &pdev->dev;
> +
> +       platform_set_drvdata(pdev, lg);
> +
> +       ret = gpiochip_add(&lg->chip);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "failed to add GPIO chip, err:%d\n", ret);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int lp3943_gpio_remove(struct platform_device *pdev)
> +{
> +       struct lp3943_gpio *lg = platform_get_drvdata(pdev);
> +       return gpiochip_remove(&lg->chip);
> +}
> +
> +static struct platform_driver lp3943_gpio_driver = {
> +       .probe = lp3943_gpio_probe,
> +       .remove = lp3943_gpio_remove,
> +       .driver = {
> +               .name = "lp3943-gpio",
> +               .owner = THIS_MODULE,
> +       },

No device tree probing support? Why?

Yours,
Linus Walleij
