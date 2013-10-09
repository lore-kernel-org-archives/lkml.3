Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3JIL6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:58:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60389 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JIL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 9 Oct 2013 13:58:35 +0200
Message-ID: <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
Subject: Re: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> This patch adds the infrastructure required to register non-linear gpio
> ranges through gpiolib and the standard GPIO device tree bindings.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

I understand the goal of this patch, and why you want it this way,
but it needs some scrutiny, especially from the device tree people.

>  Here, a single GPIO controller has GPIOs 0..9 routed to pin controller
>  pinctrl1's pins 20..29, and GPIOs 10..19 routed to pin controller pinctrl2's
>  pins 50..59.

(Yes this is previous text)

This is quite straight-forward since it deals with a very definitive
coupling of a physical pin and a GPIO line.

> +In addition, named groups of pins can be mapped to pin groups of a given
> +pin controller using the gpio-ranges property as described below:
> +
> +       gpio-range-list ::= <single-gpio-range> [gpio-range-list]
> +       single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
> +       numeric-gpio-range ::=
> +                       <pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
> +       named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
> +       pinctrl-phanle : phandle to pin controller node.

phanle really?

> +       gpio-base : Base GPIO ID in the GPIO controller
> +       pinctrl-base : Base pinctrl pin ID in the pin controller
> +       count : The number of GPIOs/pins in this range
(...)

You did not describe here that count can be 0 if a group is
given and that 0 is a valid count for that case.

> +In this case, the property gpio-ranges-group-names contains one string for
> +every single-gpio-range in gpio-ranges:
> +       gpiorange-names-list ::= <gpiorange-name> [gpiorange-names-list]
> +       gpiorange-name : Name of the pingroup associated to the GPIO range in
> +                       the respective pin controller.
(...)
> +Example:
> +
> +       gpio_pio_i: gpio-controller@14B0 {
> +               #gpio-cells = <2>;
> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> +               reg = <0x1480 0x18>;
> +               gpio-controller;
> +               gpio-ranges =                   <&pinctrl1 0 20 10>,
> +                                               <&pinctrl2 10 0 0>,
> +                                               <&pinctrl1 15 0 10>,
> +                                               <&pinctrl2 25 0 0>;
> +               gpio-ranges-group-names =       "",
> +                                               "foo",
> +                                               "",
> +                                               "bar";
> +       };

And here, I get a bit uneasy as I remember Stephen's stance that such
groups must be a physical property of the controller. I am generally a
bit soft on that, but that is from a driver point of view, and describing
hardware in the devicetree must be reflecting an objective view of the
hardware, not how the particular driver is written for Linux.

This is very questionable :-/

Are you sure this is useable on Windows and OpenBSD without
first verbatim copying the structure of the Linux pinctrl driver?

I am not 100% sure of this case but maybe I will come to realize
as I read the rest of the patches...

Empty group names for "anonymous" groups (I guess these become
linear then?) is really looking strange. They are empty strings with
a semantic effect, that is quite disturbing. but I don't know a better
way either.

Clarify that the number of ranges names must match the array of
ranges, and that if you don't supply group names all ranges
will be linear.


> -               ret = gpiochip_add_pin_range(chip,
> -                                            pinctrl_dev_get_devname( pctldev),
> -                                            pinspec.args[0],
> -                                            pinspec.args[1],
> -                                            pinspec.args[2]);
> -
> -               if (ret)
> -                       break;
> +               if (pinspec.args[2]) {
> +                       /* npins != 0: linear range */
> +                       ret = gpiochip_add_pin_range(chip,
> +                                       pinctrl_dev_get_devname(pctldev),
> +                                       pinspec.args[0],
> +                                       pinspec.args[1],
> +                                       pinspec.args[2]);
> +                       if (ret)
> +                               break;
> +               } else {
> +                       /* npins == 0: special range */
> +                       if (pinspec.args[1]) {
> +                               pr_err("%s: Illegal gpio-range format.\n",
> +                                       np->full_name);
> +                               break;
> +                       }
> +                       ret = of_property_read_string_index(np,
> +                                               "gpio-ranges-group-names",
> +                                               index, &name);
> +                       if (ret)
> +                               break;
> +
> +                       ret = gpiochip_add_pingroup_range(chip, pctldev,
> +                                               pinspec.args[0], name);
> +                       if (ret)
> +                               break;
> +               }

Here you just alter the runpath if the count argument is zero.

Try to be more strict:

- If the count argument is zero, the
  gpio-ranges-group-names index *must* also be set to a non-empty
  string.

- If the count argument is non-zeo, the gpio-ranges-group-names
  index *must* be an empty string, or the gpio-ranges-group-names
  must be non-existant (you have to check for it's presence before
  entering the iterating loop).

Both above checks need to be implemented and proper
error messages printed on detected errors.

(...)
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 2a00239..52e2e6f 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -456,6 +456,29 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
>  }
>  EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
>
> +int pinctrl_add_gpio_pingrp_range(struct pinctrl_dev *pctldev,
> +                               struct pinctrl_gpio_range *range,
> +                               char *pin_group)
> +{
> +       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> +       int group_selector, ret;
> +
> +       group_selector = pinctrl_get_group_selector(pctldev, pin_group);
> +       if (group_selector < 0)
> +               return group_selector;
> +
> +       ret = pctlops->get_group_pins(pctldev, group_selector,
> +                               &range->pins,
> +                               &range->npins);
> +       if (ret < 0)
> +               return ret;
> +
> +       pinctrl_add_gpio_range(pctldev, range);
> +       return 0;
> +
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_add_gpio_pingrp_range);

I don't think this is very elegant. It's quite strange that the range partly
populated from the GPIO side gets the corresponding pins filled
in by this function. Can't we think about something more elegant?
It reflects the strangeness I'm reacting to above I guess.

Yours,
Linus Walleij
