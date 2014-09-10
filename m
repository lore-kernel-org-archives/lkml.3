Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaIJHqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:46:14 -0400
Received: from forward2m.mail.yandex.net ([37.140.138.2]:56108 "EHLO
	forward2m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIJHqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:46:12 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 03:46:12 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jjherne@linux.vnet.ibm.com" <jjherne@linux.vnet.ibm.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <tip-5cd038f53ed9ec7a17ab7d536a727363080f4210@git.kernel.org>
References: <538ED7EB.5050303@cn.fujitsu.com> <tip-5cd038f53ed9ec7a17ab7d536a727363080f4210@git.kernel.org>
Subject: Re: [tip:sched/core] sched: Migrate waking tasks
MIME-Version: 1.0
Message-Id: <2397411410334685@web16m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 10 Sep 2014 11:38:05 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.09.2014, 18:54, "tip-bot for Lai Jiangshan" <tipbot@zytor.com>:
> Commit-ID: š5cd038f53ed9ec7a17ab7d536a727363080f4210
> Gitweb: ššššhttp://git.kernel.org/tip/5cd038f53ed9ec7a17ab7d536a727363080f4210
> Author: ššššLai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Wed, 4 Jun 2014 16:25:15 +0800
> Committer: šIngo Molnar <mingo@kernel.org>
> CommitDate: Tue, 9 Sep 2014 06:47:27 +0200
>
> sched: Migrate waking tasks
>
> Current code can fail to migrate a waking task (silently) when TTWU_QUEUE is
> enabled.
>
> When a task is waking, it is pending on the wake_list of the rq, but it is not
> queued (task->on_rq == 0). In this case, set_cpus_allowed_ptr() and
> __migrate_task() will not migrate it because its invisible to them.
>
> This behavior is incorrect, because the task has been already woken, it will be
> running on the wrong CPU without correct placement until the next wake-up or
> update for cpus_allowed.
>
> To fix this problem, we need to finish the wakeup (so they appear on
> the runqueue) before we migrate them.
>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Reported-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
> Tested-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/538ED7EB.5050303@cn.fujitsu.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
> škernel/sched/core.c | 8 +++++++-
> š1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index a814b3c..78e5c83 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4666,7 +4666,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>  		goto out;
>
>	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
> -	if (task_on_rq_queued(p)) {
> +	if (task_on_rq_queued(p) || p->state == TASK_WAKING) {
>  		struct migration_arg arg = { p, dest_cpu };
> š		/* Need help from migration thread: drop lock and wait. */
> š		task_rq_unlock(rq, p, &flags);


About migration_cpu_stop():

> @@ -4799,6 +4799,12 @@ static int migration_cpu_stop(void *data)
>  	* be on another cpu but it doesn't matter.
>  	*/
>  	local_irq_disable();
> +	/*
> +	* We need to explicitly wake pending tasks before running
> +	* __migrate_task() such that we will not miss enforcing cpus_allowed
> +	* during wakeups, see set_cpus_allowed_ptr()'s TASK_WAKING test.
> +	*/
> +	sched_ttwu_pending();
>	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
>	local_irq_enable();
>	return 0;

It looks like we do not need this hunk, because IPI happens earlier then
stop class begins migration_cpu_stop() execution.

In the first hunk the check "p->state == TASK_WAKING" is under pi_lock,
so if the task is really waking then the IPI is already set.

So, the first hunk is enough here, the second is not need.

Kirill

P.S. Formatting may be in punk style
