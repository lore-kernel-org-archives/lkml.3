Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaAETdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:33:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36755 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAETdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:33:54 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-08-52c9b39f2eb9
Message-id: <52C9B39C.2000901@samsung.com>
Date: Sun, 05 Jan 2014 23:33:48 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
 <52C5F38D.5060201@linaro.org> <52C6F722.3090704@samsung.com>
 <52C75353.8060505@linaro.org>
In-reply-to: <52C75353.8060505@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7rzN58MMjjWL2oxZ/0aNouDWzUt
	zvzWtTjb9Ibd4vKuOWwOrB4T+j8xety5tofN48SM3ywefVtWMXp83iQXwBrFZZOSmpNZllqk
	b5fAlbHn3m3WgnniFc8frWZqYLwr1MXIySEhYCLR/m82M4QtJnHh3nq2LkYuDiGBpYwS036v
	YIdwPjNKHL2/mx2kildAS2L6+0msXYwcHCwCqhIvJoiDmGwCBhL77tmCmKICERJHl2tCFAtK
	/Jh8jwXEFhHQkFi45CoTSAmzQJbEzPvFIGFhASeJXfNfMkEsWsYosePaAjaQBCfQotcXzoPZ
	zALWEisnbWOEsOUlNq95yzyBUWAWkhWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpe
	cn7uJkZIIH/dwbj0mNUhRgEORiUe3oSWE0FCrIllxZW5hxglOJiVRHjzZp8MEuJNSaysSi3K
	jy8qzUktPsTIxMEp1cA4JZ399qyqJxN1DQ2qJe9nyy1M/fZ9oVvDhYN8lU3Cklzix/SdPvVP
	Dfuk/otdq9uxxPj+K+sFDG/rg28buFxcfbbSsk7x7w6D9S91m1UMUtT3it5fKPKYZ/Hu3d7u
	X06r3/KrPL40Rq1DzjK0pXRm0aT9PT8/TLAsmjEzx6/r1p2tcdkbq6KVWIozEg21mIuKEwFJ
	wi6tQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 04:18 AM, John Stultz wrote:
> On 01/03/2014 09:45 AM, Alexey Perevalov wrote:
>> On 01/03/2014 03:17 AM, John Stultz wrote:
>>> On 01/02/2014 10:30 AM, Alexey Perevalov wrote:
>>>> This version introduces new clockid (CLOCK_DEFERRABLE) , for
>>>> timerfd_create, instead of
>>>> new flag (TFD_TIMER_DEFERRABLE) for timerfd_settime introduced in
>>>> previous version.
>>> So why did you make this change?
>>>
>>> thanks
>>> -john
>>>
>>>
>> I looked at alarm timers and found approach of making timer behavior
>> persistent per file descriptor is better than
>> changeable by timerfd_settime. I think "end user wake up from suspend"
>> and "don't wake up in idle" is the same thing on the same abstraction
>> level.
>>
>> Yes Anton's previous  patches worked with CLOCK_MONOTONIC only and I
>> didn't intend to use it with CLOCK_REALTIME, cause it's hard to me to
>> find such use case.
>> Another way - it's stay as was Anton's patch, I mean as flag for the
>> timerfd_settime, but in original patch set both hrtimer and deferrable
>> timers initialized in timerfd_create, I think it's not needed. Also
>> ability to change timer behavior looks not good if you couldn't change
>> alarm timer behavior, not unified API.
> So while the alarm timers are a reasonable precedent, I think they were
> introduced prior to the timerfd interface, so it seemed at the time
> having new clockids for the functionality was required to work with the
> existing syscalls that use the clockid (Though in retrospect, I question
> if it would have been better to use timer flags to introduce the alarm
> functionality rather then introducing it via a clockid, as it would
> simplify the clockid definitions).
As I understood alarm and deferrability it's type of repetition (timer 
trigger condition),
but REALTIME, BOOTTIME, MONOTONIC it's a type of time representation.
Mixed it in one clockid, maybe it's a controversially. Which flags do 
you want to use, flags of timerfd_settime?

>
> Now that we have the timerfd interface, and if this functionality is
> really limited to the timerfds, then we may want to consider what might
> be, at least to me, the cleaner approach of using the flag.
>
> Either way, I'd like to make sure we have a sound rational. My worry is
> that deferrable timers would be desired on more then just
> CLOCK_MONOTONIC, so we could quite likely end up with quite a few new
> clockids (ie: CLOCK_BOOTTIME_DEFERRED, CLOCK_TAI_DEFERRED,
> CLOCK_REALTIME_DEFERRED).
>
Here I'm totally agree CLOCK_DEFERRABLE is not maintainable named constant.


>> If I'm right, only high resolution timer could be REALTIME, and there
>> is no deferrable behavior for hrtimer only for timer_list.
>>
>>
> I'm not sure I understood this part. Could you explain further?
I meant, we couldn't use hrtimer for deferrability, right now.

>
> thanks
> -john
>
>


-- 
Best regards,
Alexey Perevalov
