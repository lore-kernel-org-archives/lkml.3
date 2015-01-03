Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbbACRyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 12:54:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45106 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbbACRyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 12:54:19 -0500
Date: Sat, 3 Jan 2015 11:53:46 -0600
From: Nishanth Menon <nm@ti.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Kevin Hilman <khilman@kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: avs: smartreflex:  Remove unused function
Message-ID: <20150103175346.GB20341@kahuna>
References: <1420300731-8910-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420300731-8910-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:58-20150103, Rickard Strandqvist wrote:
> Remove the function sr_configure_minmax() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/power/avs/smartreflex.c   |   86 -------------------------------------
>  include/linux/power/smartreflex.h |    1 -
>  2 files changed, 87 deletions(-)
> 
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index db9973b..62b8351 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -460,92 +460,6 @@ int sr_disable_errgen(struct omap_sr *sr)
>  }
>  
>  /**
> - * sr_configure_minmax() - Configures the SmartReflex to perform AVS using the
> - *			 minmaxavg module.
> - * @sr:			SR module to be configured.
> - *
> - * This API is to be called from the smartreflex class driver to
> - * configure the minmaxavg module inside the smartreflex module.
> - * SR settings if using the ERROR module inside Smartreflex.
> - * SR CLASS 3 by default uses only the ERROR module where as
> - * SR CLASS 2 can choose between ERROR module and MINMAXAVG
> - * module. Returns 0 on success and error value in case of failure.
> - */
> -int sr_configure_minmax(struct omap_sr *sr)
> -{
> -	u32 sr_config, sr_avgwt;
> -	u32 senp_en = 0, senn_en = 0;
> -	u8 senp_shift, senn_shift;
> -
> -	if (!sr) {
> -		pr_warn("%s: NULL omap_sr from %pF\n", __func__,
> -			(void *)_RET_IP_);
> -		return -EINVAL;
> -	}
> -
> -	if (!sr->clk_length)
> -		sr_set_clk_length(sr);
> -
> -	senp_en = sr->senp_mod;
> -	senn_en = sr->senn_mod;
> -
> -	sr_config = (sr->clk_length << SRCONFIG_SRCLKLENGTH_SHIFT) |
> -		SRCONFIG_SENENABLE |
> -		(sr->accum_data << SRCONFIG_ACCUMDATA_SHIFT);
> -
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		sr_config |= SRCONFIG_DELAYCTRL;
> -		senn_shift = SRCONFIG_SENNENABLE_V1_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V1_SHIFT;
> -		break;
> -	case SR_TYPE_V2:
> -		senn_shift = SRCONFIG_SENNENABLE_V2_SHIFT;
> -		senp_shift = SRCONFIG_SENPENABLE_V2_SHIFT;
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	sr_config |= ((senn_en << senn_shift) | (senp_en << senp_shift));
> -	sr_write_reg(sr, SRCONFIG, sr_config);
> -	sr_avgwt = (sr->senp_avgweight << AVGWEIGHT_SENPAVGWEIGHT_SHIFT) |
> -		(sr->senn_avgweight << AVGWEIGHT_SENNAVGWEIGHT_SHIFT);
> -	sr_write_reg(sr, AVGWEIGHT, sr_avgwt);
> -
> -	/*
> -	 * Enabling the interrupts if MINMAXAVG module is used.
> -	 * TODO: check if all the interrupts are mandatory
> -	 */
> -	switch (sr->ip_type) {
> -	case SR_TYPE_V1:
> -		sr_modify_reg(sr, ERRCONFIG_V1,
> -			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUVALIDINTEN |
> -			ERRCONFIG_MCUBOUNDINTEN),
> -			(ERRCONFIG_MCUACCUMINTEN | ERRCONFIG_MCUACCUMINTST |
> -			 ERRCONFIG_MCUVALIDINTEN | ERRCONFIG_MCUVALIDINTST |
> -			 ERRCONFIG_MCUBOUNDINTEN | ERRCONFIG_MCUBOUNDINTST));
> -		break;
> -	case SR_TYPE_V2:
> -		sr_write_reg(sr, IRQSTATUS,
> -			IRQSTATUS_MCUACCUMINT | IRQSTATUS_MCVALIDINT |
> -			IRQSTATUS_MCBOUNDSINT | IRQSTATUS_MCUDISABLEACKINT);
> -		sr_write_reg(sr, IRQENABLE_SET,
> -			IRQENABLE_MCUACCUMINT | IRQENABLE_MCUVALIDINT |
> -			IRQENABLE_MCUBOUNDSINT | IRQENABLE_MCUDISABLEACKINT);
> -		break;
> -	default:
> -		dev_err(&sr->pdev->dev, "%s: Trying to Configure smartreflex"
> -			"module without specifying the ip\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
>   * sr_enable() - Enables the smartreflex module.
>   * @sr:		pointer to which the SR module to be configured belongs to.
>   * @volt:	The voltage at which the Voltage domain associated with
> diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
> index d8b187c3..ffd31af 100644
> --- a/include/linux/power/smartreflex.h
> +++ b/include/linux/power/smartreflex.h
> @@ -303,7 +303,6 @@ int sr_enable(struct omap_sr *sr, unsigned long volt);
>  void sr_disable(struct omap_sr *sr);
>  int sr_configure_errgen(struct omap_sr *sr);
>  int sr_disable_errgen(struct omap_sr *sr);
> -int sr_configure_minmax(struct omap_sr *sr);
>  
>  /* API to register the smartreflex class driver with the smartreflex driver */
>  int sr_register_class(struct omap_sr_class_data *class_data);
> -- 
> 1.7.10.4
>

This is potentially used by downstream drivers which are pending cleanup
of remaining OMAP infrastructure since the transition from hwmod to
devicetree has multiple impact including the conversion of vc/vp back
into devicetree supported world (proper regulator framework). while we
can throw away code by looking at a specific snapshot, it might just
confuse the future transition.

-- 
Regards,
Nishanth Menon
