Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaEVTlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:41:03 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60498 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVTlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:41:00 -0400
Message-ID: <537E529F.6070409@windriver.com>
Date: Thu, 22 May 2014 15:40:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it
 is futile
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com> <20140519124052.GA30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140519124052.GA30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-19 08:40 AM, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 11:08:35AM -0400, Paul Gortmaker wrote:
>> As of the old commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
>> ("sched: rt-group: smp balancing") the concept of borrowing per
>> cpu rt_runtime from one core to another was introduced.
>>
>> However, this prevents the RT throttling message from ever being
>> emitted when someone does a common (but mistaken) attempt at
>> using too much CPU in RT context.  Consider the following test:
> 
> 
> So the alternative approach is something like the below, where we will
> not let it borrow more than the global bandwidth per cpu.
> 
> This whole sharing thing is completely fail anyway, but I really
> wouldn't know what else to do and keep allowing RT tasks to set random
> cpu affinities.

So, for the record, this does seem to work, in the sense that the
original test of:

  echo "main() {for(;;);}" > full_load.c
  gcc full_load.c -o full_load
  taskset -c 1 ./full_load &
  chrt -r -p 80 `pidof full_load`

will emit the sched delayed throttling message instead of the less
informative (and 20s delayed) RCU stall.  Which IMHO is a win in
terms of being more friendly to the less informed users out there.

I'd re-tested it on today's linux-next tree, with RT_GROUP_SCHED off.

The downside is that we get another tuning knob that will inevitably
end up in /proc/sys/kernel/ and we'll need to explain somewhere how
the new max_runtime relates to the existing rt_runtime and rt_period.

I'm still unsure what the best solution for mainline is.  Clearly
just defaulting the sched feat to false is the simplest, and given
your description of it as "fail" perhaps that does makes sense.  :)

Paul.
--

> 
> 
> ---
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7386,10 +7386,59 @@ static int __rt_schedulable(struct task_
>  	return ret;
>  }
>  
> +/*
> + * ret := (a * b) / d
> + */
> +static u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 d)
> +{
> +	/*
> +	 * Compute the 128bit product:
> +	 *   a * b ->
> +	 *     [ a = (ah * 2^32 + al),  b = (bh * 2^32 + bl) ]
> +	 *   -> (ah * bh) * 2^64 + (ah * bl + al * bh) * 2^32 + al * bl
> +	 */
> +	u32 ah = (a >> 32);
> +	u32 bh = (b >> 32);
> +	u32 al = a;
> +	u32 bl = b;
> +
> +	u64 mh, mm, ml;
> +
> +	mh = (u64)ah * bh;
> +	mm = (u64)ah * bl + (u64)al * bh;
> +	ml = (u64)al * bl;
> +
> +	mh += mm >> 32;
> +	mm <<= 32;
> +
> +	ml += mm;
> +	if (ml < mm) /* overflow */
> +		mh++;
> +
> +	/*
> +	 * Reduce the 128bit result to fit in a 64bit dividend:
> +	 *   m / d -> (m / 2^n) / (d / 2^n)
> +	 */
> +	while (mh) {
> +		ml >>= 1;
> +		if (mh & 1)
> +			ml |= 1ULL << 63;
> +		mh >>= 1;
> +		d >>= 1;
> +	}
> +
> +	if (unlikely(!d))
> +		return ml;
> +
> +	return div64_u64(ml, d);
> +}
> +
>  static int tg_set_rt_bandwidth(struct task_group *tg,
>  		u64 rt_period, u64 rt_runtime)
>  {
>  	int i, err = 0;
> +	u64 g_period = global_rt_period();
> +	u64 g_runtime = global_rt_runtime();
>  
>  	mutex_lock(&rt_constraints_mutex);
>  	read_lock(&tasklist_lock);
> @@ -7400,6 +7449,9 @@ static int tg_set_rt_bandwidth(struct ta
>  	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
>  	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
>  	tg->rt_bandwidth.rt_runtime = rt_runtime;
> +	tg->rt_bandwidth.rt_max_runtime = (g_runtime == RUNTIME_INF) ?
> +		rt_period :
> +		mul_u64_u64_div_u64(rt_period, g_runtime, g_period);
>  
>  	for_each_possible_cpu(i) {
>  		struct rt_rq *rt_rq = tg->rt_rq[i];
> @@ -7577,6 +7629,7 @@ static int sched_rt_global_validate(void
>  static void sched_rt_do_global(void)
>  {
>  	def_rt_bandwidth.rt_runtime = global_rt_runtime();
> +	def_rt_bandwidth.rt_max_runtime = global_rt_runtime();
>  	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
>  }
>  
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -614,12 +614,12 @@ static int do_balance_runtime(struct rt_
>  	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
>  	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
>  	int i, weight, more = 0;
> -	u64 rt_period;
> +	u64 rt_max_runtime;
>  
>  	weight = cpumask_weight(rd->span);
>  
>  	raw_spin_lock(&rt_b->rt_runtime_lock);
> -	rt_period = ktime_to_ns(rt_b->rt_period);
> +	rt_max_runtime = rt_b->rt_max_runtime;
>  	for_each_cpu(i, rd->span) {
>  		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
>  		s64 diff;
> @@ -643,12 +643,12 @@ static int do_balance_runtime(struct rt_
>  		diff = iter->rt_runtime - iter->rt_time;
>  		if (diff > 0) {
>  			diff = div_u64((u64)diff, weight);
> -			if (rt_rq->rt_runtime + diff > rt_period)
> -				diff = rt_period - rt_rq->rt_runtime;
> +			if (rt_rq->rt_runtime + diff > rt_max_runtime)
> +				diff = rt_max_runtime - rt_rq->rt_runtime;
>  			iter->rt_runtime -= diff;
>  			rt_rq->rt_runtime += diff;
>  			more = 1;
> -			if (rt_rq->rt_runtime == rt_period) {
> +			if (rt_rq->rt_runtime == rt_max_runtime) {
>  				raw_spin_unlock(&iter->rt_runtime_lock);
>  				break;
>  			}
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -124,6 +124,7 @@ struct rt_bandwidth {
>  	raw_spinlock_t		rt_runtime_lock;
>  	ktime_t			rt_period;
>  	u64			rt_runtime;
> +	u64			rt_max_runtime;
>  	struct hrtimer		rt_period_timer;
>  };
>  /*
> 
