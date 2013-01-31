Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3AaMio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:38:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49526 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3AaMil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:38:41 -0500
Message-ID: <510A65BA.6090208@ti.com>
Date: Thu, 31 Jan 2013 13:38:18 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 2/4] pwm_backlight: Validate dft_brightness in main probe
 function
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com> <1358861996-27194-3-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1358861996-27194-3-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 01/22/2013 02:39 PM, Peter Ujfalusi wrote:
> Move the dft_brightness validity check from the DT parsing function to the
> main probe. In this way we can validate it in case we are booting with or
> without DT.

Based on the discussion the rest of the series is going to be dropped, but
what about this single patch?
I think it is still addresses a valid issue, which is that in non DT boot we
do not check if the dft_brightness is within valid range.

I can resend this patch alone since it is not going to apply on mainline as it is.

-- 
Péter

> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index f0d6854..2a81c24 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -135,12 +135,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
>  		if (ret < 0)
>  			return ret;
>  
> -		if (value >= data->max_brightness) {
> -			dev_warn(dev, "invalid default brightness level: %u, using %u\n",
> -				 value, data->max_brightness - 1);
> -			value = data->max_brightness - 1;
> -		}
> -
>  		data->dft_brightness = value;
>  	}
>  
> @@ -249,6 +243,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  		goto err_alloc;
>  	}
>  
> +	if (data->dft_brightness > data->max_brightness) {
> +		dev_warn(&pdev->dev,
> +			 "invalid default brightness level: %u, using %u\n",
> +			 data->dft_brightness, data->max_brightness);
> +		data->dft_brightness = data->max_brightness;
> +	}
>  	bl->props.brightness = data->dft_brightness;
>  	backlight_update_status(bl);
>  
> 
