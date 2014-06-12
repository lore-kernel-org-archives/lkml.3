Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaFLMfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:35:44 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45978 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaFLMfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
References: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
Date: Thu, 12 Jun 2014 14:35:40 +0200
Message-ID: <CACRpkdZvANiXp2S134jmcsFDr1m=dqGkpsf3Y6ZAg6mvd6RHOQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: Add a defer reset object to send board specific reset
From: Linus Walleij <linus.walleij@linaro.org>
To: Houcheng Lin <houcheng@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 3:09 AM, Houcheng Lin <houcheng@gmail.com> wrote:

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

This needs some serious DT binding documentation. What are you trying to
achive here? Any kind of sequence encoding in DT is out of the question.

>             delay = <5>;

nanoseconds? milliseconds? seconds? years? picoseconds?

>         };
>     };

OK this is interesting stuff..

But this driver *MUST* live under drivers/power/reset/*, as it
has absolutely *nothing* to do with GPIO except for being a consumer
of it. I won't merge it.

And you should discuss it with Dmitry and David W.

But I will review it nevertheless :-D

> +#include <linux/clk.h>

What? This driver is not using any clocks.

> +#include <linux/dma-mapping.h>

What?

> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>

No way. Include
#include <linux/gpio/consumer.h>

Read up on how to use that in
Documentation/gpio/consumer.txt
Thanks.

> +#include <linux/platform_device.h>
> +#include <linux/usb/phy.h>
> +#include <linux/usb/samsung_usb_phy.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/usb/otg.h>

Please go over this list and see what is actually needed.

> +
> +
> +#define DRIVER_DESC "GPIO Defer Reset Driver"

#define DRIVER_NAME would be more to the point.

> +#define GDR_MAX_DEV 32
> +
> +static DEFINE_MUTEX(deferred_reset_mutex);
> +static LIST_HEAD(deferred_reset_list);
> +
> +struct defer_reset_private {
> +       struct list_head next;
> +       struct device_node *node;  /* defer_reset device */
> +       int    issued;

Use a bool.

> +};
> +
> +static void gdr_issue_reset(
> +       struct platform_device *pdev, struct device_node *dnode)
> +{
> +       int gpio;
> +       int i;
> +       int count = of_gpio_named_count(dnode, "reset-gpios");

Hm seems reasonable...

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

OK so you stack up these u32's...

> +       /* reset init */
> +       for (i = 0; i < count; i++) {
> +               gpio = of_get_named_gpio(dnode, "reset-gpios", i);

Use gpiod interface to obtain a GPIO descriptor.

> +               dev_info(&pdev->dev,
> +                       "issue reset to gpio %d for device [%s]\n",
> +                       gpio, dnode->parent->name);
> +               if (!gpio_is_valid(gpio))
> +                       continue;
> +               __gpio_set_value(gpio, reset_init[i]);

__gpio_set_value??

Are you using the platform-specific implementation? No way.

gpiod_set_value() please.

> +       }
> +       if (delay == 0)
> +               delay = 5;

So what on earth says that this is a sensible default?
Why not, say 10 seconds?

I think probe should simply fail if delay is not specified.

> +       mdelay(delay);

Aha so it is milliseconds. OK.

> +       /* reset end */
> +       for (i = 0; i < count; i++) {
> +               gpio = of_get_named_gpio(dnode, "reset-gpios", i);
> +               if (!gpio_is_valid(gpio))
> +                       continue;
> +               __gpio_set_value(gpio, reset_end[i]);
> +       }

OK so reset init and reset end is a way to specify when reset
is asserted (as one or zero).

DON'T do this. The GPIO bindings already know a way to define
if GPIOs are active high or low, and the gpiod interface will invert
the signal for you if this is specified as active low.

This way you get rid of both strange properties.

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
> +               }
> +       }
> +       list_for_each(pos, &deferred_reset_list) {
> +               struct defer_reset_private *prv = list_entry(pos,
> +                       struct defer_reset_private, next);
> +               if (!prv->issued)
> +                       return -EPROBE_DEFER;
> +       }
> +       return 0;
> +}
> +
> +static int gdr_remove(struct platform_device *pdev)
> +{
> +       return 0;
> +}

Isn't this callback optional then?

> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id gdr_match[] = {
> +       { .compatible = "gpio-defer-reset" },
> +       { .compatible = "defer-reset" },

Why two compatible strings? If we're inventing this let's stick to
one.

> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, gdr_match);
> +#endif
> +
> +
> +static struct platform_driver gdr_driver = {
> +       .probe      = gdr_probe,
> +       .remove     = gdr_remove,
> +       .driver = {
> +               .name   = "defer-reset",

So why are you not using this #define DRIVER_DESC for the name
you did up there?

> +               .owner  = THIS_MODULE,
> +               .of_match_table = of_match_ptr(gdr_match),
> +       }
> +};
> +
> +static int __init gdr_init(void)
> +{
> +       struct device_node *node;
> +       pr_info("defer-reset-object initialied.\n");
> +       platform_device_register_simple("defer-reset", -1, NULL, 0);
> +       mutex_lock(&deferred_reset_mutex);
> +       for_each_compatible_node(node, NULL, "defer-reset") {
> +               struct defer_reset_private *prv = kmalloc(
> +                       sizeof(struct defer_reset_private), GFP_KERNEL);
> +               prv->node = node;
> +               prv->issued = 0;
> +               list_add_tail(&prv->next, &deferred_reset_list);
> +       }
> +       mutex_unlock(&deferred_reset_mutex);
> +       return platform_driver_register(&gdr_driver);
> +}
> +module_init(gdr_init);

Hm hm. I don't know if this is a good approach. Grant will know maybe.

> +
> +static void __exit gdr_cleanup(void)
> +{
> +       platform_driver_unregister(&gdr_driver);
> +}
> +module_exit(gdr_cleanup);

You forgot to free the deferred_reset_list here. Fix that.

Yours,
Linus Walleij
