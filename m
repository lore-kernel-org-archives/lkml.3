Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3EUXQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:16:17 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41219 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3EUXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:16:15 -0400
Message-ID: <519C0004.9000706@ahsoftware.de>
Date: Wed, 22 May 2013 01:15:16 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set
 time at boot
References: <51765FB9.2050009@ahsoftware.de> <1367752887-2927-1-git-send-email-holler@ahsoftware.de> <1367752887-2927-4-git-send-email-holler@ahsoftware.de> <519BEF13.2040500@linaro.org>
In-Reply-To: <519BEF13.2040500@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.05.2013 00:02, schrieb John Stultz:
> On 05/05/2013 04:21 AM, Alexander Holler wrote:
>> drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
>> rtc-hid-sensor-time because it will be called in late_init, and thus
>> before
>> rtc-hid-sensor-time gets loaded. To set the time through
>> rtc-hid-sensor-time at startup, the module now checks by default if the
>> system time is before 1970-01-02 and sets the system time (once) if
>> this is
>> the case.
>>
>> To disable this behaviour, set the module option hctosys to zero, e.g. by
>> using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
>> driver is statically linked into the kernel.
>
> Sorry I missed this earlier, it fell into my spam box for some reason.
>

I've recently heard that gmail seems to move my mails to a SPAM folder 
(too). As I don't know why, I can't help with that and I have to live 
with the fact that I seem to get censored by Google (if it isn't a 
problem of my mail setup, but I'm not aware of such). Anyway, I'm sure 
some people like that I'm silenced this way. ;)

>
> Like Andrew, I think this feels particularly hacky.
>
> Why exactly is late_init too early? (I'm unfamiliar with the
> rtc-hid-sensor-time driver)

Currently it can be an USB device (and maybe Bluetooth or even i2c in 
the future, depends on hid-sensor-hub). That has some implications:

(1) Initialization might need longer (or happens later) than late_init, 
even if everything is linked into the kernel (same problem as with a 
boot from USB-storage)
(2) It might not even be available at boot, but it should work if a user 
plugs it in afterwards.
(3) To accomplish (2) it should set the system time (by default) IFF 
nothing else did set the time.

That "nothing else" in (3) is for security reasons, because no plugable 
HID device should be able to change the system time by default.

The check if something else did set the system time can't be 
accomplished only by the RTC subsystem because userspace, network  or 
whatever else is able to set the system time most likely doesn't use the 
RTC subsystem (or hctosys).

E.g. one of those setups could be:

boot
hctosys (fails because of no RTC)
ntpdate/rdate/date < whatever
load modules (rtc-hid-sensor-time)

If we would use a flag in the hctosys module then rtc-hid-sensor-time 
would be able to change the time (in the setup above).

Using a module option which is by default off doesn't help too. Users 
(or even distros) which would turn it on, might forget it and systems 
would be at risk if no HID clock will be found at boot (but later 
plugged in by some blackhat).

A flag in the time subsystem itself would do the trick. Such a flag 
might help with the problem if the RTC subsystem or the persistent clock 
code did set the time too. You've mentioned in another thread that you 
had to solve such a problem, but I'm not aware how you did that.

Implementation could be as easy as a bool "time_set_at_least_once" in 
the timer subsystem itself (e.g. in do_settimeofday() and whatever 
similiar is available).

 >
 > If this is a hotplug rtc device (why I'm guessing its not available at
 > late_init), would it not be better to leave the setting of time using
 > hwclock --hctosys via a udev rule or something?

I want to set the time with millisecond precision (if the HID clock 
offers that), which currently isn't available through the RTC subsystem.

But even if milliseconds would be available through /dev/rtcN, the 
problem if something else did set the time still would be the same, just 
that an udev-rule now would have that problem.

Regards,

Alexander Holler
