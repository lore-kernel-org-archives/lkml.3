Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbbAYB7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 20:59:10 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:56227 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbAYB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 20:59:06 -0500
MIME-Version: 1.0
In-Reply-To: <1422028154-2349-2-git-send-email-wxt@rock-chips.com>
References: <1422028154-2349-1-git-send-email-wxt@rock-chips.com> <1422028154-2349-2-git-send-email-wxt@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sun, 25 Jan 2015 09:58:45 +0800
X-Google-Sender-Auth: 9YYT9_Fm8djwkzhTymgDzgF3sW0
Message-ID: <CAGS+omC+WybjjXsX1GGKp-+-e0rDB91N10f0_iQJusMPexaXpA@mail.gmail.com>
Subject: Re: [PATCH v5] thermal: rockchip: make temperature reporting much
 more accurate
To: Caesar Wang <wxt@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:49 PM, Caesar Wang <wxt@rock-chips.com> wrote:
> In general, the kernel should report temperature readings exactly as
> reported by the hardware. The cpu / gpu thermal driver works in 5 degree
> increments,but we ought to do more accurate. The temperature will do
> linear interpolation between the entries in the table.
>
> Test= $md5sum /dev/zero &
> $while true; do grep "" /sys/class/thermal/thermal_zone[1-2]/temp;
> sleep .5; done
>
> e.g. We can get the result as follows:
>     /sys/class/thermal/thermal_zone1/temp:39994
>     /sys/class/thermal/thermal_zone2/temp:39086
>     /sys/class/thermal/thermal_zone1/temp:39994
>     /sys/class/thermal/thermal_zone2/temp:39540
>     /sys/class/thermal/thermal_zone1/temp:39540
>     /sys/class/thermal/thermal_zone2/temp:39540
>     /sys/class/thermal/thermal_zone1/temp:39540
>     /sys/class/thermal/thermal_zone2/temp:39994
>
> Signed-off-by: Caesar Wang <wxt@rock-chips.com>
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> ---
>
> Changes in v5:
> Fixed some style.
>
> Changes in v4:
> "return -EAGAIN" instead of "return rk_tsadcv2_code_to_temp(code)"
>
> Changes in v3:
> Suggested-by Daniel Kurtz,
> the check doesn't reject "code == 0xfff"
> Fixed in rk_tsadcv2_code_to_temp(u32 code)
>
> Changes in v2:
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
>  drivers/thermal/rockchip_thermal.c | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> index 1bcddfc..83bdf82 100644
> --- a/drivers/thermal/rockchip_thermal.c
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -193,19 +193,22 @@ static u32 rk_tsadcv2_temp_to_code(long temp)
>
>  static long rk_tsadcv2_code_to_temp(u32 code)
>  {
> -       int high, low, mid;
> -
> -       low = 0;
> -       high = ARRAY_SIZE(v2_code_table) - 1;
> -       mid = (high + low) / 2;
> -
> -       if (code > v2_code_table[low].code || code < v2_code_table[high].code)
> -               return 125000; /* No code available, return max temperature */
> +       unsigned int low = 0;
> +       unsigned int high = ARRAY_SIZE(v2_code_table) - 1;
> +       unsigned int mid = (low + high) / 2;
> +       unsigned int num;
> +       unsigned long denom;
> +
> +       /* Invalid code, return -EAGAIN */
> +       if (code > TSADCV2_DATA_MASK)
> +               return -EAGAIN;
>
> -       while (low <= high) {
> -               if (code >= v2_code_table[mid].code && code <
> -                   v2_code_table[mid - 1].code)
> -                       return v2_code_table[mid].temp;
> +       while (low <= high && mid) {
> +               if (code >= v2_code_table[mid].code &&
> +                   code < v2_code_table[mid - 1].code)
> +                       break;
> +               else if (code == TSADCV2_DATA_MASK)
> +                       break;

I don't think you need this check since this is v2_code_table[0].
But, it doesn't hurt, so either way, this is:

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

>                 else if (code < v2_code_table[mid].code)
>                         low = mid + 1;
>                 else
> @@ -213,7 +216,16 @@ static long rk_tsadcv2_code_to_temp(u32 code)
>                 mid = (low + high) / 2;
>         }
>
> -       return 125000;
> +       /*
> +        * The 5C granularity provided by the table is too much. Let's
> +        * assume that the relationship between sensor readings and
> +        * temperature between 2 table entries is linear and interpolate
> +        * to produce less granular result.
> +        */
> +       num = v2_code_table[mid].temp - v2_code_table[mid - 1].temp;
> +       num *= v2_code_table[mid - 1].code - code;
> +       denom = v2_code_table[mid - 1].code - v2_code_table[mid].code;
> +       return v2_code_table[mid - 1].temp + (num / denom);
>  }
>
>  /**
> --
> 1.9.1
>
>
