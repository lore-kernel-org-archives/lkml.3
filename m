Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaLDU0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:26:35 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37995 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbaLDU0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:26:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,517,1413270000"; 
   d="scan'208";a="52307285"
Message-ID: <5480C365.6020807@broadcom.com>
Date: Thu, 4 Dec 2014 12:26:13 -0800
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pwm: kona: Fix enable, disable and config procedures
References: <sbranden@broadcom.com> <1416944441-12066-1-git-send-email-sbranden@broadcom.com> <1416944441-12066-4-git-send-email-sbranden@broadcom.com> <CAD7vxx+FJzgXfik2XgJbw966Fsk-1m1znofuHEtvsDpm6cZY_g@mail.gmail.com>
In-Reply-To: <CAD7vxx+FJzgXfik2XgJbw966Fsk-1m1znofuHEtvsDpm6cZY_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Comments below.

On 14-11-25 11:29 PM, Tim Kryger wrote:
> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com> wrote:
>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>
>> - Added helper functions to set and clear smooth and trigger bits
>> - Added 400ns delays when clearing and setting trigger bit as requied
>>   by spec
>> - Added helper function to write prescale and other settings
>> - Updated config procedure to match spec
>> - Added code to handle pwn config when channel is disabled
>> - Updated disable procedure to match spec
>>
>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>  drivers/pwm/pwm-bcm-kona.c | 100 +++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 78 insertions(+), 22 deletions(-)
> 
> The driver is fairly small and this change rewrites a considerable amount of it.
> 
> Is there a actually specific deficiency that this change is intended to address?
> 
> I'm not sure all the extra helper functions improve readability.
> 

Hopefully my summary in the previous reply helps clarify. I'm going to
remove all the helper functions to make the changes as simple as possible.

