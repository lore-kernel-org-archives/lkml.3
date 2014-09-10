Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaIJSGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:06:07 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62759 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIJSGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U4ar=jW273=0PMX1A_hTqxPAJ9avJuTD2N4RNa4a12xg@mail.gmail.com>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
 <20140910172710.GA3300@leverpostej> <CAD=FV=U4ar=jW273=0PMX1A_hTqxPAJ9avJuTD2N4RNa4a12xg@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 10 Sep 2014 11:05:43 -0700
X-Google-Sender-Auth: YIC2BP4C9_-sZvk0JrjCxSOVzWw
Message-ID: <CAPz6YkW1ES23+xg5SpjkGz3RA6FCR5t540mRyDvHgqaFWQR-5A@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
To: Doug Anderson <dianders@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:52 AM, Doug Anderson <dianders@chromium.org> wrote:
> Mark,
>
> On Wed, Sep 10, 2014 at 10:27 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> Hi Sonny,
>>
>> On Wed, Aug 27, 2014 at 10:03:39PM +0100, Sonny Rao wrote:
>>> This is a bug fix for using physical arch timers when
>>> the arch_timer_use_virtual boolean is false.  It restores the
>>> arch_counter_get_cntpct() function after removal in
>>>
>>> 0d651e4e "clocksource: arch_timer: use virtual counters"
>>>
>>> and completes the implementation of memory mapped access for physical
>>> timers, so if a system is trying to use physical timers, it will
>>> function properly.
>>
>> To get back to the topic at hand:
>>
>> Which platform is this required by?
>
> I've seen similar problems on the A7s on exynos5420 / exynos5800 and
> on rk3288.  I can't say what other platforms might be affected.  Note
> that the arch timers on exyno5420/exynos5800 are not supported anyway,
> so I guess that means we're just worrying about the rk3288.

Yeah, given that this problem has manifest on at least two different
SoCs using ARM's cores, it would have been nice if the offset were
specified to start out as zero when in reset by the architecture (and
was implemented that way in ARM's core IP), but it looks like it
wasn't.

>
>
>> Why exactly is arch_timer_use_virtual false in this case?
>
> To re-summarize my understanding of everything (many of the below is
> secondhand knowledge, so correct if wrong):
>
> 1. The initial problem is that the virtual offset is not initialized
> by anyone and is per core (each core gets a different, random offset).
> That makes the virtual counter useless.  ...but the kernel only uses
> virtual counters.
>
> 2. As far as I know, we don't have any particular need for HYP mode
> nor for limiting access to secure mode.
>
> 3. You can only change the virtual offset from HYP mode.  That means
> someone needs to transition to HYP mode if we want to use virtual
> counters.
>
> 4. If the kernel happens to be in HYP mode it will init the virtual offset.
>
> 5. We could transition to HYP mode once in the firmware and boot the
> kernel like that, but since firmware is gone after we've booted the
> kernel, we run into the same problem when we power off a processor and
> when we resume from S3.  The firmware is not involved in these cases.
> In these cases the processors have an uninitialized virtual offset
> again.  These processors don't appear to magically come up in HYP
> mode.  Thus it would be up to the kernel to transition to HYP mode,
> init the offset, and get out of HYP mode.  ...or just use the physical
> counter.
>
>
> If you can suggest something that doesn't require us to involve the
> firmware in processor bringup and in resume, I'm all ears.  We have a
> desire not to involve the firmware there because of all the issues of
> keeping kernel/firmware in sync and because of the extra difficultly
> of shipping firmware updates (understandably the QA needed to validate
> a new firmware is much higher than the QA needed to validate a new
> kernel).

One thing that was used in the past was to have the kernel load a blob
from /lib/firmware/ which did some re-initialization when coming out
of suspend or deep sleep.  We could do something similar here and have
it either fix virtual offset or put it into hyp mode.  That would help
solve our issue of making it easier to update and avoid QA hassles.
Is such a solution acceptable to upstream?


>
>
> -Doug
