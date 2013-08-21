Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3HULsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab3HULsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:48:45 -0400
Date: Wed, 21 Aug 2013 13:42:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
Message-ID: <20130821114228.GA2220@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <20130820181500.GA22287@redhat.com> <20130821082801.GL3258@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821082801.GL3258@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Peter Zijlstra wrote:
>
> On Tue, Aug 20, 2013 at 08:15:00PM +0200, Oleg Nesterov wrote:
> > While at it.
> >
> > I do not also understand the cpu_online() checks in fs/proc/stat.c.
> >
> > OK, I agree, if cpu is offline it should not participate in cpu
> > summary. But if it goes offline, why it should switch from
> > ->iowait_sleeptime + cpustat[CPUTIME_IDLE] as it seen by /proc/stat?
> >
> > This can be another source of "idle goes backward", no?
> >
> > IOW. Ignoring the other problems we have, perhaps something like
> > below makes sense?
>
>
> Agreed, however

OK, good,

> > +++ x/kernel/time/tick-sched.c
> > @@ -477,7 +477,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
> >  		update_ts_time_stats(cpu, ts, now, last_update_time);
> >  		idle = ts->idle_sleeptime;
> >  	} else {
> > -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> > +		if (ts->idle_active && cpu_online(cpu) && !nr_iowait_cpu(cpu)) {
> >  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> >
> >  			idle = ktime_add(ts->idle_sleeptime, delta);
> > @@ -518,7 +518,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64
> >  		update_ts_time_stats(cpu, ts, now, last_update_time);
> >  		iowait = ts->iowait_sleeptime;
> >  	} else {
> > -		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> > +		if (ts->idle_active && cpu_online(cpu) && nr_iowait_cpu(cpu)) {
> >  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> >
> >  			iowait = ktime_add(ts->iowait_sleeptime, delta);
> >
>
> That's still mighty odd, but I guess that's in part due to the whacky
> semantics. We could simply transfer any open nr_iowait to the cpu
> doing the hotplug and then we have offline cpus that have nr_iowait == 0
> and the above becomes simpler again.

This won't help get_cpu_idle_time_us().

But anyway we should fix other problems first, then think about this
change. I just wanted to verify that I didn't miss something and this
iowait_sleeptime -> CPUTIME_IDLE switch is indeed wrong.

Oleg.

