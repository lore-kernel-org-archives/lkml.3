Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaIXRF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:05:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39635 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaIXRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:05:27 -0400
Date: Wed, 24 Sep 2014 10:05:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] watchdog: qcom: register a restart notifier
Message-ID: <20140924170521.GB31578@roeck-us.net>
References: <cover.1411513109.git.joshc@codeaurora.org>
 <2d539bc944f3e8fc70f39728b0f61fd171b2e5bf.1411513109.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d539bc944f3e8fc70f39728b0f61fd171b2e5bf.1411513109.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:04:38PM -0500, Josh Cartwright wrote:
> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> resort mechanism for triggering chip reset.  Usually, other restart
> methods (such as PS_HOLD) are preferrable for issuing a more complete
> reset of the chip.  As such, keep the priority of the watchdog notifier
> low.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/watchdog/qcom-wdt.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index d5e46e2..eba92ef 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>  #include <linux/watchdog.h>
>  
>  #define WDT_RST		0x0
> @@ -25,6 +26,7 @@
>  struct qcom_wdt {
>  	struct watchdog_device	wdd;
>  	struct clk		*clk;
> +	struct notifier_block	restart_nb;
>  	void __iomem		*base;
>  };
>  
> @@ -86,6 +88,23 @@ static const struct watchdog_info qcom_wdt_info = {
>  	.identity	= KBUILD_MODNAME,
>  };
>  
> +static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
> +
> +	/*
> +	 * Trigger watchdog bite:
> +	 *    Setup BITE_TIME to be very low, and enable WDT.
> +	 *      0x31F3 => 390ms @ 32kHz, also value at reset

What happens if you set it to a lower value ? If you set it to, say,
0x100, would the timeout be ~8ms ? Wouldn't that make more sense ?
Or at least something like 0x800, which should make it around 64 ms,
or 0x400 for 32 ms.

[ In other words, I don't really see the point for a 390 ms wait here ]

> +	 */
> +	writel(0, wdt->base + WDT_EN);
> +	writel(1, wdt->base + WDT_RST);
> +	writel(0x31F3, wdt->base + WDT_BITE_TIME);
> +	writel(1, wdt->base + WDT_EN);

You should have some mdelay() here, larger than the expected timeout.

Thanks,
Guenter

> +	return NOTIFY_DONE;
> +}
> +
>  static int qcom_wdt_probe(struct platform_device *pdev)
>  {
>  	struct qcom_wdt *wdt;
> @@ -141,6 +160,14 @@ static int qcom_wdt_probe(struct platform_device *pdev)
>  		return ret;
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
>  }
> @@ -149,6 +176,7 @@ static int qcom_wdt_remove(struct platform_device *pdev)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
