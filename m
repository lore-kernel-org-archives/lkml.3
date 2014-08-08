Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaHHPDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbaHHPDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:03:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [patch] dm: propagate QUEUE_FLAG_NO_SG_MERGE
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 08 Aug 2014 11:03:41 -0400
Message-ID: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 05f1dd5 introduced a new queue flag: QUEUE_FLAG_NO_SG_MERGE.
This gets set by default in blk_mq_init_queue for mq-enabled devices.
The effect of the flag is to bypass the SG segment merging.  Instead,
the bio->bi_vcnt is used as the number of hardware segments.

With a device mapper target on top of a device with
QUEUE_FLAG_NO_SG_MERGE set, we can end up sending down more segments
than a driver is prepared to handle.  I ran into this when backporting
the virtio_blk mq support.  It triggerred this BUG_ON, in
virtio_queue_rq:

        BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);

The queue's max is set here:
        blk_queue_max_segments(q, vblk->sg_elems-2);

Basically, what happens is that a bio is built up for the dm device
(which does not have the QUEUE_FLAG_NO_SG_MERGE flag set) using
bio_add_page.  That path will call into __blk_recalc_rq_segments, so
what you end up with is bi_phys_segments being much smaller than bi_vcnt
(and bi_vcnt grows beyond the maximum sg elements).  Then, when the bio
is submitted, it gets cloned.  When the cloned bio is submitted, it will
end up in blk_recount_segments, here:

        if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags))
                bio->bi_phys_segments = bio->bi_vcnt;

and now we've set bio->bi_phys_segments to a number that is beyond what
was registered as queue_max_segments by the driver.

The right way to fix this is to propagate the queue flag up the stack.
Attached is a patch that does this, tested and confirmed to fix the
problem in my environment.

The rules for propagating the flag are simple:
- if the flag is set for any underlying device, it must be set for the
  upper device
- consequently, if the flag is not set for any underlying device, it
  should not be set for the upper device.

stable notes: this patch should be applied to 3.16.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5f59f1e..bf756d1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1386,6 +1386,14 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
+static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
+}
+
 static bool dm_table_all_devices_attribute(struct dm_table *t,
 					   iterate_devices_callout_fn func)
 {
@@ -1464,6 +1472,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
+	if (!dm_table_all_devices_attribute(t, queue_supports_sg_merge))
+		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+
 	dm_table_set_integrity(t);
 
 	/*
