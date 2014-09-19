Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaISCsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:48:00 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:53580 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISCr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:47:59 -0400
Message-ID: <541B995A.6000609@roeck-us.net>
Date: Thu, 18 Sep 2014 19:47:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>, Wim Van Sebroeck <wim@iguana.be>
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: qcom: register a restart notifier
References: <cover.1411078425.git.joshc@codeaurora.org> <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
In-Reply-To: <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.541B995F.0016,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 03:27 PM, Josh Cartwright wrote:
> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> resort mechanism for triggering chip reset.  Usually, other restart
> methods (such as PS_HOLD) are preferrable for issuing a more complete
> reset of the chip.  As such, keep the priority of the watchdog notifier
> low.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>   drivers/watchdog/qcom-wdt.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
>
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index e9409f5..710ab43 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -15,6 +15,7 @@
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>   #include <linux/watchdog.h>
>
>   #define WDT_RST		0x0
> @@ -24,6 +25,7 @@
>   struct qcom_wdt {
>   	struct watchdog_device	wdd;
>   	unsigned long		freq;
> +	struct notifier_block	restart_nb;
>   	void __iomem		*base;
>   };
>
> @@ -82,6 +84,24 @@ static const struct watchdog_info qcom_wdt_info = {
>   	.identity	= KBUILD_MODNAME,
>   };
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

At this time you don't need to worry about locks.

Actually, this might be dangerous if the lock happens to be taken,
as it won't be released (there is no other code running anymore
when this function is called).

> +	writel_relaxed(0, wdt->base + WDT_EN);
> +	writel_relaxed(1, wdt->base + WDT_RST);
> +	writel_relaxed(0x31F3, wdt->base + WDT_BITE_TIME);

What is the magic here, ie what does 0x31F3 stand for ?

> +	writel_relaxed(1, wdt->base + WDT_EN);
> +	mutex_unlock(&wdt->wdd.lock);
> +	return NOTIFY_DONE;
> +}
> +
>   static int qcom_watchdog_probe(struct platform_device *pdev)
>   {
>   	struct qcom_wdt *wdt;
> @@ -121,6 +141,17 @@ static int qcom_watchdog_probe(struct platform_device *pdev)
>   		return ret;
>   	}
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

Sure you want to return an error here ? The watchdog itself is still working,
and this is supposed to be a restart method of last resort. Causing the driver
to fail loading because it can not register its restart handler seems to be
a bit aggressive.

Thanks,
Guenter

> +	}
> +
>   	return 0;
>   }
>
>

