Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3ARAFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:05:23 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60903 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3ARAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:05:21 -0500
Date: Fri, 18 Jan 2013 09:05:17 +0900
From: Simon Horman <horms@verge.net.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: sh73a0: Use generic irqchip_init()
Message-ID: <20130118000517.GI16740@verge.net.au>
References: <1358424013-31306-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358424013-31306-1-git-send-email-thierry.reding@avionic-design.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:00:13PM +0100, Thierry Reding wrote:
> The asm/hardware/gic.h header does no longer exist and the corresponding
> functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
> respectively. gic_handle_irq() and of_irq_init() are no longer available
> either and have been replaced by irqchip_init().
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thanks.

Due to the hairy upstream requirements of the arm-soc tree
I believe this patch needs to be split in two. A 'board' patch
for board-kzm9g-reference.c. And an 'soc' patch for the
remaining portions.

I'm happy to split the patch myself or for you to do so.

> ---
>  arch/arm/mach-shmobile/board-kzm9g-reference.c | 1 -
>  arch/arm/mach-shmobile/intc-sh73a0.c           | 9 ++-------
>  arch/arm/mach-shmobile/setup-sh73a0.c          | 2 --
>  3 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> index 04e9ae5..08c95dd 100644
> --- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
> +++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> @@ -90,7 +90,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
>  	.init_early	= sh73a0_add_early_devices_dt,
>  	.nr_irqs	= NR_IRQS_LEGACY,
>  	.init_irq	= sh73a0_init_irq_dt,
> -	.handle_irq	= gic_handle_irq,
>  	.init_machine	= kzm_init,
>  	.init_late	= shmobile_init_late,
>  	.init_time	= shmobile_timer_init,
> diff --git a/arch/arm/mach-shmobile/intc-sh73a0.c b/arch/arm/mach-shmobile/intc-sh73a0.c
> index fc7c8da..91faba6 100644
> --- a/arch/arm/mach-shmobile/intc-sh73a0.c
> +++ b/arch/arm/mach-shmobile/intc-sh73a0.c
> @@ -21,9 +21,9 @@
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/irq.h>
> -#include <linux/of_irq.h>
>  #include <linux/io.h>
>  #include <linux/sh_intc.h>
> +#include <linux/irqchip.h>
>  #include <linux/irqchip/arm-gic.h>
>  #include <mach/intc.h>
>  #include <mach/irqs.h>
> @@ -462,14 +462,9 @@ void __init sh73a0_init_irq(void)
>  }
>  
>  #ifdef CONFIG_OF
> -static const struct of_device_id irq_of_match[] __initconst = {
> -	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
> -	{ },
> -};
> -
>  void __init sh73a0_init_irq_dt(void)
>  {
> -	of_irq_init(irq_of_match);
> +	irqchip_init();
>  	gic_arch_extn.irq_set_wake = sh73a0_set_wake;
>  }
>  #endif
> diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
> index abf1eb0..2ecd668 100644
> --- a/arch/arm/mach-shmobile/setup-sh73a0.c
> +++ b/arch/arm/mach-shmobile/setup-sh73a0.c
> @@ -36,7 +36,6 @@
>  #include <mach/irqs.h>
>  #include <mach/sh73a0.h>
>  #include <mach/common.h>
> -#include <asm/hardware/gic.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/map.h>
>  #include <asm/mach/arch.h>
> @@ -892,7 +891,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
>  	.init_early	= sh73a0_add_early_devices_dt,
>  	.nr_irqs	= NR_IRQS_LEGACY,
>  	.init_irq	= sh73a0_init_irq_dt,
> -	.handle_irq	= gic_handle_irq,
>  	.init_machine	= sh73a0_add_standard_devices_dt,
>  	.init_time	= shmobile_timer_init,
>  	.dt_compat	= sh73a0_boards_compat_dt,
> -- 
> 1.8.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
