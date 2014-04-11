Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaDKVW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:22:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43059 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaDKVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpS3x902iQqEC69hkryHVGieeDykD=rBJX5OqYAD+afwA@mail.gmail.com>
References: <1396995583-5475-1-git-send-email-markus.mayer@linaro.org>
	<CAPDyKFpS3x902iQqEC69hkryHVGieeDykD=rBJX5OqYAD+afwA@mail.gmail.com>
Date: Fri, 11 Apr 2014 14:22:22 -0700
Message-ID: <CAPdLdq=btQda3eJZAOwH7=CyEkcLipqa=5cyZ5Rn3vkm9cJM+A@mail.gmail.com>
Subject: Re: [PATCH RESEND] mmc: Delay the card_event callback into the
 mmc_rescan worker
From: Markus Mayer <markus.mayer@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Christian Daudt <bcm@fixthebug.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 01:56, Ulf Hansson <ulf.hansson@linaro.org> wrote:

>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index 098374b..ff7fd2e 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -2421,6 +2421,11 @@ void mmc_rescan(struct work_struct *work)
>>                 container_of(work, struct mmc_host, detect.work);
>>         int i;
>>
>> +       if (host->trigger_card_event && host->ops->card_event) {
>> +               host->ops->card_event(host);
>> +               host->trigger_card_event = false;
>> +       }
>> +
>
> So this might be a stupid question. :-)
>
> Could you elaborate on why the host->ops->card_event then is needed at
> all. Why can't host drivers use host->ops->get_cd to perform the
> actions they need?
>
> The reason for bringing this up, is because this patch moves the
> invokes of the these callbacks quite close to each other. Earlier they
> were more separated.

Thanks for the question. I looked at the code and I don't think
host->ops->get_cd would work in my case.

I proposed this change based on behaviour exhibited by
sdhci-bcm-kona.c (mutex sleeps in the IRQ handler cause "scheduling
while atomic" errors). The idea of this patch is to move the card
event processing (which does the actual card detection) out of the
interrupt handler, so the mutex in my callback can be used without
problems.

https://git.linaro.org/landing-teams/working/broadcom/kernel.git/blob/refs/heads/review/mmc-card-event:/drivers/mmc/host/sdhci-bcm-kona.c#l160

An earlier proposal to fix this issue was to simply replace the mutex
with a spinlock in sdhci-bcm-kona.c, but that was not seen as good
solution. (https://lkml.org/lkml/2014/3/5/527)

Based on your question, I looked through the code some more. From what
I can tell, SDHCI hosts have their host->ops->get_cd set to
sdhci_get_cd() in sdhci.c (specifically by sdhci_add_host()). So,
get_cd is not available to me to customize.

Maybe we need a different solution from what I proposed above, but I
don't think get_cd will do the trick.

I can see how moving card_event and get_cd closer together, like I
have done, can be a reason for concern. On the flip-side, de-coupling
card_event from IRQ processing seems to be beneficial.

What do you think?

Regards,
-Markus
