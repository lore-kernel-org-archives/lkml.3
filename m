Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaLVWtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:49:45 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8959 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaLVWtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:49:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,627,1413270000"; 
   d="scan'208";a="53494170"
Message-ID: <5498A005.1090104@broadcom.com>
Date: Mon, 22 Dec 2014 14:49:41 -0800
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] pwm: kona: Fix incorrect enable, config, and disable
 procedures
References: <jonathar@broadcom.com> <1418841982-29793-1-git-send-email-jonathar@broadcom.com> <CAD7vxxJvSzJtBcuy9wsHn-AT2LyetRrKUy5CnKjPdwr1HVqCgg@mail.gmail.com>
In-Reply-To: <CAD7vxxJvSzJtBcuy9wsHn-AT2LyetRrKUy5CnKjPdwr1HVqCgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-20 02:38 PM, Tim Kryger wrote:
> On Wed, Dec 17, 2014 at 10:46 AM, Jonathan Richardson
> <jonathar@broadcom.com> wrote:
>>     The config procedure doesn't follow the spec which periodically results
>>     in failing to enable the output signal. This happens one in ten or
>>     twenty attempts. Following the spec and adding a 400ns delay in the
>>     appropriate locations resolves this problem. It also ensures that the
>>     signal transition is smooth.
> 
> This patch does not result in smooth transitions.
> 
> Please ensure that your commit message reflects the code.

I'll remove the last sentence. I would have to re-verify that it's accurate.

> 
>>
>>     If config is called when the pwm is disabled and there is nothing to do,
>>     the while loop to calculate duty cycle and period doesn't need to be
>>     done. The function now just returns if the pwm state is disabled.
>>
>>     The disable procedure now also follows the spec to ensure a smooth
>>     transition. Not following the spec can cause non-smooth transitions.
>>
>>     The enable procedure now clears the enabled bit if enabling failed.
>>     Enabling can fail if an invalid duty cycle and period is set. This
>>     prevents the sysfs interface from reporting the pwm is enabled after a
>>     failed call to enable.
>>
>> Reviewed-by: Arun Ramamurthy <arunrama@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> Tested-by: Scott Branden <sbranden@broadcom.com>
>> Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
> 
> Normally when people send a multi-part patch series they include a
> cover letter that describes the overall purpose of the changes with a
> description of changes introduced in each revision of the series.
> 
> Please follow this convention.

Will do.

> 
>> ---
>>  drivers/pwm/pwm-bcm-kona.c |   91 ++++++++++++++++++++++++++++++++------------
>>  1 file changed, 67 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>> index 02bc048..a831bb2 100644
>> --- a/drivers/pwm/pwm-bcm-kona.c
>> +++ b/drivers/pwm/pwm-bcm-kona.c
>> @@ -80,15 +80,19 @@ static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
>>  {
>>         unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>
>> -       /* Clear trigger bit but set smooth bit to maintain old output */
>> -       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>> -       value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
>> -       writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +       /*
>> +        * There must be a min 400ns delay between clearing enable and setting
>> +        * it. Failing to do this may result in no PWM signal.
>> +        */
>> +       ndelay(400);
>>
>>         /* Set trigger bit and clear smooth bit to apply new settings */
>>         value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>>         value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
>>         writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /* PWMOUT_ENABLE must be held high for at least 400 ns. */
>> +       ndelay(400);
>>  }
>>
> 
> Can you try to get a better understanding of what these timing
> requirements actually are?
> 
> When I wrote this driver, the documentation simply stated that if the
> trigger bit didn't stay high for 400 ns then the new settings would
> not get applied.
> 
> It wasn't essential that we wait 400 ns here because the only time
> when the trigger bit would be lowered is when we were about to load
> even newer settings which meant we didn't care if the previous
> settings were lost.

I'm not spending any more time trying to understand exactly why these
delays are required. All I know is that they are required. Failing to
follow the updated documentation from the ASIC engineers sometimes
resulted in no output signal as stated in the commit message. The docs
you had at the time may have been inaccurate or incomplete.

