Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbaCTUUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:20:44 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33453 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504AbaCTUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
	<1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
Date: Thu, 20 Mar 2014 15:20:41 -0500
Message-ID: <CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
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

On Thu, Mar 20, 2014 at 2:55 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> After the irq chip got registered the driver creates a mapping for every
> gpio line. This mapping be useless if the gpio in question never is
> beeing used a irq line. The mapping should be created by the core on
> request.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/gpio/gpio-dwapb.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 4d25a06b..0db0b94 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -211,7 +211,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         struct gpio_chip *gc = &port->bgc.gc;
>         struct device_node *node =  gc->of_node;
>         struct irq_chip_generic *irq_gc;
> -       unsigned int hwirq, ngpio = gc->ngpio;
> +       unsigned int ngpio = gc->ngpio;
>         struct irq_chip_type *ct;
>         int err, irq;
>
> @@ -263,9 +263,6 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         irq_set_chained_handler(irq, dwapb_irq_handler);
>         irq_set_handler_data(irq, gpio);
>
> -       for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
> -               irq_create_mapping(gpio->domain, hwirq);
> -
>         port->bgc.gc.to_irq = dwapb_gpio_to_irq;
>  }


Hi Sebastian,

I think this functionality has changed at some point or maybe
everybody copied the same bad code over and over.  I see a lot of
legacy gpio drivers calling irq_create_mapping in their to_irq()
functions.  Linus Walleij asked me to create the mappings at probe
time.  Please see https://lkml.org/lkml/2014/2/10/154 and the
subsequent discussion in https://lkml.org/lkml/2014/2/24/232

Alan Tull
aka
delicious quinoa
