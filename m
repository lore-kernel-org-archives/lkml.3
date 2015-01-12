Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbbALKQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:16:20 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42605 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbALKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <1419019671-25377-2-git-send-email-bparrot@ti.com>
References: <1419019671-25377-1-git-send-email-bparrot@ti.com>
	<1419019671-25377-2-git-send-email-bparrot@ti.com>
Date: Mon, 12 Jan 2015 11:16:17 +0100
Message-ID: <CACRpkdZhXMpmcOx9S2TNQUepQ6n0UY1h5MTx8v8cctyDBajrGQ@mail.gmail.com>
Subject: Re: [Patch v5 1/2] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Parrot <bparrot@ti.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 9:07 PM, Benoit Parrot <bparrot@ti.com> wrote:

> Based on Boris Brezillion's work this is a reworked patch
> of his initial GPIO hogging mechanism.
> This patch provides a way to initially configure specific GPIO
> when the GPIO controller is probed.
>
> The actual DT scanning to collect the GPIO specific data is performed
> as part of gpiochip_add().
>
> The purpose of this is to allow specific GPIOs to be configured
> without any driver specific code.
> This is particularly useful because board design are getting
> increasingly complex and given SoC pins can now have more
> than 10 mux values, a lot of connections are now dependent on
> external IO muxes to switch various modes.
>
> Specific drivers should not necessarily need to be aware of
> what accounts to a specific board implementation. This board level
> "description" should be best kept as part of the dts file.
>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

(...)
>  /**
> + * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
> + * @np:                device node to get GPIO from
> + * @name:      GPIO line name
> + * @flags:     a flags pointer to fill in

kerneldoc is unsynchronized, document both flags.

> + *
> + * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
> + * value on the error condition.
> + */
> +

No newline after kerneldoc. What is lflags and dflags?

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
> +       if (tmp > MAX_PHANDLE_ARGS)
> +               return ERR_PTR(-EINVAL);
> +       gg_data.gpiospec.args_count = tmp;
> +       gg_data.gpiospec.np = chip_np;

Are we duplicating this code elsewhere? No need to
fix now, but space for refactor later on...

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

Is this really reasonable, as we know we're instantiating the only
gpio_chip this hog can be on?

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

Hmmmm need to check the bindings first. I'm not yet sure I
like how we represent this.

> +       if (name && of_property_read_string(np, "line-name", name))
> +               *name = np->name;

I quite like this.

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
> +       for_each_child_of_node(chip->of_node, np) {
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
> @@ -302,6 +418,8 @@ void of_gpiochip_add(struct gpio_chip *chip)
>
>         of_gpiochip_add_pin_range(chip);
>         of_node_get(chip->of_node);
> +
> +       of_gpiochip_scan_hogs(chip);
>  }
>
>  void of_gpiochip_remove(struct gpio_chip *chip)
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 487afe6..d79c265 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -313,6 +313,7 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
>
>  /* Forward-declaration */
>  static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip);
> +static void gpiochip_free_hogs(struct gpio_chip *chip);
>
>  /**
>   * gpiochip_remove() - unregister a gpio_chip
> @@ -331,6 +332,7 @@ void gpiochip_remove(struct gpio_chip *chip)
>
>         gpiochip_irqchip_remove(chip);
>         gpiochip_remove_pin_ranges(chip);
> +       gpiochip_free_hogs(chip);
>         of_gpiochip_remove(chip);
>
>         for (id = 0; id < chip->ngpio; id++) {
> @@ -864,6 +866,7 @@ static bool __gpiod_free(struct gpio_desc *desc)
>                 clear_bit(FLAG_REQUESTED, &desc->flags);
>                 clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
>                 clear_bit(FLAG_OPEN_SOURCE, &desc->flags);
> +               clear_bit(FLAG_IS_HOGGED, &desc->flags);
>                 ret = true;
>         }
>
> @@ -1836,6 +1839,47 @@ struct gpio_desc *__must_check __gpiod_get_optional(struct device *dev,
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

This function has no sensible name.

Skip the arbitrary __ prefix and give it a descriptive name
like "gpiod_configure_flags" or something.

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
> @@ -1885,30 +1929,12 @@ struct gpio_desc *__must_check __gpiod_get_index(struct device *dev,
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
> @@ -2002,6 +2028,68 @@ struct gpio_desc *__must_check __gpiod_get_index_optional(struct device *dev,
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
> +       if (IS_ERR(local_desc)) {
> +               pr_debug("requesting own GPIO %s failed\n", name);
> +               return PTR_ERR(local_desc);
> +       }
> +
> +       status = __gpiod_set_helper(desc, name, lflags, dflags);
> +       if (status < 0) {
> +               pr_debug("setup of GPIO %s failed\n", name);
> +               gpiochip_free_own_desc(desc);
> +               return status;
> +       }
> +
> +       /* Mark GPIO as hogged so it can be identified and removed later */
> +       set_bit(FLAG_IS_HOGGED, &desc->flags);
> +
> +       pr_debug("%s: GPIO:%d (%s) as %s%s\n", __func__,

Convert to pr_info(), as this *should* be printed to console, skip printing
__func__ please.

Modify string to "GPIO line %d (%s) hogged as %s%s\n"

> +               desc_to_gpio(desc), name,
> +               (dflags&GPIOD_FLAGS_BIT_DIR_OUT) ? "output" : "input",
> +               (dflags&GPIOD_FLAGS_BIT_DIR_OUT) ?
> +                 (dflags&GPIOD_FLAGS_BIT_DIR_VAL) ? "/high" : "/low":"");
> +
> +       return 0;
> +}
> +
> +/**
> + * gpiochip_free_hogs - Scan gpio-controller chip and release GPIO hog
> + * @chip:      gpio chip to act on
> + *
> + * This is only used by of_gpiochip_remove to free hogged gpios
> + *

Skip this comment newline.

Overall the changes to gpiolib.c looks very nice.

Yours,
Linus Walleij
