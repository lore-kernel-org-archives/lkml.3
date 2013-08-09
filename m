Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab3HIPFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:05:47 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37649 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934005Ab3HIPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <001901ce9505$04483820$0cd8a860$%jun@samsung.com>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-3-git-send-email-dianders@chromium.org>
	<001901ce9505$04483820$0cd8a860$%jun@samsung.com>
Date: Fri, 9 Aug 2013 08:05:43 -0700
X-Google-Sender-Auth: DEKCyBOytJhjr4qVOAMt8MUzL2Y
Message-ID: <CAD=FV=U3LD-PmEeiNzh0F6Wb2efc==kn_=mTNjwVfB52-phSDQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Fri, Aug 9, 2013 at 6:33 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, August 07, 2013, Doug Anderson wrote:
>> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
>> looping around forever.  This has been seen to happen on exynos5420
>> silicon despite the fact that we haven't enabled any wakeup events due
>> to a silicon errata.  It is safe to do on all exynos variants.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v4:
>> - Take Seungwon's suggestion and don't add any dw_mmc-pltfm code.
>>
>> Changes in v3:
>> - Add freeze/thaw and poweroff/restore noirq entries.
>>
>> Changes in v2:
>> - Use suspend_noirq as per James Hogan.
>>
>>  drivers/mmc/host/dw_mmc-exynos.c | 51 ++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 49 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index 866edef..0c1f192 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -30,6 +30,7 @@
>>  #define SDMMC_CLKSEL_TIMING(x, y, z) (SDMMC_CLKSEL_CCLK_SAMPLE(x) |  \
>>                                       SDMMC_CLKSEL_CCLK_DRIVE(y) |    \
>>                                       SDMMC_CLKSEL_CCLK_DIVIDER(z))
>> +#define SDMMC_CLKSEL_WAKEUP_INT              BIT(11)
>>
>>  #define EXYNOS4210_FIXED_CIU_CLK_DIV 2
>>  #define EXYNOS4412_FIXED_CIU_CLK_DIV 4
>> @@ -100,6 +101,30 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>>       return 0;
>>  }
>>
>> +/**
>> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
>> + *
>> + * On exynos5420 there is a silicon errata that will sometimes leave the
>> + * WAKEUP_INT bit in the CLKSEL register asserted.  This bit is 1 to indicate
>> + * that it fired and we can clear it by writing a 1 back.  Clear it to prevent
>> + * interrupts from going off constantly.
>> + *
>> + * We run this code on all exynos variants because it doesn't hurt and the bug
>> + * may be more widespread than just exynos5420.
> I guess just above comment can be removed. (Not be widespread)
> Updating the origin value of CLKSEL looks like no harm while SDMMC_CLKSEL_WAKEUP_INT is cleared.

OK, no problem.  I'll clean up the comment next time revision.


>> -module_platform_driver(dw_mci_exynos_pltfm_driver);
>> +static int __init dw_mci_exynos_init(void)
>> +{
>> +     /* Add a "noirq" resume to platform pmops */
>> +     memcpy(&dw_mci_exynos_pmops, &dw_mci_pltfm_pmops,
>> +            sizeof(dw_mci_exynos_pmops));
>> +     WARN_ON(dw_mci_exynos_pmops.resume_noirq ||
>> +             dw_mci_exynos_pmops.thaw_noirq ||
>> +             dw_mci_exynos_pmops.restore_noirq);
>> +     dw_mci_exynos_pmops.resume_noirq = dw_mci_exynos_resume_noirq;
>> +     dw_mci_exynos_pmops.thaw_noirq = dw_mci_exynos_resume_noirq;
>> +     dw_mci_exynos_pmops.restore_noirq = dw_mci_exynos_resume_noirq;
>
> If CONFIG_PM_SLEEP is not defined, we don't need to add it.
> And also, instead of reusing dw_mci_pltfm_pmops, how about defining dw_mci_exynos_pmops's own?
> Of course, suspend/resume will not different with dw_mci_pltfm* just now.
> But specific code for exynos would be added soon.


Whoops!  ...of course this should be conditional on CONFIG_PM_SLEEP.
Thank you for catching.

I spent a bit of time debating whether I should make my own structure
or do a copy like this.  It felt like a bit of a toss up to me, but
I'm happy to do it the other way.  I will call dw_mci_suspend(host)
directly and assume hope that nobody adds any important code to
dw_mci_pltfm_suspend().  The other alternative would be make
dw_mci_pltfm_suspend() exported or call it indirectly through
dw_mci_pltfm_pmops, both of which seem slightly worse.

-Doug
