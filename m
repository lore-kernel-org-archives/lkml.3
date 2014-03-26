Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaCZClK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 22:41:10 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36206 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaCZClI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 22:41:08 -0400
MIME-Version: 1.0
In-Reply-To: <1395751894-7110-2-git-send-email-linus.walleij@linaro.org>
References: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org> <1395751894-7110-2-git-send-email-linus.walleij@linaro.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 26 Mar 2014 11:40:47 +0900
Message-ID: <CAAVeFuKhm9UrG3O1VcSq7QaP+R65NBkbLratWTBmpgSkY1GRYA@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpio: add IRQ chip helpers in gpiolib
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 9:51 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This provides a function gpiochip_irqchip_add() to set
> up an irqchip for a GPIO controller, and a function
> gpiochip_set_chained_irqchip() to chain it to a parent
> irqchip.
>
> Most GPIOs are of the type where a number of lines form
> a cascaded interrupt controller chained onto
> the primary system interrupt controller (or further down the
> chain) so let's add this helper and factor the code to
> request the lines to be used as IRQs, the .to_irq() function
> and the irqdomain into the core as well.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/Kconfig        |   3 +
>  drivers/gpio/gpiolib.c      | 188 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/gpio/driver.h |  29 +++++++
>  3 files changed, 220 insertions(+)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 2e461e459d88..51c782532687 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -55,6 +55,9 @@ config GPIO_ACPI
>         def_bool y
>         depends on ACPI
>
> +config GPIOLIB_IRQCHIP
> +       bool
> +
>  config DEBUG_GPIO
>         bool "Debug GPIO calls"
>         depends on DEBUG_KERNEL
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 584d2b465f84..f76c952e08b2 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1254,6 +1254,9 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_add);
>
> +/* Forward-declaration */
> +static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip);
> +
>  /**
>   * gpiochip_remove() - unregister a gpio_chip
>   * @chip: the chip to unregister
> @@ -1270,6 +1273,7 @@ int gpiochip_remove(struct gpio_chip *chip)
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> +       gpiochip_irqchip_remove(chip);
>         gpiochip_remove_pin_ranges(chip);
>         of_gpiochip_remove(chip);
>
> @@ -1339,6 +1343,190 @@ static struct gpio_chip *find_chip_by_name(const char *name)
>         return gpiochip_find((void *)name, gpiochip_match_name);
>  }
>
> +#ifdef CONFIG_GPIOLIB_IRQCHIP
> +
> +/*
> + * The following is irqchip helper code for gpiochips.
> + */
> +
> +/**
> + * gpiochip_add_chained_irqchip() - adds a chained irqchip to a gpiochip
> + * @gpiochip: the gpiochip to add the irqchip to
> + * @irqchip: the irqchip to add to the gpiochip
> + * @parent_irq: the irq number corresponding to the parent IRQ for this
> + * chained irqchip
> + * @parent_handler: the parent interrupt handler for the accumulated IRQ
> + * coming out of the gpiochip
> + */
> +void gpiochip_set_chained_irqchip(struct gpio_chip *gpiochip,
> +                                 struct irq_chip *irqchip,
> +                                 int parent_irq,
> +                                 irq_flow_handler_t parent_handler)
> +{
> +       irq_set_chained_handler(parent_irq, parent_handler);
> +       /*
> +        * The parent irqchip is already using the chip_data for this
> +        * irqchip, so our callbacks simply use the handler_data.
> +        */
> +       irq_set_handler_data(parent_irq, gpiochip);
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_set_chained_irqchip);
> +
> +/**
> + * gpiochip_irq_map() - maps an IRQ into a GPIO irqchip
> + * @d: the irqdomain used by this irqchip
> + * @irq: the global irq number used by this GPIO irqchip irq
> + * @hwirq: the local IRQ/GPIO line offset on this gpiochip
> + *
> + * This function will set up the mapping for a certain IRQ line on a
> + * gpiochip by assigning the gpiochip as chip data, and using the irqchip
> + * stored inside the gpiochip.
> + */
> +static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
> +                           irq_hw_number_t hwirq)
> +{
> +       struct gpio_chip *chip = d->host_data;
> +
> +       irq_set_chip_and_handler(irq, chip->irqchip, chip->irq_handler);
> +       irq_set_chip_data(irq, chip);
> +#ifdef CONFIG_ARM
> +       set_irq_flags(irq, IRQF_VALID);
> +#else
> +       irq_set_noprobe(irq);
> +#endif
> +       irq_set_irq_type(irq, chip->irq_default_type);
> +
> +       return 0;
> +}
> +
> +static const struct irq_domain_ops gpiochip_domain_ops = {
> +       .map    = gpiochip_irq_map,
> +       /* Virtually all GPIO irqchips are twocell:ed */
> +       .xlate  = irq_domain_xlate_twocell,
> +};
> +
> +static int gpiochip_irq_reqres(struct irq_data *d)
> +{
> +       struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
> +
> +       if (gpio_lock_as_irq(chip, d->hwirq)) {
> +               chip_err(chip,
> +                       "unable to lock HW IRQ %lu for IRQ\n",
> +                       d->hwirq);
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static void gpiochip_irq_relres(struct irq_data *d)
> +{
> +       struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
> +
> +       gpio_unlock_as_irq(chip, d->hwirq);
> +}
> +
> +static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       return irq_find_mapping(chip->irqdomain, offset);
> +}
> +
> +/**
> + * gpiochip_irqchip_remove() - removes an irqchip added to a gpiochip
> + * @gpiochip: the gpiochip to remove the irqchip from
> + *
> + * This is called only from gpiochip_remove()
> + */
> +static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip)
> +{
> +       if (gpiochip->irqdomain)
> +               irq_domain_remove(gpiochip->irqdomain);
> +
> +       if (gpiochip->irqchip) {
> +               gpiochip->irqchip->irq_request_resources = NULL;
> +               gpiochip->irqchip->irq_release_resources = NULL;
> +               gpiochip->irqchip = NULL;
> +       }
> +}
> +
> +/**
> + * gpiochip_irqchip_add() - adds an irqchip to a gpiochip
> + * @gpiochip: the gpiochip to add the irqchip to
> + * @irqchip: the irqchip to add to the gpiochip
> + * @first_irq: if not dynamically assigned, the base (first) IRQ to
> + * allocate gpiochip irqs from
> + * @handler: the irq handler to use (often a predefined irq core function)
> + * @type: the default type for IRQs on this irqchip
> + *
> + * This function closely associates a certain irqchip with a certain
> + * gpiochip, providing an irq domain to translate the local IRQs to
> + * global irqs in the gpiolib core, and making sure that the gpiochip
> + * is passed as chip data to all related functions. Driver callbacks
> + * need to use container_of() to get their local state containers back
> + * from the gpiochip passed as chip data. An irqdomain will be stored
> + * in the gpiochip that shall be used by the driver to handle IRQ number
> + * translation. The gpiochip will need to be initialized and registered
> + * before calling this function.
> + *
> + * This function will handle two cell:ed simple IRQs. Everything else
> + * need to be open coded.
> + */
> +int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
> +                        struct irq_chip *irqchip,
> +                        unsigned int first_irq,
> +                        irq_flow_handler_t handler,
> +                        unsigned int type)
> +{
> +       struct device_node *of_node;
> +       unsigned int offset;
> +
> +       if (!gpiochip || !irqchip)
> +               return -EINVAL;
> +
> +       if (!gpiochip->dev) {
> +               pr_err("missing gpiochip .dev parent pointer\n");
> +               return -EINVAL;
> +       }
> +       of_node = gpiochip->dev->of_node;
> +#if CONFIG_OF_GPIO
> +       /*
> +        * If the gpiochip has an assigned OF node this takes precendence
> +        * FIXME: get rid of this and use gpiochip->dev->of_node everywhere
> +        */
> +       if (gpiochip->of_node)
> +               of_node = gpiochip->of_node;
> +#endif
> +       gpiochip->irqchip = irqchip;
> +       gpiochip->irq_handler = handler;
> +       gpiochip->irq_default_type = type;
> +       gpiochip->to_irq = gpiochip_to_irq;
> +       gpiochip->irqdomain = irq_domain_add_simple(of_node,
> +                                       gpiochip->ngpio, first_irq,
> +                                       &gpiochip_domain_ops, gpiochip);
> +       if (!gpiochip->irqdomain) {
> +               gpiochip->irqchip = NULL;
> +               return -EINVAL;
> +       }
> +       irqchip->irq_request_resources = gpiochip_irq_reqres;
> +       irqchip->irq_release_resources = gpiochip_irq_relres;
> +
> +       /*
> +        * Prepare the mapping since the irqchip shall be orthogonal to
> +        * to any gpiochip calls. If the first_irq was zero, this is

If you ever need to send a v2 sometime, maybe fix the double "to" in
this comment. ;)
