Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaKTTBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:01:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbaKTTBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:01:37 -0500
Date: Thu, 20 Nov 2014 14:00:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        hch@infradead.org, mst@redhat.com, rusty@rustcorp.com.au,
        dm-devel@redhat.com
Subject: [PATCH] virtio_blk: fix defaults for max_hw_sectors and
 max_segment_size
Message-ID: <20141120190058.GA31214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_blk incorrectly established -1U as the default for these
queue_limits.  Set these limits to sane default values to avoid crashing
the kernel.  But the virtio-blk protocol should probably be extended to
allow proper stacking of the disk's limits from the host.

This change fixes a crash that was reported when virtio-blk was used to
test linux-dm.git commit 604ea90641b4 ("dm thin: adjust max_sectors_kb
based on thinp blocksize") that will initially set max_sectors to
max_hw_sectors and then rounddown to the first power-of-2 factor of the
DM thin-pool's blocksize.  Basically that commit assumes drivers don't
suck when establishing max_hw_sectors so it acted like a canary in the
coal mine.

In the case of a DM thin-pool built ontop of virtio-blk data device
these are the insane limits that were established for the DM thin-pool:

  # cat /sys/block/dm-6/queue/max_sectors_kb
  1073741824
  # cat /sys/block/dm-6/queue/max_hw_sectors_kb
  2147483647

by stacking the virtio-blk device's limits:

  # cat /sys/block/vdb/queue/max_sectors_kb
  512
  # cat /sys/block/vdb/queue/max_hw_sectors_kb
  2147483647

Attempting to mkfs.xfs against a thin device from this thin-pool quickly
resulted in fs/direct-io.c:dio_send_cur_page()'s BUG_ON.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/block/virtio_blk.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c6a27d5..68efbdc 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -674,8 +674,11 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* No need to bounce any requests */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 
-	/* No real sector limit. */
-	blk_queue_max_hw_sectors(q, -1U);
+	/*
+	 * Limited by disk's max_hw_sectors in host, but
+	 * without that info establish a sane default.
+	 */
+	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
 
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
@@ -684,7 +687,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	if (!err)
 		blk_queue_max_segment_size(q, v);
 	else
-		blk_queue_max_segment_size(q, -1U);
+		blk_queue_max_segment_size(q, BLK_MAX_SEGMENT_SIZE);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
-- 
1.7.4.4

