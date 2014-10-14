Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaJNKEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:04:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45663 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbaJNKEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:04:21 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 2/4] md: add flush_idx support for stacked devices
Date: Tue, 14 Oct 2014 14:03:53 +0400
Message-Id: <1413281035-6483-3-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For single device mapping it is safe to introduce get_flush_idx conception.
This cover most common case linear mapping for a single dev.

CC: Alasdair Kergon <agk@redhat.com>
CC: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..042d172 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1843,6 +1843,36 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 	return r;
 }
 
+static int dm_iter_get_flush_idx(struct dm_target *ti,
+				struct dm_dev *dev, sector_t start,
+				sector_t len, void *data)
+{
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return blk_get_flush_idx(q,  *((bool *)data));
+}
+
+static unsigned dm_get_flush_idx(struct request_queue *q, bool queued)
+{
+	struct dm_target *ti;
+	struct mapped_device *md = q->queuedata;
+	struct dm_table *map = dm_get_live_table_fast(md);
+	unsigned fid = 0;
+
+	if (unlikely(!map || dm_table_get_num_targets(map) != 1))
+		goto out;
+
+	ti = dm_table_get_target(map, 0);
+	if (unlikely(!ti || !ti->type->iterate_devices))
+		goto out;
+
+	fid = ti->type->iterate_devices(ti, dm_iter_get_flush_idx, &queued);
+out:
+	dm_put_live_table_fast(md);
+	return fid;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -1962,6 +1992,7 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad_queue;
 
 	dm_init_md_queue(md);
+	blk_queue_get_flush_idx(md->queue, dm_get_flush_idx);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
-- 
1.7.1

