Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFDLGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:06:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11240 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752437AbaFDLGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:06:20 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392134400"; 
   d="scan'208";a="31438363"
Message-ID: <538EFEBE.2090809@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 19:10:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <riel@redhat.com>, <linux-kernel@vger.kernel.org>, <mingo@kernel.org>
Subject: Re: [PATCH] sched: Fix migration_cpu_stop() return value
References: <20140604104122.GL30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140604104122.GL30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 06:41 PM, Peter Zijlstra wrote:
> A while ago I did a similar patch for some debugging, but looking at it
> again today I realized we should probably fix this anyway.
> 
> ---
> Subject: sched: Fix migration_cpu_stop() return value
> 
> There are a number of migration_cpu_stop() users; and some actually care
> about the success of the migration. So report this.
> 
> In particular migrate_task_to() as used from task_numa_migrate()
> actually tests this return value.
> 
> Also change set_cpus_allowed_ptr() to propagate this return value, since
> it already returns other errors.
> 
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/core.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4633,11 +4633,13 @@ int set_cpus_allowed_ptr(struct task_str
>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>  	if (p->on_rq) {
>  		struct migration_arg arg = { p, dest_cpu };
> +
>  		/* Need help from migration thread: drop lock and wait. */
>  		task_rq_unlock(rq, p, &flags);
> -		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
> +		ret = stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>  		tlb_migrate_finish(p->mm);
> -		return 0;
> +
> +		return ret;
>  	}
>  out:
>  	task_rq_unlock(rq, p, &flags);
> @@ -4747,19 +4749,24 @@ void sched_setnuma(struct task_struct *p
>   * migration_cpu_stop - this will be executed by a highprio stopper thread
>   * and performs thread migration by bumping thread off CPU then
>   * 'pushing' onto another runqueue.
> + *
> + * Returns 0 on success, -EAGAIN on failure to migrate.
>   */
>  static int migration_cpu_stop(void *data)
>  {
>  	struct migration_arg *arg = data;
> +	int ret = 0;
>  
>  	/*
>  	 * The original target cpu might have gone down and we might
>  	 * be on another cpu but it doesn't matter.
>  	 */
>  	local_irq_disable();
> -	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
> +	if (!__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu))
> +		ret = -EAGAIN;


Current __migrate_task() returns 0 in these cases:
  !cpu_active(dest_cpu):
	hotplug subsystem's responsibility to migrate it

  !cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)):
	newer set_cpus_allowed_ptr()'s responsibility

In these cases, current set_cpus_allowed_ptr() doesn't have the responsibility,
I don't think -EAGAIN is proper here since "-EAGAIN" asks the caller to do it again.


>  	local_irq_enable();
> -	return 0;
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU

