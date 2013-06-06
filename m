Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3FFBn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:43:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37534 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3FFBn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:43:26 -0400
Date: Wed, 5 Jun 2013 18:43:25 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCHv3 1/3] sched_clock: Add support for >32 bit sched_clock
Message-ID: <20130606014325.GP599@codeaurora.org>
References: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
 <1370476485-468-2-git-send-email-sboyd@codeaurora.org>
 <51AFDA20.8070501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AFDA20.8070501@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, John Stultz wrote:
> On 06/05/2013 04:54 PM, Stephen Boyd wrote:
> >
> >I've noticed that we probably need to update the mult/shift
> >calculation similar to how clocksources are done. Should we
> >just copy/paste the maxsec calculation code here or do something
> >smarter?
> 
> So, the clocksource calculation has an extra variable it has to
> balance, which is the granularity of ntp adjustments being made
> (since with higher shift values, we can make relatively smaller
> changes by +1 or -1 from mult).
> 
> sched_clock doesn't have to deal with frequency adjustments, so the
> shift value just needs to be high enough to be able to accurately
> express the desired counter frequency.  Too high and you risk
> multiplication overflows if there are large gaps between updates,
> too low though and you run into possible accuracy issues (though I
> hope there isn't much that's using sched_clock for long-term timing
> where slight accuracy issues would be problematic).
> 
> So I think its ok if the sched_clock code uses its own logic for
> calculating the mult/shift pair, since the constraints are different
> then what we expect from timekeeping.
> 

I was thinking perhaps we can do the (1 << bits) / rate thing but
not limit it to 600 seconds. Instead let it be as big as it
actually is? Right now it's actually better to register as a 32
bit clock because the wraparound comes out to be larger when
maxsec is 0.

> 
> >
> >  include/linux/sched_clock.h |  1 +
> >  kernel/time/sched_clock.c   | 41 +++++++++++++++++++++++++++--------------
> >  2 files changed, 28 insertions(+), 14 deletions(-)
> >
> >diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
> >index fa7922c..81baaef 100644
> >--- a/include/linux/sched_clock.h
> >+++ b/include/linux/sched_clock.h
> >@@ -15,6 +15,7 @@ static inline void sched_clock_postinit(void) { }
> >  #endif
> >  extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
> >+extern void sched_clock_setup(u64 (*read)(void), int bits, unsigned long rate);
> 
> Eww. This sort of word-swizzled function names makes patch reviewing a pain.

How about sched_clock_register() or register_sched_clock()?

> 
> I know you're trying to deprecate the old function and provide a
> smooth transition, but would you also consider including follow-on
> patch/patches with this set that converts the existing
> setup_sched_clock usage (at least just the ones in
> drivers/clocksource?) so it doesn't stick around forever?
> 
> And if not, at least add a clear comment here, and maybe some build
> warnings to the old function so the driver owners know to make the
> conversion happen quickly.

Yes I plan to send out the conversion patches and deprecate the
function if this is acceptable. Then we can remove the function
after the merge window is over and all stragglers are converted.

> 
> 
> 
> >  extern unsigned long long (*sched_clock_func)(void);
> >diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> >index aad1ae6..3478b6d 100644
> >--- a/kernel/time/sched_clock.c
> >+++ b/kernel/time/sched_clock.c
> >@@ -35,24 +36,31 @@ static struct clock_data cd = {
> >  	.mult	= NSEC_PER_SEC / HZ,
> >  };
> >-static u32 __read_mostly sched_clock_mask = 0xffffffff;
> >+static u64 __read_mostly sched_clock_mask;
> >-static u32 notrace jiffy_sched_clock_read(void)
> >+static u64 notrace jiffy_sched_clock_read(void)
> >  {
> >-	return (u32)(jiffies - INITIAL_JIFFIES);
> >+	return (u64)(jiffies - INITIAL_JIFFIES);
> >  }
> 
> Also, you might add a comment noting you register jiffies w/
> BITS_PER_LONG, to clarify don't have to use jiffies_64 here on 32bit
> systems (despite the u64 cast)?

Sure. Perhaps it is clearer if we don't have the u64 cast here at
all?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
