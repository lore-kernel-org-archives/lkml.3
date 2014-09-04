Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaIDTVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:21:22 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:41288 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaIDTVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <5407F6F1.60900@samsung.com>
References: <1409701034-28526-1-git-send-email-dianders@chromium.org>
	<5407F6F1.60900@samsung.com>
Date: Thu, 4 Sep 2014 12:21:17 -0700
X-Google-Sender-Auth: gTfXqzBo8B7I1Xq5JPDACxFzO-E
Message-ID: <CAD=FV=WfCmC=jPDv0annedsP2KVJ5Na=+EYGJXv-9+NSfN30_w@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Don't enable interrupts until we're ready
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Addy Ke <addy.ke@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Wed, Sep 3, 2014 at 10:21 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Doug
>
> On 09/03/2014 08:37 AM, Doug Anderson wrote:
>> On dw_mmc there's a small race if you happen to get a card detect
>> interrupt at just the wrong time during probe.  You may have enabled
>> the interrupt but host->slot[0] may be NULL.
>>
>> Fix the race by enabling interrupts all the way at the end of the
>> probe.  We can also use free_irq() instead of dw_mmc specific masking
>> to mask the IRQ at removal time.  Note that since we're now managing
>> freeing of the irq ourselves, there's no need to use devm.
>>
>> FYI, the crash would look like:
>>   dwmmc_rockchip ff0c0000.dwmmc: DW MMC controller at irq 64, 32 bit host data width, 256 deep fifo
>>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>>   pgd = c0004000
>>   [00000000] *pgd=00000000
>>   ...
>>   ...
>>   [<c0499380>] (dw_mci_work_routine_card) from [<c0134b94>] (process_one_work+0x260/0x3c4)
>>   [<c0134b94>] (process_one_work) from [<c0135b10>] (worker_thread+0x240/0x3a8)
>>   [<c0135b10>] (worker_thread) from [<c013b64c>] (kthread+0x100/0x118)
>>   [<c013b64c>] (kthread) from [<c0106418>] (ret_from_fork+0x14/0x20)
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> FYI: making dw_mmc into a module and trying module removal was not
>> tested.  I'd appreciate any testing that folks can do there.  This
>> code should be the equivalent and makes the error case of probe match
>> the removal case more closely now.
>>
>>  drivers/mmc/host/dw_mmc.c | 17 +++++++++++------
>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 7f227e9..540ba3c 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -2577,10 +2577,6 @@ int dw_mci_probe(struct dw_mci *host)
>>               goto err_dmaunmap;
>>       }
>>       INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>> -     ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
>> -                            host->irq_flags, "dw-mci", host);
>> -     if (ret)
>> -             goto err_workqueue;
>>
>>       if (host->pdata->num_slots)
>>               host->num_slots = host->pdata->num_slots;
>> @@ -2619,11 +2615,21 @@ int dw_mci_probe(struct dw_mci *host)
>>               goto err_workqueue;
>>       }
>>
>> +     ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags,
>> +                       "dw-mci", host);
>> +     if (ret)
>> +             goto err_initted;
>
> I didn't test and consider race condition yet.
> But if located "request_irq" at here, we can be confused something,
> since there is "dev_info(host->dev, "%d slots initialized\n", init_slots)" message at above.
>
> I think you can relocate this.

OK, good point.  Maybe we should skip this patch after all.  There is
definitely a race there, but I'm not 100% sure this is the right fix
for it.

In general we probably need to look at the dw_mci_work_routine_card()
a bit more (used for card detect) since that's only used for official
"CD" lines.  ...and as we've talked about anyone who wants to properly
power their card off should be using GPIOs, thus they won't get the
benefit of whatever dw_mci_work_routine_card() does.

I did play around a little bit with trying to test the module remove.
Both before and after my patch it hung.

-Doug
