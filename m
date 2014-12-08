Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaLHDGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:06:32 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:60013 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaLHDGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:06:30 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <9cafd907b3f025a2d5af96f07e867703>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548515A7.9050702@rock-chips.com>
Date: Mon, 08 Dec 2014 11:06:15 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com> <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
In-Reply-To: <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/8 10:59, Addy Ke wrote:
> high_ns calculated from the low division of CLKDIV register is the sum
> of actual measured high_ns and rise_ns. The rise time which related to
> external pull-up resistor can be up to the maximum rise time in I2C spec.
> 
> In my test, if external pull-up resistor is 4.7K, rise_ns is about
> 700ns. So the actual measured high_ns is about 3900ns, which is less
> than 4000ns(the minimum high_ns in I2C spec).
> 
> To fix this bug, min_low_ns should include fall time and min_high_ns
> should include rise time too.
> 
> This patch merged the patch that Doug submitted to chromium, which
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
Sorry, see https://chromium-review.googlesource.com/#/c/232774/ not 232775
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
> +	spec allows(1000 ns for standard mode, 300 ns for fast mode) which
> +	might cause slightly slower communication.
> + - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
> +	(t(f) in the i2c0 spec).  If not specified this is assumed to be the
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
> @@ -102,6 +102,8 @@ struct rk3x_i2c {
>  
>  	/* Settings */
>  	unsigned int scl_frequency;
> +	unsigned int rise_ns;
> +	unsigned int fall_ns;
>  
>  	/* Synchronization & notification */
>  	spinlock_t lock;
> @@ -435,6 +437,8 @@ out:
>   *
>   * @clk_rate: I2C input clock rate
>   * @scl_rate: Desired SCL rate
> + * @rise_ns: How many ns it takes for signals to rise.
> + * @fall_ns: How many ns it takes for signals to fall.
>   * @div_low: Divider output for low
>   * @div_high: Divider output for high
>   *
> @@ -443,11 +447,14 @@ out:
>   * too high, we silently use the highest possible rate.
>   */
>  static int rk3x_i2c_calc_divs(unsigned long clk_rate, unsigned long scl_rate,
> +			      unsigned long rise_ns, unsigned long fall_ns,
>  			      unsigned long *div_low, unsigned long *div_high)
>  {
> +	unsigned long spec_min_low_ns, spec_min_high_ns;
> +	unsigned long spec_max_data_hold_ns;
> +	unsigned long spec_data_hold_buffer_ns;
> +
>  	unsigned long min_low_ns, min_high_ns;
> -	unsigned long max_data_hold_ns;
> -	unsigned long data_hold_buffer_ns;
>  	unsigned long max_low_ns, min_total_ns;
>  
>  	unsigned long clk_rate_khz, scl_rate_khz;
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
> -		min_low_ns = 4700;
> -		min_high_ns = 4000;
> -		max_data_hold_ns = 3450;
> -		data_hold_buffer_ns = 50;
> +		spec_min_low_ns = 4700;
> +		spec_min_high_ns = 4000;
> +		spec_max_data_hold_ns = 3450;
> +		spec_data_hold_buffer_ns = 50;
>  	} else {
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
>  	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
>  	i2c->adap.owner = THIS_MODULE;
>  	i2c->adap.algo = &rk3x_i2c_algorithm;
> 

