Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaKFRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:31:36 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:58285 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:31:33 -0500
Date: Thu, 6 Nov 2014 09:31:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 1/3] PM / clock_ops: Add pm_clk_add_clk()
Message-ID: <20141106173128.GC34214@dtor-ws>
References: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
 <1415281862-23764-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415281862-23764-2-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:51:00PM +0200, Grygorii Strashko wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> The existing pm_clk_add() allows to pass a clock by con_id. However,
> when referring to a specific clock from DT, no con_id is available.
> 
> Add pm_clk_add_clk(), which allows to specify the struct clk * directly.
> The will will increment refcount on clock pointer, so the caller has
> to use clk_put() on clock pointer when done.
> 
> CC: Ulf Hansson <ulf.hansson@linaro.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/base/power/clock_ops.c | 47 +++++++++++++++++++++++++++++++++---------
>  include/linux/pm_clock.h       |  8 +++++++
>  2 files changed, 45 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index 7836930..f061eaa 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -12,6 +12,7 @@
>  #include <linux/pm.h>
>  #include <linux/pm_clock.h>
>  #include <linux/clk.h>
> +#include <linux/clkdev.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  
> @@ -53,7 +54,8 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
>   */
>  static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
>  {
> -	ce->clk = clk_get(dev, ce->con_id);
> +	if (!ce->clk)
> +		ce->clk = clk_get(dev, ce->con_id);
>  	if (IS_ERR(ce->clk)) {
>  		ce->status = PCE_STATUS_ERROR;
>  	} else {
> @@ -63,15 +65,8 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
>  	}
>  }
>  
> -/**
> - * pm_clk_add - Start using a device clock for power management.
> - * @dev: Device whose clock is going to be used for power management.
> - * @con_id: Connection ID of the clock.
> - *
> - * Add the clock represented by @con_id to the list of clocks used for
> - * the power management of @dev.
> - */
> -int pm_clk_add(struct device *dev, const char *con_id)
> +static int __pm_clk_add(struct device *dev, const char *con_id,
> +			struct clk *clk)
>  {
>  	struct pm_subsys_data *psd = dev_to_psd(dev);
>  	struct pm_clock_entry *ce;
> @@ -93,6 +88,12 @@ int pm_clk_add(struct device *dev, const char *con_id)
>  			kfree(ce);
>  			return -ENOMEM;
>  		}
> +	} else {
> +		if (IS_ERR(ce->clk) || !__clk_get(clk)) {
> +			kfree(ce);
> +			return -ENOENT;
> +		}
> +		ce->clk = clk;
>  	}
>  
>  	pm_clk_acquire(dev, ce);
> @@ -104,6 +105,32 @@ int pm_clk_add(struct device *dev, const char *con_id)
>  }
>  
>  /**
> + * pm_clk_add - Start using a device clock for power management.
> + * @dev: Device whose clock is going to be used for power management.
> + * @con_id: Connection ID of the clock.
> + *
> + * Add the clock represented by @con_id to the list of clocks used for
> + * the power management of @dev.
> + */
> +int pm_clk_add(struct device *dev, const char *con_id)
> +{
> +	return __pm_clk_add(dev, con_id, NULL);
> +}
> +
> +/**
> + * pm_clk_add_clk - Start using a device clock for power management.
> + * @dev: Device whose clock is going to be used for power management.
> + * @clk: Clock pointer
> + *
> + * Add the clock to the list of clocks used for the power management of @dev.
> + * It will increment refcount on clock pointer, use clk_put() on it when done.
> + */
> +int pm_clk_add_clk(struct device *dev, struct clk *clk)
> +{
> +	return __pm_clk_add(dev, NULL, clk);
> +}
> +
> +/**
>   * __pm_clk_remove - Destroy PM clock entry.
>   * @ce: PM clock entry to destroy.
>   */
> diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
> index 8348866..0b00396 100644
> --- a/include/linux/pm_clock.h
> +++ b/include/linux/pm_clock.h
> @@ -18,6 +18,8 @@ struct pm_clk_notifier_block {
>  	char *con_ids[];
>  };
>  
> +struct clk;
> +
>  #ifdef CONFIG_PM_CLK
>  static inline bool pm_clk_no_clocks(struct device *dev)
>  {
> @@ -29,6 +31,7 @@ extern void pm_clk_init(struct device *dev);
>  extern int pm_clk_create(struct device *dev);
>  extern void pm_clk_destroy(struct device *dev);
>  extern int pm_clk_add(struct device *dev, const char *con_id);
> +extern int pm_clk_add_clk(struct device *dev, struct clk *clk);
>  extern void pm_clk_remove(struct device *dev, const char *con_id);
>  extern int pm_clk_suspend(struct device *dev);
>  extern int pm_clk_resume(struct device *dev);
> @@ -51,6 +54,11 @@ static inline int pm_clk_add(struct device *dev, const char *con_id)
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int pm_clk_add_clk(struct device *dev, struct clk *clk)
> +{
> +	return -EINVAL;
> +}
>  static inline void pm_clk_remove(struct device *dev, const char *con_id)
>  {
>  }
> -- 
> 1.9.1
> 

-- 
Dmitry
