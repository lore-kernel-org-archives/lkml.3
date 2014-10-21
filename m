Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaJUNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:39:28 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34913 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaJUNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:39:26 -0400
MIME-Version: 1.0
In-Reply-To: <1412717576-19737-2-git-send-email-b.galvani@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
	<1412717576-19737-2-git-send-email-b.galvani@gmail.com>
Date: Tue, 21 Oct 2014 15:39:25 +0200
Message-ID: <CACRpkdZV9Gmx7Oy4QRh4y2MNN=FXbSF2W0cnjbtxkrB4vT2UOg@mail.gmail.com>
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

On Tue, Oct 7, 2014 at 11:32 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

Sorry for a quick and brief review, but should be enough for you to proceed
to iterate the patch.

> This is a driver for the pinmux and GPIO controller available in
> Amlogic Meson SoCs. At the moment it only supports Meson8 devices,
> however other SoC families like Meson6 and Meson8b (the Cortex-A5
> variant) appears to be similar, with just different sets of banks and
> registers.
>
> GPIO interrupts are not supported at the moment due to lack of
> documentation.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

>  arch/arm/mach-meson/Kconfig            |   3 +

Please don't mix up driver submission with platform enablement.
Put this Kconfig fragment in a separate patch.

> +++ b/drivers/pinctrl/meson/pinctrl-meson.c
(...)

> +static void meson_domain_set_bit(struct meson_domain *domain,
> +                                void __iomem *addr, unsigned int bit,
> +                                unsigned int value)
> +{
> +       unsigned long flags;
> +       unsigned int data;
> +
> +       spin_lock_irqsave(&domain->lock, flags);
> +       data = readl(addr);
> +
> +       if (value)
> +               data |= BIT(bit);
> +       else
> +               data &= ~BIT(bit);
> +
> +       writel(data, addr);
> +       spin_unlock_irqrestore(&domain->lock, flags);
> +}

Looks like you are re-implementing mmio regmap. Take a look at
devm_regmap_init_mmio() from <linux/regmap.h>

> +static int meson_get_pin_reg_and_bit(struct meson_domain *domain,
> +                                    unsigned pin, int reg_type,
> +                                    unsigned int *reg_num, unsigned int *bit)
> +{
> +       struct meson_bank *bank;
> +       int i, found = 0;

bool found;

> +
> +       for (i = 0; i < domain->data->num_banks; i++) {
> +               bank = &domain->data->banks[i];
> +               if (pin >= bank->first && pin <= bank->last) {
> +                       found = 1;
> +                       break;
> +               }
> +       }
> +
> +       if (!found)
> +               return 1;

Can't you return a negative errorcode like everyone else?

> +
> +       *reg_num = bank->regs[reg_type].reg;
> +       *bit = bank->regs[reg_type].bit + pin - bank->first;
> +
> +       return 0;
> +}

This function is weird and could use some kerneldoc explanation
to what it does I think.

> +static int meson_pmx_request_gpio(struct pinctrl_dev *pcdev,
> +                                 struct pinctrl_gpio_range *range,
> +                                 unsigned offset)
> +{
> +       struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
> +
> +       meson_pmx_disable_other_groups(pc, offset, -1);

Passing the argument -1 is usually a bit ambiguous.

> +
> +       return 0;
> +}

> +static inline struct meson_domain *to_meson_domain(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct meson_domain, chip);
> +}

I have a very vague idea what a "meson domain" is, can this be explained
in some good place? Like in the struct meson_domain with
kerneldoc...

> +static int meson_gpio_get(struct gpio_chip *chip, unsigned gpio)
> +{
> +       struct meson_domain *domain = to_meson_domain(chip);
> +       void __iomem *addr;
> +       unsigned int bit;
> +
> +       if (meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_IN,
> +                                       &addr, &bit))
> +               return 0;
> +
> +       return (readl(addr) >> bit) & 1;

Do it like this:

return !!(readl(addr) & BIT(bit));

> +static int meson_gpio_of_xlate(struct gpio_chip *chip,
> +                              const struct of_phandle_args *gpiospec,
> +                              u32 *flags)
> +{
> +       unsigned gpio = gpiospec->args[0];
> +
> +       if (gpio < chip->base || gpio >= chip->base + chip->ngpio)
> +               return -EINVAL;
> +
> +       if (flags)
> +               *flags = gpiospec->args[1];
> +
> +       return gpio - chip->base;
> +}

Why is this necessary? We want to get rid of all use of
chip->base so introducing new users is not nice.
The default of_gpio_simple_xlate() should be enough,
don't you agree?

I guess this is a twocell binding? Else I suggest you alter your
bindings to use two cells and be happy with that, as you can
have your driver behave like all others.

