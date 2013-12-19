Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3LSIZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:25:00 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:33712 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:24:58 -0500
Date: Thu, 19 Dec 2013 17:24:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: tglx@linutronix.de, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH] irq-renesas-irqc: simplify irq_set_type() method
Message-ID: <20131219082453.GA12239@verge.net.au>
References: <201312140309.31407.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312140309.31407.sergei.shtylyov@cogentembedded.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 03:09:31AM +0300, Sergei Shtylyov wrote:
> Value 0 of the sense  selection field of CONFIG_n register means "disable event
> detection" and serves in irqc_sense[] for marking the invalid values of the IRQ
> type (by just omitting initializers). There is no need for INTC_IRQ_SENSE_VALID
> and hence INTC_IRQ_SENSE() as all field values matching to the  valid IRQ types
> are non-zero anyway.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Magnus, could you review this?

> 
> ---
> The patch is against the 'irq/core' branch of the 'tip.git' repo.
> 
>  drivers/irqchip/irq-renesas-irqc.c |   17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> Index: renesas/drivers/irqchip/irq-renesas-irqc.c
> ===================================================================
> --- renesas.orig/drivers/irqchip/irq-renesas-irqc.c
> +++ renesas/drivers/irqchip/irq-renesas-irqc.c
> @@ -81,15 +81,12 @@ static void irqc_irq_disable(struct irq_
>  	iowrite32(BIT(hw_irq), p->cpu_int_base + IRQC_EN_STS);
>  }
>  
> -#define INTC_IRQ_SENSE_VALID 0x10
> -#define INTC_IRQ_SENSE(x) (x + INTC_IRQ_SENSE_VALID)
> -
>  static unsigned char irqc_sense[IRQ_TYPE_SENSE_MASK + 1] = {
> -	[IRQ_TYPE_LEVEL_LOW] = INTC_IRQ_SENSE(0x01),
> -	[IRQ_TYPE_LEVEL_HIGH] = INTC_IRQ_SENSE(0x02),
> -	[IRQ_TYPE_EDGE_FALLING] = INTC_IRQ_SENSE(0x04), /* Synchronous */
> -	[IRQ_TYPE_EDGE_RISING] = INTC_IRQ_SENSE(0x08), /* Synchronous */
> -	[IRQ_TYPE_EDGE_BOTH] = INTC_IRQ_SENSE(0x0c),  /* Synchronous */
> +	[IRQ_TYPE_LEVEL_LOW]	= 0x01,
> +	[IRQ_TYPE_LEVEL_HIGH]	= 0x02,
> +	[IRQ_TYPE_EDGE_FALLING]	= 0x04,	/* Synchronous */
> +	[IRQ_TYPE_EDGE_RISING]	= 0x08,	/* Synchronous */
> +	[IRQ_TYPE_EDGE_BOTH]	= 0x0c,	/* Synchronous */
>  };
>  
>  static int irqc_irq_set_type(struct irq_data *d, unsigned int type)
> @@ -101,12 +98,12 @@ static int irqc_irq_set_type(struct irq_
>  
>  	irqc_dbg(&p->irq[hw_irq], "sense");
>  
> -	if (!(value & INTC_IRQ_SENSE_VALID))
> +	if (!value)
>  		return -EINVAL;
>  
>  	tmp = ioread32(p->iomem + IRQC_CONFIG(hw_irq));
>  	tmp &= ~0x3f;
> -	tmp |= value ^ INTC_IRQ_SENSE_VALID;
> +	tmp |= value;
>  	iowrite32(tmp, p->iomem + IRQC_CONFIG(hw_irq));
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
