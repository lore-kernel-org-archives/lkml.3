Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaLQImP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:42:15 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47754 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaLQImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <1418422051-9471-2-git-send-email-bparrot@ti.com>
References: <1418422051-9471-1-git-send-email-bparrot@ti.com> <1418422051-9471-2-git-send-email-bparrot@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 17:41:51 +0900
Message-ID: <CAAVeFuLrYovh6-RP0T4Cy8SV2Uuh4k2LD8PKmEahXgr-jKFgtg@mail.gmail.com>
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

Looks ok to me. I have a few nits below, but otherwise I am happy with
how it turned out:

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks for your patience with this!

On Sat, Dec 13, 2014 at 7:07 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Based on Boris Brezillion's work this is a reworked patch
> of his initial GPIO hogging mechanism.
> This patch provides a way to initally configure specific GPIO

s/initally/initially

> when the gpio controller is probed.

GPIO in capitals please.

>
> The actual DT scanning to collect the GPIO specific data is performed
> as part of the gpiochip_add().

d/the

>
> The purpose of this is to allows specific GPIOs to be configured

s/allows/allow

> without any driver specific code.
> This particularly useful because board design are getting

This is particularly

> increasingly complex and given SoC pins can now have upward
> of

s/upward of/up to?

> 10 mux values a lot of connections are now dependent on

seems like a comma is missing here.

> external IO muxes to switch various modes and combination.

not sure what a combination is in that context.

