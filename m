Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaIEM5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:57:52 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50434 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaIEM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:57:51 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Chao Yu <chao2.yu@samsung.com>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: use notify_free to account all free notifications
Date: Fri,  5 Sep 2014 21:57:09 +0900
Message-Id: <1409921829-12261-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.1.0.134.gb1ae451
In-Reply-To: <1409921829-12261-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1409921829-12261-1-git-send-email-sergey.senozhatsky@gmail.com>
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

Use notify_free to account the number of pages freed in zram_free_page(),
instead of accounting only swap_slot_free_notify() calls (each
zram_slot_free_notify() call frees one page).

This means that depending on usage scenario notify_free represents:
 a) the number of pages freed because of slot free notifications, which is
   equal to the number of swap_slot_free_notify() calls, so there is no
   behaviour change

 b) the number of pages freed because of REQ_DISCARD notifications

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 13 ++++++++-----
 drivers/block/zram/zram_drv.c              |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

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
index d78b245..bc20fe1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -410,6 +410,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 	atomic64_sub(zram_get_obj_size(meta, index),
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
+	atomic64_inc(&zram->stats.notify_free);
 
 	meta->table[index].handle = 0;
 	zram_set_obj_size(meta, index, 0);
@@ -938,7 +939,6 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
-- 
2.1.0.134.gb1ae451

