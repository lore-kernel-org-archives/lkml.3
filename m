Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaLATwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:52:55 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:44938 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaLATwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:52:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,495,1413270000"; 
   d="scan'208";a="52163750"
Message-ID: <547CC395.408@broadcom.com>
Date: Mon, 1 Dec 2014 11:37:57 -0800
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pwm: kona: Remove setting default smooth type
 and polarity for all channels
References: <sbranden@broadcom.com>	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>	<1416944441-12066-2-git-send-email-sbranden@broadcom.com>	<CAD7vxxJFD8Xgsd1Jrf=vA5-duqG21UWXMr4oRM6MEmMxQ9V49A@mail.gmail.com>	<5479097B.6020108@broadcom.com>	<CAD7vxxJr48p_1=obXkX5kvk96B18A8=F98ikqnzTKsz6nYZJbQ@mail.gmail.com>	<54791F30.3050306@broadcom.com> <CAD7vxxJFuA8V0TiPLQo1LOnRQPbM-QOYDTLkg7Ty0N=Nr7frGQ@mail.gmail.com>
In-Reply-To: <CAD7vxxJFuA8V0TiPLQo1LOnRQPbM-QOYDTLkg7Ty0N=Nr7frGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14-11-28 07:19 PM, Tim Kryger wrote:
> On Fri, Nov 28, 2014 at 5:19 PM, Arun Ramamurthy
> <arun.ramamurthy@broadcom.com> wrote:
>>
>>
>> On 14-11-28 05:08 PM, Tim Kryger wrote:
>>>
>>> On Fri, Nov 28, 2014 at 3:47 PM, Arun Ramamurthy
>>> <arun.ramamurthy@broadcom.com> wrote:
>>>>
>>>>
>>>>
>>>> On 14-11-25 09:51 PM, Tim Kryger wrote:
>>>>>
>>>>>
>>>>> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>>>>>
>>>>>> The probe routine unnecessarily sets the smooth type and polarity for
>>>>>> all channels. This causes the channel for the speaker to click at the
>>>>>> same
>>>>>> time the backlight turns on. The smooth type and polarity should be set
>>>>>> individually
>>>>>> for each channel as required and no defaults need to be set.
>>>>>
>>>>>
>>>>>
>>>>> I am guessing you are talking about a PWM controlled beeper/buzzer.
>>>>>
>>>> This change is more so to remove setting smooth type and polarity for all
>>>> channels during probe and to leave them as their default values. Infact,
>>>> setting the PWM_CONTROL_TYPE_SHIT is also redundant cause the default
>>>> value
>>>> is already 1 for all channels. We can remove that loop entirely and this
>>>> will be done in the next patch set. The smooth type and polarity are only
>>>> changed when the particular pwm channel is enabled or polarity is
>>>> changed.
>>>>
>>>>> Can you mention what board you are observing this issue on?
>>>>>
>>>>> Also please explain why setting these bits result in an audible click.
>>>>>
>>>> We observe this on the bcm958300K board where one of the
>>>> PWM channels is connected to the buzzer and changing the
>>>> smooth type and polarity from its default values causes a click
>>>>
>>>
>>> Which of these two bits is causing the click?
>>>
>>> I've already said that I'm open to removing the smooth bit here if that
>>> helps.
>>>
>> Thank you for your quick reply Tim. It is setting the polarity bit that
>> causes the click. I am planning on removing this entire loop in the next
>> patch set, are you okay with that?
>
> Does it cause a click at this moment or at a later point in time?
>
> Is the click your sole motivation for this series?  If so, can you
> propose a more targeted fix?
>
> I would be amenable to deferring polarity changes until subsequent
> enable operations:
>
> - kona_pwmc_probe doesn't do any hardware writes
> - kona_pwmc_set_polarity only updates a polarity variable
> - kona_pwmc_enable sets hardware polarity according to the variable
>
> Would this be sufficient to satisfy your needs?
>
It clicks at time of boot up, I can agree to the above changes and will 
update the next patch set accordingly.
> I am still worried that deferring polarity changes may negatively
> impact some PWM users who set polarity but don't immediately enable
> the PWM.
>
>>>>>>
>>>>>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>>>>>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>>>>>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>>>>> ---
>>>>>>     drivers/pwm/pwm-bcm-kona.c | 7 ++-----
>>>>>>     1 file changed, 2 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>>>>>> index 02bc048..29eef9e 100644
>>>>>> --- a/drivers/pwm/pwm-bcm-kona.c
>>>>>> +++ b/drivers/pwm/pwm-bcm-kona.c
>>>>>> @@ -266,12 +266,9 @@ static int kona_pwmc_probe(struct platform_device
>>>>>> *pdev)
>>>>>>                    return ret;
>>>>>>            }
>>>>>>
>>>>>> -       /* Set smooth mode, push/pull, and normal polarity for all
>>>>>> channels */
>>>>>> -       for (chan = 0; chan < kp->chip.npwm; chan++) {
>>>>>> -               value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
>>>>>> +       /* Set push/pull for all channels */
>>>>>> +       for (chan = 0; chan < kp->chip.npwm; chan++)
>>>>>>                    value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
>>>>>> -               value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
>>>>>> -       }
>>>>>>
>>>>>>            writel(value, kp->base + PWM_CONTROL_OFFSET);
>>>>>
>>>>>
>>>>>
>>>>> While the smooth bit need not be set here, it is important that the
>>>>> polarity bit be set.
>>>>>
>>>> The default value for polarity is 0 which is normal polarity, so setting
>>>> it
>>>> to 1 here in the probe function without a sysfs call is
>>>> when the software will report the polarity as normal when it is actually
>>>> inversed.
>>>
>>>
>>> Please double check the meaning of the polarity bits for the revision
>>> of PWM IP in your chip.  I suspect you are mistaken here.
>>>
>>> This driver is for PWM blocks compatible those found in bcm28145,
>>> bcm28155, bcm21664, and other mobile chips of that generation.
>>>
>>> Apparently in contrast to the chip you are using, a set polarity bit
>>> in the control register means normal polarity for the chips I
>>> mentioned.
>>>
>>> A default of zero for these bits means they must be set to meet the
>>> PWM framework's expectation that channels begin with normal polarity.
>>>
>> Tim, this is from the RDB of our new chip which is supposed to have the same
>> IP as the mobile chip sets you mentioned:
>>
>> When set to 1 the output polarity for the PWM Output signal will be active
>> hight; When set to 0, the output polarity for the PWM Output signal will be
>> active low. Default State is 0.
>>
>> My understanding is that the frameworks normal polarity means active low, am
>> I mistaken in that?
>
> That is not how I would interpret things.
>
> Perhaps this paragraph from Documentation/pwm.txt will help you:
>
> When implementing polarity support in a PWM driver, make sure to respect the
> signal conventions in the PWM framework. By definition, normal polarity
> characterizes a signal starts high for the duration of the duty cycle and
> goes low for the remainder of the period. Conversely, a signal with inversed
> polarity starts low for the duration of the duty cycle and goes high for the
> remainder of the period.
>
I had it mixed up, I will update the polarity to match the PWM framework.
>>
>>>>>
>>>>> Otherwise software will report the polarity as normal when it it is
>>>>> actually inversed.
>>>>>
>>>>> Consider the case where a userspace process is controlling the PWM via
>>>>> sysfs.
>>>>>
>>>> I agree with you about the sysfs case Tim, but since this is the probe
>>>> function and not a sysfs callback, should we not leave it as the default
>>>> value?
