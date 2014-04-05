Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaDEIBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 04:01:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaDEIBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 04:01:51 -0400
Date: Sat, 5 Apr 2014 10:01:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Lei Wen <leiwen@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] printk: using booting time as the timestamp
Message-ID: <20140405080119.GA11096@twins.programming.kicks-ass.net>
References: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
 <1396581522-3309-4-git-send-email-leiwen@marvell.com>
 <533F2A57.1060808@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533F2A57.1060808@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 02:55:35PM -0700, John Stultz wrote:
> On 04/03/2014 08:18 PM, Lei Wen wrote:
> > As people may want to align the kernel log with some other processor
> > running over the same machine but not the same copy of linux, we
> > need to keep their log aligned, so that it would not make debug
> > process hard and confused.
> >
> > Signed-off-by: Lei Wen <leiwen@marvell.com>
> > ---
> >  kernel/printk/printk.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index a45b509..af96fbd 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -349,7 +349,7 @@ static void log_store(int facility, int level,
> >  	if (ts_nsec > 0)
> >  		msg->ts_nsec = ts_nsec;
> >  	else
> > -		msg->ts_nsec = local_clock();
> > +		msg->ts_nsec = ktime_to_ns(ktime_get_boottime());
> 
> No no... Since ktime_get_boottime() takes the timekeeping seqlock, this
> will cause any printk (or WARN_ON, etc) that is done while holding a
> write in the timekeeping seqlock to deadlock (which I mentioned last time).
> 
> I think the better solution here is to have the timekeeping code provide
> the printk logic the offset value whenever the sleep time is updated.
> That way the printk logic can manage its own values w/o having to take
> any timekeeping locks.
> 
> That said, I'm still not really fond of trying to add this
> functionality. The printk timestamping code was always a little fuzzy,
> using jiffies or sched_clock in order to give a rough estimate of boot
> delays (and didn't include ntp freq correction, etc). When it was
> introduced, I feel like folks were concerned about this, but folks
> agreed the rough estimates were worth it, and it didn't have to involve
> the real timekeeping code.  Now, trying to raise the bar here to make
> printk timestamps actually correlate with
> CLOCK_BOOTTIME/REALTIME/MONOTONIC (which I'll admit, seems quite
> reasonable given we have timestamps already - but ends up being feature
> creep) will add quite a bit of complexity due to the fact that printk is
> supposed to be safe to call from everywhere.
> 
> And again, syslog can add timestamps to the kernel messages relatively
> well in userland. So I'm not sure the need is clear.

Not to mention that ktime_get*() is stupid slow for some.
