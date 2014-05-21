Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEUGtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:49:01 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37214 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaEUGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140521053634.GA4764@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
	<20140519151824.GA21762@lst.de>
	<CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com>
	<20140520152303.GA20352@lst.de>
	<CACVXFVNP--zj_-UtygxfXk7GvSXwKm2KMKFs=h9KsrL=ZzbWVQ@mail.gmail.com>
	<20140521053634.GA4764@lst.de>
Date: Wed, 21 May 2014 14:48:58 +0800
Message-ID: <CACVXFVO5znzYtPKMTPwx_2MU97xFZY+wHwm+R33T043SW4JHHw@mail.gmail.com>
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

On Wed, May 21, 2014 at 1:36 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, May 21, 2014 at 01:16:14PM +0800, Ming Lei wrote:
>> I am wondering if virtio-blk is trivial block driver, :-)
>
> It's about as simple as it gets.
>
>> > The scsi-mq work that I plant to submit for the next merge window is
>> > the prime example.
>>
>> It depends if one scsi-mq req has to requeue itself with rq->requeue_work
>> inside its own .softirq_done_fn. If yes, we can't put call_single_data
>> and requeue_work into one union simply. From you last scsi-mq post,
>> looks the request may do that if I understand correctly.
>
> Requeueing a request from the completion handler is indeed what we'll
> need with various more complete drivers.

At least for scsi, the current scsi_cmnd->abort_work(reusing) should
be enough for requeing the command. For other drivers, maybe
they can make use of something like scsi_cmnd->abort_work too.

>
>> I think the patch is clean and simple, with documenting the special
>> conflict case clearly too.
>
> While I can't say anything against the fact that it fixes the issue
> it's neither clean nor simple.

It just uses q->flush_rq's own work_struct for requeuing itself,
that is it. I'd like to see a cleaner/simpler solution without wasting
space and extra complexity.

>
>> Follows current ideas:
>> 1), this patch with scsi-mq sharing abort_work together?
>> 2), move requeue_work out of the union inside request
>> 3), spin_lock_irqsave(&ctx->lock) everywhere and requeue
>> request directly to ctx without using work
>
> I think Jens very much wanted to avoid irq disabling in the I/O path
> if possible. If we have a separate requeue list with it's separate
> lock we can avoid that unless we actually have to take requests of
> that requeue list.  I can look into that implementation.

I am wondering if you can keep requests in order per blk-mq ctx
since you introduce another list.


Thanks,
-- 
Ming Lei
