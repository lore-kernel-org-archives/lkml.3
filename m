Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaINJUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:20:38 -0400
Received: from forward5l.mail.yandex.net ([84.201.143.138]:43577 "EHLO
	forward5l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaINJUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:20:37 -0400
X-Yandex-Uniq: 017ce301-be88-4a1b-95f2-17a98c4f8ce6
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <54155DE0.7040606@yandex.ru>
Date: Sun, 14 Sep 2014 13:20:32 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
References: <1410519814.3569.7.camel@tkhai> <20140914091338.GN346@worktop.programming.kicks-ass.net>
In-Reply-To: <20140914091338.GN346@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2014 13:13, Peter Zijlstra wrote:
> On Fri, Sep 12, 2014 at 03:03:34PM +0400, Kirill Tkhai wrote:
>>
>> If a task is queued but not running on it rq, we can simply migrate
>> it without migration thread and switching of context.
>>
>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>> ---
>>  kernel/sched/core.c |   47 ++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 32 insertions(+), 15 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index d4399b4..dbbba26 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4594,6 +4594,33 @@ void init_idle(struct task_struct *idle, int cpu)
>>  }
>>  
>>  #ifdef CONFIG_SMP
>> +/*
>> + * move_queued_task - move a queued task to new rq.
>> + *
>> + * Returns (locked) new rq. Old rq's lock is released.
>> + */
>> +static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
>> +{
>> +	struct rq *rq = task_rq(p);
>> +
>> +	lockdep_assert_held(&rq->lock);
>> +
>> +	dequeue_task(rq, p, 0);
>> +	p->on_rq = TASK_ON_RQ_MIGRATING;
>> +	set_task_cpu(p, new_cpu);
>> +	raw_spin_unlock(&rq->lock);
>> +
>> +	rq = cpu_rq(new_cpu);
>> +
>> +	raw_spin_lock(&rq->lock);
>> +	BUG_ON(task_cpu(p) != new_cpu);
>> +	p->on_rq = TASK_ON_RQ_QUEUED;
>> +	enqueue_task(rq, p, 0);
>> +	check_preempt_curr(rq, p, 0);
>> +
>> +	return rq;
>> +}
> 
> We have almost that exact code sequence in __migrate_task() could we
> share some?
> 

Peter, haven't I moved the sequence from __migrate_task??

Rechecked again; yes, patch makes __migrate_task using new move_queued_task.

Kirill
