Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3E1Tha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:37:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53955 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3E1Th1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:37:27 -0400
Message-ID: <51A50774.6060400@linaro.org>
Date: Tue, 28 May 2013 12:37:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set
 time at boot
References: <51765FB9.2050009@ahsoftware.de> <1367752887-2927-1-git-send-email-holler@ahsoftware.de> <1367752887-2927-4-git-send-email-holler@ahsoftware.de> <519BEF13.2040500@linaro.org> <519C0004.9000706@ahsoftware.de>
In-Reply-To: <519C0004.9000706@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:15 PM, Alexander Holler wrote:
> Am 22.05.2013 00:02, schrieb John Stultz:
>
>>
>> Like Andrew, I think this feels particularly hacky.
>>
>> Why exactly is late_init too early? (I'm unfamiliar with the
>> rtc-hid-sensor-time driver)
>
> Currently it can be an USB device (and maybe Bluetooth or even i2c in 
> the future, depends on hid-sensor-hub). That has some implications:
>
> (1) Initialization might need longer (or happens later) than 
> late_init, even if everything is linked into the kernel (same problem 
> as with a boot from USB-storage)
> (2) It might not even be available at boot, but it should work if a 
> user plugs it in afterwards.
> (3) To accomplish (2) it should set the system time (by default) IFF 
> nothing else did set the time.
>
> That "nothing else" in (3) is for security reasons, because no 
> plugable HID device should be able to change the system time by default.
>
> The check if something else did set the system time can't be 
> accomplished only by the RTC subsystem because userspace, network or 
> whatever else is able to set the system time most likely doesn't use 
> the RTC subsystem (or hctosys).
>
> E.g. one of those setups could be:
>
> boot
> hctosys (fails because of no RTC)
> ntpdate/rdate/date < whatever
> load modules (rtc-hid-sensor-time)
>
> If we would use a flag in the hctosys module then rtc-hid-sensor-time 
> would be able to change the time (in the setup above).
>
> Using a module option which is by default off doesn't help too. Users 
> (or even distros) which would turn it on, might forget it and systems 
> would be at risk if no HID clock will be found at boot (but later 
> plugged in by some blackhat).
>
> A flag in the time subsystem itself would do the trick. Such a flag 
> might help with the problem if the RTC subsystem or the persistent 
> clock code did set the time too. You've mentioned in another thread 
> that you had to solve such a problem, but I'm not aware how you did that.
>
> Implementation could be as easy as a bool "time_set_at_least_once" in 
> the timer subsystem itself (e.g. in do_settimeofday() and whatever 
> similiar is available).

If it were to be done this way, it would be good to have the RTC layer 
check when RTC devices are registered and call the internal hctosys 
functionality then (rather then just at late_init). Do you want to try 
to rework the patch in this way?

I'm not totally sure I'd agree that it would be better over leaving it 
to userspace, but if we're going to go with an in-kernel policy for 
this, then it seems like a better approach then the current patch.

>
> >
> > If this is a hotplug rtc device (why I'm guessing its not available at
> > late_init), would it not be better to leave the setting of time using
> > hwclock --hctosys via a udev rule or something?
>
> I want to set the time with millisecond precision (if the HID clock 
> offers that), which currently isn't available through the RTC subsystem.

True. This is one area I'd like to see addressed at some point. A few 
RTC devices have sub-second granularity and we're not exposing it via 
the RTC subsystem to either kernel or userland consumers.


> But even if milliseconds would be available through /dev/rtcN, the 
> problem if something else did set the time still would be the same, 
> just that an udev-rule now would have that problem.

Though a udev hack to check if its 1970 would be fairly simple. And 
pushes the policy of setting or not setting clearly off to userland 
(which allows for less compile-time or boot option tweaks to manipulate).

thanks
-john

