Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaGOCy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:54:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:38254 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbaGOCy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:54:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="361736484"
Message-ID: <53C497FD.2070000@linux.intel.com>
Date: Tue, 15 Jul 2014 10:54:53 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chris Ball <chris@printf.net>
CC: Jaehoon Chung <jh80.chung@samsung.com>, ulf.hansson@linaro.org,
        tgih.jun@samsung.com, aaron.lu@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackey.shen@amd.com,
        gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>	<53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com>	<53B968EB.60401@linux.intel.com> <53BC164E.4040900@linux.intel.com> <86zjgcjckz.fsf@void.printf.net>
In-Reply-To: <86zjgcjckz.fsf@void.printf.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The data type of "host" is "struct mmc_host", and there is not "quirks" member in this structure.


Thanks,
Zhonghui

On 2014/7/14 21:26, Chris Ball wrote:
> Hi Zhonghui,
>
> On Tue, Jul 08 2014, Fu, Zhonghui wrote:
>> Why add "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" ?  How to fix this bug?
>>
>> Could you please give out some idea about this bug?
> Jaehoon already gave you a patch to fix this bug.  Here it is again in
> proper patch form.  Please can you test it and let us know whether it
> fixes the crash?  Thanks.
>
>
> From: Chris Ball <chris@printf.net>
> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>
> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
> the use of our own custom threaded IRQ handler, but left in an
> unconditional wake_up_process() on that handler at resume-time.
>
> Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
> [Patch suggested by Jaehoon Chung]
> Signed-off-by: Chris Ball <chris@printf.net>
> ---
>  drivers/mmc/core/sdio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index e636d9e..2a128e2 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
>  		}
>  	}
>  
> -	if (!err && host->sdio_irqs)
> +	if (!err && host->sdio_irqs &&
> +	    !(host->quirks & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>  		wake_up_process(host->sdio_irq_thread);
>  	mmc_release_host(host);
>  

