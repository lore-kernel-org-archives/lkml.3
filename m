Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaFCMlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:41:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31110 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbaFCMlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:41:10 -0400
X-IronPort-AV: E=Sophos;i="4.98,965,1392134400"; 
   d="scan'208";a="31385539"
Message-ID: <538DC373.9@cn.fujitsu.com>
Date: Tue, 3 Jun 2014 20:45:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <jjherne@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com>
In-Reply-To: <538DB076.4090704@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Peter,

I rewrote the analyse. (scheduler_ipi() must be called before stopper-task,
so the part for workqueue of the old analyse maybe be wrong.)


I found something strange by review (just by review, no test yet)

int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
{
...
	if (p->on_rq) {
		struct migration_arg arg = { p, dest_cpu };
		/* Need help from migration thread: drop lock and wait. */
		task_rq_unlock(rq, p, &flags);
		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
		tlb_migrate_finish(p->mm);
		return 0;
	}
...
}

The branch failed to migrate a waken-up task with p->on_rq==0 if TTWU_QUEUE is enabled:
	p->wake_entry is added to the rq,
	p->state is TASK_WAKING
	p->on_rq is 0

In this case set_cpus_allowed_ptr() fails to migrate the waken-up task!!!.

Go back to workqueue for higher level analysing.

task1					task2					cpu#4
					wake_up_process(worker1)
					  ttwu_queue_remote() #queue worker1
					  to cpu#4
workqueue_cpu_up_callback(cpu=5)

set_cpus_allowed_ptr(worker1)
  set worker's cpuallowed to
  cpumask_of(5)
  see worker1->on_rq = 0,
  do not migrate it.
										scheduler_ipi()
										set worker1->on_rq = 1

										wq_worker_waking_up(worker1)
										fail to hit the WARN_ON()
										  due to WORKER_UNBOUND is not cleared.
set_cpus_allowed_ptr() return 0
clear WORKER_UNBOUND for worker1

In this case, the WARN_ON() in process_one_work() hit.

Thanks,
Lai


The following code maybe help.
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..1a198a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4530,7 +4530,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (p->on_rq) {
+	if (p->on_rq || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);

