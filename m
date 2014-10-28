Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJ1OLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:11:10 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39948 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ1OLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141022200633.GA31080@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
	<1412717576-19737-2-git-send-email-b.galvani@gmail.com>
	<CACRpkdZV9Gmx7Oy4QRh4y2MNN=FXbSF2W0cnjbtxkrB4vT2UOg@mail.gmail.com>
	<20141022200633.GA31080@gmail.com>
Date: Tue, 28 Oct 2014 15:11:05 +0100
Message-ID: <CACRpkdZO24g4wezqKTWpTjQwwbWGt2XNZ4p_ikyfyPNhFGLp6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: add driver for Amlogic Meson SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:06 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> On Tue, Oct 21, 2014 at 03:39:25PM +0200, Linus Walleij wrote:

>> > +static int meson_gpio_of_xlate(struct gpio_chip *chip,
>> > +                              const struct of_phandle_args *gpiospec,
>> > +                              u32 *flags)
>> > +{
>> > +       unsigned gpio = gpiospec->args[0];
>> > +
>> > +       if (gpio < chip->base || gpio >= chip->base + chip->ngpio)
>> > +               return -EINVAL;
>> > +
>> > +       if (flags)
>> > +               *flags = gpiospec->args[1];
>> > +
>> > +       return gpio - chip->base;
>> > +}
>>
>> Why is this necessary? We want to get rid of all use of
>> chip->base so introducing new users is not nice.
>
> The driver instantiates one pinctrl device with 136 pins and two
> gpio_chips, one with 120 gpios and the other with 16 (for more
> details, see below). The macros for pins in the header file use a
> single range from 0 to 135 that matches the order of pins in the
> pinctrl device:
>
>         /* First gpio-chip */
>         #define GPIOX_0         0
>         [...]
>         #define BOOT_18         119
>
>         /* Second gpio-chip */
>         #define GPIOAO_0        120
>         [...]
>         #define GPIO_TEST_N     135
>
> Since the macros are also used in DT as GPIO numbers, this function
> translates that value to the relative offset for the gpio chip.

That is not wise. You should let each gpio_chip register its
chip with base = -1, so they get whatever random GPIO numbers
they get, then register the pin range relatively to what they
get from the gpiochip side using gpiochip_add_pin_range().

>> The default of_gpio_simple_xlate() should be enough,
>> don't you agree?
>
> Probably yes, but for it to work then I have either to:
>  - change the pin macros to use a relative value
>
>         /* First gpio-chip */
>         #define GPIOX_0         0
>         [...]
>         #define BOOT_18         119
>
>         /* Second gpio-chip */
>         #define GPIOAO_0        0
>         [...]
>         #define GPIO_TEST_N     15
>
>  - or use a single gpio chip

Or (C) register the pin ranges from the gpio_chip side instead
of doing it from the pin controller side. Look at how
gpiochip_add_pin_range() works, I inisist.

>> > +       /* Copy group and function definitions from domains to pinctrl */
>> > +       pc->groups = devm_kzalloc(pc->dev, pc->num_groups *
>> > +                                 sizeof(struct meson_pmx_group), GFP_KERNEL);
>> > +       pc->funcs = devm_kzalloc(pc->dev, pc->num_funcs *
>> > +                                 sizeof(struct meson_pmx_func), GFP_KERNEL);
>> > +       if (!pc->groups || !pc->funcs)
>> > +               return -ENOMEM;
>>
>> Again more copying. Why can't we just have one set of this data
>> and only pass pointers?
>
> This code copies information on groups and functions from the
> different domains and merge it in a single array so that the driver
> can look it up easily.
>
> Probably the initial information should not be splitted so that it can
> be reused without additional copies.

Yeah I will look at V2 and see how it looks...

>> Why can't static arrays and ARRAY_SIZE() be used throughout
>> instead, just pass around pointers?
>
> The goal of the dynamic code is to simplify the declaration of groups,
> which can be done with a single statement in the form:
>
>         GROUP(_name, _reg, _bit, _pins...)
>
> for example:
>
>         GROUP(sdxc_d0_c,        4,      30,     BOOT_0),
>         GROUP(sdxc_d13_c,       4,      29,     BOOT_1, BOOT_2, BOOT_3),
>         GROUP(sdxc_d47_c,       4,      28,     BOOT_4, BOOT_5, BOOT_6, BOOT_7),
>         GROUP(sdxc_cmd_c,       4,      27,     BOOT_16),
>         GROUP(sdxc_clk_c,       4,      26,     BOOT_17),
>         GROUP(nand_io,          2,      26,     BOOT_0, BOOT_1, BOOT_2, BOOT_3,
>                                                 BOOT_4, BOOT_5, BOOT_6, BOOT_7),
>
> instead of having to define an array of pins and reference it in the
> group declaration. The same goes for functions. I admit that this is a
> bit hackish, I will stick to the classical way in the next respin.

OK thanks.

>> > +/**
>> > + * struct meson_domain
>> > + *
>> > + * @reg_mux:   registers for mux settings
>> > + * @reg_pullen:        registers for pull-enable settings
>> > + * @reg_pull:  registers for pull settings
>> > + * @reg_gpio:  registers for gpio settings
>> > + * @mux_size:  size of mux register range (in words)
>> > + * @pullen_size:size of pull-enable register range
>> > + * @pull_size: size of pull register range
>> > + * @gpio_size: size of gpio register range
>> > + * @chip:      gpio chip associated with the domain
>> > + * @data;      platform data for the domain
>> > + * @node:      device tree node for the domain
>> > + * @gpio_range:        gpio range that maps domain gpios to the pin controller
>> > + * @lock:      spinlock for accessing domain registers
>> > + *
>> > + * A domain represents a set of banks controlled by the same set of
>> > + * registers. Typically there is a domain for the normal banks and
>> > + * another one for the Always-On bus.
>> > + */
>>
>> Can I get a long-ish explanation of the domains vs banks etc
>> because that's really key to understanding this driver!
>
> Yes, I hope that the following explanation is clear enough. If anyone
> wants to know the details, the relevant information can be found in
> the Amlogic sources available at:
>
> http://openlinux.amlogic.com:8000/download/ARM/kernel/
>
> The GPIOs are organized in banks (X,Y,DV,H,Z,BOOT,CARD,AO) and each
> bank has a number of GPIOs variable from 7 to 30.
>
> There are different register sets for changing pins properties:
>  - for all banks except AO:
>         <0xc11080b0 0x28> for mux configuration
>         <0xc11080e4 0x18> for pull-enable configuration
>         <0xc1108120 0x18> for pull configuration
>         <0xc1108030 0x30> for gpio (in/out/dir) configuration
>
>  - for AO bank
>         <0xc8100014 0x4> for mux configuration
>         <0xc810002c 0x4> for pull and pull-enable configuration
>         <0xc8100024 0x8> for gpio (in/out/dir) configuration
>
> The regular banks belong to the "standard" power domain, while AO
> belongs to the Always-On power domain, which, like the name says,
> can't be powered off.
>
> Each bank uses contiguous ranges of bits in the register sets
> described above and the same register can be used by different banks
> (for example, for the pull-enable configuration the BOOT bank uses
> bits [0:18] of 0xc11080f0 and the CARD bank uses bits [20:25]).
>
> In addition to this, there seem to be some other registers, shared
> between all the banks, for the interrupt functionality.

I get it now I think, thanks!

Arguably the whole shebang is one big hardware unit so the right
thing is indeed to have a single driver for all of it.

> The driver then instantiates a gpio_chip for each subnode and a single
> pinctrl device.

This is the right design. We just need to hash out the details.

Yours,
Linus Walleij
