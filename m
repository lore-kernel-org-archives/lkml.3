Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaE3Kjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:39:32 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45714 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaE3Kja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:39:30 -0400
Message-ID: <53885FD7.8070406@linaro.org>
Date: Fri, 30 May 2014 11:39:19 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 12/13] mmc: mmci: add explicit clk control
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>	<1401284878-16937-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFoGB=0QPTOWMFvP2riLbJK=Mn1__nafJQky0f41Zo+i8g@mail.gmail.com>
In-Reply-To: <CAPDyKFoGB=0QPTOWMFvP2riLbJK=Mn1__nafJQky0f41Zo+i8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ulf for reviewing.

On 30/05/14 11:25, Ulf Hansson wrote:
> On 28 May 2014 15:47,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> On Controllers like Qcom SD card controller where cclk is mclk and mclk should
>> be directly controlled by the driver.
>>
>> This patch adds support to control mclk directly in the driver, and also
>> adds explicit_mclk_control flag in variant structure giving more flexibility
>> to the driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>>   drivers/mmc/host/mmci.c | 96 ++++++++++++++++++++++++++++++++-----------------
>>   drivers/mmc/host/mmci.h |  2 ++
>>   2 files changed, 65 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index 202f2d5..6eb0a29 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -72,6 +72,7 @@ static unsigned int fmax = 515633;
>>    * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
>>    * @busy_detect: true if busy detection on dat0 is supported
>>    * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
>> + * @explicit_mclk_control: enable explicit mclk control in driver.
>>    */
>>   struct variant_data {
>>          unsigned int            clkreg;
>> @@ -93,6 +94,7 @@ struct variant_data {
>>          bool                    pwrreg_clkgate;
>>          bool                    busy_detect;
>>          bool                    pwrreg_nopower;
>> +       bool                    explicit_mclk_control;
>>   };
>>
>>   static struct variant_data variant_arm = {
>> @@ -199,6 +201,7 @@ static struct variant_data variant_qcom = {
>>          .datalength_bits        = 24,
>>          .pwrreg_powerup         = MCI_PWR_UP,
>>          .f_max                  = 208000000,
>> +       .explicit_mclk_control  = true,
>
> This should go in patch3 instead.

yes.. will get this in to the patch3 too.

>
>>   };
>>
>>   static int mmci_card_busy(struct mmc_host *mmc)
>> @@ -301,7 +304,9 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
>>          host->cclk = 0;
>>
>>          if (desired) {
>> -               if (desired >= host->mclk) {
>> +               if (variant->explicit_mclk_control) {
>> +                       host->cclk = host->mclk;
>> +               } else if (desired >= host->mclk) {
>>                          clk = MCI_CLK_BYPASS;
>>                          if (variant->st_clkdiv)
>>                                  clk |= MCI_ST_UX500_NEG_EDGE;
>> @@ -1340,6 +1345,18 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>>          if (!ios->clock && variant->pwrreg_clkgate)
>>                  pwr &= ~MCI_PWR_ON;
>>
>> +       if ((host->variant->explicit_mclk_control) &&
>> +           (ios->clock != host->mclk_req)) {
>> +               int rc = clk_set_rate(host->clk, ios->clock);
>> +               if (rc < 0) {
>> +                       dev_err(mmc_dev(host->mmc),
>> +                               "Error setting clock rate (%d)\n", rc);
>> +               } else {
>> +                       host->mclk = clk_get_rate(host->clk);
>> +                       host->mclk_req = ios->clock;
>> +               }
>> +       }
>> +
>>          spin_lock_irqsave(&host->lock, flags);
>>
>>          mmci_set_clkreg(host, ios->clock);
>> @@ -1490,19 +1507,6 @@ static int mmci_probe(struct amba_device *dev,
>>          host->plat = plat;
>>          host->variant = variant;
>>          host->mclk = clk_get_rate(host->clk);
>> -       /*
>> -        * According to the spec, mclk is max 100 MHz,
>> -        * so we try to adjust the clock down to this,
>> -        * (if possible).
>> -        */
>> -       if (host->mclk > host->variant->f_max) {
>> -               ret = clk_set_rate(host->clk, host->variant->f_max);
>> -               if (ret < 0)
>> -                       goto clk_disable;
>> -               host->mclk = clk_get_rate(host->clk);
>> -               dev_dbg(mmc_dev(mmc), "eventual mclk rate: %u Hz\n",
>> -                       host->mclk);
>> -       }
>
> The above code is relevant for Qcom as well, I don't think you need
> change/move it.
Yes, you are right. I will fix it in next version.
>
>>
>>          host->phybase = dev->res.start;
>>          host->base = devm_ioremap_resource(&dev->dev, &dev->res);
>> @@ -1511,25 +1515,51 @@ static int mmci_probe(struct amba_device *dev,
>>                  goto clk_disable;
>>          }
>>
>> -       /*
>> -        * The ARM and ST versions of the block have slightly different
>> -        * clock divider equations which means that the minimum divider
>> -        * differs too.
>> -        */
>> -       if (variant->st_clkdiv)
>> -               mmc->f_min = DIV_ROUND_UP(host->mclk, 257);
>
> I think you could simplify the change of fixing with f_min and f_max.
>
> Start by, just add another statement here "else if
> (variant->explicit_mclk_control)" and do the clk_round_rate()
>
>> -       else
>> -               mmc->f_min = DIV_ROUND_UP(host->mclk, 512);
>> -       /*
>> -        * If no maximum operating frequency is supplied, fall back to use
>> -        * the module parameter, which has a (low) default value in case it
>> -        * is not specified. Either value must not exceed the clock rate into
>> -        * the block, of course.
>> -        */
>> -       if (mmc->f_max)
>> -               mmc->f_max = min(host->mclk, mmc->f_max);
>> -       else
>> -               mmc->f_max = min(host->mclk, fmax);
>
> Further replace the above with:
> if (mmc->f_max)
>       mmc->f_max = variant->explicit_mclk_control ? min(mmc->f_max,
> variant->f_max) : min(host->mclk, mmc->f_max);
> else
>       mmc->f_max = variant->explicit_mclk_control ? fmax : min(host->mclk, fmax);
>
> That should do it, right?
yes, that will work. It simplifies the logic too.

>
>> +       if (variant->explicit_mclk_control) {
>> +               /* get the nearest minimum clock to 100Khz */
>> +               mmc->f_min = clk_round_rate(host->clk, 100000);
>> +
>> +               if (mmc->f_max)
>> +                       mmc->f_max = min(host->variant->f_max, mmc->f_max);
>> +               else
>> +                       mmc->f_max = min(host->variant->f_max, fmax);
>> +
>> +       } else {
>> +               /*
>> +                * According to the spec, mclk is max 100 MHz,
>> +                * so we try to adjust the clock down to this,
>> +                * (if possible).
>> +                */
>> +               if (host->mclk > host->variant->f_max) {
>> +                       ret = clk_set_rate(host->clk, host->variant->f_max);
>> +                       if (ret < 0)
>> +                               goto clk_disable;
>> +                       host->mclk = clk_get_rate(host->clk);
>> +                       dev_dbg(mmc_dev(mmc), "eventual mclk rate: %u Hz\n",
>> +                               host->mclk);
>> +               }
>> +               /*
>> +                * The ARM and ST versions of the block have slightly different
>> +                * clock divider equations which means that the minimum divider
>> +                * differs too.
>> +                */
>> +               if (variant->st_clkdiv)
>> +                       mmc->f_min = DIV_ROUND_UP(host->mclk, 257);
>> +               else
>> +                       mmc->f_min = DIV_ROUND_UP(host->mclk, 512);
>> +               /*
>> +                * If no maximum operating frequency is supplied, fall back to
>> +                * use the module parameter, which has a (low) default value in
>> +                * case it is not specified. Either value must not exceed the
>> +                * clock rate into the block, of course.
>> +                */
>> +               if (mmc->f_max)
>> +                       mmc->f_max = min(host->mclk, mmc->f_max);
>> +               else
>> +                       mmc->f_max = min(host->mclk, fmax);
>> +
>> +       }
>> +
>>          dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
>>
>>          /* Get regulators and the supported OCR mask */
>> diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
>> index 706eb513..1882e20 100644
>> --- a/drivers/mmc/host/mmci.h
>> +++ b/drivers/mmc/host/mmci.h
>> @@ -208,6 +208,8 @@ struct mmci_host {
>>          spinlock_t              lock;
>>
>>          unsigned int            mclk;
>> +       /* cached value of requested clk in set_ios */
>> +       unsigned int            mclk_req;
>
> How about "clock_cache" instead?
Sounds ok to me, I will change it in next version.

Thanks,
srini
>
>>          unsigned int            cclk;
>>          u32                     pwr_reg;
>>          u32                     pwr_reg_add;
>> --
>> 1.9.1
>>
>
> Kind regards
> Ulf Hansson
>
