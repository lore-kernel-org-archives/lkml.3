Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaD1KIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:08:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:35636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaD1KIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:08:41 -0400
Date: Mon, 28 Apr 2014 12:08:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Axel Lin <axel.lin@ingics.com>
cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irqchip: vt8500: Switch to a simple write clear for
 Interrupt Status Register
In-Reply-To: <1398656117.19333.1.camel@phoenix>
Message-ID: <alpine.DEB.2.02.1404281207510.6261@ionos.tec.linutronix.de>
References: <1398656117.19333.1.camel@phoenix>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Axel Lin wrote:

> According to the datasheet, the attribute of Interrupt Status Register is RW0S,
> which means:
> 	Software can read the register.
> 	Software can also "write 1 to clear". "write 0" has no effect.
> 
> So the read/modify/write cycle is no necessary, switch to a simple write clear
> instead.

Again, what's the point of this?

There is still nothing which masks the interrupt at the controller
level which is the purpose of the irq_mask() callback.

Thanks,

	tglx

 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> v2: Update commit log, this is a code simplification rather than bug fix.
>  drivers/irqchip/irq-vt8500.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
> index eb6e91e..a0085bc 100644
> --- a/drivers/irqchip/irq-vt8500.c
> +++ b/drivers/irqchip/irq-vt8500.c
> @@ -87,14 +87,10 @@ static void vt8500_irq_mask(struct irq_data *d)
>  	void __iomem *base = priv->base;
>  	void __iomem *stat_reg = base + VT8500_ICIS + (d->hwirq < 32 ? 0 : 4);
>  	u8 edge, dctr;
> -	u32 status;
>  
>  	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
>  	if (edge) {
> -		status = readl(stat_reg);
> -
> -		status |= (1 << (d->hwirq & 0x1f));
> -		writel(status, stat_reg);
> +		writel(BIT(d->hwirq & 0x1f), stat_reg);
>  	} else {
>  		dctr = readb(base + VT8500_ICDC + d->hwirq);
>  		dctr &= ~VT8500_INT_ENABLE;
> -- 
> 1.8.3.2
> 
> 
> 
> 
