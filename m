Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaJUULF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:11:05 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:34838 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbaJUULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:11:03 -0400
X-Yandex-Uniq: 687477da-e1f7-4b74-bddd-7d62f52386d9
Authentication-Results: smtp14.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5446BDD0.3040208@yandex.ru>
Date: Wed, 22 Oct 2014 00:10:56 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com> <54456E26.2000103@yandex.ru> <20141020205006.GA2500@redhat.com> <20141021094558.GQ23531@worktop.programming.kicks-ass.net> <20141021190335.GA12851@redhat.com> <5446BC2D.1030909@yandex.ru>
In-Reply-To: <5446BC2D.1030909@yandex.ru>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.10.2014 00:03, Kirill Tkhai wrote:
> On 21.10.2014 23:03, Oleg Nesterov wrote:
>> On 10/21, Peter Zijlstra wrote:
>>>
>>> On Mon, Oct 20, 2014 at 10:50:06PM +0200, Oleg Nesterov wrote:
>>>> Let me explain what I personally dislike in v3:
>>>>
>>>> 	- I think that we do not have enough reasons for
>>>> 	  SLAB_DESTROY_BY_RCU. This is the serious change.
>>>
>>> What exactly would the downsides be? SDBR has very limited space
>>> overhead iirc.
>>
>> Yes, SDBR is nice (and it could probably have more users), but my
>> concern is not overhead. Please see below.
>>
>>>> 	- Again, perhaps we should start we a simple and stupid fix.
>>>> 	  We can do get_task_struct() under rq->lock or, if nothing
>>>> 	  else, just
>>>>
>>>> 	  	raw_spin_lock_irq(&rq->lock);
>>>> 	  	cur = rq->curr;
>>>> 	  	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
>>>> 	  		cur = NULL;
>>>> 	  	raw_spin_unlock_irq(&rq->lock);
>>>
>>> I think I agree with you, this is the simple safe option and is
>>> something we can easily backport. After that we can add creative bits on
>>> top.
>>
>> Agreed.
>>
>> Kirill, could you please make a patch?
> 
> Yeah, I'll send it tomorrow.
> 
>>> I think I prefer the SLAB_DESTROY_BY_RCU thing over the probe_kernel
>>> thing
>>
>> I won't really insist, but let me try to explain why I dislike it in
>> this particular case.
>>
>> - It is not clear who else (except task_numa_compare) will need it.
>>   And it looks at bit strange to make task_struct SLAB_DESTROY_BY_RCU
>>   just to read a word in task_numa_compare().
>>
>> - In some sense, the usage of SDBR looks simply "wrong" in this case.
>>   IOW, I agree that probe_kernel_read() is ugly, but in this case
>>   SDBR acts exactly the same way as probe_kernel_read().
>>
>>   SDBR does not make the object rcu-safe, it only protects the object
>>   type plus ensures that this memory can't go away. It was designed
>>   for the case when you read the stable members initialized in ctor
>>   (usually a lock) and verify/lock the object.
>>
>>   But in this case we can not detect that the object is still alive
>>   without the additional trick, so when you read ->sighand or ->flags,
>>   the fact that this memory is still "struct task_struct" doesn't help
>>   and doesn't matter at all. Only the subsequent "task == rq->curr"
>>   check proves that yes, this is task_struct.
>>
>>   OTOH, (afaics) we only need probe_kernel_read() if CONFIG_DEBUG_SLAB.
>>   And in fact I think that "read the valid but potentially freed kernel
>>   pointer" deserves another helper, it can have more users. For example,
>>   please look at get_freepointer_safe().
>>
>>   What if we add get_kernel(x, ptr) macro to factor out the IS_ENABLED()
>>   of ifdef hack? Or inline function... This way the new xxx() helper we
>>   discussed won't look that bad.
>>
>> But again, I agree that this subjective, I won't really argue.
> 
> So this patch we fix task_numa_compare(). We need remember to fix
> remaining later:
> 
> $ git grep ACCESS_ONCE kernel/sched/ | grep "\->curr"
> kernel/sched/deadline.c:	curr = ACCESS_ONCE(rq->curr); /*
> kernel/sched/fair.c:	cur = ACCESS_ONCE(dst_rq->curr);
> kernel/sched/fair.c:	tsk = ACCESS_ONCE(cpu_rq(cpu)->curr);
> kernel/sched/rt.c:	curr = ACCESS_ONCE(rq->curr); /* unlocked

*)in other places we use task_struct R/O.

