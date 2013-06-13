Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3FMUZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:25:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34237 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3FMUZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:25:07 -0400
Message-ID: <51BA2A9E.2070905@gmail.com>
Date: Thu, 13 Jun 2013 22:25:02 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: Set the logical block size to a sensible value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preserve the backing device's logical size, use 512 byte
sectors when there is no backing device.

The logical block size has no impact on performance, but
it alters the meaning of on-disk structures like partition
tables.  Preserve the backing device's sector size to keep
bcache transparent, and use 512 byte sectors like everyone
else when no backing device is present.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 drivers/md/bcache/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1e3bc4c..94fad70 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -745,11 +745,12 @@ static void bcache_device_free(struct bcache_device *d)
 		bioset_free(d->bio_split);
 
 	closure_debug_destroy(&d->cl);
 }
 
-static int bcache_device_init(struct bcache_device *d, unsigned block_size)
+static int bcache_device_init(struct bcache_device *d, unsigned block_size,
+			      unsigned logical_size)
 {
 	struct request_queue *q;
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
 	    !(d->unaligned_bvec = mempool_create_kmalloc_pool(1,
@@ -774,11 +775,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 	q->limits.max_sectors		= UINT_MAX;
 	q->limits.max_segment_size	= UINT_MAX;
 	q->limits.max_segments		= BIO_MAX_PAGES;
 	q->limits.max_discard_sectors	= UINT_MAX;
 	q->limits.io_min		= block_size;
-	q->limits.logical_block_size	= block_size;
+	q->limits.logical_block_size	= logical_size;
 	q->limits.physical_block_size	= block_size;
 	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
 
 	return 0;
@@ -1064,11 +1065,11 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 	for (io = dc->io; io < dc->io + RECENT_IO; io++) {
 		list_add(&io->lru, &dc->io_lru);
 		hlist_add_head(&io->hash, dc->io_hash + RECENT_IO);
 	}
 
-	ret = bcache_device_init(&dc->disk, block_size);
+	ret = bcache_device_init(&dc->disk, block_size, q->limits.logical_block_size);
 	if (ret)
 		return ret;
 
 	set_capacity(dc->disk.disk,
 		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
@@ -1163,11 +1164,11 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	closure_init(&d->cl, NULL);
 	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
 
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
-	if (bcache_device_init(d, block_bytes(c)))
+	if (bcache_device_init(d, block_bytes(c), 512))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
 	set_capacity(d->disk, u->sectors);
 	bch_flash_dev_request_init(d);
-- 
1.8.3.222.g430da9e

