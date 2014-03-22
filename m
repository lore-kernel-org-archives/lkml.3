Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaCVBiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 21:38:19 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:43958 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaCVBiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 21:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <532BE027.9010909@intel.com>
References: <1395341232-14490-1-git-send-email-abrestic@chromium.org>
	<532BE027.9010909@intel.com>
Date: Fri, 21 Mar 2014 18:38:14 -0700
X-Google-Sender-Auth: -73LCWHf7FEJrB4OMfG-a8JdNcU
Message-ID: <CAL1qeaHUPu693yGcf+5vRS5JT3O70GDpnVSoGVQgB+bgxExGAA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: don't read cd-gpio while holding spinlock
From: Andrew Bresticker <abrestic@chromium.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:45 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 20.03.2014 20:47, Andrew Bresticker wrote:
>> mmc_request() reads the cd-gpio via mmc_gpio_get_cd(), which can sleep,
>> while holding host->lock.  This may result in the following BUG:
>>
>>   BUG: spinlock wrong CPU on CPU#2, kworker/u8:16/4296
>>   lock: 0xea6b9c80, .magic: dead4ead, .owner: kworker/u8:16/4296, .owner_cpu: 0
>>   CPU: 2 PID: 4296 Comm: kworker/u8:16 Tainted: G         C   3.10.18 #137
>>   Workqueue: kmmcd mmc_rescan
>>   [<8020cf8c>] (unwind_backtrace+0x0/0x118) from [<8020a0c8>] (show_stack+0x20/0x24)
>>   [<8020a0c8>] (show_stack+0x20/0x24) from [<8075e5b8>] (dump_stack+0x20/0x28)
>>   [<8075e5b8>] (dump_stack+0x20/0x28) from [<804184a8>] (spin_dump+0x80/0x94)
>>   [<804184a8>] (spin_dump+0x80/0x94) from [<804184e8>] (spin_bug+0x2c/0x30)
>>   [<804184e8>] (spin_bug+0x2c/0x30) from [<80418790>] (do_raw_spin_unlock+0x94/0xd4)
>>   [<80418790>] (do_raw_spin_unlock+0x94/0xd4) from [<80761a44>] (_raw_spin_unlock_irqrestore+0x1c/0x24)
>>   [<80761a44>] (_raw_spin_unlock_irqrestore+0x1c/0x24) from [<805ff66c>] (sdhci_request+0x1c8/0x1d0)
>>   [<805ff66c>] (sdhci_request+0x1c8/0x1d0) from [<805ebb5c>] (mmc_start_request+0xec/0xf4)
>>   [<805ebb5c>] (mmc_start_request+0xec/0xf4) from [<805ebcbc>] (mmc_wait_for_req+0x80/0xf4)
>>   ...
>>
>> Read the cd-gpio before acquiring the spinlock instead.
>
> The same problem appears to be in sdhci_card_event() which calls
> sdhci_do_get_cd() under spinlock which then calls mmc_gpio_get_cd()
>
> Will you fix that too?

Yes, will do.

Thanks,
Andrew

>
>
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  drivers/mmc/host/sdhci.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 04a5e25..f2ef978 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -1340,6 +1340,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>>       u32 tuning_opcode;
>>
>>       host = mmc_priv(mmc);
>> +     present = mmc_gpio_get_cd(host->mmc);
>>
>>       sdhci_runtime_pm_get(host);
>>
>> @@ -1371,7 +1372,6 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>>        *     zero: cd-gpio is used, and card is removed
>>        *     one: cd-gpio is used, and card is present
>>        */
>> -     present = mmc_gpio_get_cd(host->mmc);
>>       if (present < 0) {
>>               /* If polling, assume that the card is always present. */
>>               if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
>>
>
