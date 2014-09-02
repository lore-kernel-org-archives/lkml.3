Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaIBRBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaIBRBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:01:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<5405EF48.9070601@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Sep 2014 13:01:07 -0400
In-Reply-To: <5405EF48.9070601@kernel.dk> (Jens Axboe's message of "Tue, 02
	Sep 2014 10:24:40 -0600")
Message-ID: <x498um26jos.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 09/02/2014 09:02 AM, Ming Lei wrote:
>> QUEUE_FLAG_NO_SG_MERGE is set at default for blk-mq devices,
>> so bio->bi_phys_segment computed may be bigger than
>> queue_max_segments(q) for blk-mq devices, then drivers will
>> fail to handle the case, for example, BUG_ON() in
>> virtio_queue_rq() can be triggerd for virtio-blk:
>> 
>> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1359146
>> 
>> This patch fixes the issue by ignoring the QUEUE_FLAG_NO_SG_MERGE
>> flag if the computed bio->bi_phys_segment is bigger than
>> queue_max_segments(q), and the regression is caused by commit
>> 05f1dd53152173(block: add queue flag for disabling SG merging).
>> 
>> Reported-by: Kick In <pierre-andre.morey@canonical.com>
>> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>
> Thanks Ming, this looks nice and clean. Will apply for 3.17.

This sounds an awful lot like the bug I fixed in dm:

commit 200612ec33e555a356eebc717630b866ae2b694f
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Fri Aug 8 11:03:41 2014 -0400

    dm table: propagate QUEUE_FLAG_NO_SG_MERGE
    
    Commit 05f1dd5 ("block: add queue flag for disabling SG merging")
    introduced a new queue flag: QUEUE_FLAG_NO_SG_MERGE.  This gets set by
    default in blk_mq_init_queue for mq-enabled devices.  The effect of
    the flag is to bypass the SG segment merging.  Instead, the
    bio->bi_vcnt is used as the number of hardware segments.
    
    With a device mapper target on top of a device with
    QUEUE_FLAG_NO_SG_MERGE set, we can end up sending down more segments
    than a driver is prepared to handle.  I ran into this when backporting
    the virtio_blk mq support.  It triggerred this BUG_ON, in
    virtio_queue_rq:
    
            BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);

    ...

Is bcache a stacking driver in this case?  Should it not inherit this
flag, just as DM now does?

-Jeff
