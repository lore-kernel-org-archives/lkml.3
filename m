Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbaGPImR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:42:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6325 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbaGPImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:42:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jul 2014 01:34:43 -0700
Date: Wed, 16 Jul 2014 11:41:51 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] clk: tegra: Add support for Tegra132 CAR clocks
Message-ID: <20140716084151.GN23218@tbergstrom-lnx.Nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-6-git-send-email-pdeschrijver@nvidia.com>
 <20140716074410.GF7978@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140716074410.GF7978@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:44:10AM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jul 15, 2014 at 06:24:35PM +0300, Peter De Schrijver wrote:
> > Tegra132 CAR supports almost the same clocks as Tegra124 CAR. This patch
> > deals with the small differences.
> > 
> > --
> > I'm not entirely sure why the soc_therm clock needs to be enabled on Tegra132,
> > but turning it off results in a system hang. I presume this might be because
> > of fastboot initializing soc_therm.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  drivers/clk/tegra/clk-tegra124.c |   32 ++++++++++++++++++++++++++++++++
> >  1 files changed, 32 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
> > index 80efe51..b857aab 100644
> > --- a/drivers/clk/tegra/clk-tegra124.c
> > +++ b/drivers/clk/tegra/clk-tegra124.c
> > @@ -1369,6 +1369,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
> >  	{TEGRA124_CLK_XUSB_HS_SRC, TEGRA124_CLK_PLL_U_60M, 60000000, 0},
> >  	{TEGRA124_CLK_XUSB_FALCON_SRC, TEGRA124_CLK_PLL_RE_OUT, 224000000, 0},
> >  	{TEGRA124_CLK_XUSB_HOST_SRC, TEGRA124_CLK_PLL_RE_OUT, 112000000, 0},
> > +	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 0},
> >  	/* This MUST be the last entry. */
> >  	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
> >  };
> > @@ -1378,9 +1379,25 @@ static void __init tegra124_clock_apply_init_table(void)
> >  	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
> >  }
> >  
> > +enum {
> > +	TEGRA124_CLK,
> > +	TEGRA132_CLK,
> > +};
> 
> I'd prefer this to be something like:
> 
> 	struct tegra_car_soc {
> 		bool has_ccplex_clk;
> 	};
> 
> 	static const struct tegra_car_soc tegra124_car_soc = {
> 		.has_ccplex_clk = false,
> 	};
> 
> 	static const struct tegra_car_soc tegra132_car_soc = {
> 		.has_ccplex_clk = true,
> 	};
> 
> > +static const struct of_device_id tegra_clock_of_match[] = {
> > +	{ .compatible = "nvidia,tegra124-car", .data = (void *)TEGRA124_CLK },
> 
> 	                                       .data = &tegra124_car_soc,
> 
> > +	{ .compatible = "nvidia,tegra132-car", .data = (void *)TEGRA132_CLK },
> 
> 	                                       .data = &tegra132_car_soc,
> 
> >  static void __init tegra124_clock_init(struct device_node *np)
> >  {
> >  	struct device_node *node;
> > +	const struct of_device_id *match;
> 
> 	const struct tegra_car_soc *soc;
> 
> > +	uintptr_t id;
> 
> > +	match = of_match_node(tegra_clock_of_match, np);
> > +	id = (uintptr_t)match->data;
> 
> 	soc = match->data;
> 
> >  
> >  	clk_base = of_iomap(np, 0);
> >  	if (!clk_base) {
> > @@ -1416,6 +1433,20 @@ static void __init tegra124_clock_init(struct device_node *np)
> >  	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks, &pll_a_params);
> >  	tegra_pmc_clk_init(pmc_base, tegra124_clks);
> >  
> > +	if (id == TEGRA132_CLK) {
> 
> 	if (soc->has_ccplex_clk) {
> 
> That's somewhat more explicit and avoids a lot of ugly casting.
> 

It also adds another struct + pointers to essentially store 1 bit. Which is why
I decided to go this route.

> > +		int i;
> > +
> > +		tegra124_clks[tegra_clk_cclk_g].present = false;
> > +		tegra124_clks[tegra_clk_cclk_lp].present = false;
> > +		tegra124_clks[tegra_clk_pll_x].present = false;
> > +		tegra124_clks[tegra_clk_pll_x_out0].present = false;
> > +
> > +		/* Tegra132 requires the soc_therm clock to be always on */
> > +		for (i = 0; i < ARRAY_SIZE(init_table); i++) {
> > +			if (init_table[i].clk_id == TEGRA124_CLK_SOC_THERM)
> > +				init_table[i].state = 1;
> 
> I wonder if we could do this someplace else. If we could, then we'd have
> the opportunity to make the init_table const.
> 

The easiest solution would be to turn on soc_therm for Tegra124 and Tegra132.
I don't think this would cause a measureable increase in power consumption.
If you're ok with this, this logic could just be removed. Another solution
would be to do an explicit clk_enable. PLL_P is already enabled so enabling
this clock, does not require PLL locking and could be done before udelay()
is available.

Cheers,

Peter.
