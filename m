Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaEZWjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:39:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38840 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEZWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:39:13 -0400
Message-ID: <5383C28D.1060808@linaro.org>
Date: Mon, 26 May 2014 23:39:09 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 12/13] mmc: mmci: add explicit clk control
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849578-7585-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFqz-O9-Douk96LBuFRD_P1146c_Ld14TgiduBgfBqRi_A@mail.gmail.com>
In-Reply-To: <CAPDyKFqz-O9-Douk96LBuFRD_P1146c_Ld14TgiduBgfBqRi_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,
Thankyou for the comments.

On 26/05/14 15:21, Ulf Hansson wrote:
> On 23 May 2014 14:52,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> On Controllers like Qcom SD card controller where cclk is mclk and mclk should
>> be directly controlled by the driver.
>>
>> This patch adds support to control mclk directly in the driver, and also
>> adds explicit_mclk_control and cclk_is_mclk flags in variant structure giving
>> more flexibility to the driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>   drivers/mmc/host/mmci.c | 30 +++++++++++++++++++++++++-----
>>   1 file changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index 5cbf644..f6dfd24 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -73,6 +73,8 @@ static unsigned int fmax = 515633;
>>    * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
>>    * @mclk_delayed_writes: enable delayed writes to ensure, subsequent updates
>>    *                      are not ignored.
>> + * @explicit_mclk_control: enable explicit mclk control in driver.
>> + * @cclk_is_mclk: enable iff card clock is multimedia card adapter clock.
>>    */
>>   struct variant_data {
>>          unsigned int            clkreg;
>> @@ -94,6 +96,8 @@ struct variant_data {
>>          bool                    busy_detect;
>>          bool                    pwrreg_nopower;
>>          bool                    mclk_delayed_writes;
>> +       bool                    explicit_mclk_control;
>> +       bool                    cclk_is_mclk;
>
> I can't see why you need to have both these new configurations. Aren't
> "cclk_is_mclk" just a fact when you use "explicit_mclk_control".
>


> I also believe I would prefer something like "qcom_clkdiv" instead.

There is a subtle difference between both the flags.  Am happy to change 
it to qcom_clkdiv.

>
>>   };
>>
>>   static struct variant_data variant_arm = {
>> @@ -202,6 +206,8 @@ static struct variant_data variant_qcom = {
>>           * for 3 clk cycles.
>>           */
>>          .mclk_delayed_writes    = true,
>> +       .explicit_mclk_control  = true,
>> +       .cclk_is_mclk   = true,
>>   };
>>
>>   static inline u32 mmci_readl(struct mmci_host *host, u32 off)
>> @@ -317,7 +323,9 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
>>          host->cclk = 0;
>>
>>          if (desired) {
>> -               if (desired >= host->mclk) {
>> +               if (variant->cclk_is_mclk) {
>> +                       host->cclk = host->mclk;
>> +               } else if (desired >= host->mclk) {
>>                          clk = MCI_CLK_BYPASS;
>>                          if (variant->st_clkdiv)
>>                                  clk |= MCI_ST_UX500_NEG_EDGE;
>> @@ -1354,6 +1362,16 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>>          if (!ios->clock && variant->pwrreg_clkgate)
>>                  pwr &= ~MCI_PWR_ON;
>>
>> +       if (ios->clock != host->mclk && host->variant->explicit_mclk_control) {
>
> I suggest you should clarify the statement by adding a pair of extra
> parentheses. Additionally it seems like a good idea to reverse the
> order of the statements, to clarify this is for qcom clock handling
> only.
Yes, sure Will fix this in next version.

>
> More important, what I think you really want to do is to compare
> "ios->clock" with it's previous value it had when ->set_ios were
> invoked. Then let a changed value act as the trigger to set a new clk
> rate. Obvoiusly you need to cache the clock rate in the struct mmci
> host to handle this.

host->mclk already has this cached value.

>
>> +               int rc = clk_set_rate(host->clk, ios->clock);
>> +               if (rc < 0) {
>> +                       dev_err(mmc_dev(host->mmc),
>> +                               "Error setting clock rate (%d)\n", rc);
>> +               } else {
>> +                       host->mclk = clk_get_rate(host->clk);
>
> So here you actually find out the new clk rate, but shouldn't you
> update "host->mclk" within the spin_lock? Or it might not matter?
>
I think it does not matter in this case, as this is the only place mclk 
gets modified.
>> +               }
>> +       }
>> +
>>          spin_lock_irqsave(&host->lock, flags);
>>
>>          mmci_set_clkreg(host, ios->clock);
>> @@ -1540,10 +1558,12 @@ static int mmci_probe(struct amba_device *dev,
>>           * is not specified. Either value must not exceed the clock rate into
>>           * the block, of course.
>>           */
>> -       if (mmc->f_max)
>> -               mmc->f_max = min(host->mclk, mmc->f_max);
>> -       else
>> -               mmc->f_max = min(host->mclk, fmax);
>> +       if (!host->variant->explicit_mclk_control) {
>> +               if (mmc->f_max)
>> +                       mmc->f_max = min(host->mclk, mmc->f_max);
>> +               else
>> +                       mmc->f_max = min(host->mclk, fmax);
>> +       }
>
> This means your mmc->f_max value will either be zero or the one you
> provided through DT. And since zero won't work, that means you
> _require_ to get the value from DT. According to the documentation of
> this DT binding, f_max is optional.
>
> So unless you fine another way of dynamically at runtime figure out
> the value of f_max (using the clk API), you need to update the DT
> documentation for mmci.
>

You are right there is a possibility of f_max to be zero.

This logic could fix it.

if (host->variant->explicit_mclk_control) {
	if (mmc->f_max)
		mmc->f_max = max(host->mclk, mmc->f_max);
	else
		mmc->f_max = max(host->mclk, fmax);
} else {
	if (mmc->f_max)
		mmc->f_max = min(host->mclk, mmc->f_max);
	else
		mmc->f_max = min(host->mclk, fmax);
}



> Additionally, this makes me wonder about f_min. I haven't seen
> anywhere in this patch were that value is being set to proper value,
> right?
>

f_min should be 400000 for qcom, I think with the default mclk frequency 
and a divider of 512 used for calculating the f_min is bringing down the 
f_min to lessthan 400Kz. Which is why its working fine.
I think the possibility of mclk default frequency being greater than 
208Mhz is very less. so I could either leave it as it is Or force this 
to 400000 all the time for qcom chips.

Am ok either way..

Thanks,
srini

>>          dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
>>
>>          /* Get regulators and the supported OCR mask */
>> --
>> 1.9.1
>>
>
> Kind regards
> Ulf Hansson
>
