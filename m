Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaDOKv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:51:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaDOKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:51:56 -0400
Date: Tue, 15 Apr 2014 12:51:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] nohz: Synchronize sleep time stats with memory
 barriers
Message-ID: <20140415105138.GO11096@twins.programming.kicks-ass.net>
References: <1396469872-14877-1-git-send-email-dvlasenk@redhat.com>
 <1396469872-14877-2-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396469872-14877-2-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:17:52PM +0200, Denys Vlasenko wrote:
> When some call site uses get_cpu_*_time_us() to read a sleeptime
> stat, it deduces the total sleeptime by adding the pending time
> to the last sleeptime snapshot if the CPU target is idle.
> 
> But this only works if idle_sleeptime, idle_entrytime and idle_active are
> read and updated under some disciplined order.
> 
> This patch changes updaters to modify idle_entrytime,
> {idle,iowait}_sleeptime, and idle_active exactly in this order,
> with write barriers on SMP to ensure other CPUs see then in this order too.
> Readers are changed read them in the opposite order, with read barriers.
> When readers detect a race by seeing cleared idle_entrytime,
> they retry the reads.
> 
> The "iowait-ness" of every idle period is decided at the moment it starts:
> if this CPU's run-queue had tasks waiting on I/O, then this idle
> period's duration will be added to iowait_sleeptime.
> This, along with proper SMP syncronization, fixes the bug where iowait
> counts could go backwards.

It also makes for a near infinite source of iowait. Who is to say the
CPU that started with iowait will ever wake up? The nohz sleep time is
practically unbounded.

> ---
>  kernel/time/tick-sched.c | 79 +++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 73ced0c4..ed0c1bd 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -409,10 +409,15 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
>  
>  	/* Updates the per cpu time idle statistics counters */
>  	delta = ktime_sub(now, ts->idle_entrytime);
> +	ts->idle_entrytime.tv64 = 0;

One must at all times describe the memory ordering and pairing barrier
in a comment when placing barriers.

> +	smp_wmb();
> +
> +	if (ts->idle_active == 2)
>  		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
>  	else
>  		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> +
> +	smp_wmb();
>  	ts->idle_active = 0;
>  
>  	sched_clock_idle_wakeup_event(0);
> @@ -423,7 +428,8 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
>  	ktime_t now = ktime_get();
>  
>  	ts->idle_entrytime = now;
> +	smp_wmb();
> +	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
>  	sched_clock_idle_sleep_event();
>  	return now;
>  }
> @@ -444,25 +450,44 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
>   */
>  u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>  {
> +	struct tick_sched *ts;
> +	ktime_t now, count;
> +	int active;
>  
>  	if (!tick_nohz_active)
>  		return -1;
>  
> +	ts = &per_cpu(tick_cpu_sched, cpu);
> +
>  	now = ktime_get();
>  	if (last_update_time)
>  		*last_update_time = ktime_to_us(now);
>  
> + again:
> +	active = ACCESS_ONCE(ts->idle_active);
> +	smp_rmb();
> +	count = ACCESS_ONCE(ts->idle_sleeptime);
> +	if (active == 1) {
> +		ktime_t delta, start;
> +
> +		smp_rmb();
> +		start = ACCESS_ONCE(ts->idle_entrytime);
> +		if (start.tv64 == 0)
> +			/* Other CPU is updating the count.
> +			 * We don't know whether fetched count is valid.
> +			 */
> +			goto again;

This is double wrong; any multi line stmt (even if its a single stmt)
should have {}. Also, wrong multi line comment style.

> +
> +		delta = ktime_sub(now, start);
> +		count = ktime_add(count, delta);
>  	} else {
> +		/* Possible concurrent tick_nohz_stop_idle() already
> +		 * cleared idle_active. We fetched count *after*
> +		 * we fetched idle_active, so count must be valid.
> +		 */

Wrong comment style again.

>  	}
>  
> +	return ktime_to_us(count);
>  }
>  EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
>  
> @@ -482,24 +507,44 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
>   */
>  u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>  {
> +	struct tick_sched *ts;
> +	ktime_t now, count;
> +	int active;
>  
>  	if (!tick_nohz_active)
>  		return -1;
>  
> +	ts = &per_cpu(tick_cpu_sched, cpu);
> +
>  	now = ktime_get();
>  	if (last_update_time)
>  		*last_update_time = ktime_to_us(now);
>  
> + again:
> +	active = ACCESS_ONCE(ts->idle_active);
> +	smp_rmb();
> +	count = ACCESS_ONCE(ts->iowait_sleeptime);
> +	if (active == 2) {
> +		ktime_t delta, start;
> +
> +		smp_rmb();
> +		start = ACCESS_ONCE(ts->idle_entrytime);
> +		if (start.tv64 == 0)
> +			/* Other CPU is updating the count.
> +			 * We don't know whether fetched count is valid.
> +			 */
> +			goto again;
> +
> +		delta = ktime_sub(now, start);
> +		count = ktime_add(count, delta);
>  	} else {
> +		/* Possible concurrent tick_nohz_stop_idle() already
> +		 * cleared idle_active. We fetched count *after*
> +		 * we fetched idle_active, so count must be valid.
> +		 */
>  	}

You're not nearly lazy enough; this is a near identical copy of the
above, two nearly identical copies of 'tricky' code is a bad idea.

>  
> +	return ktime_to_us(count);
>  }
>  EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);


So the proposed ordering is something like:

 [w] ->idle_entrytime = 0
     WMB /* k0 <-> r1 */
 [w] ->*_sleeptime += delta
     WMB /* k1 <-> r0 */
 [w] ->idle_active = 0

VS

 [w] ->idle_entrytime = now
     WMB /* s0 <-> r0 */
 [w] ->idle_active = 1 + !!nr_iowait

VS

 [r] active = ->idle_active
     RMB /* r0 <-> s0, k1 */
 [r] count = ->idle_sleeptime
     RMB /* r1 <-> k0 */
 [r] start = ->idle_entrytime


Which on first reading seems sound enough; but needs more words to
describe why.

That said; I thing the fundamental flaw in the entire thing is
accounting the entire nohz idle period as one type, since the period is
basically unbounded.
