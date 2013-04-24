Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3DXCnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:43:53 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41837 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3DXCnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:43:51 -0400
Message-ID: <517746E4.908@linaro.org>
Date: Tue, 23 Apr 2013 19:43:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
In-Reply-To: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 06:34 PM, Kay Sievers wrote:
> Hey,
>
> what's the intention of:
>    e90c83f757fffdacec8b3c5eee5617dcc038338f ?
>    x86: Select HAS_PERSISTENT_CLOCK on x86
>
> It unconditionally sets:
>    HAS_PERSISTENT_CLOCK
> but:
>    RTC_SYSTOHC
> got a depends on !HAS_PERSISTENT_CLOCK
>
> This makes it impossible to sync the system time from the RTC on x86.
> What's going on here?

So I suspect just some confusion, but let me know if thats wrong and 
you're actually seeing an issue.

SYSTOHC is what *sets the RTC* to the system time when we're synced with 
NTP.

HCTOSYS is what sets the system time from the RTC.

In the past, we've used the update_persistent_clock() interface to set 
the CMOS clock when we're synced with NTP, but now we've got an 
interface that can sync the RTC interface for systems that don't support 
update_persistent_clock().

We've always used the persistent_clock code (or what persistent_clock 
abstracted) on x86, but for awhile there was also ways to configure the 
kernel to also use the generic RTC infrastructure, which could cause odd 
behavior like the time being set/adjusted twice at boot and resume. This 
was mostly avoided in code, but we figured we could also avoid these 
duplicative paths at build time. Thus if HAS_PERSISTENT_CLOCK is 
enabled, we can remove some extra checks that can slow down the resume path.

Now, the persistent_clock and RTC infrastructure are annoyingly 
duplicitive, but have very different constraints. We're hopefully (and 
likely slowly) working to consolidate some of the logic here.

My goal is eventually to remove the use of the persistent_clock() for 
time initialization, instead using the generic RTC infrastructure.

Then I want to morph the persistent_clock infrastructure to really be 
only for measuring suspend time by the timekeeping core at resume. This 
can be done via clocksources that continue to count via suspend, or via 
the RTC layer, however we need a special RTC hook to allow us to read 
the RTC time when interrupts are disabled (not all RTCs support this). 
Then only should both of those options fail, fall back to the late (and 
more error prone) rtc resume hook for suspend timing.

But of course, I don't have patches for this transition yet, and I'm not 
sure when in the near term I'll get time to focus on this cleanup.

However, if you are seeing a issue/regression with the existing code in 
your config, please let me know and I'll make sure we address it.

thanks
-john

