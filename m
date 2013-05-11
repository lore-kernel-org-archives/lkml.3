Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3EKA4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:56:19 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39649 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3EKA4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:56:17 -0400
Date: Sat, 11 May 2013 02:56:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/7] posix-cpu-timers: fix acounting delta_exec twice
Message-ID: <20130511005613.GC13340@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367556468-4021-4-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367556468-4021-4-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:47:43AM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently glibc rt/tst-cpuclock2 test(*) sporadically fails because
> scheduler delta can be accounted twice from thread_group_cputimer()
> and account_group_exec_runtime().
> 
> Finally, clock_nanosleep() wakes up before an argument. This is posix
> violation. This issue was introduced by commit d670ec1317 (posix-cpu-timers:
> Cure SMP wobbles).
> 
> (*) http://sourceware.org/git/?p=glibc.git;a=blob;f=rt/tst-cpuclock2.c;h=6752721717f959e89c0d692b3f1ee082d507eec2;hb=HEAD
> 
> Cc: Olivier Langlois <olivier@trillion01.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
[...]
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 8fd709c..e56be4c 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -220,7 +220,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  		cpu->cpu = virt_ticks(p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = task_sched_runtime(p);
> +		cpu->sched = task_sched_runtime(p, true);
>  		break;
>  	}
>  	return 0;
> @@ -250,8 +250,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
>  		 * values through the TIMER_ABSTIME flag, therefore we have
>  		 * to synchronize the timer to the clock every time we start
>  		 * it.
> +		 *
> +		 * Do not add the current delta, because
> +		 * account_group_exec_runtime() will also this delta and we
> +		 * wouldn't want to double account time and get ahead of
> +		 * ourselves.
>  		 */
> -		thread_group_cputime(tsk, &sum);
> +		thread_group_cputime(tsk, false, &sum);
>  		raw_spin_lock_irqsave(&cputimer->lock, flags);

I wonder if we should move thread_group_cputime() inside this lock.
Otherwise we can miss some updates in-between.
