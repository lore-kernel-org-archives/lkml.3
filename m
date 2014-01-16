Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaAPPVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:21:08 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:53145 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaAPPVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:21:06 -0500
Date: Thu, 16 Jan 2014 16:19:27 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc@hellion.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: orion: provide C-style interrupt handler for
 MULTI_IRQ_HANDLER
Message-ID: <20140116151927.GN17530@lunn.ch>
References: <1389775235.10695.51.camel@dagon.hellion.org.uk>
 <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:10:31AM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Marvell Kirkwood and Dove SoCs make use of an irqchip
> driver. As expected for irqchip drivers, it uses a C-style
> interrupt handler and therefore selects MULTI_IRQ_HANDLER.
> 
> Now, compiling a kernel with both non-DT and DT support enabled,
> selecting MULTI_IRQ_HANDLER will break ASM irq handler used by
> non-DT boards.
> 
> Therefore, we provide a C-style irq handler even for non-DT boards,
> if MULTI_IRQ_HANDLER is set. By installing the C-style irq handler
> in orion_irq_init this is transparent to all non-DT board files.
> 
> While the regression report was filed on Marvell Kirkwood, also
> Marvell Dove non-DT boards are affected and fixed by this patch.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Ian Campbell <ijc@hellion.org.uk>
> Reported-by: Ian Campbell <ijc@hellion.org.uk>
> Fixes: 2326f04321a9 ("ARM: kirkwood: convert to DT irqchip and clocksource")
> Fixes: f07d73e33d0e ("ARM: dove: convert to DT irqchip and clocksource")

Hi Sebastian

Makes sense and this version is much better than the previous.

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew


> ---
> Compared to the two patch version sent on Ian's regression report,
> I cooked this down to a single patch only touching plat-orion/irq.c.
> I also dropped Orion5x and MV78x00, as they not yet select MULTI_IRQ_HANDLER
> at all. Instead I added a comment about taking care of them, as soon as
> they move over to an irqchip driver themselves.
> 
> I have not yet Cc'ed this patch to -stable to get some discussion and
> an Acked-by from Jason or Andrew, too.
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ian Campbell <ijc@hellion.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/plat-orion/irq.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/arch/arm/plat-orion/irq.c b/arch/arm/plat-orion/irq.c
> index c492e1b3dfdb..807df142444b 100644
> --- a/arch/arm/plat-orion/irq.c
> +++ b/arch/arm/plat-orion/irq.c
> @@ -15,8 +15,51 @@
>  #include <linux/io.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> +#include <asm/exception.h>
>  #include <plat/irq.h>
>  #include <plat/orion-gpio.h>
> +#include <mach/bridge-regs.h>
> +
> +#ifdef CONFIG_MULTI_IRQ_HANDLER
> +/*
> + * Compiling with both non-DT and DT support enabled, will
> + * break asm irq handler used by non-DT boards. Therefore,
> + * we provide a C-style irq handler even for non-DT boards,
> + * if MULTI_IRQ_HANDLER is set.
> + *
> + * Notes:
> + * - this is prepared for Kirkwood and Dove only, update
> + *   accordingly if you add Orion5x or MV78x00.
> + * - Orion5x uses different macro names and has only one
> + *   set of CAUSE/MASK registers.
> + * - MV78x00 uses the same macro names but has a third
> + *   set of CAUSE/MASK registers.
> + *
> + */
> +
> +static void __iomem *orion_irq_base = IRQ_VIRT_BASE;
> +
> +asmlinkage void
> +__exception_irq_entry orion_legacy_handle_irq(struct pt_regs *regs)
> +{
> +	u32 stat;
> +
> +	stat = readl_relaxed(orion_irq_base + IRQ_CAUSE_LOW_OFF);
> +	stat &= readl_relaxed(orion_irq_base + IRQ_MASK_LOW_OFF);
> +	if (stat) {
> +		unsigned int hwirq = __fls(stat);
> +		handle_IRQ(hwirq, regs);
> +		return;
> +	}
> +	stat = readl_relaxed(orion_irq_base + IRQ_CAUSE_HIGH_OFF);
> +	stat &= readl_relaxed(orion_irq_base + IRQ_MASK_HIGH_OFF);
> +	if (stat) {
> +		unsigned int hwirq = 32 + __fls(stat);
> +		handle_IRQ(hwirq, regs);
> +		return;
> +	}
> +}
> +#endif
>  
>  void __init orion_irq_init(unsigned int irq_start, void __iomem *maskaddr)
>  {
> @@ -35,6 +78,10 @@ void __init orion_irq_init(unsigned int irq_start, void __iomem *maskaddr)
>  	ct->chip.irq_unmask = irq_gc_mask_set_bit;
>  	irq_setup_generic_chip(gc, IRQ_MSK(32), IRQ_GC_INIT_MASK_CACHE,
>  			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
> +
> +#ifdef CONFIG_MULTI_IRQ_HANDLER
> +	set_handle_irq(orion_legacy_handle_irq);
> +#endif
>  }
>  
>  #ifdef CONFIG_OF
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
