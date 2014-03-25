Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaCYVgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:36:32 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54969 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaCYVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:36:31 -0400
Message-ID: <5331F6D5.7070809@gmail.com>
Date: Tue, 25 Mar 2014 22:36:21 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, atull@altera.com
CC: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        delicious.quinoa@gmail.com
Subject: Re: [PATCH 6/7] gpio: dwapb: use a second irq chip
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de> <1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2014 05:16 PM, Sebastian Andrzej Siewior wrote:
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
>  		break;
>  	}
>  
> +	irq_setup_alt_chip(d, type);
> +
>  	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
>  	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
>  	irq_gc_unlock(igc);
> @@ -207,7 +209,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>  	struct irq_chip_generic	*irq_gc;
>  	unsigned int hwirq, ngpio = gc->ngpio;
>  	struct irq_chip_type *ct;
> -	int err, irq;
> +	int err, irq, i;
>  
>  	irq = irq_of_parse_and_map(node, 0);
>  	if (!irq) {
> @@ -221,7 +223,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>  	if (!gpio->domain)
>  		return;
>  
> -	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 1,
> +	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 2,
>  					     "gpio-dwapb", handle_level_irq,
>  					     IRQ_NOREQUEST, 0,
>  					     IRQ_GC_INIT_NESTED_LOCK);
> @@ -242,17 +244,28 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>  	irq_gc->reg_base = gpio->regs;
>  	irq_gc->private = gpio;
>  
> -	ct = irq_gc->chip_types;
> -	ct->chip.irq_ack = irq_gc_ack_set_bit;
> -	ct->chip.irq_mask = irq_gc_mask_set_bit;
> -	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> -	ct->chip.irq_set_type = dwapb_irq_set_type;
> -	ct->chip.irq_enable = dwapb_irq_enable;
> -	ct->chip.irq_disable = dwapb_irq_disable;
> -	ct->chip.irq_request_resources = dwapb_irq_reqres;
> -	ct->chip.irq_release_resources = dwapb_irq_relres;
> -	ct->regs.ack = GPIO_PORTA_EOI;
> -	ct->regs.mask = GPIO_INTMASK;
> +	for (i = 0; i < 2; i++) {
> +
> +		ct = &irq_gc->chip_types[i];
> +		ct->chip.irq_ack = irq_gc_ack_set_bit;
> +		ct->chip.irq_mask = irq_gc_mask_set_bit;
> +		ct->chip.irq_unmask = irq_gc_mask_clr_bit;
> +		ct->chip.irq_set_type = dwapb_irq_set_type;
> +		ct->chip.irq_enable = dwapb_irq_enable;
> +		ct->chip.irq_disable = dwapb_irq_disable;
> +		ct->chip.irq_request_resources = dwapb_irq_reqres;
> +		ct->chip.irq_release_resources = dwapb_irq_relres;
> +		ct->regs.ack = GPIO_PORTA_EOI;
> +		ct->regs.mask = GPIO_INTMASK;
> +
> +		if (i == 0) {
> +			ct->type = IRQ_TYPE_LEVEL_MASK;
> +			ct->handler = handle_level_irq;
> +		} else {
> +			ct->type = IRQ_TYPE_EDGE_BOTH;
> +			ct->handler = handle_edge_irq;
> +		}

Sebastian,

IMHO the loop looks strange, especially with the (i == 0) check.

How about unrolling it again and assign both chip_types independently?

Sebastian

> +	}
>  
>  	irq_set_chained_handler(irq, dwapb_irq_handler);
>  	irq_set_handler_data(irq, gpio);
> 

