Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbaGYMm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:42:56 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:59226 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaGYMmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:42:54 -0400
Message-ID: <53D250B1.1080203@linaro.org>
Date: Fri, 25 Jul 2014 14:42:25 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:28 AM, Marc Zyngier wrote:
> So far, GICv2 has been used in with EOImode == 0. The effect of this
> mode is to perform the priority drop and the deactivation of the
> interrupt at the same time.
> 
> While this works perfectly for Linux (we only have a single priority),
> it causes issues when an interrupt is forwarded to a guest, and when
> we want the guest to perform the EOI itself.
> 
> For this case, the GIC architecture provides EOImode == 1, where:
> - A write to the EOI register drops the priority of the interrupt and leaves
> it active. Other interrupts at the same priority level can now be taken,
> but the active interrupt cannot be taken again
> - A write to the DIR marks the interrupt as inactive, meaning it can
> now be taken again.
> 
> We only enable this feature when booted in HYP mode. Also, as most device
> trees are broken (they report the CPU interface size to be 4kB, while
> the GICv2 CPU interface size is 8kB), output a warning if we're booted
> in HYP mode, and disable the feature.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c       | 61 +++++++++++++++++++++++++++++++++++++----
>  include/linux/irqchip/arm-gic.h |  4 +++
>  2 files changed, 59 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 508b815..9295bf2 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -45,6 +45,7 @@
>  #include <asm/irq.h>
>  #include <asm/exception.h>
>  #include <asm/smp_plat.h>
> +#include <asm/virt.h>
>  
>  #include "irq-gic-common.h"
>  #include "irqchip.h"
> @@ -94,6 +95,10 @@ struct irq_chip gic_arch_extn = {
>  	.irq_set_wake	= NULL,
>  };
>  
> +static struct irq_chip *gic_chip;
> +
> +static bool supports_deactivate = false;
> +
>  #ifndef MAX_GIC_NR
>  #define MAX_GIC_NR	1
>  #endif
> @@ -185,6 +190,12 @@ static void gic_eoi_irq(struct irq_data *d)
>  	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>  }
>  
> +static void gic_eoi_dir_irq(struct irq_data *d)
> +{
> +	gic_eoi_irq(d);
> +	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
> +}
> +
>  static int gic_set_type(struct irq_data *d, unsigned int type)
>  {
>  	void __iomem *base = gic_dist_base(d);
> @@ -277,6 +288,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  		}
>  		if (irqnr < 16) {
>  			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
> +			writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
Hi Marc,

a minor comment: archi spec says writing to DIR without EOIMode set is
"unpredictable" (4.4.15). however in practice it seems to work on my
test env.

Best Regards

Eric
>  #ifdef CONFIG_SMP
>  			handle_IPI(irqnr, regs);
>  #endif
> @@ -313,7 +325,7 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>  	chained_irq_exit(chip, desc);
>  }
>  
> -static struct irq_chip gic_chip = {
> +static struct irq_chip gicv1_chip = {
>  	.name			= "GIC",
>  	.irq_mask		= gic_mask_irq,
>  	.irq_unmask		= gic_unmask_irq,
> @@ -326,6 +338,19 @@ static struct irq_chip gic_chip = {
>  	.irq_set_wake		= gic_set_wake,
>  };
>  
> +static struct irq_chip gicv2_chip = {
> +	.name			= "GIC",
> +	.irq_mask		= gic_mask_irq,
> +	.irq_unmask		= gic_unmask_irq,
> +	.irq_eoi		= gic_eoi_dir_irq,
> +	.irq_set_type		= gic_set_type,
> +	.irq_retrigger		= gic_retrigger,
> +#ifdef CONFIG_SMP
> +	.irq_set_affinity	= gic_set_affinity,
> +#endif
> +	.irq_set_wake		= gic_set_wake,
> +};
> +
>  void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>  {
>  	if (gic_nr >= MAX_GIC_NR)
> @@ -377,6 +402,16 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>  	writel_relaxed(1, base + GIC_DIST_CTRL);
>  }
>  
> +static void gic_cpu_if_up(void)
> +{
> +	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> +	u32 val = 0;
> +
> +	if (supports_deactivate)
> +		val = GIC_CPU_CTRL_EOImodeNS;
> +	writel_relaxed(val | 1, cpu_base + GIC_CPU_CTRL);
> +}
> +
>  static void gic_cpu_init(struct gic_chip_data *gic)
>  {
>  	void __iomem *dist_base = gic_data_dist_base(gic);
> @@ -402,7 +437,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  	gic_cpu_config(dist_base, NULL);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +	gic_cpu_if_up();
>  }
>  
>  void gic_cpu_if_down(void)
> @@ -543,7 +578,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	gic_cpu_if_up();
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
> @@ -770,11 +805,11 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  {
>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_set_chip_and_handler(irq, &gic_chip,
> +		irq_set_chip_and_handler(irq, gic_chip,
>  					 handle_percpu_devid_irq);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	} else {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> +		irq_set_chip_and_handler(irq, gic_chip,
>  					 handle_fasteoi_irq);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  
> @@ -951,6 +986,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  
>  	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
>  
> +	if (!supports_deactivate)
> +		gic_chip = &gicv1_chip;
> +	else
> +		gic_chip = &gicv2_chip;
> +
>  	if (of_property_read_u32(node, "arm,routable-irqs",
>  				 &nr_routable_irqs)) {
>  		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
> @@ -980,7 +1020,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  		set_handle_irq(gic_handle_irq);
>  	}
>  
> -	gic_chip.flags |= gic_arch_extn.flags;
> +	gic_chip->flags |= gic_arch_extn.flags;
>  	gic_dist_init(gic);
>  	gic_cpu_init(gic);
>  	gic_pm_init(gic);
> @@ -994,6 +1034,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	void __iomem *cpu_base;
>  	void __iomem *dist_base;
> +	struct resource cpu_res;
>  	u32 percpu_offset;
>  	int irq;
>  
> @@ -1006,6 +1047,14 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  	cpu_base = of_iomap(node, 1);
>  	WARN(!cpu_base, "unable to map gic cpu registers\n");
>  
> +	of_address_to_resource(node, 1, &cpu_res);
> +	if (is_hyp_mode_available()) {
> +		if (resource_size(&cpu_res) >= SZ_8K)
> +			supports_deactivate = true;
> +		else
> +			pr_warn("GIC: CPU interface size is %x, DT is probably wrong\n", (int)resource_size(&cpu_res));
> +	}
> +
>  	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>  		percpu_offset = 0;
>  
> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> index 45e2d8c..ffe3911 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -21,6 +21,10 @@
>  #define GIC_CPU_ACTIVEPRIO		0xd0
>  #define GIC_CPU_IDENT			0xfc
>  
> +#define GIC_CPU_DEACTIVATE		0x1000
> +
> +#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
> +
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  
>  #define GIC_DIST_CTRL			0x000
> 

