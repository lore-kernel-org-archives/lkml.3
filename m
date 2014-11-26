Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaKZPJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:09:39 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:33894
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbaKZPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:09:38 -0500
From: Tim Sander <tim@krieglstein.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc3 v9 3/5] irqchip: gic: Introduce plumbing for IPI FIQ
Date: Wed, 26 Nov 2014 16:09:35 +0100
Message-ID: <1678979.dHizJmHVtD@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416936401-5147-4-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-4-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would be quite happy if grouping support for gic would be mainlined.
Then only the dance to get the old gic version 1 working with fiqs would be 
needed...

I have on comment inline below which seems as a race to me.

Am Dienstag, 25. November 2014, 17:26:39 schrieb Daniel Thompson:
> Currently it is not possible to exploit FIQ for systems with a GIC, even if
> the systems are otherwise capable of it. This patch makes it possible
> for IPIs to be delivered using FIQ.
> 
> To do so it modifies the register state so that normal interrupts are
> placed in group 1 and specific IPIs are placed into group 0. It also
> configures the controller to raise group 0 interrupts using the FIQ
> signal. It provides a means for architecture code to define which IPIs
> shall use FIQ and to acknowledge any IPIs that are raised.
> 
> All GIC hardware except GICv1-without-TrustZone support provides a means
> to group exceptions into group 0 and group 1 but the hardware
> functionality is unavailable to the kernel when a secure monitor is
> present because access to the grouping registers are prohibited outside
> "secure world". However when grouping is not available (or in the case
> of early GICv1 implementations is very hard to configure) the code to
> change groups does not deploy and all IPIs will be raised via IRQ.
> 
> It has been tested and shown working on two systems capable of
> supporting grouping (Freescale i.MX6 and STiH416). It has also been
> tested for boot regressions on two systems that do not support grouping
> (vexpress-a9 and Qualcomm Snapdragon 600).
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Jon Medhurst <tixy@linaro.org>
> ---
>  arch/arm/kernel/traps.c         |   5 +-
>  drivers/irqchip/irq-gic.c       | 155
> +++++++++++++++++++++++++++++++++++++--- include/linux/irqchip/arm-gic.h | 
>  8 +++
>  3 files changed, 158 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 0c8b10801d36..4dc45b38e56e 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -26,6 +26,7 @@
>  #include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/irq.h>
> +#include <linux/irqchip/arm-gic.h>
> 
>  #include <linux/atomic.h>
>  #include <asm/cacheflush.h>
> @@ -479,7 +480,9 @@ asmlinkage void __exception_irq_entry
> handle_fiq_as_nmi(struct pt_regs *regs)
> 
>  	nmi_enter();
> 
> -	/* nop. FIQ handlers for special arch/arm features can be added here. */
> +#ifdef CONFIG_ARM_GIC
> +	gic_handle_fiq_ipi();
> +#endif
> 
>  	nmi_exit();
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index a53aa11e4f17..dfec7a4c1c64 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -39,6 +39,7 @@
>  #include <linux/slab.h>
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/irqchip/arm-gic.h>
> +#include <linux/ratelimit.h>
> 
>  #include <asm/cputype.h>
>  #include <asm/irq.h>
> @@ -48,6 +49,10 @@
>  #include "irq-gic-common.h"
>  #include "irqchip.h"
> 
> +#ifndef SMP_IPI_FIQ_MASK
> +#define SMP_IPI_FIQ_MASK 0
> +#endif
> +
>  union gic_base {
>  	void __iomem *common_base;
>  	void __percpu * __iomem *percpu_base;
> @@ -333,6 +338,93 @@ static struct irq_chip gic_chip = {
>  	.irq_set_wake		= gic_set_wake,
>  };
> 
> +/*
> + * Shift an interrupt between Group 0 and Group 1.
> + *
> + * In addition to changing the group we also modify the priority to
> + * match what "ARM strongly recommends" for a system where no Group 1
> + * interrupt must ever preempt a Group 0 interrupt.
> + *
> + * If is safe to call this function on systems which do not support
> + * grouping (it will have no effect).
> + */
> +static void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
> +				int group)
> +{
> +	unsigned int grp_reg = hwirq / 32 * 4;
> +	u32 grp_mask = BIT(hwirq % 32);
> +	u32 grp_val;
> +
> +	unsigned int pri_reg = (hwirq / 4) * 4;
> +	u32 pri_mask = BIT(7 + ((hwirq % 4) * 8));
> +	u32 pri_val;
> +
> +	/*
> +	 * Systems which do not support grouping will have not have
> +	 * the EnableGrp1 bit set.
> +	 */
> +	if (!(GICD_ENABLE_GRP1 & readl_relaxed(base + GIC_DIST_CTRL)))
> +		return;
> +
> +	raw_spin_lock(&irq_controller_lock);
> +
Assumption: The interrupt in question is not masked over here?
> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
> +	pri_val = readl_relaxed(base + GIC_DIST_PRI + pri_reg);
> +
> +	if (group) {
> +		grp_val |= grp_mask;
> +		pri_val |= pri_mask;
> +	} else {
> +		grp_val &= ~grp_mask;
> +		pri_val &= ~pri_mask;
> +	}
> +
> +	writel_relaxed(grp_val, base + GIC_DIST_IGROUP + grp_reg);
If the assumption is true, then there is a race if the interrupt in question 
hits here with undefined priority setting. Recomended workaround would be
masking the interrupt in question.
> +	writel_relaxed(pri_val, base + GIC_DIST_PRI + pri_reg);
> +	raw_spin_unlock(&irq_controller_lock);
> +}
> +
> +/*
> + * Test which group an interrupt belongs to.
> + *
> + * Returns 0 if the controller does not support grouping.
> + */
> +static int gic_get_group_irq(void __iomem *base, unsigned int hwirq)
> +{
> +	unsigned int grp_reg = hwirq / 32 * 4;
> +	u32 grp_val;
> +
> +	grp_val = readl_relaxed(base + GIC_DIST_IGROUP + grp_reg);
> +
> +	return (grp_val >> (hwirq % 32)) & 1;
> +}
> +
> +/*
> + * Fully acknowledge (both ack and eoi) any outstanding FIQ-based IPI,
> + * otherwise do nothing.
> + */
> +void gic_handle_fiq_ipi(void)
> +{
> +	struct gic_chip_data *gic = &gic_data[0];
> +	void __iomem *cpu_base = gic_data_cpu_base(gic);
> +	unsigned long irqstat, irqnr;
> +
> +	if (WARN_ON(!in_nmi()))
> +		return;
> +
> +	while ((1u << readl_relaxed(cpu_base + GIC_CPU_HIGHPRI)) &
> +	       SMP_IPI_FIQ_MASK) {
> +		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
> +		writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
> +
> +		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> +		WARN_RATELIMIT(irqnr > 16,
> +			       "Unexpected irqnr %lu (bad prioritization?)\n",
> +			       irqnr);
> +	}
> +}
> +
>  void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>  {
>  	if (gic_nr >= MAX_GIC_NR)
> @@ -364,15 +456,24 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>  static void gic_cpu_if_up(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	u32 bypass = 0;
> +	void __iomem *dist_base = gic_data_dist_base(&gic_data[0]);
> +	u32 ctrl = 0;
> 
>  	/*
> -	* Preserve bypass disable bits to be written back later
> -	*/
> -	bypass = readl(cpu_base + GIC_CPU_CTRL);
> -	bypass &= GICC_DIS_BYPASS_MASK;
> +	 * Preserve bypass disable bits to be written back later
> +	 */
> +	ctrl = readl(cpu_base + GIC_CPU_CTRL);
> +	ctrl &= GICC_DIS_BYPASS_MASK;
> 
> -	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
> +	/*
> +	 * If EnableGrp1 is set in the distributor then enable group 1
> +	 * support for this CPU (and route group 0 interrupts to FIQ).
> +	 */
> +	if (GICD_ENABLE_GRP1 & readl_relaxed(dist_base + GIC_DIST_CTRL))
> +		ctrl |= GICC_COMMON_BPR | GICC_FIQ_EN | GICC_ACK_CTL |
> +			GICC_ENABLE_GRP1;
> +
> +	writel_relaxed(ctrl | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
>  }
> 
> 
> @@ -396,7 +497,23 @@ static void __init gic_dist_init(struct gic_chip_data
> *gic)
> 
>  	gic_dist_config(base, gic_irqs, NULL);
> 
> -	writel_relaxed(GICD_ENABLE, base + GIC_DIST_CTRL);
> +	/*
> +	 * Set EnableGrp1/EnableGrp0 (bit 1 and 0) or EnableGrp (bit 0 only,
> +	 * bit 1 ignored) depending on current mode.
> +	 */
> +	writel_relaxed(GICD_ENABLE_GRP1 | GICD_ENABLE, base + GIC_DIST_CTRL);
> +
> +	/*
> +	 * Set all global interrupts to be group 1 if (and only if) it
> +	 * is possible to enable group 1 interrupts. This register is RAZ/WI
> +	 * if not accessible or not implemented, however some GICv1 devices
> +	 * do not implement the EnableGrp1 bit making it unsafe to set
> +	 * this register unconditionally.
> +	 */
> +	if (GICD_ENABLE_GRP1 & readl_relaxed(base + GIC_DIST_CTRL))
> +		for (i = 32; i < gic_irqs; i += 32)
> +			writel_relaxed(0xffffffff,
> +				       base + GIC_DIST_IGROUP + i * 4 / 32);
>  }
> 
>  static void gic_cpu_init(struct gic_chip_data *gic)
> @@ -405,6 +522,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  	void __iomem *base = gic_data_cpu_base(gic);
>  	unsigned int cpu_mask, cpu = smp_processor_id();
>  	int i;
> +	unsigned long secure_irqs, secure_irq;
> 
>  	/*
>  	 * Get what the GIC says our CPU mask is.
> @@ -423,6 +541,19 @@ static void gic_cpu_init(struct gic_chip_data *gic)
> 
>  	gic_cpu_config(dist_base, NULL);
> 
> +	/*
> +	 * If the distributor is configured to support interrupt grouping
> +	 * then set any PPI and SGI interrupts not set in SMP_IPI_FIQ_MASK
> +	 * to be group1 and ensure any remaining group 0 interrupts have
> +	 * the right priority.
> +	 */
> +	if (GICD_ENABLE_GRP1 & readl_relaxed(dist_base + GIC_DIST_CTRL)) {
> +		secure_irqs = SMP_IPI_FIQ_MASK;
> +		writel_relaxed(~secure_irqs, dist_base + GIC_DIST_IGROUP + 0);
> +		for_each_set_bit(secure_irq, &secure_irqs, 16)
> +			gic_set_group_irq(dist_base, secure_irq, 0);
> +	}
> +
>  	writel_relaxed(GICC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
>  	gic_cpu_if_up();
>  }
> @@ -512,7 +643,8 @@ static void gic_dist_restore(unsigned int gic_nr)
>  		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
>  			dist_base + GIC_DIST_ENABLE_SET + i * 4);
> 
> -	writel_relaxed(GICD_ENABLE, dist_base + GIC_DIST_CTRL);
> +	writel_relaxed(GICD_ENABLE_GRP1 | GICD_ENABLE,
> +		       dist_base + GIC_DIST_CTRL);
>  }
> 
>  static void gic_cpu_save(unsigned int gic_nr)
> @@ -640,6 +772,7 @@ static void gic_raise_softirq(const struct cpumask
> *mask, unsigned int irq) {
>  	int cpu;
>  	unsigned long map = 0;
> +	unsigned long softint;
> 
>  	read_lock(&cpu_map_migration_lock);
> 
> @@ -654,7 +787,11 @@ static void gic_raise_softirq(const struct cpumask
> *mask, unsigned int irq) dmb(ishst);
> 
>  	/* this always happens on GIC0 */
> -	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) +
> GIC_DIST_SOFTINT); +	softint = map << 16 | irq;
> +	if (gic_get_group_irq(gic_data_dist_base(&gic_data[0]), irq))
> +		softint |= 0x8000;
> +	writel_relaxed(softint,
> +		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
> 
>  	read_unlock(&cpu_map_migration_lock);
>  }
> diff --git a/include/linux/irqchip/arm-gic.h
> b/include/linux/irqchip/arm-gic.h index 13eed92c7d24..a906fb7ac11f 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -22,6 +22,10 @@
>  #define GIC_CPU_IDENT			0xfc
> 
>  #define GICC_ENABLE			0x1
> +#define GICC_ENABLE_GRP1                0x2
> +#define GICC_ACK_CTL                    0x4
> +#define GICC_FIQ_EN                     0x8
> +#define GICC_COMMON_BPR                 0x10
>  #define GICC_INT_PRI_THRESHOLD		0xf0
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  #define GICC_INT_SPURIOUS		1023
> @@ -44,6 +48,7 @@
>  #define GIC_DIST_SGI_PENDING_SET	0xf20
> 
>  #define GICD_ENABLE			0x1
> +#define GICD_ENABLE_GRP1		0x2
>  #define GICD_DISABLE			0x0
>  #define GICD_INT_ACTLOW_LVLTRIG		0x0
>  #define GICD_INT_EN_CLR_X32		0xffffffff
> @@ -117,5 +122,8 @@ static inline void __init register_routable_domain_ops
>  {
>  	gic_routable_irq_domain_ops = ops;
>  }
> +
> +void gic_handle_fiq_ipi(void);
> +
>  #endif /* __ASSEMBLY */
>  #endif

