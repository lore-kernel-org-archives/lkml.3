Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbaAaRiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:38:14 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36672 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbaAaRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:38:09 -0500
MIME-Version: 1.0
In-Reply-To: <780bb8c8fd752eeace2fd2fbe1d8ed8572dc0d76.1391170073.git.michal.simek@xilinx.com>
References: <780bb8c8fd752eeace2fd2fbe1d8ed8572dc0d76.1391170073.git.michal.simek@xilinx.com>
Date: Fri, 31 Jan 2014 11:38:08 -0600
Message-ID: <CAL_Jsq+4Ea7=WP+mj_k1Q3q7DKm-hk6WXpv2DOBQwefp-zxzjg@mail.gmail.com>
Subject: Re: [PATCH] ARM: zynq: Reserve not DMAable space in front of the kernel
From: Rob Herring <robherring2@gmail.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 6:08 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> Reserve space from 0x0 - __pa(swapper_pg_dir),
> if kernel is loaded from 0, which is not DMAable.
> It is causing problem with MMC driver and others
> which want to add dma buffers to this space.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>
> Jason: I don't think it is worth to bring 0x8000 magic
> value and count minimum from it and phys_addr of swapper_pg_dir.
> Full 512k of memory shouldn't be used by DMA.
>
> ---
>  arch/arm/mach-zynq/common.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

The existing DT reserved range can't be used for this purpose?

Rob

>
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 1db2a5ca..8c09a83 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -25,6 +25,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
>  #include <linux/of.h>
> +#include <linux/memblock.h>
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/arm-gic.h>
>
> @@ -41,6 +42,18 @@
>
>  void __iomem *zynq_scu_base;
>
> +/**
> + * zynq_memory_init - Initialize special memory
> + *
> + * We need to stop things allocating the low memory as DMA can't work in
> + * the 1st 512K of memory.
> + */
> +static void __init zynq_memory_init(void)
> +{
> +       if (!__pa(PAGE_OFFSET))
> +               memblock_reserve(__pa(PAGE_OFFSET), __pa(swapper_pg_dir));
> +}
> +
>  static struct platform_device zynq_cpuidle_device = {
>         .name = "cpuidle-zynq",
>  };
> @@ -117,5 +130,6 @@ DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>         .init_machine   = zynq_init_machine,
>         .init_time      = zynq_timer_init,
>         .dt_compat      = zynq_dt_match,
> +       .reserve        = zynq_memory_init,
>         .restart        = zynq_system_reset,
>  MACHINE_END
> --
> 1.8.2.3
>
