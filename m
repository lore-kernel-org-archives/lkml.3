Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab3FTN3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:29:25 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54662 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3FTN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <1371694737-29336-7-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
	<1371694737-29336-7-git-send-email-alex.shi@intel.com>
Date: Thu, 20 Jun 2013 15:29:23 +0200
Message-ID: <CAKfTPtACq+whBLEHUm2Vrf7rStKUViGaSX_fn=Kf4SduXOjvbg@mail.gmail.com>
Subject: Re: [Resend patch v8 06/13] sched: compute runnable load avg in
 cpu_load and cpu_avg_load_per_task
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2013 04:18, Alex Shi <alex.shi@intel.com> wrote:
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
>
> We also try to include the blocked_load_avg as cpu load in balancing,
> but that cause kbuild performance drop 6% on every Intel machine, and
> aim7/oltp drop on some of 4 CPU sockets machines.
> Or only add blocked_load_avg into get_rq_runable_load, hackbench still
> drop a little on NHM EX.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/fair.c |  5 +++--
>  kernel/sched/proc.c | 17 +++++++++++++++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1e5a5e6..7d5c477 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2968,7 +2968,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -       return cpu_rq(cpu)->load.weight;
> +       return cpu_rq(cpu)->cfs.runnable_load_avg;
>  }

Alex,

In the wake-affine function, we use current->se.load.weight  and
p->se.load.weight to update the load of this_cpu and prev_cpu whereas
these loads are now equal to runnable_load_avg which is the sum of
se->avg.load_avg_contrib now. Shouldn't we use
se->avg.load_avg_contrib instead of se.load.weight ?

Vincent

>
>  /*
> @@ -3013,9 +3013,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
>         unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> +       unsigned long load_avg = rq->cfs.runnable_load_avg;
>
>         if (nr_running)
> -               return rq->load.weight / nr_running;
> +               return load_avg / nr_running;
>
>         return 0;
>  }
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index bb3a6a0..ce5cd48 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>         sched_avg_update(this_rq);
>  }
>
> +#ifdef CONFIG_SMP
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +       return rq->cfs.runnable_load_avg;
> +}
> +#else
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +       return rq->load.weight;
> +}
> +#endif
> +
>  #ifdef CONFIG_NO_HZ_COMMON
>  /*
>   * There is no sane way to deal with nohz on smp when using jiffies because the
> @@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>         unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -       unsigned long load = this_rq->load.weight;
> +       unsigned long load = get_rq_runnable_load(this_rq);
>         unsigned long pending_updates;
>
>         /*
> @@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
>   */
>  void update_cpu_load_active(struct rq *this_rq)
>  {
> +       unsigned long load = get_rq_runnable_load(this_rq);
>         /*
>          * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>          */
>         this_rq->last_load_update_tick = jiffies;
> -       __update_cpu_load(this_rq, this_rq->load.weight, 1);
> +       __update_cpu_load(this_rq, load, 1);
>
>         calc_load_account_active(this_rq);
>  }
> --
> 1.7.12
>
