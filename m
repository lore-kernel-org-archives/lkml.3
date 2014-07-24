Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbaGXP1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:27:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:39548 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759540AbaGXP1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,724,1400050800"; 
   d="scan'208";a="548472030"
Message-ID: <53D125D6.3020203@linux.intel.com>
Date: Thu, 24 Jul 2014 23:27:18 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>
CC: ulf.hansson@linaro.org, tgih.jun@samsung.com, aaron.lu@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com> <53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com> <53B968EB.60401@linux.intel.com> <53BC164E.4040900@linux.intel.com> <86zjgcjckz.fsf@void.printf.net> <53C497FD.2070000@linux.intel.com> <53C4AAB5.4070700@samsung.com> <53C4B0CA.1020504@samsung.com> <53CBD775.9000304@linux.intel.com>
In-Reply-To: <53CBD775.9000304@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Any comments for this new patch?

Thanks,
Zhonghui
On 2014/7/20 22:51, Fu, Zhonghui wrote:
> Hi,
>
> Chris' patch is not enough to fix this bug. I made a patch as follows and verified it can work.  Could you please give out some comments about this patch?
>
>
> Thanks,
> Zhonghui
>
> From 72d6f5b56fa04290fd3a055a3333de1d89e7c8d4 Mon Sep 17 00:00:00 2001
> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> Date: Sun, 20 Jul 2014 22:29:53 +0800
> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>
> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
> the use of our own custom threaded IRQ handler, but left in an
> unconditional wake_up_process() on that handler at resume-time.
>
> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> ---
>  drivers/mmc/core/sdio.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index e636d9e..8369e56 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -992,8 +992,18 @@ static int mmc_sdio_resume(struct mmc_host *host)
>  		}
>  	}
>  
> -	if (!err && host->sdio_irqs)
> -		wake_up_process(host->sdio_irq_thread);
> +	if (!err && host->sdio_irqs) {
> +		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
> +			wake_up_process(host->sdio_irq_thread);
> +		} else {
> +			mmc_release_host(host);
> +			mmc_host_clk_hold(host);
> +			host->ops->enable_sdio_irq(host, 1);
> +			mmc_host_clk_release(host);
> +			mmc_claim_host(host);
> +		}
> +	}
> +
>  	mmc_release_host(host);
>  
>  	host->pm_flags &= ~MMC_PM_KEEP_POWER;
> -- 1.7.1
>
>
>
> On 2014/7/15 12:40, Jaehoon Chung wrote:
>> From: Chris Ball <chris@printf.net>
>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>
>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>> the use of our own custom threaded IRQ handler, but left in an
>> unconditional wake_up_process() on that handler at resume-time.
>>
>> Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
>> [Patch suggested by Jaehoon Chung]
>> Signed-off-by: Chris Ball <chris@printf.net>
>> ---
>>  drivers/mmc/core/sdio.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>> index e636d9e..11cc4e0 100644
>> --- a/drivers/mmc/core/sdio.c
>> +++ b/drivers/mmc/core/sdio.c
>> @@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>  		}
>>  	}
>>  
>> -	if (!err && host->sdio_irqs)
>> +	if (!err && host->sdio_irqs &&
>> +			!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>>  		wake_up_process(host->sdio_irq_thread);
>>  	mmc_release_host(host);
>>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

