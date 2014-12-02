Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaLBAWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:22:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45719 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbaLBAWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:22:53 -0500
Date: Mon, 1 Dec 2014 18:22:45 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Alexandre Courbot <gnurou@gmail.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141202002244.GB24551@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Courbot <gnurou@gmail.com> wrote on Fri [2014-Nov-28 16:30:01 +0900]:
> On Fri, Nov 21, 2014 at 8:54 AM, Benoit Parrot <bparrot@ti.com> wrote:
> > Based on Boris Brezillion's work this is a reworked patch
> > of his initial GPIO hogging mechanism.
> > This patch provides a way to initally configure specific GPIO
> > when the gpio controller is probed.
> >
> > The actual DT scanning to collect the GPIO specific data is performed
> > as part of the gpiochip_add().
> >
> > The purpose of this is to allows specific GPIOs to be configured
> > without any driver specific code.
> > This particularly useful because board design are getting
> > increasingly complex and given SoC pins can now have upward
> > of 10 mux values a lot of connections are now dependent on
> > external IO muxes to switch various modes and combination.
> >
> > Specific drivers should not necessarily need to be aware of
> > what accounts to a specific board implementation. This board level
> > "description" should be best kept as part of the dts file.
> >
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > ---
> > Changes since v1:
> >  * Refactor the gpio-hog mechanism as private functions meant to
> >    be to invoked from of_gpiochip_add().
> >
> >  drivers/gpio/gpiolib-of.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 188 insertions(+)
> >
> > diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> > index 604dbe6..3caed76 100644
> > --- a/drivers/gpio/gpiolib-of.c
> > +++ b/drivers/gpio/gpiolib-of.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/of_gpio.h>
> >  #include <linux/pinctrl/pinctrl.h>
> >  #include <linux/slab.h>
> > +#include <linux/gpio/machine.h>
> >
> >  #include "gpiolib.h"
> >
> > @@ -111,6 +112,184 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
> >  EXPORT_SYMBOL(of_get_named_gpio_flags);
> >
> >  /**
> > + * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
> > + * @np:                device node to get GPIO from
> > + * @name:      GPIO line name
> > + * @flags:     a flags pointer to fill in
> > + *
> > + * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
> > + * value on the error condition.
> > + */
> > +
> > +static struct gpio_desc *of_get_gpio_hog(struct device_node *np,
> > +                                 const char **name,
> > +                                 enum gpio_lookup_flags *lflags,
> > +                                 enum gpiod_flags *dflags)
> > +{
> > +       struct device_node *chip_np;
> > +       enum of_gpio_flags xlate_flags;
> > +       struct gpio_desc *desc;
> > +       struct gg_data gg_data = {
> > +               .flags = &xlate_flags,
> > +               .out_gpio = NULL,
> > +       };
> > +       u32 tmp;
> > +       int i, in, outlo, outhi;
> > +       int ret;
> > +
> > +       if (!np)
> > +               return ERR_PTR(-EINVAL);
> 
> This function is being called from a perfectly mastered context in
> this file, so maybe we can avoid this check.

You are correct, I will change this.
> 
> > +
> > +       chip_np = np->parent;
> > +       if (!chip_np) {
> > +               desc = ERR_PTR(-EINVAL);
> > +               goto out;
> > +       }
> > +
> > +       if (!lflags || !dflags) {
> > +               desc = ERR_PTR(-EINVAL);
> > +               goto out;
> > +       }
> 
> Same for this one.
Agreed.
> 
> > +
> > +       *lflags = 0;
> > +       *dflags = 0;
> > +       in = 0;
> > +       outlo = 0;
> > +       outhi = 0;
> > +
> > +       ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
> > +       if (ret) {
> > +               desc = ERR_PTR(ret);
> > +               goto out;
> 
> Please use "return ERR_PTR(ret);" directly, since you do absolutely no
> cleanup in out:. Same remark everywhere it applies.

Agreed.

> 
> > +       }
> > +
> > +       if (tmp > MAX_PHANDLE_ARGS) {
> > +               desc = ERR_PTR(-EINVAL);
> > +               goto out;
> > +       }
> > +
> > +       gg_data.gpiospec.args_count = tmp;
> > +       gg_data.gpiospec.np = chip_np;
> > +       for (i = 0; i < tmp; i++) {
> > +               ret = of_property_read_u32(np, "gpios",
> > +                                          &gg_data.gpiospec.args[i]);
> > +               if (ret) {
> > +                       desc = ERR_PTR(ret);
> > +                       goto out;
> > +               }
> > +       }
> > +
> > +       gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
> 
> This seems to work but only supports one GPIO per hog node. It would
> be nice to be able to specify several GPIOs to which the same settings
> need to be applied.

This is on purpose following Linus Walleij's comment.

> 
> > +       if (!gg_data.out_gpio) {
> > +               if (np->parent == np)
> > +                       desc = ERR_PTR(-ENXIO);
> > +               else
> > +                       desc = ERR_PTR(-EPROBE_DEFER);
> > +               goto out;
> > +       }
> > +
> > +       if (xlate_flags & OF_GPIO_ACTIVE_LOW)
> > +               *lflags |= GPIOF_ACTIVE_LOW;
> > +
> > +       if (of_property_read_bool(np, "input")) {
> > +               *dflags |= GPIOD_IN;
> > +               in = 1;
> > +       }
> > +       if (of_property_read_bool(np, "output-low")) {
> > +               *dflags |= GPIOD_OUT_LOW;
> > +               outlo = 1;
> > +       }
> > +       if (of_property_read_bool(np, "output-high")) {
> > +               *dflags |= GPIOD_OUT_HIGH;
> > +               outhi = 1;
> > +       }
> 
> I thought we agreed that this should be a "direction =
> input|output-low|output-high" property?

Yes, miss that my bad.
I'll change it, so it will only look for a single "direction" node, and hopefully simplify this mess.

> 
> > +       if ((in + outlo + outhi) > 1) {
> > +               pr_warn("%s: GPIO %s: more than one direction/value selected, assuming: %s.\n",
> > +                        __func__, np->name,
> > +                        (outhi)?"output-high":(outlo)?"output-low":"input");
> > +       }
> > +
> > +       if (of_property_read_bool(np, "open-drain-line"))
> > +               *lflags |= GPIO_OPEN_DRAIN;
> > +       if (of_property_read_bool(np, "open-source-line"))
> > +               *lflags |= GPIO_OPEN_SOURCE;
> 
> These properties are not documented in your DT bindings.

Yeah I'll remove those as they might as well be covered under the "xlate_flags" instead
similar to GPIO_ACTIVE_LOW or whenever it gets propagated.


> 
> > +       if (name && of_property_read_string(np, "line-name", name))
> > +               *name = np->name;
> > +
> > +       desc = gg_data.out_gpio;
> > +
> > +out:
> > +       return desc;
> > +}
> > +
> > +
> > +/**
> > + * do_gpio_hog - Given node is a GPIO hog configuration, handle it
> > + * @np:                device node to get GPIO from
> > + *
> > + * This is only used by of_gpiochip_add to request/set GPIO initial
> > + * configuration.
> > + */
> > +static int do_gpio_hog(struct device_node *np)
> > +{
> > +       struct gpio_desc *desc = NULL;
> > +       int err;
> > +       const char *name;
> > +       enum gpio_lookup_flags lflags;
> > +       enum gpiod_flags dflags;
> > +
> > +       desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
> > +       if (!desc)
> > +               return -ENOTSUPP;
> > +       else if (IS_ERR(desc))
> > +               return PTR_ERR(desc);
> > +
> > +       err = gpiod_request(desc, name);
> 
> Using this function means that a GPIO chip module cannot be unloaded
> if it uses GPIO hogs. Is it the intended behavior? If not, please use
> gpiochip_request_own_desc() instead, and make sure to call
> gpiochip_free_own_desc() for each hog when the driver is unloaded.

So I guess we could add a undo_gpio_hog() function and hook it up under of_gpiochip_remove().
Now instead of maintaining a seperate structure just to keep track of hogged descriptor,
would it be acceptable to add a new "gpio_desc.flags" value in gpiolib.h says:

   #define FLAG_GPIO_IS_HOGGED 10

And key on that at removal time instead of creating a list and having to maintain that?

> 
> > +       if (err < 0)
> > +               return err;
> > +
> > +       if (lflags & GPIO_ACTIVE_LOW)
> > +               set_bit(FLAG_ACTIVE_LOW, &desc->flags);
> > +       if (lflags & GPIO_OPEN_DRAIN)
> > +               set_bit(FLAG_OPEN_DRAIN, &desc->flags);
> > +       if (lflags & GPIO_OPEN_SOURCE)
> > +               set_bit(FLAG_OPEN_SOURCE, &desc->flags);
> > +
> > +       /* No particular flag request, not really hogging then... */
> > +       if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
> > +               pr_warn("%s: GPIO %s: no hogging direction specified, bailing out\n",
> > +                        __func__, name);
> > +               err = -EINVAL;
> > +               goto free_gpio;
> > +       }
> > +
> > +       /* Process flags */
> > +       if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
> > +               err = gpiod_direction_output(desc,
> > +                                            dflags & GPIOD_FLAGS_BIT_DIR_VAL);
> > +       else
> > +               err = gpiod_direction_input(desc);
> > +
> > +       if (err < 0) {
> > +               pr_warn("%s: GPIO %s setting direction/value failed\n",
> > +                        __func__, name);
> > +               goto free_gpio;
> > +       }
> 
> I would suggest to factorize this code that is similar to the one
> found in __gpiod_get_index(). Do all the DT parsing in a function that
> just returns a descriptor and the

