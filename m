Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LZKMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:12:33 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52400 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3LZKMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:12:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131226094518.GA22894@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
	<1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
	<20131223162442.GA9383@infradead.org>
	<CACVXFVN=sxHxUY_0c9xWKw3nXhj60UeSjvFTHs52zHNEAg__4w@mail.gmail.com>
	<20131226094518.GA22894@infradead.org>
Date: Thu, 26 Dec 2013 18:12:30 +0800
Message-ID: <CACVXFVOOEGPt7JXKmk=dTz3H6TgadBoOx1_D_hksi6J1L7OjYw@mail.gmail.com>
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

On Thu, Dec 26, 2013 at 5:45 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Dec 24, 2013 at 11:30:58AM +0800, Ming Lei wrote:
>> Some drivers don't have LLDD, like null_blk, virtio-blk, ...
>
> Well, they are the low-level driver in this case.
>
>> Actually the below block APIs
>>                blk_get_request()
>>                blk_put_request()
>>                blk_execute_rq_nowait()
>>                blk_register_queue()
>>                blk_unregister_queue()
>>                blk_insert_flush()
>>                ....
>>
>> have been there to support MQ.
>
> All these are called by higher level code and not the driver, so we need
> a switch between MQ and non-MQ support somewhere.

But sometimes there is no so-called high level code, and only one driver
for driving the block device, such as two drivers above, and we have lots
of such drivers, so looks not easy to apply the rule for all drivers suppose
there is.

IMO, if one block API can serve for both non-MQ and MQ cases, why do
we have to split it into blk_foo() and blk_mq_foo()?

>
>> One problem about the 2nd way is that MQ drivers may become a bit
>> ugly if the driver still need to support traditional request/bio mechanism.
>
> On the other hand drivers have no legitimate case for long-term parallel
> MQ/non-MQ code paths.  The only exception is null_blk as a benchmarking
> vehicle, but we should not optimize for that.

IMO it is very possible that parallel path might keep for a while, and at least
the current scsi-mq patches do so.

>
>> >> +             spin_unlock_irq(lock);
>> >> +     }
>> >
>> > Why doesn't the mq case set QUEUE_FLAG_DEAD here?
>>
>> Looks DEAD flag is set to prevent request_fn from being called,
>> and there is no request_fn for MQ, so I don't set it and QUEUE_FLAG_DYING
>> has been checked in blk_mq_queue_enter() already.
>>
>> But we can do it easily.
>
> Do we have a per-context flag to prevent calling into the driver
> instead?  Sorry, it's been a while that I last looked at the code, but
> anyone just looking over the difference will have the same question, so
> the answer needs to go into a comment.

It is OK to add comment or just keep the two cases consistent, and looks
I prefer to the later.

>
>> > Also blk_execute_rq_nowait now needs to check the dying case for MQ as
>> > well.
>>
>> In this patch the dying flag is only checked in blk_mq_queue_enter()
>> which is called in allocating request path, so once the request is
>> allocated, we just simply wait for its completion in blk_mq_drain_queue().
>>
>> Even for non-MQ case, looks blk_queue_dying(q) is checked to avoid
>> being freed early before running queue, I am not sure if it is good
>> because the I/O might or can have been completed.  And it isn't a problem
>> for MQ because this request can't be reused when dying is set.
>
> Good.  I think we'll want comments like that preferable in the code, but
> at very least in the commit log.

OK.


Thanks,
-- 
Ming Lei
