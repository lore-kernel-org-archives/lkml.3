Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaK0LVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:21:36 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41903 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaK0LVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:18 -0500
Message-ID: <54770925.1000608@gmail.com>
Date: Thu, 27 Nov 2014 19:21:09 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
CC: linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
On 5/14/14, 11:08 PM, Paul Gortmaker wrote:
> As of the old commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
> ("sched: rt-group: smp balancing") the concept of borrowing per
> cpu rt_runtime from one core to another was introduced.
>
> However, this prevents the RT throttling message from ever being
> emitted when someone does a common (but mistaken) attempt at
> using too much CPU in RT context.  Consider the following test:
>
>    echo "main() {for(;;);}" > full_load.c
>    gcc full_load.c -o full_load
>    taskset -c 1 ./full_load &
>    chrt -r -p 80 `pidof full_load`

I try this on 3.18-rc6 w/ CONFIG_RCU_CPU_STALL_TIMEOUT=60 and 
SCHED_FEAT(RT_RUNTIME_SHARE, true), however I don't see rcu stall 
warning, where I miss?

Regards,
Wanpeng Li

> When run on x86_64 defconfig, what happens is as follows:
>
> -task runs on core1 for 95% of an rt_period as documented in
>   the file Documentation/scheduler/sched-rt-group.txt
>
> -at 95%, the code in balance_runtime sees this threshold and
>   calls do_balance_runtime()
>
> -do_balance_runtime sees that core 1 is in need, and does this:
> 	---------------
>          if (rt_rq->rt_runtime + diff > rt_period)
>                  diff = rt_period - rt_rq->rt_runtime;
>          iter->rt_runtime -= diff;
>          rt_rq->rt_runtime += diff;
> 	---------------
>   which extends core1's rt_runtime by 5%, making it 100% of rt_period
>   by stealing 5% from core0 (or possibly some other core).
>
> However, the next time core1's rt_rq enters sched_rt_runtime_exceeded(),
> we hit this near the top of that function:
> 	---------------
>          if (runtime >= sched_rt_period(rt_rq))
>                  return 0;
> 	---------------
> and hence we'll _never_ look at/set any of the throttling checks and
> messages in sched_rt_runtime_exceeded().  Instead, we will happily
> plod along for CONFIG_RCU_CPU_STALL_TIMEOUT seconds, at which point
> the RCU subsystem will get angry and trigger an NMI in response to
> what it rightly sees as a WTF situation.
>
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
>   and tglx asked why they wouldn't see the throttle message; it is only
>   now that I had a chance to dig in and figure out why.  Oh, and the patch
>   is against linux-next, in case that matters...]
>
>   kernel/sched/rt.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index ea4d500..698aac9 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -774,6 +774,15 @@ static int balance_runtime(struct rt_rq *rt_rq)
>   	if (!sched_feat(RT_RUNTIME_SHARE))
>   		return more;
>   
> +	/*
> +	 * Stealing from another core won't help us at all if
> +	 * we have nothing to migrate over there, or only one
> +	 * task that is running up all the rt_time.  In fact it
> +	 * will just inhibit the throttling message in that case.
> +	 */
> +	if (!rt_rq->rt_nr_migratory || rt_rq->rt_nr_total == 1)
> +		return more;
> +
>   	if (rt_rq->rt_time > rt_rq->rt_runtime) {
>   		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>   		more = do_balance_runtime(rt_rq);

