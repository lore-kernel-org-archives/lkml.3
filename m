Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3LWO2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:28:03 -0500
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:30121
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab3LWO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:28:00 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 23 Dec 2013 22:29:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <rui.zhang@intel.com>, <eduardo.valentin@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: imx: correct suspend/resume flow
Message-ID: <20131223142931.GM26070@S2101-09.ap.freescale.net>
References: <1387831918-17028-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387831918-17028-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 03:51:58PM -0500, Anson Huang wrote:
> Current imx thermal sensor's suspend function will return fail if
> thermal sensor is always enabled, but because alarm function is enabled,
> thermal sensor will be always enabled as well, hence break system's suspend,
> this patch will disable thermal sensor before suspend and re-enable it
> after resume, it fixes the failure of suspend/resume caused by thermal driver.

We should probably make it clear in the commit log that it's a
regression caused by commit 37713a1 (thermal: imx: implement thermal
alarm interrupt handling).

> 
> Signed-off-by: Anson Huang <b20788@freescale.com>
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

Is it really necessary to update data->mode through suspend/resume
cycle?

Shawn

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
> -- 
> 1.7.9.5
> 
> 

