Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3FOGC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 02:02:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34926 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3FOGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 02:02:26 -0400
Message-ID: <51BC034C.8080702@ahsoftware.de>
Date: Sat, 15 Jun 2013 08:01:48 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 4/9 RESEND] RFC: timekeeping: introduce
 flag systime_was_set
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de> <51BB60B1.6040007@linaro.org>
In-Reply-To: <51BB60B1.6040007@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.06.2013 20:28, schrieb John Stultz:
> On 06/14/2013 11:05 AM, Alexander Holler wrote:
>> Am 14.06.2013 19:41, schrieb John Stultz:
>>> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>>>> In order to let an RTC set the time at boot without the problem that a
>>>> second RTC overwrites it, the flag systime_was_set is introduced.
>>>>
>>>> systime_was_set will be true, if a persistent clock sets the time at
>>>> boot,
>>>> or if do_settimeofday() is called (e.g. by the RTC subsystem or
>>>> userspace).
>>>>
>>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>>> ---
>>>>   include/linux/time.h      |  6 ++++++
>>>>   kernel/time/timekeeping.c | 10 +++++++++-
>>>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/time.h b/include/linux/time.h
>>>> index d5d229b..888280f 100644
>>>> --- a/include/linux/time.h
>>>> +++ b/include/linux/time.h
>>>> @@ -129,6 +129,12 @@ extern int update_persistent_clock(struct
>>>> timespec now);
>>>>   void timekeeping_init(void);
>>>>   extern int timekeeping_suspended;
>>>> +/*
>>>> + * Will be true if the system time was set at least once by
>>>> + * a persistent clock, RTC or userspace.
>>>> + */
>>>> +extern bool systime_was_set;
>>>> +
>>>
>>> Probably should make this static to timekeeping.c and create an accessor
>>> function so you don't have to export locking rules on this.
>>>
>>>
>>>>   unsigned long get_seconds(void);
>>>>   struct timespec current_kernel_time(void);
>>>>   struct timespec __current_kernel_time(void); /* does not take
>>>> xtime_lock */
>>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>>> index baeeb5c..07d8531 100644
>>>> --- a/kernel/time/timekeeping.c
>>>> +++ b/kernel/time/timekeeping.c
>>>> @@ -37,6 +37,9 @@ int __read_mostly timekeeping_suspended;
>>>>   /* Flag for if there is a persistent clock on this platform */
>>>>   bool __read_mostly persistent_clock_exist = false;
>>>> +/* Flag for if the system time was set at least once */
>>>> +bool __read_mostly systime_was_set;
>>>> +
>>> Probably should also move this to be part of the timekeeper structure
>>> (since it will be protected by the timekeeper lock.
>>>
>>
>> I wanted to avoid locks for this silly flag at all. It is only set
>> once at boot (and resume) and set to 0 at suspend. And I don't see any
>> possible race condition which could make a lock necessary. Therefor
>> I've decided to not use a lock or atomic_* in order to skip any delay
>> in setting the time.
>
> Even so, having random flag variables with special rules being exported
> out is likely to cause eventual trouble (someone will mis-use or
> overload some meaning on it).
>
> So at least providing a accessor function for non-timekeeping.c uses
> would be good.


It's rather hard to misuse a bool (even if a bool in C is just a define).
What do you think I should write?

void set_systime_was_set(void) and void clear_systime_was_set(void)?

And both functions would have to be exported in order to be usable from 
modules?

Or do you think I should write something like that:

extern bool foo;
inline void set_foo(void) { foo = true};
inline void clear_foo(void) { foo = false };

That's just silly, sorry to call it such.

So now I'm unsure if I'm able to continue work on this series. I seem to 
be unable to think and code like maintainers do want I should think and 
code, whatever that might be.


>> Of course, I might be wrong and there might be a use case where
>> multiple things do set the system time concurrently and nothing else
>> did set system time before, but I found that extremly unlikely.
>
> Yea, the condition check and the action won't be both be done under a
> lock, so its likely going to be racy anyway.

And if there ever will be a race for the first timesource to set this 
flag (the first time), and something does care about the outtake, the 
system would be completly broken.

In order to keep it simple, I just tread userspace like a RTC of type X 
and will call them all timesources of type x where a the type is defined 
by the driver.

Let us go through the possible cases:

- 2 or more timesources of different type:

If the order is undefined and they have to race for which clock might be 
used for hctosys (and thus for adjusting the time after resume too), the 
only reason one would want such is for HA purposes. And in case of HA, 
both clocks must have the same time, so nobody does care about which one 
will win the race  (=> no race, no lock or atomic_* needed).

If the purpose isn't for HA and someone does care about which timesource 
should be used, the way to do this is to use hctosys=type (or 
hctosys=none in case of userspace) to define which timesource should be 
used for hctosys (=> no race, no lock or atomic_* needed).

- 2 or more timesources of the same type:
There is no possibility to define which one should win the race. Such a 
system configuration is only usable for HA purposes, so if such exists, 
nobody cares about the outtake of the race (=> no race, no lock or 
atomic_* needed).


Regards,

Alexander Holler
