Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaIEG0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:26:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEG0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <87bnquk4fe.fsf@rustcorp.com.au>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<20140902162146.GA28741@infradead.org>
	<5405EF38.60007@kernel.dk>
	<20140903121902.7a9f5a5a@tom-ThinkPad-T410>
	<87bnquk4fe.fsf@rustcorp.com.au>
Date: Fri, 5 Sep 2014 14:26:19 +0800
Message-ID: <CACVXFVPeGvmv_hSz+_+1Wj3DuUMtQiE-zjq6_fLZveiHH3NuUw@mail.gmail.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
From: Ming Lei <ming.lei@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 1:43 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Ming Lei <ming.lei@canonical.com> writes:
>> On Tue, 02 Sep 2014 10:24:24 -0600
>> Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> On 09/02/2014 10:21 AM, Christoph Hellwig wrote:
>>> > Btw, one thing we should reconsider is where we set
>>> > QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
>>> > doing the S/G merge should be a lot cheaper than fanning out into the
>>> > indirect descriptors.
>>
>> Indirect is always considered first no matter SG merge is off or on,
>> at least from current virtio-blk implementation.
>>
>> But it is a good idea to try direct descriptor first, the below simple
>> change can improve randread(libaio, O_DIRECT, multi-queue) 7% in my test,
>> and 77% transfer starts to use direct descriptor, and almost all transfer
>> uses indirect descriptor only in current upstream implementation.
>
> Hi Ming!
>
>         In general, we want to use direct descriptors of we have plenty
> of descriptors, and indirect if the ring is going to fill up.  I was
> thinking about this just yesterday, in fact.

I thought about the idea further and looks it isn't mature at least for
virtio-blk:

- the queue num is a bit small, for example 128 returned from QEMU
- so it is easy to exhaust all direct descriptors, and queue has to be
stopped

My previous test is based on null_blk which is quite fast so no
above problem.

IMO, there are at least two advantages by using indirect descriptors:

- queue won't be stopped because descriptor is enough(may not be true
for other virtio devices, like virtio-net, rx traffic is difficult to predict)
- good cache utilization because all descriptors are put together

The main problem is the extra kmalloc(), which might be
improved by a memory pool.

>
> I've been trying to use EWMA to figure out how full the ring gets, but

How full should have been figured out by num_free?

> so far it's not working well.  I'm still hacking on a solution though,
> and your thoughts would be welcome.

I am wondering if it is easy to predict how many transfers will be coming
with some mathematics model. My concern is that the cost caused by
stopping queue may overwhelm advantage from using direct descriptor.


Thanks,
