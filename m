Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3A2JaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:30:17 -0500
Received: from forward4.mail.yandex.net ([77.88.46.9]:33294 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3A2JaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:30:12 -0500
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 04:30:12 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Libo Chen <chenlibo.3@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, lizefan@huawei.com,
        jovi.zhangwei@huawei.com
Subject: Re:[PATCH]sched/rt: Do not try to push tasks if pinned task switches to RT
MIME-Version: 1.0
Message-Id: <446051359450817@web10d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 29 Jan 2013 13:13:37 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Libo Chen <libo.chen@huawei.com>
> 
> On 2013-1-29 4:23, Kirill Tkhai wrote:
> 
>> Just switched pinned task is not able to be pushed. If the rq had had
>> several RT tasks before they have already been considered as candidates
>> to be pushed (or pulled).
>>
>> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: Ingo Molnar <mingo@kernel.org>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
>> ---
>> kernel/sched/rt.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> index 4e8f0f4..5f7d92b 100644
>> --- a/kernel/sched/rt.c
>> +++ b/kernel/sched/rt.c
>> @@ -1925,9 +1925,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
>> */
>> if (p->on_rq && rq->curr != p) {
>> #ifdef CONFIG_SMP
>> - if (rq->rt.overloaded && push_rt_task(rq) &&
>> + if (rq->rt.overloaded && p->nr_cpus_allowed > 1 &&
>> /* Don't resched if we changed runqueues */
>> - rq != task_rq(p))
>> + push_rt_task(rq) && rq != task_rq(p))
> 
> I think you worry about it was excess to call push_rt_task, since the task of p->nr_cpus_allowed=1 can`t be pushed. is that right?

Sure.

> 
> The task of p->nr_cpus_allowed =1 would`t be added to pushable_tasks list （see the enqueue_task_rt()）and this push_rt_task() need to push other tasks when rt.overloaded.

If rq has already had 2 or more pushable tasks and we try to add a pinned task then call of push_rt_task will just waste a time.

> 
> So I don`t agree this patch.
> 
>> check_resched = 0;
>> #endif /* CONFIG_SMP */
>> if (check_resched && p->prio < rq->curr->prio)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html


 -- 
