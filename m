Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3CRPjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:39:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60375 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3CRPjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:39:51 -0400
MIME-Version: 1.0
In-Reply-To: <9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
Date: Mon, 18 Mar 2013 16:39:48 +0100
Message-ID: <CAFTL4hxJUnnBvHNty1FgxbBGOrrPPNotJGaE03B8s_t1Lx5vRw@mail.gmail.com>
Subject: Re: [PATCH V3 1/7] sched: Create sched_select_cpu() to give preferred
 CPU for power saving
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18 Viresh Kumar <viresh.kumar@linaro.org>:
> In order to save power, it would be useful to schedule light weight work on cpus
> that aren't IDLE instead of waking up an IDLE one.
>
> By idle cpu (from scheduler's perspective) we mean:
> - Current task is idle task
> - nr_running == 0
> - wake_list is empty
>
> This is already implemented for timers as get_nohz_timer_target(). We can figure
> out few more users of this feature, like workqueues.
>
> This patch converts get_nohz_timer_target() into a generic API
> sched_select_cpu() so that other frameworks (like workqueue) can also use it.
>
> This routine returns the cpu which is non-idle. It accepts a bitwise OR of SD_*
> flags present in linux/sched.h. If the local CPU isn't idle OR all cpus are
> idle, local cpu is returned back. If local cpu is idle, then we must look for
> another CPU which have all the flags passed as argument as set and isn't idle.
>
> This patch reuses the code from get_nohz_timer_target() routine, which had
> similar implementation.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/sched.h | 21 +++++++++++++++--
>  kernel/sched/core.c   | 63 +++++++++++++++++++++++++++++----------------------
>  2 files changed, 55 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e20580d..216fa0d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -230,14 +230,31 @@ extern void init_idle_bootup_task(struct task_struct *idle);
>
>  extern int runqueue_is_locked(int cpu);
>
> -#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
> +#ifdef CONFIG_SMP
> +extern int sched_select_cpu(unsigned int sd_flags);
> +
> +#ifdef CONFIG_NO_HZ
>  extern void nohz_balance_enter_idle(int cpu);
>  extern void set_cpu_sd_state_idle(void);
> -extern int get_nohz_timer_target(void);
> +/*
> + * In the semi idle case, use the nearest busy cpu for migrating timers
> + * from an idle cpu.  This is good for power-savings.
> + *
> + * We don't do similar optimization for completely idle system, as
> + * selecting an idle cpu will add more delays to the timers than intended
> + * (as that cpu's timer base may not be uptodate wrt jiffies etc).
> + */
> +#define get_nohz_timer_target() sched_select_cpu(0)
>  #else
>  static inline void nohz_balance_enter_idle(int cpu) { }
>  static inline void set_cpu_sd_state_idle(void) { }
> +
> +static inline int sched_select_cpu(unsigned int sd_flags)
> +{
> +       return raw_smp_processor_id();

I feel this should be symetric with the requirement of having
preemption disabled as in the CONFIG_NO_HZ version. This should be
smp_processor_id().

[...]
> @@ -648,6 +621,42 @@ void sched_avg_update(struct rq *rq)
>         }
>  }
>
> +/*
> + * This routine returns the nearest non-idle cpu. It accepts a bitwise OR of
> + * SD_* flags present in linux/sched.h. If the local CPU isn't idle, it is
> + * returned back. If it is idle, then we must look for another CPU which have
> + * all the flags passed as argument as set.
> + */
> +int sched_select_cpu(unsigned int sd_flags)

It would be nice to have some more precise naming. sched_select_busy_cpu() ?