>
> Specific drivers should not necessarily need to be aware of
> what accounts to a specific board implementation. This board level
> "description" should be best kept as part of the dts file.
>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
> Changes since v3:
>  * Relocated the non-DT "hog" function to gpiolib.c.
>  * Rename some of the function to be clearer and remove _ prefixes.
>  * Replace the gpiod_request/gpiod_put usage with
>    gpiochip_request_own_desc/free_own_desc version instead.
>  * Refactor some of the logic to better handle error condition/reporting
>  * Renamed the "direction" DT properties to "state".
>
>  drivers/gpio/gpiolib-of.c | 119 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/gpio/gpiolib.c    | 128 ++++++++++++++++++++++++++++++++++++++--------
>  drivers/gpio/gpiolib.h    |   3 ++
>  3 files changed, 230 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 604dbe6..5422216 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -22,6 +22,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/pinctrl/pinctrl.h>
>  #include <linux/slab.h>
> +#include <linux/gpio/machine.h>
>
>  #include "gpiolib.h"
>
> @@ -111,6 +112,122 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
>  EXPORT_SYMBOL(of_get_named_gpio_flags);
>
>  /**
> + * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
> + * @np:                device node to get GPIO from
> + * @name:      GPIO line name
> + * @flags:     a flags pointer to fill in
> + *
> + * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
> + * value on the error condition.
> + */
> +
> +static struct gpio_desc *of_get_gpio_hog(struct device_node *np,
> +                                 const char **name,
> +                                 enum gpio_lookup_flags *lflags,
> +                                 enum gpiod_flags *dflags)
> +{
> +       struct device_node *chip_np;
> +       enum of_gpio_flags xlate_flags;
> +       struct gpio_desc *desc;
> +       const char *dir_val;
> +       struct gg_data gg_data = {
> +               .flags = &xlate_flags,
> +               .out_gpio = NULL,

out_gpio will be set to NULL if you don't specify it, so you don't
need this last line.

> +       };
> +       u32 tmp;
> +       int i, ret;
> +
> +       chip_np = np->parent;
> +       if (!chip_np)
> +               return ERR_PTR(-EINVAL);
> +
> +       xlate_flags = 0;
> +       *lflags = 0;
> +       *dflags = 0;
> +
> +       ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       if (tmp > MAX_PHANDLE_ARGS)
> +               return ERR_PTR(-EINVAL);
> +
> +       gg_data.gpiospec.args_count = tmp;
> +       gg_data.gpiospec.np = chip_np;
> +       for (i = 0; i < tmp; i++) {
> +               ret = of_property_read_u32_index(np, "gpios", i,
> +                                          &gg_data.gpiospec.args[i]);
> +               if (ret)
> +                       return ERR_PTR(ret);
> +       }
> +
> +       gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
> +       if (!gg_data.out_gpio) {
> +               if (np->parent == np)
> +                       return ERR_PTR(-ENXIO);
> +               else
> +                       return ERR_PTR(-EPROBE_DEFER);
> +       }
> +
> +       if (xlate_flags & OF_GPIO_ACTIVE_LOW)
> +               *lflags |= GPIO_ACTIVE_LOW;
> +
> +       if (of_property_read_string(np, "state", &dir_val)) {
> +               pr_warn("%s: GPIO:%d (%s): no hogging state specified, bailing out\n",
> +                        __func__, desc_to_gpio(gg_data.out_gpio), np->name);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       if (!strcmp(dir_val, "input"))
> +               *dflags |= GPIOD_IN;
> +       else if (!strcmp(dir_val, "output-low"))
> +               *dflags |= GPIOD_OUT_LOW;
> +       else if (!strcmp(dir_val, "output-high"))
> +               *dflags |= GPIOD_OUT_HIGH;
> +       else {
> +               pr_warn("%s: GPIO:%d (%s): invalid state '%s' requested, bailing out\n",
> +                        __func__, desc_to_gpio(gg_data.out_gpio),
> +                       np->name, dir_val);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       if (name && of_property_read_string(np, "line-name", name))
> +               *name = np->name;
> +
> +       desc = gg_data.out_gpio;
> +
> +       return desc;
> +}
> +
> +/**
> + * of_gpiochip_scan_hogs - Scan gpio-controller and apply GPIO hog as requested
> + * @chip:      gpio chip to act on
> + *
> + * This is only used by of_gpiochip_add to request/set GPIO initial
> + * configuration.
> + */
> +static void of_gpiochip_scan_hogs(struct gpio_chip *chip)
> +{
> +       struct gpio_desc *desc = NULL;
> +       struct device_node *np;
> +       const char *name;
> +       enum gpio_lookup_flags lflags;
> +       enum gpiod_flags dflags;
> +
> +       for_each_child_of_node(chip->dev->of_node, np) {
> +               if (!of_property_read_bool(np, "gpio-hog"))
> +                       continue;
> +
> +               desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
> +               if (IS_ERR(desc))
> +                       continue;
> +
> +               if (gpiod_hog(desc, name, lflags, dflags))
> +                       continue;
> +       }
> +}
> +
> +/**
>   * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
>   * @gc:                pointer to the gpio_chip structure
>   * @np:                device node of the GPIO chip
> @@ -302,6 +419,8 @@ void of_gpiochip_add(struct gpio_chip *chip)
>
>         of_gpiochip_add_pin_range(chip);
>         of_node_get(chip->of_node);
> +
> +       of_gpiochip_scan_hogs(chip);
>  }
>
>  void of_gpiochip_remove(struct gpio_chip *chip)
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 58659db..5527dbb 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -301,6 +301,7 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
>
>  /* Forward-declaration */
>  static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip);
> +static void gpiochip_free_hogs(struct gpio_chip *chip);
>
>  /**
>   * gpiochip_remove() - unregister a gpio_chip
> @@ -319,6 +320,7 @@ void gpiochip_remove(struct gpio_chip *chip)
>
>         gpiochip_irqchip_remove(chip);
>         gpiochip_remove_pin_ranges(chip);
> +       gpiochip_free_hogs(chip);
>         of_gpiochip_remove(chip);
>
>         for (id = 0; id < chip->ngpio; id++) {
> @@ -849,6 +851,7 @@ static bool __gpiod_free(struct gpio_desc *desc)
>                 clear_bit(FLAG_REQUESTED, &desc->flags);
>                 clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
>                 clear_bit(FLAG_OPEN_SOURCE, &desc->flags);
> +               clear_bit(FLAG_IS_HOGGED, &desc->flags);
>                 ret = true;
>         }
>
> @@ -1653,6 +1656,47 @@ struct gpio_desc *__must_check __gpiod_get_optional(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(__gpiod_get_optional);
>
> +
> +/**
> + * __gpiod_set_helper - helper function to configure a given GPIO
> + * @desc:      gpio whose value will be assigned
> + * @con_id:    function within the GPIO consumer
> + * @lflags:    gpio_lookup_flags - returned from of_find_gpio() or
> + *             of_get_gpio_hog()
> + * @dflags:    gpiod_flags - optional GPIO initialization flags
> + *
> + * Return 0 on success, -ENOENT if no GPIO has been assigned to the
> + * requested function and/or index, or another IS_ERR() code if an error
> + * occurred while trying to acquire the GPIO.
> + */
> +static int __gpiod_set_helper(struct gpio_desc *desc, const char *con_id,
> +               unsigned long lflags, enum gpiod_flags dflags)
> +{
> +       int status;
> +
> +       if (lflags & GPIO_ACTIVE_LOW)
> +               set_bit(FLAG_ACTIVE_LOW, &desc->flags);
> +       if (lflags & GPIO_OPEN_DRAIN)
> +               set_bit(FLAG_OPEN_DRAIN, &desc->flags);
> +       if (lflags & GPIO_OPEN_SOURCE)
> +               set_bit(FLAG_OPEN_SOURCE, &desc->flags);
> +
> +       /* No particular flag request, return here... */
> +       if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
> +               pr_debug("no flags found for %s\n", con_id);
> +               return 0;
> +       }
> +
> +       /* Process flags */
> +       if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
> +               status = gpiod_direction_output(desc,
> +                                             dflags & GPIOD_FLAGS_BIT_DIR_VAL);
> +       else
> +               status = gpiod_direction_input(desc);
> +
> +       return status;
> +}
> +
>  /**
>   * gpiod_get_index - obtain a GPIO from a multi-index GPIO function
>   * @dev:       GPIO consumer, can be NULL for system-global GPIOs
> @@ -1702,30 +1746,12 @@ struct gpio_desc *__must_check __gpiod_get_index(struct device *dev,
>         }
>
>         status = gpiod_request(desc, con_id);
> -
>         if (status < 0)
>                 return ERR_PTR(status);
>
> -       if (lookupflags & GPIO_ACTIVE_LOW)
> -               set_bit(FLAG_ACTIVE_LOW, &desc->flags);
> -       if (lookupflags & GPIO_OPEN_DRAIN)
> -               set_bit(FLAG_OPEN_DRAIN, &desc->flags);
> -       if (lookupflags & GPIO_OPEN_SOURCE)
> -               set_bit(FLAG_OPEN_SOURCE, &desc->flags);
> -
> -       /* No particular flag request, return here... */
> -       if (!(flags & GPIOD_FLAGS_BIT_DIR_SET))
> -               return desc;
> -
> -       /* Process flags */
> -       if (flags & GPIOD_FLAGS_BIT_DIR_OUT)
> -               status = gpiod_direction_output(desc,
> -                                             flags & GPIOD_FLAGS_BIT_DIR_VAL);
> -       else
> -               status = gpiod_direction_input(desc);
> -
> +       status = __gpiod_set_helper(desc, con_id, lookupflags, flags);
>         if (status < 0) {
> -               dev_dbg(dev, "setup of GPIO %s failed\n", con_id);
> +               pr_debug("setup of GPIO %s failed\n", con_id);
>                 gpiod_put(desc);
>                 return ERR_PTR(status);
>         }
> @@ -1819,6 +1845,68 @@ struct gpio_desc *__must_check __gpiod_get_index_optional(struct device *dev,
>  EXPORT_SYMBOL_GPL(__gpiod_get_index_optional);
>
>  /**
> + * gpiod_hog - Hog the specified GPIO desc given the provided flags
> + * @desc:      gpio whose value will be assigned
> + * @name:      gpio line name
> + * @lflags:    gpio_lookup_flags - returned from of_find_gpio() or
> + *             of_get_gpio_hog()
> + * @dflags:    gpiod_flags - optional GPIO initialization flags
> + *
> + */
> +int gpiod_hog(struct gpio_desc *desc, const char *name,
> +             unsigned long lflags, enum gpiod_flags dflags)
> +{
> +       struct gpio_chip *chip;
> +       struct gpio_desc *local_desc;
> +       int hwnum;
> +       int status;
> +
> +       chip = gpiod_to_chip(desc);
> +       hwnum = gpio_chip_hwgpio(desc);
> +
> +       local_desc = gpiochip_request_own_desc(chip, hwnum, name);

This looks somehow funny because local_desc will be strictly equal to
desc, but there is nothing you can do here. The DT GPIO lookup process
should not return a desc, but a (gpiochip*, hwnum) tuple to begin
with, so let's keep it that way. I made a note to myself to fix this.
