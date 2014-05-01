Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaEAMlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:41:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65461 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaEAMlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <1398287792-19831-3-git-send-email-linus.walleij@linaro.org>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org> <1398287792-19831-3-git-send-email-linus.walleij@linaro.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 1 May 2014 20:40:43 +0800
X-Google-Sender-Auth: UUDO_zyA1W01S6NvvAk8UMdL6EU
Message-ID: <CAGsJ_4zgQbsCZGXrAMqy6BbSvjtFUTYGw9px4UDRtUd=GUau=w@mail.gmail.com>
Subject: Re: [PATCH 2/2] RFT: pinctrl: sirf: move sgpio lock into state container
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-24 5:16 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
> Instead of referring to a global static variable for the sgpio
> locking, use the state container to contain the lock.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

hi Linus, thanks! this looks very good only if we fix the
gpiochip_add_pin_range() failure in patch 1:

[    0.231658] pinmux-sirf b0120000.pinctrl: initialized SIRFSOC pinmux driver
[    0.261200] bio: create slab <bio-0> at 0
[    0.268264] GPIO chip /axi/peri-iobg/pinctrl@b0120000: could not
create pin range
[    0.276142] pinmux-sirf b0120000.pinctrl: could not add gpiochip pin range


> ---
>  drivers/pinctrl/sirf/pinctrl-sirf.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
> index 0613e0c77e8a..2ca5424b2bca 100644
> --- a/drivers/pinctrl/sirf/pinctrl-sirf.c
> +++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
> @@ -40,10 +40,9 @@ struct sirfsoc_gpio_chip {
>         struct of_mm_gpio_chip chip;
>         bool is_marco; /* for marco, some registers are different with prima2 */
>         struct sirfsoc_gpio_bank sgpio_bank[SIRFSOC_GPIO_NO_OF_BANKS];
> +       spinlock_t lock;
>  };
>
> -static DEFINE_SPINLOCK(sgpio_lock);
> -
>  static struct sirfsoc_pin_group *sirfsoc_pin_groups;
>  static int sirfsoc_pingrp_cnt;
>
> @@ -450,13 +449,13 @@ static void sirfsoc_gpio_irq_ack(struct irq_data *d)
>
>         offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
>
> -       spin_lock_irqsave(&sgpio_lock, flags);
> +       spin_lock_irqsave(&sgpio->lock, flags);
>
>         val = readl(sgpio->chip.regs + offset);
>
>         writel(val, sgpio->chip.regs + offset);
>
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> +       spin_unlock_irqrestore(&sgpio->lock, flags);
>  }
>
>  static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_chip *sgpio,
> @@ -468,14 +467,14 @@ static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_chip *sgpio,
>
>         offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
>
> -       spin_lock_irqsave(&sgpio_lock, flags);
> +       spin_lock_irqsave(&sgpio->lock, flags);
>
>         val = readl(sgpio->chip.regs + offset);
>         val &= ~SIRFSOC_GPIO_CTL_INTR_EN_MASK;
>         val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
>         writel(val, sgpio->chip.regs + offset);
>
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> +       spin_unlock_irqrestore(&sgpio->lock, flags);
>  }
>
>  static void sirfsoc_gpio_irq_mask(struct irq_data *d)
> @@ -498,14 +497,14 @@ static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
>
>         offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
>
> -       spin_lock_irqsave(&sgpio_lock, flags);
> +       spin_lock_irqsave(&sgpio->lock, flags);
>
>         val = readl(sgpio->chip.regs + offset);
>         val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
>         val |= SIRFSOC_GPIO_CTL_INTR_EN_MASK;
>         writel(val, sgpio->chip.regs + offset);
>
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> +       spin_unlock_irqrestore(&sgpio->lock, flags);
>  }
>
>  static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
> @@ -519,7 +518,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>
>         offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
>
> -       spin_lock_irqsave(&sgpio_lock, flags);
> +       spin_lock_irqsave(&sgpio->lock, flags);
>
>         val = readl(sgpio->chip.regs + offset);
>         val &= ~(SIRFSOC_GPIO_CTL_INTR_STS_MASK | SIRFSOC_GPIO_CTL_OUT_EN_MASK);
> @@ -551,7 +550,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
>
>         writel(val, sgpio->chip.regs + offset);
>
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> +       spin_unlock_irqrestore(&sgpio->lock, flags);
>
>         return 0;
>  }
> @@ -714,11 +713,11 @@ static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
>
>         offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
>
> -       spin_lock_irqsave(&sgpio_lock, flags);
> +       spin_lock_irqsave(&sgpio->lock, flags);
>
>         sirfsoc_gpio_set_output(sgpio, bank, offset, value);
>
> -       spin_unlock_irqrestore(&sgpio_lock, flags);
> +       spin_unlock_irqrestore(&sgpio->lock, flags);
>
>         return 0;
>  }
> @@ -811,6 +810,7 @@ static int sirfsoc_gpio_probe(struct device_node *np)
>         sgpio = devm_kzalloc(&pdev->dev, sizeof(*sgpio), GFP_KERNEL);
>         if (!sgpio)
>                 return -ENOMEM;
> +       spin_lock_init(&sgpio->lock);
>
>         regs = of_iomap(np, 0);
>         if (!regs)
> --
> 1.9.0
>

-barry
