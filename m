Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaJVUIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:08:25 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42207 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaJVUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:08:22 -0400
Date: Wed, 22 Oct 2014 22:06:33 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH 1/3] pinctrl: add driver for Amlogic Meson SoCs
Message-ID: <20141022200633.GA31080@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
 <1412717576-19737-2-git-send-email-b.galvani@gmail.com>
 <CACRpkdZV9Gmx7Oy4QRh4y2MNN=FXbSF2W0cnjbtxkrB4vT2UOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZV9Gmx7Oy4QRh4y2MNN=FXbSF2W0cnjbtxkrB4vT2UOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 03:39:25PM +0200, Linus Walleij wrote:
> On Tue, Oct 7, 2014 at 11:32 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> 
> Sorry for a quick and brief review, but should be enough for you to proceed
> to iterate the patch.
> 
> > This is a driver for the pinmux and GPIO controller available in
> > Amlogic Meson SoCs. At the moment it only supports Meson8 devices,
> > however other SoC families like Meson6 and Meson8b (the Cortex-A5
> > variant) appears to be similar, with just different sets of banks and
> > registers.
> >
> > GPIO interrupts are not supported at the moment due to lack of
> > documentation.
> >
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> 
> >  arch/arm/mach-meson/Kconfig            |   3 +
> 
> Please don't mix up driver submission with platform enablement.
> Put this Kconfig fragment in a separate patch.

Ok, will do.

> 
> > +++ b/drivers/pinctrl/meson/pinctrl-meson.c
> (...)
> 
> > +static void meson_domain_set_bit(struct meson_domain *domain,
> > +                                void __iomem *addr, unsigned int bit,
> > +                                unsigned int value)
> > +{
> > +       unsigned long flags;
> > +       unsigned int data;
> > +
> > +       spin_lock_irqsave(&domain->lock, flags);
> > +       data = readl(addr);
> > +
> > +       if (value)
> > +               data |= BIT(bit);
> > +       else
> > +               data &= ~BIT(bit);
> > +
> > +       writel(data, addr);
> > +       spin_unlock_irqrestore(&domain->lock, flags);
> > +}
> 
> Looks like you are re-implementing mmio regmap. Take a look at
> devm_regmap_init_mmio() from <linux/regmap.h>

I missed that, thanks.

