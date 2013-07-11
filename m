Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3GKOyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:54:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42813 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3GKOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/98] zram: use zram->lock to protect zram_free_page() in swap free notify path
Date: Thu, 11 Jul 2013 15:23:32 +0100
Message-Id: <1373552708-15235-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 57ab048532c0d975538cebd4456491b5c34248f4 upstream.

zram_slot_free_notify() is free-running without any protection from
concurrent operations. So there are race conditions between
zram_bvec_read()/zram_bvec_write() and zram_slot_free_notify(),
and possible consequences include:
1) Trigger BUG_ON(!handle) on zram_bvec_write() side.
2) Access to freed pages on zram_bvec_read() side.
3) Break some fields (bad_compress, good_compress, pages_stored)
   in zram->stats if the swap layer makes concurrently call to
   zram_slot_free_notify().

So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
before calling zram_free_page().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 2 ++
 drivers/staging/zram/zram_drv.h | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 900f0ed..56797d9 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -692,7 +692,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index fbe8ac9..1047e82 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -107,8 +107,9 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers and table
-				   * against concurrent read and writes */
+	struct rw_semaphore lock; /* protect compression buffers, table,
+				   * 32bit stat counters against concurrent
+				   * notifications, reads and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
-- 
1.8.1.2

