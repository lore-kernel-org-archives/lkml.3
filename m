Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaCRXrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:47:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49467 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaCRXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140318215231.GH5917@mithrandir>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
	<1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
	<20140318215231.GH5917@mithrandir>
Date: Tue, 18 Mar 2014 16:47:36 -0700
Message-ID: <CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] pwm: kona: Introduce Kona PWM controller support
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 2:52 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Mar 12, 2014 at 01:15:43PM -0700, Tim Kryger wrote:
> [...]
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index 22f2f28..1fd42af 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -62,6 +62,16 @@ config PWM_ATMEL_TCB
>>         To compile this driver as a module, choose M here: the module
>>         will be called pwm-atmel-tcb.
>>
>> +config PWM_BCM_KONA
>> +     tristate "Kona PWM support"
>> +     depends on ARCH_BCM_MOBILE
>> +     default y
>
> No "default y", please.

Even though it depends on ARCH_BCM_MOBILE?  It seems like a reasonable default.

These SoCs target mobile phones which almost always have a backlight
controlled by the PWM.

>
>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
> [...]
>> +static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
>> +{
>> +     unsigned long value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +     /*
>> +      * New duty and period settings are only reflected in the PWM output
>> +      * after a rising edge of the enable bit.  When smooth bit is set, the
>> +      * new settings are delayed until the prior PWM period has completed.
>> +      * Furthermore, if the smooth bit is set, the PWM continues to output a
>> +      * waveform based on the old settings during the time that the enable
>> +      * bit is low.  Otherwise the output is a constant high signal while
>> +      * the enable bit is low.
>> +      */
>> +
>> +     /* clear enable bit but set smooth bit to maintain old output */
>> +     value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>
> There's no need for the parentheses here.

Ok

>
>> +     value &= ~(1 << PWM_CONTROL_ENABLE_SHIFT(chan));
>> +     writel(value, kp->base + PWM_CONTROL_OFFSET);
>> +
>> +     /* set enable bit and clear smooth bit to apply new settings */
>> +     value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>> +     value |= (1 << PWM_CONTROL_ENABLE_SHIFT(chan));
>
> Nor here.

Ok

>
>> +     writel(value, kp->base + PWM_CONTROL_OFFSET);
>
> I'm curious about how this work. The above writes the control register
> once with smooth set and enable cleared, then immediately rewrites it
> again with smooth cleared and enable set. Are these writes somehow
> queued in hardware, so that the subsequent write becomes active only
> after the current period?

It isn't exactly queuing up the writes but if smooth mode is set, it
will wait to apply the new settings.

>
>> +static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                             int duty_ns, int period_ns)
>
> Please align arguments on subsequent lines with those on the first line.

Sure

>
>> +{
>> +     struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
>
> The proper way to do this would be upcasting using container_of().
> Better yet, define a static inline function that wraps container_of(),
> just like very other driver does.
>

I will convert to use this approach (except in kona_pwmc_remove)

>> +     u64 val, div, clk_rate;
>> +     unsigned long prescale = PRESCALE_MIN, pc, dc;
>> +     unsigned int value, chan = pwm->hwpwm;
>> +
>> +     /*
>> +      * Find period count, duty count and prescale to suit duty_ns and
>> +      * period_ns. This is done according to formulas described below:
>> +      *
>> +      * period_ns = 10^9 * (PRESCALE + 1) * PC / PWM_CLK_RATE
>> +      * duty_ns = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
>> +      *
>> +      * PC = (PWM_CLK_RATE * period_ns) / (10^9 * (PRESCALE + 1))
>> +      * DC = (PWM_CLK_RATE * duty_ns) / (10^9 * (PRESCALE + 1))
>> +      */
>> +
>> +     clk_rate = clk_get_rate(kp->clk);
>
> "rate" is 50% shorter and would do equally well.

That works for me.

>
>> +
>> +     /* There is polarity support in HW but it is easier to manage in SW */
>> +     if (pwm->polarity == PWM_POLARITY_INVERSED)
>> +             duty_ns = period_ns - duty_ns;
>
> No, this is wrong. You're not actually changing the *polarity* here.

Please elaborate.  I don't understand what is wrong here.

Does polarity influence the output while a PWM is disabled?

>
> Also I think this is missing a pair of clk_prepare_enable() and
> clk_disable_unprepare().

There is no issue here since the hardware registers are only touched
in kona_pwmc_config if the channel was already enabled.

>
>> +static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                               enum pwm_polarity polarity)
>> +{
>> +     /*
>> +      * The framework only allows the polarity to be changed when a PWM is
>> +      * disabled so no immediate action is required here.  When a channel is
>> +      * enabled, the polarity gets handled as part of the re-config step.
>> +      */
>> +
>> +     return 0;
>> +}
>
> See above. If you don't want to implement the hardware support for
> inversed polarity, then simply don't implement this.

