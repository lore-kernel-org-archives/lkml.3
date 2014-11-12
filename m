Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaKLMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:25:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaKLMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:25:27 -0500
Date: Wed, 12 Nov 2014 13:21:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112122155.GA3250@redhat.com>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112111553.GA21343@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:15:53PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 12, 2014 at 11:29:28AM +0100, Stanislaw Gruszka wrote:
> > Commit d670ec13178d "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
> > test case in cost of breaking another one. After that commit, calling
> > clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
> > of Y time being smaller than X time.
> 
> <snip>
> 
> > Issue happens because on start in thread_group_cputimer() we initialize
> > sum_exec_runtime of cputimer with threads runtime not yet accounted and
> > then add the threads runtime again on scheduler tick. When cputimer
> > finish, it's sum_exec_runtime value is bigger than current sum counted
> > by iterating over the threads in thread_group_cputime().
> > 
> > KOSAKI Motohiro posted fix for this problem, but that patch was never
> > applied: https://lkml.org/lkml/2013/5/26/191.
> > 
> > This patch takes different approach. It revert change from d670ec13178d,
> > but to assure process times are in sync with thread times, before
> > accounting the times it calls update_curr() to update current thread
> > sum_exec_runtime. This fixes the test case from commit d670ec13178d and
> > also make things like they were before i.e. process cpu times can be
> > (nr_threads - 1) * TICK_NSEC behind the clock (this is a drawback
> > unfortunately). 
> 
> > Good news is that patch improve performance of
> > thread_group_cputime(), i.e. we do not need optimizations from commit
> > 911b289 "sched: Optimize task_sched_runtime()"
> 
> You're inconsistent with your SHA1 lengths, use 12 chars.
> 
> So I'm not seeing how you've not reintroduced the issue from
> d670ec13178d, afaict you simply do not take the delta of all the other
> threads into account, which is why you're not taking as many locks.
> 
> Which also re-introduces the 32bit data race mentioned in that
> changelog.

Right, I missed the 32 bit issue. On 64 bit's this patch really
helps with d670ec13178d test case. Issue there was that thread accounted
cpu time was bigger than cpu time of proccess which include that thread.
It happened because on cpu_clock_sample() we return task sum_exec_runtime
plus not yet accounted runtime, but on cpu_clock_sample_group() we count
only sum_exec_runtime of that task. With this patch we count only the
task sum_exec_runtime on both cpu_clock_sample() and
cpu_clock_sample_group() (but sum_exec_runtime is updated for current
task before we use it in those functions).

> > @@ -254,6 +256,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
> >  		*sample = cputime_to_expires(cputime.utime);
> >  		break;
> >  	case CPUCLOCK_SCHED:
> > +		scheduler_update_curr(p);
> >  		thread_group_cputime(p, &cputime);
> >  		*sample = cputime.sum_exec_runtime;
> >  		break;
> 
> Why only these two thread_group_cputime() calls and not all others?

On other cases here we do not utilize sum_exec_runtime, but only utime
and stime, which are not updated by update_curr().

I can fix 32 bit problem by introducing seq_lock around reading/writing 
task sum_exec_runtime on 32 bits arches. And fix other issues you pointed.
Though I'm not sure now, if this approach is better than KOSAKI Motohiro 
patch: http://marc.info/?l=linux-kernel&m=136960420627094&w=2
That patch can be furhter simplified - we do not have to pass bool value
up to task_sched_runtime(), juts add it only to thread_group_cputime().
What do you think ?

Stanislaw

