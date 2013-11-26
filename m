Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3KZWvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:51:14 -0500
Received: from void.printf.net ([89.145.121.20]:57308 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3KZWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:51:11 -0500
From: Chris Ball <cjb@laptop.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuanxiao.dong@intel.com
Subject: Re: [PATCH] mmc: sdhci: Setting the host->mrq to NULL before executing tuning
References: <1383634365.26153.100.camel@cliu38-desktop-build>
Date: Tue, 26 Nov 2013 17:50:59 -0500
In-Reply-To: <1383634365.26153.100.camel@cliu38-desktop-build> (Chuansheng
	Liu's message of "Tue, 05 Nov 2013 14:52:45 +0800")
Message-ID: <87r4a2eq0c.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuansheng,

On Tue, Nov 05 2013, Chuansheng Liu wrote:
> In function sdhci_request(), it is possible to do the tuning execution
> like below:
>
> sdhci_request() {
> 	spin_lock_irqsave(&host->lock, flags);
> 	host->mrq = mrq;
> 	...
> 	spin_unlock_irqrestore(&host->lock, flags);
>
> <=== Here it is possible one pending finish_tasklet get running
>      and it will operate the original mrq, and notified the mrq
>      is done, and causes memory corruption.
>
> 	sdhci_execute_tuning(mmc, tuning_opcode);
> 	spin_lock_irqsave(&host->lock, flags);
> 	host->mrq = mrq;
> ...
> }
>
> In the above race place, the original mrq should not be finished wrongly,
> so here before unlock the spinlock, we need to set the host->mrq to NULL
> to avoid this case.
>
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/mmc/host/sdhci.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7a7fb4f..c7a001a 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1391,6 +1391,13 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  					mmc->card->type == MMC_TYPE_MMC ?
>  					MMC_SEND_TUNING_BLOCK_HS200 :
>  					MMC_SEND_TUNING_BLOCK;
> +
> +				/* Here we need to set the host->mrq to NULL,
> +				 * in case the penging finish_tasklet
> +				 * operates it wrongly.
> +				 */
> +				host->mrq = NULL;
> +
>  				spin_unlock_irqrestore(&host->lock, flags);
>  				sdhci_execute_tuning(mmc, tuning_opcode);
>  				spin_lock_irqsave(&host->lock, flags);

Thanks, pushed to mmc-next for 3.14.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
