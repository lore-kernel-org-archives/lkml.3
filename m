Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaJPQFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:05:37 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:51987 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaJPQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <543F9202.8010806@samsung.com>
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
	<543F7F91.1010609@samsung.com>
	<543F9202.8010806@samsung.com>
Date: Thu, 16 Oct 2014 09:05:33 -0700
X-Google-Sender-Auth: j3TFj-MNz57gqdhCDBIBvCz63iE
Message-ID: <CAD=FV=XxXV3pEfVfU0CUSrNwPEnv4sn0QYmxO17xr88K9+jW5Q@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Thu, Oct 16, 2014 at 2:38 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi, Doug.
>
> Add one comment.
>
> On 10/16/2014 05:19 PM, Jaehoon Chung wrote:
>> Hi, Doug.
>>
>> Looks good to me.
>>
>> Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
>> with exynos3/4 series.
>>
>> Need to check exynos5 with using other "card detect" mechanism.
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> On 10/15/2014 01:33 AM, Doug Anderson wrote:
>>> The dw_mmc driver had a bunch of code that ran whenever a card was
>>> ejected and inserted.  However, this code was old and crufty and
>>> should be removed.  Some evidence that it's really not needed:
>>>
>>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>>    doesn't run any of the crufty old code but yet still works.
>>>
>>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>>    castrated the old code a little bit already and nobody noticed.
>>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>>    means that on the first card removal none of the crufty code ran.
>>>
>>> 3. I can run "while true; do dd if=/dev/mmcblk1 of=/dev/null; done"
>>>    while ejecting and inserting an SD Card and the world doesn't
>>>    explode.
>>>
>>> If some of the crufty old code is actually needed, we should justify
>>> it and also put it in some place where it will be run even with
>>> "cd-gpio".
>>>
>>> Note that in my case I'm using the "cd-gpio" mechanism but for various
>>> reasons the hardware triggers a dw_mmc "card detect" at bootup.  That
>>> was actually causing a real bug.  The card detect workqueue was
>>> running while the system was trying to enumerate the card.  The
>>> "present != slot->last_detect_state" triggered and we were doing all
>>> kinds of crazy stuff and messing up enumeration.  The new mechanism of
>>> just asking the core to check the card is much safer and then the
>>> bogus interrupt doesn't hurt.
>
> Did you read the Card-detect Recommendation?
> There is a Recommendation for Card-detect(CDT) at TRM.
> We don't read the CDETECT register(0x50) anywhere. Could you share this register value after detecting?

Sure we do.  Look at dw_mci_get_cd().  I see "mci_readl(slot->host, CDETECT)".


> And I think "last_detect_state" is used for "software should read card detect register and store in memory."

Well yeah, last_detect_state DID store the result of the card detect
register in memory.  ...but it wasn't the only place that the card
detect state was stored in memory.  The MMC core handles things for
you, right?  Said another way: put a printout in dw_mci_get_cd() when
the CDETECT is read.  Insert a card.  You should see your printout.
Now try to access your card.  Did your printout happen?  It shouldn't.
Linux knows that the card is still inserted because it stored that
fact in memory (in some MMC core data structure).

The MMC core handles polling the card detect at boot time (calling
dw_mci_get_cd()) to see if there is a card inserted.  The Linux core
also handles calling dw_mci_get_cd() as appropriate when you tell it
something may have changed with mmc_detect_change().  Let's let the
core do its work.

If we _really_ need to follow the recommendation in the Designware
TRM, we should:

1. Before enabling interrupts cache the CDETECT (per slot)

2. In the IRQ handler read the CDETECT.

3. Never read CDETECT in dw_mci_get_cd().  Only use the cached value.

If you insist I'll spin the patch for that, but I'd rather not since:

* The old code definitely didn't get CDETECT in the irq handler (it
read it in the work routine), so it already violated the
recommendation.

* The designware guide shows this as a recommendation, not a
requirement.  I think they are just trying to make things simpler for
you, but nothing could be simpler than letting the MMC core do all the
heavy lifting.
