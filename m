Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3ARRzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:55:09 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38798 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3ARRzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:55:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Prashant Gaikwad <pgaikwad@nvidia.com>, <swarren@nvidia.com>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <maxime.ripard@free-electrons.com>,
        <linux@prisktech.co.nz>, <josh.cartwright@ni.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1357282858-2112-4-git-send-email-pgaikwad@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
 <1357282858-2112-4-git-send-email-pgaikwad@nvidia.com>
Message-ID: <20130118175502.3982.82180@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 4/7] clk: highbank: Use common of_clk_init() function
Date: Fri, 18 Jan 2013 09:55:02 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Prashant Gaikwad (2013-01-03 23:00:55)
> Use common of_clk_init() function for clocks initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Rob,

Can I get a Tested-by from you before I take this?

Thanks,
Mike

> ---
>  arch/arm/mach-highbank/core.h     |    1 -
>  arch/arm/mach-highbank/highbank.c |    3 ++-
>  drivers/clk/clk-highbank.c        |   18 ++++--------------
>  3 files changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/mach-highbank/core.h b/arch/arm/mach-highbank/core.h
> index 80235b4..3f65206 100644
> --- a/arch/arm/mach-highbank/core.h
> +++ b/arch/arm/mach-highbank/core.h
> @@ -2,7 +2,6 @@
>  #define __HIGHBANK_CORE_H
>  
>  extern void highbank_set_cpu_jump(int cpu, void *jump_addr);
> -extern void highbank_clocks_init(void);
>  extern void highbank_restart(char, const char *);
>  extern void __iomem *scu_base_addr;
>  
> diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
> index f6ca285..fb148da 100644
> --- a/arch/arm/mach-highbank/highbank.c
> +++ b/arch/arm/mach-highbank/highbank.c
> @@ -25,6 +25,7 @@
>  #include <linux/of_address.h>
>  #include <linux/smp.h>
>  #include <linux/amba/bus.h>
> +#include <linux/clk-provider.h>
>  
>  #include <asm/arch_timer.h>
>  #include <asm/cacheflush.h>
> @@ -116,7 +117,7 @@ static void __init highbank_timer_init(void)
>         WARN_ON(!timer_base);
>         irq = irq_of_parse_and_map(np, 0);
>  
> -       highbank_clocks_init();
> +       of_clk_init(NULL);
>         lookup.clk = of_clk_get(np, 0);
>         clkdev_add(&lookup);
>  
> diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
> index 52fecad..5d1de2e 100644
> --- a/drivers/clk/clk-highbank.c
> +++ b/drivers/clk/clk-highbank.c
> @@ -314,33 +314,23 @@ static void __init hb_pll_init(struct device_node *node)
>  {
>         hb_clk_init(node, &clk_pll_ops);
>  }
> +CLK_OF_DECLARE(hb_pll, "calxeda,hb-pll-clock", hb_pll_init);
>  
>  static void __init hb_a9periph_init(struct device_node *node)
>  {
>         hb_clk_init(node, &a9periphclk_ops);
>  }
> +CLK_OF_DECLARE(hb_a9periph, "calxeda,hb-a9periph-clock", hb_a9periph_init);
>  
>  static void __init hb_a9bus_init(struct device_node *node)
>  {
>         struct clk *clk = hb_clk_init(node, &a9bclk_ops);
>         clk_prepare_enable(clk);
>  }
> +CLK_OF_DECLARE(hb_a9bus, "calxeda,hb-a9bus-clock", hb_a9bus_init);
>  
>  static void __init hb_emmc_init(struct device_node *node)
>  {
>         hb_clk_init(node, &periclk_ops);
>  }
> -
> -static const __initconst struct of_device_id clk_match[] = {
> -       { .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
> -       { .compatible = "calxeda,hb-pll-clock", .data = hb_pll_init, },
> -       { .compatible = "calxeda,hb-a9periph-clock", .data = hb_a9periph_init, },
> -       { .compatible = "calxeda,hb-a9bus-clock", .data = hb_a9bus_init, },
> -       { .compatible = "calxeda,hb-emmc-clock", .data = hb_emmc_init, },
> -       {}
> -};
> -
> -void __init highbank_clocks_init(void)
> -{
> -       of_clk_init(clk_match);
> -}
> +CLK_OF_DECLARE(hb_emmc, "calxeda,hb-emmc-clock", hb_emmc_init);
> -- 
> 1.7.4.1
