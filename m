Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaK2CCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 21:02:41 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60928 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaK2CCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 21:02:40 -0500
MIME-Version: 1.0
In-Reply-To: <547909B0.2090408@broadcom.com>
References: <sbranden@broadcom.com>
	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>
	<1416944441-12066-3-git-send-email-sbranden@broadcom.com>
	<CAD7vxxKgcu9QLY8qH8WR0b_5WBu+MNxcemmZ8syYa__JaC6tsQ@mail.gmail.com>
	<547909B0.2090408@broadcom.com>
Date: Fri, 28 Nov 2014 18:02:39 -0800
Message-ID: <CAD7vxxLv+uh5DxjNYy9X8iY7Egu_9u-JzUg7Xk2UiNsoJwb1tw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pwm: kona: Fix incorrect enable after channel
 polarity change
From: Tim Kryger <tim.kryger@gmail.com>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-pwm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 3:48 PM, Arun Ramamurthy
<arun.ramamurthy@broadcom.com> wrote:
>
>
> On 14-11-25 10:22 PM, Tim Kryger wrote:
>>
>> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com>
>> wrote:
>>>
>>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>>
>>> The pwm core code requires a separate call for enabling the channel
>>> and hence the driver does not need to set pwm_trigger after a
>>> polarity change
>>
>>
>> The framework does restrict when polarity changes can occur but it
>> isn't clear to me that there is any reason to delay applying the
>> polarity change.
>
> I examined several other drivers such as pwm-atmel-tcb.c, pwm-ep93xx.c,
> pwm-renesas-tpu.c, pwm-samsung.c in the 3.17 kernel tree and none of them
> enable the channel after changing polarity. We would be the first driver to
> do so.

We are not "enabling" the channel as much as we are "triggering an
application of settings" by hardware.

Both pwm-ep93xx and pwm-samsung write polarity settings to the
hardware immediately, presumably resulting in an immediate change in
output.

Alternatively, the pwm-atmel-tcb and pwm-renesas-tpu drivers save the
polarity and write it to hardware later.

There may be advantages to deferring the application of the polarity
till a subsequent enable but both approaches appear to be acceptable.

>
>> Keep in mind that polarity matters even when a PWM
>> is disabled.  While disabled, the output should be equivalent to an
>> enabled configuration with zero duty.  Thus for normal polarity the
>> output is constant low and for inversed polarity the output is
>> constant high.
>
> The driver does set the duty cycle to zero when disabling the pwm
> channel.However since the frame work prevents polarity change when the pwm
> is enabled, I don’t see how one could expect the polarity change to be
> reflected immediately without a separate call to pwm enable.
>
>
>> I believe there is an expectation that the output is
>> updated to reflect the requested polarity change prior to returning to
>> the caller.
>
>
> Once again I disagree with this based on other pwm drivers which only change
> the polarity and do not enable the channel when their set polarity functions
> are called.

I don't know why you keep calling this an enable.  Its not an enable,
it is only a trigger.

Perhaps this would be best explained with an example:

# Export PWM for access by userspace
cd /sys/class/pwm/pwmchip0
echo 0 > export
cd pwm0

# Request 50% duty output when PWM is enabled
echo 50000 > duty_cycle
echo 100000 > period

# Command Inversed Polarity
echo inversed > polarity

# Command Normal Polarity
echo normal > polarity

# Enable PWM
echo 1 > enable

The polarity changes trigger immediate output updates but the PWM is
not enabled until the end.

Prior to the last step the output is either a constant high or low
signal, not the 50% duty waveform.

>
>
>>
>>>
>>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>> ---
>>>   drivers/pwm/pwm-bcm-kona.c | 5 -----
>>>   1 file changed, 5 deletions(-)
>>>
>>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>>> index 29eef9e..fa0b5bf 100644
>>> --- a/drivers/pwm/pwm-bcm-kona.c
>>> +++ b/drivers/pwm/pwm-bcm-kona.c
>>> @@ -173,11 +173,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip
>>> *chip, struct pwm_device *pwm,
>>>
>>>          writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>
>>> -       kona_pwmc_apply_settings(kp, chan);
>>> -
>>> -       /* Wait for waveform to settle before gating off the clock */
>>> -       ndelay(400);
>>> -
>>>          clk_disable_unprepare(kp->clk);
>>>
>>>          return 0;
>>> --
>>> 2.1.3
>>>
>
