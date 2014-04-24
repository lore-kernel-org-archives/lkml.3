Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaDXKtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:49:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58500 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaDXKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:49:06 -0400
X-AuditID: cbfee61b-b7f766d00000646c-b1-5358ec1fb2fd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Subject: Re: [PATCH] thermal: samsung: Only update available threshold limits
Date: Thu, 24 Apr 2014 12:48:38 +0200
Message-id: <1705902.4858U1S3Zd@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1397453895-6688-1-git-send-email-tushar.behera@linaro.org>
References: <1397453895-6688-1-git-send-email-tushar.behera@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAV35NxHBBie2ylis2f+TyeLyrjls
	Fp97jzBazDi/j8niycM+Nov2v3vZHNg8Fu95yeRx59oeNo/jN7YzeXzeJBfAEsVlk5Kak1mW
	WqRvl8CVsWbeK+aCm0IVL4/yNTA+4eti5OSQEDCROPBxGhOELSZx4d56ti5GLg4hgUWMEucu
	LIZyWpgk7nRtYQWpYhOwkpjYvooRxBYR0JF4sGgvC0gRs0Avo8TnndfARgkL+Erc6bwEZHNw
	sAioSnx5aAUS5hXQlNiz9hVYiaiAp8SO7SvZQEo4BTwkjl5RBjGFBNwltkNs4hUQlPgx+R4L
	iM0sIC+xb/9UVghbR2J/6zS2CYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwcH8THoH46oGi0OMAhyMSjy8CrfCg4VYE8uKK3MPMUpwMCuJ8P55HhEsxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgXFNfNOBVbV+p6IE8xe0
	XYw537lL/vL3bRMeCJvwuv6qmcr9rHTSRxmRtQXn89Re6NdqFS2cG8hhuMPrk+/U+t+tN1id
	AhcflonveXDv4YOOM9MCnFbnu3wrE689MT/j/Ov9ai7Plf3n/5u6R0Hjp5cQz6Ovr54wZC/L
	2KNalMJ3YKbS08k6K18osRRnJBpqMRcVJwIAGClvJWICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, April 14, 2014 11:08:15 AM Tushar Behera wrote:
> Currently the threshold limits are updated in 2 stages, once for all
> software trigger levels and again for hardware trip point.
> 
> While updating the software trigger levels, it overwrites the threshold
> limit for hardware trip point thereby forcing the Exynos core to issue
> an emergency shutdown.

On what SoC type have you encountered this problem?  It doesn't seem to
happen on older SoCs (at least Exynos4210 and Exynos4x12 ones).

> Updating only the required fields in threshold register fixes this issue.

With the current code there is indeed a time window during which threshold
limit for hardware trip point is set to zero so the fix is correct.

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Based on v3.15-rc1.
> 
>  drivers/thermal/samsung/exynos_tmu.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 0d96a51..ffccc89 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -225,6 +225,8 @@ skip_calib_data:
>  			trigger_levs++;
>  	}
>  
> +	rising_threshold = readl(data->base + reg->threshold_th0);

You may move this inside "} else {" block as rising_threshold
is not used for data->soc == SOC_ARCH_EXYNOS4210 case.

Also rising_threshold initialization to zero at the beginning of
exynos_tmu_initialize() is not needed anylonger.

> +
>  	if (data->soc == SOC_ARCH_EXYNOS4210) {
>  		/* Write temperature code for threshold */
>  		threshold_code = temp_to_code(data, pdata->threshold);
> @@ -249,6 +251,7 @@ skip_calib_data:
>  				ret = threshold_code;
>  				goto out;
>  			}
> +			rising_threshold &= ~(0xff << 8 * i);
>  			rising_threshold |= threshold_code << 8 * i;
>  			if (pdata->threshold_falling) {
>  				threshold_code = temp_to_code(data,
> @@ -281,6 +284,7 @@ skip_calib_data:
>  			}
>  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
>  				/* 1-4 level to be assigned in th0 reg */
> +				rising_threshold &= ~(0xff << 8 * i);
>  				rising_threshold |= threshold_code << 8 * i;
>  				writel(rising_threshold,
>  					data->base + reg->threshold_th0);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

