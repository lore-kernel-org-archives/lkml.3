Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaFHM6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:58:34 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:55139 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaFHM6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
References: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 8 Jun 2014 21:58:11 +0900
Message-ID: <CAAVeFuKGyGXQtD9XwqQ=V1M4-tHQLBF5j5i3+-eGCawS0iJNew@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: Add a defer reset object to send board specific reset
To: Houcheng Lin <houcheng@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 10:09 AM, Houcheng Lin <houcheng@gmail.com> wrote:
> The Problem
> -----------
> The reset signal on a hardware board is send either:
>     - during machine initialization
>     - during bus master's initialization
>
> In some hardware design, devices on bus need a non-standard and extra reset
> signal after bus is initialied. Most reason is to wake up device from hanging
> state.
>
> The board spefic reset code can not be put into machine init code, as it is
> too early. This code can not also be put onto chip's driver, as it is board
> specific and not suitable for a common chip driver.
>
> Defer Reset Object
> ------------------
> The defer reset object is to resolve this issue, developer can put a defer-
> reset device on the board's dts file and enable DEFER RESET OBJECT CONFIG.
> During driver init-calls, a defer-reset object is created and issue reset signal
> after the enclosing device is initialized.
>
> This eliminate the need to rewrite a driver module with only one purpose: sending
> a board specific reset. This also allow mainstream kernel to support many boards
> that modify the common drivers to send board specific reset. Configuring defer-reset
> device in dts leave the board specific reset rules on board level and simple to
> maintain.

