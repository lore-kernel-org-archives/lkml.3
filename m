Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3FMJAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42607 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3FMJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:27 -0400
MIME-Version: 1.0
In-Reply-To: <1371055449-15828-1-git-send-email-christian.ruppert@abilis.com>
References: <20130522094958.GA4789@ab42.lan>
	<1371055449-15828-1-git-send-email-christian.ruppert@abilis.com>
Date: Thu, 13 Jun 2013 11:00:26 +0200
Message-ID: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
Subject: Re: [RFC] Allow GPIO ranges based on pinctl pin groups
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 6:44 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> This patch allows the definition of GPIO ranges based on pin groups in
> addition to the traditional linear pin ranges. GPIO ranges based on pin
> groups have the following advantages over traditional pin ranges:
> . Previously, pins associated to a given functionality were defined
>   inside the pin controller (e.g. a pin controller can define a group
>   spi0_pins defining which pins are used by SPI port 0). This mechanism
>   did not apply to GPIO controllers, however, which had to define GPIO
>   ranges based on pin numbers otherwise confined to the pin controller.
>   With the possibility to use pin groups for pin ranges, the pins
>   associated to any functionality, including GPIO, can now be entirely
>   defined inside the pin controller. Everything that needs to be known
>   to the outside world is the name of the pin group.
> . Non-consecutive pin ranges and arbitrary pin ordering is now possible
>   in GPIO ranges.
> . Linux internal pin numbers now no longer leak out of the kernel, e.g.
>   to device tree. If the pinctrl driver author chooses to, GPIO range
>   management can now entirely be based on symbolic names of pin groups.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

Overall this approach looks nice.

There are details that need fixing though:

> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
(...)
> @@ -112,3 +112,39 @@ where,
>
>  The pinctrl node must have "#gpio-range-cells" property to show number of
>  arguments to pass with phandle from gpio controllers node.
> +
> +In addition, gpio ranges can be mapped to pin groups of a given pin
> +controller (see Documentation/pinctrl.txt):

Do not reference Linux particulars in bindings. The idea is to
reuse these bindings with other operating systems as well.

> +
> +       gpio_pio_g: gpio-controller@1480 {
> +               #gpio-cells = <2>;
> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> +               reg = <0x1480 0x18>;
> +               gpio-controller;
> +               gpio-pingrps = <&pinctrl1 0>, <&pinctrl2 3>;
> +               gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
> +       }

End with semicolon?

> +where,
> +   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.

There is something weird with spacing above.

> +   Next values specify the base GPIO offset of the pin range with respect to
> +   the GPIO controller's base. The number of pins in the range is the number
> +   of pins in the pin group.
> +
> +   gpio-pingrp-names defines the name of each pingroup of the respective pin
> +   controller.

That seems like a good idea.

> +The pinctrl node msut have a "#gpio-pingrp-cells" property set to one to

must

> +define the number of arguments to pass with the phandle.
> +
> +Both methods can be combined in the same GPIO controller, e.g.
> +
> +       gpio_pio_i: gpio-controller@14B0 {
> +               #gpio-cells = <2>;
> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> +               reg = <0x1480 0x18>;
> +               gpio-controller;
> +               gpio-ranges = <&pinctrl1 0 20 10>;
> +               gpio-pingrps = <&pinctrl2 10>;
> +               gpio-pingrp-names = "gpio_g_pins";
> +       }

Semicolon after that closing brace.

> +++ b/drivers/gpio/gpiolib-of.c
(...)
> +       index = 0;
> +       of_property_for_each_string(np, "gpio-pingrp-names", prop, name) {
> +               ret = of_parse_phandle_with_args(np, "gpio-pingrps",
> +                                                       "#gpio-pingrp-cells",
> +                                                       index, &pinspec);
> +               if (ret < 0)
> +                       break;
> +
> +               index ++;
> +
> +               pctldev = of_pinctrl_get(pinspec.np);
> +
> +               gpiochip_add_pingroup_range(chip, pctldev,
> +                                       pinspec.args[0], name);
> +       }
>  }

This part looks fine.

