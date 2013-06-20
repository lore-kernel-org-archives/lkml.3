Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965664Ab3FTSqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:46:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43977 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649Ab3FTSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:46:21 -0400
Message-ID: <51C34DCC.8080501@ahsoftware.de>
Date: Thu, 20 Jun 2013 20:45:32 +0200
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
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de> <51BB60B1.6040007@linaro.org> <51BC034C.8080702@ahsoftware.de> <51BF5132.1060400@linaro.org> <51C2D62A.3060906@ahsoftware.de> <51C33B9B.7030600@linaro.org>
In-Reply-To: <51C33B9B.7030600@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2013 19:27, schrieb John Stultz:
> On 06/20/2013 03:15 AM, Alexander Holler wrote:
>> Am 17.06.2013 20:10, schrieb John Stultz:
>>> On 06/14/2013 11:01 PM, Alexander Holler wrote:
>>>
>>>> What do you think I should write?
>>>>
>>>> void set_systime_was_set(void) and void clear_systime_was_set(void)?
>>>>
>>>> And both functions would have to be exported in order to be usable
>>>> from modules?
>>>>
>>>> Or do you think I should write something like that:
>>>>
>>>> extern bool foo;
>>>> inline void set_foo(void) { foo = true};
>>>> inline void clear_foo(void) { foo = false };
>>>>
>>>> That's just silly, sorry to call it such.
>>>
>>> No no. I'm only asking that the boolean be static to timekeeping.c and
>>> an accessor function be used to read it. Since the timekeeping core
>>> should be managing this value, there should be no reason for any other
>>> users to be setting or clearing the value.
>>
>> First you can't make the value static (semantically) because it has to
>> be set and cleared from different parts of the kernel. And adding
>> accessor functions doesn't help in any way, everyone will still be
>> able to set or clear the value (this still is C and  no C++ with
>> classes or other encapsulation features). The only thing what will
>> happen with such an accessor function is that a small overhead through
>> the then necessary function call is introduced.
>
>
>
>
> Why would it be set and cleared from different parts of the kernel?
>
> We're checking if the system time was set. The system time can be set
> only from a limited number functions in timekeeping.c. It seems
> reasonable it should be static to timekeeping.c
>
> Even so, this is all a tangent. I really think the flag value is racy
> and should be dropped for a timekeeping_setime_if_not_set() - or better
> named - function that can act atomically.
>
>
>
>
>>>
>>>>>> Of course, I might be wrong and there might be a use case where
>>>>>> multiple things do set the system time concurrently and nothing else
>>>>>> did set system time before, but I found that extremly unlikely.
>>>>>
>>>>> Yea, the condition check and the action won't be both be done under a
>>>>> lock, so its likely going to be racy anyway.
>>>>
>>>> And if there ever will be a race for the first timesource to set this
>>>> flag (the first time), and something does care about the outtake, the
>>>> system would be completly broken.
>>>>
>>>> In order to keep it simple, I just tread userspace like a RTC of type
>>>> X and will call them all timesources of type x where a the type is
>>>> defined by the driver.
>>>>
>>>> Let us go through the possible cases:
>>>>
>>>> - 2 or more timesources of different type:
>>>>
>>>> If the order is undefined and they have to race for which clock might
>>>> be used for hctosys (and thus for adjusting the time after resume
>>>> too), the only reason one would want such is for HA purposes. And in
>>>> case of HA, both clocks must have the same time, so nobody does care
>>>> about which one will win the race  (=> no race, no lock or atomic_*
>>>> needed).
>>>>
>>>> If the purpose isn't for HA and someone does care about which
>>>> timesource should be used, the way to do this is to use hctosys=type
>>>> (or hctosys=none in case of userspace) to define which timesource
>>>> should be used for hctosys (=> no race, no lock or atomic_* needed).
>>>>
>>>> - 2 or more timesources of the same type:
>>>> There is no possibility to define which one should win the race. Such
>>>> a system configuration is only usable for HA purposes, so if such
>>>> exists, nobody cares about the outtake of the race (=> no race, no
>>>> lock or atomic_* needed).
>>>>
>>>
>>> The race I'm thinking of is you have a system that normally sets the
>>> time via ntpdate at bootup. Thus they expect the system to always be
>>> started w/ NTP time (even if the system time was initially set via
>>> hctosys).
>>>
>>> Then because of of some delay in the driver (or because the RTC device
>>> was plugged in during boot), the hctosys functionality runs just as
>>> ntpdate is being called.  hctosys sees time has not yet been set and
>>> reads the RTC hardware time. At this point, ntpdate sets the time to NTP
>>> time.  Then hctosys completes, setting the time to the RTC time.  This
>>> results in the system clock being wrong from the user's perspective (as
>>> they expect it to be set to NTP time).
>>
>> Therefor there now will be hctosys as a kernel command line parameter.
>> Instead of a kernel config option which can't be changed by 99% of all
>> Linux users, that option allows ordinary (non kernel compiling) users
>> to disable hctosys at all.
>
>
> I agree your suggestion of having a hctosys= boot option (to override
> the CONFIG_HCTOSYS_DEVICE value) could be a useful extension.
>
> But we shouldn't expect users to set magic boot flags in order to have a
> reliably functioning system. If userland sets the time during init, and
> the hctosys functionality isn't supposed to overwrite that value, then
> there should be no case where userland sets the time at boot, but we end
> up with the RTC time after boot. But currently that race is possible
> (though small).
>
> A more concrete case:
> On many distros ntpd isn't installed by default. Instead they leave the
> kernel to initialize the time from the RTC.