> 
>>  static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> @@ -99,6 +103,9 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>         unsigned long prescale = PRESCALE_MIN, pc, dc;
>>         unsigned int value, chan = pwm->hwpwm;
>>
>> +       if (!test_bit(PWMF_ENABLED, &pwm->flags))
>> +               return 0;
>> +
>>         /*
>>          * Find period count, duty count and prescale to suit duty_ns and
>>          * period_ns. This is done according to formulas described below:
> 
> Like I said last time, this is wrong.  You need to sanity check the
> requested period and duty cycle here.

I don't agree. I actually like the code in its original form in this
case. The period and duty cycle are calculated as a function of the
prescale so the loop is responsible for figuring out what values are
correct or not as it iterates. Unless there is a more compelling reason
to change it, I'm going to leave it as is.

> 
> You can't just return success immediately when the channel isn't enabled.

I'll make it return an error.

> 
>> @@ -121,31 +128,60 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>                 dc = div64_u64(val, div);
>>
>>                 /* If duty_ns or period_ns are not achievable then return */
>> -               if (pc < PERIOD_COUNT_MIN || dc < DUTY_CYCLE_HIGH_MIN)
>> +               if (pc < PERIOD_COUNT_MIN) {
>> +                       dev_warn(chip->dev,
>> +                               "%s: pwm[%d]: period=%d is not achievable, pc=%lu, prescale=%lu\n",
>> +                               __func__, chan, period_ns, pc, prescale);
>>                         return -EINVAL;
>> +               }
>> +
>> +               /* If duty_ns is not achievable then return */
>> +               if (dc < DUTY_CYCLE_HIGH_MIN) {
>> +                       if (0 != duty_ns) {
>> +                               dev_warn(chip->dev,
>> +                                       "%s: pwm[%d]: duty cycle=%d is not achievable, dc=%lu, prescale=%lu\n",
>> +                                       __func__, chan, duty_ns, dc, prescale);
>> +                       }
>> +                       return -EINVAL;
>> +               }
>>
>>                 /* If pc and dc are in bounds, the calculation is done */
>>                 if (pc <= PERIOD_COUNT_MAX && dc <= DUTY_CYCLE_HIGH_MAX)
>>                         break;
>>
>>                 /* Otherwise, increase prescale and recalculate pc and dc */
>> -               if (++prescale > PRESCALE_MAX)
>> +               if (++prescale > PRESCALE_MAX) {
>> +                       dev_warn(chip->dev,
>> +                               "%s: pwm[%d]: Prescale (=%lu) within max (=%d) for period=%d and duty cycle=%d is not achievable\n",
>> +                               __func__, chan, prescale, PRESCALE_MAX,
>> +                               period_ns, duty_ns);
>>                         return -EINVAL;
>> +               }
>>         }
>>
>> -       /* If the PWM channel is enabled, write the settings to the HW */
>> -       if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> -               value = readl(kp->base + PRESCALE_OFFSET);
>> -               value &= ~PRESCALE_MASK(chan);
>> -               value |= prescale << PRESCALE_SHIFT(chan);
>> -               writel(value, kp->base + PRESCALE_OFFSET);
>> +       dev_dbg(chip->dev, "pwm[%d]: period=%lu, duty_high=%lu, prescale=%lu\n",
>> +               chan, pc, dc, prescale);
>>
>> -               writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>> +       value = readl(kp->base + PWM_CONTROL_OFFSET);
>>
>> -               writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +       /*
>> +        * Clear trigger bit but set smooth bit to maintain old
>> +        * output.
>> +        */
>> +       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>> +       value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>>
>> -               kona_pwmc_apply_settings(kp, chan);
>> -       }
>> +       value = readl(kp->base + PRESCALE_OFFSET);
>> +       value &= ~PRESCALE_MASK(chan);
>> +       value |= prescale << PRESCALE_SHIFT(chan);
>> +       writel(value, kp->base + PRESCALE_OFFSET);
>> +
>> +       writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>> +
>> +       writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +
>> +       kona_pwmc_apply_settings(kp, chan);
>>
>>         return 0;
>>  }
> 
> There is no requirement to lower the trigger bit prior to writing the
> period and duty registers.
> 
> This change is unnecessary.  The old sequence was fine.

Incorrect. The old sequence was flawed as already discussed. I'll refer
you the updated spec in previous discussion that was already sent to
you. Not following the spec really does occasionally result in no output
signal as the commit message states.

> 
>> @@ -173,11 +209,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>>
>>         writel(value, kp->base + PWM_CONTROL_OFFSET);
>>
>> -       kona_pwmc_apply_settings(kp, chan);
>> -
>> -       /* Wait for waveform to settle before gating off the clock */
>> -       ndelay(400);
>> -
>>         clk_disable_unprepare(kp->clk);
>>
>>         return 0;
> 
> I'm not completely convinced that changing the polarity behavior is beneficial.
> 
> Please mention this change in your commit description and provide
> appropriate justification.

I'll update the commit message. You won't get any polarity change
without the added code. It doesn't work.

> 
>> @@ -190,12 +221,14 @@ static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>>
>>         ret = clk_prepare_enable(kp->clk);
>>         if (ret < 0) {
>> +               clear_bit(PWMF_ENABLED, &pwm->flags);
>>                 dev_err(chip->dev, "failed to enable clock: %d\n", ret);
>>                 return ret;
>>         }
>>
>>         ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
>>         if (ret < 0) {
>> +               clear_bit(PWMF_ENABLED, &pwm->flags);
>>                 clk_disable_unprepare(kp->clk);
>>                 return ret;
>>         }
> 
> Don't try to fix this in the Kona PWM driver, fix it in the PWM core.

I agree that's where the fix should go. I wasn't sure I could make the
change or not. I'll make the change and put it in a different commit.

> 
>> @@ -207,13 +240,23 @@ static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>>  {
>>         struct kona_pwmc *kp = to_kona_pwmc(chip);
>>         unsigned int chan = pwm->hwpwm;
>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /* Set smooth type to 1 and disable */
>> +       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>> +       value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>>
>>         /* Simulate a disable by configuring for zero duty */
>>         writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> -       kona_pwmc_apply_settings(kp, chan);
>> +       writel(0, kp->base + PERIOD_COUNT_OFFSET(chan));
>>
>> -       /* Wait for waveform to settle before gating off the clock */
>> -       ndelay(400);
>> +       /* Set prescale to 0 for this channel */
>> +       value = readl(kp->base + PRESCALE_OFFSET);
>> +       value &= ~PRESCALE_MASK(chan);
>> +       writel(value, kp->base + PRESCALE_OFFSET);
> 
> Can you explain why it is necessary to change the prescale here?

Spec recommendation and it's cleaner. We'd like the code to match the
spec now that we have more detailed documentation. There is nothing
dysfunctional about setting the prescale to the default value on disable
that I can see.

> 
>> +
>> +       kona_pwmc_apply_settings(kp, chan);
>>
>>         clk_disable_unprepare(kp->clk);
>>  }
>> --
>> 1.7.9.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

