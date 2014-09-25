Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIYSlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:41:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42309 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIYSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:41:54 -0400
Date: Thu, 25 Sep 2014 11:41:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] watchdog: qcom: register a restart notifier
Message-ID: <20140925184149.GB12340@roeck-us.net>
References: <cover.1411667144.git.joshc@codeaurora.org>
 <2dc54244e755eeacf8265a484819e0c2e2393221.1411667144.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dc54244e755eeacf8265a484819e0c2e2393221.1411667144.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:48:53PM -0500, Josh Cartwright wrote:
> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> resort mechanism for triggering chip reset.  Usually, other restart
> methods (such as PS_HOLD) are preferrable for issuing a more complete
> reset of the chip.  As such, keep the priority of the watchdog notifier
> low.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/watchdog/qcom-wdt.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index 0f56ca3..8ce339f 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -10,12 +10,14 @@
>   * GNU General Public License for more details.
>   *
>   */
> +#include <linux/delay.h>

Nitpick: Please keep alphabetical order of include files.
That makes it easier to identify include files later on.

>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>  #include <linux/watchdog.h>
>  
>  #define WDT_RST		0x0
> @@ -26,6 +28,7 @@ struct qcom_wdt {
>  	struct watchdog_device	wdd;
>  	struct clk		*clk;
>  	unsigned long		rate;
> +	struct notifier_block	restart_nb;
>  	void __iomem		*base;
>  };
>  
> @@ -84,6 +87,32 @@ static const struct watchdog_info qcom_wdt_info = {
>  	.identity	= KBUILD_MODNAME,
>  };
>  
> +static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
> +	u32 timeout;
> +
> +	/*
> +	 * Trigger watchdog bite:
> +	 *    Setup BITE_TIME to be 128ms, and enable WDT.
> +	 */
> +	timeout = 128 * wdt->rate / 1000;
> +
> +	writel(0, wdt->base + WDT_EN);
> +	writel(1, wdt->base + WDT_RST);
> +	writel(timeout, wdt->base + WDT_BITE_TIME);
> +	writel(1, wdt->base + WDT_EN);
> +
> +	/*
> +	 * Actually make sure the above sequence hits hardware before sleeping.
> +	 */
> +	wmb();
> +
> +	msleep(150);
> +	return NOTIFY_DONE;
> +}
> +
>  static int qcom_wdt_probe(struct platform_device *pdev)
>  {
>  	struct qcom_wdt *wdt;
> @@ -149,6 +178,14 @@ static int qcom_wdt_probe(struct platform_device *pdev)
>  		goto err_clk_unprepare;
>  	}
>  
> +	/*
> +	 * WDT restart notifier has priority 0 (use as a last resort)
> +	 */
> +	wdt->restart_nb.notifier_call = qcom_wdt_restart;
> +	ret = register_restart_handler(&wdt->restart_nb);
> +	if (ret)
> +		dev_err(&pdev->dev, "failed to setup restart handler\n");
> +
>  	platform_set_drvdata(pdev, wdt);
>  	return 0;
>  
> @@ -162,6 +199,7 @@ static int qcom_wdt_remove(struct platform_device *pdev)
>  {
>  	struct qcom_wdt *wdt = platform_get_drvdata(pdev);
>  
> +	unregister_restart_handler(&wdt->restart_nb);
>  	watchdog_unregister_device(&wdt->wdd);
>  	clk_disable_unprepare(wdt->clk);
>  	return 0;
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
