Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243AbaDJDtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:49:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35638 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152AbaDJDtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <1396960077-30599-1-git-send-email-linus.walleij@linaro.org>
References: <1396960077-30599-1-git-send-email-linus.walleij@linaro.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 10 Apr 2014 11:48:56 +0800
X-Google-Sender-Auth: H6UoomZDhdaodfTJb3vRo7zUmro
Message-ID: <CAGsJ_4yfCcQoMmUD08HBJDkXSPUOuUP-Sj9EZAJZ8grpodReiw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: sirf: switch driver to use gpiolib irqchip helpers
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        linux-gpio@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-08 20:27 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
> This switches the Sirf pinctrl driver over to using the gpiolib
> irqchip helpers simplifying some of the code.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This really needs testing on real hardware before I dare to
> merge it, but the driver seems simple and straight-forward to
> convert.

Linus, this  broke the irq/gpio mapping. for example:

without this:
# cat /proc/interrupts
           CPU0
 16:        181  irq_sirfsoc   0  sirfsoc_timer0
...
 62:          0  sirf-gpio-irq  45  extcon-gpio
...

with this:
# cat /proc/interrupts
           CPU0
 16:        944  irq_sirfsoc   0  sirfsoc_timer0
...
105:          0  sirf-gpio-irq  13  extcon-gpio
...

i will do a debug to find why. any idea from you?

-barry

