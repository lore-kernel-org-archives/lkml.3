Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaLHIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:52:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60115 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaLHIwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:52:18 -0500
Date: Mon, 8 Dec 2014 09:52:02 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        huangtao@rock-chips.com, hl@rock-chips.com, yzq@rock-chips.com,
        zyw@rock-chips.com, linux-kernel@vger.kernel.org,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, linux-i2c@vger.kernel.org,
        caesar.wang@rock-chips.com, cf@rock-chips.com, hj@rock-chips.com,
        zhengsq@rock-chips.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C spec
Message-ID: <20141208085202.GA13486@pengutronix.de>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
 <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Addy,

On Mon, Dec 08, 2014 at 10:59:49AM +0800, Addy Ke wrote:
> high_ns calculated from the low division of CLKDIV register is the sum
> of actual measured high_ns and rise_ns. The rise time which related to
I think "actual measured" is misleading here. (The driver doesn't
dermine these parameters automatically, right?)

Maybe something like the following is more correct and understandable?:

	The number of clock cycles to be written into the XYZ register
	that determines the i2c clk high phase includes the rise time.
	So to meet the timing requirements defined in the i2c
	specification which defines the minimal time SCL has to be high,
	the rise time has to taken into account. The same applies to the
	low phase with falling time.

> external pull-up resistor can be up to the maximum rise time in I2C spec.
> 
> In my test, if external pull-up resistor is 4.7K, rise_ns is about
It would be nice to point out the actual board you used (if it's a
publically available machine).

> 700ns. So the actual measured high_ns is about 3900ns, which is less
> than 4000ns(the minimum high_ns in I2C spec).
s/s(/s (/;
s/spec/specification for Standard-mode/

There are different capitalisation of i2c in the patch and the commit log. I
don't know what Wolfram prefers here, but using the same spelling
everywhere would be nice.

> To fix this bug, min_low_ns should include fall time and min_high_ns
> should include rise time too.
> 
> This patch merged the patch that Doug submitted to chromium, which
Isn't Chromium a web browser? Does it really contain i2c stuff?
I bet it's about Chromium OS.

> can get the rise and fall times for signals from the device tree.
> This allows us to more accurately calculate timings. see:
> https://chromium-review.googlesource.com/#/c/232774/
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - merged the patch that Doug submitted to chromium
> Changes in v3:
> - merged the patch that Doug submitted to chromium to change bindins
>   see: https://chromium-review.googlesource.com/#/c/232775/
> 
>  Documentation/devicetree/bindings/i2c/i2c-rk3x.txt | 11 +++++
>  drivers/i2c/busses/i2c-rk3x.c                      | 57 +++++++++++++++-------
>  2 files changed, 50 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> index dde6c22..925d6eb 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> @@ -21,6 +21,14 @@ Required on RK3066, RK3188 :
>  Optional properties :
>  
>   - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.
> + - i2c-scl-rising-time-ns : Number of nanoseconds the signal takes to rise
> +	(t(r) in i2c spec). If not specified this is assumed to be the max the
s/spec/specification/; s/max/maximum/

> +	spec allows(1000 ns for standard mode, 300 ns for fast mode) which
s/s(/s (/; s/standard mode/Standard-mode/; s/fast mode/Fast-mode/;


> +	might cause slightly slower communication.
> + - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
> +	(t(f) in the i2c0 spec).  If not specified this is assumed to be the
s/i2c0/i2c/

> +	max the spec allows (300 ns) which might cause slightly slower
> +	communication.
>  
>  Example:
>  
> @@ -39,4 +47,7 @@ i2c0: i2c@2002d000 {
>  
>  	clock-names = "i2c";
>  	clocks = <&cru PCLK_I2C0>;
> +
> +	i2c-scl-rising-time-ns = <800>;
> +	i2c-scl-falling-time-ns = <100>;
>  };
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index 0ee5802..50c1678 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -470,28 +477,30 @@ static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
>  
>  	/*
>  	 * min_low_ns:  The minimum number of ns we need to hold low
> -	 *		to meet i2c spec
> +	 *		to meet i2c spec, should include fall time.
>  	 * min_high_ns: The minimum number of ns we need to hold high
> -	 *		to meet i2c spec
> +	 *		to meet i2c spec, should include rise time.
>  	 * max_low_ns:  The maximum number of ns we can hold low
> -	 *		to meet i2c spec
> +	 *		to meet i2c spec.
>  	 *
>  	 * Note: max_low_ns should be (max data hold time * 2 - buffer)
>  	 *	 This is because the i2c host on Rockchip holds the data line
>  	 *	 for half the low time.
>  	 */
>  	if (scl_rate <= 100000) {
		/* Standard-mode */
> -		min_low_ns = 4700;
> -		min_high_ns = 4000;
> -		max_data_hold_ns = 3450;
> -		data_hold_buffer_ns = 50;
> +		spec_min_low_ns = 4700;
> +		spec_min_high_ns = 4000;
> +		spec_max_data_hold_ns = 3450;
The specification calls this "data valid time" (t_(VD;DAT)).
> +		spec_data_hold_buffer_ns = 50;
I didn't find this parameter in the spec, also it doesn't differ for
Standard-mode vs. Fast-mode. What is this?

>  	} else {
		/* Fast-mode */
> -		min_low_ns = 1300;
> -		min_high_ns = 600;
> -		max_data_hold_ns = 900;
> -		data_hold_buffer_ns = 50;
> +		spec_min_low_ns = 1300;
> +		spec_min_high_ns = 600;
> +		spec_max_data_hold_ns = 900;
> +		spec_data_hold_buffer_ns = 50;
>  	}
> -	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
> +	min_low_ns = spec_min_low_ns + fall_ns;
> +	min_high_ns = spec_min_high_ns + rise_ns;
> +	max_low_ns = spec_max_data_hold_ns * 2 - spec_data_hold_buffer_ns;
>  	min_total_ns = min_low_ns + min_high_ns;
>  
>  	/* Adjust to avoid overflow */
> @@ -588,8 +597,8 @@ static void rk3x_i2c_adapt_div(struct rk3x_i2c *i2c, unsigned long clk_rate)
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
> @@ -633,9 +642,9 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
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
> @@ -859,6 +868,18 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
>  		i2c->scl_frequency = DEFAULT_SCL_RATE;
>  	}
>  
> +	/* Read rise and fall ns; if not there use the default max from spec */
> +	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time-ns",
> +				 &i2c->rise_ns)) {
> +		if (i2c->scl_frequency <= 100000)
> +			i2c->rise_ns = 1000;
> +		else
> +			i2c->rise_ns = 300;
> +	}
> +	if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-time-ns",
> +				 &i2c->fall_ns))
> +		i2c->fall_ns = 300;
> +
I don't know if other drivers do the same (I assume they should). If so,
moving this logic into the core would be nice. I guess this can still be
done later.

The i2c specification also has a minimum for t(r) and t(f). I don't know
why these are limited, but I think it would be good to check for these
limits, too.

>  	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
>  	i2c->adap.owner = THIS_MODULE;
>  	i2c->adap.algo = &rk3x_i2c_algorithm;

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
