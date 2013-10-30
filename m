Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3J3WTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:19:38 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12931 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3J3WTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:19:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 30 Oct 2013 15:18:58 -0700
Date: Thu, 31 Oct 2013 00:19:32 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
Message-ID: <20131030221932.GR22111@tbergstrom-lnx.Nvidia.com>
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
 <527128B5.2020101@wwwdotorg.org>
 <1383147850.4095.3.camel@weser.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383147850.4095.3.camel@weser.hi.pengutronix.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:44:10PM +0100, Lucas Stach wrote:
> Am Mittwoch, den 30.10.2013, 09:41 -0600 schrieb Stephen Warren:
> > On 10/29/2013 06:41 PM, Peter De Schrijver wrote:
> > > Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> > > Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
> > 
> > Why? What benefit does this give, or what bug does this fix?
> > 
> > > diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> > 
> > >  	val_aux = pll_readl(pll_params->aux_reg, pll);
> > >  
> > >  	if (val & PLL_BASE_ENABLE) {
> > > -		if (!(val_aux & PLLE_AUX_PLLRE_SEL))
> > > +		if ((val_aux & PLLE_AUX_PLLRE_SEL) || (val_aux & val_aux))
> > 
> > Isn't "|| (val_aux & val_aux)" always true, at least if the value is
> > non-zero? Either this should be simply "|| val_aux", or one of those two
> > "val_aux" is the wrong thing.
> > 
> > >  			WARN(1, "pll_e enabled with unsupported parent %s\n",
> > > -			  (val & PLLE_AUX_PLLP_SEL) ? "pllp_out0" : "pll_ref");
> > > +			  (val_aux & PLLE_AUX_PLLP_SEL) ? "pllp_out0" :
> > > +					"pll_re_vco");
> > >  	} else {
> > > -		val_aux |= PLLE_AUX_PLLRE_SEL;
> > > +		val_aux &= ~(PLLE_AUX_PLLRE_SEL | PLLE_AUX_PLLP_SEL);
> > >  		pll_writel(val, pll_params->aux_reg, pll);
> > >  	}
> > 
> > > diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> > 
> > > @@ -560,6 +560,7 @@ static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
> > >  	/* PLLE special case: use cpcon field to store cml divider value */
> > >  	{336000000, 100000000, 100, 21, 16, 11},
> > >  	{312000000, 100000000, 200, 26, 24, 13},
> > > +	{12000000, 100000000, 200,  1,  24, 13},
> > 
> > Presumably this is because pll_ref is the crystal, which runs at 12MHz.
> > What if it doesn't; Tegra supports a bunch of other crystal rates. Don't
> > we need entries for all the other potential crystal rates too?
> 
> The TRM states that PCIe and thus PLLE are only supported with 12MHz
> external crystal rate.
> 

This is has been different for Tegra114 at least (where PLLE is used for USB3)

Cheers,

Peter.