(...)
> +++ b/drivers/gpio/gpiolib.c
> @@ -1318,6 +1318,54 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
>  #ifdef CONFIG_PINCTRL
>
>  /**
> + * gpiochip_add_pingroup_range() - add a range for GPIO <-> pin mapping
> + * @chip: the gpiochip to add the range for
> + * @pinctrl: the dev_name() of the pin controller to map to
> + * @gpio_offset: the start offset in the current gpio_chip number space
> + * @pin_group: name of the pin group inside the pin controller
> + */
> +int gpiochip_add_pingroup_range(struct gpio_chip *chip,
> +                       struct pinctrl_dev *pctldev,
> +                       unsigned int gpio_offset, const char *pin_group)
> +{
> +       struct gpio_pin_range *pin_range;
> +       int ret;
> +
> +       pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
> +       if (!pin_range) {
> +               pr_err("%s: GPIO chip: failed to allocate pin ranges\n",
> +                               chip->label);
> +               return -ENOMEM;
> +       }
> +
> +       /* Use local offset as range ID */
> +       pin_range->range.id = gpio_offset;
> +       pin_range->range.gc = chip;
> +       pin_range->range.name = chip->label;
> +       pin_range->range.base = chip->base + gpio_offset;
> +       pin_range->range.pin_base = 0;
> +       ret = pinctrl_get_group_pins(pctldev, pin_group,
> +                                       &pin_range->range.pins,
> +                                       &pin_range->range.npins);
> +       if (ret < 0) {
> +               pr_err("%s: GPIO chip: could not create pin range %s\n",
> +                      chip->label, pin_group);
> +       }
> +       pin_range->pctldev = pctldev;
> +       pinctrl_add_gpio_range(pctldev, &pin_range->range);
> +
> +       pr_debug("GPIO chip %s: created GPIO range %d->%d ==> %s PINGRP %s\n",
> +                chip->label, gpio_offset,
> +                gpio_offset + pin_range->range.npins - 1,
> +                pinctrl_dev_get_devname(pctldev), pin_group);
> +
> +       list_add_tail(&pin_range->node, &chip->pin_ranges);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_add_pingroup_range);

This thing has *waaaay* to much pinctrl stuff in it. You need to find
a better way to partition this between gpiolib and drivers/pinctrl/core.c.
For example: get rid of the function pinctrl_get_group_pins(),
why should GPIOlib know about that stuff?

Pass the groupname to the pinctrl core and let it handle this
business.

> +/**
>   * gpiochip_add_pin_range() - add a range for GPIO <-> pin mapping
>   * @chip: the gpiochip to add the range for
>   * @pinctrl_name: the dev_name() of the pin controller to map to

That seems like an unrelated fix I'd like a separate patch for.

(...)
> +++ b/drivers/pinctrl/core.c
> @@ -279,6 +279,15 @@ static int pinctrl_register_pins(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> +static inline int gpio2pin(struct pinctrl_gpio_range *range, unsigned int gpio)
> +{
> +       unsigned int offset = gpio - range->base;
> +       if (range->pins)
> +               return range->pins[offset];
> +       else
> +               return range->pin_base + offset;
> +}

Clever function. Document it! :-)

>  /**
>   * pinctrl_match_gpio_range() - check if a certain GPIO pin is in range
>   * @pctldev: pin controller device to check
> @@ -444,8 +453,14 @@ pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
>         /* Loop over the ranges */
>         list_for_each_entry(range, &pctldev->gpio_ranges, node) {
>                 /* Check if we're in the valid range */
> -               if (pin >= range->pin_base &&
> -                   pin < range->pin_base + range->npins) {
> +               if (range->pins) {
> +                       int a;
> +                       for (a = 0; a < range->npins; a++) {
> +                               if (range->pins[a] == pin)
> +                                       return range;
> +                       }
> +               } else if (pin >= range->pin_base &&
> +                          pin < range->pin_base + range->npins) {
>                         mutex_unlock(&pctldev->mutex);
>                         return range;
>                 }

This seems like it could be a separate refactoring patch, i.e. a
patch refactoring the ranges to be an array of disparate pins
instead of a linear, consecutive range.

>  /**
> + * pinctrl_get_group_pins() - returns a pin group
> + * @pctldev: the pin controller handling the group
> + * @pin_group: the pin group to look up
> + * @pins: returns a pointer to an array of pin numbers in the group
> + * @npins: returns the number of pins in the group
> + */
> +int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
> +                       const char *pin_group,
> +                       unsigned const **pins, unsigned * const npins)
> +{
> +       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> +       unsigned group_selector;
> +
> +       group_selector = pinctrl_get_group_selector(pctldev, pin_group);
> +       if (group_selector < 0)
> +               return group_selector;
> +
> +       return pctlops->get_group_pins(pctldev, group_selector, pins, npins);
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_get_group_pins);

As mentioned I don't like these pinctrl internals to be exposed
to the whole wide world. You need to find another partitioning.

>         /* Convert to the pin controllers number space */
> -       pin = gpio - range->base + range->pin_base;
> +       pin = gpio2pin(range, gpio);

Nice, can I have a patch adding this gpio2pin (hm maybe
you can rename that gpio_to_pin() I don't mind...)
and refactoring the code? It's a nice refactoring in its own
right.

Yours,
Linus Walleij
