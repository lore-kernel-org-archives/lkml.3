Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaCXGUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:20:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:40447 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaCXGUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="scan'208";a="498097944"
Message-ID: <532FCE75.6010004@intel.com>
Date: Mon, 24 Mar 2014 08:19:33 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mmc: sdhci: don't read cd-gpio while holding spinlock
References: <1395341232-14490-1-git-send-email-abrestic@chromium.org> <1395625380-12507-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1395625380-12507-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.03.2014 03:43, Andrew Bresticker wrote:
> sdhci_request() and sdhci_card_event() read the cd-gpio via
> mmc_gpio_get_cd(), which can sleep, while holding host->lock.
> This may result in the following BUG:
> 
>   BUG: spinlock wrong CPU on CPU#2, kworker/u8:16/4296
>   lock: 0xea6b9c80, .magic: dead4ead, .owner: kworker/u8:16/4296, .owner_cpu: 0
>   CPU: 2 PID: 4296 Comm: kworker/u8:16 Tainted: G         C   3.10.18 #137
>   Workqueue: kmmcd mmc_rescan
>   [<8020cf8c>] (unwind_backtrace+0x0/0x118) from [<8020a0c8>] (show_stack+0x20/0x24)
>   [<8020a0c8>] (show_stack+0x20/0x24) from [<8075e5b8>] (dump_stack+0x20/0x28)
>   [<8075e5b8>] (dump_stack+0x20/0x28) from [<804184a8>] (spin_dump+0x80/0x94)
>   [<804184a8>] (spin_dump+0x80/0x94) from [<804184e8>] (spin_bug+0x2c/0x30)
>   [<804184e8>] (spin_bug+0x2c/0x30) from [<80418790>] (do_raw_spin_unlock+0x94/0xd4)
>   [<80418790>] (do_raw_spin_unlock+0x94/0xd4) from [<80761a44>] (_raw_spin_unlock_irqrestore+0x1c/0x24)
>   [<80761a44>] (_raw_spin_unlock_irqrestore+0x1c/0x24) from [<805ff66c>] (sdhci_request+0x1c8/0x1d0)
>   [<805ff66c>] (sdhci_request+0x1c8/0x1d0) from [<805ebb5c>] (mmc_start_request+0xec/0xf4)
>   [<805ebb5c>] (mmc_start_request+0xec/0xf4) from [<805ebcbc>] (mmc_wait_for_req+0x80/0xf4)
>   ...
> 
> Read the cd-gpio before acquiring the spinlock instead.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  drivers/mmc/host/sdhci.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 04a5e25..328b250 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1340,6 +1340,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  	u32 tuning_opcode;
>  
>  	host = mmc_priv(mmc);
> +	present = mmc_gpio_get_cd(host->mmc);
>  
>  	sdhci_runtime_pm_get(host);
>  
> @@ -1371,7 +1372,6 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  	 *     zero: cd-gpio is used, and card is removed
>  	 *     one: cd-gpio is used, and card is present
>  	 */
> -	present = mmc_gpio_get_cd(host->mmc);
>  	if (present < 0) {
>  		/* If polling, assume that the card is always present. */
>  		if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
> @@ -2082,15 +2082,16 @@ static void sdhci_card_event(struct mmc_host *mmc)
>  {
>  	struct sdhci_host *host = mmc_priv(mmc);
>  	unsigned long flags;
> +	int present;
>  
>  	/* First check if client has provided their own card event */
>  	if (host->ops->card_event)
>  		host->ops->card_event(host);
>  
> +	present = sdhci_get_cd(mmc);

Shouldn't that be sdhci_do_get_cd(mmc) ?

>  	spin_lock_irqsave(&host->lock, flags);
>  
> -	/* Check host->mrq first in case we are runtime suspended */
> -	if (host->mrq && !sdhci_do_get_cd(host)) {
> +	if (host->mrq && !present) {
>  		pr_err("%s: Card removed during transfer!\n",
>  			mmc_hostname(host->mmc));
>  		pr_err("%s: Resetting controller.\n",
> 

