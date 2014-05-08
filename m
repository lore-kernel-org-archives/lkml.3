Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaEHPZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:25:36 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63394 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaEHPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:25:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
	<CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
Date: Thu, 8 May 2014 08:25:34 -0700
X-Google-Sender-Auth: -4ZStjrc6zmWYpJqnDubFqGviP0
Message-ID: <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
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

Viresh,

On Thu, May 8, 2014 at 3:41 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Fixing Rafael's id.
>
> On Thu, May 8, 2014 at 4:53 AM, Doug Anderson <dianders@chromium.org> wrote:
>> Downscaling loops_per_jiffy on SMP ARM systems really doesn't work.
>> You could really only do this if:
>>
>> * Each CPU is has independent frequency changes (changing one CPU
>>   doesn't affect another).
>> * We change the generic ARM udelay() code to actually look at percpu
>>   loops_per_jiffy.
>
> There is one more case I believe:
> All CPUs share a single clock line and generic udelay() uses global
> loops_per_jiffy, as it would never happen that some other CPU is running
> faster and udelay would complete early

I'm not sure I understood your case.  Maybe you can give me an
example?  I can give you an example myself of the single clock case
and you can tell me how your example differs:

1. Initially CPU1 and CPU2 at 200MHz.  Pretend loops_per_jiffy is 1000.

2. CPU1 starts a delay.  It reads global lpj (1000) and sets up its
local registers up for the loop.

3. At the same time, CPU2 is transitioning the system to 2000MHz.
Right after CPU1 reads lpj CPU2 stores it as 10000.

4. Now CPU1 and CPU2 are running at 2000MHz but CPU1 is only looping
1000 times.  It will complete too fast.

...you could possibly try to account for this in the delay loop code
(being careful to handle all of the corner cases and races).  ...or we
could make the delay loop super conservative and suggest that people
should be using a real timer.


> So, the end of this will happen when a CPU is set to its highest frequency
> for the first time. After that this routine will simply be noise and nothing
> more. Isn't it?

Yup.


> And if that's the case, why don't we get rid of it completely and set
> global-loop-per-jiffy for the max freq at boot ?

How exactly do you do this in a generic way?  I know that our systems
don't always boot up at full speed.  The HP Chromebook 11 might boot
up at 900MHz and stay that way for a while until the battery gets
enough juice.  The Samsung Chromebook 2 will boot up at 1.8GHz
although some of them can go to 1.9GHz and others to 2.0GHz.  Waiting
to actually see the cpufreq transition is a safe way, though it does
end up with some extra function calls.

-Doug
