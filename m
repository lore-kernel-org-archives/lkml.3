Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3DWPsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:48:00 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49295 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3DWPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:47:58 -0400
Message-ID: <5176AD08.8090108@ahsoftware.de>
Date: Tue, 23 Apr 2013 17:47:20 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] rtc: rtc-hid-sensor-time; add option hctosys to set
 time at boot
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de> <1366384452-14367-4-git-send-email-holler@ahsoftware.de> <20130422163830.4aaaef240b1572dc778dd620@linux-foundation.org> <51764B8E.9090402@ahsoftware.de> <51765D8C.1010008@ahsoftware.de> <51765ECD.6020601@ahsoftware.de> <51765FB9.2050009@ahsoftware.de>
In-Reply-To: <51765FB9.2050009@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.04.2013 12:17, schrieb Alexander Holler:
> Am 23.04.2013 12:13, schrieb Alexander Holler:
>> Am 23.04.2013 12:08, schrieb Alexander Holler:
>>> Am 23.04.2013 10:51, schrieb Alexander Holler:
>>>> Am 23.04.2013 01:38, schrieb Andrew Morton:
>>>>> On Fri, 19 Apr 2013 17:14:12 +0200 Alexander Holler
>>>>> <holler@ahsoftware.de> wrote:
>>>>>
>>>>>> drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
>>>>>> rtc-hid-sensor-time because it will be called in late_init, and thus
>>>>>> before
>>>>>> rtc-hid-sensor-time gets loaded.
>>>>>
>>>>> Isn't that true of all RTC drivers which are built as modules?
>>>>> There's
>>>>> nothing special about hid-sensor-time here?
>>>>>
>>>>> I assume the standard answer here is "your RTC driver should be built
>>>>> into vmlinux".  If we wish to make things work for modular RTC drivers
>>>>> then we should find a solution which addresses *all* RTC drivers?
>>>>
>>>> No. I having rtc-hid-sensor-time, hid-sensor-hub (and USB) statically
>>>> linked in doesn't help. Here is what happens here with such an
>>>> configuration:
>>>>
>>>> --
>>>> [    7.638970] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
>>>> [    7.645639] Waiting 180sec before mounting root device...
>>>> [   16.598759] HID-SENSOR-2000a0 HID-SENSOR-2000a0.0: rtc core:
>>>> registered hid-sensor-time as rtc0
>>>> [   16.608712] HID-SENSOR-2000a0 HID-SENSOR-2000a0.0: hctosys: setting
>>>> system clock to 2013-04-19 16:45:06 UTC (1366389906)
>>>> --
>>>>
>>>> I havent't looked in detail at why rtc-hid-sensor-time gets loaded that
>>>> late, but I assume it's because the USB stack (and/or the device or the
>>>> communication inbetween) needs some time (and I assume that's why
>>>> rootwait and rootdelay got invented too).
>>>>
>>>>>
>>>>>> To set the time through rtc-hid-sensor-time
>>>>>> at startup, the module now checks by default if the system time is
>>>>>> before
>>>>>> 1970-01-02 and sets the system time (once) if this is the case.
>>>>>>
>>>>>> To disable this behaviour, set the module option hctosys to zero,
>>>>>> e.g. by
>>>>>> using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
>>>>>> driver is statically linked into the kernel.
>>>>>
>>>>> Is a bit hacky, no?
>>>>
>>>> I didn't have any other idea to prevent an USB (or any other
>>>> hot-pluggable HID) device to change the time while still beeing able
>>>> (by
>>>> default) to set the time by such an device at boot. But I'm open to
>>>> suggestions. (E.g. one of the scenarios I want to prevent is, that a
>>>> computer gets it's time by NTP and someone is able to change the time
>>>> later on by simply plugging in some HID device.)
>>>>
>>>
>>> To add something more: I use the system time as a bool
>>> "time_was_set_once" and have choosen one day just in case something
>>> needs really long to boot (e.g. because of some lengthy fsck or whatever
>>> else).
>>>
>>> A solution to both problems might be to change the logic for hctosys
>>> completly to read the time when the first RTC device appears (or when
>>> the device mentioned in CONFIG_RTC_HCTOSYS_DEVICE appears). But that
>>> would require a change to hctosys or the RTC subsystem, which would
>>> involve more patches and discussion. As rtc-hid-sensor-time currently
>>> seems to be the only RTC with the above problems, I've gone the easy
>>> route and only modified this driver.
>>
>> Oh, damn. I've forgotten my example above with NTP. In that case setting
>> the time when the first RTC appears doesn't work.
>
> So a general solution might be to set the system time when the first RTC
> (or the one mentioned in CONFIG_RTC_HCTOSYS_DEVICE) appears AND nothing
> else did set the time before.

To extend that idea a bit further, I think an option timewait (similiar 
to rootwait) would be a nice to have.

If just time wouldn't be that rare ... ;)

Regards,

Alexander
