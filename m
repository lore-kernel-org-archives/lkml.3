Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaHFLaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:30:23 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:37810 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaHFLaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:30:22 -0400
Date: Wed, 6 Aug 2014 13:30:17 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org
Subject: Re: [RFC PATCH 4/9] irqchip: GIC: add support for forwarded
 interrupts
Message-ID: <20140806113017.GA14205@cbox>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
 <1403688530-23273-5-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403688530-23273-5-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:28:45AM +0100, Marc Zyngier wrote:
> Now that we've switched to EOImode == 1, prevent a forwarded interrupt
> from being deactivated after its priority has been dropped.
> 
> Also add support for the interrupt state to be saved/restored.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c | 48 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 9295bf2..bde1637 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -157,12 +157,22 @@ static inline unsigned int gic_irq(struct irq_data *d)
>  /*
>   * Routines to acknowledge, disable and enable interrupts
>   */
> -static void gic_mask_irq(struct irq_data *d)
> +static void gic_poke_irq(struct irq_data *d, u32 offset)
> +{
> +	u32 mask = 1 << (gic_irq(d) % 32);
> +	writel_relaxed(mask, gic_dist_base(d) + offset + (gic_irq(d) / 32) * 4);
> +}
> +
> +static int gic_peek_irq(struct irq_data *d, u32 offset)
>  {
>  	u32 mask = 1 << (gic_irq(d) % 32);
> +	return !!(readl_relaxed(gic_dist_base(d) + offset + (gic_irq(d) / 32) * 4) & mask);
> +}
>  
> +static void gic_mask_irq(struct irq_data *d)
> +{
>  	raw_spin_lock(&irq_controller_lock);
> -	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_CLEAR + (gic_irq(d) / 32) * 4);
> +	gic_poke_irq(d, GIC_DIST_ENABLE_CLEAR);
>  	if (gic_arch_extn.irq_mask)
>  		gic_arch_extn.irq_mask(d);
>  	raw_spin_unlock(&irq_controller_lock);
> @@ -170,12 +180,10 @@ static void gic_mask_irq(struct irq_data *d)
>  
>  static void gic_unmask_irq(struct irq_data *d)
>  {
> -	u32 mask = 1 << (gic_irq(d) % 32);
> -
>  	raw_spin_lock(&irq_controller_lock);
>  	if (gic_arch_extn.irq_unmask)
>  		gic_arch_extn.irq_unmask(d);
> -	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_SET + (gic_irq(d) / 32) * 4);
> +	gic_poke_irq(d, GIC_DIST_ENABLE_SET);
>  	raw_spin_unlock(&irq_controller_lock);
>  }
>  
> @@ -193,7 +201,33 @@ static void gic_eoi_irq(struct irq_data *d)
>  static void gic_eoi_dir_irq(struct irq_data *d)
>  {
>  	gic_eoi_irq(d);
> -	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
> +	if (!irqd_irq_forwarded(d))
> +		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
> +}
> +
> +static void gic_irq_set_fwd_state(struct irq_data *d, u32 val, u32 mask)
> +{
> +	if (mask & IRQ_FWD_STATE_PENDING)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_PENDING) ? GIC_DIST_ENABLE_SET : GIC_DIST_ENABLE_CLEAR);

Why are you masking/unmasking the interrupt on the pending bit?  Did you
mean GIC_DIST_PENDING_{SET,CLEAR} ?

> +	if (mask & IRQ_FWD_STATE_ACTIVE)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_ACTIVE) ? GIC_DIST_ACTIVE_SET : GIC_DIST_ACTIVE_CLEAR);
> +	if (mask & IRQ_FWD_STATE_MASKED)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_MASKED) ? GIC_DIST_ENABLE_CLEAR : GIC_DIST_ENABLE_SET);
> +
> +}
> +
> +static u32 gic_irq_get_fwd_state(struct irq_data *d, u32 mask)
> +{
> +	u32 val = 0;
> +
> +	if (mask & IRQ_FWD_STATE_PENDING && gic_peek_irq(d, GIC_DIST_ENABLE_SET))
> +		val |= IRQ_FWD_STATE_PENDING;

same

> +	if (mask & IRQ_FWD_STATE_ACTIVE && gic_peek_irq(d, GIC_DIST_ACTIVE_SET))
> +		val |= IRQ_FWD_STATE_ACTIVE;
> +	if (mask & IRQ_FWD_STATE_MASKED && !gic_peek_irq(d, GIC_DIST_ENABLE_SET))
> +		val |= IRQ_FWD_STATE_MASKED;
> +
> +	return val;
>  }
>  
>  static int gic_set_type(struct irq_data *d, unsigned int type)
> @@ -349,6 +383,8 @@ static struct irq_chip gicv2_chip = {
>  	.irq_set_affinity	= gic_set_affinity,
>  #endif
>  	.irq_set_wake		= gic_set_wake,
> +	.irq_get_fwd_state	= gic_irq_get_fwd_state,
> +	.irq_set_fwd_state	= gic_irq_set_fwd_state,
>  };
>  
>  void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
> -- 
> 1.8.3.4
> 
