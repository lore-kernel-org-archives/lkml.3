Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaLATwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:52:41 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8214 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaLATwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:52:39 -0500
X-IronPort-AV: E=Sophos;i="5.07,495,1413270000"; 
   d="scan'208";a="51828278"
Message-ID: <547CC392.3070508@broadcom.com>
Date: Mon, 1 Dec 2014 11:37:54 -0800
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pwm: kona: Fix enable, disable and config procedures
References: <sbranden@broadcom.com>	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>	<1416944441-12066-4-git-send-email-sbranden@broadcom.com>	<CAD7vxx+FJzgXfik2XgJbw966Fsk-1m1znofuHEtvsDpm6cZY_g@mail.gmail.com>	<54790A0F.2010506@broadcom.com> <CAD7vxx++oRKPyRYzMc4MubHM4VzRB8j9jrPsS-wALNOhL8BaWw@mail.gmail.com>
In-Reply-To: <CAD7vxx++oRKPyRYzMc4MubHM4VzRB8j9jrPsS-wALNOhL8BaWw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14-11-28 06:30 PM, Tim Kryger wrote:
> On Fri, Nov 28, 2014 at 3:49 PM, Arun Ramamurthy
> <arun.ramamurthy@broadcom.com> wrote:
>>
>>
>> On 14-11-25 11:29 PM, Tim Kryger wrote:
>>>
>>> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com>
>>> wrote:
>>>>
>>>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>>>
>>>> - Added helper functions to set and clear smooth and trigger bits
>>>> - Added 400ns delays when clearing and setting trigger bit as requied
>>>>     by spec
>>>> - Added helper function to write prescale and other settings
>>>> - Updated config procedure to match spec
>>>> - Added code to handle pwn config when channel is disabled
>>>> - Updated disable procedure to match spec
>>>>
>>>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>>>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>>>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>>> ---
>>>>    drivers/pwm/pwm-bcm-kona.c | 100
>>>> +++++++++++++++++++++++++++++++++++----------
>>>>    1 file changed, 78 insertions(+), 22 deletions(-)
>>>
>>>
>>> The driver is fairly small and this change rewrites a considerable amount
>>> of it.
>>>
>>> Is there a actually specific deficiency that this change is intended to
>>> address?
>>>
>> The main issue this patchset addresses is setting the period and duty cycle
>> when the pwm is disabled. This is done by turning on the clock and writing
>> to the PWM registers. Additionally it also adds the 400ns
>> delays specified by the PWM spec when setting or clearing certain bits. It
>> also updates the PWM programming procedure to match the spec more closely.
>> Although there is considerable change, all of it addresses the core
>> functionality and it would not make sense to split it into multiple patches.
>
> So what you are saying is that there isn't any known issue that this resolves.
>
> This only changes the driver to use an alternate programming sequence?
>
> The benefit here seems uncertain.
>
Actually Tim, it addresses the bug where period and duty cycle are not 
set if the PWM channel is not enabled in sysfs. Following up on your 
example you provided in your other email:

# Disable PWM
echo 0 > enable

# Change to a 25% duty output when PWM is enabled
echo 25000 > duty_cycle

The original code would not write this duty cycle change to the 
registers as the PWmF_ENABLED bit is not set and the clocks are turned off.

