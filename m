Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3DXQva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:51:30 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61649 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3DXQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <5178088D.7010703@linaro.org>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org> <CAPXgP12D-H_E3WbWYgrbtvA_6wq=DhpiaLU_hGRgD6ga=_1x-A@mail.gmail.com>
 <5178088D.7010703@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 18:51:07 +0200
Message-ID: <CAPXgP10LS38M=4C+mt+pA6HXzRoyroE01n4-W9tWUEomYqijZQ@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 6:30 PM, John Stultz <john.stultz@linaro.org> wrote:

>> Until the above commits we always needed:
>>    CONFIG_RTC_HCTOSYS=y
>>    CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
>> to get the system time correctly initialized at bootup on x86.

> So... always needed to get system time correctly initialized? I'm not sure I
> agree with this. On non-x86 (mostly embedded) platforms that do not have
> persistent_clock support, yes, the above is needed.

Yeah, right, that's an "always" like the "forever" in "we support that
for forever" :)

> But I'm unaware of the above actually being necessary on x86, as its always
> had persistent_clock support.

Maybe it goes back longer, I remember that we needed to run hwclock in
userspace otherwise we had the 1970 state.

Here is the Fedora bug from 2009 to enable it:
  https://bugzilla.redhat.com/show_bug.cgi?id=489494

>> These options are gone now and cannot be selected anymore. You are
>> saying that this is all fine, that they are gone, but all initial
>> clock syncing should still work?
>
> Yes, we're just removing a duplicative initialization of time, and compiling
> out code in the suspend/resume path that would never trigger when
> persistent_clocks were present.

I see, makes sense.

>> Also:
>>    $ cat /sys/class/rtc/rtc0/hctosys
>>    0
>> always carried "1", and this now breaks setups which expect an
>> automatically created symlink /dev/rtc to the actual "system rtc".
>
>
> Sigh. So just turning off HCTOSYS on those systems causes them to break?

Well, the symlink is no longer there, which is visible. People asked
where it is gone now. That's the "breakage" which might not deserve
that word, if nothing really breaks that way. Stuff we looked at so
far, falls back to /dev/rtc0 which covers that.

> That is sort of obnoxiously fragile.  I've always been somewhat skeptical of
> the multi-rtc configs - as they're all the "system's" RTCs after all. 99%
> probably only have one rtc device, so checking the hctosys in that case is a
> little silly.

Yeah, ARM is as a mess, they often have rtc1 as the "system rtc", that
is why all this symlink game was "invented".

> But the terribly annoying interface breakage when /dev/rtc went to /dev/rtcN
> with the generic rtc layer landing shouldn't have happened, so I won't
> begrudge too much the userland hacks needed to fix that up.

Right.

> So I'll send Thomas a revert for the HCTOSYS optimization. In the kernel
> we'll still avoid using HCTOSYS when the persistent_clock is there, but at
> least userland will still have some /sys/class/rtc/rtcN that has the
> "offical" flag.

So in case you really revert it, x86 should not enable any of that RTC
stuff by default, right?

>> There was also always a line in dmesg that told the rtc_cmos time it
>> wrote to the system clock. This is also gone?
>
> More worrisome, I'll turn the question around: is that an expected interface
> never to break?

No, sure not. I was just noticing that, when looking what was going
on, and I couldn't make sense out of it before you explained the
details.

Kay
