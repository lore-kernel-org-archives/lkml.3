Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3GJPFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:05:07 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52647 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3GJPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <002a01ce7d7d$6bd9e870$438db950$%jun@samsung.com>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-4-git-send-email-dianders@chromium.org>
	<002a01ce7d7d$6bd9e870$438db950$%jun@samsung.com>
Date: Wed, 10 Jul 2013 08:05:01 -0700
X-Google-Sender-Auth: JEweZ8A4V4MXhtDoMqiKQdRiKig
Message-ID: <CAD=FV=UtX0Z1ABdi5h270ks8Py2o1iPK4DonOHJH3N0Q1YShTQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to
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

On Wed, Jul 10, 2013 at 7:54 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, July 10, 2013, Doug Anderson wrote:
>> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
>> looping around forever.  This has been seen to happen on exynos5420
>> silicon despite the fact that we haven't enabled any wakeup events.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v2:
>> - Use suspend_noirq as per James Hogan.
>>
>>  drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index f013e7e..36b9620 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -30,6 +30,7 @@
>>  #define SDMMC_CLKSEL_TIMING(x, y, z) (SDMMC_CLKSEL_CCLK_SAMPLE(x) |  \
>>                                       SDMMC_CLKSEL_CCLK_DRIVE(y) |    \
>>                                       SDMMC_CLKSEL_CCLK_DIVIDER(z))
>> +#define SDMMC_CLKSEL_WAKEUP_INT              BIT(11)
>>
>>  #define SDMMC_CMD_USE_HOLD_REG               BIT(29)
>>
>> @@ -102,6 +103,27 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>>       return 0;
>>  }
>>
>> +/**
>> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
>> + *
>> + * We have seen cases (at least on the exynos5420) where turning off the INT
>> + * power rail during suspend will leave the WAKEUP_INT bit in the CLKSEL
>> + * register asserted.  This bit is 1 to indicate that it fired and we can
>> + * clear it by writing a 1 back.  Clear it to prevent interrupts from going off
>> + * constantly.
>> + */
> As I know this bit is auto-cleared.
> Did you find the cause of this problem?
> How about your GPIO setting in sleep?
> Currently, we don't know why the problem is happened.
> At least, we should make it clear.

Yes, the documentation that I have says that this bit is "auto
cleared" as well but doesn't indicate under what conditions it is auto
cleared.  From testing how this bit reacts I have found that writing a
1 to it clears the bit--in other words it behaves like bits in
RINTSTS.  That's a terrible design for a bit in a register with shared
config but appears to be how it works.

Note: in a sense it will be "auto cleared" because doing a
read-modify-write of any other bits in this register will clear the
interrupt.

I have asked for official confirmation.

We have found that on exynos5420 bits 8-10 of CLKSEL are marked as
RESERVED.  Those bits are documented to enable the WAKEUP_INT on
exynos5250.  My best guess is that these bits are not used on
exynos5420 and the WAKEUP_INT line is left floating, which means it
can fire randomly.  I have also asked for official confirmation about
this.


I will likely merge this change locally in our kernel tree while
waiting for a response.  If you would like to wait before Acking
that's very reasonable.  Do you have any other problems with this
change assuming my understanding above is correct?

-Doug
