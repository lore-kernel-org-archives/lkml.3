Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaAOOPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:15:40 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53930 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaAOOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:15:37 -0500
MIME-Version: 1.0
In-Reply-To: <1389711134-21049-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
	<1389711134-21049-1-git-send-email-srinivas.kandagatla@st.com>
Date: Wed, 15 Jan 2014 15:15:34 +0100
Message-ID: <CACRpkdY=uTtE8CMyQocQcV4c7xmvR_it1ue03kSfKmaLQX_sxA@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] pinctrl: st: Add Interrupt support.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 3:52 PM,  <srinivas.kandagatla@st.com> wrote:

> ST Pincontroller GPIO bank can have one of the two possible types of
> interrupt-wirings.

Interesting :-)

> +Pin controller node:
> +Required properties:
>  - compatible   : should be "st,<SOC>-<pio-block>-pinctrl"
>         like st,stih415-sbc-pinctrl, st,stih415-front-pinctrl and so on.
> -- gpio-controller : Indicates this device is a GPIO controller
> -- #gpio-cells    : Should be one. The first cell is the pin number.
> +- st,syscfg            : Should be a phandle of the syscfg node.

So why do you add this? This is totally unused by your driver.

>  - st,retime-pin-mask   : Should be mask to specify which pins can be retimed.
>         If the property is not present, it is assumed that all the pins in the
>         bank are capable of retiming. Retiming is mainly used to improve the
>         IO timing margins of external synchronous interfaces.
> -- st,bank-name         : Should be a name string for this bank as
> -                       specified in datasheet.

Why do you have this property? The driver is not using it.

And what is wrong with just using that name for the node?

> -- st,syscfg            : Should be a phandle of the syscfg node.
> +- ranges       : specifies the ranges for the pin controller memory.

And what are they used for? I've never seen this before.

> +Optional properties:
> +- interrupts   : Interrupt number of the irqmux. If the interrupt is shared
> +  with other gpio banks via irqmux.
> +  a irqline and gpio banks.
> +- reg          : irqmux memory resource. If irqmux is present.
> +- reg-names    : irqmux resource should be named as "irqmux".
> +
> +GPIO controller node.
> +Required properties:
> +- gpio-controller : Indicates this device is a GPIO controller
> +- #gpio-cells    : Should be one. The first cell is the pin number.
> +- st,bank-name   : Should be a name string for this bank as specified in
> +  datasheet.

Again, why?

> +Optional properties:
> +- interrupts   : Interrupt number for this gpio bank. If there is a dedicated
> +  interrupt wired up for this gpio bank.
> +
> +- interrupt-controller : Indicates this device is a interrupt controller. GPIO
> +  bank can be an interrupt controller iff one of the interrupt type either via
> +irqmux or a dedicated interrupt per bank is specified.
> +
> +- #interrupt-cells: the value of this property should be 2.
> +     - First Cell: represents the external gpio interrupt number local to the
> +       external gpio interrupt space of the controller.
> +     - Second Cell: flags to identify the type of the interrupt
> +       - 1 = rising edge triggered
> +       - 2 = falling edge triggered
> +       - 3 = rising and falling edge triggered
> +       - 4 = high level triggered
> +       - 8 = low level triggered

Correct, but reference symbols from:
include/dt-bindings/interrupt-controller/irq.h
in example.


