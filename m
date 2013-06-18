Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3FROU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:20:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38522 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab3FROU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:56 -0400
Date: Tue, 18 Jun 2013 16:20:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/8] posix-cpu-timers: fix wrong timer initialization
Message-ID: <20130618142050.GF17619@somewhere.redhat.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
 <1369604149-13016-6-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369604149-13016-6-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 05:35:44PM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently glibc's rt/tst-cputimer1 testcase sporadically fails because
> a timer created by timer_create() may fire earlier than specified.
> 
> posix_cpu_timer_set() uses "val" as current time for three purpose. 1)
> initialize sig->cputimer. 2) calculation "old" val. 3) calculations an
> expires.
> 
> (1) and (2) should only use committed time (i.e. without delta_exec)
> because run_posix_cpu_timers() don't care of delta_exec and we need
> consistency, but (3) need exact current time (aka cpu clock time) because
> an expires should be "now + timeout" by definition.
> 
> This patch distinguishes between two kinds of "now".
> 
> Cc: Olivier Langlois <olivier@trillion01.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/kernel_stat.h |    5 -----
>  kernel/posix-cpu-timers.c   |   14 ++++++++++++--
>  kernel/sched/core.c         |   13 -------------
>  3 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> index ed5f6ed..f5d4fdf 100644
> --- a/include/linux/kernel_stat.h
> +++ b/include/linux/kernel_stat.h
> @@ -117,11 +117,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
>  	return kstat_cpu(cpu).irqs_sum;
>  }
>  
> -/*
> - * Lock/unlock the current runqueue - to extract task statistics:
> - */
> -extern unsigned long long task_delta_exec(struct task_struct *);
> -
>  extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
>  extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
>  extern void account_steal_time(cputime_t);
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 25447c5..d068808 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -652,7 +652,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
>  		cpu->cpu = cputime.utime;
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = cputime.sum_exec_runtime;

Are you sure that all callers of cpu_timer_sample_group() are fine with that change?
Looking at set_process_cpu_timer() it seems we want the committed time as well to
be added on newval. For the same reasons we use cpu_clock_sample_group() in (3) here.
