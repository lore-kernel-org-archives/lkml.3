Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaEHT7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:59:45 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54244 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaEHT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:59:43 -0400
Date: Thu, 8 May 2014 15:59:40 -0400 (EDT)
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
In-Reply-To: <CAD=FV=X4h0nfO7a10NXe+d76xj5ttBJx=q1pAvW4aPzrc22BoQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405081540460.980@knanqh.ubzr>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org> <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com> <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com> <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
 <CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com> <alpine.LFD.2.11.1405081329010.980@knanqh.ubzr> <CAD=FV=X4h0nfO7a10NXe+d76xj5ttBJx=q1pAvW4aPzrc22BoQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Doug Anderson wrote:

> Nicolas,
> 
> On Thu, May 8, 2014 at 10:43 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Thu, 8 May 2014, Doug Anderson wrote:
> 
> >> Longer delays aren't very good, but IMHO having some delays of 100 =>
> >> 1000 is better than having delays of 100 => 75.  The former will cause
> >> mostly performance problems and the later will cause real correctness
> >> problems.
> >> I'm not saying that 100 => 1000 is good, it's just less bad.
> >
> > There might be some cases where precise timing is needed though.
> > I thought I came across one such case in the past but I can't remember
> > which.
> 
> If precise timing is needed, shouldn't it be using ktime?

I meant "precise" in the sense that you might have to poke at some 
hardware within some deadline e.g. set bit, wait 13us, clear bit, and 
not exceed 15us between both bit events.  Arguably this is best hangled 
with actual FIQs (when they're available).  But I don't have any actual 
case of this to bring as example.

> >> I will make the argument that this patch makes things less broken
> >> overall on any systems that actually end up running this code, but if
> >> you want NAK it then it won't cause me any heartache.  ;)
> >
> > What I insist on is for this issue to be solved using a stable counter
> > such a timer when available.  It _is_ available on one of the target you
> > mentioned so that is the solution you should add to your tree.
> 
> Yup, we're working on it.
> 
> 
> > Investigating a similar solution for your other target should be
> > preferred to hacking the udelay loop. This way you're guaranteed to
> > solve this problem fully.
> 
> I have no other target in mind.  I'm merely sending this up there just
> in case there is some cpufreq running ARM board that is SMP and has no
> timer-based udelay.  Those are the only boards that could possibly be
> running this code anyway.
> 
> I guess I would say that my patch is unhacking the this code.  The
> code after my patch is simpler.  I would perhaps argue that (ec971ea
> ARM: add cpufreq transiton notifier to adjust loops_per_jiffy for smp)
> should never have landed to begin with.

I would agree to qualify your patch as brokenness mitigation and that 
might be better than nothing.  But this should probably print a warning 
to that effect.

Yet, wouldn't using ktime to implement udelay() a better solution in 
that case?  Suffice to make sure a clock source with microsecs 
resolution is available.


Nicolas
