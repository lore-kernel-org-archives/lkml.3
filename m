Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3KTK6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:58:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46383 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3KTK6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:58:30 -0500
Message-ID: <528C95D2.5090200@arm.com>
Date: Wed, 20 Nov 2013 10:58:26 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/1] irq-gic: add capability to set bypass flag in GIC
References: <1384897358-22940-1-git-send-email-fkan@apm.com>
In-Reply-To: <1384897358-22940-1-git-send-email-fkan@apm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 20 Nov 2013 10:58:26.0737 (UTC) FILETIME=[7072EA10:01CEE5DF]
X-MC-Unique: 113112010582801001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[dropping <patches@apm.com> from the CC list, as someone seems to have
 tripped on the config file, and I'm tired of getting bounces]

Feng,

On 19/11/13 21:42, Feng Kan wrote:
> The GIC-400 implementation allows for FIQ and IRQ bypass. In the
> X-Gene implementation, the FIQ bypass must be enabled at all time.
> Otherwise, some PPI will appear as FIQ and cause kernel problem.

How comes? Are only PPIs affected? When you say "some PPIs", can you be
more specific?

> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/irqchip/irq-gic.c       |   15 +++++++++++----
>  include/linux/irqchip/arm-gic.h |    4 ++--
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index d0e9480..aa7342e 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -65,6 +65,7 @@ struct gic_chip_data {
>  #endif
>  	struct irq_domain *domain;
>  	unsigned int gic_irqs;
> +	unsigned int bypass_flag;
>  #ifdef CONFIG_GIC_NON_BANKED
>  	void __iomem *(*get_base)(union gic_base *);
>  #endif
> @@ -450,7 +451,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +	writel_relaxed(gic->bypass_flag | 1, base + GIC_CPU_CTRL);
>  }
>  
>  void gic_cpu_if_down(void)
> @@ -591,7 +592,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	writel_relaxed(gic_data[gic_nr].bypass_flag | 1, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
> @@ -733,7 +734,8 @@ const struct irq_domain_ops gic_irq_domain_ops = {
>  
>  void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  			   void __iomem *dist_base, void __iomem *cpu_base,
> -			   u32 percpu_offset, struct device_node *node)
> +			   u32 percpu_offset, u32 bypass_val,
> +			   struct device_node *node)
>  {
>  	irq_hw_number_t hwirq_base;
>  	struct gic_chip_data *gic;
> @@ -821,6 +823,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  
>  	set_handle_irq(gic_handle_irq);
>  
> +	gic->bypass_flag = (bypass_val & 0xf) << 4;

Beware, the top 2 bits are reserved on GICv1, and shouldn't be messed with.

>  	gic_chip.flags |= gic_arch_extn.flags;
>  	gic_dist_init(gic);
>  	gic_cpu_init(gic);
> @@ -835,6 +838,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
>  	void __iomem *cpu_base;
>  	void __iomem *dist_base;
>  	u32 percpu_offset;
> +	u32 bypass_val;
>  	int irq;
>  
>  	if (WARN_ON(!node))
> @@ -849,7 +853,10 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
>  	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>  		percpu_offset = 0;
>  
> -	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
> +	if (of_property_read_u32(node, "bypass-flags", &bypass_val))
> +		bypass_val = 0;

[adding Mark on Cc, so he can comment on the DT parts]

Where's the DT documentation update? Also, as this is an
implementation-specific quirk, you should consider using a separate
compatible string and move the handling of this issue into some X-Gene
specific code.

> +	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, bypass_val, node);
>  
>  	if (parent) {
>  		irq = irq_of_parse_and_map(node, 0);
> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> index 0e5d9ec..999515b 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -64,14 +64,14 @@ struct device_node;
>  extern struct irq_chip gic_arch_extn;
>  
>  void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
> -		    u32 offset, struct device_node *);
> +		    u32 offset, u32 bypass_val, struct device_node *);
>  void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
>  void gic_cpu_if_down(void);
>  
>  static inline void gic_init(unsigned int nr, int start,
>  			    void __iomem *dist , void __iomem *cpu)
>  {
> -	gic_init_bases(nr, start, dist, cpu, 0, NULL);
> +	gic_init_bases(nr, start, dist, cpu, 0, 0, NULL);
>  }
>  
>  #endif /* __ASSEMBLY */
> 

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