> ---
>  drivers/pinctrl/Kconfig             |   1 +
>  drivers/pinctrl/sirf/pinctrl-sirf.c | 103 +++++++++---------------------------
>  2 files changed, 27 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index e49324032611..ddd4e6eae3c1 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -270,6 +270,7 @@ config PINCTRL_SIRF
>         bool "CSR SiRFprimaII/SiRFmarco pin controller driver"
>         depends on ARCH_SIRF
>         select PINMUX
> +       select GPIOLIB_IRQCHIP
>
>  config PINCTRL_SUNXI
>         bool
> diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
> index 2c3eb207ff87..99dbe61f5fd1 100644
> --- a/drivers/pinctrl/sirf/pinctrl-sirf.c
> +++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
> @@ -9,13 +9,10 @@
>
>  #include <linux/init.h>
>  #include <linux/module.h>
> -#include <linux/irq.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
> -#include <linux/irqdomain.h>
> -#include <linux/irqchip/chained_irq.h>
>  #include <linux/pinctrl/pinctrl.h>
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/pinctrl/consumer.h>
> @@ -27,7 +24,6 @@
>  #include <linux/bitops.h>
>  #include <linux/gpio.h>
>  #include <linux/of_gpio.h>
> -#include <asm/mach/irq.h>
>
>  #include "pinctrl-sirf.h"
>
> @@ -35,7 +31,6 @@
>
>  struct sirfsoc_gpio_bank {
>         struct of_mm_gpio_chip chip;
> -       struct irq_domain *domain;
>         int id;
>         int parent_irq;
>         spinlock_t lock;
> @@ -464,15 +459,6 @@ static int __init sirfsoc_pinmux_init(void)
>  }
>  arch_initcall(sirfsoc_pinmux_init);
>
> -static inline int sirfsoc_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> -{
> -       struct sirfsoc_gpio_bank *bank = container_of(to_of_mm_gpio_chip(chip),
> -               struct sirfsoc_gpio_bank, chip);
> -
> -       return irq_create_mapping(bank->domain, offset + bank->id *
> -               SIRFSOC_GPIO_BANK_SIZE);
> -}
> -
>  static inline int sirfsoc_gpio_to_offset(unsigned int gpio)
>  {
>         return gpio % SIRFSOC_GPIO_BANK_SIZE;
> @@ -490,7 +476,8 @@ static inline struct sirfsoc_gpio_bank *sirfsoc_gpiochip_to_bank(struct gpio_chi
>
>  static void sirfsoc_gpio_irq_ack(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(gc);
>         int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
>         u32 val, offset;
>         unsigned long flags;
> @@ -525,14 +512,16 @@ static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_bank *bank, int idx)
>
>  static void sirfsoc_gpio_irq_mask(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(gc);
>
>         __sirfsoc_gpio_irq_mask(bank, d->hwirq % SIRFSOC_GPIO_BANK_SIZE);
>  }
>
>  static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
>  {
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(gc);
>         int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
>         u32 val, offset;
>         unsigned long flags;
> @@ -551,7 +540,8 @@ static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
>
>  static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>  {
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(gc);
>         int idx = d->hwirq % SIRFSOC_GPIO_BANK_SIZE;
>         u32 val, offset;
>         unsigned long flags;
> @@ -595,39 +585,18 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>         return 0;
>  }
>
> -static int sirfsoc_gpio_irq_reqres(struct irq_data *d)
> -{
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> -
> -       if (gpio_lock_as_irq(&bank->chip.gc, d->hwirq % SIRFSOC_GPIO_BANK_SIZE)) {
> -               dev_err(bank->chip.gc.dev,
> -                       "unable to lock HW IRQ %lu for IRQ\n",
> -                       d->hwirq);
> -               return -EINVAL;
> -       }
> -       return 0;
> -}
> -
> -static void sirfsoc_gpio_irq_relres(struct irq_data *d)
> -{
> -       struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> -
> -       gpio_unlock_as_irq(&bank->chip.gc, d->hwirq % SIRFSOC_GPIO_BANK_SIZE);
> -}
> -
>  static struct irq_chip sirfsoc_irq_chip = {
>         .name = "sirf-gpio-irq",
>         .irq_ack = sirfsoc_gpio_irq_ack,
>         .irq_mask = sirfsoc_gpio_irq_mask,
>         .irq_unmask = sirfsoc_gpio_irq_unmask,
>         .irq_set_type = sirfsoc_gpio_irq_type,
> -       .irq_request_resources = sirfsoc_gpio_irq_reqres,
> -       .irq_release_resources = sirfsoc_gpio_irq_relres,
>  };
>
>  static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>  {
> -       struct sirfsoc_gpio_bank *bank = irq_get_handler_data(irq);
> +       struct gpio_chip *gc = irq_desc_get_handler_data(desc);
> +       struct sirfsoc_gpio_bank *bank = sirfsoc_gpiochip_to_bank(gc);
>         u32 status, ctrl;
>         int idx = 0;
>         struct irq_chip *chip = irq_get_chip(irq);
> @@ -653,7 +622,7 @@ static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
>                 if ((status & 0x1) && (ctrl & SIRFSOC_GPIO_CTL_INTR_EN_MASK)) {
>                         pr_debug("%s: gpio id %d idx %d happens\n",
>                                 __func__, bank->id, idx);
> -                       generic_handle_irq(irq_find_mapping(bank->domain, idx +
> +                       generic_handle_irq(irq_find_mapping(gc->irqdomain, idx +
>                                         bank->id * SIRFSOC_GPIO_BANK_SIZE));
>                 }
>
> @@ -801,27 +770,6 @@ static void sirfsoc_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>         spin_unlock_irqrestore(&bank->lock, flags);
>  }
>
> -static int sirfsoc_gpio_irq_map(struct irq_domain *d, unsigned int irq,
> -                               irq_hw_number_t hwirq)
> -{
> -       struct sirfsoc_gpio_bank *bank = d->host_data;
> -
> -       if (!bank)
> -               return -EINVAL;
> -
> -       irq_set_chip(irq, &sirfsoc_irq_chip);
> -       irq_set_handler(irq, handle_level_irq);
> -       irq_set_chip_data(irq, bank + hwirq / SIRFSOC_GPIO_BANK_SIZE);
> -       set_irq_flags(irq, IRQF_VALID);
> -
> -       return 0;
> -}
> -
> -static const struct irq_domain_ops sirfsoc_gpio_irq_simple_ops = {
> -       .map = sirfsoc_gpio_irq_map,
> -       .xlate = irq_domain_xlate_twocell,
> -};
> -
>  static void sirfsoc_gpio_set_pullup(const u32 *pullups)
>  {
>         int i, n;
> @@ -860,7 +808,6 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         struct sirfsoc_gpio_bank *bank;
>         void __iomem *regs;
>         struct platform_device *pdev;
> -       struct irq_domain *domain;
>         bool is_marco = false;
>
>         u32 pullups[SIRFSOC_GPIO_NO_OF_BANKS], pulldowns[SIRFSOC_GPIO_NO_OF_BANKS];
> @@ -876,14 +823,6 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         if (of_device_is_compatible(np, "sirf,marco-pinctrl"))
>                 is_marco = 1;
>
> -       domain = irq_domain_add_linear(np, SIRFSOC_GPIO_BANK_SIZE * SIRFSOC_GPIO_NO_OF_BANKS,
> -               &sirfsoc_gpio_irq_simple_ops, sgpio_bank);
> -       if (!domain) {
> -               pr_err("%s: Failed to create irqdomain\n", np->full_name);
> -                       err = -ENOSYS;
> -               goto out;
> -       }
> -
>         for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
>                 bank = &sgpio_bank[i];
>                 spin_lock_init(&bank->lock);
> @@ -893,7 +832,6 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>                 bank->chip.gc.get = sirfsoc_gpio_get_value;
>                 bank->chip.gc.direction_output = sirfsoc_gpio_direction_output;
>                 bank->chip.gc.set = sirfsoc_gpio_set_value;
> -               bank->chip.gc.to_irq = sirfsoc_gpio_to_irq;
>                 bank->chip.gc.base = i * SIRFSOC_GPIO_BANK_SIZE;
>                 bank->chip.gc.ngpio = SIRFSOC_GPIO_BANK_SIZE;
>                 bank->chip.gc.label = kstrdup(np->full_name, GFP_KERNEL);
> @@ -912,15 +850,26 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>
>                 err = gpiochip_add(&bank->chip.gc);
>                 if (err) {
> -                       pr_err("%s: error in probe function with status %d\n",
> +                       dev_err(&pdev->dev,
> +                               "%s: error in probe function with status %d\n",
>                                 np->full_name, err);
>                         goto out;
>                 }
>
> -               bank->domain = domain;
> +               err =  gpiochip_irqchip_add(&bank->chip.gc,
> +                                           &sirfsoc_irq_chip,
> +                                           0, handle_level_irq,
> +                                           IRQ_TYPE_NONE);
> +               if (err) {
> +                       dev_err(&pdev->dev,
> +                               "could not connect irqchip to gpiochip\n");
> +                       goto out;
> +               }
>
> -               irq_set_chained_handler(bank->parent_irq, sirfsoc_gpio_handle_irq);
> -               irq_set_handler_data(bank->parent_irq, bank);
> +               gpiochip_set_chained_irqchip(&bank->chip.gc,
> +                                            &sirfsoc_irq_chip,
> +                                            bank->parent_irq,
> +                                            sirfsoc_gpio_handle_irq);
>         }
>
>         if (!of_property_read_u32_array(np, "sirf,pullups", pullups,
> --
> 1.9.0
>
