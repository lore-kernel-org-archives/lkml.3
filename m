Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaFDCXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:23:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbaFDCXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:23:02 -0400
X-IronPort-AV: E=Sophos;i="4.98,969,1392134400"; 
   d="scan'208";a="31415789"
Message-ID: <538E840D.2040300@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 10:27:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140603141659.GO30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 10:16 PM, Peter Zijlstra wrote:
> On Tue, Jun 03, 2014 at 07:24:38PM +0800, Lai Jiangshan wrote:
>> Hi, Jason
>>
>> Could you test again after the following command has done.
>> (if Peter hasn't asked you test with this command before nor he doesn't stop you now) 
>>
>> echo NO_TTWU_QUEUE > /sys/kernel/debug/sched_features
>>
>> Thanks a lot.
>>
>> Hi, Peter,
>>
>> I found something strange by review (just by review, no test yet)
>>
>> __migrate_task()
>> {
>> ...
>> 	/*
>> 	 * If we're not on a rq, the next wake-up will ensure we're
>> 	 * placed properly.
>> 	 */
>> 	if (p->on_rq) {
>> 		dequeue_task(rq_src, p, 0);
>> 		set_task_cpu(p, dest_cpu);
>> 		enqueue_task(rq_dest, p, 0);
>> 		check_preempt_curr(rq_dest, p, 0);
>> 	}
>> ...
>> }
>>
>> The comment is incorrect if TTWU_QUEUE is enabled.
>> The task is waken-up even p->on_rq==0 in this case:
>> 	p->wake_entry is added to the rq,
>> 	p->state is TASK_WAKING
>> 	p->on_rq is 0
>>
>> In this case __migrate_task() fails to migrate the task!!!.
>>
>> Go back to workqueue for higher level analysing.
>>
>> task1				cpu#4			task3
>> workqueue_cpu_up_callback()
>> 							wake_up_process(worker1)
>> 							  ttwu_queue_remote() #queue worker1 to cpu#4
>> set_cpus_allowed_ptr()
>>   set worker's cpuallowed to
>>   cpumask_of(5)
>> 				#stopper_task
>> 				__migrate_task()
>> 				finds p->on_rq is 0,
>> 				do nothing return
>> set_cpus_allowed_ptr() return 0
>>
>> In this case, the WARN_ON() in process_one_work() hit.
> 
> Hmm, yes I think you're right. A queued wakeup can miss an affinity
> change like that.
> 
> Something like the below ought to cure that I suppose..

As a non-scheduler developer, I can't find anything wrong with the patch
(I searched all on_rq in kernel/sched).

but I think __migrate_task() is slow path comparing to sched_ttwu_pending().
So I prefer to change set_cpus_allowed_ptr() and __migrate_task() rather than
to sched_ttwu_pending().

Any way, I agree on the change.
I hope Jason test it in few days.

> 
> ---
>  kernel/sched/core.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 240aa83e73f5..0708ee21632f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1521,17 +1521,32 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>  }
>  
>  #ifdef CONFIG_SMP
> +static void ttwu_queue_remote(struct task_struct *p, int cpu)
> +{
> +	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> +		smp_send_reschedule(cpu);
> +}
> +
>  static void sched_ttwu_pending(void)
>  {
>  	struct rq *rq = this_rq();
>  	struct llist_node *llist = llist_del_all(&rq->wake_list);
>  	struct task_struct *p;
> +	int cpu;
>  
>  	raw_spin_lock(&rq->lock);
>  
>  	while (llist) {
>  		p = llist_entry(llist, struct task_struct, wake_entry);
>  		llist = llist_next(llist);
> +
> +		if (unlikely(!cpumask_test_cpu(rq->cpu, tsk_cpus_allowed(p)))) {
> +			cpu = select_fallback_rq(rq->cpu, p);
> +			set_task_cpu(p, cpu);
> +			ttwu_queue_remote(p, cpu);
> +			continue;
> +		}
> +
>  		ttwu_do_activate(rq, p, 0);
>  	}
>  
> @@ -1579,12 +1594,6 @@ void scheduler_ipi(void)
>  	irq_exit();
>  }
>  
> -static void ttwu_queue_remote(struct task_struct *p, int cpu)
> -{
> -	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> -		smp_send_reschedule(cpu);
> -}
> -
>  bool cpus_share_cache(int this_cpu, int that_cpu)
>  {
>  	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);

