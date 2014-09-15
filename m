Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaIOUn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:43:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbaIOTgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.16 151/158] dm table: propagate QUEUE_FLAG_NO_SG_MERGE
Date: Mon, 15 Sep 2014 12:26:30 -0700
Message-Id: <20140915192547.394737184@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 200612ec33e555a356eebc717630b866ae2b694f upstream.

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

The rules for propagating the flag are simple:
- if the flag is set for any underlying device, it must be set for the
  upper device
- consequently, if the flag is not set for any underlying device, it
  should not be set for the upper device.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1386,6 +1386,14 @@ static int device_is_not_random(struct d
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
@@ -1464,6 +1472,11 @@ void dm_table_set_restrictions(struct dm
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
+	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
+		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+
 	dm_table_set_integrity(t);
 
 	/*


