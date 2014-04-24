Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaDXAQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:16:48 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50271 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaDXAQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:16:46 -0400
Date: Thu, 24 Apr 2014 02:16:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] nohz: Synchronize sleep time stats with memory
 barriers
Message-ID: <20140424001640.GA27571@localhost.localdomain>
References: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com>
 <1398279636-21503-2-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398279636-21503-2-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:00:35PM +0200, Denys Vlasenko wrote:
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
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/time/tick-sched.c | 83 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 66 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 73ced0c4..a99770e 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -409,10 +409,15 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
>  
>  	/* Updates the per cpu time idle statistics counters */
>  	delta = ktime_sub(now, ts->idle_entrytime);
> -	if (nr_iowait_cpu(smp_processor_id()) > 0)
> +	ts->idle_entrytime.tv64 = 0;
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
> -	ts->idle_active = 1;
> +	smp_wmb();
> +	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
>  	sched_clock_idle_sleep_event();
>  	return now;
>  }
> @@ -444,25 +450,46 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
>   */
>  u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>  {
> -	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> -	ktime_t now, idle;
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
> -	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> -		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> -		idle = ktime_add(ts->idle_sleeptime, delta);
> + again:
> +	active = ACCESS_ONCE(ts->idle_active);
> +	smp_rmb();
> +	count = ACCESS_ONCE(ts->idle_sleeptime);
> +	if (active == 1) {
> +		ktime_t delta, start;
> +
> +		smp_rmb();
> +		start = ACCESS_ONCE(ts->idle_entrytime);
> +		if (start.tv64 == 0) {
> +			/*
> +			 * Other CPU is updating the count.
> +			 * We don't know whether fetched count is valid.
> +			 */
> +			goto again;
> +		}
> +		delta = ktime_sub(now, start);
> +		count = ktime_add(count, delta);

There is still a possibility that you race with an updater here.
Lets take these initial values, all of which belong to ts(CPU 1):

      // idle_sleeptime == 0
      // idle_entrytime == 0
      // ktime_get() == 100
      // idle_active = 1

           CPU 0                                       CPU 1

      count = idle_sleeptime // = 0               
                                                     tick_nohz_stop_idle();
                                                     tick_nohz_start_idle();
                                                     /* now idle_sleeptime == 100
                                                        and idle_entrytime == 100
                                                        ktime_get() is still 100
                                                        and idle_active is still 1
                                                        as it has toggled two times */
      delta = now - idle_entrytime; // 100 - 100
      count += delta // == 0

Then you get the spurious 0 result.

So memory barriers probably aren't enough here. seqcount would solve the issue as it maintains
update seq tokens.
