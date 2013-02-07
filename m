Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab3BGUDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759335Ab3BGUDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:03:32 -0500
Message-ID: <5114088B.8060700@redhat.com>
Date: Thu, 07 Feb 2013 15:03:23 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFE PATCH] time, Fix setting of hardware clock in NTP code
References: <1360243741-25213-1-git-send-email-prarit@redhat.com> <CANcMJZAYY779QNCBV5OR7_ybk=RFqNazwPxUsWt12G60aiRuSw@mail.gmail.com> <5113F05E.30001@redhat.com> <511405E8.2060004@linaro.org>
In-Reply-To: <511405E8.2060004@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2013 02:52 PM, John Stultz wrote:
> On 02/07/2013 10:20 AM, Prarit Bhargava wrote:
>>
>> On 02/07/2013 12:24 PM, John Stultz wrote:
>>> On Thu, Feb 7, 2013 at 5:29 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>
>> I'm not sure I understand the purpose behind the +/-15 minute window?  Is it
>> just to prevent a wild swing on the RTC?  I can understand that to some degree,
>> however, I'm not sure I agree with it being the default behaviour.
> 
> The 15 minute cap is totally an x86-ism, and I believe its due to the fact that
> the main concern is we don't reliably know the timezone data has been set
> properly, but we're expected to work well dual booting with Windows.

Heh :)  I think some of the other arches have copied what x86 does.  alpha and
mn10300 do the same thing. :)


> 
>> 99.99999% of Linux users out there are using some sort of time protocol (usually
>> NTP, but PTP is starting to catch on) to sync their systems.  NTP is a trusted
>> source of timekeeping IMO.  How often do we see systems that run NTP but don't
>> trust the numbers that come from it?
> 
> I actually doubt ntp usage is that high, given that some popular distros don't
> install it by default, but that's a tangent. :)

:D  Fair enough :D

> 
> Again, the quirks here are all about interacting with Windows on a dual-boot
> environment.
> 

Sure, that's been my understanding as well.

> Though I think it might be reasonable at this point to say we'll set the RTC as
> accurately as we can with the given info, which requires the distro to trigger
> warp clock if the RTC is kept in local time.

Okay.

> 
> 
> 
> 
>>>>   /*
>>>> + * Indicates if there is an offset between the system clock and the hardware
>>>> + * clock/persistent clock/rtc.
>>>> + */
>>>> +int sys_time_offset;
>>> So why is this extra flag necessary instead of just using if
>>> (sys_tz.tz_minuteswest) ?
>> sys_tz can be set during runtime via settimeofday() without affecting the
>> current system time.  The bug *only* happens if the system clock is "warped"
>> ahead relative to the hardware clock on the first call to settimeofday(), so
>> checking for sys_tz.tz_minuteswest isn't good enough of a test.
> 
> So it would probably be better named as something like rtc_is_local.

I'll do a [v2] with that change as well.

> 
> 
> So yea, I think if we include your patch, we can probably consider dropping the
> 15 min cap. There will probably be some situations where system setups don't
> have RTC local configured, so that flag isn't set and we'll fight with a
> dual-boot environment, but those hopefully should be rare.
> 
> I'd suggest we do this in two steps. First your current patch, adding
> rtc_is_local flag and the RTC timezone correction in update_persistent_clock(),
> then second a patch for x86 dropping the 15 min cap that gets wide distribution
> so all the distros know its coming and can test it and object if necessary.

That's what I was hoping for.  I'll post this as an actual patch and then get to
work on the full sync code next.

Thanks,

P.

> 
> thanks
> -john
> 
> 
> 
> 
> 
