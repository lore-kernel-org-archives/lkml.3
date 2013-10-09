Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3JIOBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:01:08 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62163 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3JIOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <20131009132837.GA23021@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
	<CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
	<20131009132837.GA23021@ab42.lan>
Date: Wed, 9 Oct 2013 16:01:05 +0200
Message-ID: <CACRpkdbo9MOuCY_UWhzbWwEAom_Z3=Vi575ELix9j3hsZdBzZw@mail.gmail.com>
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

On Wed, Oct 9, 2013 at 3:28 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> On Wed, Oct 09, 2013 at 01:58:35PM +0200, Linus Walleij wrote:
>> On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
>> <christian.ruppert@abilis.com> wrote:
>> > +In addition, named groups of pins can be mapped to pin groups of a given
>> > +pin controller using the gpio-ranges property as described below:
>> > +
>> > +       gpio-range-list ::= <single-gpio-range> [gpio-range-list]
>> > +       single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
>> > +       numeric-gpio-range ::=
>> > +                       <pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
>> > +       named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
>> > +       pinctrl-phanle : phandle to pin controller node.
>>
>> phanle really?
>
> Yes, this is actually identical to the numeric ranges. It specifies the
> pin controller which is "responsible" for the pins/pin group in
> question.

I was more thinking about the speling, should it not be "phandle"?

> The named pin groups actually are a physical property of the pin
> controller hardware (well, at least the pin groups are, the names are
> not ;).

OK.

It would be good if the names of the group could match, as close
as possible, the names given to the same identity in the data
sheet or similar documentation.

> Obviously, a driver (no matter for which OS) must be aware of
> this hardware property so it can decide which value to write to which
> register in order to control the pin mux. If we don't want to split (or
> worse: duplicate) that information in the driver and device tree, I see
> two alternatives.
> 1. Define register offsets, masks and register values and the list of
>    pins controlled by those register/value pairs in the device tree.

This is not a viable alternative of course.

> 2. Define register offsets, masks and register values and the list of
>    pins controlled by those register/value pairs in the drivers. Define
>    a portable high level interface for the device tree.
>
> My personal preference is clearly 2.

Yes you are also making a very good case for it, and I tend to
think the same.

But alt 1 is not the alternative, the alternative (3) is to reference
the pin numbers in the device tree, if need be by a largeish
set of one-pin-per-range ranges if these are disparate.

Which is arguably quite ugly compared to (2) as well, but atleast
reasonable.

>> Are you sure this is useable on Windows and OpenBSD without
>> first verbatim copying the structure of the Linux pinctrl driver?
>
> Without knowing the pinctrl infrastructure in either Windows or OpenBSD,
> I am actually convinced that this is _more_ portable than the numeric
> ranges:
>
> - The numeric ranges used today depend on a numbering scheme which
>   is specific to the Linux pinctrl framework.

Not really, it's just a number, it is quite possible for driver developers
to have this match an index number from the hardware documentation.
Also these numbers are sparse, they don't have to be an array that
begin with 0 and go to N. So *any* discrete numbering scheme will
do, and it's not any more strange than the named groups, instead of
putting five apples in a basket and labeling it "group" you can number
the five apples { 7, 19, 22, 67, 216 } and say each one belongs in
the basket.

> One could very well
>   imagine pinctrl frameworks without any numbering scheme at all.

Whether numbers or text labels are used to label the physical
entities does not matter, what matters is that the device tree
binding documentation is implementable by several OS:es.

> - The actual numbers depend on the particulars of each individual Linux
>   pinctrl driver implementation.

No, not from a device tree point of view. It is possible to select
a numbering scheme coming from the device tree and use that
in the driver instead of the other way around.

Do not always assume that the driver comes first. It is possible
to enumerate the pins in a DT binding and tree before even starting
to implement the driver, and the pinctrl framework will cope with
whatever number scheme you choose.

> Adding the higher level concept of named pin groups (which accidentally
> exists in Linux already) seems to be an elegant path to better
> portability here.

Same same, but it deals with sets of pins instead of individual
pins.

>> Empty group names for "anonymous" groups (I guess these become
>> linear then?) is really looking strange. They are empty strings with
>> a semantic effect, that is quite disturbing. but I don't know a better
>> way either.
>
> The alternative would probably be to skip them altogether but I'm afraid
> that that makes it even worse...

We'll have to live with this...

>> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>> > index 2a00239..52e2e6f 100644
>> > --- a/drivers/pinctrl/core.c
>> > +++ b/drivers/pinctrl/core.c
>> > @@ -456,6 +456,29 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
>> >  }
>> >  EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
>> >
>> > +int pinctrl_add_gpio_pingrp_range(struct pinctrl_dev *pctldev,
>> > +                               struct pinctrl_gpio_range *range,
>> > +                               char *pin_group)
>> > +{
>> > +       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
>> > +       int group_selector, ret;
>> > +
>> > +       group_selector = pinctrl_get_group_selector(pctldev, pin_group);
>> > +       if (group_selector < 0)
>> > +               return group_selector;
>> > +
>> > +       ret = pctlops->get_group_pins(pctldev, group_selector,
>> > +                               &range->pins,
>> > +                               &range->npins);
>> > +       if (ret < 0)
>> > +               return ret;
>> > +
>> > +       pinctrl_add_gpio_range(pctldev, range);
>> > +       return 0;
>> > +
>> > +}
>> > +EXPORT_SYMBOL_GPL(pinctrl_add_gpio_pingrp_range);
>>
>> I don't think this is very elegant. It's quite strange that the range partly
>> populated from the GPIO side gets the corresponding pins filled
>> in by this function. Can't we think about something more elegant?
>> It reflects the strangeness I'm reacting to above I guess.
>
> I don't see in which respect the existence of this function is different
> from the existence of pinctrl_find_and_add_gpio_range (the sole purpose
> of which is to be called from gpiochip_add_pin_range). I like the idea
> of being strict about the gpio framework only managing GPIO related
> things and the pinctrl framework only managing pinctrl related things.
> Thus, I adopted this concept to gpiochip_add_pingroup_range (which calls
> pinctrl_add_gpio_pingrp_range).
>
> Tell me if you want me to migrate the get_group_pins call to
> gpiochip_add_pingroup_range but IMHO this would be less elegant.

Hm there are several ways to skin this cat but well, this is OK.

Yours,
Linus Walleij
