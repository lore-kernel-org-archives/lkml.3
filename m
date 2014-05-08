Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaEHQ7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:59:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50458 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751295AbaEHQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:59:12 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V6] gic: preserve gic V2 bypass bits in cpu ctrl register
In-Reply-To: <1399566634-2537-1-git-send-email-fkan@apm.com> (Feng Kan's
	message of "Thu, 8 May 2014 17:30:34 +0100")
Organization: ARM Ltd
References: <1399566634-2537-1-git-send-email-fkan@apm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 08 May 2014 17:59:10 +0100
Message-ID: <87d2foky01.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08 2014 at  5:30:34 pm BST, Feng Kan <fkan@apm.com> wrote:
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
> V6: add gic_cpu_if_up function to replace macro used in v5
> V5: Use macro to replace read modify write of cpu_ctrl register.
> V4: Change to use bypass mask, change ot user more suitable variable name.
>  drivers/irqchip/irq-gic.c       |   30 +++++++++++++++++++++++++++---
>  include/linux/irqchip/arm-gic.h |    1 +
>  2 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4300b66..cb8eb92 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -449,13 +449,36 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +
> +	gic_cpu_if_up();

Use before definition. The only reason GCC doesn't scream is because of
the useless prototype in irqchip/arm-gic.h (see below).

> +}
> +
> +void gic_cpu_if_up(void)

Why isn't it static?

> +{
> +	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> +	u32 bypass;
> +
> +	/* 

Trailing whitespace

> +	 * Preserve bypass disable bits to be written back later
> +	 */
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= 0x1e0;
> +
> +	writel_relaxed(bypass | 0x1, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  void gic_cpu_if_down(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
> +	u32 bypass;
> +
> +	/* 

Trailing whitespace

> +	 * Preserve bypass disable bits to be written back later
> +	 */
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= 0x1e0;
> +
> +	writel_relaxed(bypass, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -590,7 +613,8 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +	

Trailing whitespace

> +	gic_cpu_if_up();
>  }
>  
>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> index 7ed92d0..762dea0 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -80,6 +80,7 @@ extern struct irq_chip gic_arch_extn;
>  void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
>  		    u32 offset, struct device_node *);
>  void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
> +void gic_cpu_if_up(void);

Why do you need to expose this to the rest of the kernel, while there is
obviously no caller?

>  void gic_cpu_if_down(void);
>  
>  static inline void gic_init(unsigned int nr, int start,

So how many other versions of this incredibly simple patch are we going
to see? Please, read what you're sending, run checkpatch, try to apply
the patch to a clean tree (git am screams), get it reviewed by your
friends and colleagues before gracing the list and our inboxes with
it. At the moment, you're just wasting everybody's time and bandwidth,
as I obviously spend more time reviewing and testing this thing than you
do.

	M.
-- 
Jazz is not dead. It just smells funny.
