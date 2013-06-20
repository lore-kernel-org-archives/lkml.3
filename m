Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823Ab3FTT2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:28:50 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48225 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663Ab3FTT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:28:48 -0400
Message-ID: <51C357ED.7080409@linaro.org>
Date: Thu, 20 Jun 2013 12:28:45 -0700
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
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de> <51BB60B1.6040007@linaro.org> <51BC034C.8080702@ahsoftware.de> <51BF5132.1060400@linaro.org> <51C2D62A.3060906@ahsoftware.de> <51C33B9B.7030600@linaro.org> <51C34DCC.8080501@ahsoftware.de>
In-Reply-To: <51C34DCC.8080501@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 11:45 AM, Alexander Holler wrote:
> Am 20.06.2013 19:27, schrieb John Stultz:
>> On 06/20/2013 03:15 AM, Alexander Holler wrote:
>>> Therefor there now will be hctosys as a kernel command line parameter.
>>> Instead of a kernel config option which can't be changed by 99% of all
>>> Linux users, that option allows ordinary (non kernel compiling) users
>>> to disable hctosys at all.
>>
>>
>> I agree your suggestion of having a hctosys= boot option (to override
>> the CONFIG_HCTOSYS_DEVICE value) could be a useful extension.
>>
>> But we shouldn't expect users to set magic boot flags in order to have a
>> reliably functioning system. If userland sets the time during init, and
>> the hctosys functionality isn't supposed to overwrite that value, then
>> there should be no case where userland sets the time at boot, but we end
>> up with the RTC time after boot. But currently that race is possible
>> (though small).
>>
>> A more concrete case:
>> On many distros ntpd isn't installed by default. Instead they leave the
>> kernel to initialize the time from the RTC.
>
> Which still is done, even earlier with the new hctosys (if a RTC is 
> used instead of a persistent clock). Nothing changed there. And if the 
> persistent clock is used, which is true on almost all x86 systems, the 
> race doesn't exist at all, at least as long as the persistent clock 
> still exists and will be used (instead of rtc-cmos).


Yea, eventually I'd like to push the persistent clock functionality into 
the RTC core, or remove its use for time initialization and only use the 
persistent clock for suspend/resume timing.

But just because the race doesn't exist on x86, doesn't mean we can 
ignore it for all the various other arches.


>
>>
>> But ntpd can be installed afterwards, and it would be silly to require
>> users edit their boot arguments when installing the ntp package.
>>

This point you left un-addressed, and is the key problem I see with 
requiring boot arguments.


>>
>>> Something which wasn't possible before without recompiling the kernel.
>>> And, like before, most RTC drivers will be loaded before userspace
>>> calls ntp/ntpdate. If not, the system is already broken.
>>
>> I'm not sure I'm following how the system is already broken?
>
> Because it isn't determined what does set the time. The race you've 
> described happens because someone wants to use ntp for the hctosys 
> functionality but he doesn't want it, if the date might come first 
> from a RTC (in case the race window would be even hit). So the 
> configuration is broken because it is non-deterministic while someone 
> wants deterministic.

I still don't see this.  As it stands with the current kernel, the 
HCTOSYS functionality runs prior to init starting, so it may initialize 
time, but any userland setting of time will have the final say.

You're patches allow for the HCTOSYS functionality to happen after init 
starts. And the systime_was_set flag you proposed seems to address this 
change in behavior the following way: Assuming userland has not set the 
clock, allow the HCTOSYS functionality to set the clock after userland 
has run.

This seems like a reasonable balance. However, with your implementation 
there is a small race possible, such that the hctosys might set the time 
to RTC time after userland has set the time.

You seem to be saying the race is only possible if the system doesn't 
use the hctosys= boot argument you're also proposing.
But machines don't need a boot argument now, and aren't broken, so why 
do we want to add an option that requires everyone to use it? Personally 
I think requiring a boot argument is unnecessary (though having a boot 
option can be helpful in some cases - don't mistake me for thinking the 
option is a bad idea, I just don't think it should be required) and is 
actually problematic for distros to handle properly.


>
>>
>>
>>> And just in case, I've made that possible window for the above race
>>> very small by checking the flag systime_was_set twice, once before
>>> starting to read the time and a second time right before the time is
>>> set. Ok, the race is still there, but as said before, if that problem
>>> does exist at all, the system would be setup wrong at all.
>>
>> It just seems that if we really want a to do this, we might as well do
>> it right, using the timekeeping_settime_first() or whatever function
>> that can properly check the value and complete the action atomically
>> while holding the lock.
>>
>>
>>>>
>>>> This is basically what this code is trying to avoid in the first 
>>>> place.
>>>> And I'll grant that its a small race window, but it may lead to
>>>> irregular behavior.
>>>>
>>>> So either we need to document that this race is theoretically 
>>>> possible,
>>>> and explain *why* its safe to ignore it.  Or if we really want to do
>>>
>>> I would think that documenting hctosys=none should be enough.
>>
>> Again, I don't think users who install ntpd should have to also change
>> their boot parameters.
>>
>>
>>> All systems I've seen do load modules very early (before they would
>>> start anything ntp related). And the new hctosys is done inside the
>>> registration of the RTC. So if a system is configured in such a way
>>> that the race really might happen, the system would be broken because
>>> the RTC would not be there when starting ntp. To conclude, I think the
>>> problem is highly academic/artificial and, if possible at all, only
>>> possible on already misconfigured systems during a very, very small
>>> window. Therfor I still believe that no locking mechanism is needed.
>>>
>>> Anyway, I don't care, if you want, I will make an accessor-function
>>> with locks and an return code for "set" to indicate if it was already
>>> set.
>>
>> Sorry if I'm frustrating you here, that's not my intent.
>
> I'm not frustrated, I'm just annoyed. 

Well, I'm sorry if I'm annoying you. Again, not my intent.

> I don't know why everyone seems to assume that I'm getting frustrated 
> while I just find it totally annoying to invest time to make 
> checkpatch-clean max. 80 chars per line wide patches while having to 
> use 8 chars intendation and meaningfull variable and function names. 
> Besides having to explain and discuss every single line and often get 
> called a fool or similiar. 

Just to be clear, I'm in no way calling you a fool. Part of the review 
process is that we have to understand not only what is done but *why* 
its being done. So I have to ask (sometimes dumb) questions so that 
*why* is clearly established. Please don't take these inquiries as 
questioning your ability.


>>>
>>> We could also request and wait for a third opinion on that topic. As
>>> it most likely will not end up in any kernel before the end of this
>>> year (if at all), there is enough time to do so.
>>>
>>
>> I'm in no rush. I think the changes you're proposing are interesting and
>> novel cases that we should handle. But I also do think we should do it
>> properly, especially since its relatively easy to do in this case.
>
> Anyway, my intention was to avoid locking stuff in the time-setting 
> functions but it looks like that isn't wanted. So I will implement the 
> locking foo, after we finished the discussion about the other parts 
> and I will have come to the impression that I don't write stuff just 
> for nothing. A quick look at your other comments revealed that I have 
> to explain a lot more in order to not get accused that I want to kill 
> the timekeeping system. ;)

To be clear, we already do locking in the time-setting functions. I'm 
just proposing we introduce a new time setting function that uses the 
same locking to allow for the flag to be tested and the time to be set 
atomically (returning an error code if the time had been previously set).

thanks
-john
