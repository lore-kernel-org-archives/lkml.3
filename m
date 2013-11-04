Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3KDRe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:34:28 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56338 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:34:27 -0500
Date: Mon, 4 Nov 2013 18:34:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131104173421.GH9299@localhost.localdomain>
References: <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
 <20131020111006.GA26671@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131020111006.GA26671@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 01:10:06PM +0200, Andreas Mohr wrote:
> Hi,
> 
> 
> +u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> +{
> +	ktime_t iowait, delta = { .tv64 = 0 };
> +	struct rq *rq = cpu_rq(cpu);
> +	ktime_t now = ktime_get();
> +	unsigned int seq;
> +
> +	do {
> +		seq = read_seqbegin(&rq->iowait_lock);
> +		if (rq->nr_iowait)
> +			delta = ktime_sub(now, rq->iowait_start);
> +		iowait = ktime_add(rq->iowait_time, delta);
> +	} while (read_seqretry(&rq->iowait_lock, seq));
> 
> 
> AFAICS that's slightly buggy, in light of:
> 
> 
> +static void cpu_iowait_end(struct rq *rq)
> +{
> +	ktime_t delta;
> +	write_seqlock(&rq->iowait_lock);
> +	if (!--rq->nr_iowait) {
> +		delta = ktime_sub(ktime_get(), rq->iowait_start);
> +		rq->iowait_time = ktime_add(rq->iowait_time, delta);
> +	}
> +	write_sequnlock(&rq->iowait_lock);
> +}
> 
> get_cpu_iowait_time_us() loops until update is consistent,
> yet its "delta" will have been assigned previously
> (*and potentially not updated*),
> yet then a subsequent cpu_iowait_end() does provide a final consistent
> update (by updating that very iowait_time base value taking the current delta
> [destructively] into account!!)
> and the other get_cpu_iowait_time_us's delta value remained stale
> (iff nr_iowait now back to zero!).
> 
> IOW, newly updated iowait_time base value already (and re-evaluated),
> yet *old* delta still being added to this *new* base value.

Good point! We indeed want to properly update delta in get_cpu_iowait_time_us()
for each loop. I'll fix that.

> 
> 
> 
> Further thoughts:
> 
> Janitorial: cpu_iowait_end(): might be useful to move ktime_t delta
> into local scope.

Makes sense.

> 
> Would be nice to move inner handling of get_cpu_iowait_time_us()
> into an rq-focussed properly named helper function (to reflect the fact that
> while this is stored in rq it's merely being used to derive CPU-side status
> values from it), but it seems "ktime_t now" would then have to be
> grabbed multiple times, which would be a complication.

Right, we want to minimize the calls to ktime_get(). In fact I'll try to convert
that to local_clok()/cpu_clock(), which should be cheaper, as Peter suggested.
Lets hope that won't break the user ABI on /proc/stat.

> 
> In case of high update traffic of parts guarded by rq->iowait_lock
> (is that a relevant case?),
>
> it might be useful to merely grab all relevant values into helper vars
> (i.e., establish a consistent "view" on things), now, start, nr_iowait etc. -
> this would enable us to do ktime_sub(), ktime_add() calculations
> *once*, after the fact. Drawback would be that this reduces seqlock
> guard scope (would not be active any more during runtime spent for calculations,
> i.e. another update may happen during that calculation time),
> but then that function's purpose merely is to provide a *consistent
> one-time probe* of a continually updated value anyway, so it does not
> matter if we happen to return values of one update less
> than is already available.

I'm not sure I really understand what you mean here. But I don't think we can do the
iowait_start/iowait_time probe only once. The retry part is necessary to make
sure that we have coherent results against a given update sequence. Otherwise we
need to use pure exclusive locks, like spinlocks. If we find out that there are issues
wrt. readers starvations or livelocks, may be we'll do this but I believe that won't
be needed.


> 
> 
> Thank you very much for working on improving this important infrastructure code!

Thanks for your review!

I think I'm going to respin this series but move back the iowait time update part to
the idle code. The update made in io_schedule() doesn't work since we really need it
to account iowait time when the CPU is idle only: idle time accounting itself depend
on it, and the callers of get_...time_us() rely on that too. Plus doing the update
only when the CPU is idle will result in less overhead.

> 
> Andreas Mohr
