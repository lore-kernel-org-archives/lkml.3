Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3LSBMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:12:20 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34588 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LSBMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:12:18 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk
Cc: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] bcache/md: Use raid stripe size
Date: Wed, 18 Dec 2013 17:12:11 -0800
Message-Id: <1387415531-10713-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got code for raid5/6 stripe awareness, bcache just needs
to know about the stripes and when writing partial stripes is expensive
- we probably don't want to enable this optimization for raid1 or 10,
even though they have stripes. So add a flag to queue_limits.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
This is in my pile of bcache stuff queued up for 3.14 - if no one objects it'll
be in my bcache pull request:

 drivers/md/bcache/super.c | 6 ++++++
 drivers/md/raid5.c        | 1 +
 include/linux/blkdev.h    | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 63ebef78df..e363efcf2b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1134,6 +1134,12 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 		hlist_add_head(&io->hash, dc->io_hash + RECENT_IO);
 	}
 
+	dc->disk.stripe_size = q->limits.io_opt >> 9;
+
+	if (dc->disk.stripe_size)
+		dc->partial_stripes_expensive =
+			q->limits.raid_partial_stripes_expensive;
+
 	ret = bcache_device_init(&dc->disk, block_size,
 			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
 	if (ret)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bef353c51c..4b5035f286 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6104,6 +6104,7 @@ static int run(struct mddev *mddev)
 		blk_queue_io_min(mddev->queue, chunk_size);
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks - conf->max_degraded));
+		mddev->queue->limits.raid_partial_stripes_expensive = 1;
 		/*
 		 * We can only discard a whole stripe. It doesn't make sense to
 		 * discard data disk but write parity disk
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 02cb6f0ea7..0375654adb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -291,6 +291,7 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
 	unsigned char		discard_zeroes_data;
+	unsigned char		raid_partial_stripes_expensive;
 };
 
 struct request_queue {
-- 
1.8.5.1

