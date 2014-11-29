Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaK2BI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:08:26 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60390 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaK2BIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:08:24 -0500
MIME-Version: 1.0
In-Reply-To: <5479097B.6020108@broadcom.com>
References: <sbranden@broadcom.com>
	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>
	<1416944441-12066-2-git-send-email-sbranden@broadcom.com>
	<CAD7vxxJFD8Xgsd1Jrf=vA5-duqG21UWXMr4oRM6MEmMxQ9V49A@mail.gmail.com>
	<5479097B.6020108@broadcom.com>
Date: Fri, 28 Nov 2014 17:08:23 -0800
Message-ID: <CAD7vxxJr48p_1=obXkX5kvk96B18A8=F98ikqnzTKsz6nYZJbQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pwm: kona: Remove setting default smooth type and
 polarity for all channels
From: Tim Kryger <tim.kryger@gmail.com>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-pwm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 3:47 PM, Arun Ramamurthy
<arun.ramamurthy@broadcom.com> wrote:
>
>
> On 14-11-25 09:51 PM, Tim Kryger wrote:
>>
>> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com>
>> wrote:
>>>
>>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>>
>>> The probe routine unnecessarily sets the smooth type and polarity for
>>> all channels. This causes the channel for the speaker to click at the
>>> same
>>> time the backlight turns on. The smooth type and polarity should be set
>>> individually
>>> for each channel as required and no defaults need to be set.
>>
>>
>> I am guessing you are talking about a PWM controlled beeper/buzzer.
>>
> This change is more so to remove setting smooth type and polarity for all
> channels during probe and to leave them as their default values. Infact,
> setting the PWM_CONTROL_TYPE_SHIT is also redundant cause the default value
> is already 1 for all channels. We can remove that loop entirely and this
> will be done in the next patch set. The smooth type and polarity are only
> changed when the particular pwm channel is enabled or polarity is changed.
>
>> Can you mention what board you are observing this issue on?
>>
>> Also please explain why setting these bits result in an audible click.
>>
> We observe this on the bcm958300K board where one of the
> PWM channels is connected to the buzzer and changing the
> smooth type and polarity from its default values causes a click
>

Which of these two bits is causing the click?

I've already said that I'm open to removing the smooth bit here if that helps.

>>>
>>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>> ---
>>>   drivers/pwm/pwm-bcm-kona.c | 7 ++-----
>>>   1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>>> index 02bc048..29eef9e 100644
>>> --- a/drivers/pwm/pwm-bcm-kona.c
>>> +++ b/drivers/pwm/pwm-bcm-kona.c
>>> @@ -266,12 +266,9 @@ static int kona_pwmc_probe(struct platform_device
>>> *pdev)
>>>                  return ret;
>>>          }
>>>
>>> -       /* Set smooth mode, push/pull, and normal polarity for all
>>> channels */
>>> -       for (chan = 0; chan < kp->chip.npwm; chan++) {
>>> -               value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>>> +       /* Set push/pull for all channels */
>>> +       for (chan = 0; chan < kp->chip.npwm; chan++)
>>>                  value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
>>> -               value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
>>> -       }
>>>
>>>          writel(value, kp->base + PWM_CONTROL_OFFSET);
>>
>>
>> While the smooth bit need not be set here, it is important that the
>> polarity bit be set.
>>
> The default value for polarity is 0 which is normal polarity, so setting it
> to 1 here in the probe function without a sysfs call is
> when the software will report the polarity as normal when it is actually
> inversed.

Please double check the meaning of the polarity bits for the revision
of PWM IP in your chip.  I suspect you are mistaken here.

This driver is for PWM blocks compatible those found in bcm28145,
bcm28155, bcm21664, and other mobile chips of that generation.

Apparently in contrast to the chip you are using, a set polarity bit
in the control register means normal polarity for the chips I
mentioned.

A default of zero for these bits means they must be set to meet the
PWM framework's expectation that channels begin with normal polarity.

>>
>> Otherwise software will report the polarity as normal when it it is
>> actually inversed.
>>
>> Consider the case where a userspace process is controlling the PWM via
>> sysfs.
>>
> I agree with you about the sysfs case Tim, but since this is the probe
> function and not a sysfs callback, should we not leave it as the default
> value?
