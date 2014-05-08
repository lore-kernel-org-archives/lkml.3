Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaEHWud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:50:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:59409 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaEHWuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:50:32 -0400
Date: Fri, 9 May 2014 00:50:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Kan <fkan@apm.com>
cc: catalin.marinas@arm.com, marc.zyngier@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, patches@apm.com,
        Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V7] gic: preserve gic V2 bypass bits in cpu ctrl
 register
In-Reply-To: <1399578180-18413-1-git-send-email-fkan@apm.com>
Message-ID: <alpine.DEB.2.02.1405090042321.6261@ionos.tec.linutronix.de>
References: <1399578180-18413-1-git-send-email-fkan@apm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Feng Kan wrote:

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
> V7: cleanup white spaces, remove export in gic.h, change if_up to static.
> V6: add gic_cpu_if_up function to replace macro used in v5
> V5: Use macro to replace read modify write of cpu_ctrl register.
> V4: Change to use bypass mask, change ot user more suitable variable name.
>  drivers/irqchip/irq-gic.c |   30 +++++++++++++++++++++++++++---
>  1 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4300b66..7e952c3 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -373,6 +373,20 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
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
> +	bypass &= 0x1e0;

Can we please use some reasonable defines instead of magic hex
constants?

It's not a new problem as the existing code is full of magic
numbers. But as a compensation for stealing so much of Marcs time for
this rather trivial endeavour, please create a patch series with two
patches:

1/2: Replace the existing magic constants in that code with reasonable
     self explaining defines

2/2: Add your new stuff on top of it.

Thanks,

	tglx
