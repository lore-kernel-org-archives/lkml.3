Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3FQSLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:11:05 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48422 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3FQSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:11:03 -0400
Message-ID: <51BF5132.1060400@linaro.org>
Date: Mon, 17 Jun 2013 11:10:58 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 4/9 RESEND] RFC: timekeeping: introduce
 flag systime_was_set
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de> <51BB60B1.6040007@linaro.org> <51BC034C.8080702@ahsoftware.de>
In-Reply-To: <51BC034C.8080702@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 11:01 PM, Alexander Holler wrote:
> Am 14.06.2013 20:28, schrieb John Stultz:
>> On 06/14/2013 11:05 AM, Alexander Holler wrote:
>>> Am 14.06.2013 19:41, schrieb John Stultz:
>>>> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>>>>> In order to let an RTC set the time at boot without the problem 
>>>>> that a
>>>>> second RTC overwrites it, the flag systime_was_set is introduced.
>>>>>
>>>>> systime_was_set will be true, if a persistent clock sets the time at
>>>>> boot,
>>>>> or if do_settimeofday() is called (e.g. by the RTC subsystem or
>>>>> userspace).
>>>>>
>>>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>>>> ---
>>>>>   include/linux/time.h      |  6 ++++++
>>>>>   kernel/time/timekeeping.c | 10 +++++++++-
>>>>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/linux/time.h b/include/linux/time.h
>>>>> index d5d229b..888280f 100644
>>>>> --- a/include/linux/time.h
>>>>> +++ b/include/linux/time.h
>>>>> @@ -129,6 +129,12 @@ extern int update_persistent_clock(struct
>>>>> timespec now);
>>>>>   void timekeeping_init(void);
>>>>>   extern int timekeeping_suspended;
>>>>> +/*
>>>>> + * Will be true if the system time was set at least once by
>>>>> + * a persistent clock, RTC or userspace.
>>>>> + */
>>>>> +extern bool systime_was_set;
>>>>> +
>>>>
>>>> Probably should make this static to timekeeping.c and create an 
>>>> accessor
>>>> function so you don't have to export locking rules on this.
>>>>
>>>>
>>>>>   unsigned long get_seconds(void);
>>>>>   struct timespec current_kernel_time(void);
>>>>>   struct timespec __current_kernel_time(void); /* does not take
>>>>> xtime_lock */
>>>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>>>> index baeeb5c..07d8531 100644
>>>>> --- a/kernel/time/timekeeping.c
>>>>> +++ b/kernel/time/timekeeping.c
>>>>> @@ -37,6 +37,9 @@ int __read_mostly timekeeping_suspended;
>>>>>   /* Flag for if there is a persistent clock on this platform */
>>>>>   bool __read_mostly persistent_clock_exist = false;
>>>>> +/* Flag for if the system time was set at least once */
>>>>> +bool __read_mostly systime_was_set;
>>>>> +
>>>> Probably should also move this to be part of the timekeeper structure
>>>> (since it will be protected by the timekeeper lock.
>>>>
>>>
>>> I wanted to avoid locks for this silly flag at all. It is only set
>>> once at boot (and resume) and set to 0 at suspend. And I don't see any
>>> possible race condition which could make a lock necessary. Therefor
>>> I've decided to not use a lock or atomic_* in order to skip any delay
>>> in setting the time.
>>
>> Even so, having random flag variables with special rules being exported
>> out is likely to cause eventual trouble (someone will mis-use or
>> overload some meaning on it).
>>
>> So at least providing a accessor function for non-timekeeping.c uses
>> would be good.
>
>
> It's rather hard to misuse a bool (even if a bool in C is just a define).

I'm trying to avoid allowing non-timekeeping users of the value to be 
able to set it.
By putting the value behind a timekeeping_systime_was_set() accessor, 
and making the boolean value static, we can make sure its properly 
managed by the timekeeping code alone.

> What do you think I should write?
>
> void set_systime_was_set(void) and void clear_systime_was_set(void)?
>
> And both functions would have to be exported in order to be usable 
> from modules?
>
> Or do you think I should write something like that:
>
> extern bool foo;
> inline void set_foo(void) { foo = true};
> inline void clear_foo(void) { foo = false };
>
> That's just silly, sorry to call it such.

No no. I'm only asking that the boolean be static to timekeeping.c and 
an accessor function be used to read it. Since the timekeeping core 
should be managing this value, there should be no reason for any other 
users to be setting or clearing the value.


>>> Of course, I might be wrong and there might be a use case where
>>> multiple things do set the system time concurrently and nothing else
>>> did set system time before, but I found that extremly unlikely.
>>
>> Yea, the condition check and the action won't be both be done under a
>> lock, so its likely going to be racy anyway.
>
> And if there ever will be a race for the first timesource to set this 
> flag (the first time), and something does care about the outtake, the 
> system would be completly broken.
>
> In order to keep it simple, I just tread userspace like a RTC of type 
> X and will call them all timesources of type x where a the type is 
> defined by the driver.
>
> Let us go through the possible cases:
>
> - 2 or more timesources of different type:
>
> If the order is undefined and they have to race for which clock might 
> be used for hctosys (and thus for adjusting the time after resume 
> too), the only reason one would want such is for HA purposes. And in 
> case of HA, both clocks must have the same time, so nobody does care 
> about which one will win the race  (=> no race, no lock or atomic_* 
> needed).
>
> If the purpose isn't for HA and someone does care about which 
> timesource should be used, the way to do this is to use hctosys=type 
> (or hctosys=none in case of userspace) to define which timesource 
> should be used for hctosys (=> no race, no lock or atomic_* needed).
>
> - 2 or more timesources of the same type:
> There is no possibility to define which one should win the race. Such 
> a system configuration is only usable for HA purposes, so if such 
> exists, nobody cares about the outtake of the race (=> no race, no 
> lock or atomic_* needed).
>

The race I'm thinking of is you have a system that normally sets the 
time via ntpdate at bootup. Thus they expect the system to always be 
started w/ NTP time (even if the system time was initially set via 
hctosys).

Then because of of some delay in the driver (or because the RTC device 
was plugged in during boot), the hctosys functionality runs just as 
ntpdate is being called.  hctosys sees time has not yet been set and 
reads the RTC hardware time. At this point, ntpdate sets the time to NTP 
time.  Then hctosys completes, setting the time to the RTC time.  This 
results in the system clock being wrong from the user's perspective (as 
they expect it to be set to NTP time).

This is basically what this code is trying to avoid in the first place. 
And I'll grant that its a small race window, but it may lead to 
irregular behavior.

So either we need to document that this race is theoretically possible, 
and explain *why* its safe to ignore it.  Or if we really want to do 
something like this properly, we need to drop the accessor function to 
the boolean, and instead provide a special 
timekeeping_set_time_if_unset() (with hopefully a better name then what 
I just came up with ;) function which checks the boolean and sets the 
clock all while holding the same lock. That way we really can be sure 
that if userland sets the time, we don't accidentally over-write that time.


thanks
-john





