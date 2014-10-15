Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaJOWCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:02:44 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:41739 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaJOWCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:02:43 -0400
X-Yandex-Uniq: 77393e1f-a2a1-4ac3-b32c-90d51ae6a660
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <543EEEFE.4060505@yandex.ru>
Date: Thu, 16 Oct 2014 02:02:38 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
References: <1413376300.24793.55.camel@tkhai> <20141015150641.GA2755@redhat.com> <20141015194044.GA4557@redhat.com> <543EEB1F.3040900@yandex.ru>
In-Reply-To: <543EEB1F.3040900@yandex.ru>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.10.2014 01:46, Kirill Tkhai wrote:
> Yeah, you're sure about initial patch. Thanks for signal explanation.
> 
> On 15.10.2014 23:40, Oleg Nesterov wrote:
>> On 10/15, Oleg Nesterov wrote:
>>>
>>> On 10/15, Kirill Tkhai wrote:
>>>>
>>>> Regarding to scheduler this may be a reason of use-after-free.
>>>>
>>>>     task_numa_compare()                    schedule()
>>>>         rcu_read_lock()                        ...
>>>>         cur = ACCESS_ONCE(dst_rq->curr)        ...
>>>>             ...                                rq->curr = next;
>>>>             ...                                    context_switch()
>>>>             ...                                        finish_task_switch()
>>>>             ...                                            put_task_struct()
>>>>             ...                                                __put_task_struct()
>>>>             ...                                                    free_task_struct()
>>>>             task_numa_assign()                                     ...
>>>>                 get_task_struct()                                  ...
>>>
>>> Agreed. I don't understand this code (will try to take another look later),
>>> but at first glance this looks wrong.
>>>
>>> At least the code like
>>>
>>> 	rcu_read_lock();
>>> 	get_task_struct(foreign_rq->curr);
>>> 	rcu_read_unlock();
>>>
>>> is certainly wrong. And _probably_ the problem should be fixed here. Perhaps
>>> we can add try_to_get_task_struct() which does atomic_inc_not_zero() ...
>>
>> Yes, but perhaps in this particular case another simple fix makes more
>> sense. The patch below needs a comment to explain that we check PF_EXITING
>> because:
>>
>> 	1. It doesn't make sense to migrate the exiting task. Although perhaps
>> 	   we could check ->mm == NULL instead.
>>
>> 	   But let me repeat that I do not understand this code, I am not sure
>> 	   we can equally treat is_idle_task() and PF_EXITING here...
>>
>> 	2. If PF_EXITING is not set (or ->mm != NULL) then delayed_put_task_struct()
>> 	   won't be called until we drop rcu_read_lock(), and thus get_task_struct()
>> 	   is safe.
>>
> 
> Cool! Elegant fix. We set PF_EXITING in exit_signals(), which is earlier
> than release_task() is called.
> 
> Shouldn't we use smp_rmb/smp_wmb here?
> 
>> And. it seems that there is another problem? Can't task_h_load(cur) race
>> with itself if 2 CPU's call task_numa_migrate() and inspect the same rq
>> in parallel? Again, I don't understand this code, but update_cfs_rq_h_load()
>> doesn't look "atomic". In fact I am not even sure about task_h_load(env->p),
>> p == current but we do not disable preemption.
>>
>> What do you think?
> 
> We use it completely unlocked, so nothing good is here. Also we work
> with pointers.
> 
> As I understand in update_cfs_rq_h_load() we go from bottom to top,
> and then from top to bottom. We set cfs_rq::h_load_next to be able
> to do top-bottom passage (top is a root of "tree").

> Yeah, this "way" may be overwritten by competitor. Also, task may change
> its cfs_rq.

Wrong, it's not a task... Brain is sleepy, it's better tomorrow.

> 
>> --- x/kernel/sched/fair.c
>> +++ x/kernel/sched/fair.c
>> @@ -1165,7 +1165,7 @@ static void task_numa_compare(struct tas
>>  
>>  	rcu_read_lock();
>>  	cur = ACCESS_ONCE(dst_rq->curr);
>> -	if (cur->pid == 0) /* idle */
>> +	if (is_idle_task(cur) || (curr->flags & PF_EXITING))
>>  		cur = NULL;
>>  
>>  	/*
>>
> 
> Looks like, we have to use the same fix for task_numa_group().
> 
> grp = rcu_dereference(tsk->numa_group);
> 
> Below we dereference grp->nr_tasks.
> 
> Also, the same in rt.c and deadline.c, but we do no take second
> reference there. Wrong pointer dereference is not possible there,
> not so bad.
> 
> Kirill
> 

