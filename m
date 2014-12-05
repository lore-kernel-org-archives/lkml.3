Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaLEK1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:27:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49916 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbaLEK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:27:53 -0500
Date: Fri, 5 Dec 2014 10:27:14 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] arm: ls1021a: setup hrtimer based tick broadcast
Message-ID: <20141205102714.GD11889@leverpostej>
References: <1417770449-3492-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417770449-3492-1-git-send-email-jingchang.lu@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 05, 2014 at 09:07:29AM +0000, Jingchang Lu wrote:
> This adds setup of hrtimer based tick broadcast to utilize
> the hrtimer in SMP without other broadcast tick devices.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>

This shouldn't live in board code.

Similarly to what happens with the generic dummy timer on all arches
that select it (and the broadcast hrtimer on all arches that use it so
far), we should just unconditionally register the broadcast hrtimer.

A real broadcast-capable clock event device will take preference if
present, so we don't need to add board-specific code to only register
this in certain conditions.

Mark.

> ---
>  arch/arm/mach-imx/mach-ls1021a.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mach-ls1021a.c b/arch/arm/mach-imx/mach-ls1021a.c
> index b89c858..4d074cf 100644
> --- a/arch/arm/mach-imx/mach-ls1021a.c
> +++ b/arch/arm/mach-imx/mach-ls1021a.c
> @@ -7,6 +7,10 @@
>   * (at your option) any later version.
>   */
>  
> +#include <linux/clockchips.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clocksource.h>
> +
>  #include <asm/mach/arch.h>
>  
>  #include "common.h"
> @@ -16,7 +20,15 @@ static const char * const ls1021a_dt_compat[] __initconst = {
>  	NULL,
>  };
>  
> +static void __init ls1021a_init_time(void)
> +{
> +	of_clk_init(NULL);
> +	clocksource_of_init();
> +	tick_setup_hrtimer_broadcast();
> +}
> +
>  DT_MACHINE_START(LS1021A, "Freescale LS1021A")
>  	.smp		= smp_ops(ls1021a_smp_ops),
> +	.init_time	= ls1021a_init_time,
>  	.dt_compat	= ls1021a_dt_compat,
>  MACHINE_END
> -- 
> 1.8.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
