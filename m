Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbbARTVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:21:40 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63135 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbARTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:21:37 -0500
Date: Sun, 18 Jan 2015 11:21:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <wxt@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] thermal: rockchip: make temperature reporting much
 more accurate
Message-ID: <20150118192133.GA15457@dtor-glaptop>
References: <1421597753-2082-1-git-send-email-wxt@rock-chips.com>
 <1421597753-2082-2-git-send-email-wxt@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421597753-2082-2-git-send-email-wxt@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:15:53AM +0800, Caesar Wang wrote:
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

I did several review this patch on the Chrome OS gerrit, so

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> 
> ---
> 
>  drivers/thermal/rockchip_thermal.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> index 1bcddfc..a7ae23a 100644
> --- a/drivers/thermal/rockchip_thermal.c
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -193,19 +193,18 @@ static u32 rk_tsadcv2_temp_to_code(long temp)
>  
>  static long rk_tsadcv2_code_to_temp(u32 code)
>  {
> -	int high, low, mid;
> -
> -	low = 0;
> -	high = ARRAY_SIZE(v2_code_table) - 1;
> -	mid = (high + low) / 2;
> +	unsigned int low = 0;
> +	unsigned int high = ARRAY_SIZE(v2_code_table) - 1;
> +	unsigned int mid = (low + high) / 2;
> +	unsigned int scale;
>  
>  	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
>  		return 125000; /* No code available, return max temperature */
>  
>  	while (low <= high) {
> -		if (code >= v2_code_table[mid].code && code <
> -		    v2_code_table[mid - 1].code)
> -			return v2_code_table[mid].temp;
> +		if (code >= v2_code_table[mid].code &&
> +		    code < v2_code_table[mid - 1].code)
> +			break;
>  		else if (code < v2_code_table[mid].code)
>  			low = mid + 1;
>  		else
> @@ -213,7 +212,16 @@ static long rk_tsadcv2_code_to_temp(u32 code)
>  		mid = (low + high) / 2;
>  	}
>  
> -	return 125000;
> +	/*
> +	 * The 5C granularity provided by the table is too much. Let's
> +	 * assume that the relationship between sensor readings and
> +	 * temperature between 2 table entries is linear and extrapolate
> +	 * to produce less granular result.
> +	 */
> +	scale = (v2_code_table[mid].temp - v2_code_table[mid - 1].temp) /
> +		(v2_code_table[mid - 1].code - v2_code_table[mid].code);
> +	return v2_code_table[mid - 1].temp +
> +			(v2_code_table[mid - 1].code - code) * scale;
>  }
>  
>  /**
> -- 
> 1.9.1
> 
> 

Thanks.

-- 
Dmitry
