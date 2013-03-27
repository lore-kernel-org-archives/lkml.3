Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3C0Rvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:51:54 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47002 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3C0Rvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <000b01ce2ae6$249bfb90$6dd3f2b0$%jun@samsung.com>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
	<000b01ce2ae6$249bfb90$6dd3f2b0$%jun@samsung.com>
Date: Wed, 27 Mar 2013 10:51:51 -0700
X-Google-Sender-Auth: f6ikE4A7B_FPjiQnzuubNeMUxS8
Message-ID: <CANEJEGsLqAdZqLV+c59nT97ErdAOSRWTPJpYye7m64_i7ga0rg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Grant Grundler <grundler@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Doug Anderson <dianders@chromium.org>,
        Will Newton <will.newton@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 5:25 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wednesday, March 27, 2013, Grant Grundler wrote:
>> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
> For easily identifying, it would be good to point the commit id and subject.

commit id will be different for different git trees and branches - not
as useful as one might think.

I will include the following and update the patch:
   Author: Seungwon Jeon <tgih.jun@samsung.com>
   Date:   Tue May 22 13:01:21 2012 +0900
   mmc: dw_mmc: correct the calculation for CLKDIV


>> But when debugging a related issue (http://crbug.com/221828) I found
>
> It is not easy to catch up issue in your site. What problem is bothering you?
> Could you describe the problem and conditions you have found?

The bug is not relevant to this patch - it's a "related bug". I
mentioned the bug only to explain my motivation for looking at this
code. I will move the bug reference out of the commit message.

To summarize, I was trying to backport "mmc: dw_mmc: correct the
calculation for CLKDIV" patch to 3.4 kernel to support faster eMMC
parts since the original computation in 3.4 kernel was returning wrong
CLKDIV value. But then ran into other problems specific to one
firmware combination breaking the eMMC clock settings.

cheers,
grant

>
> Thanks,
> Seungwon Jeon
>
>> the code unreadable.  This rewrite simplifies the computation and
>> explains each step.
>>
>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>> ---
>> Tested on Samsung Series 3 Chromebook (exynos 5250 chipset) using
>> ChromeOS 3.4 kernel (not 3.9-rc3 which this patch is based against).
>>
>> I've written a test program to confirm this patch generates the
>> same correct values and will share that separately.
>>
>>  drivers/mmc/host/dw_mmc.c | 22 +++++++++++++++-------
>>  1 file changed, 15 insertions(+), 7 deletions(-)
>>
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 9834221..6fdf55b 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -631,14 +631,22 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>
>>       if (slot->clock != host->current_speed || force_clkinit) {
>>               div = host->bus_hz / slot->clock;
>> -             if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
>> -                     /*
>> -                      * move the + 1 after the divide to prevent
>> -                      * over-clocking the card.
>> +             if (host->bus_hz > slot->clock) {
>> +                     /* don't overclock due to integer math losses */
>> +                     if ((div * slot->clock) < host->bus_hz)
>> +                             div++;
>> +
>> +                     /* don't overclock due to resolution of HW */
>> +                     if (div & 1)
>> +                             div++;
>> +
>> +                     /* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
>> +                      * Look for dwc_mobile_storage_db.pdf from Synopsys.
>> +                      * CLKDIV value 0 means divisor 1, val 1 -> 2, ...
>>                        */
>> -                     div += 1;
>> -
>> -             div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
>> +                     div /= 2;
>> +             } else
>> +                     div = 0;        /* use bus_hz */
>>
>>               dev_info(&slot->mmc->class_dev,
>>                        "Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
>> --
>> 1.8.1.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
