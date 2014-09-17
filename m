Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaIQQKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:10:05 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45339 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbaIQQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:10:03 -0400
Date: Wed, 17 Sep 2014 09:09:58 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, Sonny Rao <sonnyrao@chromium.org>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: RK808: Add register caching
Message-ID: <20140917160958.GI30918@lee--X1>
References: <1410303964-6943-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410303964-6943-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Doug Anderson wrote:

> Let's define the voltatile registers (those that can't be cached) and
> enable caching.  The rk808 is accessed almost constantly with cpufreq
> so this is really nice.
> 
> As measured by ftrace:
>   before this change: cpu0_set_target() => ~2200us
>   after this change:  cpu0_set_target() =>  ~500us
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/rk808.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)

Applied with Chris' Reviewed-by.

> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
> index 0324422..bd02150 100644
> --- a/drivers/mfd/rk808.c
> +++ b/drivers/mfd/rk808.c
> @@ -29,10 +29,40 @@ struct rk808_reg_data {
>  	int value;
>  };
>  
> +static bool rk808_is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	/*
> +	 * Notes:
> +	 * - Technically the ROUND_30s bit makes RTC_CTRL_REG volatile, but
> +	 *   we don't use that feature.  It's better to cache.
> +	 * - It's unlikely we care that RK808_DEVCTRL_REG is volatile since
> +	 *   bits are cleared in case when we shutoff anyway, but better safe.
> +	 */
> +
> +	switch (reg) {
> +	case RK808_SECONDS_REG ... RK808_WEEKS_REG:
> +	case RK808_RTC_STATUS_REG:
> +	case RK808_VB_MON_REG:
> +	case RK808_THERMAL_REG:
> +	case RK808_DCDC_UV_STS_REG:
> +	case RK808_LDO_UV_STS_REG:
> +	case RK808_DCDC_PG_REG:
> +	case RK808_LDO_PG_REG:
> +	case RK808_DEVCTRL_REG:
> +	case RK808_INT_STS_REG1:
> +	case RK808_INT_STS_REG2:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static const struct regmap_config rk808_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  	.max_register = RK808_IO_POL_REG,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_reg = rk808_is_volatile_reg,
>  };
>  
>  static struct resource rtc_resources[] = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
