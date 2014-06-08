Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaFHCq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 22:46:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32421 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753187AbaFHCqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 22:46:25 -0400
X-IronPort-AV: E=Sophos;i="4.98,997,1392134400"; 
   d="scan'208";a="31608476"
Message-ID: <5393CF90.9070807@cn.fujitsu.com>
Date: Sun, 8 Jun 2014 10:50:56 +0800
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
References: <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net> <538E840D.2040300@cn.fujitsu.com> <20140604064946.GF30445@twins.programming.kicks-ass.net> <538ED7EB.5050303@cn.fujitsu.com> <20140604093907.GC11096@twins.programming.kicks-ass.net> <53904C6B.90001@cn.fujitsu.com> <20140606133629.GP13930@laptop.programming.kicks-ass.net>
In-Reply-To: <20140606133629.GP13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 09:36 PM, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 06:54:35PM +0800, Lai Jiangshan wrote:
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 268a45e..d05a5a1 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1474,20 +1474,24 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>>  }
>>  
>>  #ifdef CONFIG_SMP
>> -static void sched_ttwu_pending(void)
>> +static void sched_ttwu_pending_locked(struct rq *rq)
>>  {
>> -	struct rq *rq = this_rq();
>>  	struct llist_node *llist = llist_del_all(&rq->wake_list);
>>  	struct task_struct *p;
>>  
>> -	raw_spin_lock(&rq->lock);
>> -
>>  	while (llist) {
>>  		p = llist_entry(llist, struct task_struct, wake_entry);
>>  		llist = llist_next(llist);
>>  		ttwu_do_activate(rq, p, 0);
>>  	}
>> +}
>>  
>> +static void sched_ttwu_pending(void)
>> +{
>> +	struct rq *rq = this_rq();
>> +
>> +	raw_spin_lock(&rq->lock);
>> +	sched_ttwu_pending_locked(rq);
>>  	raw_spin_unlock(&rq->lock);
>>  }
> 
> OK, so this won't apply to a recent kernel.

Thank you for review.

The code here was already changed in the recent kernel?
or I touched too much to apply it?

> 
>> @@ -4530,6 +4534,11 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>>  		goto out;
>>  
>>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>> +
>> +	/* Ensure it is on rq for migration if it is waking */
>> +	if (p->state == TASK_WAKING)
>> +		sched_ttwu_pending_locked(rq);
> 
> So I would really rather like to avoid this if possible, its doing full
> remote queueing, exactly what we tried to avoid.

set_cpus_allowed_ptr() is slow path, the bad effect introduced by this
change is limited.

> 
>> +
>>  	if (p->on_rq) {
>>  		struct migration_arg arg = { p, dest_cpu };
>>  		/* Need help from migration thread: drop lock and wait. */
>> @@ -4576,6 +4585,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>>  	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>>  		goto fail;
>>  
>> +	/* Ensure it is on rq for migration if it is waking */
>> +	if (p->state == TASK_WAKING)
>> +		sched_ttwu_pending_locked(rq_src);
>> +
>>  	/*
>>  	 * If we're not on a rq, the next wake-up will ensure we're
>>  	 * placed properly.
> 
> Oh man, another variant.. why did you change it again? And without
> explanation for why you changed it.
> 
> I don't see a reason to call sched_ttwu_pending() with rq->lock held,
> seeing as how we append to that list without it held.

sched_ttwu_pending() requires rq->lock to do actual work.

I swapped the order of "llist_del_all(&rq->wake_list)" and "raw_spin_lock(&rq->lock);"
that it makes the lock section of rq->lock is slightly extend.

> 
> I'm still thinking the previous version is good, can you explain why you
> changed it?

There was a window in the previous version.

sched_ttwu_pending();
	<----------------window here, the task can be in WAKING state again.
__migrate_task();


When I thought deeply, it was still correct in current code for all migration_cpu_stop()'s
callers. But we need a big chunk of comments to explain it. And I felt nervous
with that window, it would be a bug if something else changed without regarding
this window. I don't want to leave a fragile code.

The new version patch is much straight and it is self comment.

Migration: if the task is waken-up, migrate it, otherwise it is next wakeup's responsibility.
Original code simply considered p->on_rq <==> waken-up.
New patch just fixes up p->on_rq before considering it.


How about this (slight changed without touching original sched_ttwu_pending())

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..cd224ea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1474,6 +1474,18 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
+static void sched_ttwu_pending_locked(struct rq *rq)
+{
+	struct llist_node *llist = llist_del_all(&rq->wake_list);
+	struct task_struct *p;
+
+	while (llist) {
+		p = llist_entry(llist, struct task_struct, wake_entry);
+		llist = llist_next(llist);
+		ttwu_do_activate(rq, p, 0);
+	}
+}
+
 static void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
@@ -4530,7 +4542,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (p->on_rq) {
+	if (p->on_rq || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
@@ -4576,6 +4588,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 		goto fail;
 
+	/* Ensure it is on rq for migration if it is waking */
+	if (p->state == TASK_WAKING)
+		sched_ttwu_pending_locked(rq_src);
+
 	/*
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
> 
> 
> 
> 
> 
> 
> .
> 