Interesting approach to a long-standing problem. I had my own
embarrassing attempt at it (power sequences), and more recently Olof
(CC'd) sent something related for the MMC bus
(http://www.spinics.net/lists/devicetree/msg18900.html - I'm not sure
what has become of this patch?). And there are certainly other
attempts that I don't know of.

So, let's say that this time we do it for real. There are some points
I like in your approach, like the fact that it is completely
bus-agnostic. But although it will certainly not end up being as
controversial as the power sequences have been, I am not sure
everybody will agree to use the DT this way...

>
> Example dts File
> ----------------
>     usb-ehci-chip@1211000{
>         usb-phy = <&usb2_phy>;
>         defer_reset_vbus {
>             compatible = "defer-reset";
>             reset-gpios = <&gpx3 5 1>;
>             reset-init = <0>;
>             reset-end = <1>;
>             delay = <5>;
>         };
>     };

Here I am not convinced that everybody will like the fact that this
appears as a device of its own, with its own compatible property.
Let's see what the DT people think of it.

>
> Block Diagram of dts File
> -------------------------
>     +-------------------------------------+
>     | usb-ehci-chip@1211000               |
>     |   +-------------------------+       |
>     |   | defer-reset(gpx3)       |       |
>     |   +-------------------------+       |
>     +-------------------------------------+
>
> Signed-off-by: Houcheng Lin <houcheng@gmail.com>
> ---
>  drivers/gpio/Kconfig            |   8 ++
>  drivers/gpio/Makefile           |   1 +
>  drivers/gpio/gpio-defer-reset.c | 179 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 188 insertions(+)
>  create mode 100644 drivers/gpio/gpio-defer-reset.c
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index a86c49a..99aa0d6 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -851,6 +851,14 @@ config GPIO_BCM_KONA
>         help
>           Turn on GPIO support for Broadcom "Kona" chips.
>
> +config GPIO_DEFER_RESET
> +       bool "Defer reset driver via gpio"
> +       depends on OF_GPIO
> +       help
> +         Enable defer reset drvier

s/drvier/driver

> +         The reset signal would be issued after a device on USB or PCI bus is initialied.

s/initialied/initialized

> +         The dependency of reset signal and device can be specified in board's dts file.
> +
>  comment "USB GPIO expanders:"
>
>  config GPIO_VIPERBOARD
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 6309aff..0754758 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -101,3 +101,4 @@ obj-$(CONFIG_GPIO_WM8994)   += gpio-wm8994.o
>  obj-$(CONFIG_GPIO_XILINX)      += gpio-xilinx.o
>  obj-$(CONFIG_GPIO_XTENSA)      += gpio-xtensa.o
>  obj-$(CONFIG_GPIO_ZEVIO)       += gpio-zevio.o
> +obj-$(CONFIG_GPIO_DEFER_RESET) += gpio-defer-reset.o
> diff --git a/drivers/gpio/gpio-defer-reset.c b/drivers/gpio/gpio-defer-reset.c
> new file mode 100644
> index 0000000..c6decab
> --- /dev/null
> +++ b/drivers/gpio/gpio-defer-reset.c
> @@ -0,0 +1,179 @@
> +/*
> + * GPIO Defer Reset Driver
> + *
> + * Copyright (C) 2014 Houcheng Lin
> + * Author: Houcheng Lin <houcheng@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/usb/phy.h>
> +#include <linux/usb/samsung_usb_phy.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/usb/otg.h>
> +
> +
> +#define DRIVER_DESC "GPIO Defer Reset Driver"
> +#define GDR_MAX_DEV 32
> +
> +
> +static DEFINE_MUTEX(deferred_reset_mutex);
> +static LIST_HEAD(deferred_reset_list);
> +
> +
> +struct defer_reset_private {
> +       struct list_head next;
> +       struct device_node *node;  /* defer_reset device */
> +       int    issued;
> +};
> +
> +static void gdr_issue_reset(
> +       struct platform_device *pdev, struct device_node *dnode)
> +{
> +       int gpio;
> +       int i;
> +       int count = of_gpio_named_count(dnode, "reset-gpios");
> +       u32 reset_init[GDR_MAX_DEV];
> +       u32 reset_end[GDR_MAX_DEV];
> +       u32 delay;
> +
> +       if (count != of_property_count_u32_elems(dnode, "reset-init")) {
> +               dev_err(&pdev->dev, "should call std error here, number is wrong:%d\n",
> +                       of_property_count_u32_elems(dnode, "reset-init"));
> +               return;
> +       }
> +       if (count != of_property_count_u32_elems(dnode, "reset-end")) {
> +               dev_err(&pdev->dev, "should call std error here, number is wrong:%d\n",
> +                       of_property_count_u32_elems(dnode, "reset-end"));
> +               return;
> +       }
> +       if (count > GDR_MAX_DEV) {
> +               dev_err(&pdev->dev, "too large reset array!\n");
> +               return;
> +       }
> +
> +       /* setup parameters */
> +       of_property_read_u32_array(dnode, "reset-init", reset_init, count);
> +       of_property_read_u32_array(dnode, "reset-end", reset_end, count);
> +       of_property_read_u32(dnode, "delay", &delay);
> +
> +       /* reset init */
> +       for (i = 0; i < count; i++) {
> +               gpio = of_get_named_gpio(dnode, "reset-gpios", i);

Quick note: please make use of the gpiod interface in your code
(include/linux/gpio/consumer.h and Documentation/gpio/consumer.txt).
That will simplify it a great deal and will force you to actually
request the GPIOs, which you omitted here.

> +               dev_info(&pdev->dev,
> +                       "issue reset to gpio %d for device [%s]\n",
> +                       gpio, dnode->parent->name);
> +               if (!gpio_is_valid(gpio))
> +                       continue;
> +               __gpio_set_value(gpio, reset_init[i]);
> +       }
> +       if (delay == 0)
> +               delay = 5;
> +       mdelay(delay);
> +       /* reset end */
> +       for (i = 0; i < count; i++) {
> +               gpio = of_get_named_gpio(dnode, "reset-gpios", i);
> +               if (!gpio_is_valid(gpio))
> +                       continue;
> +               __gpio_set_value(gpio, reset_end[i]);
> +       }
> +}
> +
> +/**
> +  * the pdev parameter is null as it is provided by register routine, platform_device_register_simple
> +  **/
> +static int gdr_probe(struct platform_device *pdev)
> +{
> +       struct list_head *pos;
> +
> +       pr_debug("gpio defer reset probe\n");
> +       list_for_each(pos, &deferred_reset_list) {
> +               struct platform_device *pd;
> +               struct defer_reset_private *prv = list_entry(
> +                       pos, struct defer_reset_private, next);
> +               if (prv->issued)
> +                       continue;
> +               pd = of_find_device_by_node(
> +                       prv->node->parent);
> +               if (pd->dev.driver != 0) {
> +                       gdr_issue_reset(pdev, prv->node);
> +                       prv->issued = 1;

Is there anything that prevents you from removing (and freeing) the
items from the list once the reset is issued?

> +               }
> +       }
> +       list_for_each(pos, &deferred_reset_list) {
> +               struct defer_reset_private *prv = list_entry(pos,
> +                       struct defer_reset_private, next);
> +               if (!prv->issued)
> +                       return -EPROBE_DEFER;
> +       }
> +       return 0;

If you can remove your defer_reset_private instances as they are
processed you can simple return 0 if the list is empty, or
-EPROBE_DEFER otherwise. And probably get rid of your "issued" member
too.

Also, once everything is processed, it would be nice to de-register your device.

Before doing a more thorough review, I'd like to discuss the basic
idea. All the previous attempts at implementing an out-of-bus reset
mechanism are strong evidence that something like this is needed.
Having a generic mechanism would be a great plus. I am not convinced
that using a dummy device instance is the right thing to do though.
Also depending on the bus or device you might desire a different
timing for issuing the reset: e.g. I know of a modem on a discoverable
bus (MMC) that will only let itself be probed after the reset is
applied.

Maybe something ought to be implemented at a deeper level, like the
bus (as in, all of them) of even the device layer?

Alex.
