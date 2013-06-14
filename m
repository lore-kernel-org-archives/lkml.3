Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3FNS2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:28:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44908 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3FNS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:28:04 -0400
Message-ID: <51BB60B1.6040007@linaro.org>
Date: Fri, 14 Jun 2013 11:28:01 -0700
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
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de>
In-Reply-To: <51BB5B65.3000400@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 11:05 AM, Alexander Holler wrote:
> Am 14.06.2013 19:41, schrieb John Stultz:
>> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>>> In order to let an RTC set the time at boot without the problem that a
>>> second RTC overwrites it, the flag systime_was_set is introduced.
>>>
>>> systime_was_set will be true, if a persistent clock sets the time at
>>> boot,
>>> or if do_settimeofday() is called (e.g. by the RTC subsystem or
>>> userspace).
>>>
>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>> ---
>>>   include/linux/time.h      |  6 ++++++
>>>   kernel/time/timekeeping.c | 10 +++++++++-
>>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/time.h b/include/linux/time.h
>>> index d5d229b..888280f 100644
>>> --- a/include/linux/time.h
>>> +++ b/include/linux/time.h
>>> @@ -129,6 +129,12 @@ extern int update_persistent_clock(struct
>>> timespec now);
>>>   void timekeeping_init(void);
>>>   extern int timekeeping_suspended;
>>> +/*
>>> + * Will be true if the system time was set at least once by
>>> + * a persistent clock, RTC or userspace.
>>> + */
>>> +extern bool systime_was_set;
>>> +
>>
>> Probably should make this static to timekeeping.c and create an accessor
>> function so you don't have to export locking rules on this.
>>
>>
>>>   unsigned long get_seconds(void);
>>>   struct timespec current_kernel_time(void);
>>>   struct timespec __current_kernel_time(void); /* does not take
>>> xtime_lock */
>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>> index baeeb5c..07d8531 100644
>>> --- a/kernel/time/timekeeping.c
>>> +++ b/kernel/time/timekeeping.c
>>> @@ -37,6 +37,9 @@ int __read_mostly timekeeping_suspended;
>>>   /* Flag for if there is a persistent clock on this platform */
>>>   bool __read_mostly persistent_clock_exist = false;
>>> +/* Flag for if the system time was set at least once */
>>> +bool __read_mostly systime_was_set;
>>> +
>> Probably should also move this to be part of the timekeeper structure
>> (since it will be protected by the timekeeper lock.
>>
>
> I wanted to avoid locks for this silly flag at all. It is only set 
> once at boot (and resume) and set to 0 at suspend. And I don't see any 
> possible race condition which could make a lock necessary. Therefor 
> I've decided to not use a lock or atomic_* in order to skip any delay 
> in setting the time.

Even so, having random flag variables with special rules being exported 
out is likely to cause eventual trouble (someone will mis-use or 
overload some meaning on it).

So at least providing a accessor function for non-timekeeping.c uses 
would be good.


> Of course, I might be wrong and there might be a use case where 
> multiple things do set the system time concurrently and nothing else 
> did set system time before, but I found that extremly unlikely.

Yea, the condition check and the action won't be both be done under a 
lock, so its likely going to be racy anyway.


>>>   static inline void tk_normalize_xtime(struct timekeeper *tk)
>>>   {
>>>       while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
>>> @@ -498,6 +501,9 @@ int do_settimeofday(const struct timespec *tv)
>>>       raw_spin_lock_irqsave(&timekeeper_lock, flags);
>>>       write_seqcount_begin(&timekeeper_seq);
>>> +    systime_was_set = true;
>>> +
>>> +
>>>       timekeeping_forward_now(tk);
>>>       xt = tk_xtime(tk);
>>
>> Might also want to add the flag to inject_offset as well, since that
>> could be used to set the time.
>
> I wasn't sure about that because I had only a quick look at 
> inject_offset() and had the impression it's only able to inject a 
> relative small offset (so not usable at boot). And, as written 
> sometimes before, I haven't had a deep look at suspend/resume, which 
> might be the only place where it is really used to set the clock when
> systime_was_set is false.

Not via suspend/resume, since those modify the boottime to account for 
the sleep time that has past.

I'm thinking via adjtimex ADJ_SETOFFSET (which is relatively new, and 
not widely used). See the do_adjtimex() path in timekeeping.c


thanks
-john

