Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3KZBis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:38:48 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42575 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3KZBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:38:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131125110854.GI22043@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
	<1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
	<20131125110854.GI22043@ulmo.nvidia.com>
Date: Mon, 25 Nov 2013 17:38:44 -0800
Message-ID: <CAAYSxhr7=Pa8RdnEsD2MGTR4hvfHCcHQCP77GRjx1Fqb-=kRrA@mail.gmail.com>
Subject: Re: [PATCH 2/5] pwm: kona: Introduce Kona PWM controller support
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:08 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Nov 18, 2013 at 10:54:58AM -0800, Tim Kryger wrote:
> [...]
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> [...]
>> +config PWM_BCM_KONA
>> +     tristate "Kona PWM support"
>> +     depends on ARCH_BCM_MOBILE
>> +     default y
>
> Why do you want this to be the default? Shouldn't this be something that
> a default configuration selects explicitly?

This hardware is present on all recent Broadcom mobile SoCs so it is
reasonable to expect that one would want the driver enabled but I
think it makes sense to allow it be compiled out just in case it is
unused.

>> +#define PWM_CONTROL_INITIAL          (0x3f3f3f00)
>
> Can this not be expressed as a bitmask of values for the individual
> fields.
>
>> +#define PWMOUT_POLARITY(chan)                (0x1 << (8 + chan))
>
> This seems to only account for bits 8-13, what about the others?
>
>> +#define PWMOUT_ENABLE(chan)          (0x1 << chan)
>
> Well, this accounts for bits 0-5, that still leaves 16-21 and 24-29.

29:24 - Configures each PWM channel for smooth transitions or glitches
21:16 - Configures each PWM channel for push/pull or open drain output


>> +#define PRESCALE_OFFSET                      (0x00000004)
>> +#define PRESCALE_SHIFT(chan)         (chan << 2)
>
> I'm confused. This allocates 2 bits for each channel...
>
>> +#define PRESCALE_MASK(chan)          (~(0x7 << (chan << 2)))
>> +#define PRESCALE_MIN                 (0x00000000)
>> +#define PRESCALE_MAX                 (0x00000007)
>
> ... but 0x7 requires at least 3 bits.

Actually this is allocating 2^2 bits for each channel.

>> +#define PERIOD_COUNT_OFFSET(chan)    (0x00000008 + (chan << 3))
>> +#define PERIOD_COUNT_MIN             (0x00000002)
>> +#define PERIOD_COUNT_MAX             (0x00ffffff)
>
> Why PERIOD_COUNT? PERIOD is descriptive enough. Or is this the name as
> found in the manual?

I agree but as you suspected this name comes from the hardware docs.

>> +#define DUTY_CYCLE_HIGH_OFFSET(chan) (0x0000000c + (chan << 3))
>> +#define DUTY_CYCLE_HIGH_MIN          (0x00000000)
>> +#define DUTY_CYCLE_HIGH_MAX          (0x00ffffff)
>
> By definition the duty-cycle is where the signal is high. Again, if this
> is how the manual names the registers it's fine.

Same comment as above.

>> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     return kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
>> +}
>
> Why can't this just enable the channel? Why go through all the trouble
> of running the whole computations again?

The hardware is always enabled and at best can be be configured to
operate at zero duty.

The settings in HW may have already been triggered and might not be
what you want.

For example:

/sys/class/pwm/pwmchip0/pwm1# echo 1 > enable
/sys/class/pwm/pwmchip0/pwm1# echo 5000 > period
/sys/class/pwm/pwmchip0/pwm1# echo 2000 > duty_cycle
/sys/class/pwm/pwmchip0/pwm1# echo 0 > enable
/sys/class/pwm/pwmchip0/pwm1# echo 1 > enable

>> +
>> +static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +     struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
>> +     int chan = pwm->hwpwm;
>> +
>> +     /*
>> +      * The PWM hardware lacks a proper way to be disabled so
>> +      * we just program zero duty cycle high count instead
>> +      */
>
> So clearing the enable bit doesn't disable the PWM channel?

That is correct.  They picked a terrible name for this bit.

>> +
>> +     writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
>> +     kona_pwmc_apply_settings(kp, chan);
>> +}
>> +
>> +static const struct pwm_ops kona_pwm_ops = {
>> +     .config = kona_pwmc_config,
>> +     .owner = THIS_MODULE,
>> +     .enable = kona_pwmc_enable,
>> +     .disable = kona_pwmc_disable,
>> +};
>
> Please move the .owner field to be the last field. Also you did define
> the PWMOUT_POLARITY field, which indicates that the hardware supports
> changing the signal's polarity, yet you don't implement the polarity
> feature. Why not?

I wanted to keep this driver simple for now.

>> +     ret = clk_prepare_enable(kp->clk);
>> +     if (ret < 0)
>> +             return ret;
>
> Do you really want the clock enabled all the time? Why not just
> clk_enable() whenever a PWM is enabled? If you need the clock for
> register access, you can also bracket register accesses with
> clk_enable() and clk_disable(). Perhaps the power savings aren't worth
> the added effort, so if you'd rather not do that, I'm fine with it, too.

I intend to follow up with a patch to do exactly that but I want to
establish the baseline functionality first.

>> +MODULE_AUTHOR("Broadcom");
>
> I don't think Broadcom qualifies as author. This should be the name of
> whoever wrote the code. There are a few drivers that contain the company
> name in the MODULE_AUTHOR, but I don't think those are correct either.

Would you be fine with two lines here?  Something like:

MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.com>");
MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");


Thanks for the review.  I will make all of the other changes you have
recommended.

-Tim
