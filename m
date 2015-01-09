Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbbAIN5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:57:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38622 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbbAIN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:57:35 -0500
Message-ID: <54AFDE4A.2000205@ti.com>
Date: Fri, 9 Jan 2015 19:27:30 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] phy: ti-pipe3: Disable clocks on system suspend
References: <1418990720-3638-1-git-send-email-rogerq@ti.com> <1418990720-3638-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1418990720-3638-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Friday 19 December 2014 05:35 PM, Roger Quadros wrote:
> On system suspend, the runtime_suspend() driver hook doesn't get
> called and so the clocks are not disabled in the driver.
> This causes the L3INIT_960M_GFCLK and L3INIT_480M_GFCLK to remain
> active on the DRA7 platform while in system suspend.
> 
> Add suspend/resume hooks to the driver.
> In case of pcie-phy, the runtime_suspend hook gets called after

This contradicts with the first line of your commit message. Is pcie-phy driver
is an exception?

Thanks
Kishon

> the suspend hook so we introduce a flag phy->enabled to keep
> track if our clocks are enabled or not to prevent multiple
> enable/disables.
> 
> Move enabling/disabling clock code into helper functions.
> 
> Reported-by: Nishant Menon <nm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/phy/phy-ti-pipe3.c | 99 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 77 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
> index 1387b4d..e60ff14 100644
> --- a/drivers/phy/phy-ti-pipe3.c
> +++ b/drivers/phy/phy-ti-pipe3.c
> @@ -28,6 +28,7 @@
>  #include <linux/delay.h>
>  #include <linux/phy/omap_control_phy.h>
>  #include <linux/of_platform.h>
> +#include <linux/spinlock.h>
>  
>  #define	PLL_STATUS		0x00000004
>  #define	PLL_GO			0x00000008
> @@ -83,6 +84,8 @@ struct ti_pipe3 {
>  	struct clk		*div_clk;
>  	struct pipe3_dpll_map	*dpll_map;
>  	u8			id;
> +	bool enabled;
> +	spinlock_t lock;	/* serialize clock enable/disable */
>  };
>  
>  static struct pipe3_dpll_map dpll_map_usb[] = {
> @@ -303,6 +306,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	phy->dev		= &pdev->dev;
> +	spin_lock_init(&phy->lock);
>  
>  	if (!of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
>  		match = of_match_device(of_match_ptr(ti_pipe3_id_table),
> @@ -425,24 +429,14 @@ static int ti_pipe3_remove(struct platform_device *pdev)
>  
>  #ifdef CONFIG_PM
>  
> -static int ti_pipe3_runtime_suspend(struct device *dev)
> +static int ti_pipe3_enable_clocks(struct ti_pipe3 *phy)
>  {
> -	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> -
> -	if (!IS_ERR(phy->wkupclk))
> -		clk_disable_unprepare(phy->wkupclk);
> -	if (!IS_ERR(phy->refclk))
> -		clk_disable_unprepare(phy->refclk);
> -	if (!IS_ERR(phy->div_clk))
> -		clk_disable_unprepare(phy->div_clk);
> -
> -	return 0;
> -}
> +	int ret = 0;
> +	unsigned long flags;
>  
> -static int ti_pipe3_runtime_resume(struct device *dev)
> -{
> -	u32 ret = 0;
> -	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> +	spin_lock_irqsave(&phy->lock, flags);
> +	if (phy->enabled)
> +		goto err1;
>  
>  	if (!IS_ERR(phy->refclk)) {
>  		ret = clk_prepare_enable(phy->refclk);
> @@ -467,6 +461,9 @@ static int ti_pipe3_runtime_resume(struct device *dev)
>  			goto err3;
>  		}
>  	}
> +
> +	phy->enabled = true;
> +	spin_unlock_irqrestore(&phy->lock, flags);
>  	return 0;
>  
>  err3:
> @@ -478,19 +475,77 @@ err2:
>  		clk_disable_unprepare(phy->refclk);
>  
>  err1:
> +	spin_unlock_irqrestore(&phy->lock, flags);
> +	return ret;
> +}
> +
> +static void ti_pipe3_disable_clocks(struct ti_pipe3 *phy)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&phy->lock, flags);
> +	if (!phy->enabled) {
> +		spin_unlock_irqrestore(&phy->lock, flags);
> +		return;
> +	}
> +
> +	if (!IS_ERR(phy->wkupclk))
> +		clk_disable_unprepare(phy->wkupclk);
> +	if (!IS_ERR(phy->refclk))
> +		clk_disable_unprepare(phy->refclk);
> +	if (!IS_ERR(phy->div_clk))
> +		clk_disable_unprepare(phy->div_clk);
> +	phy->enabled = false;
> +	spin_unlock_irqrestore(&phy->lock, flags);
> +}
> +
> +static int ti_pipe3_runtime_suspend(struct device *dev)
> +{
> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> +
> +	ti_pipe3_disable_clocks(phy);
> +	return 0;
> +}
> +
> +static int ti_pipe3_runtime_resume(struct device *dev)
> +{
> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = ti_pipe3_enable_clocks(phy);
>  	return ret;
>  }
>  
> +static int ti_pipe3_suspend(struct device *dev)
> +{
> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> +
> +	ti_pipe3_disable_clocks(phy);
> +	return 0;
> +}
> +
> +static int ti_pipe3_resume(struct device *dev)
> +{
> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = ti_pipe3_enable_clocks(phy);
> +	if (ret)
> +		return ret;
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +	return 0;
> +}
> +#endif
> +
>  static const struct dev_pm_ops ti_pipe3_pm_ops = {
>  	SET_RUNTIME_PM_OPS(ti_pipe3_runtime_suspend,
>  			   ti_pipe3_runtime_resume, NULL)
> +	SET_SYSTEM_SLEEP_PM_OPS(ti_pipe3_suspend, ti_pipe3_resume)
>  };
>  
> -#define DEV_PM_OPS     (&ti_pipe3_pm_ops)
> -#else
> -#define DEV_PM_OPS     NULL
> -#endif
> -
>  #ifdef CONFIG_OF
>  static const struct of_device_id ti_pipe3_id_table[] = {
>  	{
> @@ -518,7 +573,7 @@ static struct platform_driver ti_pipe3_driver = {
>  	.remove		= ti_pipe3_remove,
>  	.driver		= {
>  		.name	= "ti-pipe3",
> -		.pm	= DEV_PM_OPS,
> +		.pm	= &ti_pipe3_pm_ops,
>  		.of_match_table = of_match_ptr(ti_pipe3_id_table),
>  	},
>  };
> 
