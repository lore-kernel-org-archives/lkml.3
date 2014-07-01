Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbaGAIXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:23:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45012 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbaGAIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:23:17 -0400
Date: Tue, 1 Jul 2014 10:23:02 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] clk: Introduce 'clk_find_nearest_rate()'
Message-ID: <20140701082302.GL14781@pengutronix.de>
References: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
 <1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:56:33AM -0700, Soren Brinkmann wrote:
> Introduce a new API function to find the rate a clock can provide which
> is closest to a given rate.
> 
> clk_round_rate() leaves it to the clock driver how rounding is done.
> Commonly implementations round down due to use-cases that have a certain
> frequency maximum that must not be exceeded.
> 
> The new API call enables use-cases where accuracy is preferred. E.g.
> Ethernet clocks.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> 
>  drivers/clk/clk.c   | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h |  9 +++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 8b73edef151d..fce1165cd879 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1030,6 +1030,63 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
>  EXPORT_SYMBOL_GPL(clk_round_rate);
>  
>  /**
> + * clk_find_nearest_rate - round the given rate for a clk
> + * @clk: the clk for which we are rounding a rate
> + * @rate: the rate which is to be rounded
> + *
> + * Takes in a rate as input and finds the closest rate that the clk
> + * can actually use which is then returned.
> + * Note: This function relies on the clock's clk_round_rate() implementation.
> + * For cases clk_round_rate() rounds up, not the closest but the rounded up
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
Consider rate = 0xf0000000, lower = 0x7fffffff (= LONG_MAX). Then tmp =
(unsigned long)0x160000000 = 0x60000000. In this case you pick upper =
0x60000000 while you should use upper = LONG_MAX.

I think you need

-	if (tmp > LONG_MAX)
+	if (tmp > LONG_MAX || tmp < rate)

(and a comment)

> +
> +	upper = __clk_round_rate(clk, upper);
> +	if (upper <= lower || upper < 0) {
Is it an idea to do something like:

		if (IS_ENABLED(CONFIG_CLK_SANITY_CHECKS))
			WARN_ON(upper < lower && upper >= 0);

here?

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
This is broken if you don't assume that __clk_round_rate rounds down.
Consider an implementation that already does round_nearest and clk can
assume the values 0x60000 and 0x85000 (and nothing in between), and rate
= 0x70000. This results in

	lower = 0x60000;
	tmp = 0x7ffff;
	upper = __clk_round_rate(clk, 0x7ffff) = 0x85000

before the loop and the loop then doesn't even terminate.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
