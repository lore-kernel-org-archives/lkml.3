Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaF3T1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:27:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58047 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbaF3T1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:27:17 -0400
Date: Mon, 30 Jun 2014 21:27:07 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pm@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Michal Simek <michal.simek@xilinx.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xl?= =?UTF-8?B?aW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] clk: Introduce 'clk_find_nearest_rate()'
Message-ID: <20140630212707.1eb44db6@bbrezillon>
In-Reply-To: <1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
 <1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Soren,

On Mon, 30 Jun 2014 09:56:33 -0700
Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:

> Introduce a new API function to find the rate a clock can provide
> which is closest to a given rate.
> 
> clk_round_rate() leaves it to the clock driver how rounding is done.
> Commonly implementations round down due to use-cases that have a
> certain frequency maximum that must not be exceeded.

I had the same concern (how could a driver decide whether it should
round up, down or to the closest value), but had a slightly different
approach in mind.

AFAIU, you're assuming the clock is always a power of two (which is
true most of the time, but some clock implementation might differ,
i.e. a PLL accept any kind of multiplier not necessarily a power of 2).

How about improving the clk_ops interface instead by adding a new method

	long (*round_rate_with_constraint)(struct clk_hw *hw,
					   unsigned long requested_rate,
					   unsigned long *parent_rate,
					   enum clk_round_type type);

with

enum clk_round_type {
	CLK_ROUND_DOWN,
	CLK_ROUND_UP,
	CLK_ROUND_CLOSEST,
};

or just adding these 3 methods:

	long (*round_rate_up)(struct clk_hw *hw,
			      unsigned long requested_rate,
			      unsigned long *parent_rate);

	long (*round_rate_down)(struct clk_hw *hw,
				unsigned long requested_rate,
				unsigned long *parent_rate);

	long (*round_rate_closest)(struct clk_hw *hw,
				   unsigned long requested_rate,
				   unsigned long *parent_rate);

and let the round_rate method implement the default behaviour.

This way you could add 3 functions to the API:

clk_round_closest (or clk_find_nearest_rate as you called it),
clk_round_up and clk_round_down, and let the clk driver implementation
return the appropriate rate.

These are just some thoughts...

Best Regards,

Boris

> 
> The new API call enables use-cases where accuracy is preferred. E.g.
> Ethernet clocks.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> 
>  drivers/clk/clk.c   | 57
> +++++++++++++++++++++++++++++++++++++++++++++++++++++
> include/linux/clk.h |  9 +++++++++ 2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 8b73edef151d..fce1165cd879 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1030,6 +1030,63 @@ long clk_round_rate(struct clk *clk, unsigned
> long rate) EXPORT_SYMBOL_GPL(clk_round_rate);
>  
>  /**
> + * clk_find_nearest_rate - round the given rate for a clk
> + * @clk: the clk for which we are rounding a rate
> + * @rate: the rate which is to be rounded
> + *
> + * Takes in a rate as input and finds the closest rate that the clk
> + * can actually use which is then returned.
> + * Note: This function relies on the clock's clk_round_rate()
> implementation.
> + * For cases clk_round_rate() rounds up, not the closest but the
> rounded up
> + * rate is found.
> + */
> +long clk_find_nearest_rate(struct clk *clk, unsigned long rate)
> +{
> +	long ret, lower, upper;
> +	unsigned long tmp;
> +
> +	clk_prepare_lock();
> +
> +	lower = __clk_round_rate(clk, rate);
> +	if (lower >= rate || lower < 0) {
> +		ret = lower;
> +		goto unlock;
> +	}
> +
> +	tmp = rate + (rate - lower) - 1;
> +	if (tmp > LONG_MAX)
> +		upper = LONG_MAX;
> +	else
> +		upper = tmp;
> +
> +	upper = __clk_round_rate(clk, upper);
> +	if (upper <= lower || upper < 0) {
> +		ret = lower;
> +		goto unlock;
> +	}
> +
> +	lower = rate + 1;
> +	while (lower < upper) {
> +		long rounded, mid;
> +
> +		mid = lower + ((upper - lower) >> 1);
> +		rounded = __clk_round_rate(clk, mid);
> +		if (rounded < lower)
> +			lower = mid + 1;
> +		else
> +			upper = rounded;
> +	}
> +
> +	ret = upper;
> +
> +unlock:
> +	clk_prepare_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_find_nearest_rate);
> +
> +/**
>   * __clk_notify - call clk notifier chain
>   * @clk: struct clk * that is changing rate
>   * @msg: clk notifier type (see include/linux/clk.h)
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index fb5e097d8f72..f8b53c515483 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -264,6 +264,15 @@ void devm_clk_put(struct device *dev, struct clk
> *clk); long clk_round_rate(struct clk *clk, unsigned long rate);
>  
>  /**
> + * clk_find_nearest_rate - Find nearest rate to the exact rate a
> clock can provide
> + * @clk: the clk for which we are rounding a rate
> + * @rate: the rate which is to be rounded
> + *
> + * Returns the rate closest to @rate the clock can provide.
> + */
> +long clk_find_nearest_rate(struct clk *clk, unsigned long rate);
> +
> +/**
>   * clk_set_rate - set the clock rate for a clock source
>   * @clk: clock source
>   * @rate: desired clock rate in Hz



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
