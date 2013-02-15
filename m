Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3BOU1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:27:09 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62785 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3BOU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360896534-20637-2-git-send-email-linux@prisktech.co.nz>
References: <1360896534-20637-1-git-send-email-linux@prisktech.co.nz>
	<1360896534-20637-2-git-send-email-linux@prisktech.co.nz>
Date: Fri, 15 Feb 2013 21:27:06 +0100
Message-ID: <CACRpkdbueZr4rjAydjYfrXetkDYBASoWPf7dguNSwifN3paJ8g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: gpio: vt8500: Add pin control driver for
 Wondermedia SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>, Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 3:48 AM, Tony Prisk <linux@prisktech.co.nz> wrote:

Hm some of these remarks would apply to the BCM2835 driver as
well, I missed to complain at the time it was added. Probably I was
all too excited about the new Raspberry.

Mainly you want Stephens review on this since he wrote the
driver you based it on...

> +++ b/arch/arm/Kconfig
> @@ -1618,10 +1618,10 @@ config LOCAL_TIMERS
>  config ARCH_NR_GPIO
>         int
>         default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
> +       default 512 if SOC_OMAP5
>         default 355 if ARCH_U8500
> +       default 352 if ARCH_VT8500
>         default 264 if MACH_H4700
> -       default 512 if SOC_OMAP5
> -       default 288 if ARCH_VT8500
>         default 0

This seems like a totally unrelated chunk, put that in some
other patch and send off to the ARM SoC people if you want
it changed.

> +obj-$(CONFIG_PINCTRL_WMT)      += pinctrl-wmt.o
> +obj-$(CONFIG_PINCTRL_WM8850)   += pinctrl-wm8850.o

So one front-end driver and one pluggable SoC-driver
I guess.

> +++ b/drivers/pinctrl/pinctrl-wm8850.c
(skipping this file, looks like OK and pure data)

> +++ b/drivers/pinctrl/pinctrl-wmt.c
(...)
> +#define WMT_PINCONF_PACK(__param, __arg)       ((__param << 16) | __arg)
> +#define WMT_PINCONF_UNPACK_PARAM(__conf)       (__conf >> 16)
> +#define WMT_PINCONF_UNPACK_ARG(__conf)         (__conf & 0xffff)

Please use the generic pinconf helper library, there are no magic
configurations in this driver. Look at other drivers using generic pinconf
and get pack/unpack for free and tested.

(then follows a large block of nice, clean code)

> +static int wmt_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
> +                          unsigned long config)
> +{
> +       struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
> +       enum wmt_pinconf_param param = WMT_PINCONF_UNPACK_PARAM(config);
> +       u16 arg = WMT_PINCONF_UNPACK_ARG(config);
> +       u32 bank = pin >> 5;
> +       u32 bit = pin & 0x1f;

Comment the two lines above. What kind of magic is happening?
I can guess, but it's better if it's stated.

(...)
> +static int wmt_gpio_get_value(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
> +       u32 bank = offset >> 5;
> +       u32 bit = offset & 0x1f;

Hm it looks like duplicated code as well. What abot a small
static inline helper function to do the magic?

> +int wmt_pinctrl_probe(struct platform_device *pdev,
> +                     struct wmt_pinctrl_data *data)
> +{
> +       int err;
> +       wmt_desc.pins = data->pins;
> +       wmt_desc.npins = data->npins;
> +
> +       data->gpio_chip = wmt_gpio_chip;
> +       data->gpio_chip.dev = &pdev->dev;
> +       data->gpio_chip.of_node = pdev->dev.of_node;
> +       data->gpio_chip.ngpio = data->nbanks * 32;
> +
> +       platform_set_drvdata(pdev, data);
> +
> +       data->dev = &pdev->dev;
> +       data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
> +       if (IS_ERR(data->pctl_dev)) {
> +               dev_err(&pdev->dev, "Failed to register pinctrl\n");
> +               return -EINVAL;
> +       }
> +
> +       err = gpiochip_add(&data->gpio_chip);
> +       if (err) {
> +               dev_err(&pdev->dev, "could not add GPIO chip\n");
> +               return err;
> +       }

Nice with gpiochip and pinctrl in the same probe, just as
it should be.

> +
> +       data->gpio_range = wmt_pinctrl_gpio_range;
> +
> +       data->gpio_range.gc = &data->gpio_chip;
> +       data->gpio_range.base = data->gpio_chip.base;
> +       data->gpio_range.npins = data->nbanks * 32;
> +       pinctrl_add_gpio_range(data->pctl_dev, &data->gpio_range);

Don't do this. Register ranges from the gpiochip side instead
of from the pinctrl side of things. This way of doing things is
deprecated.

Grep for gpiochip_add_pin_range for examples.

When you have this right I guess you could probably
patch the BCM driver as well since it's so similar.

> +       dev_info(&pdev->dev, "Pin controller initialized\n");
> +
> +       return 0;
> +}

(...)
> +++ b/drivers/pinctrl/pinctrl-wmt.h

Looks OK.

Yours,
Linus Walleij
