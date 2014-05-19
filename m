Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaESJNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:13:40 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57014 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752794AbaESJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:13:39 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@apm.com" <patches@apm.com>, jason@lakedaemon.net
Subject: Re: [PATCH 1/2] irqchip: gic: replace hex numbers with defines.
In-Reply-To: <1400278813-3048-2-git-send-email-fkan@apm.com> (Feng Kan's
	message of "Fri, 16 May 2014 23:20:12 +0100")
Organization: ARM Ltd
References: <1400278813-3048-1-git-send-email-fkan@apm.com>
	<1400278813-3048-2-git-send-email-fkan@apm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 19 May 2014 10:13:36 +0100
Message-ID: <87ha4mnnb3.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Jason Cooper to the mix, as he's ramping up on the GIC
stuff... ;-)]

On Fri, May 16 2014 at 11:20:12 pm BST, Feng Kan <fkan@apm.com> wrote:
> This is to cleanup some hex numbers used in the code and replace
> then with defines to make the code cleaner.
>
> Signed-off-by: Feng Kan <fkan@apm.com>
> Reviewed-by: Anup Patel <apatel@apm.com>
> ---
>  drivers/irqchip/irq-gic.c | 57 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 38 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 57d165e..e6698a2 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -48,6 +48,20 @@
>  
>  #include "irqchip.h"
>  
> +#define GIC_DIST_ENABLE		0x1
> +#define GIC_DIST_DISABLE	0x0
> +#define GIC_CPU_ENABLE		0x1
> +#define GIC_CPU_DISABLE		0x0
> +#define GIC_INT_ID_MASK		0x3ff
> +#define GIC_INT_DEF_PRI		0xa0
> +#define GIC_INT_DEF_PRI_MASK	((GIC_INT_DEF_PRI << 24) |\
> +				(GIC_INT_DEF_PRI << 16) |\
> +				(GIC_INT_DEF_PRI << 8) | GIC_INT_DEF_PRI)

This is not a mask, but the interrupt priority for 4 interrupts.

> +#define GIC_INT_PRI_THRESHOLD	0xf0
> +#define GIC_INT_DISABLE_MASK	0xffffffff

This is not a mask to disable interrupt, but rather a mask for for 32
interrupts addressed by a single register. The action (enable or
disable) depends on the register you're writting to.

