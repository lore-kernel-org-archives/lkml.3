Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3JSQCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:02:42 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60234 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3JSQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:02:41 -0400
Date: Sat, 19 Oct 2013 18:02:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131019160235.GA13534@localhost.localdomain>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
 <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
 <20131019153535.GA2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019153535.GA2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 05:35:35PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 19, 2013 at 05:17:20PM +0200, Frederic Weisbecker wrote:
> > +u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> > +{
> > +	ktime_t iowait, delta = { .tv64 = 0 };
> > +	struct rq *rq = cpu_rq(cpu);
> > +	ktime_t now = ktime_get();
> > +	unsigned int seq;
> > +
> > +	do {
> > +		seq = read_seqbegin(&rq->iowait_lock);
> > +		if (rq->nr_iowait)
> > +			delta = ktime_sub(now, rq->iowait_start);
> > +		iowait = ktime_add(rq->iowait_time, delta);
> > +	} while (read_seqretry(&rq->iowait_lock, seq));
> > +
> > +	if (last_update_time)
> > +		*last_update_time = ktime_to_us(now);
> > +
> > +	return ktime_to_us(iowait);
> > +}
> > +EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
> > +
> > +static void cpu_iowait_start(struct rq *rq)
> > +{
> > +	write_seqlock(&rq->iowait_lock);
> > +	if (!rq->nr_iowait++)
> > +		rq->iowait_start = ktime_get();
> > +	write_sequnlock(&rq->iowait_lock);
> > +}
> > +
> > +static void cpu_iowait_end(struct rq *rq)
> > +{
> > +	ktime_t delta;
> > +	write_seqlock(&rq->iowait_lock);
> > +	if (!--rq->nr_iowait) {
> > +		delta = ktime_sub(ktime_get(), rq->iowait_start);
> > +		rq->iowait_time = ktime_add(rq->iowait_time, delta);
> > +	}
> > +	write_sequnlock(&rq->iowait_lock);
> > +}
> 
> Yeah, so using ktime_get() for this is completely insane ;-)

Woops, yeah I clearly overlooked that while moving the code :)
local_clock() should be fine.

> 
> I just had a look at delayacct; wth wrote that crap; that too uses
> gtod.

I can't find where it does that. kernel/delayacct.c doesn't seem to at least.
