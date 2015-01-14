Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbbANSAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:00:31 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:52207 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbANSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
References: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 14 Jan 2015 10:00:08 -0800
X-Google-Sender-Auth: 8doBr_Cpa_bus8NrYHmaBH4J9tU
Message-ID: <CAPz6YkW4icehT6P9EicP1Eww_Ny0hNaeS53WXaFei+HrYbPQ3A@mail.gmail.com>
Subject: Re: [PATCH] RTC: RK808: fix the rtc time reading issue
To: Chris Zhong <zyw@rock-chips.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 6:43 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> After we set the GET_TIME bit, the rtc time couldn't be read immediately,
> we should wait up to 31.25 us, about one cycle of 32khz. Otherwise reading
> RTC time will return a old time. If clear the GET_TIME bit after setting,
> the time of i2c transfer certainly more than 31.25us.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
>  drivers/rtc/rtc-rk808.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
> index df42257..8dae322 100644
> --- a/drivers/rtc/rtc-rk808.c
> +++ b/drivers/rtc/rtc-rk808.c
> @@ -67,15 +67,20 @@ static int rk808_rtc_readtime(struct device *dev, struct rtc_time *tm)
>         /* Force an update of the shadowed registers right now */
>         ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>                                  BIT_RTC_CTRL_REG_RTC_GET_TIME,
> -                                0);
> +                                BIT_RTC_CTRL_REG_RTC_GET_TIME);
>         if (ret) {
>                 dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
>                 return ret;
>         }
>
> +       /* After we set the GET_TIME bit, the rtc time couldn't be read
> +        * immediately, we should wait up to 31.25 us, about one cycle of
> +        * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
> +        * certainly more than 31.25us.
> +        */

Chris, it looks like you swapped the set and the clear of this bit,
and you're relying on the fact that the i2c transaction takes a
certain amount of time after the RTC_GET_TIME BIT is set.   I'm not
sure how long it actually takes, but why not just put in a usleep()
for the minimum wait time?

>         ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>                                  BIT_RTC_CTRL_REG_RTC_GET_TIME,
> -                                BIT_RTC_CTRL_REG_RTC_GET_TIME);
> +                                0);
>         if (ret) {
>                 dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
>                 return ret;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
