Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaD1TjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:39:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:42411 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaD1TjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:39:04 -0400
Date: Mon, 28 Apr 2014 21:39:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/3] irqchip: orion: reverse irq handling
 priority
In-Reply-To: <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.DEB.2.02.1404282137240.6261@ionos.tec.linutronix.de>
References: <1398540855-27367-1-git-send-email-sebastian.hesselbarth@gmail.com> <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2014, Sebastian Hesselbarth wrote:

> Non-DT irq handlers were working through irq causes from most-significant
> to least-significant bit, while DT irqchip driver does it the other way
> round. This revealed some more HW issues on Kirkwood peripheral IP, where
> spurious sdio irqs can happen although IP's irq enable registers are all
> zero. Although, not directly related with the described issue, reverse
> irq bit handling back to original order by replacing ffs() with fls().

So why are we reverting to the original order?

The explanation above is just confusing.

Thanks,

	tglx
 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/irqchip/irq-orion.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
> index e25f246cd2fb..34d18b48bb78 100644
> --- a/drivers/irqchip/irq-orion.c
> +++ b/drivers/irqchip/irq-orion.c
> @@ -42,7 +42,7 @@ __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
>  		u32 stat = readl_relaxed(gc->reg_base + ORION_IRQ_CAUSE) &
>  			gc->mask_cache;
>  		while (stat) {
> -			u32 hwirq = ffs(stat) - 1;
> +			u32 hwirq = __fls(stat);
>  			u32 irq = irq_find_mapping(orion_irq_domain,
>  						   gc->irq_base + hwirq);
>  			handle_IRQ(irq, regs);
> @@ -117,7 +117,7 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
>  		   gc->mask_cache;
>  
>  	while (stat) {
> -		u32 hwirq = ffs(stat) - 1;
> +		u32 hwirq = __fls(stat);
>  
>  		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
>  		stat &= ~(1 << hwirq);
> -- 
> 1.9.1
> 
> 
