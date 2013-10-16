Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3JPPGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:06:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3630 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3JPPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:06:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 08:06:20 -0700
Date: Wed, 16 Oct 2013 18:06:19 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 02/19] clk: tegra: simplify periph clock data
Message-ID: <20131016150619.GM5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <1381848794-11761-3-git-send-email-pdeschrijver@nvidia.com>
 <525D8D7D.10301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525D8D7D.10301@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 08:46:21PM +0200, Stephen Warren wrote:
> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> > This patch determines the register bank for clock enable/disable and reset
> > based on the clock ID instead of hardcoding it in the tables describing the
> > clocks. This results in less data to be maintained in the tables, making the
> > code easier to understand. The full benefit of the change will be realized once
> > also other clocktypes will be table based.
> 
> > diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> 
> >  #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
> > -			    _clk_num, _regs, _gate_flags, _clk_id)	\
> > +			    _clk_num, _gate_flags, _clk_id)	\
> >  	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
> > -			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
> > -			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
> > -			_parents##_idx, 0)
> > +			30, MASK(2), 0, 0, 8, 1, 0, \
> > +			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
> > +			 _clk_id, _parents##_idx, 0)
> 
> Nit (since there are bugs since I know V4 is needed): If you kept
> _clk_num on the same line in that macro, the diff would be much more
> obvious. I think I said this last time.
> 
> >  	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
> >  		data = &tegra_periph_clk_list[i];
> > -		clk = tegra_clk_register_periph(data->name, data->parent_names,
> > -				data->num_parents, &data->periph,
> > -				clk_base, data->offset, data->flags);
> > +
> > +		clk = tegra_clk_register_periph(data->name,
> > +			data->parent_names, data->num_parents, &data->periph,
> > +			clk_base, data->offset, data->flags);
> >  		clks[data->clk_id] = clk;
> >  	}
> >  
> >  	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
> >  		data = &tegra_periph_nodiv_clk_list[i];
> > +
> >  		clk = tegra_clk_register_periph_nodiv(data->name,
> 
> Nit: Seems like an unrelated change, and inconsistent with the other
> loop above.
> 

Actually it makes it consistent. The previous loop added an empty line
between data = ... and tegra_clk_register_periph()

> > diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> 
> > +struct tegra_clk_periph_regs * __init get_reg_bank(int clkid)
> > +{
> > +	int reg_bank = clkid / 32;
> > +
> > +	if (reg_bank < periph_banks)
> > +		return &periph_regs[reg_bank];
> > +	else {
> > +		WARN_ON(1);
> > +		return NULL;
> > +	}
> > +}
> > +
> > +int __init tegra_clk_periph_banks(int num)
> > +{
> > +	if (num > ARRAY_SIZE(periph_regs))
> > +		return -EINVAL;
> > +
> > +	periph_banks = num;
> > +
> > +	return 0;
> > +}
> 
> Shouldn't the condition in tegra_clk_periph_banks() check against
> periph_banks rather than ARRAY_SIZE(periph_regs)? I assume the calls to

periph_banks is initialized in tegra_clk_periph_banks(), so I don't see how
that would work?

> tegra_clk_periph_banks() from tegra*_clock_init() are intended to ensure
> that periph_regs is set up correctly in this file? I wonder if
> s/tegra_clk_periph_banks/tegra_clk_validate_periph_bank_count/ isn't
> called for?

Yes. The calls are intended to ensure that the clk-tegra* files, don't
refer to register banks which don't have addresses specified. This could happen
if a wrong periph clk ID would be specified for example. In later patches
we will also allocate memory based on the number of register banks.

Cheers,

Peter.
