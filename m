Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbaLKHr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:47:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbaLKHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:47:55 -0500
Date: Thu, 11 Dec 2014 08:47:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v4] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C specification
Message-ID: <20141211074738.GL13486@pengutronix.de>
References: <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
 <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I like it now. There are only a few small nitpicks, not sure its worth
to respin if noone else has concerns. See below.

On Thu, Dec 11, 2014 at 02:00:49PM +0800, Addy Ke wrote:
> The number of clock cycles to be written into the CLKDIV register
> that determines the I2C clk high phase includes the rise time.
> So to meet the timing requirements defined in the I2C specification
> which defines the minimal time SCL has to be high, the rise time
> has to taken into account. The same applies to the low phase with
> falling time.
> 
> In my test on RK3288-Pink2 board, which is not an upstream board yet,
> if external pull-up resistor is 4.7K, rise_ns is about 700ns.
> So the measured high_ns is about 3900ns, which is less than 4000ns
> (the minimum high_ns in I2C specification for Standard-mode).
> 
> To fix this bug, min_low_ns should include fall time and min_high_ns
s/,//

> should include rise time too.
I'd skip the "too". If you want to keep it, s/time/time,/.
 
> This patch merged the patch that Doug submitted to chromium project,
AFAIK s/,//

For correctness, does this patch needs Doug's Sob?

> which can get the rise and fall times for signals from the device tree.
> This allows us to more accurately calculate timings. see:
> https://chromium-review.googlesource.com/#/c/232774/
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> [...]
> @@ -469,29 +476,33 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
> [...]
>  	if (scl_rate <= 100000) {
> -		min_low_ns = 4700;
> -		min_high_ns = 4000;
> -		max_data_hold_ns = 3450;
> -		data_hold_buffer_ns = 50;
> +		/* Standard-mode */
> +		spec_min_low_ns = 4700;
> +		spec_min_high_ns = 4000;
> +		spec_max_data_hold_ns = 3450;
> +		spec_data_hold_buffer_ns = 50;
>  	} else {
> -		min_low_ns = 1300;
> -		min_high_ns = 600;
> -		max_data_hold_ns = 900;
> -		data_hold_buffer_ns = 50;
> +		/* Fast-mode */
> +		spec_min_low_ns = 1300;
> +		spec_min_high_ns = 600;
> +		spec_max_data_hold_ns = 900;
> +		spec_data_hold_buffer_ns = 50;
The background of my question regarding data_hold_buffer_ns in the last
round was: If data_hold_buffer_ns doesn't appear in the I2C
specification, should it be renamed to spec_... ? *shrug*

>  	}
> -	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
> +	min_low_ns = spec_min_low_ns + fall_ns;
> +	min_high_ns = spec_min_high_ns + rise_ns;
> +	max_low_ns = spec_max_data_hold_ns * 2 - spec_data_hold_buffer_ns;
>  	min_total_ns = min_low_ns + min_high_ns;
>  
>  	/* Adjust to avoid overflow */
> @@ -510,8 +521,8 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
>  	min_div_for_hold = (min_low_div + min_high_div);
>  
>  	/*
> -	 * This is the maximum divider so we don't go over the max.
> -	 * We don't round up here (we round down) since this is a max.
> +	 * This is the maximum divider so we don't go over the maximum.
> +	 * We don't round up here (we round down) since this is a maximum.
>  	 */
>  	max_low_div = clk_rate_khz * max_low_ns / (8 * 1000000);
>  
> @@ -544,7 +555,7 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
>  		ideal_low_div = DIV_ROUND_UP(clk_rate_khz * min_low_ns,
>  					     scl_rate_khz * 8 * min_total_ns);
>  
> -		/* Don't allow it to go over the max */
> +		/* Don't allow it to go over the maximum */
>  		if (ideal_low_div > max_low_div)
>  			ideal_low_div = max_low_div;
>  
> @@ -588,8 +599,8 @@ static void rk3x_i2c_adapt_div(struct rk3x_i2c *i2c, unsigned long clk_rate)
>  	u64 t_low_ns, t_high_ns;
>  	int ret;
>  
> -	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, &div_low,
> -				 &div_high);
> +	ret = rk3x_i2c_calc_divs(clk_rate, i2c->scl_frequency, i2c->rise_ns,
> +				 i2c->fall_ns, &div_low, &div_high);
>  
>  	WARN_ONCE(ret != 0, "Could not reach SCL freq %u", i2c->scl_frequency);
>  
> @@ -633,9 +644,9 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
>  	switch (event) {
>  	case PRE_RATE_CHANGE:
>  		if (rk3x_i2c_calc_divs(ndata->new_rate, i2c->scl_frequency,
> -				      &div_low, &div_high) != 0) {
> +				       i2c->rise_ns, i2c->fall_ns, &div_low,
> +				       &div_high) != 0)
>  			return NOTIFY_STOP;
> -		}
>  
>  		/* scale up */
>  		if (ndata->new_rate > ndata->old_rate)
> @@ -859,6 +870,21 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
>  		i2c->scl_frequency = DEFAULT_SCL_RATE;
>  	}
>  
> +	/*
> +	 * Read rise and fall ns.
> +	 * If not, there use the default maximum from specification.
I'd write:

	Read rise and fall time from device tree. If not available use
	the default maximum timing from the specification.

(Otherwise I think the comma needs to go after "there" in your
sentence.)

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
