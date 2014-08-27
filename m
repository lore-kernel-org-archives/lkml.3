Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935746AbaH0Suh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:50:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58963 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935147AbaH0Suf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:50:35 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v6 3/5] RTC: RK808: add RTC driver for RK808
Date: Wed, 27 Aug 2014 20:52:19 +0200
Message-ID: <6810623.bmce33g2Ev@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409062496-12074-1-git-send-email-zyw@rock-chips.com>
References: <1409062496-12074-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Dienstag, 26. August 2014, 22:14:56 schrieb Chris Zhong:
> Adding RTC driver for supporting RTC device present inside RK808 PMIC.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> ---
> 
> Changes in v6:
> Adviced by doug
> - move RTC_READSEL setting into probe
> 
> Changes in v5:
> - fixed a bug about set_time failed
> 
> Changes in v4:
> - use &client->dev replace rk808->dev
> 
> Changes in v3: None
> Changes in v2:
> Adviced by javier.martinez
> - Add a separate clock driver, rather than in RTC driver
> 
>  drivers/rtc/Kconfig     |   10 ++
>  drivers/rtc/Makefile    |    1 +
>  drivers/rtc/rtc-rk808.c |  412
> +++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 423
> insertions(+)
>  create mode 100644 drivers/rtc/rtc-rk808.c
> 

[...]

> diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
> new file mode 100644
> index 0000000..00cd997
> --- /dev/null
> +++ b/drivers/rtc/rtc-rk808.c

[...]

> +/*
> + * We will just handle setting the frequency and make use the framework for
> + * reading the periodic interupts.
> + *
> + * @freq: Current periodic IRQ freq:
> + * bit 0: every second
> + * bit 1: every minute
> + * bit 2: every hour
> + * bit 3: every day
> + */
> +static irqreturn_t rk808_alarm_irq(int irq, void *data)
> +{
> +	struct rk808_rtc *rk808_rtc = data;
> +	struct rk808 *rk808 = rk808_rtc->rk808;
> +	struct i2c_client *client = rk808->i2c;
> +	uint32_t rtc_ctl;
> +	int ret;
> +
> +	ret = regmap_write(rk808->regmap, RK808_RTC_STATUS_REG,
> +			   RTC_STATUS_MASK);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"%s:Failed to update RTC status: %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	rtc_update_irq(rk808_rtc->rtc, 1, RTC_IRQF | RTC_AF);
> +	dev_dbg(&client->dev,
> +		 "%s:irq=%d,rtc_ctl=0x%x\n", __func__, irq, rtc_ctl);

what is rtc_ctl? It seems to be unused and its use in the dev_dbg produces:

drivers/rtc/rtc-rk808.c: In function 'rk808_alarm_irq':
drivers/rtc/rtc-rk808.c:258:2: warning: 'rtc_ctl' may be used uninitialized in this function [-Wuninitialized]


Heiko
