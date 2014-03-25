Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaCYSsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:48:47 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:34073 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaCYSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
Date: Tue, 25 Mar 2014 13:48:44 -0500
Message-ID: <CANk1AXTUr2MevsXphxicgZEPC2tQBUh6pEXa78Fa6Jt4bPiRdQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] gpio: dwapb: use a second irq chip
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 11:16 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Right new have one irq chip running always in level mode. It would nicer
> to have two irq chips where one is handling level type interrupts and
> the other one is doing edge interrupts. So we can have at runtime two users
> where one is using edge and the other level.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/gpio/gpio-dwapb.c | 41 ++++++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 752ccb1..3c9cdda 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -192,6 +192,8 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>                 break;
>         }
>
> +       irq_setup_alt_chip(d, type);
> +
>         writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
>         writel(polarity, gpio->regs + GPIO_INT_POLARITY);
>         irq_gc_unlock(igc);
> @@ -207,7 +209,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         struct irq_chip_generic *irq_gc;
>         unsigned int hwirq, ngpio = gc->ngpio;
>         struct irq_chip_type *ct;
> -       int err, irq;
> +       int err, irq, i;
>
>         irq = irq_of_parse_and_map(node, 0);
>         if (!irq) {
> @@ -221,7 +223,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         if (!gpio->domain)
>                 return;
>
> -       err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 1,
> +       err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 2,
>                                              "gpio-dwapb", handle_level_irq,
>                                              IRQ_NOREQUEST, 0,
>                                              IRQ_GC_INIT_NESTED_LOCK);
> @@ -242,17 +244,28 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         irq_gc->reg_base = gpio->regs;
>         irq_gc->private = gpio;
>
> -       ct = irq_gc->chip_types;
> -       ct->chip.irq_ack = irq_gc_ack_set_bit;
> -       ct->chip.irq_mask = irq_gc_mask_set_bit;
> -       ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> -       ct->chip.irq_set_type = dwapb_irq_set_type;
> -       ct->chip.irq_enable = dwapb_irq_enable;
> -       ct->chip.irq_disable = dwapb_irq_disable;
> -       ct->chip.irq_request_resources = dwapb_irq_reqres;
> -       ct->chip.irq_release_resources = dwapb_irq_relres;
> -       ct->regs.ack = GPIO_PORTA_EOI;
> -       ct->regs.mask = GPIO_INTMASK;
> +       for (i = 0; i < 2; i++) {
> +
> +               ct = &irq_gc->chip_types[i];
> +               ct->chip.irq_ack = irq_gc_ack_set_bit;
> +               ct->chip.irq_mask = irq_gc_mask_set_bit;
> +               ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> +               ct->chip.irq_set_type = dwapb_irq_set_type;
> +               ct->chip.irq_enable = dwapb_irq_enable;
> +               ct->chip.irq_disable = dwapb_irq_disable;
> +               ct->chip.irq_request_resources = dwapb_irq_reqres;
> +               ct->chip.irq_release_resources = dwapb_irq_relres;

I'm trying to test against recent tag next-20140312.  Got a build error.

/home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:254:11:
error: 'struct irq_chip' has no member named 'irq_request_resources'
/home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:254:36:
error: 'dwapb_irq_reqres' undeclared (first use in this function)
/home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:255:11:
error: 'struct irq_chip' has no member named 'irq_release_resources'
/home/atull/repos/linux-socfpga/drivers/gpio/gpio-dwapb.c:255:36:
error: 'dwapb_irq_relres' undeclared (first use in this function)
Build failed...

Alan Tull
aka
delicious quinoa


> +               ct->regs.ack = GPIO_PORTA_EOI;
> +               ct->regs.mask = GPIO_INTMASK;
> +
> +               if (i == 0) {
> +                       ct->type = IRQ_TYPE_LEVEL_MASK;
> +                       ct->handler = handle_level_irq;
> +               } else {
> +                       ct->type = IRQ_TYPE_EDGE_BOTH;
> +                       ct->handler = handle_edge_irq;
> +               }
> +       }
>
>         irq_set_chained_handler(irq, dwapb_irq_handler);
>         irq_set_handler_data(irq, gpio);
> --
> 1.9.1
>
