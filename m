Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A3SbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:31:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31593 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755317Ab3A3SbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:31:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FgLGdxIhvatOpREsBxmRwwyXuqrkY6+g=
Date: Wed, 30 Jan 2013 13:30:49 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Simon Baatz <gmbnomis@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: kirkwood: fix to retain gbe MAC addresses for
 DT kernels
Message-ID: <20130130183049.GR7717@titan.lakedaemon.net>
References: <1359509201-11674-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1359509201-11674-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359509201-11674-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Wed, Jan 30, 2013 at 02:26:41AM +0100, Sebastian Hesselbarth wrote:
> The ethernet controller used on kirkwood looses its MAC address
> register contents when the corresponding clock is gated. Until there
> is proper DT support for the mv643xx_eth driver, we add a workaround
> to always enable ge0/ge1 clocks on kirkwood. This workaround is also
> already used on non-DT kirkwood kernels.

Could you please make it clear that this is only relevant for scenarios
where mv643xx_eth is built as a module?

thx,

Jason.

> 
> Reported-by: Simon Baatz <gmbnomis@gmail.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Simon Baatz <gmbnomis@gmail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> index de4fd2b..e714ead 100644
> --- a/arch/arm/mach-kirkwood/board-dt.c
> +++ b/arch/arm/mach-kirkwood/board-dt.c
> @@ -41,16 +41,12 @@ static void __init kirkwood_legacy_clk_init(void)
>  
>  	struct device_node *np = of_find_compatible_node(
>  		NULL, NULL, "marvell,kirkwood-gating-clock");
> -
>  	struct of_phandle_args clkspec;
> +	struct clk *clk;
>  
>  	clkspec.np = np;
>  	clkspec.args_count = 1;
>  
> -	clkspec.args[0] = CGC_BIT_GE0;
> -	orion_clkdev_add(NULL, "mv643xx_eth_port.0",
> -			 of_clk_get_from_provider(&clkspec));
> -
>  	clkspec.args[0] = CGC_BIT_PEX0;
>  	orion_clkdev_add("0", "pcie",
>  			 of_clk_get_from_provider(&clkspec));
> @@ -63,14 +59,24 @@ static void __init kirkwood_legacy_clk_init(void)
>  	orion_clkdev_add("1", "pcie",
>  			 of_clk_get_from_provider(&clkspec));
>  
> -	clkspec.args[0] = CGC_BIT_GE1;
> -	orion_clkdev_add(NULL, "mv643xx_eth_port.1",
> -			 of_clk_get_from_provider(&clkspec));
> -
>  	clkspec.args[0] = CGC_BIT_SDIO;
>  	orion_clkdev_add(NULL, "mvsdio",
>  			 of_clk_get_from_provider(&clkspec));
>  
> +	/*
> +	 * The ethernet interfaces forget the MAC address assigned by
> +	 * u-boot if the clocks are turned off. Until proper DT support
> +	 * is available we always enable them for now.
> +	 */
> +	clkspec.args[0] = CGC_BIT_GE0;
> +	clk = of_clk_get_from_provider(&clkspec);
> +	orion_clkdev_add(NULL, "mv643xx_eth_port.0", clk);
> +	clk_prepare_enable(clk);
> +
> +	clkspec.args[0] = CGC_BIT_GE1;
> +	clk = of_clk_get_from_provider(&clkspec);
> +	orion_clkdev_add(NULL, "mv643xx_eth_port.1", clk);
> +	clk_prepare_enable(clk);
>  }
>  
>  static void __init kirkwood_of_clk_init(void)
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
