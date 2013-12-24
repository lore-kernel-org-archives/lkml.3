Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3LXDIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:08:13 -0500
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:56946
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab3LXDIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:08:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI146fI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 24 Dec 2013 11:09:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <rui.zhang@intel.com>, <eduardo.valentin@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] thermal: imx: correct suspend/resume flow
Message-ID: <20131224030946.GA3872@S2101-09.ap.freescale.net>
References: <1387896204-31754-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387896204-31754-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 09:43:24AM -0500, Anson Huang wrote:
> Fixes regression introduced by:
> 
> commit 37713a1e8e4c1a1067ad4c99296f78d3c82ed9c4
> Author: Philipp Zabel <p.zabel@pengutronix.de>
> Date:   Thu Aug 1 18:33:12 2013 +0200
> 
>     thermal: imx: implement thermal alarm interrupt handling
> 

Generally, when we quote a commit in the log, it's good enough to use
the output of 'git log --oneline' with patch subject in parentheses.

  37713a1 (thermal: imx: implement thermal alarm interrupt handling)

Anyway, Rui and Eduardo may be fine with what you put there, so

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> The commit 37713a1e8e4 makes imx thermal sensor always powered up as alarm
> function is enabled, but the suspend callback of imx thermal returns
> success only if thermal sensor is powered down, so it will always returns
> fail hence break system's suspend, this patch disables imx thermal sensor
> before suspend and re-enable it after resume.
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

