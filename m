Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaIZDUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:20:32 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:60714 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaIZDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:20:28 -0400
Message-ID: <5424DB77.7000008@roeck-us.net>
Date: Thu, 25 Sep 2014 20:20:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] watchdog: qcom: register a restart notifier
References: <cover.1411684967.git.joshc@codeaurora.org> <1baf370c79a9bd7d57214c732863375374da2e0a.1411684967.git.joshc@codeaurora.org>
In-Reply-To: <1baf370c79a9bd7d57214c732863375374da2e0a.1411684967.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5424DB7B.00C6,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 25
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

On 09/25/2014 03:51 PM, Josh Cartwright wrote:
> The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> resort mechanism for triggering chip reset.  Usually, other restart
> methods (such as PS_HOLD) are preferrable for issuing a more complete
> reset of the chip.  As such, keep the priority of the watchdog notifier
> low.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/watchdog/qcom-wdt.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
>
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index 68db322..aa85618 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -11,11 +11,13 @@
>    *
>    */
>   #include <linux/clk.h>
> +#include <linux/delay.h>
>   #include <linux/io.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>   #include <linux/watchdog.h>
>
>   #define WDT_RST		0x0
> @@ -26,6 +28,7 @@ struct qcom_wdt {
>   	struct watchdog_device	wdd;
>   	struct clk		*clk;
>   	unsigned long		rate;
> +	struct notifier_block	restart_nb;
>   	void __iomem		*base;
>   };
>
> @@ -84,6 +87,32 @@ static const struct watchdog_info qcom_wdt_info = {
>   	.identity	= KBUILD_MODNAME,
>   };
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
>   static int qcom_wdt_probe(struct platform_device *pdev)
>   {
>   	struct qcom_wdt *wdt;
> @@ -147,6 +176,14 @@ static int qcom_wdt_probe(struct platform_device *pdev)
>   		goto err_clk_unprepare;
>   	}
>
> +	/*
> +	 * WDT restart notifier has priority 0 (use as a last resort)
> +	 */
> +	wdt->restart_nb.notifier_call = qcom_wdt_restart;
> +	ret = register_restart_handler(&wdt->restart_nb);
> +	if (ret)
> +		dev_err(&pdev->dev, "failed to setup restart handler\n");
> +
>   	platform_set_drvdata(pdev, wdt);
>   	return 0;
>
> @@ -159,6 +196,7 @@ static int qcom_wdt_remove(struct platform_device *pdev)
>   {
>   	struct qcom_wdt *wdt = platform_get_drvdata(pdev);
>
> +	unregister_restart_handler(&wdt->restart_nb);
>   	watchdog_unregister_device(&wdt->wdd);
>   	clk_disable_unprepare(wdt->clk);
>   	return 0;
>

