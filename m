Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaEHQEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:04:39 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:65113 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbaEHQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:04:37 -0400
Date: Thu, 8 May 2014 12:04:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Doug Anderson <dianders@chromium.org>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
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
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP
 systems
In-Reply-To: <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org> <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com> <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Doug Anderson wrote:

> 1. Initially CPU1 and CPU2 at 200MHz.  Pretend loops_per_jiffy is 1000.
> 
> 2. CPU1 starts a delay.  It reads global lpj (1000) and sets up its
> local registers up for the loop.
> 
> 3. At the same time, CPU2 is transitioning the system to 2000MHz.
> Right after CPU1 reads lpj CPU2 stores it as 10000.
> 
> 4. Now CPU1 and CPU2 are running at 2000MHz but CPU1 is only looping
> 1000 times.  It will complete too fast.
> 
> ...you could possibly try to account for this in the delay loop code
> (being careful to handle all of the corner cases and races).  ...or we
> could make the delay loop super conservative and suggest that people
> should be using a real timer.

I don't see how you can possibly solve this issue without a timer based 
delay.  Even if you scale the loop count in only one direction, it will 
still have this problem even though the window for the race would happen 
much less often.  Yet having a delay which is way longer than expected 
might cause problems in some cases.

Yet clock frequency changes with the kind of magnitude you give in your 
example are usually not instantaneous.  Given udelay should be used for 
very short delays, it is likely that CPU1 will complete its count before 
the higher clock frequency is effective in most cases.

> How exactly do you do this in a generic way?  I know that our systems
> don't always boot up at full speed.  The HP Chromebook 11 might boot
> up at 900MHz and stay that way for a while until the battery gets
> enough juice.  The Samsung Chromebook 2 will boot up at 1.8GHz
> although some of them can go to 1.9GHz and others to 2.0GHz.  Waiting
> to actually see the cpufreq transition is a safe way, though it does
> end up with some extra function calls.

The Samsung Chromebook uses an A15 which does use a timer based udelay.  
What about the others?  IOW is this a real problem in practice or a 
theoretical one?

SMP with shared clock for DVFS simply doesn't allow pure loop counts to 
always be accurate.  Trying to fix a broken implementation with 
something that is still broken to some extent, and maybe more in 
some cases, doesn't look like much progress to me.


Nicolas