Which still is done, even earlier with the new hctosys (if a RTC is used 
instead of a persistent clock). Nothing changed there. And if the 
persistent clock is used, which is true on almost all x86 systems, the 
race doesn't exist at all, at least as long as the persistent clock 
still exists and will be used (instead of rtc-cmos).

>
> But ntpd can be installed afterwards, and it would be silly to require
> users edit their boot arguments when installing the ntp package.
>
>
>> Something which wasn't possible before without recompiling the kernel.
>> And, like before, most RTC drivers will be loaded before userspace
>> calls ntp/ntpdate. If not, the system is already broken.
>
> I'm not sure I'm following how the system is already broken?

Because it isn't determined what does set the time. The race you've 
described happens because someone wants to use ntp for the hctosys 
functionality but he doesn't want it, if the date might come first from 
a RTC (in case the race window would be even hit). So the configuration 
is broken because it is non-deterministic while someone wants deterministic.


>
>
>> And just in case, I've made that possible window for the above race
>> very small by checking the flag systime_was_set twice, once before
>> starting to read the time and a second time right before the time is
>> set. Ok, the race is still there, but as said before, if that problem
>> does exist at all, the system would be setup wrong at all.
>
> It just seems that if we really want a to do this, we might as well do
> it right, using the timekeeping_settime_first() or whatever function
> that can properly check the value and complete the action atomically
> while holding the lock.
>
>
>>>
>>> This is basically what this code is trying to avoid in the first place.
>>> And I'll grant that its a small race window, but it may lead to
>>> irregular behavior.
>>>
>>> So either we need to document that this race is theoretically possible,
>>> and explain *why* its safe to ignore it.  Or if we really want to do
>>
>> I would think that documenting hctosys=none should be enough.
>
> Again, I don't think users who install ntpd should have to also change
> their boot parameters.
>
>
>> All systems I've seen do load modules very early (before they would
>> start anything ntp related). And the new hctosys is done inside the
>> registration of the RTC. So if a system is configured in such a way
>> that the race really might happen, the system would be broken because
>> the RTC would not be there when starting ntp. To conclude, I think the
>> problem is highly academic/artificial and, if possible at all, only
>> possible on already misconfigured systems during a very, very small
>> window. Therfor I still believe that no locking mechanism is needed.
>>
>> Anyway, I don't care, if you want, I will make an accessor-function
>> with locks and an return code for "set" to indicate if it was already
>> set.
>
> Sorry if I'm frustrating you here, that's not my intent.

I'm not frustrated, I'm just annoyed. I don't know why everyone seems to 
assume that I'm getting frustrated while I just find it totally annoying 
to invest time to make checkpatch-clean max. 80 chars per line wide 
patches while having to use 8 chars intendation and meaningfull variable 
and function names. Besides having to explain and discuss every single 
line and often get called a fool or similiar. I might become frustrated 
if I would need to get patches into the mainline kernel, but happily I'm 
able to manage my own tree of patches and don't have to care if patches 
from me will end up in the mainline kernel. After all I still find it 
much less time consuming to fix bugs and add additional functionalities 
myself instead of just writing bug reports or requesting features. And 
it becomes easier with every patch I write for subsystem xy. ;)

>
>>
>> We could also request and wait for a third opinion on that topic. As
>> it most likely will not end up in any kernel before the end of this
>> year (if at all), there is enough time to do so.
>>
>
> I'm in no rush. I think the changes you're proposing are interesting and
> novel cases that we should handle. But I also do think we should do it
> properly, especially since its relatively easy to do in this case.

Anyway, my intention was to avoid locking stuff in the time-setting 
functions but it looks like that isn't wanted. So I will implement the 
locking foo, after we finished the discussion about the other parts and 
I will have come to the impression that I don't write stuff just for 
nothing. A quick look at your other comments revealed that I have to 
explain a lot more in order to not get accused that I want to kill the 
timekeeping system. ;)

I will answer the next comment shortly.

Regards,

Alexander Holler
