Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaI3MeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:34:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50902 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3MeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:34:04 -0400
Message-ID: <542AA336.6070206@gmail.com>
Date: Tue, 30 Sep 2014 14:33:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
To: Jisheng Zhang <jszhang@marvell.com>, tglx@linutronix.de,
        jason@lakedaemon.net
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] irqchip: dw-apb-ictl: add PM support
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-4-git-send-email-jszhang@marvell.com>
In-Reply-To: <1411454100-6814-4-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:35 AM, Jisheng Zhang wrote:
> This patch adds in support for S2R for dw-apb-ictl irqchip driver.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>   drivers/irqchip/irq-dw-apb-ictl.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
> index c136b67..53bb732 100644
> --- a/drivers/irqchip/irq-dw-apb-ictl.c
> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> @@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
>   	chained_irq_exit(chip, desc);
>   }
>
> +#ifdef CONFIG_PM
> +static void dw_apb_ictl_resume(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct irq_chip_type *ct = irq_data_get_chip_type(d);
> +
> +	irq_gc_lock(gc);
> +	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
> +	writel_relaxed(*ct->mask_cache, gc->reg_base + ct->regs.mask);
> +	irq_gc_unlock(gc);
> +}

I agree with the overall change, but may this also be suited for a
generic irq_chip helper instead of being a driver specific one?

Maybe Thomas or Jason can comment on this.

Also, now that you are using writel_relaxed, I understand that both
writes above can happen in any order? Are there any implication we
have to consider, i.e. do we require any of the registers above to
be written first?

Sebastian

> +#else
> +#define dw_apb_ictl_resume	NULL
> +#endif /* CONFIG_PM */
> +
>   static int __init dw_apb_ictl_init(struct device_node *np,
>   				   struct device_node *parent)
>   {
> @@ -127,13 +142,17 @@ static int __init dw_apb_ictl_init(struct device_node *np,
>   	gc->reg_base = iobase;
>
>   	gc->chip_types[0].regs.mask = APB_INT_MASK_L;
> +	gc->chip_types[0].regs.enable = APB_INT_ENABLE_L;
>   	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
>   	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
> +	gc->chip_types[0].chip.irq_resume = dw_apb_ictl_resume;
>
>   	if (nrirqs > 32) {
>   		gc->chip_types[1].regs.mask = APB_INT_MASK_H;
> +		gc->chip_types[1].regs.enable = APB_INT_ENABLE_H;
>   		gc->chip_types[1].chip.irq_mask = irq_gc_mask_set_bit;
>   		gc->chip_types[1].chip.irq_unmask = irq_gc_mask_clr_bit;
> +		gc->chip_types[1].chip.irq_resume = dw_apb_ictl_resume;
>   	}
>
>   	irq_set_handler_data(irq, gc);
>
