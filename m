Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802AbaJ2Qzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:55:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50764 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaJ2Qzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:55:46 -0400
Message-ID: <54511BF6.9060908@gmail.com>
Date: Wed, 29 Oct 2014 09:55:18 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 09/11] irqchip: bcm7120-l2: Use gc->mask_cache to simplify
 suspend/resume functions
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-9-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-9-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> The cached value already incorporates irq_fwd_mask, and was saved the
> last time an IRQ was enabled/disabled.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/irqchip/irq-bcm7120-l2.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
> index e9331f8..c76c9ad 100644
> --- a/drivers/irqchip/irq-bcm7120-l2.c
> +++ b/drivers/irqchip/irq-bcm7120-l2.c
> @@ -37,7 +37,6 @@ struct bcm7120_l2_intc_data {
>  	bool can_wake;
>  	u32 irq_fwd_mask;
>  	u32 irq_map_mask;
> -	u32 saved_mask;
>  };
>  
>  static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
> @@ -62,14 +61,11 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>  	struct bcm7120_l2_intc_data *b = gc->private;
> -	u32 reg;
>  
>  	irq_gc_lock(gc);
> -	/* Save the current mask and the interrupt forward mask */
> -	b->saved_mask = irq_reg_readl(b->base + IRQEN) | b->irq_fwd_mask;
>  	if (b->can_wake) {
> -		reg = b->saved_mask | gc->wake_active;
> -		irq_reg_writel(reg, b->base + IRQEN);
> +		irq_reg_writel(gc->mask_cache | gc->wake_active,
> +			       b->base + IRQEN);
>  	}
>  	irq_gc_unlock(gc);
>  }
> @@ -77,11 +73,10 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
>  static void bcm7120_l2_intc_resume(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	struct bcm7120_l2_intc_data *b = gc->private;
>  
>  	/* Restore the saved mask */
>  	irq_gc_lock(gc);
> -	irq_reg_writel(b->saved_mask, b->base + IRQEN);
> +	irq_reg_writel(gc->mask_cache, b->base + IRQEN);
>  	irq_gc_unlock(gc);
>  }
>  
> 

