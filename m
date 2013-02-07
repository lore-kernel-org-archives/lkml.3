Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3BGTwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:52:14 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44313 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3BGTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:52:13 -0500
Message-ID: <511405E8.2060004@linaro.org>
Date: Thu, 07 Feb 2013 11:52:08 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFE PATCH] time, Fix setting of hardware clock in NTP code
References: <1360243741-25213-1-git-send-email-prarit@redhat.com> <CANcMJZAYY779QNCBV5OR7_ybk=RFqNazwPxUsWt12G60aiRuSw@mail.gmail.com> <5113F05E.30001@redhat.com>
In-Reply-To: <5113F05E.30001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 10:20 AM, Prarit Bhargava wrote:
>
> On 02/07/2013 12:24 PM, John Stultz wrote:
>> On Thu, Feb 7, 2013 at 5:29 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>> We do not see this manifest on some architectures because they limit changes
>>> to the rtc to +/-15 minutes of the current value of the rtc (x86, alpha,
>>> mn10300).  Other arches do nothing (cris, mips, sh), and only a few seem to
>>> show this problem (power, sparc).  I can reproduce this reliably on powerpc
>>> with the latest Fedoras (17, 18, rawhide), as well as an Ubuntu powerpc spin.
>>> I can also reproduce it "older" OSes such as RHEL6.
>> Interesting.
>> Yea, local RTC time is probably pretty rare outside of x86 (due to windows).
>> And the +/- 15minute trick has always explicitly masked this issue there.
>>
> I'm not sure I understand the purpose behind the +/-15 minute window?  Is it
> just to prevent a wild swing on the RTC?  I can understand that to some degree,
> however, I'm not sure I agree with it being the default behaviour.

The 15 minute cap is totally an x86-ism, and I believe its due to the 
fact that the main concern is we don't reliably know the timezone data 
has been set properly, but we're expected to work well dual booting with 
Windows.

Imagine the case where he RTC is local, but the system doesn't set the 
timezone at boot, so warp-clock never runs, and then NTP jumps in and 
just sets the RTC to UTC, which then causes problems the next boot up 
with windows.


> Here's a real-world scenario:
>
> My RTC on my laptop is set to 1:30PM Jan 7, 2013.  I boot, systemd and ntp do
> their magic, and the system time comes up as Feb 7, 12:48PM.  I never will
> notice that the RTC is wrong.
>
> Now I go somewhere and have to work on a plane.  I have no internet connection
> and then boot.  Now the system time will be 1:30PM Jan 7, 2013.  That's actually
> happened to me and I remember filing it away for a bug to be looked at.
>
> AFAIK, no other OS does that ... if I install Windows or use a Mac in the
> no-internet connection case, the time is *always* corrected.  I tried to see if
> I could get this to happen on a Mac and I can't.

Yea, although I suspect you'd have problems dual-booting a Mac with Windows.
http://lifehacker.com/5742148/fix-windows-clock-issues-when-dual+booting-with-os-x

Though interestingly that link suggests a fix on the windows side.


> 99.99999% of Linux users out there are using some sort of time protocol (usually
> NTP, but PTP is starting to catch on) to sync their systems.  NTP is a trusted
> source of timekeeping IMO.  How often do we see systems that run NTP but don't
> trust the numbers that come from it?

I actually doubt ntp usage is that high, given that some popular distros 
don't install it by default, but that's a tangent. :)

Again, the quirks here are all about interacting with Windows on a 
dual-boot environment.

Though I think it might be reasonable at this point to say we'll set the 
RTC as accurately as we can with the given info, which requires the 
distro to trigger warp clock if the RTC is kept in local time.




>>>   /*
>>> + * Indicates if there is an offset between the system clock and the hardware
>>> + * clock/persistent clock/rtc.
>>> + */
>>> +int sys_time_offset;
>> So why is this extra flag necessary instead of just using if
>> (sys_tz.tz_minuteswest) ?
> sys_tz can be set during runtime via settimeofday() without affecting the
> current system time.  The bug *only* happens if the system clock is "warped"
> ahead relative to the hardware clock on the first call to settimeofday(), so
> checking for sys_tz.tz_minuteswest isn't good enough of a test.

So it would probably be better named as something like rtc_is_local.


So yea, I think if we include your patch, we can probably consider 
dropping the 15 min cap. There will probably be some situations where 
system setups don't have RTC local configured, so that flag isn't set 
and we'll fight with a dual-boot environment, but those hopefully should 
be rare.

I'd suggest we do this in two steps. First your current patch, adding 
rtc_is_local flag and the RTC timezone correction in 
update_persistent_clock(), then second a patch for x86 dropping the 15 
min cap that gets wide distribution so all the distros know its coming 
and can test it and object if necessary.

thanks
-john





