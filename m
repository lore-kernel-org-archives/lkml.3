Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaEHMyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:54:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46320 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752756AbaEHMya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:54:30 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V5] gic: preserve gic V2 bypass bits in cpu ctrl register
In-Reply-To: <1399507310-2791-1-git-send-email-fkan@apm.com> (Feng Kan's
	message of "Thu, 8 May 2014 01:01:50 +0100")
Organization: ARM Ltd
References: <1399507310-2791-1-git-send-email-fkan@apm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 08 May 2014 13:54:27 +0100
Message-ID: <87ha50mnwc.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08 2014 at  1:01:50 am BST, Feng Kan <fkan@apm.com> wrote:
> This change is made to preserve the GIC v2 bypass bits in the
> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> This code will preserve all bits configured by the bootload regarding
> v2 bypass group bits. In the X-Gene platform, the bypass functionality
> is not used and bypass bits should not be changed by the kernel gic
> code as it could lead to incorrect behavior.
>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Acked-by: Anup Patel <apatel@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
> V5: Use macro to replace read modify write of cpu_ctrl register.
> V4: Change to use bypass mask, change ot user more suitable variable name.
>  drivers/irqchip/irq-gic.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4300b66..42e9bf4 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -97,6 +97,13 @@ struct irq_chip gic_arch_extn = {
>  #define MAX_GIC_NR	1
>  #endif
>  
> +#define set_cpuctrl(base, val)					\
> +	do {							\
> +		u32 bypass;					\
> +		bypass = readl(base + GIC_CPU_CTRL) & 0x1e0;	\
> +		writel_relaxed(bypass | val, base + GIC_CPU_CTRL);\
> +	} while (0)
> +

Please use a function. A macro doesn't buy us anything here, and lacks
type safety.

Your previous patch was nicer in that respect. You just had to move the
enable code to a gic_cpu_if_up() function, and you were done...

>  static struct gic_chip_data gic_data[MAX_GIC_NR] __read_mostly;
>  
>  #ifdef CONFIG_GIC_NON_BANKED
> @@ -449,13 +456,15 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +
> +	set_cpuctrl(base, 1);
>  }
>  
>  void gic_cpu_if_down(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
> +
> +	set_cpuctrl(cpu_base, 0);
>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -590,7 +599,8 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	
> +	set_cpuctrl(cpu_base, 1);
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)


	M.
-- 
Jazz is not dead. It just smells funny.
