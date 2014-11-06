Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaKFRcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:32:07 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:43130 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaKFRcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:32:01 -0500
Date: Thu, 6 Nov 2014 09:31:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 2/3] PM / clock_ops: make __pm_clk_enable more generic
Message-ID: <20141106173156.GD34214@dtor-ws>
References: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
 <1415281862-23764-3-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415281862-23764-3-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:51:01PM +0200, Grygorii Strashko wrote:
> Now there are two places in code which do the same things,
> so allow __pm_clk_enable() to accept pointer on pm_clock_entry
> structure as second parameter instead of pointer on clock and
> remove duplicated code.
> 
> Also, updated function intended to be used by following patch.
> 
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Kevin Hilman <khilman@linaro.org>
> CC: Ulf Hansson <ulf.hansson@linaro.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/base/power/clock_ops.c | 38 ++++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index f061eaa..b32b5d4 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -35,14 +35,20 @@ struct pm_clock_entry {
>  /**
>   * pm_clk_enable - Enable a clock, reporting any errors
>   * @dev: The device for the given clock
> - * @clk: The clock being enabled.
> + * @ce: PM clock entry corresponding to the clock.
>   */
> -static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
> +static inline int __pm_clk_enable(struct device *dev, struct pm_clock_entry *ce)
>  {
> -	int ret = clk_enable(clk);
> -	if (ret)
> -		dev_err(dev, "%s: failed to enable clk %p, error %d\n",
> -			__func__, clk, ret);
> +	int ret;
> +
> +	if (ce->status < PCE_STATUS_ERROR) {
> +		ret = clk_enable(ce->clk);
> +		if (!ret)
> +			ce->status = PCE_STATUS_ENABLED;
> +		else
> +			dev_err(dev, "%s: failed to enable clk %p, error %d\n",
> +				__func__, ce->clk, ret);
> +	}
>  
>  	return ret;
>  }
> @@ -293,7 +299,6 @@ int pm_clk_resume(struct device *dev)
>  	struct pm_subsys_data *psd = dev_to_psd(dev);
>  	struct pm_clock_entry *ce;
>  	unsigned long flags;
> -	int ret;
>  
>  	dev_dbg(dev, "%s()\n", __func__);
>  
> @@ -302,13 +307,8 @@ int pm_clk_resume(struct device *dev)
>  
>  	spin_lock_irqsave(&psd->lock, flags);
>  
> -	list_for_each_entry(ce, &psd->clock_list, node) {
> -		if (ce->status < PCE_STATUS_ERROR) {
> -			ret = __pm_clk_enable(dev, ce->clk);
> -			if (!ret)
> -				ce->status = PCE_STATUS_ENABLED;
> -		}
> -	}
> +	list_for_each_entry(ce, &psd->clock_list, node)
> +		__pm_clk_enable(dev, ce);
>  
>  	spin_unlock_irqrestore(&psd->lock, flags);
>  
> @@ -417,7 +417,6 @@ int pm_clk_resume(struct device *dev)
>  	struct pm_subsys_data *psd = dev_to_psd(dev);
>  	struct pm_clock_entry *ce;
>  	unsigned long flags;
> -	int ret;
>  
>  	dev_dbg(dev, "%s()\n", __func__);
>  
> @@ -427,13 +426,8 @@ int pm_clk_resume(struct device *dev)
>  
>  	spin_lock_irqsave(&psd->lock, flags);
>  
> -	list_for_each_entry(ce, &psd->clock_list, node) {
> -		if (ce->status < PCE_STATUS_ERROR) {
> -			ret = __pm_clk_enable(dev, ce->clk);
> -			if (!ret)
> -				ce->status = PCE_STATUS_ENABLED;
> -		}
> -	}
> +	list_for_each_entry(ce, &psd->clock_list, node)
> +		__pm_clk_enable(dev, ce);
>  
>  	spin_unlock_irqrestore(&psd->lock, flags);
>  
> -- 
> 1.9.1
> 

-- 
Dmitry
