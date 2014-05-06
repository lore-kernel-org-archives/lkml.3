Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbaEFPnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:43:47 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36207 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaEFPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140505130130.GA11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
	<1398571754-12443-2-git-send-email-laijs@cn.fujitsu.com>
	<20140505130130.GA11231@htj.dyndns.org>
Date: Tue, 6 May 2014 23:43:45 +0800
X-Google-Sender-Auth: P1nl_rWwj3bCNiS1p0bAbV0KOsY
Message-ID: <CACvQF52gKX72eoV73NTAhVf7BgAUGUg2Leeruchb-uMfj-Z0XA@mail.gmail.com>
Subject: Re: [PATCH 01/10] workqueue: use manager lock only to protect worker_idr
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 9:01 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Apr 27, 2014 at 12:08:56PM +0800, Lai Jiangshan wrote:
>> worker_idr is highly bound to managers and is always/only accessed in manager
>> lock context. So we don't need pool->lock for it.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ...
>> @@ -378,14 +367,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
>>   * @wi: integer used for iteration
>>   * @pool: worker_pool to iterate workers of
>>   *
>> - * This must be called with either @pool->manager_mutex or ->lock held.
>> + * This must be called with either @pool->manager_mutex.
>
> Please drop "either" from the sentence.

Ahh, I will do it.

>
>> @@ -1725,13 +1714,7 @@ static struct worker *create_worker(struct worker_pool *pool)
>>        * ID is needed to determine kthread name.  Allocate ID first
>>        * without installing the pointer.
>>        */
>> -     idr_preload(GFP_KERNEL);
>> -     spin_lock_irq(&pool->lock);
>> -
>> -     id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_NOWAIT);
>> -
>> -     spin_unlock_irq(&pool->lock);
>> -     idr_preload_end();
>> +     id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_KERNEL);
>>       if (id < 0)
>>               goto fail;
>>
>> @@ -1773,18 +1756,13 @@ static struct worker *create_worker(struct worker_pool *pool)
>>               worker->flags |= WORKER_UNBOUND;
>>
>>       /* successful, commit the pointer to idr */
>> -     spin_lock_irq(&pool->lock);
>>       idr_replace(&pool->worker_idr, worker, worker->id);
>> -     spin_unlock_irq(&pool->lock);
>
> W/ locking updated, we can simply assign the pointer on idr_alloc()
> instead of doing split alloc/replace.

I hope the patch simpler which just removes the lock around it.
this idr_replace() will be removed in later patch, so it is OK
when idr_replace() is temporary kept.

And I don't want to add a fail path after the thread is allocated.

>
> I'm a bit on the fence about this patch.  It does simplify the code a
> bit but then we lose the ability to iterate workers without grabbing
> the manager_mutex, which would come handy when, for example,
> implementing better workqueue info reporting during oops which we'll
> prolly need to add sooner or later.

It can be done by idle_list + busy_hash if needed.
Or add an additional list.

Thanks
Lai

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
