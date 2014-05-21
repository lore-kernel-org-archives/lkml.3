Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaEUFQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:16:17 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43277 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaEUFQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140520152303.GA20352@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
	<20140519151824.GA21762@lst.de>
	<CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com>
	<20140520152303.GA20352@lst.de>
Date: Wed, 21 May 2014 13:16:14 +0800
Message-ID: <CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:23 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, May 20, 2014 at 11:20:25AM +0800, Ming Lei wrote:
>> - the conflict on the two structures just happens with flush
>> requests because rq->requeue_work is only used to queue
>> flush requests
>
> Once we get non-trivial block drivers we'll need to be able
> to requeue arbitrary requests, that's why I added blk_mq_requeue_request.

I am wondering if virtio-blk is trivial block driver, :-)
And virtio-blk still supports requeuing with returning
BLK_MQ_RQ_QUEUE_BUSY.

> The scsi-mq work that I plant to submit for the next merge window is
> the prime example.

It depends if one scsi-mq req has to requeue itself with rq->requeue_work
inside its own .softirq_done_fn. If yes, we can't put call_single_data
and requeue_work into one union simply. From you last scsi-mq post,
looks the request may do that if I understand correctly.

But scsi_cmnd has already one 'abort_work', and I am wondering
why scsi-mq requeuing doesn't share its own requeue_work with
abort_work, which seems doable since requeuing and aborting belong
to different stage.

>
> I'd really prefer to avoid breaking that use case if we can avoid it.

This patch won't break the coming scsi-mq, and it is a fix.

I'd like to figure out one patch to cover scsi-mq case if
we can get that before 3.15 release since your 'respect-affinity'
patch has enabled IPI at default already. Otherwise, we
still have enough time to fix the issue for scsi-mq, don't we?

>
>
> Note that the flush code already is very nasy for blk-mq and this just
> makes it worse.

I think the patch is clean and simple, with documenting the special
conflict case clearly too.

>
> One fix that would also help to sort out some of the flush issues would
> be to add a list of requests that need requeueing to the blk_mq context,
> which we can add requeusts to from irq context.  The next time we run

That won't be easy to introduce a requeue_list for the purpose
since we need to keep order of requests per blk-mq ctx.

Also lockless list won't work since there are both
'add_front'/'add_tail' requirement.

> hw contexts for the queue we'll pick them up in user context and insert
> them.

IMO, the requests can be inserted to ctx list directly from irq
context, but with cost of spin_lock_irqsave(&ctx->lock) everywhere.

Follows current ideas:
1), this patch with scsi-mq sharing abort_work together?
2), move requeue_work out of the union inside request
3), spin_lock_irqsave(&ctx->lock) everywhere and requeue
request directly to ctx without using work

Any other ideas?

Thanks,
--
Ming Lei
