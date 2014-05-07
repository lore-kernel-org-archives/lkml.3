Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbaEGNim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:38:42 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35739 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaEGNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140507131257.GB16702@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
	<1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
	<20140505143613.GD11231@htj.dyndns.org>
	<5369DC5C.20001@cn.fujitsu.com>
	<20140507131257.GB16702@htj.dyndns.org>
Date: Wed, 7 May 2014 21:38:39 +0800
X-Google-Sender-Auth: Y2Wxsf7PMfJI8dwgWpv8M-07Fhs
Message-ID: <CACvQF50kdodjDGnaxgQC2sW82rvkFVLtWQDOn90cohNkzG-oZw@mail.gmail.com>
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 9:12 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Wed, May 07, 2014 at 03:10:20PM +0800, Lai Jiangshan wrote:
>> 1) complete() can't be called inside attach_mutex due to the worker
>>    shouldn't access to the pool after complete().
>
> Sure, complete it after releasing the lock.  Shutdown can't complete
> before the completion gets completed, right?
>
>> 2) put_unbound_pool() may called from get_unbound_pool(), we need to add
>>    an additional check and avoid the wait_for_completion() if so.

Do you accept if I remove put_unbound_pool() from get_unbound_pool()
and use several freeing code instead?

>>
>> +static void worker_detach_from_pool(struct worker *worker, struct worker_pool *pool)
>> +{
>> +     bool is_last;
>> +
>> +     mutex_lock(&pool->bind_mutex);
>> +     list_del(&worker->bind_entry);
>> +     is_last = list_empty(&worker->bind_entry);
>> +     mutex_unlock(&pool->bind_mutex);
>> +
>> +     /* need some comments here */
>> +     if (is_last)
>> +             complete(&pool->workers_detached);
>> +}
>>
>>
>> @@ -3588,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
>>       mutex_lock(&pool->manager_mutex);
>>       spin_lock_irq(&pool->lock);
>>
>> +     need_to_wait = pool->nr_workers != 0; /* it may be called from get_unbound_pool() */
>>       while ((worker = first_worker(pool)))
>>               destroy_worker(worker);
>>       WARN_ON(pool->nr_workers || pool->nr_idle);
>> @@ -3596,6 +3596,8 @@ static void put_unbound_pool(struct worker_pool *pool)
>>       mutex_unlock(&pool->manager_mutex);
>>       mutex_unlock(&pool->manager_arb);
>>
>> +     if (need_to_wait)
>> +             wait_for_completion(&pool->workers_detached);
>
> Shouldn't it be able to wait whenever it's about to destroy non-empty
> pool?
>
>         DECLARE_COMPLETION_ONSTACK(completion);
>
>         ...
>
>         while ((worker = first_worker(pool))) {
>                 destroy_worker(worker);
>                 pool->detach_completion = &completion;
>         }
>
>         ...
>         unlock;
>
>         if (pool->detach_completion)
>                 wait_for_completion();

it is more complex than wait_queue.
if put_unbound_pool() is removed out from get_unbound_pool(),
a simple wait_for_completion() is enough.

>         ...
>
> And the worker side can simply do,
>
>         struct completion *completion;
>
>         if (I'm the last worker exiting)
>                 completion = pool->detach_completion;
>         unlock;
>

if(completion)
>         complete(completion);
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
