Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaH0DER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 23:04:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37629 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaH0DEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 23:04:15 -0400
X-AuditID: cbfee61b-f79f86d00000144c-8b-53fd4aac07e9
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: [PATCH v4] zram: add num_{discard_req, discarded} for discard stat
Date: Wed, 27 Aug 2014 11:02:51 +0800
Message-id: <000401cfc1a3$938f3620$baada260$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/BoXYi4D/n5CU8QFuLBLOZDO/zfA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd21Xn+DDebfZbKYs34Nm8WpP9eZ
	LC7vmsNmcW/Nf1aLZV/fs1tsaJnFbrH282N2B3aPnbPusntsWtXJ5rHp0yR2jxMzfrN4vN93
	lc1j56fNrB6fN8kFsEdx2aSk5mSWpRbp2yVwZfy7/pGxoEOvYu7M6awNjNPVuhg5OSQETCTu
	tG1mh7DFJC7cW8/WxcjFISSwiFHi5fmNrCAJIYEfjBKLml1AbDYBFYnlHf+ZQGwRoIbHX36w
	gzQwC9xglLj58xhYg7CAt8TFPavZQGwWAVWJ1lvXweK8ApYSM66+ZoOwBSV+TL7HAmIzC2hJ
	bN7WxAphy0tsXvOWGeIiBYkdZ18zdjFyAC3Tk5hxsgyiRFxi45FbLBMYBWYhmTQLyaRZSCbN
	QtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwRDyT3sG4qsHiEKMAB6MSD++HBX+C
	hVgTy4orcw8xSnAwK4nwZhr/DRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7
	NbUgtQgmy8TBKdXAqLRNbelMmy+JGjua+Y30yliPPK0v1yzse8e8U9/86v0XnOtEtK2XS16u
	fxAkHJzrdN9iz4mw7dOX/LuUZBU37YOgtFbg6Xin1g8XNnxx4dV4l8Um4xsnkpSVMV+fJdf2
	9P5j72as/v724PX4pZ77HE4Lnm5hVyvfXC2wYu+pY0pT9nkULPutqcRSnJFoqMVcVJwIALBE
	NbyEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have supported handling discard request in this commit
f4659d8e620d08bd1a84a8aec5d2f5294a242764 (zram: support REQ_DISCARD), zram got
one more chance to free unused memory whenever received discard request. But
without stating for discard request, there is no method for user to know whether
discard request has been handled by zram or how many blocks were discarded by
zram when user wants to know the effect of discard.

In this patch, we add num_discard_req to stat discard request and add
num_discarded to stat real discarded blocks, and export them to sysfs for users.

* From v1
 * Update zram document to show num_discards in statistics list.

* From v2
 * Update description of this patch with clear goal.

* From v3
 * Stat discard request and discarded pages separately as "previous stat
   indicates lots of free page discarded without real freeing, so the stat makes
   our user's misunderstanding" pointed out by Minchan Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 17 +++++++++++++++++
 Documentation/blockdev/zram.txt            |  2 ++
 drivers/block/zram/zram_drv.c              | 17 ++++++++++++++---
 drivers/block/zram/zram_drv.h              |  2 ++
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index 70ec992..805fb11 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -57,6 +57,23 @@ Description:
 		The failed_writes file is read-only and specifies the number of
 		failed writes happened on this device.
 
+What:		/sys/block/zram<id>/num_discard_req
+Date:		August 2014
+Contact:	Chao Yu <chao2.yu@samsung.com>
+Description:
+		The num_discard_req file is read-only and specifies the number
+		of requests received by this device. These requests are sent by
+		swap layer or filesystem when they want to free blocks which are
+		no longer used.
+
+What:		/sys/block/zram<id>/num_discarded
+Date:		August 2014
+Contact:	Chao Yu <chao2.yu@samsung.com>
+Description:
+		The num_discarded file is read-only and specifies the number of
+		real discarded blocks (pages which are really freed) in this
+		device after discard request is sent to this device.
+
 What:		/sys/block/zram<id>/max_comp_streams
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 0595c3f..f9c1e41 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -89,6 +89,8 @@ size of the disk when not in use so a huge zram is wasteful.
 		num_writes
 		failed_reads
 		failed_writes
+		num_discard_req
+		num_discarded
 		invalid_io
 		notify_free
 		zero_pages
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00831c..1d012e8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -322,7 +322,7 @@ static void handle_zero_page(struct bio_vec *bvec)
  * caller should hold this table index entry's bit_spinlock to
  * indicate this index entry is accessing.
  */
-static void zram_free_page(struct zram *zram, size_t index)
+static bool zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
@@ -336,7 +336,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 			zram_clear_flag(meta, index, ZRAM_ZERO);
 			atomic64_dec(&zram->stats.zero_pages);
 		}
-		return;
+		return false;
 	}
 
 	zs_free(meta->mem_pool, handle);
@@ -347,6 +347,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	meta->table[index].handle = 0;
 	zram_set_obj_size(meta, index, 0);
+	return true;
 }
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
@@ -603,12 +604,18 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 	}
 
 	while (n >= PAGE_SIZE) {
+		bool discarded;
+
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-		zram_free_page(zram, index);
+		discarded = zram_free_page(zram, index);
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		if (discarded)
+			atomic64_inc(&zram->stats.num_discarded);
 		index++;
 		n -= PAGE_SIZE;
 	}
+
+	atomic64_inc(&zram->stats.num_discard_req);
 }
 
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
@@ -866,6 +873,8 @@ ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
 ZRAM_ATTR_RO(failed_writes);
+ZRAM_ATTR_RO(num_discard_req);
+ZRAM_ATTR_RO(num_discarded);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -879,6 +888,8 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
+	&dev_attr_num_discard_req.attr,
+	&dev_attr_num_discarded.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index e0f725c..49f91aa 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -86,6 +86,8 @@ struct zram_stats {
 	atomic64_t num_writes;	/* --do-- */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
+	atomic64_t num_discard_req;	/* no. of discard req */
+	atomic64_t num_discarded;	/* no. of discarded pages */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t zero_pages;		/* no. of zero filled pages */
-- 
2.0.1.474.g72c7794


