Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbaABCCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:02:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:17024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaABCCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="scan'208";a="452526318"
Message-ID: <1388628111.3739.68.camel@rzhang1-mobl4>
Subject: Re: [PATCH V2] thermal: imx: correct suspend/resume flow
From: Zhang Rui <rui.zhang@intel.com>
To: Anson Huang <b20788@freescale.com>
Cc: shawn.guo@linaro.org, eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Jan 2014 10:01:51 +0800
In-Reply-To: <1387896204-31754-1-git-send-email-b20788@freescale.com>
References: <1387896204-31754-1-git-send-email-b20788@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 09:43 -0500, Anson Huang wrote:
> Fixes regression introduced by:
> 
> commit 37713a1e8e4c1a1067ad4c99296f78d3c82ed9c4
> Author: Philipp Zabel <p.zabel@pengutronix.de>
> Date:   Thu Aug 1 18:33:12 2013 +0200
> 
>     thermal: imx: implement thermal alarm interrupt handling
> 
> The commit 37713a1e8e4 makes imx thermal sensor always powered up as alarm
> function is enabled, but the suspend callback of imx thermal returns
> success only if thermal sensor is powered down, so it will always returns
> fail hence break system's suspend, this patch disables imx thermal sensor
> before suspend and re-enable it after resume.
> 
> Signed-off-by: Anson Huang <b20788@freescale.com>

applied. BTW, this should also be a stable material for 3.12, right?

thanks,
rui
> ---
>  drivers/thermal/imx_thermal.c |   31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index cbb16f3..9a9a6c2 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -510,27 +510,30 @@ static int imx_thermal_suspend(struct device *dev)
>  {
>  	struct imx_thermal_data *data = dev_get_drvdata(dev);
>  	struct regmap *map = data->tempmon;
> -	u32 val;
>  
> -	regmap_read(map, TEMPSENSE0, &val);
> -	if ((val & TEMPSENSE0_POWER_DOWN) == 0) {
> -		/*
> -		 * If a measurement is taking place, wait for a long enough
> -		 * time for it to finish, and then check again.  If it still
> -		 * does not finish, something must go wrong.
> -		 */
> -		udelay(50);
> -		regmap_read(map, TEMPSENSE0, &val);
> -		if ((val & TEMPSENSE0_POWER_DOWN) == 0)
> -			return -ETIMEDOUT;
> -	}
> +	/*
> +	 * Need to disable thermal sensor, otherwise, when thermal core
> +	 * try to get temperature before thermal sensor resume, a wrong
> +	 * temperature will be read as the thermal sensor is powered
> +	 * down.
> +	 */
> +	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
> +	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
> +	data->mode = THERMAL_DEVICE_DISABLED;
>  
>  	return 0;
>  }
>  
>  static int imx_thermal_resume(struct device *dev)
>  {
> -	/* Nothing to do for now */
> +	struct imx_thermal_data *data = dev_get_drvdata(dev);
> +	struct regmap *map = data->tempmon;
> +
> +	/* Enabled thermal sensor after resume */
> +	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
> +	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
> +	data->mode = THERMAL_DEVICE_ENABLED;
> +
>  	return 0;
>  }
>  #endif


