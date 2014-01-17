Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaAQW7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:59:05 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5294 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaAQW7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:59:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 Jan 2014 14:58:35 -0800
From: Philip Rakity <prakity@nvidia.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 23:58:59 +0100
Subject: Re: [PATCH] mmc: sdhci: fix possible scheduling while atomic
Thread-Topic: [PATCH] mmc: sdhci: fix possible scheduling while atomic
Thread-Index: Ac8T17RxFYwwiyEwQ8SOKU6Ec2WTTQ==
Message-ID: <0D8B1718-0A9D-467A-AFC5-108A868DE3BB@nvidia.com>
References: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17, 2014, at 7:57 PM, Andrew Bresticker <abrestic@chromium.org> wrote:

> sdhci_execute_tuning() takes host->lock without disabling interrupts.
> Use spin_lock_irq{save,restore} instead so that we avoid taking an
> interrupt and scheduling while holding host->lock.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> drivers/mmc/host/sdhci.c | 13 +++++++------
> 1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ec3eb30..84c80e7 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1857,12 +1857,13 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> 	unsigned long timeout;
> 	int err = 0;
> 	bool requires_tuning_nonuhs = false;
> +	unsigned long flags;
> 
> 	host = mmc_priv(mmc);
> 
> 	sdhci_runtime_pm_get(host);
> 	disable_irq(host->irq);
> -	spin_lock(&host->lock);
> +	spin_lock_irqsave(&host->lock, flags);


The disable_irq() call stops the controller from doing interrupts.  
Please explain what problem you are seeing

> 
> 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
> 
> @@ -1882,14 +1883,14 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> 	    requires_tuning_nonuhs)
> 		ctrl |= SDHCI_CTRL_EXEC_TUNING;
> 	else {
> -		spin_unlock(&host->lock);
> +		spin_unlock_irqrestore(&host->lock, flags);
> 		enable_irq(host->irq);
> 		sdhci_runtime_pm_put(host);
> 		return 0;
> 	}
> 
> 	if (host->ops->platform_execute_tuning) {
> -		spin_unlock(&host->lock);
> +		spin_unlock_irqrestore(&host->lock, flags);
> 		enable_irq(host->irq);
> 		err = host->ops->platform_execute_tuning(host, opcode);
> 		sdhci_runtime_pm_put(host);
> @@ -1963,7 +1964,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> 		host->cmd = NULL;
> 		host->mrq = NULL;
> 
> -		spin_unlock(&host->lock);
> +		spin_unlock_irqrestore(&host->lock, flags);
> 		enable_irq(host->irq);
> 
> 		/* Wait for Buffer Read Ready interrupt */
> @@ -1971,7 +1972,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> 					(host->tuning_done == 1),
> 					msecs_to_jiffies(50));
> 		disable_irq(host->irq);
> -		spin_lock(&host->lock);
> +		spin_lock_irqsave(&host->lock, flags);
> 
> 		if (!host->tuning_done) {
> 			pr_info(DRIVER_NAME ": Timeout waiting for "
> @@ -2046,7 +2047,7 @@ out:
> 		err = 0;
> 
> 	sdhci_clear_set_irqs(host, SDHCI_INT_DATA_AVAIL, ier);
> -	spin_unlock(&host->lock);
> +	spin_unlock_irqrestore(&host->lock, flags);
> 	enable_irq(host->irq);
> 	sdhci_runtime_pm_put(host);
> 
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