> +static int meson_pinctrl_init_data(struct meson_pinctrl *pc)
> +{
> +       struct meson_domain_data *data;
> +       int i, j, pin = 0, func = 0, group = 0;
> +
> +       /* Copy pin definitions from domains to pinctrl */
> +       pc->pins = devm_kzalloc(pc->dev, pc->num_pins *
> +                               sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
> +       if (!pc->pins)
> +               return -ENOMEM;
> +
> +       for (i = 0, j = 0; i < pc->num_domains; i++) {
> +               data = pc->domains[i].data;
> +               for (j = 0; j < data->num_pins; j++) {
> +                       pc->pins[pin].number = pin;
> +                       pc->pins[pin++].name = data->pin_names[j];
> +               }
> +       }

This seems a little kludgy. Why can't these domains also simply
use struct pinctrl_pin_desc?

> +       /* Copy group and function definitions from domains to pinctrl */
> +       pc->groups = devm_kzalloc(pc->dev, pc->num_groups *
> +                                 sizeof(struct meson_pmx_group), GFP_KERNEL);
> +       pc->funcs = devm_kzalloc(pc->dev, pc->num_funcs *
> +                                 sizeof(struct meson_pmx_func), GFP_KERNEL);
> +       if (!pc->groups || !pc->funcs)
> +               return -ENOMEM;

Again more copying. Why can't we just have one set of this data
and only pass pointers?

> +       for (i = 0; i < pc->num_domains; i++) {
> +               data = pc->domains[i].data;
> +
> +               for (j = 0; j < data->num_groups; j++) {
> +                       memcpy(&pc->groups[group], &data->groups[j],
> +                              sizeof(struct meson_pmx_group));
> +                       pc->groups[group++].domain = &pc->domains[i];
> +               }
> +
> +               for (j = 0; j < data->num_funcs; j++) {
> +                       memcpy(&pc->funcs[func++], &data->funcs[j],
> +                              sizeof(struct meson_pmx_func));
> +               }
> +       }
> +
> +       /* Count pins in groups */
> +       for (i = 0; i < pc->num_groups; i++) {
> +               for (j = 0; ; j++) {
> +                       if (pc->groups[i].pins[j] == PINS_END) {
> +                               pc->groups[i].num_pins = j;
> +                               break;
> +                       }
> +               }
> +       }
> +
> +       /* Count groups in functions */
> +       for (i = 0; i < pc->num_funcs; i++) {
> +               for (j = 0; ; j++) {
> +                       if (!pc->funcs[i].groups[j]) {
> +                               pc->funcs[i].num_groups = j;
> +                               break;
> +                       }
> +               }
> +       }

All this dynamic code also looks cumbersome to maintain.

Why can't static arrays and ARRAY_SIZE() be used throughout
instead, just pass around pointers?

> +static int meson_gpiolib_register(struct meson_pinctrl *pc)
> +{
> +       struct meson_domain *domain;
> +       unsigned int base = 0;
> +       int i, ret;
> +
> +       for (i = 0; i < pc->num_domains; i++) {
> +               domain = &pc->domains[i];
> +
> +               domain->chip.label = domain->data->name;
> +               domain->chip.dev = pc->dev;
> +               domain->chip.request = meson_gpio_request;
> +               domain->chip.free = meson_gpio_free;
> +               domain->chip.direction_input = meson_gpio_direction_input;
> +               domain->chip.direction_output = meson_gpio_direction_output;
> +               domain->chip.get = meson_gpio_get;
> +               domain->chip.set = meson_gpio_set;
> +               domain->chip.base = base;
> +               domain->chip.ngpio = domain->data->num_pins;
> +               domain->chip.names = domain->data->pin_names;
> +               domain->chip.can_sleep = false;
> +               domain->chip.of_node = domain->of_node;
> +               domain->chip.of_gpio_n_cells = 2;
> +               domain->chip.of_xlate = meson_gpio_of_xlate;
> +
> +               ret = gpiochip_add(&domain->chip);
> +               if (ret < 0) {
> +                       dev_err(pc->dev, "can't add gpio chip %s\n",
> +                               domain->data->name);
> +                       goto fail;
> +               }
> +
> +               domain->gpio_range.name = domain->data->name;
> +               domain->gpio_range.id = i;
> +               domain->gpio_range.base = base;
> +               domain->gpio_range.pin_base = base;
> +               domain->gpio_range.npins = domain->data->num_pins;
> +               domain->gpio_range.gc = &domain->chip;
> +               pinctrl_add_gpio_range(pc->pcdev, &domain->gpio_range);

No thanks, use gpiochip_add_pin_range() instead. That is much
better as it's completely relative.

(...)
> +++ b/drivers/pinctrl/meson/pinctrl-meson.h
> +/**
> + * struct meson bank
> + *
> + * @name:      bank name
> + * @first:     first pin of the bank
> + * @last:      last pin of the bank
> + * @regs:      couples of <reg offset, bit index> controlling the
> + *             functionalities of the bank pins (pull, direction, value)
> + *
> + * A bank represents a set of pins controlled by a contiguous set of
> + * bits in the domain registers.
> + */
> +struct meson_bank {
> +       const char *name;
> +       unsigned int first;
> +       unsigned int last;
> +       struct meson_reg_offset regs[NUM_REG];
> +};

That struct is actually documented!

> +/**
> + * struct meson_domain
> + *
> + * @reg_mux:   registers for mux settings
> + * @reg_pullen:        registers for pull-enable settings
> + * @reg_pull:  registers for pull settings
> + * @reg_gpio:  registers for gpio settings
> + * @mux_size:  size of mux register range (in words)
> + * @pullen_size:size of pull-enable register range
> + * @pull_size: size of pull register range
> + * @gpio_size: size of gpio register range
> + * @chip:      gpio chip associated with the domain
> + * @data;      platform data for the domain
> + * @node:      device tree node for the domain
> + * @gpio_range:        gpio range that maps domain gpios to the pin controller
> + * @lock:      spinlock for accessing domain registers
> + *
> + * A domain represents a set of banks controlled by the same set of
> + * registers. Typically there is a domain for the normal banks and
> + * another one for the Always-On bus.
> + */

Can I get a long-ish explanation of the domains vs banks etc
because that's really key to understanding this driver!

Some example or something.

Yours,
Linus Walleij
