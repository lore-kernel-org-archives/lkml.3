Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbaJ3P1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:27:36 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:55928 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161083AbaJ3P1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410301507350.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
	<1414667745-7703-6-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1410301507350.5308@nanos>
Date: Thu, 30 Oct 2014 08:27:33 -0700
Message-ID: <CALAqxLV5EpXsfwUBj5-6uZb58Xaic+yzSON91-oOZm80LfCV1A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/11] time: Convert all users of do_settimeofday()
 to use do_settimeofday64()
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        xen-devel@lists.xenproject.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 30 Oct 2014, pang.xunlei wrote:
>
>> As part of addressing 2038 saftey for in-kernel uses, this patch
>> converts all users of do_settimeofday() to use do_settimeofday64().
>
> You forgot to insert 'blindly' between 'converts' and 'all'.
>
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -486,6 +486,7 @@ static void __init xen_time_init(void)
>>  {
>>       int cpu = smp_processor_id();
>>       struct timespec tp;
>> +     struct timespec64 tp64;
>>
>>       clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>>
>> @@ -496,9 +497,13 @@ static void __init xen_time_init(void)
>>               xen_clockevent = &xen_vcpuop_clockevent;
>>       }
>>
>> -     /* Set initial system time with full resolution */
>> +     /*
>> +      * Set initial system time with full resolution
>> +      * TODO: [2038 safety] xen_read_wallclock() uses timespec64
>
> This is the wrong approach, really.
>
> First of all this wants to be a seperate patch. Secondly it wants to
> be a patch series which addresses the whole XEN space which is
> involved in this. That involves other changes to x86 as well, but we
> really can do better than mechanically pushing the problem one step
> deeper just to get rid of the non safe do_settimeofday() variant.
>
> It does not matter WHEN we remove that. What matters is that we do the
> conversion in sensible contexts and not by mechanically pushing the
> problem one layer down, leave cryptic TODO comments around and think
> we achieved something.

So agreed that this patch should be broken up.

And yea, as a side effect of your earlier feedback to add 64bit
interfaces and slowly migrate, I guess it does make sense to handle
all the interfaces first, and then cohesively address each subsystem,
rather then addressing interface by interface through the whole
system.  My suggested partitioning of the problem doesn't produce as
nice to understand patches.

That said, this is a big project with a number of folks attacking it,
and as seen in the Xen code (where xen's settime logic bleeds into the
pv persistent clock logic), if we go subsystem by subsystem rather
then interface by interface, there will be cases where subsystems
interact and I think we'll still have to have similar TODOs notes and
iterations. I think having some greppable tag in the comments will
help as we iterate through things.


>> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
>> index ff4b3e8..01017ff 100644
>> --- a/drivers/staging/android/alarm-dev.c
>> +++ b/drivers/staging/android/alarm-dev.c
>> @@ -152,16 +152,19 @@ static int alarm_wait(void)
>>       return rv;
>>  }
>>
>> +/* TODO: [2038 safety] alarm_set_rtc() uses timespec64 */
>>  static int alarm_set_rtc(struct timespec *ts)
>>  {
>> +     struct timespec ts64;
>>       struct rtc_time new_rtc_tm;
>>       struct rtc_device *rtc_dev;
>>       unsigned long flags;
>>       int rv = 0;
>>
>> -     rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
>> +     ts64 = timespec_to_timespec64(*ts);
>> +     rtc_time_to_tm64(ts64.tv_sec, &new_rtc_tm);
>>       rtc_dev = alarmtimer_get_rtcdev();
>> -     rv = do_settimeofday(ts);
>> +     rv = do_settimeofday64(&ts64);
>
> John: What kind of weird hackery is that alarm-dev thing? This should
> rather die than being fixed.

I think it was agreed at plumbers that we can drop alarm-dev from
staging. But if its fixed before its dropped, or just dropped doesn't
matter.

thanks
-john