I had originally planned to omit polarity support but because it
affects the binding (which is treated as ABI), it wouldn't be possible
to add it in later without defining a new compatible string.

>
>> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
>> +     int ret;
>> +
>> +     /*
>> +      * The PWM framework does not clear the enable bit in the flags if an
>> +      * error is returned from a PWM driver's enable function so it must be
>> +      * cleared here if any trouble is encountered.
>> +      */
>> +
>> +     ret = clk_prepare_enable(kp->clk);
>> +     if (ret < 0) {
>> +             dev_err(chip->dev, "failed to enable clock: %d\n", ret);
>> +             clear_bit(PWMF_ENABLED, &pwm->flags);
>
> You're not supposed to touch these. This is a bug in the core, and it
> should be fixed in the core.

Okay.  I'll drop the clear_bit lines from this patch.

>
>> +             return ret;
>> +     }
>> +
>> +     ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
>> +     if (ret < 0) {
>> +             clk_disable_unprepare(kp->clk);
>> +             clear_bit(PWMF_ENABLED, &pwm->flags);
>> +             return ret;
>> +     }
>
> Why are you doing this? .config() should be setting everything up
> according to the given duty cycle and period and .enable() should only
> be enabling a specific channel. Please don't conflate the two.

The hardware only supports a configure operation.

Thus disable has to be simulated by configuring zero duty.

During an enable operation we have to program the last configuration.

>
>> +static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
>> +     unsigned int chan = pwm->hwpwm;
>> +
>> +     /*
>> +      * The "enable" bits in the control register only affect when settings
>> +      * start to take effect so the only real way to disable the PWM output
>> +      * is to program a zero duty cycle.
>> +      */
>
> What's wrong about waiting for the settings to take effect? There's
> nothing about disable that says it should happen *immediately*.

The current code does wait for the settings to take effect.

Can you clarify what you mean?

>
>> +
>> +     writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +     kona_pwmc_apply_settings(kp, chan);
>> +
>> +     /*
>> +      * When the PWM clock is disabled, the output is pegged high or low
>> +      * depending on its state at that instant.  To guarantee that the new
>> +      * settings have taken effect and the output is low a delay of 400ns is
>> +      * required.
>> +      */
>> +
>> +     ndelay(400);
>
> Where does this number come from?

Hardware documentation

>
>> +static int kona_pwmc_probe(struct platform_device *pdev)
>> +{
>> +     struct kona_pwmc *kp;
>> +     struct resource *res;
>> +     unsigned int chan, value;
> [...]
>> +     /* Set smooth mode, push/pull, and normal polarity for all channels */
>> +     for (value = 0, chan = 0; chan < kp->chip.npwm; chan++) {
>
> Can't you initialize value to 0 when you declare it? That way the for
> loop becomes much more idiomatic.

Sure.

>
>> +             value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>> +             value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
>> +             value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
>> +     }
>> +     writel(value, kp->base + PWM_CONTROL_OFFSET);
>
> I'd prefer a blank line between the above two for readability.

Ok

>
>> +static struct platform_driver kona_pwmc_driver = {
>> +
>
> Gratuitous blank line.

Ok

>
>> +     .driver = {
>> +             .name = "bcm-kona-pwm",
>> +             .of_match_table = bcm_kona_pwmc_dt,
>> +     },
>> +     .probe = kona_pwmc_probe,
>> +     .remove = kona_pwmc_remove,
>> +};
>> +
>
> And here.

Ok

>
>> +module_platform_driver(kona_pwmc_driver);
>> +
>> +MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.com>");
>> +MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");
>> +MODULE_DESCRIPTION("Driver for Kona PWM controller");
>
> Perhaps "Broadcom Kona PWM"?

Sure

Thanks for the review.

-Tim
