Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3HFHrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:47:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3HFHrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:47:00 -0400
Message-ID: <1375775172.5412.14.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ethan Zhao <ethan.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        johlstei@codeaurora.org, Yinghai Lu <yinghai@kernel.org>,
        Jin Feng <joe.jin@oracle.com>, Youquan Song <youquan.song@intel.com>,
        LenBrown <len.brown@intel.com>
Date: Tue, 06 Aug 2013 09:46:12 +0200
In-Reply-To: <1375774140.5412.9.camel@marge.simpson.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:h8ynmWzvg/EFTJEYoAG1Obedg1tVnD/VxbXnbOjyAvn
 k1SS6eouHWQRgjLa5eF9ga4W0D1kHvSStuKGCdJaOJpB+wsWBF
 mhLzh2mPrn6KboxTHQA82xYmO3wro7TODPiUQSsxkAYTuC99M3
 TrayJzHd9dn1t9ZQ509gPQTMY3khPOZGsmjSEmoH1c0jFjWd/X
 5aZJasjrgYFBvLPuoG6s9FDg+vyuUJejctrvbAoFh190P9JgHM
 V0+E7psm15jTeIuiCgyKk+X3YcXKaJuvnTYOTbRtTKlkJa1rEt
 G/ZMvQG8CoIEnc15UOM23rLtv2vzM0l5NqtHPohKMW3pCiaZiT
 Ecghj8bnrAbWRu/CRDjpoLpI8ofT+mSEa1FTc+7FeKjWFYZBaI
 /hPIiJHTYE5pw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs Intel folks)