> +#define GIC_INT_SGI_MASK	0x0000ffff
> +#define GIC_INT_LVL_TRIGGER	0x0
> +
>  union gic_base {
>  	void __iomem *common_base;
>  	void __percpu * __iomem *percpu_base;
> @@ -291,7 +305,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  
>  	do {
>  		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
> -		irqnr = irqstat & ~0x1c00;
> +		irqnr = irqstat & GIC_INT_ID_MASK;
>  
>  		if (likely(irqnr > 15 && irqnr < 1021)) {
>  			irqnr = irq_find_mapping(gic->domain, irqnr);
> @@ -322,7 +336,7 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>  	status = readl_relaxed(gic_data_cpu_base(chip_data) + GIC_CPU_INTACK);
>  	raw_spin_unlock(&irq_controller_lock);
>  
> -	gic_irq = (status & 0x3ff);
> +	gic_irq = (status & GIC_INT_ID_MASK);
>  	if (gic_irq == 1023)

You could define this one as GIC_INT_SPURIOUS.

>  		goto out;
>  
> @@ -384,13 +398,14 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>  	unsigned int gic_irqs = gic->gic_irqs;
>  	void __iomem *base = gic_data_dist_base(gic);
>  
> -	writel_relaxed(0, base + GIC_DIST_CTRL);
> +	writel_relaxed(GIC_DIST_DISABLE, base + GIC_DIST_CTRL);
>  
>  	/*
>  	 * Set all global interrupts to be level triggered, active low.
>  	 */
>  	for (i = 32; i < gic_irqs; i += 16)
> -		writel_relaxed(0, base + GIC_DIST_CONFIG + i * 4 / 16);
> +		writel_relaxed(GIC_INT_LVL_TRIGGER,
> +				base + GIC_DIST_CONFIG + i * 4 / 16);
>  
>  	/*
>  	 * Set all global interrupts to this CPU only.
> @@ -405,16 +420,18 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>  	 * Set priority on all global interrupts.
>  	 */
>  	for (i = 32; i < gic_irqs; i += 4)
> -		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i * 4 / 4);
> +		writel_relaxed(GIC_INT_DEF_PRI_MASK,
> +					base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	/*
>  	 * Disable all interrupts.  Leave the PPI and SGIs alone
>  	 * as these enables are banked registers.
>  	 */
>  	for (i = 32; i < gic_irqs; i += 32)
> -		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
> +		writel_relaxed(GIC_INT_DISABLE_MASK,
> +				base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
>  
> -	writel_relaxed(1, base + GIC_DIST_CTRL);
> +	writel_relaxed(GIC_DIST_ENABLE, base + GIC_DIST_CTRL);
>  }
>  
>  static void gic_cpu_init(struct gic_chip_data *gic)
> @@ -443,23 +460,24 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  	 * Deal with the banked PPI and SGI interrupts - disable all
>  	 * PPI interrupts, ensure all SGI interrupts are enabled.
>  	 */
> -	writel_relaxed(0xffff0000, dist_base + GIC_DIST_ENABLE_CLEAR);
> -	writel_relaxed(0x0000ffff, dist_base + GIC_DIST_ENABLE_SET);
> +	writel_relaxed(~GIC_INT_SGI_MASK, dist_base + GIC_DIST_ENABLE_CLEAR);

Not quite. 0xffff0000 descibe the PPIs. It is not the opposite of the
set of SGIs.

> +	writel_relaxed(GIC_INT_SGI_MASK, dist_base + GIC_DIST_ENABLE_SET);
>
>  	/*
>  	 * Set priority on PPI and SGI interrupts
>  	 */
>  	for (i = 0; i < 32; i += 4)
> -		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
> +		writel_relaxed(GIC_INT_DEF_PRI_MASK,
> +				dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
> -	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +	writel_relaxed(GIC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
> +	writel_relaxed(GIC_CPU_ENABLE, base + GIC_CPU_CTRL);
>  }
>  
>  void gic_cpu_if_down(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
> +	writel_relaxed(GIC_CPU_DISABLE, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -519,14 +537,14 @@ static void gic_dist_restore(unsigned int gic_nr)
>  	if (!dist_base)
>  		return;
>  
> -	writel_relaxed(0, dist_base + GIC_DIST_CTRL);
> +	writel_relaxed(GIC_DIST_DISABLE, dist_base + GIC_DIST_CTRL);
>  
>  	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
>  		writel_relaxed(gic_data[gic_nr].saved_spi_conf[i],
>  			dist_base + GIC_DIST_CONFIG + i * 4);
>  
>  	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
> -		writel_relaxed(0xa0a0a0a0,
> +		writel_relaxed(GIC_INT_DEF_PRI_MASK,
>  			dist_base + GIC_DIST_PRI + i * 4);
>  
>  	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
> @@ -537,7 +555,7 @@ static void gic_dist_restore(unsigned int gic_nr)
>  		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
>  			dist_base + GIC_DIST_ENABLE_SET + i * 4);
>  
> -	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
> +	writel_relaxed(GIC_DIST_ENABLE, dist_base + GIC_DIST_CTRL);
>  }
>  
>  static void gic_cpu_save(unsigned int gic_nr)
> @@ -591,10 +609,11 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
>  
>  	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
> -		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
> +		writel_relaxed(GIC_INT_DEF_PRI_MASK,
> +					dist_base + GIC_DIST_PRI + i * 4);
>  
> -	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	writel_relaxed(GIC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
> +	writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
