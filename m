Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaE0Mnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:43:52 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56075 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaE0Mns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:43:48 -0400
Message-ID: <5384887F.2060505@linaro.org>
Date: Tue, 27 May 2014 13:43:43 +0100
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
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849578-7585-1-git-send-email-srinivas.kandagatla@linaro.org>	<CAPDyKFqz-O9-Douk96LBuFRD_P1146c_Ld14TgiduBgfBqRi_A@mail.gmail.com>	<5383C28D.1060808@linaro.org> <CAPDyKFpD==5wMZa5KbcMpGnZMTyncmGZfc=17j0=YjKT8qq5bg@mail.gmail.com>
In-Reply-To: <CAPDyKFpD==5wMZa5KbcMpGnZMTyncmGZfc=17j0=YjKT8qq5bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/05/14 10:32, Ulf Hansson wrote:
> On 27 May 2014 00:39, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>> Hi Ulf,
>> Thankyou for the comments.
>>
>>
>> On 26/05/14 15:21, Ulf Hansson wrote:
>>>
>>> On 23 May 2014 14:52,  <srinivas.kandagatla@linaro.org> wrote:
>>>>
>>>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>>>
>>>> On Controllers like Qcom SD card controller where cclk is mclk and mclk
>>>> should
>>>> be directly controlled by the driver.
>>>>
...

>>>>            * for 3 clk cycles.
>>>>            */
>>>>           .mclk_delayed_writes    = true,
>>>> +       .explicit_mclk_control  = true,
>>>> +       .cclk_is_mclk   = true,
>>>>    };
>>>>
>>>>    static inline u32 mmci_readl(struct mmci_host *host, u32 off)
>>>> @@ -317,7 +323,9 @@ static void mmci_set_clkreg(struct mmci_host *host,
>>>> unsigned int desired)
>>>>           host->cclk = 0;
>>>>
>>>>           if (desired) {
>>>> -               if (desired >= host->mclk) {
>>>> +               if (variant->cclk_is_mclk) {
>>>> +                       host->cclk = host->mclk;
>>>> +               } else if (desired >= host->mclk) {
>>>>                           clk = MCI_CLK_BYPASS;
>>>>                           if (variant->st_clkdiv)
>>>>                                   clk |= MCI_ST_UX500_NEG_EDGE;
>>>> @@ -1354,6 +1362,16 @@ static void mmci_set_ios(struct mmc_host *mmc,
>>>> struct mmc_ios *ios)
>>>>           if (!ios->clock && variant->pwrreg_clkgate)
>>>>                   pwr &= ~MCI_PWR_ON;
>>>>
>>>> +       if (ios->clock != host->mclk &&
>>>> host->variant->explicit_mclk_control) {
>>>
>>>
>>> I suggest you should clarify the statement by adding a pair of extra
>>> parentheses. Additionally it seems like a good idea to reverse the
>>> order of the statements, to clarify this is for qcom clock handling
>>> only.
>>
>> Yes, sure Will fix this in next version.
>>
>>
>>>
>>> More important, what I think you really want to do is to compare
>>> "ios->clock" with it's previous value it had when ->set_ios were
>>> invoked. Then let a changed value act as the trigger to set a new clk
>>> rate. Obvoiusly you need to cache the clock rate in the struct mmci
>>> host to handle this.
>>
>>
>> host->mclk already has this cached value.
>
> There are no guarantees clk_set_rate() will manage to set the exact
> requested rate as ios->clock. At least if you follow the clk API
> documentation.
>

Yes, I agree. caching ios->clock looks like the best option.

>>
>>
>>>

...

>>
>>>> +               }
>>>> +       }
>>>> +
>>>>           spin_lock_irqsave(&host->lock, flags);
>>>>
>>>>           mmci_set_clkreg(host, ios->clock);
>>>> @@ -1540,10 +1558,12 @@ static int mmci_probe(struct amba_device *dev,
>>>>            * is not specified. Either value must not exceed the clock rate
>>>> into
>>>>            * the block, of course.
>>>>            */
>>>> -       if (mmc->f_max)
>>>> -               mmc->f_max = min(host->mclk, mmc->f_max);
>>>> -       else
>>>> -               mmc->f_max = min(host->mclk, fmax);
>>>> +       if (!host->variant->explicit_mclk_control) {
>>>> +               if (mmc->f_max)
>>>> +                       mmc->f_max = min(host->mclk, mmc->f_max);
>>>> +               else
>>>> +                       mmc->f_max = min(host->mclk, fmax);
>>>> +       }
>>>
>>>
>>> This means your mmc->f_max value will either be zero or the one you
>>> provided through DT. And since zero won't work, that means you
>>> _require_ to get the value from DT. According to the documentation of
>>> this DT binding, f_max is optional.
>>>
>>> So unless you fine another way of dynamically at runtime figure out
>>> the value of f_max (using the clk API), you need to update the DT
>>> documentation for mmci.
>>>
>>
>> You are right there is a possibility of f_max to be zero.
>>
>> This logic could fix it.
>>
>> if (host->variant->explicit_mclk_control) {
>>          if (mmc->f_max)
>>                  mmc->f_max = max(host->mclk, mmc->f_max);
>>          else
>>                  mmc->f_max = max(host->mclk, fmax);
>> } else {
>>          if (mmc->f_max)
>>
>>                  mmc->f_max = min(host->mclk, mmc->f_max);
>>          else
>>
>>                  mmc->f_max = min(host->mclk, fmax);
>> }
>>
>
> Hmm. Looking a bit deeper into this, we have some additional related
> code to fixup. :-)
>
> In ->probe(), we do clk_set_rate(100MHz), if the mclk > 100MHz. That's
> due to the current variants don't support higher frequency than this.
> It seems like the Qcom variant may support up to 208MHz? Now, if
> that's the case, we need to add "f_max" to the struct variant_data to
> store this information, so we can respect different values while doing
> clk_set_rate() at ->probe().
>
Yes, qcom SOCs support more than 100Hhz clock.

Probe and clk_set_rate/set_ios should respect this.

On the other thought, Should probe actually care about clocks which are 
explicitly controlled? It should not even attempt to set any frequency 
to start with. mmc-core would set the right frequency depending on the 
mmc state-machine respecting f_min and f_max.
I think for qcom, probe should just check the if f_max and f_min are 
valid and set them to defaults if any in the same lines as existing code.

> While updating mmc->f_max for host->variant->explicit_mclk_control, we
> shouldn't care about using the host->mclk as a limiter, instead, use
> min(mmc->f_max, host->variant->f_max) and fallback to fmax.
>
Yes, that's correct, mclk should not be used as limiter. Adding f_max to 
the variant looks useful.

> Not sure how that will affect the logic. :-)
>
>>
>>
>>> Additionally, this makes me wonder about f_min. I haven't seen
>>> anywhere in this patch were that value is being set to proper value,
>>> right?
>>>
>>
>> f_min should be 400000 for qcom, I think with the default mclk frequency and
>> a divider of 512 used for calculating the f_min is bringing down the f_min
>> to lessthan 400Kz. Which is why its working fine.
>> I think the possibility of mclk default frequency being greater than 208Mhz
>> is very less. so I could either leave it as it is Or force this to 400000
>> all the time for qcom chips.
>
> No, this seems like a wrong approach.
>
> I think you would like to do use the clk_round_rate() find out the
> lowest possible rate. Or just use a fixed fallback value somehow.

clk_round_rate(mclk, 0) might be more generic, instead of fixed 
fallback. Let the mmc-core figure out what frequency would be best from 
its table starting from f_min.

thanks,
srini
>
> Kind regards
> Ulf Hansson
>
