Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaHKBLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaHKBLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:11:12 -0400
Date: Sun, 10 Aug 2014 21:11:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: dm: propagate QUEUE_FLAG_NO_SG_MERGE
Message-ID: <20140811011108.GA13946@redhat.com>
References: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08 2014 at 11:03am -0400,
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> Commit 05f1dd5 introduced a new queue flag: QUEUE_FLAG_NO_SG_MERGE.
> This gets set by default in blk_mq_init_queue for mq-enabled devices.
> The effect of the flag is to bypass the SG segment merging.  Instead,
> the bio->bi_vcnt is used as the number of hardware segments.
> 
> With a device mapper target on top of a device with
> QUEUE_FLAG_NO_SG_MERGE set, we can end up sending down more segments
> than a driver is prepared to handle.  I ran into this when backporting
> the virtio_blk mq support.  It triggerred this BUG_ON, in
> virtio_queue_rq:
> 
>         BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
> 
> The queue's max is set here:
>         blk_queue_max_segments(q, vblk->sg_elems-2);
> 
> Basically, what happens is that a bio is built up for the dm device
> (which does not have the QUEUE_FLAG_NO_SG_MERGE flag set) using
> bio_add_page.  That path will call into __blk_recalc_rq_segments, so
> what you end up with is bi_phys_segments being much smaller than bi_vcnt
> (and bi_vcnt grows beyond the maximum sg elements).  Then, when the bio
> is submitted, it gets cloned.  When the cloned bio is submitted, it will
> end up in blk_recount_segments, here:
> 
>         if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags))
>                 bio->bi_phys_segments = bio->bi_vcnt;
> 
> and now we've set bio->bi_phys_segments to a number that is beyond what
> was registered as queue_max_segments by the driver.
> 
> The right way to fix this is to propagate the queue flag up the stack.
> Attached is a patch that does this, tested and confirmed to fix the
> problem in my environment.
> 
> The rules for propagating the flag are simple:
> - if the flag is set for any underlying device, it must be set for the
>   upper device
> - consequently, if the flag is not set for any underlying device, it
>   should not be set for the upper device.

Hi Jeff,

Thanks for the patch.  But I think you need the following tweak.
Otherwise if the DM table is reloaded (and the devices in the table
happen to change) the flag won't get cleared as needed.

I've folded this in and staged it in linux-next for 3.17 here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=200612ec33e555a356eebc717630b866ae2b694f

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index feedafd..f9c6cb8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1509,7 +1509,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
-	if (!dm_table_all_devices_attribute(t, queue_supports_sg_merge))
+	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
+		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
 	dm_table_set_integrity(t);
