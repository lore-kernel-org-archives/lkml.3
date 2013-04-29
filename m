Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3D2RyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:54:00 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39669 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab3D2Rx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:53:59 -0400
Message-ID: <517EB3B4.6040702@gmail.com>
Date: Mon, 29 Apr 2013 13:53:56 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: fix wrong timer initialization
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com> <1367216762-3933-2-git-send-email-kosaki.motohiro@gmail.com> <20130429103600.GB31700@dyad.programming.kicks-ass.net>
In-Reply-To: <20130429103600.GB31700@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/29/13 6:36 AM), Peter Zijlstra wrote:
> On Mon, Apr 29, 2013 at 02:26:02AM -0400, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Currently glibc's rt/tst-cputimer1 testcase is spradically fail because
>> a timer created by timer_create() may faire earlier than an argument.
>>
>> There are two faults. 1) cpu_timer_sample_group() adds task_delta_exec(current).
>> But it is definity silly idea especially when multi thread. cputimer should
>> be initialized by committed exec runtime. i.e. it should not be added
>> scheduler delta. 2) expire time should be current time + timeout. In the other
>> words, expire calculation should take care scheduler delta.
> 
> I'm sorry, that completely fails to parse.
> 
>> -/*
>> - * Lock/unlock the current runqueue - to extract task statistics:
>> - */
>> -extern unsigned long long task_delta_exec(struct task_struct *);
> 
> Yay.. this thing dying is good -- it did seem strange to compute the current
> delta but not also read sum_exec_runtime under the same lock.
> 
>> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
>> index e56be4c..dc61bc3 100644
>> --- a/kernel/posix-cpu-timers.c
>> +++ b/kernel/posix-cpu-timers.c
>> @@ -203,12 +203,10 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
>>  	return error;
>>  }
>>  
>> -
>> -/*
>> - * Sample a per-thread clock for the given task.
>> - */
>> -static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>> -			    union cpu_time_count *cpu)
>> +static int do_cpu_clock_sample(const clockid_t which_clock,
>> +			       struct task_struct *p,
>> +			       bool add_delta,
>> +			       union cpu_time_count *cpu)
> 
> Would not thread_cputime() (to mirror thread_group_cputime()) be a better name?

agreed.


> Also, I would think both these functions would be a good place to insert a
> comment explaining the difference between timer and clock.

agreed.


> 
>> +static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>> +			    union cpu_time_count *cpu)
>> +{
>> +	return do_cpu_clock_sample(which_clock, p, true, cpu);
>> +}
> 
>> @@ -700,7 +707,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>>  	 * check if it's already passed.  In short, we need a sample.
>>  	 */
>>  	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
>> -		cpu_clock_sample(timer->it_clock, p, &val);
>> +		do_cpu_clock_sample(timer->it_clock, p, false, &val);
>>  	} else {
>>  		cpu_timer_sample_group(timer->it_clock, p, &val);
>>  	}
> 
> This would suggest:
> 
> static inline int cpu_timer_sample(const clockid_t which_clock, struct task_struct *p, union cpu_time_count *cpu)
> {
> 	return do_cpu_clock_sample(which_clock, p, false, cpu);
> }
> 
> That would preserve the: cpu_{timer,clock}_sample{,_group}() form.

Yeah, agreed.
And also, all timer function should use cpu_timer_sample() instead of cpu_clock_sample().
check_thread_timers() uses p->se.sum_exec_runtime without delta. This is consitency with
per-process timer. Thus, other functions (e.g. posix_cpu_timers_get) should also use the
same.

> 
>> @@ -749,7 +756,13 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
>>  	}
>>  
>>  	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
>> -		cpu_time_add(timer->it_clock, &new_expires, val);
>> +		union cpu_time_count now;
>> +
>> +		if (CPUCLOCK_PERTHREAD(timer->it_clock))
>> +			cpu_clock_sample(timer->it_clock, p, &now);
>> +		else
>> +			cpu_clock_sample_group(timer->it_clock, p, &now);
> 
> This triggered a pattern match against earlier in this function; but they're
> different now; timer vs clock. So nothing to merge...

Not different, I think.
Relative timeout need to calculate "now + timeout" by definition.

But which time is "now"? 

Example, thread1 has 10ms sum_exec_runtime and 4ms delta and call timer_settime(4ms).
Old code calculate an expire is 10+4=14. New one calculate  10+4+4=18.

Which expire is correct? When using old one, timer will fire just after syscall. This
is posix violation. 

In the other words,

	sighandler(){
		t1 = clock_gettime()
	}

	t0 = clock_gettime()
	timer_settime(timeout);
	 ... wait to fire
	
	assert (t1 - t0 >= timeout)

This pseudo code must be true. it is snippest what glibc rt/tst-cputimer1 test and failed.




> So I don't mind the code changes, although its still not entirely clear to me
> what exact problem is fixed how; and thus the Changelog needs TLC.
> 

