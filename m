Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbbAZLr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:47:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43016 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbbAZLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:47:24 -0500
Date: Mon, 26 Jan 2015 11:46:59 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "Patrice.VILCHEZ@atmel.com" <Patrice.VILCHEZ@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/7] ARM: at91: enable the L2 Cache controller
Message-ID: <20150126114659.GD23313@leverpostej>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
 <1422266836-24592-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422266836-24592-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:07:16AM +0000, Wenyou Yang wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  arch/arm/mach-at91/board-dt-sama5.c |   53 +++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 86cffcd..ed6db28 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -17,17 +17,70 @@
>  #include <linux/of_platform.h>
>  #include <linux/phy.h>
>  #include <linux/clk-provider.h>
> +#include <linux/of_address.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
> +#include <asm/hardware/cache-l2x0.h>
>  
>  #include "generic.h"
>  
> +void __iomem *at91_l2cc_base;
> +EXPORT_SYMBOL_GPL(at91_l2cc_base);
> +
> +#ifdef CONFIG_CACHE_L2X0
> +static void __init at91_init_l2cache(void)
> +{
> +	struct device_node *np;
> +	u32 reg;
> +
> +	np = of_find_compatible_node(NULL, NULL, "arm,pl310-cache");
> +	if (!np)
> +		return;
> +
> +	at91_l2cc_base = of_iomap(np, 0);
> +	if (!at91_l2cc_base)
> +		panic("unable to map l2cc cpu registers\n");
> +
> +	of_node_put(np);
> +
> +	/* Disable cache if it hasn't been done yet */
> +	if (readl_relaxed(at91_l2cc_base + L2X0_CTRL) & L2X0_CTRL_EN)
> +		writel_relaxed(~L2X0_CTRL_EN, at91_l2cc_base + L2X0_CTRL);
> +
> +	/* Prefetch Control */
> +	reg = readl_relaxed(at91_l2cc_base + L310_PREFETCH_CTRL);
> +	reg &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
> +	reg |= 0x01;
> +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
> +	reg |= L310_PREFETCH_CTRL_PREFETCH_DROP;
> +	reg |= L310_PREFETCH_CTRL_DATA_PREFETCH;
> +	reg |= L310_PREFETCH_CTRL_INSTR_PREFETCH;
> +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL;
> +	writel_relaxed(reg, at91_l2cc_base + L310_PREFETCH_CTRL);
> +
> +	/* Power Control */
> +	reg = readl_relaxed(at91_l2cc_base + L310_POWER_CTRL);
> +	reg |= L310_STNDBY_MODE_EN;
> +	reg |= L310_DYNAMIC_CLK_GATING_EN;
> +	writel_relaxed(reg, at91_l2cc_base + L310_POWER_CTRL);
> +
> +	/* Disable interrupts */
> +	writel_relaxed(0x00, at91_l2cc_base + L2X0_INTR_MASK);
> +	writel_relaxed(0x01ff, at91_l2cc_base + L2X0_INTR_CLEAR);
> +	l2x0_of_init(0, ~0UL);
> +}
> +#else
> +static inline void at91_init_l2cache(void) {}
> +#endif

This poking of the PL310 should live in the cache_l2x0 driver.

Mark.
