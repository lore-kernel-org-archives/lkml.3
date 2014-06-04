Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaFDIVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:21:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25637 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbaFDIVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:21:12 -0400
X-IronPort-AV: E=Sophos;i="4.98,971,1392134400"; 
   d="scan'208";a="31429799"
Message-ID: <538ED7EB.5050303@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 16:25:15 +0800
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
References: <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net> <538E840D.2040300@cn.fujitsu.com> <20140604064946.GF30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140604064946.GF30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 02:49 PM, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 10:27:25AM +0800, Lai Jiangshan wrote:
>>> Hmm, yes I think you're right. A queued wakeup can miss an affinity
>>> change like that.
>>>
>>> Something like the below ought to cure that I suppose..
>>
>> As a non-scheduler developer, I can't find anything wrong with the patch
>> (I searched all on_rq in kernel/sched).
> 
> You did fine finding that hole, so who knows, you might become one real
> soon now ;-)
> 
>> but I think __migrate_task() is slow path comparing to sched_ttwu_pending().
>> So I prefer to change set_cpus_allowed_ptr() and __migrate_task() rather than
>> to sched_ttwu_pending().
> 
> Yes, I agree, something there would be better, but I couldn't find
> anything without holes in.
> 
> 

I think the following code works. (inspirited from the sched_ttwu_pending() in migration_call().)

if p->on_rq == 0 && p->state == TASK_WAKING in __migrate_task() after this patch,
it means the cpuallowed is changed before __migrate_task() along with other scheduler
movements happens between sched_ttwu_pending() and __migrate_task().


diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..277f3bc 100644
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
@@ -4656,6 +4656,7 @@ static int migration_cpu_stop(void *data)
 	 * be on another cpu but it doesn't matter.
 	 */
 	local_irq_disable();
+	sched_ttwu_pending();
 	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
 	local_irq_enable();
 	return 0;
