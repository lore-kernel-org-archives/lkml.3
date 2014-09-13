Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaIMDxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 23:53:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41218 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaIMDwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 23:52:50 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Chao Yu <chao2.yu@samsung.com>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2] zram: use notify_free to account all free notifications
Date: Sat, 13 Sep 2014 12:52:14 +0900
Message-Id: <1410580334-8429-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.1.0.251.ga182987
In-Reply-To: <1410580334-8429-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1410580334-8429-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

notify_free device attribute accounts the number of slot free notifications
and internally represents the number of zram_free_page() calls. Slot free
notifications are sent only when device is used as a swap device, hence
notify_free is used only for swap devices. Since f4659d8e620d08 (zram:
support REQ_DISCARD) ZRAM handles yet another one free notification (also
via zram_free_page() call) -- REQ_DISCARD requests, which are sent by a
filesystem, whenever some data blocks are discarded. However, there is no
way to know the number of notifications in the latter case.

Change zram_free_page() to return a bool status, indicating if zs_free()
has happened. So we can use `notify_free' to account the number of pages
freed by zram_bio_discard() and zram_slot_free_notify().

This means that depending on usage scenario `notify_free' represents:
 a) the number of pages freed because of slot free notifications, which is
   equal to the number of swap_slot_free_notify() calls, so there is no
   behaviour change

 b) the number of pages freed because of REQ_DISCARD notifications

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 13 ++++++++-----
 drivers/block/zram/zram_drv.c              | 12 +++++++-----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index b13dc99..a6148ea 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -77,11 +77,14 @@ What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
 Description:
-		The notify_free file is read-only and specifies the number of
-		swap slot free notifications received by this device. These
-		notifications are sent to a swap block device when a swap slot
-		is freed. This statistic is applicable only when this disk is
-		being used as a swap disk.
+		The notify_free file is read-only. Depending on device usage
+		scenario it may account a) the number of pages freed because
+		of swap slot free notifications or b) the number of pages freed
+		because of REQ_DISCARD requests sent by bio. The former ones
+		are sent to a swap block device when a swap slot is freed, which
+		implies that this disk is being used as a swap disk. The latter
+		ones are sent by filesystem mounted with discard option,
+		whenever some data blocks are getting discarded.
 
 What:		/sys/block/zram<id>/zero_pages
 Date:		August 2010
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d78b245..03d11d5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -388,7 +388,7 @@ static void handle_zero_page(struct bio_vec *bvec)
  * caller should hold this table index entry's bit_spinlock to
  * indicate this index entry is accessing.
  */
-static void zram_free_page(struct zram *zram, size_t index)
+static bool zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
@@ -402,7 +402,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 			zram_clear_flag(meta, index, ZRAM_ZERO);
 			atomic64_dec(&zram->stats.zero_pages);
 		}
-		return;
+		return false;
 	}
 
 	zs_free(meta->mem_pool, handle);
@@ -413,6 +413,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	meta->table[index].handle = 0;
 	zram_set_obj_size(meta, index, 0);
+	return true;
 }
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
@@ -696,7 +697,8 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 
 	while (n >= PAGE_SIZE) {
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-		zram_free_page(zram, index);
+		if (zram_free_page(zram, index))
+			atomic64_inc(&zram->stats.notify_free);
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		index++;
 		n -= PAGE_SIZE;
@@ -936,9 +938,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	meta = zram->meta;
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-	zram_free_page(zram, index);
+	if (zram_free_page(zram, index))
+		atomic64_inc(&zram->stats.notify_free);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
-- 
2.1.0.251.ga182987

