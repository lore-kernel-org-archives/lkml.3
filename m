Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaJMIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:35:14 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60029 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaJMIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:35:08 -0400
From: Max Schwarz <max.schwarz@online.de>
To: linux-rockchip@lists.infradead.org
Cc: Addy Ke <addy.ke@rock-chips.com>, wsa@the-dreams.de, heiko@sntech.de,
        olof@lixom.net, dianders@chromium.org, huangtao@rock-chips.com,
        hl@rock-chips.com, yzq@rock-chips.com, zyw@rock-chips.com,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        xjq@rock-chips.com, linux-i2c@vger.kernel.org,
        caesar.wang@rock-chips.com, cf@rock-chips.com, hj@rock-chips.com,
        zhengsq@rock-chips.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] i2c: rk3x: adjust the LOW divison based on characteristics of SCL
Date: Mon, 13 Oct 2014 10:34:36 +0200
Message-ID: <2133780.ep4AUsTpvP@typ>
User-Agent: KMail/4.14.1 (Linux/3.15.7-031507-generic; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1413168244-3553-1-git-send-email-addy.ke@rock-chips.com>
References: <1413168244-3553-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:w5Zll+LoP/UxWMSANhUnGJ1St2mYgoJaqxv1MKtEQmI
 1CoSwGGRk4km48R9eaayE+wiBNcQ1Ig3dD364BXhOLvyzmDmCO
 68Ycj1HOdd6g6rZqvMOTQynvPdXwW4ZTZwQckLzQQSqmeV17e9
 lOa0USIitcXQxpwc7StI9Uf5bb12ZqNbwyOHV7VRdPPPo1uu/4
 HRPLQ4MFF4yIjOreM+xzdbvE4YCLVEfs+XCzkiUtJgD375q+bN
 oMjK/Ipkb2/Qel/n6jkHYXZxsqvq6buY+wYM5eNH+NefzWzRRm
 T4jYJ206uOpF7J4siBg9yXE+6ywOEBeUxRXMtNZaWpvLMHs8Q=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Addy,

On Monday 13 October 2014 at 10:44:04, Addy Ke wrote:
> As show in I2C specification:
> - Standard-mode: the minimum HIGH period of the scl clock is 4.0us
>                  the minimum LOW period of the scl clock is 4.7us
> - Fast-mode: the minimum HIGH period of the scl clock is 0.6us
>              the minimum LOW period of the scl clock is 1.3us
> 
> I have measured i2c SCL waveforms in fast-mode by oscilloscope
> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
> It is so critical that we must adjust LOW division to increase
> the LOW period of the scl clock.
> 
> Thanks Doug for the suggestion about division formulas.
> 
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - remove Fast-mode plus and HS-mode
> - use new formulas suggested by Doug
> Changes in V3:
> - use new formulas (sep 30) suggested by Doug
> Changes in V4:
> - fix some wrong style
> - WARN_ONCE if min_low_div > max_low_div
> Changes in V5:
> - round up for i2c_rate and round down for scl_rate, suggested by Max
> - place a WARN_ON if scl_rate < 1000, suggested by Max
> - add div_high and div_low overflow protection, suggested by Max
> 
>  drivers/i2c/busses/i2c-rk3x.c | 161
> +++++++++++++++++++++++++++++++++++++++--- 1 file changed, 152
> insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index b41d979..a30a4fb 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -24,6 +24,7 @@
>  #include <linux/wait.h>
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
> +#include <linux/math64.h>
> 
> 
>  /* Register Map */
> @@ -428,18 +429,158 @@ out:
>  	return IRQ_HANDLED;
>  }
> 
> -static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long
> scl_rate) +static int rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned
> long scl_rate, +			       unsigned long *div_low, unsigned long 
*div_high)
>  {
> -	unsigned long i2c_rate = clk_get_rate(i2c->clk);
> -	unsigned int div;
> +	unsigned long min_low_ns, min_high_ns;
> +	unsigned long max_data_hold_ns;
> +	unsigned long data_hold_buffer_ns;
> +	unsigned long max_low_ns, min_total_ns;
> +
> +	unsigned long i2c_rate_khz, scl_rate_khz;
> +
> +	unsigned long min_low_div, min_high_div;
> +	unsigned long max_low_div;
> +
> +	unsigned long min_div_for_hold, min_total_div;
> +	unsigned long extra_div, extra_low_div, ideal_low_div;
> +
> +	/* Only support standard-mode and fast-mode */
> +	if (WARN_ON(scl_rate > 400000))
> +		scl_rate = 400000;
> +
> +	/* prevent scl_rate_khz from becoming 0 */
> +	if (WARN_ON(scl_rate < 1000))
> +		scl_rate = 1000;
> +
> +	/*
> +	 * min_low_ns:  The minimum number of ns we need to hold low
> +	 *		to meet i2c spec
> +	 * min_high_ns: The minimum number of ns we need to hold high
> +	 *		to meet i2c spec
> +	 * max_low_ns:  The maximum number of ns we can hold low
> +	 *		to meet i2c spec
> +	 *
> +	 * Note: max_low_ns should be (max data hold time * 2 - buffer)
> +	 *	 This is because the i2c host on Rockchip holds the data line
> +	 *	 for half the low time.
> +	 */
> +	if (scl_rate <= 100000) {
> +		min_low_ns = 4700;
> +		min_high_ns = 4000;
> +		max_data_hold_ns = 3450;
> +		data_hold_buffer_ns = 50;
> +	} else {
> +		min_low_ns = 1300;
> +		min_high_ns = 600;
> +		max_data_hold_ns = 900;
> +		data_hold_buffer_ns = 50;
> +	}
> +	max_low_ns = max_data_hold_ns * 2 - data_hold_buffer_ns;
> +	min_total_ns = min_low_ns + min_high_ns;
> +
> +	/* Adjust to avoid overflow */
> +	i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000);
> +	scl_rate_khz = scl_rate / 1000;
> 
> -	/* set DIV = DIVH = DIVL
> -	 * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
> -	 *          = (clk rate) / (16 * (DIV + 1))
> +	/*
> +	 * We need the total div to be >= this number
> +	 * so we don't clock too fast.
> +	 */
> +	min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);
> +
> +	/* These are the min dividers needed for min hold times. */
> +	min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000);
> +	min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000);
> +	min_div_for_hold = (min_low_div + min_high_div);
> +
> +	/*
> +	 * This is the maximum divider so we don't go over the max.
> +	 * We don't round up here (we round down) since this is a max.
>  	 */
> -	div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
> +	max_low_div = i2c_rate_khz * max_low_ns / (8 * 1000000);
> +
> +	if (min_low_div > max_low_div) {
> +		WARN_ONCE(true,
> +			  "Conflicting, min_low_div %lu, max_low_div %lu\n",
> +			  min_low_div, max_low_div);
> +		max_low_div = min_low_div;
> +	}
> +
> +	if (min_div_for_hold > min_total_div) {
> +		/*
> +		 * Time needed to meet hold requirements is important.
> +		 * Just use that.
> +		 */
> +		*div_low = min_low_div;
> +		*div_high = min_high_div;
> +	} else {
> +		/*
> +		 * We've got to distribute some time among the low and high
> +		 * so we don't run too fast.
> +		 */
> +		extra_div = min_total_div - min_div_for_hold;
> +
> +		/*
> +		 * We'll try to split things up perfectly evenly,
> +		 * biasing slightly towards having a higher div
> +		 * for low (spend more time low).
> +		 */
> +		ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
> +					     scl_rate_khz * 8 * min_total_ns);
> +
> +		/* Don't allow it to go over the max */
> +		if (ideal_low_div > max_low_div)
> +			ideal_low_div = max_low_div;
> +
> +		/*
> +		 * Handle when the ideal low div is going to take up
> +		 * more than we have.
> +		 */
> +		if (ideal_low_div > min_low_div + extra_div)
> +			ideal_low_div = min_low_div + extra_div;
> +
> +		/* Give low the "ideal" and give high whatever extra is left */
> +		extra_low_div = ideal_low_div - min_low_div;
> +		*div_low = ideal_low_div;
> +		*div_high = min_high_div + (extra_div - extra_low_div);
> +	}
> +
> +	/*
> +	* Adjust to the fact that the hardware has an implicit "+1".
> +	* NOTE: Above calculations always produce div_low > 0 and  div_high > 0.
> +	*/
> +	*div_low = *div_low - 1;
> +	*div_high = *div_high - 1;
> +
> +	if (*div_low >= 0xffff || *div_high >= 0xffff)
> +		return -EINVAL;
> +	else
> +		return 0;
> +}
> +
> +static int rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long
> scl_rate) +{
> +	unsigned long i2c_rate = clk_get_rate(i2c->clk);
> +	unsigned long div_low, div_high;
> +	u64 t_low_ns, t_high_ns;
> +	int ret = 0;
> 
> -	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
> +	ret = rk3x_i2c_calc_divs(i2c_rate, scl_rate, &div_low, &div_high);
> +	if (ret < 0)
> +		return ret;
> +
> +	i2c_writel(i2c, (div_high << 16) | (div_low & 0xffff), REG_CLKDIV);
> +
> +	t_low_ns = div_u64(((u64)div_low + 1) * 8 * 1000000000, i2c_rate);
> +	t_high_ns = div_u64(((u64)div_high + 1) * 8 * 1000000000, i2c_rate);
> +	dev_dbg(i2c->dev,
> +		"CLK %lukhz, Req %luns, Act low %lluns high %lluns\n",
> +		i2c_rate / 1000,
> +		1000000000 / scl_rate,
> +		t_low_ns, t_high_ns);
> +
> +	return ret;
>  }
> 
>  /**
> @@ -537,7 +678,9 @@ static int rk3x_i2c_xfer(struct i2c_adapter *adap,
>  	clk_enable(i2c->clk);
> 
>  	/* The clock rate might have changed, so setup the divider again */
> -	rk3x_i2c_set_scl_rate(i2c, i2c->scl_frequency);
> +	ret = rk3x_i2c_set_scl_rate(i2c, i2c->scl_frequency);
> +	if (ret < 0)
> +		return ret;

You are leaving the i2c->lock locked and the clock enabled if you return here. 
Please use goto to jump to the clk_disable(i2c->clk) at the end of the 
function.

Cheers,
  Max
