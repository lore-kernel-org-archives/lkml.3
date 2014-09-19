Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbaISMoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:44:04 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:52709 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbaISMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:44:02 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <541C25E5.6080601@smartplayin.com>
Date: Fri, 19 Sep 2014 18:17:33 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: qcom: register a restart notifier
References: <cover.1411078425.git.joshc@codeaurora.org> <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
In-Reply-To: <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

Tested this patch on IFC6410 by disabling pinctrl ps_hold reset
implementation and on top of Guenter's patchset for restart_notifier.

Tested-by: pramod.gurav@smartplayin.com

I picked up DT changes from bindings as they are from this patchset.

Thanks
Pramod
On Friday 19 September 2014 03:57 AM, Josh Cartwright wrote:
> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> resort mechanism for triggering chip reset.  Usually, other restart
> methods (such as PS_HOLD) are preferrable for issuing a more complete
> reset of the chip.  As such, keep the priority of the watchdog notifier
> low.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/watchdog/qcom-wdt.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index e9409f5..710ab43 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>  #include <linux/watchdog.h>
>  
>  #define WDT_RST		0x0
> @@ -24,6 +25,7 @@
>  struct qcom_wdt {
>  	struct watchdog_device	wdd;
>  	unsigned long		freq;
> +	struct notifier_block	restart_nb;
>  	void __iomem		*base;
>  };
>  
> @@ -82,6 +84,24 @@ static const struct watchdog_info qcom_wdt_info = {
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
> +	 */
> +	mutex_lock(&wdt->wdd.lock);
> +	writel_relaxed(0, wdt->base + WDT_EN);
> +	writel_relaxed(1, wdt->base + WDT_RST);
> +	writel_relaxed(0x31F3, wdt->base + WDT_BITE_TIME);
> +	writel_relaxed(1, wdt->base + WDT_EN);
> +	mutex_unlock(&wdt->wdd.lock);
> +	return NOTIFY_DONE;
> +}
> +
>  static int qcom_watchdog_probe(struct platform_device *pdev)
>  {
>  	struct qcom_wdt *wdt;
> @@ -121,6 +141,17 @@ static int qcom_watchdog_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	/*
> +	 * WDT restart notifier has priority 0 (use as a last resort)
> +	 */
> +	wdt->restart_nb.notifier_call = qcom_wdt_restart;
> +	ret = register_restart_handler(&wdt->restart_nb);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to setup restart handler\n");
> +		watchdog_unregister_device(&wdt->wdd);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> 
