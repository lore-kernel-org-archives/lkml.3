Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaIDCUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:20:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:22011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756618AbaIDCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:20:06 -0400
X-IronPort-AV: E=Sophos;i="5.04,462,1406563200"; 
   d="scan'208";a="35491410"
Message-ID: <5407CCD0.2090907@cn.fujitsu.com>
Date: Thu, 4 Sep 2014 10:22:08 +0800
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
References: <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net> <538E840D.2040300@cn.fujitsu.com> <20140604064946.GF30445@twins.programming.kicks-ass.net> <538ED7EB.5050303@cn.fujitsu.com> <20140604093907.GC11096@twins.programming.kicks-ass.net> <53904C6B.90001@cn.fujitsu.com> <20140606133629.GP13930@laptop.programming.kicks-ass.net> <5403E237.2000708@cn.fujitsu.com> <20140903151531.GP4783@worktop.ger.corp.intel.com>
In-Reply-To: <20140903151531.GP4783@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 11:15 PM, Peter Zijlstra wrote:
> On Mon, Sep 01, 2014 at 11:04:23AM +0800, Lai Jiangshan wrote:
>> Hi, Peter
>>
>> Could you make a patch for it, please? Jason J. Herne's test showed we
>> addressed the bug.  But the fix is not in kernel yet.  Some new highly
>> related reports are come up again.
>>
>> I don't want to argue any more, no matter how the patch will be,
>> I will accept.  And please add the following tags in your patch:
> 
> Well; I said http://marc.info/?l=linux-kernel&m=140187009016179 was a
> good patch and only asked you to add a comment and make it a nice patch
> which I could apply: http://marc.info/?l=linux-kernel&m=140187477317886&w=2
> 

I posted this patch as a quick fix for early test...
It didn't match my own criteria which may be diverted from the community although.

I'm sorry for having pushed my personal thinking to the community and resulted
that you had to write comment for my patch which was my responsibility.

> Instead you posted an entirely different patch again.
> 
> So how about the below?

Acked

> 
> ---
> Subject: sched: Migrate waking tasks
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Wed, 4 Jun 2014 16:25:15 +0800
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
> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/538ED7EB.5050303@cn.fujitsu.com
> ---
>  kernel/sched/core.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4642,7 +4642,7 @@ int set_cpus_allowed_ptr(struct task_str
>  		goto out;
>  
>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
> -	if (task_on_rq_queued(p)) {
> +	if (task_on_rq_queued(p) || p->state == TASK_WAKING) {

unrelated question: why we have to stop the cpu even the task is
not running?

