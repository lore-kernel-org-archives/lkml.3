Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3LaNCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 08:02:14 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:38526 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3LaNCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 08:02:12 -0500
X-Auth-Info: aoGlrqeh2T9jyxyccWghujCTrmCbGaAJYGHWwhdSPoU=
Date: Tue, 31 Dec 2013 14:02:01 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/15] clk: Add regmap core helpers for
 enable/disable/is_enabled
Message-ID: <20131231130201.GQ8064@book.gsilab.sittig.org>
Mail-Followup-To: Stephen Boyd <sboyd@codeaurora.org>,
	Mike Turquette <mturquette@linaro.org>,
	linux-arm-msm@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
 <20131224150741.GG8064@book.gsilab.sittig.org>
 <20131226193101.GH31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226193101.GH31766@codeaurora.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:31 -0800, Stephen Boyd wrote:
> 
> On 12/24, Gerhard Sittig wrote:
> > On Mon, Dec 23, 2013 at 17:12 -0800, Stephen Boyd wrote:
> > > 
> > > The clock framework already has support for simple gate clocks
> > > but if drivers want to use the gate clock functionality they need
> > > to wrap the gate clock in another struct and chain the ops by
> > > calling the gate ops from their own custom ops. Plus the gate
> > > clock implementation only supports MMIO accessors so other bus
> > > type clocks don't benefit from the potential code reuse. Add some
> > > simple regmap helpers for enable/disable/is_enabled that drivers
> > > can use as drop in replacements for their clock ops or as simple
> > > functions they call from their own custom ops. This is based on 
> > > similar helps in the regulator framework.
> > 
> > The same comment applies as to the previous version.  Is it
> > useful to introduce copies of the gate handling while the
> > difference in only in how the hardware registers get accessed?
> > 
> 
> I don't plan to use the clk-gate.c implementation because I need
> more than just a bit toggling clock. We can easily make
> clk-gate.c use these helpers if you're worried about the very
> small amount of code duplication between the two. I'd be glad to
> do that, I just didn't include it here because I don't have a use
> for it.

OK, then I simply misunderstood.  From past threads I got the
impression that your clock item was "a gate with regmap instead
of mmio for hardware access, everything else being the same".
The concerns were not so much about the size of duplicated code,
but the "quality step" in starting duplication at all.  But since
I was wrong, nevermind.


> > > --- a/include/linux/clk-provider.h
> > > +++ b/include/linux/clk-provider.h
> > > @@ -177,11 +177,21 @@ struct clk_init_data {
> > > [ ... ]
> > > @@ -447,6 +457,9 @@ struct clk *__clk_lookup(const char *name);
> > >  long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
> > >  			      unsigned long *best_parent_rate,
> > >  			      struct clk **best_parent_p);
> > > +int clk_is_enabled_regmap(struct clk_hw *hw);
> > > +int clk_enable_regmap(struct clk_hw *hw);
> > > +void clk_disable_regmap(struct clk_hw *hw);
> > 
> > Looking at the patch:  Do you expect callers to remember whether
> > a clock gate is backed by mmio or by regmap access, to call a
> > different set of routines? 
> 
> There are only regmap functions. I'm not sure where the choice
> is, but I expect the callers to know what they're doing. If you
> look at the rest of this series you'll see that I assign these
> functions directly to the clk_ops, or I call them from the
> enable/disable functions that need to do some status bit polling
> after the clock is enabled or disabled.
> 
> > Should this not be hidden behind the
> > API and be transparent after clock registration?
> 
> I don't really understand what you mean by hiding it behind the
> API? What API? If we're talking about clk_register_gate() I think
> we would need to add a clk_register_regmap_gate() function
> because the reg argument is an __iomem pointer. It doesn't look
> like it can be transparent unless that pointer is reused as an
> offset. I don't attempt to do anything about that here though
> because I don't use the clk-gate.c code.

See above, it's simple.  I misunderstood, asked (in a previous
thread), got no response, saw another submission, asked again.
Now that you told me, it's clear I got something wrong.  Thank
you for telling me what I missed before.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
