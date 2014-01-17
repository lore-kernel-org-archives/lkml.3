Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaAQXK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:10:27 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37920 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAQXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:10:24 -0500
MIME-Version: 1.0
In-Reply-To: <0D8B1718-0A9D-467A-AFC5-108A868DE3BB@nvidia.com>
References: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
	<0D8B1718-0A9D-467A-AFC5-108A868DE3BB@nvidia.com>
Date: Fri, 17 Jan 2014 15:10:22 -0800
X-Google-Sender-Auth: -0xB52sPZnYxfOTjBigWdY4JsVo
Message-ID: <CAL1qeaGuC+pEw207LOb2A2NaVZfFmrCgKLXJG-YRFa6=6LyC+g@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: fix possible scheduling while atomic
From: Andrew Bresticker <abrestic@chromium.org>
To: Philip Rakity <prakity@nvidia.com>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 2:58 PM, Philip Rakity <prakity@nvidia.com> wrote:
>
> On Jan 17, 2014, at 7:57 PM, Andrew Bresticker <abrestic@chromium.org> wrote:
>
>> sdhci_execute_tuning() takes host->lock without disabling interrupts.
>> Use spin_lock_irq{save,restore} instead so that we avoid taking an
>> interrupt and scheduling while holding host->lock.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>> drivers/mmc/host/sdhci.c | 13 +++++++------
>> 1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index ec3eb30..84c80e7 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -1857,12 +1857,13 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
>>       unsigned long timeout;
>>       int err = 0;
>>       bool requires_tuning_nonuhs = false;
>> +     unsigned long flags;
>>
>>       host = mmc_priv(mmc);
>>
>>       sdhci_runtime_pm_get(host);
>>       disable_irq(host->irq);
>> -     spin_lock(&host->lock);
>> +     spin_lock_irqsave(&host->lock, flags);
>
>
> The disable_irq() call stops the controller from doing interrupts.

Right, but it does not disable other IRQ sources that could cause us
to schedule.

> Please explain what problem you are seeing

The issue we were seeing was that a card-detect interrupt was
triggered (*not* the controller interrupt), causing the card-detect
irq thread to recurse on host->lock:

[   60.962218] BUG: spinlock cpu recursion on CPU#0, irq/362-700b040/89
[   60.975253]  lock: 0xee210c80, .magic: dead4ead, .owner:
kworker/u8:1/33, .owner_cpu: 0
[   60.991638] CPU: 0 PID: 89 Comm: irq/362-700b040 Not tainted 3.10.18 #2
[   61.005199] [<800153cc>] (unwind_backtrace+0x0/0x118) from
[<800124e4>] (show_stack+0x20/0x24)
[   61.022824] [<800124e4>] (show_stack+0x20/0x24) from [<8053d584>]
(dump_stack+0x20/0x28)
[   61.039389] [<8053d584>] (dump_stack+0x20/0x28) from [<8021d508>]
(spin_dump+0x80/0x94)
[   61.055773] [<8021d508>] (spin_dump+0x80/0x94) from [<8021d548>]
(spin_bug+0x2c/0x30)
[   61.071803] [<8021d548>] (spin_bug+0x2c/0x30) from [<8021d61c>]
(do_raw_spin_lock+0x70/0x15c)
[   61.089250] [<8021d61c>] (do_raw_spin_lock+0x70/0x15c) from
[<8054098c>] (_raw_spin_lock_irqsave+0x20/0x28)
[   61.109175] [<8054098c>] (_raw_spin_lock_irqsave+0x20/0x28) from
[<803e2af0>] (sdhci_card_event+0x28/0xfc)
[   61.128922] [<803e2af0>] (sdhci_card_event+0x28/0xfc) from
[<803dc880>] (mmc_gpio_cd_irqt+0x30/0x4c)
[   61.147609] [<803dc880>] (mmc_gpio_cd_irqt+0x30/0x4c) from
[<80091858>] (irq_thread+0xf0/0x224)
[   61.165412] [<80091858>] (irq_thread+0xf0/0x224) from [<80050db4>]
(kthread+0xc8/0xd8)
[   61.181623] [<80050db4>] (kthread+0xc8/0xd8) from [<8000e4d8>]
(ret_from_fork+0x14/0x20)

Thanks,
Andrew

>
>>
>>       ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
>>
>> @@ -1882,14 +1883,14 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
>>           requires_tuning_nonuhs)
>>               ctrl |= SDHCI_CTRL_EXEC_TUNING;
>>       else {
>> -             spin_unlock(&host->lock);
>> +             spin_unlock_irqrestore(&host->lock, flags);
>>               enable_irq(host->irq);
>>               sdhci_runtime_pm_put(host);
>>               return 0;
>>       }
>>
>>       if (host->ops->platform_execute_tuning) {
>> -             spin_unlock(&host->lock);
>> +             spin_unlock_irqrestore(&host->lock, flags);
>>               enable_irq(host->irq);
>>               err = host->ops->platform_execute_tuning(host, opcode);
>>               sdhci_runtime_pm_put(host);
>> @@ -1963,7 +1964,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
>>               host->cmd = NULL;
>>               host->mrq = NULL;
>>
>> -             spin_unlock(&host->lock);
>> +             spin_unlock_irqrestore(&host->lock, flags);
>>               enable_irq(host->irq);
>>
>>               /* Wait for Buffer Read Ready interrupt */
>> @@ -1971,7 +1972,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
>>                                       (host->tuning_done == 1),
>>                                       msecs_to_jiffies(50));
>>               disable_irq(host->irq);
>> -             spin_lock(&host->lock);
>> +             spin_lock_irqsave(&host->lock, flags);
>>
>>               if (!host->tuning_done) {
>>                       pr_info(DRIVER_NAME ": Timeout waiting for "
>> @@ -2046,7 +2047,7 @@ out:
>>               err = 0;
>>
>>       sdhci_clear_set_irqs(host, SDHCI_INT_DATA_AVAIL, ier);
>> -     spin_unlock(&host->lock);
>> +     spin_unlock_irqrestore(&host->lock, flags);
>>       enable_irq(host->irq);
>>       sdhci_runtime_pm_put(host);
>>
>> --
>> 1.8.5.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
