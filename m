Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3JIN3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:29:09 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27387 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab3JIN3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:29:04 -0400
Date: Wed, 9 Oct 2013 15:28:38 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20131009132837.GA23021@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
 <1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 01:58:35PM +0200, Linus Walleij wrote:
> On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> > This patch adds the infrastructure required to register non-linear gpio
> > ranges through gpiolib and the standard GPIO device tree bindings.
> >
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> 
> I understand the goal of this patch, and why you want it this way,
> but it needs some scrutiny, especially from the device tree people.
> 
> >  Here, a single GPIO controller has GPIOs 0..9 routed to pin controller
> >  pinctrl1's pins 20..29, and GPIOs 10..19 routed to pin controller pinctrl2's
> >  pins 50..59.
> 
> (Yes this is previous text)
> 
> This is quite straight-forward since it deals with a very definitive
> coupling of a physical pin and a GPIO line.
> 
> > +In addition, named groups of pins can be mapped to pin groups of a given
> > +pin controller using the gpio-ranges property as described below:
> > +
> > +       gpio-range-list ::= <single-gpio-range> [gpio-range-list]
> > +       single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
> > +       numeric-gpio-range ::=
> > +                       <pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
> > +       named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
> > +       pinctrl-phanle : phandle to pin controller node.
> 
> phanle really?

Yes, this is actually identical to the numeric ranges. It specifies the
pin controller which is "responsible" for the pins/pin group in
question.

> > +       gpio-base : Base GPIO ID in the GPIO controller
> > +       pinctrl-base : Base pinctrl pin ID in the pin controller
> > +       count : The number of GPIOs/pins in this range
> (...)
> 
> You did not describe here that count can be 0 if a group is
> given and that 0 is a valid count for that case.

It is implicit in "named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'"
but you are probably right that this needs to be more explicit. When
rereading the whole section now (with all the changes that were made to
the documentation since the patch was originally written), I think I'll
rewrite this paragraph entirely, integrating it in the explanation of
numeric ranges.

> > +In this case, the property gpio-ranges-group-names contains one string for
> > +every single-gpio-range in gpio-ranges:
> > +       gpiorange-names-list ::= <gpiorange-name> [gpiorange-names-list]
> > +       gpiorange-name : Name of the pingroup associated to the GPIO range in
> > +                       the respective pin controller.
> (...)
> > +Example:
> > +
> > +       gpio_pio_i: gpio-controller@14B0 {
> > +               #gpio-cells = <2>;
> > +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> > +               reg = <0x1480 0x18>;
> > +               gpio-controller;
> > +               gpio-ranges =                   <&pinctrl1 0 20 10>,
> > +                                               <&pinctrl2 10 0 0>,
> > +                                               <&pinctrl1 15 0 10>,
> > +                                               <&pinctrl2 25 0 0>;
> > +               gpio-ranges-group-names =       "",
> > +                                               "foo",
> > +                                               "",
> > +                                               "bar";
> > +       };
> 
> And here, I get a bit uneasy as I remember Stephen's stance that such
> groups must be a physical property of the controller. I am generally a
> bit soft on that, but that is from a driver point of view, and describing
> hardware in the devicetree must be reflecting an objective view of the
> hardware, not how the particular driver is written for Linux.

The named pin groups actually are a physical property of the pin
controller hardware (well, at least the pin groups are, the names are
not ;). Obviously, a driver (no matter for which OS) must be aware of
this hardware property so it can decide which value to write to which
register in order to control the pin mux. If we don't want to split (or
worse: duplicate) that information in the driver and device tree, I see
two alternatives.
1. Define register offsets, masks and register values and the list of
   pins controlled by those register/value pairs in the device tree.
2. Define register offsets, masks and register values and the list of
   pins controlled by those register/value pairs in the drivers. Define
   a portable high level interface for the device tree.

My personal preference is clearly 2.

> This is very questionable :-/
> 
> Are you sure this is useable on Windows and OpenBSD without
> first verbatim copying the structure of the Linux pinctrl driver?

Without knowing the pinctrl infrastructure in either Windows or OpenBSD,
I am actually convinced that this is _more_ portable than the numeric
ranges:
- The numeric ranges used today depend on a numbering scheme which
  is specific to the Linux pinctrl framework. One could very well
  imagine pinctrl frameworks without any numbering scheme at all.