I would tend to agree.
But as Linus suggested I was trying to contain the changes to gpiolib_of.c only.
> 
> > +
> > +       pr_debug("%s: gpio-hog: GPIO:%d (%s) as %s%s\n", __func__,
> > +               desc_to_gpio(desc), name,
> > +               (dflags&GPIOD_FLAGS_BIT_DIR_OUT) ? "output" : "input",
> > +               (dflags&GPIOD_FLAGS_BIT_DIR_OUT) ?
> > +                       (dflags&GPIOD_FLAGS_BIT_DIR_VAL) ? "/high" : "/low":"");
> > +
> > +       return 0;
> > +
> > +free_gpio:
> > +       gpiod_put(desc);
> > +       return err;
> > +}
> 
> I think most of this function should be moved into gpiolib.c. Add a
> function there that takes the descriptor, lflags and dflags and that
> sets the GPIO up, possibly adding it to a list of hogs so we can unset
> the hogs when unloading the module. That way we have a hogging
> mechanism that is not dependent on device tree and can be used by
> other GPIO binders, such as ACPI.
>

That's fine with as long as everyone agrees.
 
> There is still some work needed but it looks much better than the
> first version. Please make sure to also keep Maxime, Pantelis and Jiri
> in the loop since they expressed interest in your first version.

Regards,
Benoit
