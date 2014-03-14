Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaCNLfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:35:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:57417 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaCNLfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:35:45 -0400
Date: Fri, 14 Mar 2014 12:35:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans de Goede <hdegoede@redhat.com>
cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] irqchip: sun4i: Don't mask + unmask for the non
 oneshot case
In-Reply-To: <1394740202-1952-2-git-send-email-hdegoede@redhat.com>
Message-ID: <alpine.DEB.2.02.1403141228290.18573@ionos.tec.linutronix.de>
References: <1394740202-1952-1-git-send-email-hdegoede@redhat.com> <1394740202-1952-2-git-send-email-hdegoede@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Hans de Goede wrote:

> Since sun4i and sun5i are single core SOCs there is no need to mask non
> oneshot IRQs, to achieve this we use handle_fasteoi_irq with a dummy eoi.

This is slightly wrong :)

Even on a SMP system there is no need to mask the interrupt when the
controller works like that sunxi one. If the controller is not broken
beyond repair then it does not deliver the same interrupt to a
different cpu. Such a thing would always deliver it to all cores and
those would race to grab the spinlock and mask it. I've seen such
horror, but don't ask how that performs.

The reason why you can spare the mask/unmask dance is that the
controller does not require any action and clears the interrupt when
the level goes back to inactive. That happens when the device handler
acks it at the device level.

Now there might be the case when the device reactivates the interrupt
before the RETI. But that does not matter as we run the primary
interrupt handlers with interrupts disabled.

Thanks,

	tglx
 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/irqchip/irq-sun4i.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> index a0ed1ea..0a71990 100644
> --- a/drivers/irqchip/irq-sun4i.c
> +++ b/drivers/irqchip/irq-sun4i.c
> @@ -74,8 +74,17 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>  	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
>  }
>  
> +/*
> + * Since sun4i and sun5i are single core SOCs there is no need to mask non
> + * oneshot IRQs, to achieve this we use handle_fasteoi_irq with a dummy eoi.
> + */
> +static void sun4i_irq_dummy_eoi(struct irq_data *irqd)
> +{
> +}
> +
>  static struct irq_chip sun4i_irq_chip = {
>  	.name		= "sun4i_irq",
> +	.irq_eoi	= sun4i_irq_dummy_eoi,
>  	.irq_mask	= sun4i_irq_mask,
>  	.irq_unmask	= sun4i_irq_unmask,
>  };
> @@ -97,7 +106,7 @@ static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
>  					 handle_fasteoi_irq);
>  	else
>  		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> -					 handle_level_irq);
> +					 handle_fasteoi_irq);
>  
>  	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
>  
> -- 
> 1.9.0
> 
> 
