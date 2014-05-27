Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaE0Iqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:46:38 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:47054 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaE0Iqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <1401177400.8073.16.camel@AMDC1943>
References: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
	<1401110423-5647-3-git-send-email-k.kozlowski@samsung.com>
	<CAKew6eXdmif5-A+sb7-HEd3fP739RNy8SbzpCVRJ6uDgkyFvoQ@mail.gmail.com>
	<1401177400.8073.16.camel@AMDC1943>
Date: Tue, 27 May 2014 14:16:30 +0530
Message-ID: <CAKew6eX7szcRPSOmW9S4-MVZQCALyFz=bjTuVmoVFmOtA0UJOQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: s2mps11: Merge S2MPA01 driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 1:26 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On wto, 2014-05-27 at 12:00 +0530, Yadwinder Singh Brar wrote:
>> On Mon, May 26, 2014 at 6:50 PM, Krzysztof Kozlowski
>> <k.kozlowski@samsung.com> wrote:
>> > Add S2MPA01 support to the s2mps11 regulator driver. This obsoletes the
>> > s2mpa01 regulator driver.
>> >
>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>
>> > @@ -216,30 +250,20 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>> >                         ramp_delay = s2mps11->ramp_delay16;
>> >                 break;
>> >         case S2MPX_BUCK2:
>> > -               if (!ramp_delay) {
>> > -                       ramp_enable = 0;
>> > -                       break;
>> > -               }
>> > -
>>
>> What if we want to disable ramp_delay from DT ?
>
> It will work OK because at the beginning of s2mps11_set_ramp_delay():
>         unsigned int ramp_disable = !ramp_delay;
> This 'ramp_disable' is later used if enable/disable is supported.
>>

Oh! I missed you defined a new variable "ramp_disable",
 since ramp_disable is already a label defined in same function.
It should be different, i think.

>> > -               s2mps11->ramp_delay2 = ramp_delay;
>> > +               if (s2mps11->dev_type == S2MPS11X ||
>> > +                               ramp_delay > s2mps11->ramp_delay2)
>> > +                       s2mps11->ramp_delay2 = ramp_delay;
>> > +               else /* S2MPA01 && ramp_delay <= s2mpa01->ramp_delay24 */
>> > +                       ramp_delay = s2mps11->ramp_delay2;
>>
>> Here ramp_delay = 0(ramp_disable case) is also getting over written,
>> if required to take care of it later.
>
> The same, it is already stored as 'ramp_disable' local variable.
>
>>
>> >                 break;
>> >         case S2MPX_BUCK3:
>> > -               if (!ramp_delay) {
>> > -                       ramp_enable = 0;
>> > -                       break;
>> > -               }
>>
>> [snip]
>>
>> >
>> > -       if (!ramp_enable)
>> > -               goto ramp_disable;
>> > -
>> > -       /* Ramp delay can be enabled/disabled only for buck[2346] */
>> >         if (ramp_reg->enable_supported) {
>> > +               if (ramp_disable)
>>
>> typo ?    if (!ramp_enable) / if (!ramp_delay) ?
>
> I think it is good. I changed the 'ramp_enable' into 'ramp_disable'.
>

ok, but very next statement is
             goto ramp_disable;

which seems odd and obfuscated me.

> Anyway while reviewing the code I found that I didn't updated the case
> statements with new BUCKX enum values and the register for
> enable/disable is hard-coded. I'll fix it.
>>
>> > +                       goto ramp_disable;
>> > +
>>
>>
>> Also TBH, I can't get rationale behind this merge, As i can't see
>> considerable reduction in no of C code lines in comp of added
>> complexity.
>>  Is there considerable advantage in binary stats of single driver as
>> compare to independent drivers?
>
> Overall more code is removed than added:
> 6 files changed, 454 insertions(+), 719 deletions(-)
> but you are right that the code for ramp delay is now more complex. What
> is worth noting now most of ramp delay settings are moved to an array:
>
> static const struct s2mpx_ramp_reg s2mps11_ramp_regs[] = {
>         [S2MPX_BUCK1]   = s2mps11_ramp_reg(BUCK16),
>         [S2MPX_BUCK2]   = s2mps11_buck2346_ramp_reg(BUCK2, RAMP, BUCK2),
>         [S2MPX_BUCK3]   = s2mps11_buck2346_ramp_reg(BUCK34, RAMP, BUCK3)
>
> instead of being hard-coded into the big switch statement like it was
> before.
>
> Alternative solution to complex ramp delay setting is to just use
> original functions: s2mps11_set_ramp_delay and s2mpa01_set_ramp_delay.
>
> These chips are really similar so having two drivers seems like doubling
> the effort for maintaining them.
>

I think maintaining a complex or a big file(in case we keep original
functions), itself will be an effort consuming thing and moreover
binary size of a single driver will also increase considerable as
compare to independent drivers (if its not case of multiplatform
kernel).

Anyways, i think its matter of preference of all, It will be OK, if
for others( especially maintainers, Mark ?), its OK.


Best Regards,
Yadwinder

> Thanks for comments.
>
> Best regards,
> Krzysztof
>
