Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaAMLTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:19:45 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38384 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAMLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:38 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 7/7] zram: remove unnecessary lock
Date: Mon, 13 Jan 2014 20:19:02 +0900
Message-Id: <1389611942-15544-8-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read/write lock's performance is really bad compared to
mutex_lock in write most workload.(AFAIR, recenlty there
were some effort to enhance it but not sure it got merged).

Anyway, we don't need such big granuarity read-write lock
any more so this patch replaces read/write lock with mutex.

CPU 12
iozone -t -T -l 12 -u 12 -r 16K -s 60M -I +Z -V 0

==Initial  write        ==Initial  write
records:   10           records:   10
avg:       516189.16    avg:       839907.96
std:       22486.53     std:       47902.17
max:       546970.60    max:       909910.35
min:       481131.54    min:       751148.38
==Rewrite  ==Rewrite
records:   10           records:   10
avg:       509527.98    avg:       1050156.37
std:       45799.94     std:       40695.44
max:       611574.27    max:       1111929.26
min:       443679.95    min:       980409.62
==Read     ==Read
records:   10           records:   10
avg:       4408624.17   avg:       4472546.76
std:       281152.61    std:       163662.78
max:       4867888.66   max:       4727351.03
min:       4058347.69   min:       4126520.88
==Re-read  ==Re-read
records:   10           records:   10
avg:       4462147.53   avg:       4363257.75
std:       283546.11    std:       247292.63
max:       4912894.44   max:       4677241.75
min:       4131386.50   min:       4035235.84
==Reverse  Read         ==Reverse  Read
records:   10           records:   10
avg:       4565865.97   avg:       4485818.08
std:       313395.63    std:       248470.10
max:       5232749.16   max:       4789749.94
min:       4185809.62   min:       3963081.34
==Stride   read         ==Stride   read
records:   10           records:   10
avg:       4515981.80   avg:       4418806.01
std:       211192.32    std:       212837.97
max:       4889287.28   max:       4686967.22
min:       4210362.00   min:       4083041.84
==Random   read         ==Random   read
records:   10           records:   10
avg:       4410525.23   avg:       4387093.18
std:       236693.22    std:       235285.23
max:       4713698.47   max:       4669760.62
min:       4057163.62   min:       3952002.16
==Mixed    workload     ==Mixed    workload
records:   10           records:   10
avg:       243234.25    avg:       2818677.27
std:       28505.07     std:       195569.70
max:       288905.23    max:       3126478.11
min:       212473.16    min:       2484150.69
==Random   write        ==Random   write
records:   10           records:   10
avg:       555887.07    avg:       1053057.79
std:       70841.98     std:       35195.36
max:       683188.28    max:       1096125.73
min:       437299.57    min:       992481.93
==Pwrite   ==Pwrite
records:   10           records:   10
avg:       501745.93    avg:       810363.09
std:       16373.54     std:       19245.01
max:       518724.52    max:       833359.70
min:       464208.73    min:       765501.87
==Pread    ==Pread
records:   10           records:   10
avg:       4539894.60   avg:       4457680.58
std:       197094.66    std:       188965.60
max:       4877170.38   max:       4689905.53
min:       4226326.03   min:       4095739.72

Read side seem to be a bit slower than old but I believe it's not
bad deal if we consider increased performance of write side and
code readability.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++---------
 drivers/block/zram/zram_drv.h |  4 +---
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index f1a3c95..011e55d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -230,6 +230,7 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	}
 
 	rwlock_init(&meta->tb_lock);
+	mutex_init(&meta->buffer_lock);
 	return meta;
 
 free_table:
@@ -412,6 +413,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	bool locked = false;
 
 	page = bvec->bv_page;
 	src = meta->compress_buffer;
@@ -431,6 +433,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 	}
 
+	mutex_lock(&meta->buffer_lock);
+	locked = true;
 	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec)) {
@@ -457,7 +461,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
-
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
@@ -514,6 +517,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		atomic_inc(&zram->stats.good_compress);
 
 out:
+	if (locked)
+		mutex_unlock(&meta->buffer_lock);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
 
@@ -527,15 +532,10 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 {
 	int ret;
 
-	if (rw == READ) {
-		down_read(&zram->lock);
+	if (rw == READ)
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-		up_read(&zram->lock);
-	} else {
-		down_write(&zram->lock);
+	else
 		ret = zram_bvec_write(zram, bvec, index, offset);
-		up_write(&zram->lock);
-	}
 
 	return ret;
 }
@@ -808,7 +808,6 @@ static int create_device(struct zram *zram, int device_id)
 {
 	int ret = -ENOMEM;
 
-	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index d876300..ad8aa35 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -88,13 +88,11 @@ struct zram_meta {
 	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
+	struct mutex buffer_lock; /* protect compress buffers */
 };
 
 struct zram {
 	struct zram_meta *meta;
-	struct rw_semaphore lock; /* protect compression buffers,
-				   * reads and writes
-				   */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
-- 
1.8.4.3

