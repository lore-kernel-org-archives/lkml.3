Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaIWQKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:10:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36280 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaIWQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:10:03 -0400
Date: Tue, 23 Sep 2014 09:09:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: imx2_wdt: Add power management support.
Message-ID: <20140923160957.GB20591@roeck-us.net>
References: <1411475513-2576-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411475513-2576-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:31:53PM +0800, Xiubo Li wrote:
> Add power management operations(suspend and resume) as part of
> dev_pm_ops for IMX2 watchdog driver.
> 
> If PM will be supported, please make sure that the wdev->clk
> could disable the watchdog's counter input clock source or can
> mask watchdog's reset request to the core.
> 
> If watchdog is still used by consumers and resumes from deep
> sleep state, we need to restart the watchdog again without
> enabling the timer.
> 
> If watchdog been has started --> stopped by the consumers and
> resumes from non-deep sleep state, then start the timer again.
> 
> If watchdog has been started --> stopped by the consumers and
> resumes from deep sleep state, will do nothing. The watchdog
> will be restarted by consumers next time to be used.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
> Hi,
> 
> I have pulled all the patches since Linux kernel v3.12 to v3.12, and
> test the PM on my LS1021A QDS board again.
> It works fine for now.
> 
> Change in v2:
> - Fix one bug with another small change.
> - Adjust the comments.
> 
> 
> 
>  drivers/watchdog/imx2_wdt.c | 66 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 68c3d37..b9c81c9 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -295,6 +295,71 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
>  	}
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +/* Disable watchdog if it is active or non-active but still running */
> +static int imx2_wdt_suspend(struct device *dev)
> +{
> +	struct watchdog_device *wdog = dev_get_drvdata(dev);
> +	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
> +
> +	imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
> +	imx2_wdt_ping(wdog);

I am a bit concerned about this one. Why ping the watchdog if it is
not running ? Shouldn't this only be done if the watchdog is running ?

> +
> +	/* Watchdog has been stopped but IP block is still running */
> +	if (!watchdog_active(wdog) && imx2_wdt_is_running(wdev))
> +		del_timer_sync(&wdev->timer);
> +
> +	/* If PM will be supported using imx2_wdt, please
> +	 * make sure that the wdev->clk could disable the
> +	 * watchdog's counter input clock source or can mask
> +	 * watchdog's reset request to the core.
> +	 */

As far as I know, the watchdog subsystem uses standard multi-line comments.

I am not sure if such a comment in the code will help. People don't usually
read code to find out why the watchdog resets the board in suspend even
if it should not.

Can you detect this condition programmatically (presumably that the clock
was stopped if I understand correctly) to ensure that it is met ?

> +	clk_disable_unprepare(wdev->clk);
> +
> +	return 0;
> +}
> +
> +/* Enable watchdog and configure it if necessary */
> +static int imx2_wdt_resume(struct device *dev)
> +{
> +	struct watchdog_device *wdog = dev_get_drvdata(dev);
> +	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
> +
> +	clk_prepare_enable(wdev->clk);
> +
> +	if (watchdog_active(wdog) && !imx2_wdt_is_running(wdev)) {
> +		/* If watchdog is still used by consumers and
> +		 * resumes from deep sleep state, need to
> +		 * restart the watchdog again.
> +		 */
> +		imx2_wdt_setup(wdog);
> +		imx2_wdt_set_timeout(wdog, wdog->timeout);
> +		imx2_wdt_ping(wdog);
> +	} else if (imx2_wdt_is_running(wdev)) {
> +		imx2_wdt_set_timeout(wdog, wdog->timeout);
> +		imx2_wdt_ping(wdog);
> +		/* If watchdog has started --> stopped by the
> +		 * consumers and resumes from non-deep sleep state,
> +		 * then start the timer again.
> +		 */
> +		if (!watchdog_active(wdog))
> +			mod_timer(&wdev->timer,
> +				  jiffies + wdog->timeout * HZ / 2);
> +	} else {
> +		/* If watchdog has been started --> stopped by
> +		 * the consumers and resumes from deep sleep state,
> +		 * will do nothing. The watchdog will be restarted
> +		 * by consumers next time to be used.
> +		 */

I really dislike the notion of an else case just for a comment.
It should be obvious that nothing needs to be done here if the watchdog
is not running.

> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(imx2_wdt_pm_ops, imx2_wdt_suspend,
> +			 imx2_wdt_resume);
> +
>  static const struct of_device_id imx2_wdt_dt_ids[] = {
>  	{ .compatible = "fsl,imx21-wdt", },
>  	{ /* sentinel */ }
> @@ -307,6 +372,7 @@ static struct platform_driver imx2_wdt_driver = {
>  	.driver		= {
>  		.name	= DRIVER_NAME,
>  		.owner	= THIS_MODULE,
> +		.pm     = &imx2_wdt_pm_ops,
>  		.of_match_table = imx2_wdt_dt_ids,
>  	},
>  };
> -- 
> 2.1.0.27.g96db324
> 
