Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaENPpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:45:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35495 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaENPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:45:04 -0400
Date: Wed, 14 May 2014 08:44:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140514154459.GE4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051415-1542-0000-0000-000001CC6804
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:08:35AM -0400, Paul Gortmaker wrote:
> As of the old commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
> ("sched: rt-group: smp balancing") the concept of borrowing per
> cpu rt_runtime from one core to another was introduced.
> 
> However, this prevents the RT throttling message from ever being
> emitted when someone does a common (but mistaken) attempt at
> using too much CPU in RT context.  Consider the following test:
> 
>   echo "main() {for(;;);}" > full_load.c
>   gcc full_load.c -o full_load
>   taskset -c 1 ./full_load &
>   chrt -r -p 80 `pidof full_load`
> 
> When run on x86_64 defconfig, what happens is as follows:
> 
> -task runs on core1 for 95% of an rt_period as documented in
>  the file Documentation/scheduler/sched-rt-group.txt
> 
> -at 95%, the code in balance_runtime sees this threshold and
>  calls do_balance_runtime()
> 
> -do_balance_runtime sees that core 1 is in need, and does this:
> 	---------------
>         if (rt_rq->rt_runtime + diff > rt_period)
>                 diff = rt_period - rt_rq->rt_runtime;
>         iter->rt_runtime -= diff;
>         rt_rq->rt_runtime += diff;
> 	---------------
>  which extends core1's rt_runtime by 5%, making it 100% of rt_period
>  by stealing 5% from core0 (or possibly some other core).
> 
> However, the next time core1's rt_rq enters sched_rt_runtime_exceeded(),
> we hit this near the top of that function:
> 	---------------
>         if (runtime >= sched_rt_period(rt_rq))
>                 return 0;
> 	---------------
> and hence we'll _never_ look at/set any of the throttling checks and
> messages in sched_rt_runtime_exceeded().  Instead, we will happily
> plod along for CONFIG_RCU_CPU_STALL_TIMEOUT seconds, at which point
> the RCU subsystem will get angry and trigger an NMI in response to
> what it rightly sees as a WTF situation.

In theory, one way of making RCU OK with an RT usermode CPU hog is to
build with Frederic's CONFIG_NO_HZ_FULL=y.  This will cause RCU to see
CPUs having a single runnable usermode task as idle, preventing the RCU
CPU stall warning.  This does work well for mainline kernel in the lab.

In practice, not sure how much testing CONFIG_NO_HZ_FULL=y has received
for -rt kernels in production environments.

But leaving practice aside for the moment...

> Granted, there are lots of ways you can do bad things to yourself with
> RT, but in the current zeitgeist of multicore systems with people
> dedicating individual cores to individual tasks, I'd say the above is
> common enough that we should react to it sensibly, and an RCU stall
> really doesn't translate well to an end user vs a simple message that
> says "throttling activated".
> 
> One way to get the throttle message instead of the ambiguous and lengthy
> NMI triggered all core backtrace of the RCU stall is to change the
> SCHED_FEAT(RT_RUNTIME_SHARE, true) to false.  One could make a good
> case for this being the default for the out-of-tree preempt-rt series,
> since folks using that are more apt to be manually tuning the system
> and won't want an invisible hand coming in and making changes.
> 
> However, in mainline, where it is more likely that there will be
> n+x (x>0) RT tasks on an n core system, we can leave the sharing on,
> and still avoid the RCU stalls by noting that there is no point in
> trying to balance when there are no tasks to migrate, or only a
> single RT task is present.  Inflating the rt_runtime does nothing
> in this case other than defeat sched_rt_runtime_exceeded().
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [I'd mentioned a similar use case here: https://lkml.org/lkml/2013/3/6/338
>  and tglx asked why they wouldn't see the throttle message; it is only
>  now that I had a chance to dig in and figure out why.  Oh, and the patch
>  is against linux-next, in case that matters...]
> 
>  kernel/sched/rt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index ea4d500..698aac9 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -774,6 +774,15 @@ static int balance_runtime(struct rt_rq *rt_rq)
>  	if (!sched_feat(RT_RUNTIME_SHARE))
>  		return more;
> 
> +	/*
> +	 * Stealing from another core won't help us at all if
> +	 * we have nothing to migrate over there, or only one
> +	 * task that is running up all the rt_time.  In fact it
> +	 * will just inhibit the throttling message in that case.
> +	 */
> +	if (!rt_rq->rt_nr_migratory || rt_rq->rt_nr_total == 1)

How about something like the following to take NO_HZ_FULL into account?

+	if ((!rt_rq->rt_nr_migratory || rt_rq->rt_nr_total == 1) &&
+	    !tick_nohz_full_cpu(cpu))

							Thanx, Paul

> +		return more;
> +
>  	if (rt_rq->rt_time > rt_rq->rt_runtime) {
>  		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>  		more = do_balance_runtime(rt_rq);
> -- 
> 1.8.2.3
> 

