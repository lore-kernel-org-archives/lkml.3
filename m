Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaD1JbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:31:12 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60091 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaD1JbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140428091341.GA5918@pengutronix.de>
References: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
	<20140428091341.GA5918@pengutronix.de>
Date: Mon, 28 Apr 2014 11:31:03 +0200
Message-ID: <CAPDyKFqP_cDTyC38+8XDPLWN0C6wWs9e6iZD06nkb_LqqLjjnw@mail.gmail.com>
Subject: Re: [PATCH] mmc: mxs: fix card detection function for broken card detect
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Daniel Willmann <daniel@totalueberwachung.de>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 April 2014 11:13, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Apr 19, 2014 at 11:59:18PM +0200, Daniel Willmann wrote:
>> Return -ENOSYS in get_cd if broken-cd is specified in the device tree.
>>
>> Commit a91fe279ae75 (mmc: mxs: use standard flag for broken card
>> detection) sets MMC_CAP_NEEDS_POLL when broken-cd is specified. This
>> driver sets this flag unconditionally as it does not support a card
>> detect interrupt. Instead, broken-cd means that there is no card detect
>> signal connected.
>>
>> The mmc core checks the get_cd function return value to determine if a
>> card is present. Only for a non-zero return value it will attempt to
>> initialize the card. So retuning -ENOSYS will allow the card to be
>> initialized.
>> For comparison, mmc_gpio_get_cd in slot-gpio.c also returns -ENOSYS if
>> the card detect GPIO is not valid.
>
> Short answer for fixing this regression:
>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
>
> Long answer:
>
> This is broken in the MMC OF parser. When the parser finds the
> 'broken-cd' property it just sets the MMC_CAP_NEEDS_POLL flag. This is
> wrong.  broken-cd means that we cannot rely on any card detection, but
> instead have to talk to the card to find out if it's available.
> Currently there is no flag to signal this situation, so the host driver
> has to handle this by returning true in the get_cd callback, just like
> the patch below does.
>
> IMO the correct solution would be to add a MMC_CAP_CD_NEEDS_TALK_TO_CARD
> flag to the core.
>

So if I understand correct, you want the host-ops->get_cd function to
be invoked from the mmc rescan - only when it actually can provide
useful information?

Kind regards
Ulf Hansson

> Sascha
>
>>
>> Signed-off-by: Daniel Willmann <daniel@totalueberwachung.de>
>> ---
>> This might be relevant for stable kernels. The patch was tested with 3.14.1 on
>> olinuxino nano.
>>
>>  drivers/mmc/host/mxs-mmc.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
>> index 073e871a0fc8..babfea03ba8a 100644
>> --- a/drivers/mmc/host/mxs-mmc.c
>> +++ b/drivers/mmc/host/mxs-mmc.c
>> @@ -70,6 +70,7 @@ struct mxs_mmc_host {
>>       unsigned char                   bus_width;
>>       spinlock_t                      lock;
>>       int                             sdio_irq_en;
>> +     bool                            broken_cd;
>>  };
>>
>>  static int mxs_mmc_get_cd(struct mmc_host *mmc)
>> @@ -78,6 +79,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>>       struct mxs_ssp *ssp = &host->ssp;
>>       int present, ret;
>>
>> +     if (host->broken_cd)
>> +             return -ENOSYS;
>> +
>>       ret = mmc_gpio_get_cd(mmc);
>>       if (ret >= 0)
>>               return ret;
>> @@ -568,6 +572,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>>  {
>>       const struct of_device_id *of_id =
>>                       of_match_device(mxs_mmc_dt_ids, &pdev->dev);
>> +     struct device_node *np = pdev->dev.of_node;
>>       struct mxs_mmc_host *host;
>>       struct mmc_host *mmc;
>>       struct resource *iores;
>> @@ -634,6 +639,8 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>>       mmc->caps = MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
>>                   MMC_CAP_SDIO_IRQ | MMC_CAP_NEEDS_POLL;
>>
>> +     host->broken_cd = of_property_read_bool(np, "broken-cd");
>> +
>>       mmc->f_min = 400000;
>>       mmc->f_max = 288000000;
>>
>> --
>> 1.8.4.2
>>
>>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
