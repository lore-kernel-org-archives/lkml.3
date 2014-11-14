Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaKNHuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:50:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52158 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaKNHuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:50:09 -0500
Date: Thu, 13 Nov 2014 23:50:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 7/7] clk: Add floor and ceiling constraints to clock
 rates
Message-ID: <20141114075007.GB11808@codeaurora.org>
References: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414666135-14313-8-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414666135-14313-8-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30, Tomeu Vizoso wrote:
> @@ -2145,6 +2218,16 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
>  }
>  EXPORT_SYMBOL_GPL(__clk_register);
>  
> +static void __clk_free_clk(struct clk *clk)
> +{
> +	struct clk_core *core = clk->core;
> +
> +	hlist_del(&clk->child_node);

Does this race with aggregation in clk_core_set_rate()? I would think
we need to hold the prepare lock here so we don't traverse the list
while it's being modified?

> +	kfree(clk);
> +
> +	clk_core_set_rate(core, core->req_rate);
> +}
> +
>  /**
>   * clk_register - allocate a new clock, register it and return an opaque cookie
>   * @dev: device that is registering this clock
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index c7f258a..0d55570 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -302,6 +302,24 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
>  int clk_set_rate(struct clk *clk, unsigned long rate);
>  
>  /**
> + * clk_set_floor_rate - set a minimum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired minimum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_floor_rate(struct clk *clk, unsigned long rate);
> +
> +/**
> + * clk_set_ceiling_rate - set a maximum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired maximum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_ceiling_rate(struct clk *clk, unsigned long rate);
> +

I still don't see anything to do with clk_round_rate()? It's
possible that whatever is constrained at this user level goes
down to the hardware driver and then is rounded up or down to a
value that is outside of the constraints, in which case the
constraints did nothing besides control the value that the
hardware driver sees in the .round_rate() op. I doubt that was
intended.

I also wonder what we should do about clocks that are in the
middle of the tree (i.e. not a leaf) and have constraints set on
them. It looks like if a child of that clock can propagate rates
up to the parent that we've constrained with the per-user
constraints, those constraints won't be respected at all, leading
to a hole in the constraints.

I imagine both of these points don't matter to the emc clock
scaling patch (BTW is there some pointer to that and the usage of
these APIs?) because that is only dealing with a leaf clock that
doesn't care about clk_set_rate() being used along with
constraints and the rounding behavior doesn't violate a floor?

I'm all for having a clk_set_rate_range() API (and floor/ceiling
too), but it needs to be done much deeper in the core framework
to actually work properly. Having a range API would make all the
confusion about how a particular clock driver decides to round a
rate go away and just leave an API that sanely says the rate will
be within these bounds or an error will be returned stating it
can't be satisfied. This would be useful so we don't have a bunch
of drivers littered with code that loops on clk_round_rate() to
figure out what their hardware actually supports or having some
hard-coded frequency table per driver because the hardware can't
generate some frequency that's part of a spec (but still lies
within some acceptable tolerance!). It would also make
clk_round_rate() mostly obsolete because we know the rate is
within whatever acceptable bounds we've chosen. Eventually
clk_set_rate() could be become a small wrapper on top of
clk_set_rate_range(), constraining the rate to be exactly
whatever the clock driver returns as the rounded rate.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