- The actual numbers depend on the particulars of each individual Linux
  pinctrl driver implementation. There is no guarantee that such a
  numbering is compatible with pin numbering constraints of other OSses.
  Nobody would be surprised if any given OS didn't allow sparse pin
  numbering ranges, for example.

Adding the higher level concept of named pin groups (which accidentally
exists in Linux already) seems to be an elegant path to better
portability here.

> I am not 100% sure of this case but maybe I will come to realize
> as I read the rest of the patches...
> 
> Empty group names for "anonymous" groups (I guess these become
> linear then?) is really looking strange. They are empty strings with
> a semantic effect, that is quite disturbing. but I don't know a better
> way either.

The alternative would probably be to skip them altogether but I'm afraid
that that makes it even worse...

> Clarify that the number of ranges names must match the array of
> ranges, and that if you don't supply group names all ranges
> will be linear.

OK. Will be done when rewriting the documentation.

> > -               ret = gpiochip_add_pin_range(chip,
> > -                                            pinctrl_dev_get_devname( pctldev),
> > -                                            pinspec.args[0],
> > -                                            pinspec.args[1],
> > -                                            pinspec.args[2]);
> > -
> > -               if (ret)
> > -                       break;
> > +               if (pinspec.args[2]) {
> > +                       /* npins != 0: linear range */
> > +                       ret = gpiochip_add_pin_range(chip,
> > +                                       pinctrl_dev_get_devname(pctldev),
> > +                                       pinspec.args[0],
> > +                                       pinspec.args[1],
> > +                                       pinspec.args[2]);
> > +                       if (ret)
> > +                               break;
> > +               } else {
> > +                       /* npins == 0: special range */
> > +                       if (pinspec.args[1]) {
> > +                               pr_err("%s: Illegal gpio-range format.\n",
> > +                                       np->full_name);
> > +                               break;
> > +                       }
> > +                       ret = of_property_read_string_index(np,
> > +                                               "gpio-ranges-group-names",
> > +                                               index, &name);
> > +                       if (ret)
> > +                               break;
> > +
> > +                       ret = gpiochip_add_pingroup_range(chip, pctldev,
> > +                                               pinspec.args[0], name);
> > +                       if (ret)
> > +                               break;
> > +               }
> 
> Here you just alter the runpath if the count argument is zero.
> 
> Try to be more strict:
> 
> - If the count argument is zero, the
>   gpio-ranges-group-names index *must* also be set to a non-empty
>   string.
> 
> - If the count argument is non-zeo, the gpio-ranges-group-names
>   index *must* be an empty string, or the gpio-ranges-group-names
>   must be non-existant (you have to check for it's presence before
>   entering the iterating loop).
> 
> Both above checks need to be implemented and proper
> error messages printed on detected errors.

OK.

> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> > index 2a00239..52e2e6f 100644
> > --- a/drivers/pinctrl/core.c
> > +++ b/drivers/pinctrl/core.c
> > @@ -456,6 +456,29 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
> >  }
> >  EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
> >
> > +int pinctrl_add_gpio_pingrp_range(struct pinctrl_dev *pctldev,
> > +                               struct pinctrl_gpio_range *range,
> > +                               char *pin_group)
> > +{
> > +       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> > +       int group_selector, ret;
> > +
> > +       group_selector = pinctrl_get_group_selector(pctldev, pin_group);
> > +       if (group_selector < 0)
> > +               return group_selector;
> > +
> > +       ret = pctlops->get_group_pins(pctldev, group_selector,
> > +                               &range->pins,
> > +                               &range->npins);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       pinctrl_add_gpio_range(pctldev, range);
> > +       return 0;
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(pinctrl_add_gpio_pingrp_range);
> 
> I don't think this is very elegant. It's quite strange that the range partly
> populated from the GPIO side gets the corresponding pins filled
> in by this function. Can't we think about something more elegant?
> It reflects the strangeness I'm reacting to above I guess.

I don't see in which respect the existence of this function is different
from the existence of pinctrl_find_and_add_gpio_range (the sole purpose
of which is to be called from gpiochip_add_pin_range). I like the idea
of being strict about the gpio framework only managing GPIO related
things and the pinctrl framework only managing pinctrl related things.
Thus, I adopted this concept to gpiochip_add_pingroup_range (which calls
pinctrl_add_gpio_pingrp_range).

Tell me if you want me to migrate the get_group_pins call to
gpiochip_add_pingroup_range but IMHO this would be less elegant.

Greetings,
  Christian
