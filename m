Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaEOO4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:56:24 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:43256 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaEOO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:56:21 -0400
Date: Thu, 15 May 2014 10:55:52 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] thermal: exynos: remove redundant threshold_code
 checks from exynos_tmu_initialize()
Message-ID: <20140515145552.GB27690@developer>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bartlomiej,

On Mon, May 05, 2014 at 01:15:35PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Remove runtime checks for negative return values of temp_to_code()
> from exynos_tmu_initialize().  The current level temperature data
> hardcoded in pdata will never cause a negative temp_to_code()
> return values and for the new code potential mistakes should be
> caught during development/review phases.
> 
> Theres should be no functional changes caused by this patch.
> 

Same question as in previous patch. Removing defensive code must
be done carefully. 

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 789d745..a415829 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -170,10 +170,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  	if (data->soc == SOC_ARCH_EXYNOS4210) {
>  		/* Write temperature code for threshold */
>  		threshold_code = temp_to_code(data, pdata->threshold);
> -		if (threshold_code < 0) {
> -			ret = threshold_code;
> -			goto out;
> -		}
>  		writeb(threshold_code,
>  			data->base + reg->threshold_temp);
>  		for (i = 0; i < trigger_levs; i++)
> @@ -187,18 +183,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
> -			if (threshold_code < 0) {
> -				ret = threshold_code;
> -				goto out;
> -			}
>  			rising_threshold |= threshold_code << 8 * i;
>  			if (pdata->threshold_falling) {
>  				threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i] -
>  						pdata->threshold_falling);
> -				if (threshold_code > 0)
> -					falling_threshold |=
> -						threshold_code << 8 * i;
> +				falling_threshold |= threshold_code << 8 * i;
>  			}
>  		}
>  
> @@ -217,10 +207,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  				(pdata->trigger_type[i] == HW_TRIP)) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
> -			if (threshold_code < 0) {
> -				ret = threshold_code;
> -				goto out;
> -			}
>  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
>  				/* 1-4 level to be assigned in th0 reg */
>  				rising_threshold |= threshold_code << 8 * i;
> -- 
> 1.8.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