> > +static int meson_get_pin_reg_and_bit(struct meson_domain *domain,
> > +                                    unsigned pin, int reg_type,
> > +                                    unsigned int *reg_num, unsigned int *bit)
> > +{
> > +       struct meson_bank *bank;
> > +       int i, found = 0;
> 
> bool found;
> 
> > +
> > +       for (i = 0; i < domain->data->num_banks; i++) {
> > +               bank = &domain->data->banks[i];
> > +               if (pin >= bank->first && pin <= bank->last) {
> > +                       found = 1;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       if (!found)
> > +               return 1;
> 
> Can't you return a negative errorcode like everyone else?

Sure.

> 
> > +
> > +       *reg_num = bank->regs[reg_type].reg;
> > +       *bit = bank->regs[reg_type].bit + pin - bank->first;
> > +
> > +       return 0;
> > +}
> 
> This function is weird and could use some kerneldoc explanation
> to what it does I think.

Ok.

> 
> > +static int meson_pmx_request_gpio(struct pinctrl_dev *pcdev,
> > +                                 struct pinctrl_gpio_range *range,
> > +                                 unsigned offset)
> > +{
> > +       struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
> > +
> > +       meson_pmx_disable_other_groups(pc, offset, -1);
> 
> Passing the argument -1 is usually a bit ambiguous.
> 
> > +
> > +       return 0;
> > +}
> 
> > +static inline struct meson_domain *to_meson_domain(struct gpio_chip *chip)
> > +{
> > +       return container_of(chip, struct meson_domain, chip);
> > +}
> 
> I have a very vague idea what a "meson domain" is, can this be explained
> in some good place? Like in the struct meson_domain with
> kerneldoc...

Yes, below there is an explanation.

> 
> > +static int meson_gpio_get(struct gpio_chip *chip, unsigned gpio)
> > +{
> > +       struct meson_domain *domain = to_meson_domain(chip);
> > +       void __iomem *addr;
> > +       unsigned int bit;
> > +
> > +       if (meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_IN,
> > +                                       &addr, &bit))
> > +               return 0;
> > +
> > +       return (readl(addr) >> bit) & 1;
> 
> Do it like this:
> 
> return !!(readl(addr) & BIT(bit));
> 
> > +static int meson_gpio_of_xlate(struct gpio_chip *chip,
> > +                              const struct of_phandle_args *gpiospec,
> > +                              u32 *flags)
> > +{
> > +       unsigned gpio = gpiospec->args[0];
> > +
> > +       if (gpio < chip->base || gpio >= chip->base + chip->ngpio)
> > +               return -EINVAL;
> > +
> > +       if (flags)
> > +               *flags = gpiospec->args[1];
> > +
> > +       return gpio - chip->base;
> > +}
> 
> Why is this necessary? We want to get rid of all use of
> chip->base so introducing new users is not nice.

The driver instantiates one pinctrl device with 136 pins and two
gpio_chips, one with 120 gpios and the other with 16 (for more
details, see below). The macros for pins in the header file use a
single range from 0 to 135 that matches the order of pins in the
pinctrl device:

	/* First gpio-chip */
	#define GPIOX_0         0
	[...]
	#define BOOT_18         119

	/* Second gpio-chip */
	#define GPIOAO_0        120
	[...]
	#define GPIO_TEST_N     135

Since the macros are also used in DT as GPIO numbers, this function
translates that value to the relative offset for the gpio chip.

> The default of_gpio_simple_xlate() should be enough,
> don't you agree?

Probably yes, but for it to work then I have either to:
 - change the pin macros to use a relative value

	/* First gpio-chip */
	#define GPIOX_0         0
	[...]
	#define BOOT_18         119

	/* Second gpio-chip */
	#define GPIOAO_0        0
	[...]
	#define GPIO_TEST_N     15

 - or use a single gpio chip

> 
> I guess this is a twocell binding? Else I suggest you alter your
> bindings to use two cells and be happy with that, as you can
> have your driver behave like all others.

It's a two-cell binding.

> 
> > +static int meson_pinctrl_init_data(struct meson_pinctrl *pc)
> > +{
> > +       struct meson_domain_data *data;
> > +       int i, j, pin = 0, func = 0, group = 0;
> > +
> > +       /* Copy pin definitions from domains to pinctrl */
> > +       pc->pins = devm_kzalloc(pc->dev, pc->num_pins *
> > +                               sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
> > +       if (!pc->pins)
> > +               return -ENOMEM;
> > +
> > +       for (i = 0, j = 0; i < pc->num_domains; i++) {
> > +               data = pc->domains[i].data;
> > +               for (j = 0; j < data->num_pins; j++) {
> > +                       pc->pins[pin].number = pin;
> > +                       pc->pins[pin++].name = data->pin_names[j];
> > +               }
> > +       }
> 
> This seems a little kludgy. Why can't these domains also simply
> use struct pinctrl_pin_desc?

I will fix this.

> 
> > +       /* Copy group and function definitions from domains to pinctrl */
> > +       pc->groups = devm_kzalloc(pc->dev, pc->num_groups *
> > +                                 sizeof(struct meson_pmx_group), GFP_KERNEL);
> > +       pc->funcs = devm_kzalloc(pc->dev, pc->num_funcs *
> > +                                 sizeof(struct meson_pmx_func), GFP_KERNEL);
> > +       if (!pc->groups || !pc->funcs)
> > +               return -ENOMEM;
> 
> Again more copying. Why can't we just have one set of this data
> and only pass pointers?

This code copies information on groups and functions from the
different domains and merge it in a single array so that the driver
can look it up easily.

Probably the initial information should not be splitted so that it can
be reused without additional copies.

> 
> > +       for (i = 0; i < pc->num_domains; i++) {
> > +               data = pc->domains[i].data;
> > +
> > +               for (j = 0; j < data->num_groups; j++) {
> > +                       memcpy(&pc->groups[group], &data->groups[j],
> > +                              sizeof(struct meson_pmx_group));
> > +                       pc->groups[group++].domain = &pc->domains[i];
> > +               }
> > +
> > +               for (j = 0; j < data->num_funcs; j++) {
> > +                       memcpy(&pc->funcs[func++], &data->funcs[j],
> > +                              sizeof(struct meson_pmx_func));
> > +               }
> > +       }
> > +
> > +       /* Count pins in groups */
> > +       for (i = 0; i < pc->num_groups; i++) {
> > +               for (j = 0; ; j++) {
> > +                       if (pc->groups[i].pins[j] == PINS_END) {
> > +                               pc->groups[i].num_pins = j;
> > +                               break;
> > +                       }
> > +               }
> > +       }
> > +
> > +       /* Count groups in functions */
> > +       for (i = 0; i < pc->num_funcs; i++) {
> > +               for (j = 0; ; j++) {
> > +                       if (!pc->funcs[i].groups[j]) {
> > +                               pc->funcs[i].num_groups = j;
> > +                               break;
> > +                       }
> > +               }
> > +       }
> 
> All this dynamic code also looks cumbersome to maintain.
> 
> Why can't static arrays and ARRAY_SIZE() be used throughout
> instead, just pass around pointers?

The goal of the dynamic code is to simplify the declaration of groups,
which can be done with a single statement in the form:

	GROUP(_name, _reg, _bit, _pins...)

for example:

        GROUP(sdxc_d0_c,        4,      30,     BOOT_0),
        GROUP(sdxc_d13_c,       4,      29,     BOOT_1, BOOT_2, BOOT_3),
        GROUP(sdxc_d47_c,       4,      28,     BOOT_4, BOOT_5, BOOT_6, BOOT_7),
        GROUP(sdxc_cmd_c,       4,      27,     BOOT_16),
        GROUP(sdxc_clk_c,       4,      26,     BOOT_17),
        GROUP(nand_io,          2,      26,     BOOT_0, BOOT_1, BOOT_2, BOOT_3,
                                                BOOT_4, BOOT_5, BOOT_6, BOOT_7),

instead of having to define an array of pins and reference it in the
group declaration. The same goes for functions. I admit that this is a
bit hackish, I will stick to the classical way in the next respin.

> 
> > +static int meson_gpiolib_register(struct meson_pinctrl *pc)
> > +{
> > +       struct meson_domain *domain;
> > +       unsigned int base = 0;
> > +       int i, ret;
> > +
> > +       for (i = 0; i < pc->num_domains; i++) {
> > +               domain = &pc->domains[i];
> > +
> > +               domain->chip.label = domain->data->name;
> > +               domain->chip.dev = pc->dev;
> > +               domain->chip.request = meson_gpio_request;
> > +               domain->chip.free = meson_gpio_free;
> > +               domain->chip.direction_input = meson_gpio_direction_input;
> > +               domain->chip.direction_output = meson_gpio_direction_output;
> > +               domain->chip.get = meson_gpio_get;
> > +               domain->chip.set = meson_gpio_set;
> > +               domain->chip.base = base;
> > +               domain->chip.ngpio = domain->data->num_pins;
> > +               domain->chip.names = domain->data->pin_names;
> > +               domain->chip.can_sleep = false;
> > +               domain->chip.of_node = domain->of_node;
> > +               domain->chip.of_gpio_n_cells = 2;
> > +               domain->chip.of_xlate = meson_gpio_of_xlate;
> > +
> > +               ret = gpiochip_add(&domain->chip);
> > +               if (ret < 0) {
> > +                       dev_err(pc->dev, "can't add gpio chip %s\n",
> > +                               domain->data->name);
> > +                       goto fail;
> > +               }
> > +
> > +               domain->gpio_range.name = domain->data->name;
> > +               domain->gpio_range.id = i;
> > +               domain->gpio_range.base = base;
> > +               domain->gpio_range.pin_base = base;
> > +               domain->gpio_range.npins = domain->data->num_pins;
> > +               domain->gpio_range.gc = &domain->chip;
> > +               pinctrl_add_gpio_range(pc->pcdev, &domain->gpio_range);
> 
> No thanks, use gpiochip_add_pin_range() instead. That is much
> better as it's completely relative.

Ok.

> 
> (...)
> > +++ b/drivers/pinctrl/meson/pinctrl-meson.h
> > +/**
> > + * struct meson bank
> > + *
> > + * @name:      bank name
> > + * @first:     first pin of the bank
> > + * @last:      last pin of the bank
> > + * @regs:      couples of <reg offset, bit index> controlling the
> > + *             functionalities of the bank pins (pull, direction, value)
> > + *
> > + * A bank represents a set of pins controlled by a contiguous set of
> > + * bits in the domain registers.
> > + */
> > +struct meson_bank {
> > +       const char *name;
> > +       unsigned int first;
> > +       unsigned int last;
> > +       struct meson_reg_offset regs[NUM_REG];
> > +};
> 
> That struct is actually documented!
> 
> > +/**
> > + * struct meson_domain
> > + *
> > + * @reg_mux:   registers for mux settings
> > + * @reg_pullen:        registers for pull-enable settings
> > + * @reg_pull:  registers for pull settings
> > + * @reg_gpio:  registers for gpio settings
> > + * @mux_size:  size of mux register range (in words)
> > + * @pullen_size:size of pull-enable register range
> > + * @pull_size: size of pull register range
> > + * @gpio_size: size of gpio register range
> > + * @chip:      gpio chip associated with the domain
> > + * @data;      platform data for the domain
> > + * @node:      device tree node for the domain
> > + * @gpio_range:        gpio range that maps domain gpios to the pin controller
> > + * @lock:      spinlock for accessing domain registers
> > + *
> > + * A domain represents a set of banks controlled by the same set of
> > + * registers. Typically there is a domain for the normal banks and
> > + * another one for the Always-On bus.
> > + */
> 
> Can I get a long-ish explanation of the domains vs banks etc
> because that's really key to understanding this driver!

Yes, I hope that the following explanation is clear enough. If anyone
wants to know the details, the relevant information can be found in
the Amlogic sources available at:

http://openlinux.amlogic.com:8000/download/ARM/kernel/

The GPIOs are organized in banks (X,Y,DV,H,Z,BOOT,CARD,AO) and each
bank has a number of GPIOs variable from 7 to 30.

There are different register sets for changing pins properties:
 - for all banks except AO:
	<0xc11080b0 0x28> for mux configuration
	<0xc11080e4 0x18> for pull-enable configuration
	<0xc1108120 0x18> for pull configuration
	<0xc1108030 0x30> for gpio (in/out/dir) configuration

 - for AO bank
	<0xc8100014 0x4> for mux configuration
	<0xc810002c 0x4> for pull and pull-enable configuration
	<0xc8100024 0x8> for gpio (in/out/dir) configuration

The regular banks belong to the "standard" power domain, while AO
belongs to the Always-On power domain, which, like the name says,
can't be powered off.

Each bank uses contiguous ranges of bits in the register sets
described above and the same register can be used by different banks
(for example, for the pull-enable configuration the BOOT bank uses
bits [0:18] of 0xc11080f0 and the CARD bank uses bits [20:25]).

In addition to this, there seem to be some other registers, shared
between all the banks, for the interrupt functionality.

My initial submission refers to these two group of banks as "domains"
(for lack of a better name) and uses a separate node in the DT for
each of them:

	pinctrl@ {
		compatible = "amlogic,meson8-pinctrl";
		[...]

		gpio: banks@c11080b0 {
			reg = <0xc11080b0 0x28>,
			      <0xc11080e4 0x18>,
			      <0xc1108120 0x18>,
			      <0xc1108030 0x30>;
			reg-names = "mux", "pull-enable", "pull", "gpio";
			gpio-controller;
			#gpio-cells = <2>;
		};

		gpio_ao: ao-bank@c1108030 {
			reg = <0xc8100014 0x4>,
			      <0xc810002c 0x4>,
			      <0xc8100024 0x8>;
			reg-names = "mux", "pull", "gpio";
			gpio-controller;
			#gpio-cells = <2>;
		};

The driver then instantiates a gpio_chip for each subnode and a single
pinctrl device. Anyway, I'll document better the driver in the next
submission.

Thanks for the review!

Beniamino
