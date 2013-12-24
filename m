Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3LXDbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:31:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55277 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab3LXDa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:30:59 -0500
MIME-Version: 1.0
In-Reply-To: <20131223162442.GA9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
	<1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
	<20131223162442.GA9383@infradead.org>
Date: Tue, 24 Dec 2013 11:30:58 +0800
Message-ID: <CACVXFVN=sxHxUY_0c9xWKw3nXhj60UeSjvFTHs52zHNEAg__4w@mail.gmail.com>
Subject: Re: [PATCH 1/4] block: blk-mq: support draining mq queue
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Thanks for your review.

On Tue, Dec 24, 2013 at 12:24 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Dec 24, 2013 at 12:18:56AM +0800, Ming Lei wrote:
>> blk_mq_drain_queue() is introduced so that we can drain
>> mq queue during cleanup queue.
>>
>> Also don't accept new requests any more if queue is marked
>> as dying.
>
> blk_cleanup_queue is a call from the LLDD, there is no need to make

Some drivers don't have LLDD, like null_blk, virtio-blk, ...

> it handle the MQ case.  However given that there might be a lot of
> code shared between blk_cleanup_queue and blk_mq_cleanup_queue an
> internal helper might be useful.

So there are two ways to implement block API for MQ: one is to try to
adapt current block APIs for blk mq driver, another one is to always
reinvent new blk_mq_* APIs for blk mq driver.

Looks you prefer to the 2nd one, and this patch takes the 1st way.

Actually the below block APIs
               blk_get_request()
               blk_put_request()
               blk_execute_rq_nowait()
               blk_register_queue()
               blk_unregister_queue()
               blk_insert_flush()
               ....

have been there to support MQ.

One problem about the 2nd way is that MQ drivers may become a bit
ugly if the driver still need to support traditional request/bio mechanism.

So I think blk_mq_drain_queue can be called for MQ too.

>
>> +     if (q->mq_ops) {
>> +             blk_mq_drain_queue(q);
>> +     } else {
>> +             spin_lock_irq(lock);
>> +             __blk_drain_queue(q, true);
>> +             queue_flag_set(QUEUE_FLAG_DEAD, q);
>> +             spin_unlock_irq(lock);
>> +     }
>
> Why doesn't the mq case set QUEUE_FLAG_DEAD here?

Looks DEAD flag is set to prevent request_fn from being called,
and there is no request_fn for MQ, so I don't set it and QUEUE_FLAG_DYING
has been checked in blk_mq_queue_enter() already.

But we can do it easily.

>
>> -static void blk_mq_freeze_queue(struct request_queue *q)
>> +static void __blk_mq_freeze_queue(struct request_queue *q,
>> +             bool force_drain)
>>  {
>>       bool drain;
>>
>> +     if (force_drain)
>> +             goto do_drain;
>> +
>>       spin_lock_irq(q->queue_lock);
>>       drain = !q->bypass_depth++;
>>       queue_flag_set(QUEUE_FLAG_BYPASS, q);
>> @@ -134,6 +141,7 @@ static void blk_mq_freeze_queue(struct request_queue *q)
>>       if (!drain)
>>               return;
>>
>> + do_drain:
>>       while (true) {
>>               s64 count;
>
> This begs to be split into two functions, one that forces the drain, and
> once that wraps it.

Sounds a good idea, and I will do it in v1.

>
> Also blk_execute_rq_nowait now needs to check the dying case for MQ as
> well.

In this patch the dying flag is only checked in blk_mq_queue_enter()
which is called in allocating request path, so once the request is
allocated, we just simply wait for its completion in blk_mq_drain_queue().

Even for non-MQ case, looks blk_queue_dying(q) is checked to avoid
being freed early before running queue, I am not sure if it is good
because the I/O might or can have been completed.  And it isn't a problem
for MQ because this request can't be reused when dying is set.


Thanks,
-- 
Ming Lei
