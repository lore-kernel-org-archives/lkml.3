Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3FQE4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:56:23 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:48396 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3FQE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:56:22 -0400
Date: Mon, 17 Jun 2013 04:56:21 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-omap@vger.kernel.org,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org,
        "'Jean-Philippe Francois'" <jp.francois@cynove.com>
Subject: Re: [PATCH 3.9-stable] ARM: omap3: clock: fix wrong container_of in
 clock36xx.c
In-Reply-To: <008d01ce6aea$96291790$c27b46b0$%choi@samsung.com>
Message-ID: <alpine.DEB.2.02.1306170454330.4477@utopia.booyaka.com>
References: <008d01ce6aea$96291790$c27b46b0$%choi@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013, Jonghwan Choi wrote:

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Please do.


- Paul

> 
> ------------------
> 
> From: "Jean-Philippe Francois <jp.francois@cynove.com>"
> 
> commit a93d8a1cea0899982993e9a93404c6f78b123697 upstream
> 
> omap36xx_pwrdn_clk_enable_with_hsdiv_restore expects the parent hw of
> the clock to be a clk_hw_omap. However, looking at cclock3xxx_data.c,
> all concerned clock have parent defined as clk_divider.  Fix the
> function to use clk_divider.  Tested with 3.9 on dm3730.
> 
> Signed-off-by: Jean-Philippe Francois <jp.francois@cynove.com>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  arch/arm/mach-omap2/clock36xx.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clock36xx.c
> b/arch/arm/mach-omap2/clock36xx.c
> index 8f3bf4e..bbd6a3f 100644
> --- a/arch/arm/mach-omap2/clock36xx.c
> +++ b/arch/arm/mach-omap2/clock36xx.c
> @@ -20,11 +20,12 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/io.h>
>  
>  #include "clock.h"
>  #include "clock36xx.h"
> -
> +#define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
>  
>  /**
>   * omap36xx_pwrdn_clk_enable_with_hsdiv_restore - enable clocks suffering
> @@ -39,29 +40,28 @@
>   */
>  int omap36xx_pwrdn_clk_enable_with_hsdiv_restore(struct clk_hw *clk)
>  {
> -	struct clk_hw_omap *parent;
> +	struct clk_divider *parent;
>  	struct clk_hw *parent_hw;
> -	u32 dummy_v, orig_v, clksel_shift;
> +	u32 dummy_v, orig_v;
>  	int ret;
>  
>  	/* Clear PWRDN bit of HSDIVIDER */
>  	ret = omap2_dflt_clk_enable(clk);
>  
>  	parent_hw = __clk_get_hw(__clk_get_parent(clk->clk));
> -	parent = to_clk_hw_omap(parent_hw);
> +	parent = to_clk_divider(parent_hw);
>  
>  	/* Restore the dividers */
>  	if (!ret) {
> -		clksel_shift = __ffs(parent->clksel_mask);
> -		orig_v = __raw_readl(parent->clksel_reg);
> +		orig_v = __raw_readl(parent->reg);
>  		dummy_v = orig_v;
>  
>  		/* Write any other value different from the Read value */
> -		dummy_v ^= (1 << clksel_shift);
> -		__raw_writel(dummy_v, parent->clksel_reg);
> +		dummy_v ^= (1 << parent->shift);
> +		__raw_writel(dummy_v, parent->reg);
>  
>  		/* Write the original divider */
> -		__raw_writel(orig_v, parent->clksel_reg);
> +		__raw_writel(orig_v, parent->reg);
>  	}
>  
>  	return ret;
> -- 
> 1.7.9.5
> 


- Paul