>>
>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>> index fa0b5bf..06fa983 100644
>> --- a/drivers/pwm/pwm-bcm-kona.c
>> +++ b/drivers/pwm/pwm-bcm-kona.c
>> @@ -65,6 +65,10 @@
>>  #define DUTY_CYCLE_HIGH_MIN                    (0x00000000)
>>  #define DUTY_CYCLE_HIGH_MAX                    (0x00ffffff)
>>
>> +/* The delay required after clearing or setting
>> +   PWMOUT_ENABLE*/
>> +#define PWMOUT_ENABLE_HOLD_DELAY 400
>> +
>>  struct kona_pwmc {
>>         struct pwm_chip chip;
>>         void __iomem *base;
>> @@ -76,28 +80,70 @@ static inline struct kona_pwmc *to_kona_pwmc(struct pwm_chip *_chip)
>>         return container_of(_chip, struct kona_pwmc, chip);
>>  }
>>
>> -static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
>> +static inline void kona_pwmc_set_trigger(struct kona_pwmc *kp,
>> +                                        unsigned int chan)
>>  {
>>         unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>>
>> -       /* Clear trigger bit but set smooth bit to maintain old output */
>> -       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>> +       /* set trigger bit to enable channel */
>> +       value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +       ndelay(PWMOUT_ENABLE_HOLD_DELAY);
>> +}
>> +static inline void kona_pwmc_clear_trigger(struct kona_pwmc *kp,
>> +                                          unsigned int chan)
>> +{
>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /* Clear trigger bit */
>>         value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
>>         writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +       ndelay(PWMOUT_ENABLE_HOLD_DELAY);
>> +}
>>
>> -       /* Set trigger bit and clear smooth bit to apply new settings */
>> +static inline void kona_pwmc_clear_smooth(struct kona_pwmc *kp,
>> +                                         unsigned int chan)
>> +{
>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /* Clear smooth bit */
>>         value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>> -       value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
>>         writel(value, kp->base + PWM_CONTROL_OFFSET);
>>  }
>>
>> +static inline void kona_pwmc_set_smooth(struct kona_pwmc *kp, unsigned int chan)
>> +{
>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /*  set smooth bit to maintain old output */
>> +       value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
>> +       writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +}
>> +
>> +static void kona_pwmc_write_settings(struct kona_pwmc *kp, unsigned int chan,
>> +                                    unsigned long prescale, unsigned long pc,
>> +                                    unsigned long dc)
>> +{
>> +       unsigned int value;
>> +
>> +       value = readl(kp->base + PRESCALE_OFFSET);
>> +       value &= ~PRESCALE_MASK(chan);
>> +       value |= prescale << PRESCALE_SHIFT(chan);
>> +       writel(value, kp->base + PRESCALE_OFFSET);
>> +
>> +       writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>> +
>> +       writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +
>> +}
>> +
>>  static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>                             int duty_ns, int period_ns)
>>  {
>>         struct kona_pwmc *kp = to_kona_pwmc(chip);
>>         u64 val, div, rate;
>>         unsigned long prescale = PRESCALE_MIN, pc, dc;
>> -       unsigned int value, chan = pwm->hwpwm;
>> +       unsigned int ret, chan = pwm->hwpwm;
>>
>>         /*
>>          * Find period count, duty count and prescale to suit duty_ns and
>> @@ -133,19 +179,30 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>                         return -EINVAL;
>>         }
>>
>> -       /* If the PWM channel is enabled, write the settings to the HW */
>> -       if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> -               value = readl(kp->base + PRESCALE_OFFSET);
>> -               value &= ~PRESCALE_MASK(chan);
>> -               value |= prescale << PRESCALE_SHIFT(chan);
>> -               writel(value, kp->base + PRESCALE_OFFSET);
>>
>> -               writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
>> +       /* If the PWM channel is not enabled, enable the clock */
>> +       if (!test_bit(PWMF_ENABLED, &pwm->flags)) {
>> +               ret = clk_prepare_enable(kp->clk);
>> +               if (ret < 0) {
>> +                       dev_err(chip->dev, "failed to enable clock: %d\n", ret);
>> +                       return ret;
>> +               }
>> +       }
>>
>> -               writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +       /* Set smooth bit to maintain old output */
>> +       kona_pwmc_set_smooth(kp, chan);
>> +       kona_pwmc_clear_trigger(kp, chan);
>> +
>> +       /* apply new settings */
>> +       kona_pwmc_write_settings(kp, chan, prescale, pc, dc);
>> +
>> +       /*If the PWM is enabled, enable the channel with the new settings
>> +        and if not  disable the clock*/
>> +       if (test_bit(PWMF_ENABLED, &pwm->flags))
>> +               kona_pwmc_set_trigger(kp, chan);
>> +       else
>> +               clk_disable_unprepare(kp->clk);
>>
>> -               kona_pwmc_apply_settings(kp, chan);
>> -       }
>>
>>         return 0;
>>  }
>> @@ -188,7 +245,6 @@ static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>>                 dev_err(chip->dev, "failed to enable clock: %d\n", ret);
>>                 return ret;
>>         }
>> -
>>         ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
>>         if (ret < 0) {
>>                 clk_disable_unprepare(kp->clk);
>> @@ -203,12 +259,12 @@ static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>>         struct kona_pwmc *kp = to_kona_pwmc(chip);
>>         unsigned int chan = pwm->hwpwm;
>>
>> +       kona_pwmc_clear_smooth(kp, chan);
>> +       kona_pwmc_clear_trigger(kp, chan);
> 
> I believe the output will spike high here.  Likely not what you want...
> 
>>         /* Simulate a disable by configuring for zero duty */
>> -       writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> -       kona_pwmc_apply_settings(kp, chan);
>> -
>> -       /* Wait for waveform to settle before gating off the clock */
>> -       ndelay(400);
>> +       kona_pwmc_write_settings(kp, chan, 0, 0, 0);
>> +       kona_pwmc_set_polarity(chip, pwm, PWM_POLARITY_NORMAL);
> 
> This is wrong.  You shouldn't change the polarity when the PWM is disabled.

Agreed. No need to set polarity on disable.

> 
> The original polarity isn't even restored when it is re-enabled...
> 
>> +       kona_pwmc_set_trigger(kp, chan);
>>
>>         clk_disable_unprepare(kp->clk);
>>  }
>> --
>> 2.1.3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

