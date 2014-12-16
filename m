Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaLPTg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:36:56 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:18342 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:36:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,588,1413270000"; 
   d="scan'208";a="53068804"
Message-ID: <549089DA.9070405@broadcom.com>
Date: Tue, 16 Dec 2014 11:36:58 -0800
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
Subject: Re: [PATCH v2 1/2] pwm: kona: Fix incorrect enable, config, and disable
 procedures
References: <jonathar@broadcom.com> <1418260059-1642-1-git-send-email-jonathar@broadcom.com> <CAD7vxxJ2++PNteSZ+F5epvPW_nrrSZT9pja325pmLVhq_MHL0w@mail.gmail.com>
In-Reply-To: <CAD7vxxJ2++PNteSZ+F5epvPW_nrrSZT9pja325pmLVhq_MHL0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-14 11:18 PM, Tim Kryger wrote:
> On Wed, Dec 10, 2014 at 5:07 PM, Jonathan Richardson
> <jonathar@broadcom.com> wrote:
> 
>>     If config is called when the pwm is disabled and there is nothing to do,
>>     the while loop to calculate duty cycle and period doesn't need to be
>>     done. The function now just returns if the pwm state is disabled.
> 
> It doesn't take long to figure out whether the duty and period are achievable.
> 
> If the caller specifies bad settings, why not return an error immediately?

Sorry, not sure what you're suggesting here. It's returning as soon as
it can isn't it? Nothing changed in the way the period and duty cycle
were calculated and checked in the while loop.

> 
>> @@ -207,13 +240,23 @@ static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>>  {
>>         struct kona_pwmc *kp = to_kona_pwmc(chip);
>>         unsigned int chan = pwm->hwpwm;
>> +       unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
>> +
>> +       /* Set smooth type to 0 and disable */
>> +       value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
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
>> +
>> +       kona_pwmc_apply_settings(kp, chan);
>>
>>         clk_disable_unprepare(kp->clk);
>>  }
> 
> I've mentioned this before but I will say it again, when the smooth
> and trigger bit are both low, the output is constant high.
> 
> If you look at the PWM output on a scope you will see it go high for
> 400 ns during your disable even if the duty prior to the disable was
> zero.
> 
> How are you testing your proposed changes?
> 

I see what you mean now and verified it. For a smooth transition even on
disable the smooth bit should be set high, not low. It's the same
procedure as in config. Setting the bit high instead of low gets rid of
the 400ns transition high. I can make this change.

> Thanks,
> Tim Kryger
> 

