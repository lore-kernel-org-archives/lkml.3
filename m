Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3DYG4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:56:22 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35420 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3DYG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:56:20 -0400
Message-ID: <5178D367.4050905@ahsoftware.de>
Date: Thu, 25 Apr 2013 08:55:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 3/3] rtc: rtc-hid-sensor-time; add option hctosys to set
 time at boot
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de> <1366384452-14367-4-git-send-email-holler@ahsoftware.de> <20130422163830.4aaaef240b1572dc778dd620@linux-foundation.org> <51764B8E.9090402@ahsoftware.de> <51765D8C.1010008@ahsoftware.de> <51765ECD.6020601@ahsoftware.de> <51765FB9.2050009@ahsoftware.de> <5176AD08.8090108@ahsoftware.de> <20130424141459.df581d79e6e296f90eb1369c@linux-foundation.org>
In-Reply-To: <20130424141459.df581d79e6e296f90eb1369c@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2013 23:14, schrieb Andrew Morton:
> On Tue, 23 Apr 2013 17:47:20 +0200 Alexander Holler <holler@ahsoftware.de> wrote:
>
>>>>> "time_was_set_once" and have choosen one day just in case something
>>>>> needs really long to boot (e.g. because of some lengthy fsck or whatever
>>>>> else).
>>>>>
>>>>> A solution to both problems might be to change the logic for hctosys
>>>>> completly to read the time when the first RTC device appears (or when
>>>>> the device mentioned in CONFIG_RTC_HCTOSYS_DEVICE appears). But that
>>>>> would require a change to hctosys or the RTC subsystem, which would
>>>>> involve more patches and discussion. As rtc-hid-sensor-time currently
>>>>> seems to be the only RTC with the above problems, I've gone the easy
>>>>> route and only modified this driver.
>>>>
>>>> Oh, damn. I've forgotten my example above with NTP. In that case setting
>>>> the time when the first RTC appears doesn't work.
>>>
>>> So a general solution might be to set the system time when the first RTC
>>> (or the one mentioned in CONFIG_RTC_HCTOSYS_DEVICE) appears AND nothing
>>> else did set the time before.
>>
>> To extend that idea a bit further, I think an option timewait (similiar
>> to rootwait) would be a nice to have.
>>
>> If just time wouldn't be that rare ... ;)
>
> Yes, some sort of notifier callout when the CONFIG_RTC_HCTOSYS_DEVICE
> device is registered seems appropriate.  I didn't understand why that
> is problematic for NTP.
>
> Getting all the lifetime/reference stuff right will be tricky :( Can't
> shut down or unload a driver when it is on that notification list.
>
> And it assumes that the CONFIG_RTC_HCTOSYS_DEVICE driver is all ready
> to go when it registers itself.  Hopefully that is true, but they
> should be reviewed.
>
> Adding the timewait thing sounds unpleasant - how to reliably tune the
> interval for all possible users of your distro?  We should aim to make
> things synchronous, deterministic and
> stuff-happens-in-the-correct-order.
>
> It all sounds like a moderate amount of work, but it would be great
> to be able to fix this for all drivers, not just hid-sensor-time.  That's
> assuming that other drivers have the same issue - perhaps they don't,
> but perhaps things can go wrong if the module loading order is wrong?
>

I've added John Stultz to cc as he seems to work on a similiar problem 
(to not set the time twice on resume).

I'm not sure what you meant with the notifiers, but wouldn't be a 
function which sets the time if nothing else did that before a solution?

I think about something like that (not real code):

static bool timeWasSet; // = 0

int setTimeIfNotSet(time, devicename)
{
   if (timeWasSet || (devicename && CONFIG_RTC_HCTOSYS_DEVICE && 
devicename != CONFIG_RTC_HCTOSYS_DEVICE )
     return -1;

   timeWasSet = 1;
   do_settimeofday(time);
   return 0;
}

That "timewait" kernel option I mentioned above then would be easy too:

void timewait(void)
{
   while (!timeWasSet)
     sleepOrSimiliar();
}

That setTimeIfNotSet() function could be called by the RTC subsystem 
whenever a new RTC will be registered and CONFIG_RTC_HCTOSYS is enabled 
(or on resume).
In regard to the persistent_clocks on x86 I know almost nothing. I 
didn't even knew they do exist before I've seen a discussion about 
HCTOSYS yesterday. I thought the RTC_CMOS driver is responsible for the 
time on x86. ;) Therfor I can't say anything about how things do work there.

Whats missing above is something which sets timeWasSet to 1 if userland 
(NTP or similiar) does set the time. That could be done always (in 
do_settimeofday) or e.g. by using a function pointer to 
do_settimeofday() which first points to a function which sets timeWasSet 
and later on points to do_settimeofday() directly.

Maybe it's all silly (I'm missing the big overview over time in the 
kernel), but thats what first entered my mind while thinking about how 
to avoid changing a time by an HID device if it was already set by 
userland/NTP or another clock (besides that trick in testing for system 
date < 1970-01-02 I've then used in my patch because it was easy to 
implement while not doing changes to timekeeping itself).

Regards,

Alexander
