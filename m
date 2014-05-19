Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaESJm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:42:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11564 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752701AbaESJm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:42:26 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
In-Reply-To: <1400278813-3048-3-git-send-email-fkan@apm.com> (Feng Kan's
	message of "Fri, 16 May 2014 23:20:13 +0100")
Organization: ARM Ltd
References: <1400278813-3048-1-git-send-email-fkan@apm.com>
	<1400278813-3048-3-git-send-email-fkan@apm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 19 May 2014 10:42:23 +0100
Message-ID: <878upynlz4.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16 2014 at 11:20:13 pm BST, Feng Kan <fkan@apm.com> wrote:
> This change is made to preserve the GIC v2 bypass bits in the
> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> This code will preserve all bits configured by the bootloader regarding
> v2 bypass group bits. In the X-Gene platform, the bypass functionality
> is not used and bypass bits should not be changed by the kernel gic
> code as it could lead to incorrect behavior.
>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> Reviewed-by: Anup Patel <apatel@apm.com>
> ---
>  drivers/irqchip/irq-gic.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index e6698a2..9840ddc 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -61,6 +61,7 @@
>  #define GIC_INT_DISABLE_MASK	0xffffffff
>  #define GIC_INT_SGI_MASK	0x0000ffff
>  #define GIC_INT_LVL_TRIGGER	0x0
> +#define GIC_DIS_BYPASS_MASK	0x1e0
>  
>  union gic_base {
>  	void __iomem *common_base;
> @@ -391,6 +392,20 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>  	return mask;
>  }
>  
> +static void gic_cpu_if_up(void)
> +{
> +	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> +	u32 bypass;
> +
> +	/*
> +	 * Preserve bypass disable bits to be written back later
> +	 */
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= GIC_DIS_BYPASS_MASK;
> +
> +	writel_relaxed(bypass | GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
> +}
> +
>  static void __init gic_dist_init(struct gic_chip_data *gic)
>  {
>  	unsigned int i;
> @@ -471,13 +486,21 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  				dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(GIC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(GIC_CPU_ENABLE, base + GIC_CPU_CTRL);
> +	gic_cpu_if_up();
>  }
>  
>  void gic_cpu_if_down(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(GIC_CPU_DISABLE, cpu_base + GIC_CPU_CTRL);
> +	u32 bypass;
> +
> +	/*
> +	 * Preserve bypass disable bits to be written back later
> +	 */
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= GIC_DIS_BYPASS_MASK;
> +
> +	writel_relaxed(bypass | GIC_CPU_DISABLE, cpu_base + GIC_CPU_CTRL);

Given that on the way down, you know that the configuration is sane, you
can write this as:

    val =  readl(cpu_base + GIC_CPU_CTRL);
    val &= ~GIC_CPU_ENABLE;
    writel_relaxed(val, cpu_base + GIC_CPU_CTRL);

I think it looks a bit better.

>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -613,7 +636,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  					dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(GIC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
> +	gic_cpu_if_up();

Have you tested the save/restore path? It seems that we dont save
GICC_CTLR, so it may not do what you think it will...

>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)

-- 
Jazz is not dead. It just smells funny.
