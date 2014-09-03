Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaICHj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:39:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaICHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:39:26 -0400
MIME-Version: 1.0
In-Reply-To: <x498um26jos.fsf@segfault.boston.devel.redhat.com>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<5405EF48.9070601@kernel.dk>
	<x498um26jos.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 3 Sep 2014 15:39:24 +0800
Message-ID: <CACVXFVMZ6q5p9sivnRDmCo4jCVK6CdH-a2jmeADQnjdKU97qEQ@mail.gmail.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
From: Ming Lei <ming.lei@canonical.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 1:01 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>
>> On 09/02/2014 09:02 AM, Ming Lei wrote:
>>> QUEUE_FLAG_NO_SG_MERGE is set at default for blk-mq devices,
>>> so bio->bi_phys_segment computed may be bigger than
>>> queue_max_segments(q) for blk-mq devices, then drivers will
>>> fail to handle the case, for example, BUG_ON() in
>>> virtio_queue_rq() can be triggerd for virtio-blk:
>>>
>>>      https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1359146
>>>
>>> This patch fixes the issue by ignoring the QUEUE_FLAG_NO_SG_MERGE
>>> flag if the computed bio->bi_phys_segment is bigger than
>>> queue_max_segments(q), and the regression is caused by commit
>>> 05f1dd53152173(block: add queue flag for disabling SG merging).
>>>
>>> Reported-by: Kick In <pierre-andre.morey@canonical.com>
>>> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
>>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>>
>> Thanks Ming, this looks nice and clean. Will apply for 3.17.
>
> This sounds an awful lot like the bug I fixed in dm:

Anyway block should respect max segments constraint even though
QUEUE_FLAG_NO_SG_MERGE is set, that is what this patch does.

>
> commit 200612ec33e555a356eebc717630b866ae2b694f
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Fri Aug 8 11:03:41 2014 -0400
>
>     dm table: propagate QUEUE_FLAG_NO_SG_MERGE
>
>     Commit 05f1dd5 ("block: add queue flag for disabling SG merging")
>     introduced a new queue flag: QUEUE_FLAG_NO_SG_MERGE.  This gets set by
>     default in blk_mq_init_queue for mq-enabled devices.  The effect of
>     the flag is to bypass the SG segment merging.  Instead, the
>     bio->bi_vcnt is used as the number of hardware segments.
>
>     With a device mapper target on top of a device with
>     QUEUE_FLAG_NO_SG_MERGE set, we can end up sending down more segments
>     than a driver is prepared to handle.  I ran into this when backporting
>     the virtio_blk mq support.  It triggerred this BUG_ON, in
>     virtio_queue_rq:
>
>             BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>
>     ...
>
> Is bcache a stacking driver in this case?  Should it not inherit this
> flag, just as DM now does?

IMO your patch might make things complicated because:

- max segment constraint is HW related thing, so DM/bcache shouldn't
have touched related flag

- it isn't good to let both DM and underlying device do SG merge or not
do SG merge, performance may hurt if both do SG merge.

So why not let driver and block-core handle it? If driver has max segment
constraint requirement, block core just meets its requirement like this patch.

Thanks,
