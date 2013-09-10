Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3IJUfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:35:05 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40530 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3IJUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:35:03 -0400
Message-ID: <522F8274.7020406@linaro.org>
Date: Tue, 10 Sep 2013 13:35:00 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <5400101.STbFFoov5a@tauon>
In-Reply-To: <5400101.STbFFoov5a@tauon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:47 PM, Stephan Mueller wrote:
> Am Dienstag, 10. September 2013, 12:38:56 schrieb John Stultz:
>
> Hi John,
>
>> On Tue, Sep 10, 2013 at 4:31 AM, Stephan Mueller <smueller@chronox.de> 
> wrote:
>>> Hi,
>>>
>>> /dev/random uses the get_cycles() function to obtain entropy in
>>> addition to jiffies and the event value of hardware events.
>>>
>>> Typically the high-resolution timer of get_cycles delivers the
>>> majority of entropy, because the event value is quite deterministic
>>> and jiffies are very coarse.
>> [snip]
>>
>>> The following patch uses the clocksource clock for a time value in
>>> case get_cycles returns 0. As clocksource may not be available
>>> during boot time, a flag is introduced which allows random.c to
>>> check the availability of clocksource.
>> [snip]
>>
>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>> index 48b9fff..75b1613 100644
>>> --- a/kernel/time/timekeeping.c
>>> +++ b/kernel/time/timekeeping.c
>>> @@ -35,6 +35,7 @@ static struct timekeeper timekeeper;
>>>
>>>  static DEFINE_RAW_SPINLOCK(timekeeper_lock);
>>>  static seqcount_t timekeeper_seq;
>>>  static struct timekeeper shadow_timekeeper;
>>>
>>> +static bool timekeeper_enabled = 0;
>>>
>>>  /* flag for if timekeeping is suspended */
>>>  int __read_mostly timekeeping_suspended;
>>>
>>> @@ -833,8 +834,15 @@ void __init timekeeping_init(void)
>>>
>>>         write_seqcount_end(&timekeeper_seq);
>>>         raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
>>>
>>> +       timekeeper_enabled = 1;
>>>
>>>  }
>> So the end of timekeeping_init() may not be what you want here. This
>> only means we've started up the timekeping core with only the default
>> clocksource (with only few exceptions, this is almost always jiffies).
>> Then as clocksource drivers are initialized, they are registered and
>> the timekeeping core will switch over to the best available
>> clocksource.  Also, to avoid the churn at boot of switching to every
>> clocksource registered, we queue them up and wait until fs_init time
>> to switch to whatever is the best available then.
>>
>> So its likely with this patch that the systems all still end up using
>> jiffies for their clocksource at least until fs_init time.
> Thank you for the explanation. Is there any trigger that is fired at 
> fs_init time that one can read?
Check out clocksource_done_booting(), as that's probably where you'd
want to add something similar. Now this doesn't ensure non-jiffies
clocksources are installed, just that we're far enough into boot that we
assume most of the system's clocksources have been registered.

timekeeping_valid_for_hres() might be a better check for what you're
looking for, since that means some free-running clocksource has been
installed.

thanks
-john

