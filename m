Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaFIOBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:01:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45096 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaFIOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:01:42 -0400
Message-ID: <5395BE3D.6060409@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2014 10:01:33 -0400
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net> <538E840D.2040300@cn.fujitsu.com> <20140604064946.GF30445@twins.programming.kicks-ass.net> <538ED7EB.5050303@cn.fujitsu.com> <20140604093907.GC11096@twins.programming.kicks-ass.net> <53904C6B.90001@cn.fujitsu.com>
In-Reply-To: <53904C6B.90001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060914-9332-0000-0000-00000109EE22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:54 AM, Lai Jiangshan wrote:
> ------------
>
> Subject: [PATCH] sched: migrate the waking tasks
>
> Current code skips to migrate the waking task silently when TTWU_QUEUE is enabled.
>
> When a task is waking, it is pending on the wake_list of the rq, but
> it is not on queue (task->on_rq == 0). In this case, set_cpus_allowed_ptr()
> and __migrate_task() will not migrate it due to it is not on queue.
>
> This behavior is incorrect, because the task had been already waken-up, it will
> be running on the wrong CPU without correct placement until the next wake-up
> or update for cpus_allowed.
>
> To fix this problem, we need to make the waking tasks on-queue (transfer
> the waking tasks to running state) before migrate them.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..d05a5a1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1474,20 +1474,24 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>   }
>
>   #ifdef CONFIG_SMP
> -static void sched_ttwu_pending(void)
> +static void sched_ttwu_pending_locked(struct rq *rq)
>   {
> -	struct rq *rq = this_rq();
>   	struct llist_node *llist = llist_del_all(&rq->wake_list);
>   	struct task_struct *p;
>
> -	raw_spin_lock(&rq->lock);
> -
>   	while (llist) {
>   		p = llist_entry(llist, struct task_struct, wake_entry);
>   		llist = llist_next(llist);
>   		ttwu_do_activate(rq, p, 0);
>   	}
> +}
>
> +static void sched_ttwu_pending(void)
> +{
> +	struct rq *rq = this_rq();
> +
> +	raw_spin_lock(&rq->lock);
> +	sched_ttwu_pending_locked(rq);
>   	raw_spin_unlock(&rq->lock);
>   }
>
> @@ -4530,6 +4534,11 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>   		goto out;
>
>   	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
> +
> +	/* Ensure it is on rq for migration if it is waking */
> +	if (p->state == TASK_WAKING)
> +		sched_ttwu_pending_locked(rq);
> +
>   	if (p->on_rq) {
>   		struct migration_arg arg = { p, dest_cpu };
>   		/* Need help from migration thread: drop lock and wait. */
> @@ -4576,6 +4585,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>   	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>   		goto fail;
>
> +	/* Ensure it is on rq for migration if it is waking */
> +	if (p->state == TASK_WAKING)
> +		sched_ttwu_pending_locked(rq_src);
> +
>   	/*
>   	 * If we're not on a rq, the next wake-up will ensure we're
>   	 * placed properly.
>

FYI, this patch appears to fix the problem. I was able to run for 3 days 
without hitting the warning.

I see that you guys are still discussing the details of the fix. When 
you decide on a final solution I'm happy to retest. Just be sure to ask 
:). It is hard to tell what to test with so many patches and code 
snippets flying around all the time.

Happy coding.

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

