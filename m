Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3BVMc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:32:28 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:49626 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab3BVMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:32:27 -0500
Date: Fri, 22 Feb 2013 13:32:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org,
        efault@gmx.de
Subject: Re: [PATCH v4] sched: fix init NOHZ_IDLE flag
Message-ID: <20130222123213.GA17948@somewhere.redhat.com>
References: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 09:29:16AM +0100, Vincent Guittot wrote:
> On my smp platform which is made of 5 cores in 2 clusters, I have the
> nr_busy_cpu field of sched_group_power struct that is not null when the
> platform is fully idle. The root cause seems to be:
> During the boot sequence, some CPUs reach the idle loop and set their
> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
> field is initialized later with the assumption that all CPUs are in the busy
> state whereas some CPUs have already set their NOHZ_IDLE flag.
> During the initialization of the sched_domain, we set the NOHZ_IDLE flag when
> nr_busy_cpus is initialized to 0 in order to have a coherent configuration.
> If a CPU enters idle and call set_cpu_sd_state_idle during the build of the
> new sched_domain it will not corrupt the initial state
> set_cpu_sd_state_busy is modified and clears the NOHZ_IDLE only if a non NULL
> sched_domain is attached to the CPU (which is the case during the rebuild)
> 
> Change since V3;
>  - NOHZ flag is not cleared if a NULL domain is attached to the CPU
>  - Remove patch 2/2 which becomes useless with latest modifications
> 
> Change since V2:
>  - change the initialization to idle state instead of busy state so a CPU that
>    enters idle during the build of the sched_domain will not corrupt the
>    initialization state
> 
> Change since V1:
>  - remove the patch for SCHED softirq on an idle core use case as it was
>    a side effect of the other use cases.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/core.c |    4 +++-
>  kernel/sched/fair.c |    9 +++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..c730a4e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5884,7 +5884,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>  		return;
>  
>  	update_group_power(sd, cpu);
> -	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
> +	atomic_set(&sg->sgp->nr_busy_cpus, 0);
> +	set_bit(NOHZ_IDLE, nohz_flags(cpu));
> +
>  }
>  
>  int __weak arch_sd_sibling_asym_packing(void)
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 81fa536..2701a92 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5403,15 +5403,20 @@ static inline void set_cpu_sd_state_busy(void)
>  {
>  	struct sched_domain *sd;
>  	int cpu = smp_processor_id();
> +	int clear = 0;
>  
>  	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
>  		return;
> -	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
>  
>  	rcu_read_lock();
> -	for_each_domain(cpu, sd)
> +	for_each_domain(cpu, sd) {
>  		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
> +		clear = 1;
> +	}
>  	rcu_read_unlock();
> +
> +	if (likely(clear))
> +		clear_bit(NOHZ_IDLE, nohz_flags(cpu));

I fear there is still a race window:

      = CPU 0 =                 = CPU 1 =
                             // NOHZ_IDLE is set
                             set_cpu_sd_state_busy() {
                                 dom1 = rcu_dereference(dom1);
                                 inc(dom1->nr_busy_cpus)

    rcu_assign_pointer(dom 1, NULL)
    // create new domain
    init_sched_group_power() {
	    atomic_set(&tmp->nr_busy_cpus, 0);
	    set_bit(NOHZ_IDLE, nohz_flags(cpu 1));
    rcu_assign_pointer(dom 1, tmp)


                                  
                                  clear_bit(NOHZ_IDLE, nohz_flags(cpu));
                              }


I don't know if there is any sane way to deal with this issue other than
having nr_busy_cpus and nohz_flags in the same object sharing the same
lifecycle.
