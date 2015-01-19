Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbASL4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:56:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:39110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbbASL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:56:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,426,1418112000"; 
   d="scan'208";a="672187354"
Date: Mon, 19 Jan 2015 13:56:50 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: fractional-divider: prevent division by zero
Message-ID: <20150119115650.GB21244@kuha.fi.intel.com>
References: <1421411870-115195-1-git-send-email-heikki.krogerus@linux.intel.com>
 <54B990B9.2020702@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B990B9.2020702@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:29:13PM -0800, Stephen Boyd wrote:
> On 01/16/2015 04:37 AM, Heikki Krogerus wrote:
> > Preventing division by zero condition by making sure that
> > the initial n and m values are not 0.
> >
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/clk/clk-fractional-divider.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
> > index 82a59d0..dc91da7 100644
> > --- a/drivers/clk/clk-fractional-divider.c
> > +++ b/drivers/clk/clk-fractional-divider.c
> > @@ -104,6 +104,7 @@ struct clk *clk_register_fractional_divider(struct device *dev,
> >  	struct clk_fractional_divider *fd;
> >  	struct clk_init_data init;
> >  	struct clk *clk;
> > +	u32 val;
> >  
> >  	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
> >  	if (!fd) {
> > @@ -126,6 +127,14 @@ struct clk *clk_register_fractional_divider(struct device *dev,
> >  	fd->lock = lock;
> >  	fd->hw.init = &init;
> >  
> > +	/* Prevent division by zero */
> > +	val = clk_readl(fd->reg);
> > +	if (!(val & fd->nmask))
> > +		val |= 1 << fd->nshift;
> > +	if (!(val & fd->mmask))
> > +		val |= 1 << fd->mshift;
> > +	clk_writel(val, fd->reg);
> > +
> >  	clk = clk_register(dev, &fd->hw);
> >  	if (IS_ERR(clk))
> >  		kfree(fd);
> 
> Sorry I don't understand this at all. Does your hardware support a value
> of 0 in the register? Doesn't that mean "bypass" so that the rate of the
> parent bypasses the divider? If so, why aren't we fixing the
> recalc_rate() logic to check for a special case of 0?

OK. Makes sense.

-- 
heikki
