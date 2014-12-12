Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbaLLIyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:54:36 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50630 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaLLIyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141210234817.GB13407@ti.com>
References: <1417726922-10376-1-git-send-email-bparrot@ti.com>
 <1417726922-10376-2-git-send-email-bparrot@ti.com> <CAAVeFuK0zNOW-_+J5HgjZ5A_5sTqXvzJkzq0Z52Eewudj0pTng@mail.gmail.com>
 <20141210234817.GB13407@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 12 Dec 2014 17:54:06 +0900
Message-ID: <CAAVeFuJXpzu-O3A+=038fjokkKxa7OyRjmFgihm01xP1P-01Dg@mail.gmail.com>
Subject: Re: [Patch v3 1/2] gpio: add GPIO hogging mechanism
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

On Thu, Dec 11, 2014 at 8:48 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Alexandre Courbot <gnurou@gmail.com> wrote on Wed [2014-Dec-10 20:19:51 +0900]:
>> On Fri, Dec 5, 2014 at 6:02 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > Based on Boris Brezillion's work this is a reworked patch
>> > of his initial GPIO hogging mechanism.
>> > This patch provides a way to initally configure specific GPIO
>> > when the gpio controller is probed.
>> >
>> > The actual DT scanning to collect the GPIO specific data is performed
>> > as part of the gpiochip_add().
>> >
>> > The purpose of this is to allows specific GPIOs to be configured
>> > without any driver specific code.
>> > This particularly useful because board design are getting
>> > increasingly complex and given SoC pins can now have upward
>> > of 10 mux values a lot of connections are now dependent on
>> > external IO muxes to switch various modes and combination.
>> >
>> > Specific drivers should not necessarily need to be aware of
>> > what accounts to a specific board implementation. This board level
>> > "description" should be best kept as part of the dts file.
>> >
>> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> > ---
>> > Changes since v2:
>> >  * Refactor the gpio-hog mechanism to split the DT related action
>> >    from the actual "hogging" operation.
>> >  * This allows non-DT providers to implement hogs as well.
>> >  * Added FLAG_IS_HOGGED to mark hogged gpio and make gpiochip removal
>> >    able to release hogged gpio.
>> >  * Similarly to the hogging, the cleanup is performed as part of
>> >    of_gpiochip_remove
>> >  * Refactor the gpio-hog mechanism as private functions meant to
>> >    be to invoked from of_gpiochip_add().
>> >
>> > Changes since v1:
>> >  * Refactor the gpio-hog mechanism as private functions meant to
>> >    be to invoked from of_gpiochip_add().
>> >
>> >  drivers/gpio/gpiolib-of.c     | 127 ++++++++++++++++++++++++++++++++++++++++++
>> >  drivers/gpio/gpiolib.c        | 118 ++++++++++++++++++++++++++++++---------
>> >  drivers/gpio/gpiolib.h        |   1 +
>> >  include/linux/gpio/consumer.h |   9 +++
>> >  4 files changed, 229 insertions(+), 26 deletions(-)
>> >
>> > diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
>> > index 604dbe6..e13134d 100644
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
>> > @@ -111,6 +112,128 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
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
>> > +       if (!of_property_read_string(np, "direction", &dir_val)) {
>> > +               if (!strcmp(dir_val, "input"))
>> > +                       *dflags |= GPIOD_IN;
>> > +               else if (!strcmp(dir_val, "output-low"))
>> > +                       *dflags |= GPIOD_OUT_LOW;
>> > +               else if (!strcmp(dir_val, "output-high"))
>> > +                       *dflags |= GPIOD_OUT_HIGH;
>> > +       }
>>
>> ... else?
>>
>> We should probably return an error if the property is not specified -
>> is there a point in hogging a GPIO without a direction? E.g:
>>
>> if (of_property_read_string(np, "direction", &dir_val))
>>     return ERR_PTR(-EINVAL);
>>
>> if (!strcmp(...
>>
>> to use the nice pattern that errors (and not normal behavior) are the exception.
>
> Bah, I was going for compartmentalization.
> It make sense if you don't think about it ..... :)
>
>>
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
>> > + * _gpiochip_hog - Scan gpio-controller and apply GPIO hog as requested
>> > + * @chip:      gpio chip to act on
>> > + *
>> > + * This is only used by of_gpiochip_add to request/set GPIO initial
>> > + * configuration.
>> > + */
>> > +static void _gpiochip_hog(struct gpio_chip *chip)
>>
>> Rename to of_gpio_scan_hogs() maybe?
>
> Given that it is meant for gpiochip_add, how about
> _gpiochip_scan_hogs()?

of_gpiochip_scan_hogs(), and this is my last offer. :P (why do you
want to prefix it with __ btw?)

>
>>
>> > +{
>> > +       struct gpio_desc *desc = NULL;
>> > +       struct device_node *np;
>> > +       const char *name;
>> > +       enum gpio_lookup_flags lflags;
>> > +       enum gpiod_flags dflags;
>> > +
>> > +       for_each_child_of_node(chip->dev->of_node, np) {
>> > +               if (!of_property_read_bool(np, "gpio-hog"))
>> > +                       continue;
>> > +
>> > +               desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
>> > +               if (IS_ERR(desc))
>> > +                       continue;
>> > +
>> > +               __gpiod_hog(desc, name, lflags, dflags);
>>
>> You are not propagating any error returned by __gpiod_hog here.
>
> _gpiochip_hog is a void function given that __gpiod_hog() is the last call of that loop
> there is nothing to propagate.
> You would still want to scan all of the child node regardless of errors, no?

You're right. Besides hogging failure should probably not be a fatal
error. In this case please make sure that all possible errors related
to hogging are at least reported accordingly in the log.

>
>>
>> > +       }
>> > +}
>> > +
>> > +/**
>> > + * _gpiochip_unhog - Scan gpio-controller and apply GPIO hog as requested
>> > + * @chip:      gpio chip to act on
>> > + *
>> > + * This is only used by of_gpiochip_remove to free hogged gpios
>> > + *
>> > + */
>> > +static void _gpiochip_unhog(struct gpio_chip *chip)
>> > +{
>> > +       int id;
>> > +
>> > +       for (id = 0; id < chip->ngpio; id++) {
>> > +               if (test_bit(FLAG_IS_HOGGED, &chip->desc[id].flags))
>> > +                       gpiod_put(&chip->desc[id]);
>> > +       }
>> > +}
>>
>> This function is not DT-specific. It should be included in gpiolib.c
>> and called from there before of_gpiochip_remove().
>
> Agreed, any name request while I am at it or tis this fine as is?

Name looks good, although I don't know why the '_' prefix?

>
>>
>> > +
>> > +/**
>> >   * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
>> >   * @gc:                pointer to the gpio_chip structure
>> >   * @np:                device node of the GPIO chip
>> > @@ -302,10 +425,14 @@ void of_gpiochip_add(struct gpio_chip *chip)
>> >
>> >         of_gpiochip_add_pin_range(chip);
>> >         of_node_get(chip->of_node);
>> > +
>> > +       _gpiochip_hog(chip);
>> >  }
>> >
>> >  void of_gpiochip_remove(struct gpio_chip *chip)
>> >  {
>> >         gpiochip_remove_pin_ranges(chip);
>> >         of_node_put(chip->of_node);
>> > +
>> > +       _gpiochip_unhog(chip);
>> >  }
>> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> > index e8e98ca..4ef6eb8 100644
>> > --- a/drivers/gpio/gpiolib.c
>> > +++ b/drivers/gpio/gpiolib.c
>> > @@ -849,6 +849,7 @@ static bool __gpiod_free(struct gpio_desc *desc)
>> >                 clear_bit(FLAG_REQUESTED, &desc->flags);
>> >                 clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
>> >                 clear_bit(FLAG_OPEN_SOURCE, &desc->flags);
>> > +               clear_bit(FLAG_IS_HOGGED, &desc->flags);
>> >                 ret = true;
>> >         }
>> >
>> > @@ -1631,6 +1632,58 @@ struct gpio_desc *__must_check __gpiod_get_optional(struct device *dev,
>> >  }
>> >  EXPORT_SYMBOL_GPL(__gpiod_get_optional);
>> >
>> > +
>> > +/**
>> > + * __gpiod_get_helper - helper function to request and configure a given GPIO
>> > + * @desc:      gpio whose value will be assigned
>> > + * @con_id:    unction within the GPIO consumer
>> > + * @lflags:    gpio_lookup_flags - returned from of_find_gpio() or
>> > + *             of_get_gpio_hog()
>> > + * @dflags:    gpiod_flags - optional GPIO initialization flags
>> > + *
>> > + * Return 0 on success, -ENOENT if no GPIO has been assigned to the
>> > + * requested function and/or index, or another IS_ERR() code if an error
>> > + * occurred while trying to acquire the GPIO.
>> > + */
>> > +static int __gpiod_get_helper(struct gpio_desc *desc, const char *con_id,
>> > +               unsigned long lflags, enum gpiod_flags dflags)
>> > +{
>> > +       int status;
>> > +
>> > +       status = gpiod_request(desc, con_id);
>>
>> As I mentioned in the previous revision, this will prevent the module
>> from being unloaded with hogged GPIOs. You need to use
>> gpiochip_request_own_desc() here and gpiochip_free_own_desc() instead
>> of gpiod_put() to free hogged GPIOs. Therefore the call to
>> gpiod_request/gpiochip_request_own_gpio should be taken out of this
>> (very nice otherwise!) helper.
>
> I can split the functionality out but I do not understand why in this case using
> gpiod_request would prevent module from being unloaded?
> Isn't gpiochip_remove() part of a gpio module unload sequence?
>
> Because then the _gpiochip_unhog() would release these descriptors. Am I missing something?

This is because gpiod_request() does a try_module_get(), which will
cause an error when someone tries to unload the module with, say,
rmmod. The corresponding calls to gpiod_put() that would decrease the
module usage count are typically done at module unload time, and thus
never get a chance to be called.

> Also would using gpiochip_request_own_desc() basically allow the very same hogged GPIO to be
> requested later on by a consumer.

No, both gpiod_request() and gpiochip_request_own_desc() call
__gpiod_request(), which sets the FLAG_REQUESTED flag on the
descriptor, ensuring it cannot be requested again later.
