Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3EPUCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:02:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16488 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3EPUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:02:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Qn9Gn2maz9ug7R22+kMhc
Date: Thu, 16 May 2013 13:02:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH V5 1/6] clk: OMAP: introduce device tree binding to
 kernel clock data
Message-ID: <20130516200237.GL5600@atomide.com>
References: <1368039976-29648-1-git-send-email-nm@ti.com>
 <1368039976-29648-2-git-send-email-nm@ti.com>
 <20130513235119.10068.47040@quantum>
 <20130516174355.GB5600@atomide.com>
 <20130516194632.12127.59935@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516194632.12127.59935@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Turquette <mturquette@linaro.org> [130516 12:52]:
> Quoting Tony Lindgren (2013-05-16 10:43:56)
> > * Mike Turquette <mturquette@linaro.org> [130513 16:56]:
> > > Quoting Nishanth Menon (2013-05-08 12:06:11)
> > > <snip>
> > > > Overall strategy introduced here is simple: a clock node described in
> > > > device tree blob is used to identify the exact clock provided in the
> > > > SoC specific data. This is then linked back using of_clk_add_provider
> > > > to the device node to be accessible by of_clk_get.
> > > > 
> > > 
> > > FYI, I'm working on moving the OMAP clocks over to DT which is a better
> > > alternative than this patch.  I'll share what I have on the list,
> > > hopefully next week.
> > 
> > That's good news! What's your plan on using the indexing the clocks?
> > 
> > I'd rather avoid indexing as that's basically same as the old IRQ
> > numbering and GPIO numbering schemes that don't work well in the long
> > term.
> > 
> > We already have quite a few sets of clocks for omaps, so the indexing
> > is already an issue. My thinking is that indexing should only be used
> > if the same physical clock has multiple outputs.
> > 
> 
> At present I am actually describing the clock hardware in DT.  Each
> clock is a node (not a device) using the established clock binding in
> Documentation/devicetree/bindings/clocks/clock-bindings.txt.
> 
> To do this I am introducing new bindings for the common types: gate, mux
> & divider.  These are the ones I am migrating to DT first.  Eventually
> I'll create bindings for the OMAP-specifc clocks after this.

Great, that's the way to go.
 
> I currently have this DT approach co-existing with the static data.  As
> a start I have used the fixed-clock and mux-clock bindings to put all of
> the root clocks and sys_clk into arch/arm/boot/dts/omap4-clocks.dtsi.
> This file is included by arch/arm/boot/dts/omap4.dtsi.

OK.

> The DT clocks are parsed prior to the static clock registration:
> 
> diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
> index 88e37a4..7cc4cae 100644
> --- a/arch/arm/mach-omap2/cclock44xx_data.c
> +++ b/arch/arm/mach-omap2/cclock44xx_data.c
> @@ -27,6 +27,7 @@
>  #include <linux/clk-private.h>
>  #include <linux/clkdev.h>
>  #include <linux/io.h>
> +#include <linux/clk/omap.h>
>  
>  #include "soc.h"
>  #include "iomap.h"
> @@ -1442,27 +1443,11 @@ static struct omap_clk omap443x_clks[] = {
>   * clocks common to omap44xx
>   */
>  static struct omap_clk omap44xx_clks[] = {
> -	CLK(NULL,	"extalt_clkin_ck",		&extalt_clkin_ck),
>  	CLK(NULL,	"pad_clks_src_ck",		&pad_clks_src_ck),
>  	CLK(NULL,	"pad_clks_ck",			&pad_clks_ck),
> -	CLK(NULL,	"pad_slimbus_core_clks_ck",	&pad_slimbus_core_clks_ck),
> -	CLK(NULL,	"secure_32k_clk_src_ck",	&secure_32k_clk_src_ck),
>  	CLK(NULL,	"slimbus_src_clk",		&slimbus_src_clk),
>  	CLK(NULL,	"slimbus_clk",			&slimbus_clk),
>  	CLK(NULL,	"sys_32k_ck",			&sys_32k_ck),
> -	CLK(NULL,	"virt_12000000_ck",		&virt_12000000_ck),
> -	CLK(NULL,	"virt_13000000_ck",		&virt_13000000_ck),
> -	CLK(NULL,	"virt_16800000_ck",		&virt_16800000_ck),
> -	CLK(NULL,	"virt_19200000_ck",		&virt_19200000_ck),
> -	CLK(NULL,	"virt_26000000_ck",		&virt_26000000_ck),
> -	CLK(NULL,	"virt_27000000_ck",		&virt_27000000_ck),
> -	CLK(NULL,	"virt_38400000_ck",		&virt_38400000_ck),
> -	CLK(NULL,	"sys_clkin_ck",			&sys_clkin_ck),
> -	CLK(NULL,	"tie_low_clock_ck",		&tie_low_clock_ck),
> -	CLK(NULL,	"utmi_phy_clkout_ck",		&utmi_phy_clkout_ck),
> -	CLK(NULL,	"xclk60mhsp1_ck",		&xclk60mhsp1_ck),
> -	CLK(NULL,	"xclk60mhsp2_ck",		&xclk60mhsp2_ck),
> -	CLK(NULL,	"xclk60motg_ck",		&xclk60motg_ck),
>  	CLK(NULL,	"abe_dpll_bypass_clk_mux_ck",	&abe_dpll_bypass_clk_mux_ck),
>  	CLK(NULL,	"abe_dpll_refclk_mux_ck",	&abe_dpll_refclk_mux_ck),
>  	CLK(NULL,	"dpll_abe_ck",			&dpll_abe_ck),
> @@ -1690,6 +1675,9 @@ int __init omap4xxx_clk_init(void)
>  {
>  	int rc;
>  
> +	/* FIXME register clocks from DT first */
> +	dt_omap_clk_init();
> +
>  	if (cpu_is_omap443x()) {
>  		cpu_mask = RATE_IN_4430;
>  		omap_clocks_register(omap443x_clks, ARRAY_SIZE(omap443x_clks));
> 
> 
> Ideally dt_omap_clk_init() will go away and instead by replaced by the
> probe from drivers/clk/omap/clk.c (new omap clock driver).  However I
> still need to register the root clocks before the PLLs and other
> dividers for now to avoid many issues (divide by zero errors, failed
> reparent operations, etc).  And furthermore I don't think the hwmod code
> will work if the clock tree is not populated before module_init.  So for
> now the omap clock driver does not properly probe or call module_init,
> but some day that might be fixed.

Yes, I'm sure there are some dependencies to untangle there..
 
> I know that putting all of the data into DT is not a popular idea with
> everybody.  I also know that I am not a DT expert, so I'm sure there are
> some better approaches to the some of the decisions I'm making.  I'll
> post an RFC to the list next week with cleaned-up patches and then we
> can all take it from there.

The DT related bloat issues can be avoided with the following:

1. Allow defining all clocks as needed in the .dtsi files

   This way we have the clocks available for timer, uart, mmc and
   whatever people might need.

2. Optionally allow loading the complete clock set from /lib/firmware

   This way we can avoid large amount of data in the .dtsi files
   to make booting faster. Naturally this is optional, and not needed
   if all the clocks are already defined in .dtsi files. And this can
   of course done later on if needed as long as we just keep that
   option open.

Regards,

Tony
