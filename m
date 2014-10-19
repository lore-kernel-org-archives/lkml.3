Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaJSIVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 04:21:15 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:39502 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaJSIVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 04:21:08 -0400
X-Yandex-Uniq: b98b942b-7a90-41b2-bb45-6adf4c4d85f6
Authentication-Results: smtp1o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5443746B.6060309@yandex.ru>
Date: Sun, 19 Oct 2014 12:20:59 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru> <1011271413621207@web30j.yandex.ru> <20141018193612.GC23531@worktop.programming.kicks-ass.net>
In-Reply-To: <20141018193612.GC23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.2014 23:36, Peter Zijlstra wrote:
> On Sat, Oct 18, 2014 at 12:33:27PM +0400, Kirill Tkhai wrote:
>> How about this?
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index b78280c..d46427e 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1165,7 +1165,21 @@ static void task_numa_compare(struct task_numa_env *env,
>>  
>>  	rcu_read_lock();
>>  	cur = ACCESS_ONCE(dst_rq->curr);
>> -	if (cur->pid == 0) /* idle */
>> +	/*
>> +	 * No need to move the exiting task, and this ensures that ->curr
>> +	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
>> +	 * is safe; note that rcu_read_lock() can't protect from the final
>> +	 * put_task_struct() after the last schedule().
>> +	 */
>> +	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
>> +		cur = NULL;
>> +	/*
>> +	 * Check once again to be sure curr is still on dst_rq. Even if
>> +	 * it points on a new task, which is using the memory of freed
>> +	 * cur, it's OK, because we've locked RCU before
>> +	 * delayed_put_task_struct() callback is called to put its struct.
>> +	 */
>> +	if (cur != ACCESS_ONCE(dst_rq->curr))
>>  		cur = NULL;
>>  
>>  	/*
> 
> So you worry about the refcount doing 0->1 ? In which case the above is
> still wrong and we should be using atomic_inc_not_zero() in order to
> acquire the reference count.
> 

We can't use atomic_inc_not_zero(). The problem is that cur is pointing
to a memory, which may be not a task_struct even. No guarantees at all.
