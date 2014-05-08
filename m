Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaEHQlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:41:04 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42995 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaEHQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
	<CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
	<CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
Date: Thu, 8 May 2014 09:41:00 -0700
X-Google-Sender-Auth: TOyaALJ0Q0frbUWf3ezGsFRHkYo
Message-ID: <CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On Thu, May 8, 2014 at 9:04 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 8 May 2014, Doug Anderson wrote:
>
>> 1. Initially CPU1 and CPU2 at 200MHz.  Pretend loops_per_jiffy is 1000.
>>
>> 2. CPU1 starts a delay.  It reads global lpj (1000) and sets up its
>> local registers up for the loop.
>>
>> 3. At the same time, CPU2 is transitioning the system to 2000MHz.
>> Right after CPU1 reads lpj CPU2 stores it as 10000.
>>
>> 4. Now CPU1 and CPU2 are running at 2000MHz but CPU1 is only looping
>> 1000 times.  It will complete too fast.
>>
>> ...you could possibly try to account for this in the delay loop code
>> (being careful to handle all of the corner cases and races).  ...or we
>> could make the delay loop super conservative and suggest that people
>> should be using a real timer.
>
> I don't see how you can possibly solve this issue without a timer based
> delay.  Even if you scale the loop count in only one direction, it will
> still have this problem even though the window for the race would happen
> much less often.  Yet having a delay which is way longer than expected
> might cause problems in some cases.

You could possibly try to do something excessively clever by checking
the loops per jiffy after the loop was done (and perhaps register for
cpufreq changes so you know if it changed and then changed back)?  As
I said, I don't think it's a good use of anyone's time.

Longer delays aren't very good, but IMHO having some delays of 100 =>
1000 is better than having delays of 100 => 75.  The former will cause
mostly performance problems and the later will cause real correctness
problems.

I'm not saying that 100 => 1000 is good, it's just less bad.
Specifically even in a timer-based system you can't guarantee that a
udelay(100) won't end up a udelay(1000) if the kernel finds something
better to do than to run your code.  I agree that there might be code
that breaks when a udelay(100) becomes a udelay(1000), but probably
that code needs to be fixed to be more tolerant anyway.

When you've got a udelay(100) => udelay(75) then suddenly you're
returning from regulator code before the regulator has fully ramped up
to its final voltage.  You're talking to peripherals faster than they
were intended to be talked to.  ...etc.


> Yet clock frequency changes with the kind of magnitude you give in your
> example are usually not instantaneous.  Given udelay should be used for
> very short delays, it is likely that CPU1 will complete its count before
> the higher clock frequency is effective in most cases.

In practice we found that the frequency changed fast enough in a real
system that we were seeing real problems, at least with a udelay(50).
If you've got a system using lpj-based udelay() that supports cpufreq,
grab David's test patches and try for yourself.  Perhaps I was
mistaken?


>> How exactly do you do this in a generic way?  I know that our systems
>> don't always boot up at full speed.  The HP Chromebook 11 might boot
>> up at 900MHz and stay that way for a while until the battery gets
>> enough juice.  The Samsung Chromebook 2 will boot up at 1.8GHz
>> although some of them can go to 1.9GHz and others to 2.0GHz.  Waiting
>> to actually see the cpufreq transition is a safe way, though it does
>> end up with some extra function calls.
>
> The Samsung Chromebook uses an A15 which does use a timer based udelay.
> What about the others?  IOW is this a real problem in practice or a
> theoretical one?

Correct, the Samsung Chromebook uses a timer-based udelay upstream (it
still doesn't in our tree BTW, but we're working to rectify that).
...that's why I didn't send the patch up initially.  I sent it up at
the request of John Stultz in a discussion about David's test code.


> SMP with shared clock for DVFS simply doesn't allow pure loop counts to
> always be accurate.  Trying to fix a broken implementation with
> something that is still broken to some extent, and maybe more in
> some cases, doesn't look like much progress to me.

I totally agree that this doesn't really fix the problem nicely which
is why I didn't send it initially.

I will make the argument that this patch makes things less broken
overall on any systems that actually end up running this code, but if
you want NAK it then it won't cause me any heartache.  ;)

-Doug
