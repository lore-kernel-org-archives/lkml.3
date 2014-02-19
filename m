Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaBSKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:33:43 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55218 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753127AbaBSKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:33:40 -0500
Message-ID: <53048882.9070706@arm.com>
Date: Wed, 19 Feb 2014 10:33:38 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.dev" <tglx@linutronix.dev>,
        "patches@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH] irqchip:gic: change access of gicc_ctrl register to read
 modify write.
References: <1392761550-11662-1-git-send-email-fkan@apm.com>
In-Reply-To: <1392761550-11662-1-git-send-email-fkan@apm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On 18/02/14 22:12, Feng Kan wrote:
> This change is made to preserve the GIC v2 releated bits in the
> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> The original code only set the enable/disable group bit in this register.
> This code will preserve all other bits configured by the bootload except

This "all other bits" in itself is a major problem, see below.

> the enable/disable bit. The main reason for this change is to allow the
> bypass bits specified in the v2 spec to remain untouched by the current
> GIC code. In the X-Gene platform, the bypass functionality is not used
> and bypass must be disabled at all time.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Acked-by: Anup Patel <apatel@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/irqchip/irq-gic.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 341c601..9adc3e1 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  	void __iomem *dist_base = gic_data_dist_base(gic);
>  	void __iomem *base = gic_data_cpu_base(gic);
>  	unsigned int cpu_mask, cpu = smp_processor_id();
> +	unsigned int ctrl_mask;
>  	int i;
>  
>  	/*
> @@ -449,13 +450,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +
> +	ctrl_mask = readl(base + GIC_CPU_CTRL);
> +	ctrl_mask |= 0x1;
> +	writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);

So what if the firmware used a different EOImode? We would end up in a
situation where we don't deactivate the interrupts anymore. Not good.

You should only preserve the bits that actually matter, and that won't
have an impact with the way the kernel works.

>  }
>  
>  void gic_cpu_if_down(void)
>  {
> +	unsigned int ctrl_mask;
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
> +
> +	ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
> +	ctrl_mask &= 0xfffffffe;

nit: use

	ctlr_mask &= ~1;

in order to be consistent with the rest of the code.

> +	writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -566,6 +574,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  {
>  	int i;
>  	u32 *ptr;
> +	unsigned int ctrl_mask;
>  	void __iomem *dist_base;
>  	void __iomem *cpu_base;
>  
> @@ -590,7 +599,10 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +
> +	ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
> +	ctrl_mask |= 0x1;
> +	writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