On Tue, 2013-08-06 at 09:29 +0200, Mike Galbraith wrote: 
> On Tue, 2013-07-30 at 11:35 +0200, Peter Zijlstra wrote:
> 
> > It would be good if you could do what Thomas suggested and look at which
> > timer is actually active during your workload.
> 
> Rebuilding regression test trees, some pipe-test results...
> 
> I'm missing mwait_idle() rather a lot on Q6600, and at 3.8, E5620 took a
> severe NOHZ drubbing from the menu governor. 
> 
> pipe-test, scheduling cross core
> 
> NOTE: nohz is throttled here (patchlet below), as to not eat horrible
> microidle cost, see E5620 v3.7.10-nothrottle below.
> 
> Q6600
> v3.8.13                  500.6 KHz     1.000
> v3.9.11                  422.4 KHz      .843
> v3.10.4                  420.2 KHz      .839
> v3.11-rc3-4-g36f571e     404.7 KHz      .808
> 
> Q6600 3.9 regression:
> guilty party is 69fb3676 x86 idle: remove mwait_idle() and "idle=mwait" cmdline param
> halt sucks, HTH does one activate mwait_idle_with_hints() [processor_idle()] for core2 boxen?
> 
> E5620                                            +write 0 -> /dev/cpu_dma_latency, hold open
> v3.7.10                  578.5 KHz     1.000     675.4 KHz     1.000
> v3.7.10-nothrottle       366.7 KHz      .633     395.0 KHz      .584
> v3.8.13                  468.3 KHz      .809     690.0 KHz     1.021
> v3.8.13 idle=mwait       595.1 KHz     1.028     NA
> v3.9.11                  462.0 KHz      .798     691.1 KHz     1.023
> v3.10.4                  419.4 KHz      .724     570.8 KHz      .845
> v3.11-rc3-4-g36f571e     400.1 KHz      .691     538.5 KHz      .797
> 
> E5620 3.8 regression:
> guilty party: 69a37bea cpuidle: Quickly notice prediction failure for repeat mode
> 
> 
> Q6600 (2.4 GHz core2 quad)
>      v3.11-rc3-4-g36f571e                       v3.8.13
>      7.97%  [k] reschedule_interrupt            8.63%  [k] __schedule
>      6.27%  [k] __schedule                      6.07%  [k] native_sched_clock
>      4.74%  [k] native_sched_clock              4.96%  [k] system_call
>      4.23%  [k] _raw_spin_lock_irqsave          4.30%  [k] _raw_spin_lock_irqsave
>      3.39%  [k] system_call                     4.06%  [k] resched_task
>      2.89%  [k] sched_clock_local               3.44%  [k] sched_clock_local
>      2.79%  [k] mutex_lock                      3.39%  [k] pipe_read
>      2.57%  [k] pipe_read                       3.21%  [k] mutex_lock
>      2.55%  [k] __switch_to                     2.98%  [k] read_tsc
>      2.24%  [k] read_tsc                        2.87%  [k] __switch_to
> 
> 
> E5620 (2.4 GHz Westmere quad)
>     v3.7.10                                     v3.7.10-nothrottle                       v3.7.10-nothrottle
>     8.01%  [k] __schedule                      25.80%  [k] _raw_spin_unlock_irqrestore   21.80%  [k] _raw_spin_unlock_irqrestore
>     4.49%  [k] resched_tas                      4.64%  [k] __hrtimer_start_range_ns      - _raw_spin_unlock_irqrestore
>     3.94%  [k] mutex_lock                       4.62%  [k] timerqueue_add                   + 37.94% __hrtimer_start_range_ns
>     3.44%  [k] __switch_to                      4.54%  [k] __schedule                         19.69% hrtimer_cancel
>     3.18%  [k] menu_select                      2.84%  [k] enqueue_hrtimer                       tick_nohz_restart
>     3.05%  [k] copy_user_generic_string         2.64%  [k] resched_task                          tick_nohz_idle_exit
>     3.02%  [k] task_waking_fair                 2.29%  [k] _raw_spin_lock_irqsave                cpu_idle
>     2.91%  [k] mutex_unlock                     2.28%  [k] mutex_lock                            start_secondary
>     2.82%  [k] pipe_read                        1.96%  [k] __switch_to                      + 16.05% hrtimer_start_range_ns
>     2.32%  [k] ktime_get_real                   1.73%  [k] menu_select                        15.46% hrtimer_start
>                                                                                                  tick_nohz_stop_sched_tick
>                                                                                                  __tick_nohz_idle_enter
>                                                                                                  tick_nohz_idle_enter
>                                                                                                  cpu_idle
>                                                                                                  start_secondary
>                                                                                               6.37% hrtimer_try_to_cancel
>                                                                                                  hrtimer_cancel
>                                                                                                  tick_nohz_restart
>                                                                                                  tick_nohz_idle_exit
>                                                                                                  cpu_idle
>                                                                                                  start_secondary
> 
>     v3.8.13                                    v3.8.13 idle=mwait                        v3.8.13 (throttled, but menu gov bites.. HARD)
>     23.16%  [k] _raw_spin_unlock_irqrestore    8.35%  [k] __schedule                     -  22.91%  [k] _raw_spin_unlock_irqrestore
>      4.93%  [k] __schedule                     6.49%  [k] __switch_to                       - _raw_spin_unlock_irqrestore
>      3.42%  [k] resched_task                   5.71%  [k] resched_task                         - 47.26% hrtimer_try_to_cancel
>      3.27%  [k] __switch_to                    4.64%  [k] mutex_lock                                hrtimer_cancel
>      3.05%  [k] mutex_lock                     3.48%  [k] copy_user_generic_string                  menu_hrtimer_cancel
>      2.32%  [k] copy_user_generic_string       3.15%  [k] task_waking_fair                          tick_nohz_idle_exit
>      2.30%  [k] _raw_spin_lock_irqsave         3.13%  [k] pipe_read                                 cpu_idle
>      2.15%  [k] pipe_read                      2.61%  [k] mutex_unlock                              start_secondary
>      2.15%  [k] task_waking_fair               2.54%  [k] finish_task_switch                   - 40.01% __hrtimer_start_range_ns
>      2.08%  [k] ktime_get                      2.29%  [k] _raw_spin_lock_irqsave                    hrtimer_start
>      1.87%  [k] mutex_unlock                   1.91%  [k] idle_cpu                                  menu_select
>      1.76%  [k] finish_task_switch             1.84%  [k] __wake_up_common                          cpuidle_idle_call
>                                                                                                     cpu_idle
>                                                                                                     start_secondary
> 
>     v3.9.11
>     18.67%  [k] _raw_spin_unlock_irqrestore
>      4.36%  [k] __schedule
>      3.66%  [k] __switch_to
>      3.13%  [k] mutex_lock
>      2.97%  [k] __hrtimer_start_range_ns
>      2.69%  [k] _raw_spin_lock_irqsave
>      2.38%  [k] copy_user_generic_string
>      2.34%  [k] hrtimer_reprogram.isra.32
>      2.34%  [k] task_waking_fair
>      2.25%  [k] ktime_get
>      2.14%  [k] pipe_read
>      1.98%  [k] menu_select
> 
>     v3.10.4
>     20.42%  [k] _raw_spin_unlock_irqrestore
>      4.75%  [k] __schedule
>      4.42%  [k] reschedule_interrupt  <== appears in 3.10, guilty party as yet unknown
>      3.52%  [k] __switch_to
>      3.27%  [k] resched_task
>      2.64%  [k] cpuidle_enter_state
>      2.63%  [k] _raw_spin_lock_irqsave
>      2.04%  [k] copy_user_generic_string
>      2.00%  [k] cpu_idle_loop
>      1.97%  [k] mutex_lock
>      1.90%  [k] ktime_get
>      1.75%  [k] task_waking_fair
> 
>    v3.11-rc3-4-g36f571e
>    18.96%  [k] _raw_spin_unlock_irqrestore
>     4.84%  [k] __schedule
>     4.69%  [k] reschedule_interrupt
>     3.75%  [k] __switch_to
>     2.62%  [k] _raw_spin_lock_irqsave
>     2.43%  [k] cpuidle_enter_state
>     2.28%  [k] resched_task
>     2.20%  [k] cpu_idle_loop
>     1.97%  [k] copy_user_generic_string
>     1.88%  [k] ktime_get
>     1.81%  [k] task_waking_fair
>     1.75%  [k] mutex_lock
> 
> sched: ratelimit nohz
> 
> Entering nohz code on every micro-idle is too expensive to bear.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  include/linux/sched.h    |    5 +++++
>  kernel/sched/core.c      |    5 +++++
>  kernel/time/tick-sched.c |    2 +-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -235,9 +235,14 @@ extern int runqueue_is_locked(int cpu);
>  extern void nohz_balance_enter_idle(int cpu);
>  extern void set_cpu_sd_state_idle(void);
>  extern int get_nohz_timer_target(void);
> +extern int sched_needs_cpu(int cpu);
>  #else
>  static inline void nohz_balance_enter_idle(int cpu) { }
>  static inline void set_cpu_sd_state_idle(void) { }
> +static inline int sched_needs_cpu(int cpu)
> +{
> +	return 0;
> +}
>  #endif
>  
>  /*
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -650,6 +650,11 @@ static inline bool got_nohz_idle_kick(vo
>  	return false;
>  }
>  
> +int sched_needs_cpu(int cpu)
> +{
> +	return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;
> +}
> +
>  #else /* CONFIG_NO_HZ_COMMON */
>  
>  static inline bool got_nohz_idle_kick(void)
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -548,7 +548,7 @@ static ktime_t tick_nohz_stop_sched_tick
>  		time_delta = timekeeping_max_deferment();
>  	} while (read_seqretry(&jiffies_lock, seq));
>  
> -	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> +	if (sched_needs_cpu(cpu) || rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
>  	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
> 
> 


