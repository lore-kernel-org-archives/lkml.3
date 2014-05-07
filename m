Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaEGJhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:37:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21408 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932069AbaEGJhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:37:35 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V4] gic: preserve gic V2 bypass bits in cpu ctrl register
In-Reply-To: <1399424025-4199-1-git-send-email-fkan@apm.com> (Feng Kan's
	message of "Wed, 7 May 2014 01:53:45 +0100")
Organization: ARM Ltd
References: <1399424025-4199-1-git-send-email-fkan@apm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 07 May 2014 10:37:26 +0100
Message-ID: <877g5yorop.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07 2014 at  1:53:45 am BST, Feng Kan <fkan@apm.com> wrote:
> This change is made to preserve the GIC v2 bypass bits in the
> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> This code will preserve all bits configured by the bootload regarding
                                                     bootloader
> v2 bypass group bits. In the X-Gene platform (as well others), the

Which other platform? It'd be interesting to know which one, as you're
implying they haven't managed to boot a mainline kernel so far...

> bypass functionality is not generally used and bypass bits should not
> be changed by the kernel gic code as it could lead to incorrect behavior.
> Tested on X-Gene mustang board.
>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Acked-by: Anup Patel <apatel@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  V4: Change to use bypass mask, change to use more suitable variable name.
>  V3: Fix code not touch other bits other than bypass bits.
>
>  drivers/irqchip/irq-gic.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4300b66..50a7bb2 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -97,6 +97,8 @@ struct irq_chip gic_arch_extn = {
>  #define MAX_GIC_NR	1
>  #endif
>  
> +#define GIC_BYPASS_MASK		0x1e0
> +
>  static struct gic_chip_data gic_data[MAX_GIC_NR] __read_mostly;
>  
>  #ifdef CONFIG_GIC_NON_BANKED
> @@ -418,6 +420,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  	void __iomem *dist_base = gic_data_dist_base(gic);
>  	void __iomem *base = gic_data_cpu_base(gic);
>  	unsigned int cpu_mask, cpu = smp_processor_id();
> +	unsigned int bypass;

Please use a type that corresponds to the width of the access (u32 in
this case).

>  	int i;
>  
>  	/*
> @@ -449,13 +452,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>  
>  	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, base + GIC_CPU_CTRL);
> +
> +	bypass = readl(base + GIC_CPU_CTRL);
> +	bypass &= GIC_BYPASS_MASK;
> +	writel_relaxed(bypass | 0x1, base + GIC_CPU_CTRL);
>  }
>  
>  void gic_cpu_if_down(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
> -	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
> +	unsigned int bypass;
> +
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= GIC_BYPASS_MASK;
> +	writel_relaxed(bypass, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  #ifdef CONFIG_CPU_PM
> @@ -566,6 +576,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  {
>  	int i;
>  	u32 *ptr;
> +	unsigned int bypass;
>  	void __iomem *dist_base;
>  	void __iomem *cpu_base;
>  
> @@ -590,7 +601,10 @@ static void gic_cpu_restore(unsigned int gic_nr)
>  		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>  
>  	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
> -	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
> +
> +	bypass = readl(cpu_base + GIC_CPU_CTRL);
> +	bypass &= GIC_BYPASS_MASK;
> +	writel_relaxed(bypass | 0x1, cpu_base + GIC_CPU_CTRL);

It would be good to turn these into a static function (gic_cpu_if_up,
matching gic_cpu_if_down?), and use it in both gic_cpu_init and
gic_cpu_restore.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
