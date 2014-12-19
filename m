Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLSGBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:01:16 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46963 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaLSGBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:01:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141218170810.GF16916@ti.com>
References: <1418422051-9471-1-git-send-email-bparrot@ti.com>
 <1418422051-9471-2-git-send-email-bparrot@ti.com> <CAAVeFuLrYovh6-RP0T4Cy8SV2Uuh4k2LD8PKmEahXgr-jKFgtg@mail.gmail.com>
 <20141218170810.GF16916@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 19 Dec 2014 15:00:52 +0900
Message-ID: <CAAVeFuKDGEx8okVHB9YkbBB0tAao1Vho_wqvjc=U1hnbjrmrJA@mail.gmail.com>
Subject: Re: [Patch v4 1/2] gpio: add GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 2:08 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Alexandre Courbot <gnurou@gmail.com> wrote on Wed [2014-Dec-17 17:41:51 +0900]:
>> Looks ok to me. I have a few nits below, but otherwise I am happy with
>> how it turned out:
>>
>> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> I'll add this to the next version.
>
>>
>> Thanks for your patience with this!
>>
>> On Sat, Dec 13, 2014 at 7:07 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > Based on Boris Brezillion's work this is a reworked patch
>> > of his initial GPIO hogging mechanism.
>> > This patch provides a way to initally configure specific GPIO
>>
>> s/initally/initially
>>
>> > when the gpio controller is probed.
>>
>> GPIO in capitals please.
>>
>> >
>> > The actual DT scanning to collect the GPIO specific data is performed
>> > as part of the gpiochip_add().
>>
>> d/the
>>
>> >
>> > The purpose of this is to allows specific GPIOs to be configured
>>
>> s/allows/allow
>>
>> > without any driver specific code.
>> > This particularly useful because board design are getting
>>
>> This is particularly
>>
>> > increasingly complex and given SoC pins can now have upward
>> > of
>>
>> s/upward of/up to?
>
> well i meant more than 10 I think in some cases we have 13.
>
>>
>> > 10 mux values a lot of connections are now dependent on
>>
>> seems like a comma is missing here.
>>
>> > external IO muxes to switch various modes and combination.
>>
>> not sure what a combination is in that context.
>>
>> >
>> > Specific drivers should not necessarily need to be aware of
>> > what accounts to a specific board implementation. This board level
>> > "description" should be best kept as part of the dts file.
>> >
>> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> > ---
>> > Changes since v3:
>> >  * Relocated the non-DT "hog" function to gpiolib.c.
>> >  * Rename some of the function to be clearer and remove _ prefixes.
>> >  * Replace the gpiod_request/gpiod_put usage with
>> >    gpiochip_request_own_desc/free_own_desc version instead.
>> >  * Refactor some of the logic to better handle error condition/reporting
>> >  * Renamed the "direction" DT properties to "state".
>> >
>> >  drivers/gpio/gpiolib-of.c | 119 ++++++++++++++++++++++++++++++++++++++++++
>> >  drivers/gpio/gpiolib.c    | 128 ++++++++++++++++++++++++++++++++++++++--------
>> >  drivers/gpio/gpiolib.h    |   3 ++
>> >  3 files changed, 230 insertions(+), 20 deletions(-)
>> >
>> > diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
>> > index 604dbe6..5422216 100644
>> > --- a/drivers/gpio/gpiolib-of.c
>> > +++ b/drivers/gpio/gpiolib-of.c
>> > @@ -22,6 +22,7 @@
>> >  #include <linux/of_gpio.h>
>> >  #include <linux/pinctrl/pinctrl.h>
>> >  #include <linux/slab.h>
>> > +#include <linux/gpio/machine.h>
>> >
>> >  #include "gpiolib.h"
>> >
>> > @@ -111,6 +112,122 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
>> >  EXPORT_SYMBOL(of_get_named_gpio_flags);
>> >
>> >  /**
>> > + * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
>> > + * @np:                device node to get GPIO from
>> > + * @name:      GPIO line name
>> > + * @flags:     a flags pointer to fill in
>> > + *
>> > + * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
>> > + * value on the error condition.
>> > + */
>> > +
>> > +static struct gpio_desc *of_get_gpio_hog(struct device_node *np,
>> > +                                 const char **name,
>> > +                                 enum gpio_lookup_flags *lflags,
>> > +                                 enum gpiod_flags *dflags)
>> > +{
>> > +       struct device_node *chip_np;
>> > +       enum of_gpio_flags xlate_flags;
>> > +       struct gpio_desc *desc;
>> > +       const char *dir_val;
>> > +       struct gg_data gg_data = {
>> > +               .flags = &xlate_flags,
>> > +               .out_gpio = NULL,
>>
>> out_gpio will be set to NULL if you don't specify it, so you don't
>> need this last line.
>
> ok
>
>>
>> > +       };
>> > +       u32 tmp;
>> > +       int i, ret;
>> > +
>> > +       chip_np = np->parent;
>> > +       if (!chip_np)
>> > +               return ERR_PTR(-EINVAL);
>> > +
>> > +       xlate_flags = 0;
>> > +       *lflags = 0;
>> > +       *dflags = 0;
>> > +
>> > +       ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
>> > +       if (ret)
>> > +               return ERR_PTR(ret);
>> > +
>> > +       if (tmp > MAX_PHANDLE_ARGS)
>> > +               return ERR_PTR(-EINVAL);
>> > +
>> > +       gg_data.gpiospec.args_count = tmp;
>> > +       gg_data.gpiospec.np = chip_np;
>> > +       for (i = 0; i < tmp; i++) {
>> > +               ret = of_property_read_u32_index(np, "gpios", i,
>> > +                                          &gg_data.gpiospec.args[i]);
>> > +               if (ret)
>> > +                       return ERR_PTR(ret);
>> > +       }
>> > +
>> > +       gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
>> > +       if (!gg_data.out_gpio) {
>> > +               if (np->parent == np)
>> > +                       return ERR_PTR(-ENXIO);
>> > +               else
>> > +                       return ERR_PTR(-EPROBE_DEFER);
>> > +       }
>> > +
>> > +       if (xlate_flags & OF_GPIO_ACTIVE_LOW)
>> > +               *lflags |= GPIO_ACTIVE_LOW;
>> > +
>> > +       if (of_property_read_string(np, "state", &dir_val)) {
>> > +               pr_warn("%s: GPIO:%d (%s): no hogging state specified, bailing out\n",
>> > +                        __func__, desc_to_gpio(gg_data.out_gpio), np->name);
>> > +               return ERR_PTR(-EINVAL);
>> > +       }
>> > +
>> > +       if (!strcmp(dir_val, "input"))
>> > +               *dflags |= GPIOD_IN;
>> > +       else if (!strcmp(dir_val, "output-low"))
>> > +               *dflags |= GPIOD_OUT_LOW;
>> > +       else if (!strcmp(dir_val, "output-high"))
>> > +               *dflags |= GPIOD_OUT_HIGH;
>> > +       else {
>> > +               pr_warn("%s: GPIO:%d (%s): invalid state '%s' requested, bailing out\n",
>> > +                        __func__, desc_to_gpio(gg_data.out_gpio),
>> > +                       np->name, dir_val);
>> > +               return ERR_PTR(-EINVAL);
>> > +       }
>> > +
>> > +       if (name && of_property_read_string(np, "line-name", name))
>> > +               *name = np->name;
>> > +
>> > +       desc = gg_data.out_gpio;
>> > +
>> > +       return desc;
>> > +}
>> > +
>> > +/**
>> > + * of_gpiochip_scan_hogs - Scan gpio-controller and apply GPIO hog as requested
>> > + * @chip:      gpio chip to act on
>> > + *
>> > + * This is only used by of_gpiochip_add to request/set GPIO initial
>> > + * configuration.
>> > + */
>> > +static void of_gpiochip_scan_hogs(struct gpio_chip *chip)
>> > +{
>> > +       struct gpio_desc *desc = NULL;
>> > +       struct device_node *np;
>> > +       const char *name;
>> > +       enum gpio_lookup_flags lflags;
>> > +       enum gpiod_flags dflags;
>> > +
>> > +       for_each_child_of_node(chip->dev->of_node, np) {
>
> As I was backporting this to 3.14 for my own purpose.
> I encountered a NULL pointer dereference here.
> In 3.14 chip->dev (which is optional) is NULL at least on my platform.
> I had to change the above line to:
>
>        for_each_child_of_node(chip->of_node, np) {
>
> Would you recommend the same change here?

That looks ok, yes. IIRC chip->of_node is precisely here because
chip->dev might be NULL sometimes.
