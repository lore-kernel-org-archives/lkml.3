Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaHYQKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:10:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:16348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbaHYQKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,397,1406617200"; 
   d="scan'208";a="589569466"
Message-ID: <53FB5FDD.6030202@linux.intel.com>
Date: Tue, 26 Aug 2014 00:10:05 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Aaron Lu <aaron.lu@intel.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jackey Shen <jackey.shen@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process()
 on sdio thread
References: <53E85967.5060503@linux.intel.com>	<CAPDyKFqLE-09=3k_6stMXiY3+Ax3xoRBO3q__GHyqH4fd-XmsQ@mail.gmail.com>	<53F16D28.5010500@linux.intel.com> <CAPDyKFrfXe0f6S0z8HUG2Mg29JVU39C0VOBimgKtq-HL47HZrA@mail.gmail.com>
In-Reply-To: <CAPDyKFrfXe0f6S0z8HUG2Mg29JVU39C0VOBimgKtq-HL47HZrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Many thanks for your helps.



Thanks,
Zhonghui


On 2014/8/18 20:07, Ulf Hansson wrote:
> On 18 August 2014 05:04, Fu, Zhonghui <zhonghui.fu@linux.intel.com> wrote:
>> From 21266249bbbaf9407c1e88cd5950e06ac88aeebf Mon Sep 17 00:00:00 2001
>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>> Date: Mon, 18 Aug 2014 10:48:14 +0800
>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>
>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>> the use of our own custom threaded IRQ handler, but left in an
>> unconditional wake_up_process() on that handler at resume-time.
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=80151
>>
>> In addition, the check for MMC_CAP_SDIO_IRQ capability is added
>> before enable sdio IRQ.
>>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> Signed-off-by: Chris Ball <chris@printf.net>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> Thanks! Applied for next and added a stable tag for v3.16+.
>
> Kind regards
> Uffe
>
>> ---
>>  drivers/mmc/core/sdio.c     |   12 ++++++++++--
>>  drivers/mmc/core/sdio_irq.c |    4 ++--
>>  2 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>> index e636d9e..3fc40a7 100644
>> --- a/drivers/mmc/core/sdio.c
>> +++ b/drivers/mmc/core/sdio.c
>> @@ -992,8 +992,16 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>                 }
>>         }
>>
>> -       if (!err && host->sdio_irqs)
>> -               wake_up_process(host->sdio_irq_thread);
>> +       if (!err && host->sdio_irqs) {
>> +               if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>> +                       wake_up_process(host->sdio_irq_thread);
>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>> +                       mmc_host_clk_hold(host);
>> +                       host->ops->enable_sdio_irq(host, 1);
>> +                       mmc_host_clk_release(host);
>> +               }
>> +       }
>> +
>>         mmc_release_host(host);
>>
>>         host->pm_flags &= ~MMC_PM_KEEP_POWER;
>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>> index 5cc13c8..696eca4 100644
>> --- a/drivers/mmc/core/sdio_irq.c
>> +++ b/drivers/mmc/core/sdio_irq.c
>> @@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
>>                                 host->sdio_irqs--;
>>                                 return err;
>>                         }
>> -               } else {
>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>                         mmc_host_clk_hold(host);
>>                         host->ops->enable_sdio_irq(host, 1);
>>                         mmc_host_clk_release(host);
>> @@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
>>                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>                         atomic_set(&host->sdio_irq_thread_abort, 1);
>>                         kthread_stop(host->sdio_irq_thread);
>> -               } else {
>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>                         mmc_host_clk_hold(host);
>>                         host->ops->enable_sdio_irq(host, 0);
>>                         mmc_host_clk_release(host);
>> -- 1.7.1
>>
>> On 2014/8/12 18:23, Ulf Hansson wrote:
>>> On 11 August 2014 07:49, Fu, Zhonghui <zhonghui.fu@linux.intel.com> wrote:
>>>> From 6cee984e1d76ba0a3320430f8cf4318ab65fcf06 Mon Sep 17 00:00:00 2001
>>>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>>> Date: Tue, 5 Aug 2014 12:44:38 +0800
>>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>>
>>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>>> the use of our own custom threaded IRQ handler, but left in an
>>>> unconditional wake_up_process() on that handler at resume-time.
>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=80151
>>>>
>>>> In addition, the check for MMC_CAP_SDIO_IRQ capability is added
>>>> before enable sdio IRQ.
>>>>
>>>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>>>> Signed-off-by: Chris Ball <chris@printf.net>
>>>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>>> ---
>>>>  drivers/mmc/core/sdio.c     |   14 ++++++++++++--
>>>>  drivers/mmc/core/sdio_irq.c |    4 ++--
>>>>  2 files changed, 14 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>>> index e636d9e..e04a540 100644
>>>> --- a/drivers/mmc/core/sdio.c
>>>> +++ b/drivers/mmc/core/sdio.c
>>>> @@ -992,8 +992,18 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>>                 }
>>>>         }
>>>>
>>>> -       if (!err && host->sdio_irqs)
>>>> -               wake_up_process(host->sdio_irq_thread);
>>>> +       if (!err && host->sdio_irqs) {
>>>> +               if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>> +                       wake_up_process(host->sdio_irq_thread);
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>> +                       mmc_release_host(host);
>>> Why mmc_release_host() and the corresponding mmc_claim_host() below?
>>> Those shouldn't be needed I think.
>> You are right. These two functions shouldn't be invoked here. I made a new patch as above.
>>
>>
>> Thanks,
>> Zhonghui
>>>
>>>> +                       mmc_host_clk_hold(host);
>>>> +                       host->ops->enable_sdio_irq(host, 1);
>>>> +                       mmc_host_clk_release(host);
>>>> +                       mmc_claim_host(host);
>>>> +               }
>>>> +       }
>>>> +
>>>>         mmc_release_host(host);
>>>>
>>>>         host->pm_flags &= ~MMC_PM_KEEP_POWER;
>>>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>>>> index 5cc13c8..696eca4 100644
>>>> --- a/drivers/mmc/core/sdio_irq.c
>>>> +++ b/drivers/mmc/core/sdio_irq.c
>>>> @@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
>>>>                                 host->sdio_irqs--;
>>>>                                 return err;
>>>>                         }
>>>> -               } else {
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>                         mmc_host_clk_hold(host);
>>>>                         host->ops->enable_sdio_irq(host, 1);
>>>>                         mmc_host_clk_release(host);
>>>> @@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
>>>>                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>>                         atomic_set(&host->sdio_irq_thread_abort, 1);
>>>>                         kthread_stop(host->sdio_irq_thread);
>>>> -               } else {
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>                         mmc_host_clk_hold(host);
>>>>                         host->ops->enable_sdio_irq(host, 0);
>>>>                         mmc_host_clk_release(host);
>>>> -- 1.7.1
>>>>
>>> Thanks for working on this!
>>>
>>> Kind regards
>>> Uffe
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

