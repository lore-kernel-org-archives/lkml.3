Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423792Ab3FVIC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 04:02:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48407 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423731Ab3FVICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 04:02:19 -0400
Message-ID: <51C5598C.30203@ahsoftware.de>
Date: Sat, 22 Jun 2013 10:00:12 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 6/9 v3] RFC: timekeeping: rtc: remove CONFIG_RTC_HCTOSYS
 and RTC_HCTOSYS_DEVICE
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-7-git-send-email-holler@ahsoftware.de> <51BB6ACF.9050702@linaro.org>
In-Reply-To: <51BB6ACF.9050702@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.06.2013 21:11, schrieb John Stultz:
> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>> Those config options don't make sense anymore with the new hctosys
>> mechanism introduced with the previous patch.
>>
>> That means two things:
>>
>> - If a (hardware) clock is available it will be used to set the time at
>>    boot. This was already the case for system which have a "persistent"
>>    clock, e.g. most x86 systems. The only way to specify the device used
>>    for hctosys is now by using the kernel parameter hctosys= introduced
>>    with a previous patch.
>>
>> - If a hardware clock was used for hctosys before suspend, this clock
>>    will be used to adjust the clock at resume. Again, this doesn't change
>>    anything on systems with a "persistent" clock.
>>
>> What's missing:
>>
>> I don't know much about those "persistent" clocks and I haven't had a
>> deep look at them. That's especially true for the suspend/resume
>> mechanism used by them. The mechanism I want to use is the following:
>> The RTC subsystem now maintains the ID of the RTC device which was used
>> for hctosys (in rtc_hctosys_dev_id) and therefor specifies the device
>> which should be used to adjust the time after resume. Additionaly the
>> (new) flag systime_was_set will be set to false at suspend and on resume
>> this flag will be set to true if either the clock will be adjusted by
>> the device used for hctosys or by userspace (through do_settimeofday()).
>>
>> That all should already work as expected for RTCs, what's missing for
>> "persistent" clocks is that the flag systime_was_set is set to false on
>> suspend and set to true on resume. Currently it just stays at true
>> (which is set through hctosys if a "persistent" clock is found.
>> But because "persistent" clocks don't go away (as it is possible with
>> RTCs by removing the driver or the RTC itself), nor do "persistent"
>> clocks might have two instances, this shouldn't be a problem at all.
>
> This one concerns me a bit. Since you're removing quite a bit and it
> looks like it may break userland expectations.

The only thing I remove from a user point of view is a broken (because 
undetermined) informational entry (/proc/driver/rtc) if persistent 
clocks are used.

>
> I ran into this myself recently, when I found some distros look for
> /sys/class/rtc/rtcN/hctosys in order to determine which rtc device
> should be synced with from userland.

The patches don't change anything in /sys.

>
> So I'd probably suggest instead to re-factor this so you leave all the
> hctosys bits alone, but just change it from being called by a
> late_initcall() and instead have it called when we register the RTC that
> matches CONFIG_RTC_HCTOSYS_DEVICE.
>
> I suspect it will end up being a much smaller change that way.
>
> Then the last bit is just a matter of adding the
> timekeeping_systimeset() check to the hctosys bits.

This doesn't work because the current hctosys approach is (imho) broken 
by design, at least how it currently works. Of course, this might be the 
result of changes, refused patches or whatever, I don't know the history 
of the current hctosys.

First it's only a kernel configuration, that means most users can't even 
change it. Second, it just defines the N in rtcN, which is based on the 
order RTC drivers are loaded (undefined). Third, it ignores persistent 
clocks, and if persistent clocks are used, the informational entry in 
/proc is misleading and just might fit because of some lucky circumstance.

As it seems hard to understand the changes, here they are again, maybe 
my second description is more understandable.


1. Replacment of the Kernel config option CONFIG_RTC_HCTOSYS by a kernel 
command line parameter hctosys=.
   - Kernel config options are unavailable for most users.
     A kernel command line parameter gives them the possibility to
     change it.
   - The current config option ignores persistent clocks at all. It
     doesn't allow to disable persistent clocks and therefor it is
     misleading. I assume most users don't even know persistent clocks
     do exist. Fixed with the new kernel command line parameter.

2. Replacement of RTC_HCTOSYS_DEVICE by a kernel command line parameter 
hctosys=.
   - Again, it's a kernel config option only, not changeable by most
     users. The new hctosys= allows ordinary (non-kernel-compiling) users
     to change that.
   - The current config option is based on the order RTC drivers are
     loaded, which is non-deterministic thus undefined. The new hctosys=
     allows to choose the used RTC driver by name.
   - The config option ignores persistent clocks, the new hctosys=
     kernel commandline parameter doesn't.

3. Removal of /proc/driver/rtc if and only if a persistent clock is used.
   - If a persistent clock is used, the informational entry in /proc
     might be totally wrong because it is based on the first loaded RTC
     driver. The first loaded RTC driver doesn't have to be the
     corresponding rtc-driver which uses the same hardware clock as the
     persistent clock and might describe a totally different hardware
     clock.
   - If a persistent clock is used, it describes the abilities of the
     RTC driver, but not those of the persistent clock driver. This
     might be misleading because only the persistent clock driver is
     used and not the corresponding (described) RTC driver.
   - No changes for users of any RTC driver. The entry in /proc will
     still be there.

Regards,

Alexander Holler
