Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaDBI1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:27:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16494 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaDBI1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:27:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Apr 2014 01:22:31 -0700
Date: Wed, 2 Apr 2014 11:26:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Fix PLLE programming
Message-ID: <20140402082642.GM2931@tbergstrom-lnx.Nvidia.com>
References: <1396277142-18292-1-git-send-email-thierry.reding@gmail.com>
 <53399D1A.4070301@wwwdotorg.org> <20140331194612.GC3431@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140331194612.GC3431@mithrandir>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:46:22PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Mar 31, 2014 at 10:51:38AM -0600, Stephen Warren wrote:
> > On 03/31/2014 08:45 AM, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > PLLE has M, N and P divider shift and width parameters that differ from
> > > the defaults. Furthermore, when clearing the M, N and P divider fields
> > > the corresponding masks were never shifted, thereby clearing only the
> > > lowest bits of the register. This lead to a situation where the PLLE
> > > programming would only work if the register hadn't been touched before.
> > 
> > > diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> > 
> > > @@ -730,8 +730,10 @@ static int clk_plle_enable(struct clk_hw *hw)
> > >  	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
> > >  		/* configure dividers */
> > >  		val = pll_readl_base(pll);
> > > -		val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
> > > -		val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
> > > +		val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
> > > +			 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
> > > +			 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
> > 
> > Shouldn't those shift values also be a macro/inline like
> > divm_shift(pll), since ...
> > 
> > > +static struct div_nmp pll_e_nmp = {
> > > +	.divn_shift = PLLE_BASE_DIVN_SHIFT,
> > > +	.divn_width = PLLE_BASE_DIVN_WIDTH,
> > > +	.divm_shift = PLLE_BASE_DIVM_SHIFT,
> > > +	.divm_width = PLLE_BASE_DIVM_WIDTH,
> > > +	.divp_shift = PLLE_BASE_DIVP_SHIFT,
> > > +	.divp_width = PLLE_BASE_DIVP_WIDTH,
> > > +};
> > 
> > ... that table contains parameters for both width and shift values, not
> > just width values?
> 
> Yes, that could be done. At some point I was also thinking about simply
> converting the masks to be shifted masks, but then realized that the
> patche would become rather intrusive.
> 
> Perhaps, though, to make the code slightly more terse, in addition to
> div{n,m,p}_shift() macros I could add div{n,m,p}_mask_shifted() macros
> as well to combine both.
> 

Problem is that there are 2 shift values in case the PLL has an override bit.
The corresponding PMC register is not always layed out in the same way than
the CAR register.

Cheers,

Peter.
