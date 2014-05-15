Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaEOHi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:38:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43979 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaEOHi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:38:27 -0400
Date: Thu, 15 May 2014 09:38:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Message-ID: <20140515073816.GI16662@pengutronix.de>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it's great you pick that up.

On Wed, May 14, 2014 at 03:30:52PM -0700, Soren Brinkmann wrote:
> Introduce a new API function to round a rate to the closest possible
> rate the HW clock can generate.
> In contrast to 'clk_round_rate()' which works similar, but always returns
> a frequency <= its input rate.
> 
> The code comes from Uwe and was copied from this LKML thread:
> https://lkml.org/lkml/2013/3/21/115
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> 
>  drivers/clk/clk.c   | 26 ++++++++++++++++++++++++--
>  include/linux/clk.h | 14 ++++++++++++--
>  2 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index dff0373f53c1..b715f5a9826c 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1011,8 +1011,9 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>   * @rate: the rate which is to be rounded
>   *
>   * Takes in a rate as input and rounds it to a rate that the clk can actually
> - * use which is then returned.  If clk doesn't support round_rate operation
> - * then the parent rate is returned.
> + * use and does not exceed the requested frequency, which is then returned.
> + * If clk doesn't support round_rate operation then the parent rate
> + * is returned.
>   */
>  long clk_round_rate(struct clk *clk, unsigned long rate)
>  {
> @@ -1027,6 +1028,27 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
>  EXPORT_SYMBOL_GPL(clk_round_rate);
>  
>  /**
> + * clk_round_rate_nearest - round the given rate for a clk
> + * @clk: the clk for which we are rounding a rate
> + * @rate: the rate which is to be rounded
> + *
> + * Takes in a rate as input and rounds it to the closest rate that the clk
> + * can actually use which is then returned. If clk doesn't support
> + * round_rate operation then the parent rate is returned.
> + */
> +long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> +{
> +	long lower_limit = clk_round_rate(clk, rate);
> +	long upper_limit = clk_round_rate(clk, rate + (rate - lower_limit));
> +
> +	if (rate - lower_limit < upper_limit - rate)
> +		return lower_limit;
> +	else
> +		return upper_limit;
I wanted to suggest to add some comment to describe why the calculation
works here. While trying to proove it, I noticed that this
implementation is buggy.
Consider a clock that can provide the following frequencies: 38000,
38401, 38600.

	clk_round_rate_nearest(clk, 38400)
	  lower_limit = clk_round_rate(clk, 38400) -> 38000
	  upper_limit = clk_round_rate(clk, 38800) -> 38600

	  return 38600

but 38401 would have been the better/correct answer. I think you cannot
implement clk_round_rate_nearest without iteration if you don't want to
add specific logic to the clock providers.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
