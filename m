Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3D2Khh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:37:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3D2Khg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:37:36 -0400
Date: Mon, 29 Apr 2013 12:36:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: fix wrong timer initialization
Message-ID: <20130429103600.GB31700@dyad.programming.kicks-ass.net>
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367216762-3933-2-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367216762-3933-2-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:26:02AM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently glibc's rt/tst-cputimer1 testcase is spradically fail because
> a timer created by timer_create() may faire earlier than an argument.
> 
> There are two faults. 1) cpu_timer_sample_group() adds task_delta_exec(current).
> But it is definity silly idea especially when multi thread. cputimer should
> be initialized by committed exec runtime. i.e. it should not be added
> scheduler delta. 2) expire time should be current time + timeout. In the other
> words, expire calculation should take care scheduler delta.

I'm sorry, that completely fails to parse.

> -/*
> - * Lock/unlock the current runqueue - to extract task statistics:
> - */
> -extern unsigned long long task_delta_exec(struct task_struct *);

Yay.. this thing dying is good -- it did seem strange to compute the current
delta but not also read sum_exec_runtime under the same lock.

> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index e56be4c..dc61bc3 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -203,12 +203,10 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
>  	return error;
>  }
>  
> -
> -/*
> - * Sample a per-thread clock for the given task.
> - */
> -static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
> -			    union cpu_time_count *cpu)
> +static int do_cpu_clock_sample(const clockid_t which_clock,
> +			       struct task_struct *p,
> +			       bool add_delta,
> +			       union cpu_time_count *cpu)

Would not thread_cputime() (to mirror thread_group_cputime()) be a better name?

Also, I would think both these functions would be a good place to insert a
comment explaining the difference between timer and clock.

> +static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
> +			    union cpu_time_count *cpu)
> +{
> +	return do_cpu_clock_sample(which_clock, p, true, cpu);
> +}

> @@ -700,7 +707,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>  	 * check if it's already passed.  In short, we need a sample.
>  	 */
>  	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
> -		cpu_clock_sample(timer->it_clock, p, &val);
> +		do_cpu_clock_sample(timer->it_clock, p, false, &val);
>  	} else {
>  		cpu_timer_sample_group(timer->it_clock, p, &val);
>  	}

This would suggest:

static inline int cpu_timer_sample(const clockid_t which_clock, struct task_struct *p, union cpu_time_count *cpu)
{
	return do_cpu_clock_sample(which_clock, p, false, cpu);
}

That would preserve the: cpu_{timer,clock}_sample{,_group}() form.

> @@ -749,7 +756,13 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>  	}
>  
>  	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
> -		cpu_time_add(timer->it_clock, &new_expires, val);
> +		union cpu_time_count now;
> +
> +		if (CPUCLOCK_PERTHREAD(timer->it_clock))
> +			cpu_clock_sample(timer->it_clock, p, &now);
> +		else
> +			cpu_clock_sample_group(timer->it_clock, p, &now);

This triggered a pattern match against earlier in this function; but they're
different now; timer vs clock. So nothing to merge...


So I don't mind the code changes, although its still not entirely clear to me
what exact problem is fixed how; and thus the Changelog needs TLC.
