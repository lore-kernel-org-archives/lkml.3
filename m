Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaJ1RBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:01:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33169 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJ1RBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:01:33 -0400
Message-ID: <544FCBE8.9030901@gmail.com>
Date: Tue, 28 Oct 2014 18:01:28 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Pramod Gurav <pramod.gurav@smartplayin.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-pxav3: Fix Sparse warning of duplicate set_uhs_signaling
 entry
References: <1411997137-13034-1-git-send-email-pramod.gurav@smartplayin.com> <CAMf-jSn7=AkQqWCHuNyXg7aEUq6WAE6S+Vr-s8+ye0TQqFbxfw@mail.gmail.com>
In-Reply-To: <CAMf-jSn7=AkQqWCHuNyXg7aEUq6WAE6S+Vr-s8+ye0TQqFbxfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 05:41 PM, Pramod Gurav wrote:
> Hi Ulf,
>
> Is this good to go?

Uhm, no it isn't. pxav3 needs a special set_uhs_signaling handler,
remove the standard sdhci provided instead.

Sebastian

> On Mon, Sep 29, 2014 at 6:55 PM, Pramod Gurav
> <pramod.gurav@smartplayin.com> wrote:
>> This fixes below sparse warning:
>> drivers/mmc/host/sdhci-pxav3.c:227:10: warning: Initializer entry defined twice
>> drivers/mmc/host/sdhci-pxav3.c:232:10:   also defined here
>>
>> by removing duplicate initialization of .set_uhs_signaling in
>> struct sdhci_ops. Also does away with duplcated function.
>>
>> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: Chris Ball <chris@printf.net>
>> Cc: linux-mmc@vger.kernel.org
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---
>>   drivers/mmc/host/sdhci-pxav3.c |   37 -------------------------------------
>>   1 file changed, 37 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
>> index 6f842fb..fd93e60 100644
>> --- a/drivers/mmc/host/sdhci-pxav3.c
>> +++ b/drivers/mmc/host/sdhci-pxav3.c
>> @@ -186,45 +186,8 @@ static void pxav3_gen_init_74_clocks(struct sdhci_host *host, u8 power_mode)
>>          pxa->power_mode = power_mode;
>>   }
>>
>> -static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
>> -{
>> -       u16 ctrl_2;
>> -
>> -       /*
>> -        * Set V18_EN -- UHS modes do not work without this.
>> -        * does not change signaling voltage
>> -        */
>> -       ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
>> -
>> -       /* Select Bus Speed Mode for host */
>> -       ctrl_2 &= ~SDHCI_CTRL_UHS_MASK;
>> -       switch (uhs) {
>> -       case MMC_TIMING_UHS_SDR12:
>> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
>> -               break;
>> -       case MMC_TIMING_UHS_SDR25:
>> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
>> -               break;
>> -       case MMC_TIMING_UHS_SDR50:
>> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR50 | SDHCI_CTRL_VDD_180;
>> -               break;
>> -       case MMC_TIMING_UHS_SDR104:
>> -               ctrl_2 |= SDHCI_CTRL_UHS_SDR104 | SDHCI_CTRL_VDD_180;
>> -               break;
>> -       case MMC_TIMING_UHS_DDR50:
>> -               ctrl_2 |= SDHCI_CTRL_UHS_DDR50 | SDHCI_CTRL_VDD_180;
>> -               break;
>> -       }
>> -
>> -       sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
>> -       dev_dbg(mmc_dev(host->mmc),
>> -               "%s uhs = %d, ctrl_2 = %04X\n",
>> -               __func__, uhs, ctrl_2);
>> -}
>> -
>>   static const struct sdhci_ops pxav3_sdhci_ops = {
>>          .set_clock = sdhci_set_clock,
>> -       .set_uhs_signaling = pxav3_set_uhs_signaling,
>>          .platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
>>          .get_max_clock = sdhci_pltfm_clk_get_max_clock,
>>          .set_bus_width = sdhci_set_bus_width,
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

