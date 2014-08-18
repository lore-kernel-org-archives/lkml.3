Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaHRMg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:36:56 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46547 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHRMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140815134917.da77205b68f18341140c6593@codethink.co.uk>
References: <1408029833-6970-1-git-send-email-geert+renesas@glider.be>
	<20140815134917.da77205b68f18341140c6593@codethink.co.uk>
Date: Mon, 18 Aug 2014 14:36:52 +0200
X-Google-Sender-Auth: utPBNzbZ_Otra4k2zXmtM6XsPoA
Message-ID: <CAMuHMdXrWgW2iMDd7GA+QC-vcAsp+vH9fidkdnBj-f9F878yAw@mail.gmail.com>
Subject: Re: [PATCH] mmc: tmio: Fix hang during suspend
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ian Molton <ian.molton@codethink.co.uk>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Fri, Aug 15, 2014 at 2:49 PM, Ian Molton <ian.molton@codethink.co.uk> wrote:
> On Thu, 14 Aug 2014 17:23:53 +0200
> Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>
>> On R-Car Gen 2, the SDHI registers cannot be accessed while the SDHI
>> module clock is disabled. Doing so will cause a lock-up.
>>
>> When suspending, enable the module clock before disabling the SDHI
>> interrupts, and disable the clock again afterwards.
>
> This feels wrong. Why can't interrupts be disabled prior to turning the clock off?

The clock is handled by runtime PM. So if SDHI becomes idle, the clock
is turned off.
However, the card insertion interrupt is still enabled.
If all interrupts would be disabled when the clock is turned off, I believe card
insertion can no longer be detected.

BTW, I'm still wondering why tmio_mmc_host_resume() works without
enabling the clock, as it calls tmio_mmc_enable_dma(), which also writes to
an SDHI register (CTL_DMA_ENABLE).

>> This fixes suspend and resume on r8a7791/koelsch.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>>  drivers/mmc/host/tmio_mmc_pio.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
>> index faf0924e71cb..83192420a7e3 100644
>> --- a/drivers/mmc/host/tmio_mmc_pio.c
>> +++ b/drivers/mmc/host/tmio_mmc_pio.c
>> @@ -1147,8 +1147,18 @@ int tmio_mmc_host_suspend(struct device *dev)
>>  {
>>       struct mmc_host *mmc = dev_get_drvdata(dev);
>>       struct tmio_mmc_host *host = mmc_priv(mmc);
>> +     struct tmio_mmc_data *pdata = host->pdata;
>> +
>> +     if (pdata->clk_enable) {
>> +             unsigned int f;
>> +             pdata->clk_enable(host->pdev, &f);
>> +     }
>>
>>       tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
>> +
>> +     if (pdata->clk_disable)
>> +             pdata->clk_disable(host->pdev);
>> +
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(tmio_mmc_host_suspend);
>> --
>> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