>
>  Example:
>         pin-controller-sbc {

Please put in an updated example making use of all the
new props.


(...)
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c

> @@ -271,6 +276,8 @@ struct st_gpio_bank {
>         struct pinctrl_gpio_range       range;
>         void __iomem                    *base;
>         struct st_pio_control           pc;
> +       struct  irq_domain              *domain;
> +       int                             gpio_irq;

Why are you putting this IRQ into the state container when it can be
a function local variable in probe()?

>  struct st_pinctrl {
> @@ -284,6 +291,8 @@ struct st_pinctrl {
>         int                             ngroups;
>         struct regmap                   *regmap;
>         const struct st_pctl_data       *data;
> +       void __iomem                    *irqmux_base;
> +       int                             irqmux_irq;

Dito. I think.

> +static int st_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct st_gpio_bank *bank = gpio_chip_to_bank(chip);
> +       int virq;

Just name this variable "irq". It is no more virtual than any other
IRQ.

> +
> +       if (bank->domain && (offset < chip->ngpio))
> +               virq = irq_create_mapping(bank->domain, offset);

No, don't do the create_mapping() call in the .to_irq() function.
Call irq_create_mapping() for *all* valid hwirqs in probe() and use
irq_find_mapping() here.

> +static void st_gpio_irq_disable(struct irq_data *d)
> +{
> +       struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +
> +       writel(BIT(d->hwirq), bank->base + REG_PIO_CLR_PMASK);
> +}
> +
> +static void st_gpio_irq_enable(struct irq_data *d)
> +{
> +       struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +
> +       writel(BIT(d->hwirq), bank->base + REG_PIO_SET_PMASK);
> +}

I *strongly* suspect that these two should be replaced with
_mask()/_unmask() rather than using disable/enable.

Because that seems to be what they are doing.

(...)
> +static void __gpio_irq_handler(struct st_gpio_bank *bank)
> +{
> +       unsigned long port_in, port_mask, port_comp, port_active;
> +       int n;
> +
> +       port_in = readl(bank->base + REG_PIO_PIN);
> +       port_comp = readl(bank->base + REG_PIO_PCOMP);
> +       port_mask = readl(bank->base + REG_PIO_PMASK);
> +
> +       port_active = (port_in ^ port_comp) & port_mask;
> +
> +       for_each_set_bit(n, &port_active, BITS_PER_LONG) {
> +               generic_handle_irq(irq_find_mapping(bank->domain, n));

So what happens if new IRQs appear in the register while you are
inside this loop?

Check this recent patch:
http://marc.info/?l=linux-arm-kernel&m=138979164119464&w=2

Especially this:

+ for (;;) {
+     mask = ioread8(host->base + CLRHILVINT) & 0xff;
+     mask |= (ioread8(host->base + SECOINT) & SECOINT_MASK) << 8;
+     mask |= (ioread8(host->base + PRIMINT) & PRIMINT_MASK) << 8;
+     mask &= host->irq_high_enabled | (host->irq_sys_enabled << 8);
+     if (mask == 0)
+         break;
+     for_each_set_bit(n, &mask, BITS_PER_LONG)
+     generic_handle_irq(irq_find_mapping(host->domain, n));
+ }


> +static struct irq_chip st_gpio_irqchip = {
> +       .name           = "GPIO",
> +       .irq_disable    = st_gpio_irq_disable,
> +       .irq_mask       = st_gpio_irq_disable,
> +       .irq_unmask     = st_gpio_irq_enable,

Just implement mask/unmask as indicated earlier.

> +       .irq_set_type   = st_gpio_irq_set_type,
> +};

You need to mark IRQ GPIO lines as used for IRQ.

Add startup() and shutdown() hooks similar to those I add
in this patch:

http://marc.info/?l=linux-gpio&m=138977709114785&w=2

> +static int st_gpio_irq_domain_xlate(struct irq_domain *d,
> +       struct device_node *ctrlr, const u32 *intspec, unsigned int intsize,
> +       irq_hw_number_t *out_hwirq, unsigned int *out_type)
> +{
> +       struct st_gpio_bank *bank = d->host_data;
> +       int ret;
> +       int pin = bank->gpio_chip.base + intspec[0];
> +
> +       if (WARN_ON(intsize < 2))
> +               return -EINVAL;
> +
> +       *out_hwirq = intspec[0];
> +       *out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
> +
> +       ret = gpio_request(pin, ctrlr->full_name);
> +       if (ret)
> +               return ret;
> +
> +       ret = gpio_direction_input(pin);
> +       if (ret)
> +               return ret;

We recently concluded that you should *NOT* call
gpio_request() and gpio_direction_input() from xlate or similar.

Instead: set up the hardware directly in mask/unmask callbacks
so that the irqchip can trigger IRQs directly without any
interaction with the GPIO subsystem.

By implementing the startup/shutdown hooks as indicated
above you can still indicate to the GPIO subsystem what is
going on and it will enforce that e.g. the line is not set to
output.

>  static int st_gpiolib_register_bank(struct st_pinctrl *info,
> @@ -1219,7 +1378,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>         struct pinctrl_gpio_range *range = &bank->range;
>         struct device *dev = info->dev;
>         int bank_num = of_alias_get_id(np, "gpio");
> -       struct resource res;
> +       struct resource res, irq_res;
>         int err;
>
>         if (of_address_to_resource(np, 0, &res))
> @@ -1248,6 +1407,43 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>         }
>         dev_info(dev, "%s bank added.\n", range->name);
>
> +       /**
> +        * GPIO bank can have one of the two possible types of
> +        * interrupt-wirings.
> +        *
> +        * First type is via irqmux, single interrupt is used by multiple
> +        * gpio banks. This reduces number of overall interrupts numbers
> +        * required. All these banks belong to a single pincontroller.
> +        *                _________
> +        *               |         |----> [gpio-bank (n)    ]
> +        *               |         |----> [gpio-bank (n + 1)]
> +        *      [irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
> +        *               |         |----> [gpio-bank (...  )]
> +        *               |_________|----> [gpio-bank (n + 7)]
> +        *
> +        * Second type has a dedicated interrupt per each gpio bank.
> +        *
> +        *      [irqN]----> [gpio-bank (n)]
> +        */
> +
> +       if (!of_irq_to_resource(np, 0, &irq_res)) {
> +               bank->gpio_irq = irq_res.start;
> +               irq_set_chained_handler(bank->gpio_irq, st_gpio_irq_handler);
> +               irq_set_handler_data(bank->gpio_irq, bank);
> +       }
> +
> +       if (info->irqmux_irq > 0 || bank->gpio_irq > 0) {
> +               /* Setup IRQ domain */
> +               bank->domain  = irq_domain_add_linear(np,
> +                                               ST_GPIO_PINS_PER_BANK,
> +                                               &st_gpio_irq_ops, bank);
> +               if (!bank->domain)
> +                       dev_err(dev, "Failed to add irq domain for [%s]\n",
> +                               np->full_name);
> +       } else {
> +               dev_info(dev, "No IRQ support for [%s] bank\n", np->full_name);

Why is the [bank name] inside [brackets]?

Yours,
Linus Walleij
