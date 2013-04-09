Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102Ab3DIRRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:17:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33737 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab3DIRRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:17:45 -0400
Message-ID: <51644D28.5090400@ti.com>
Date: Tue, 9 Apr 2013 13:17:28 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: step_wise: set throttle target within thermal
 instance limits
References: <1365465371-24652-1-git-send-email-abrestic@chromium.org> <51642D21.2060705@ti.com> <CAL1qeaENU4z9FC4kXmcTGfzKBg3nVmpRNomBYa=HAenDRbPOgA@mail.gmail.com>
In-Reply-To: <CAL1qeaENU4z9FC4kXmcTGfzKBg3nVmpRNomBYa=HAenDRbPOgA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-04-2013 13:09, Andrew Bresticker wrote:
> Hi Eduardo,
>
> On Tue, Apr 9, 2013 at 8:00 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> Hi Andrew,
>>
>>
>> On 08-04-2013 19:56, Andrew Bresticker wrote:
>>>
>>> When selecting a target cooling state in get_target_state(), make sure
>>> that the state is at least as high as the minimum when the temperature
>>> is rising and at least as low as the maximum when the temperature is
>>> falling.  Previously the cooling level would only be incremented or
>>> decremented by one in these cases.
>>>
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>> ---
>>>    drivers/thermal/step_wise.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
>>> index 0cd5e9f..49992a4 100644
>>> --- a/drivers/thermal/step_wise.c
>>> +++ b/drivers/thermal/step_wise.c
>>> @@ -47,9 +47,13 @@ static unsigned long get_target_state(struct
>>> thermal_instance *instance,
>>>          if (trend == THERMAL_TREND_RAISING) {
>>>                  cur_state = cur_state < instance->upper ?
>>>                              (cur_state + 1) : instance->upper;
>>> +               if (cur_state < instance->lower)
>>> +                       cur_state = instance->lower;
>>>          } else if (trend == THERMAL_TREND_DROPPING) {
>>>                  cur_state = cur_state > instance->lower ?
>>>                              (cur_state - 1) : instance->lower;
>>> +               if (cur_state > instance->upper)
>>> +                       cur_state = instance->upper;
>>>          }
>>
>>
>>
>> In which situations cur_state will be out of the [lower;upper] boundaries? I
>> mean at this point while temperature is rising, and we are rising the
>> cooling level, we should be already above lower (and vice-versa). Can you
>> please describe better the situation you are trying to cover/ that you have
>> identified?
>
> Suppose we hit a trip point which has bounds from 5 to 10, but
> cur_state is 0 because there has previously been no thermal
> throttling.  In that case, we would only go to level 1, even though
> the thermal instance specifies we should be between 5 and 10.  This
> patch would fix it so that we go directly to level 5 instead.
>
> I will resend this with a more descriptive commit message.

Thanks, I appreciate it.

>
>>
>>>
>>>          return cur_state;
>>>
>>
>
> Thanks,
> Andrew
>
>

