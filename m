Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaJTUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:18:56 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:50914 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaJTUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:18:55 -0400
X-Yandex-Uniq: d34707f4-6cc3-46b4-a02c-94cbb84d2e4d
Authentication-Results: smtp12.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <54456E26.2000103@yandex.ru>
Date: Tue, 21 Oct 2014 00:18:46 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com>
In-Reply-To: <20141020182748.GA20424@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oleg,

On 20.10.2014 22:27, Oleg Nesterov wrote:
> On 10/20, Oleg Nesterov wrote:
>>
>> On 10/20, Oleg Nesterov wrote:
>>>
>>> Again, perhaps we will need to change the lifetime rules for task_struct
>>> anyway, if we have more problems like this. But until then this looks like
>>> an overkill to me. Plus rq_curr_if_not_put() looks too subtle, and it is
>>> not generic.
>>
>> Yes... otoh, perhaps we can do something more generic? Something like
>>
>> 	struct task_struct *xxx(struct task_struct **ptask)
>> 	{
>> 		struct task_struct *task;
>> 		void *sighand;
>> 	retry:
>> 		task = ACCESS_ONCE(*ptask);
>> 		if (!task)
>> 			return NULL;
>>
>> 		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
>> 			if (probe_kernel_read(&sighand, &task->sighand, sizeof(sighand)))
>> 				goto retry;
>> 		} else {
>> 			sighand = task->sighand;
>> 		}
>>
>> 		if (!sighand)
>> 			return NULL;
>> 		/*
>> 		 * Pairs with atomic_dec_and_test() in put_task_struct(task).
>> 		 * If we have read the freed/reused memory, we must see that
>> 		 * the pointer was updated.
>> 		 */
>> 		smp_rmb();
>> 		if (task != ACCESS_ONCE(*ptask))
>> 			goto retry;
>>
>> 		return task;
>> 	}
>>
>> task_numa_compare() can do cur = xxx(&rc->curr), but this helper can work
>> with any "task_struct *" pointer assuming that somehow this pointer is
>> cleared or changed before the final put_task_struct().
>>
>> What do you think? Peter?
> 
> And if we introduce this helper, it would better to check "sighand != NULL"
> after "task != *ptask":
> 
> 	struct task_struct *xxx(struct task_struct **ptask)
> 	{
> 		struct task_struct *task;
> 		struct sighand_struct *sighand;
> 
> 	retry:
> 		task = ACCESS_ONCE(*ptask);
> 		if (!task)
> 			return task;
> 
> 		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
> 			if (probe_kernel_read(&sighand, &task->sighand, sizeof(sighand)))
> 				goto retry;
> 		} else {
> 			sighand = task->sighand;
> 		}
> 		/*
> 		 * Pairs with atomic_dec_and_test() in put_task_struct(task).
> 		 * If we have read the freed/reused memory, we must see that
> 		 * the pointer was updated.
> 		 */
> 		smp_rmb();
> 		if (unlikely(task != ACCESS_ONCE(*ptask)))
> 			goto retry;
> 		/*
> 		 * release_task(task) was already called, potentially before
> 		 * the caller took rcu_read_lock() and in this case it can be
> 		 * freed before rcu_read_unlock().
> 		 */
> 		if (!sighand)
> 			return NULL;
> 		return task;
> 	}
> 
> Of course, task_numa_compare() do not really need "retry", and task == NULL
> is not possible. But this way the new helper can (probably) have more users,
> and this just looks better imo.

I think generic helper is a good idea. The prototype looks OK.

But I'm a little doubt about retry loop. If this helper is generic and
one day it may move to ./include directory, isn't there a probability
people will use it wrong? This loop may bring delays or something bad.
Nothing specific, just suspicion...

And since we still depends on RCU, I'd suggest to add its lockdep assert.

Kirill