I can remove all the helper functions and address only this particular 
bug if you prefer that.
>>
>>> I'm not sure all the extra helper functions improve readability.
>>>
>> There was a lot of repeated code in various different functions. It seemed
>> more efficient to consolidate them into helper functions. It also helped
>> when comparing the spec to the code to check if we were
>> setting the bits in the right order.
>>
>>
>>>>
>>>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>>>> index fa0b5bf..06fa983 100644
>>>> --- a/drivers/pwm/pwm-bcm-kona.c
>>>> +++ b/drivers/pwm/pwm-bcm-kona.c
>>>> @@ -65,6 +65,10 @@
>>>>    #define DUTY_CYCLE_HIGH_MIN                    (0x00000000)
>>>>    #define DUTY_CYCLE_HIGH_MAX                    (0x00ffffff)
>>>>
>>>> +/* The delay required after clearing or setting
>>>> +   PWMOUT_ENABLE*/
>>>> +#define PWMOUT_ENABLE_HOLD_DELAY 400
>>>> +
>>>>    struct kona_pwmc {
>>>>           struct pwm_chip chip;
>>>>           void __iomem *base;
>>>> @@ -76,28 +80,70 @@ static inline struct kona_pwmc *to_kona_pwmc(struct
>>>> pwm_chip *_chip)
>>>>           return container_of(_chip, struct kona_pwmc, chip);
>>>>    }
>>>>
>>>> -static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int
>>>> chan)
>>>> +static inline void kona_pwmc_set_trigger(struct kona_pwmc *kp,
>>>> +                                        unsigned int chan)
>>>>    {
>>>>           unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>>>
>>>> -       /* Clear trigger bit but set smooth bit to maintain old output */
>>>> -       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>>>> +       /* set trigger bit to enable channel */
>>>> +       value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
>>>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>> +       ndelay(PWMOUT_ENABLE_HOLD_DELAY);
>>>> +}
>>>> +static inline void kona_pwmc_clear_trigger(struct kona_pwmc *kp,
>>>> +                                          unsigned int chan)
>>>> +{
>>>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>>> +
>>>> +       /* Clear trigger bit */
>>>>           value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
>>>>           writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>> +       ndelay(PWMOUT_ENABLE_HOLD_DELAY);
>>>> +}
>>>>
>>>> -       /* Set trigger bit and clear smooth bit to apply new settings */
>>>> +static inline void kona_pwmc_clear_smooth(struct kona_pwmc *kp,
>>>> +                                         unsigned int chan)
>>>> +{
>>>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>>> +
>>>> +       /* Clear smooth bit */
>>>>           value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>>>> -       value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
>>>>           writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>>    }
>>>>
>>>> +static inline void kona_pwmc_set_smooth(struct kona_pwmc *kp, unsigned
>>>> int chan)
>>>> +{
>>>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>>> +
>>>> +       /*  set smooth bit to maintain old output */
>>>> +       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>>>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>> +}
>>>> +
>>>> +static void kona_pwmc_write_settings(struct kona_pwmc *kp, unsigned int
>>>> chan,
>>>> +                                    unsigned long prescale, unsigned
>>>> long pc,
>>>> +                                    unsigned long dc)
>>>> +{
>>>> +       unsigned int value;
>>>> +
>>>> +       value = readl(kp->base + PRESCALE_OFFSET);
>>>> +       value &= ~PRESCALE_MASK(chan);
>>>> +       value |= prescale << PRESCALE_SHIFT(chan);
>>>> +       writel(value, kp->base + PRESCALE_OFFSET);
>>>> +
>>>> +       writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>>>> +
>>>> +       writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>>>> +
>>>> +}
>>>> +
>>>>    static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device
>>>> *pwm,
>>>>                               int duty_ns, int period_ns)
>>>>    {
>>>>           struct kona_pwmc *kp = to_kona_pwmc(chip);
>>>>           u64 val, div, rate;
>>>>           unsigned long prescale = PRESCALE_MIN, pc, dc;
>>>> -       unsigned int value, chan = pwm->hwpwm;
>>>> +       unsigned int ret, chan = pwm->hwpwm;
>>>>
>>>>           /*
>>>>            * Find period count, duty count and prescale to suit duty_ns
>>>> and
>>>> @@ -133,19 +179,30 @@ static int kona_pwmc_config(struct pwm_chip *chip,
>>>> struct pwm_device *pwm,
>>>>                           return -EINVAL;
>>>>           }
>>>>
>>>> -       /* If the PWM channel is enabled, write the settings to the HW */
>>>> -       if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>>>> -               value = readl(kp->base + PRESCALE_OFFSET);
>>>> -               value &= ~PRESCALE_MASK(chan);
>>>> -               value |= prescale << PRESCALE_SHIFT(chan);
>>>> -               writel(value, kp->base + PRESCALE_OFFSET);
>>>>
>>>> -               writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>>>> +       /* If the PWM channel is not enabled, enable the clock */
>>>> +       if (!test_bit(PWMF_ENABLED, &pwm->flags)) {
>>>> +               ret = clk_prepare_enable(kp->clk);
>>>> +               if (ret < 0) {
>>>> +                       dev_err(chip->dev, "failed to enable clock:
>>>> %d\n", ret);
>>>> +                       return ret;
>>>> +               }
>>>> +       }
>>>>
>>>> -               writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>>>> +       /* Set smooth bit to maintain old output */
>>>> +       kona_pwmc_set_smooth(kp, chan);
>>>> +       kona_pwmc_clear_trigger(kp, chan);
>>>> +
>>>> +       /* apply new settings */
>>>> +       kona_pwmc_write_settings(kp, chan, prescale, pc, dc);
>>>> +
>>>> +       /*If the PWM is enabled, enable the channel with the new settings
>>>> +        and if not  disable the clock*/
>>>> +       if (test_bit(PWMF_ENABLED, &pwm->flags))
>>>> +               kona_pwmc_set_trigger(kp, chan);
>>>> +       else
>>>> +               clk_disable_unprepare(kp->clk);
>>>>
>>>> -               kona_pwmc_apply_settings(kp, chan);
>>>> -       }
>>>>
>>>>           return 0;
>>>>    }
>>>> @@ -188,7 +245,6 @@ static int kona_pwmc_enable(struct pwm_chip *chip,
>>>> struct pwm_device *pwm)
>>>>                   dev_err(chip->dev, "failed to enable clock: %d\n", ret);
>>>>                   return ret;
>>>>           }
>>>> -
>>>>           ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
>>>>           if (ret < 0) {
>>>>                   clk_disable_unprepare(kp->clk);
>>>> @@ -203,12 +259,12 @@ static void kona_pwmc_disable(struct pwm_chip
>>>> *chip, struct pwm_device *pwm)
>>>>           struct kona_pwmc *kp = to_kona_pwmc(chip);
>>>>           unsigned int chan = pwm->hwpwm;
>>>>
>>>> +       kona_pwmc_clear_smooth(kp, chan);
>>>> +       kona_pwmc_clear_trigger(kp, chan);
>>>
>>>
>>> I believe the output will spike high here.  Likely not what you want...
>>
>>
>> According to spec, this is the procedure to program the PWM and the code
>> follows that:
>>
>> STEP0: Program SMOOTH_TYPE=1. That will only allow changing of PWM setting
>> at the PWM period boundary.
>>   STEP1: Program PWMOUT_ENABLE=0. At this time, PWM internal logic will
>> continue to run with the previous settings. (i.e. If PWM is at 50Hz 40% duty
>> cycle before, during the time when PWMOUT_ENABLE=0, it will still run at
>> 50MHz 40% duty cycle.)
>>   STEP2: Program PWM register for new setting (i.e. PRESCALE, DUTY, PERIOD
>> etc)
>>   STEP3: Program PWMOUT_ENABLE=1. That will load the new PWM setting from APB
>> into PWM internal register. (Note. Minimum of 400ns is needed between step1
>> and step3. )
>>   STEP4: Keep PWMOUT ENABLE=1. (Note: If user didn't hold PWMOUT_ENABLE=1 for
>> longer than 400ns, PWM internal logic will discard the new PWM setting in
>> step2. User should hold the PWMOUT_ENABLE=1 unless new PWM settings is
>> needed.)
>>
>>
>>
>>>
>>>>           /* Simulate a disable by configuring for zero duty */
>>>> -       writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>>>> -       kona_pwmc_apply_settings(kp, chan);
>>>> -
>>>> -       /* Wait for waveform to settle before gating off the clock */
>>>> -       ndelay(400);
>>>> +       kona_pwmc_write_settings(kp, chan, 0, 0, 0);
>>>> +       kona_pwmc_set_polarity(chip, pwm, PWM_POLARITY_NORMAL);
>>>
>>>
>>> This is wrong.  You shouldn't change the polarity when the PWM is
>>> disabled.
>>>
>>> The original polarity isn't even restored when it is re-enabled...
>>>
>> this is procedure from the PWM spec to disable :
>>
>> STEP0: Program SMOOTH_TYPE=0.
>>   STEP1: Program PWMOUT_ENABLE=0. Now, PWM internal logic will be at reset,
>> PWM output will be default at 1.
>
> This is exactly what I was saying before.  You glitch the output high
> for no good reason.
>
> The sequence in the document isn't gospel.  From what I recall, it was
> just a verification engineer's best guess at how to get a very unusual
> PWM controller to do the normal PWM things.

So to summarize, you would prefer that the disable procedure be left 
unchanged which is to set the duty cycle to zero.
>
>>   STEP2: Program PWM register to these setting. PRESCALE=0, POLARITY=1,
>> DUTY=0, PERIOD=0.
>>   STEP3: Program PWMOUT_ENABLE=1, and Keep SMOOTH_TYPE=0.
>>   STEP4: Turn off PWM clock from CCU, and Keep PWMOUT ENABLE=1. (Note, It
>> takes 400ns from STEP3 to turn off the LCD backlight, and user should
>> guarantee that the PWM clock will not be disabled in less than 400ns after
>> STEP3.
>>
>> I agree with you that the original polarity isnt restored. I will need to
>> add some code to check the syfs polarity value when the PWM is enabled.
>> However, if i was to comply with the above spec, I would still have set the
>> polarity. I just realized it should be set to inverted and I will fix this
>> in the next patchset
>>
>>
>>>> +       kona_pwmc_set_trigger(kp, chan);
>>>>
>>>>           clk_disable_unprepare(kp->clk);
>>>>    }
>>>> --
>>>> 2.1.3
>>>>
>>
