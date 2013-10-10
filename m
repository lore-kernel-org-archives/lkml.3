Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JJOGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:06:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45865 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab3JJOGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:06:36 -0400
Message-ID: <5256B467.8080402@ti.com>
Date: Thu, 10 Oct 2013 19:36:31 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 14/27] mmc: omap_hsmmc: Move away from using deprecated
 APIs
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org> <1380207292-16968-15-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1380207292-16968-15-git-send-email-ulf.hansson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 September 2013 08:24 PM, Ulf Hansson wrote:
> Suspend and resume of cards are being handled from the protocol layer
> and consequently the mmc_suspend|resume_host APIs are deprecated.
>
> This means we can simplify the suspend|resume callbacks by removing the
> use of the deprecated APIs. Additional cleanup done for keeping track
> suspended state.
>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: linux-omap@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Balaji T K <balajitk@ti.com>

> ---
>   drivers/mmc/host/omap_hsmmc.c |   37 +++----------------------------------
>   1 file changed, 3 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 6ac63df..eb6fb28 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -170,7 +170,6 @@ struct omap_hsmmc_host {
>   	unsigned int		dma_sg_idx;
>   	unsigned char		bus_mode;
>   	unsigned char		power_mode;
> -	int			suspended;
>   	int			irq;
>   	int			use_dma, dma_ch;
>   	struct dma_chan		*tx_chan;
> @@ -1178,9 +1177,6 @@ static irqreturn_t omap_hsmmc_detect(int irq, void *dev_id)
>   	struct omap_mmc_slot_data *slot = &mmc_slot(host);
>   	int carddetect;
>
> -	if (host->suspended)
> -		return IRQ_HANDLED;
> -
>   	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
>
>   	if (slot->card_detect)
> @@ -1643,11 +1639,6 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
>   	seq_printf(s, "mmc%d:\n ctx_loss:\t%d:%d\n\nregs:\n",
>   			mmc->index, host->context_loss, context_loss);
>
> -	if (host->suspended) {
> -		seq_printf(s, "host suspended, can't read registers\n");
> -		return 0;
> -	}
> -
>   	pm_runtime_get_sync(host->dev);
>
>   	seq_printf(s, "CON:\t\t0x%08x\n",
> @@ -2119,23 +2110,12 @@ static void omap_hsmmc_complete(struct device *dev)
>
>   static int omap_hsmmc_suspend(struct device *dev)
>   {
> -	int ret = 0;
>   	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
>
>   	if (!host)
>   		return 0;
>
> -	if (host && host->suspended)
> -		return 0;
> -
>   	pm_runtime_get_sync(host->dev);
> -	host->suspended = 1;
> -	ret = mmc_suspend_host(host->mmc);
> -
> -	if (ret) {
> -		host->suspended = 0;
> -		goto err;
> -	}
>
>   	if (!(host->mmc->pm_flags & MMC_PM_KEEP_POWER)) {
>   		omap_hsmmc_disable_irq(host);
> @@ -2145,23 +2125,19 @@ static int omap_hsmmc_suspend(struct device *dev)
>
>   	if (host->dbclk)
>   		clk_disable_unprepare(host->dbclk);
> -err:
> +
>   	pm_runtime_put_sync(host->dev);
> -	return ret;
> +	return 0;
>   }
>
>   /* Routine to resume the MMC device */
>   static int omap_hsmmc_resume(struct device *dev)
>   {
> -	int ret = 0;
>   	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
>
>   	if (!host)
>   		return 0;
>
> -	if (host && !host->suspended)
> -		return 0;
> -
>   	pm_runtime_get_sync(host->dev);
>
>   	if (host->dbclk)
> @@ -2172,16 +2148,9 @@ static int omap_hsmmc_resume(struct device *dev)
>
>   	omap_hsmmc_protect_card(host);
>
> -	/* Notify the core to resume the host */
> -	ret = mmc_resume_host(host->mmc);
> -	if (ret == 0)
> -		host->suspended = 0;
> -
>   	pm_runtime_mark_last_busy(host->dev);
>   	pm_runtime_put_autosuspend(host->dev);
> -
> -	return ret;
> -
> +	return 0;
>   }
>
>   #else
>

