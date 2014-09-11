Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaIKDnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:43:24 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:41894 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185AbaIKDnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:43:23 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <a5cfeb7eb47e7668c0b116d4d7c19199>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5411196B.6000507@rock-chips.com>
Date: Thu, 11 Sep 2014 11:39:23 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>
CC: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        Sonny Rao <sonnyrao@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: RK808: Add register caching
References: <1410303964-6943-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1410303964-6943-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/10/2014 07:06 AM, Doug Anderson wrote:
> Let's define the voltatile registers (those that can't be cached) and
> enable caching.  The rk808 is accessed almost constantly with cpufreq
> so this is really nice.
>
> As measured by ftrace:
>    before this change: cpu0_set_target() => ~2200us
>    after this change:  cpu0_set_target() =>  ~500us
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/mfd/rk808.c | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
>
> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
> index 0324422..bd02150 100644
> --- a/drivers/mfd/rk808.c
> +++ b/drivers/mfd/rk808.c
> @@ -29,10 +29,40 @@ struct rk808_reg_data {
>   	int value;
>   };
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
>   static const struct regmap_config rk808_regmap_config = {
>   	.reg_bits = 8,
>   	.val_bits = 8,
>   	.max_register = RK808_IO_POL_REG,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_reg = rk808_is_volatile_reg,
>   };
>   
>   static struct resource rtc_resources[] = {
Reviewed-by: Chris Zhong <zyw@rock-chips.com>
