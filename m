Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967701Ab3HICLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:11:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967660Ab3HIB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [ 061/102] zram: use zram->lock to protect zram_free_page() in swap free notify path
Date: Thu,  8 Aug 2013 18:57:37 -0700
Message-Id: <20130809015024.585003988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/zram/zram_drv.c |    2 ++
 drivers/staging/zram/zram_drv.h |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -582,7 +582,9 @@ static void zram_slot_free_notify(struct
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -93,8 +93,9 @@ struct zram_meta {
 struct zram {
 	struct zram_meta *meta;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers and table
-				   * against concurrent read and writes */
+	struct rw_semaphore lock; /* protect compression buffers, table,
+				   * 32bit stat counters against concurrent
+				   * notifications, reads and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;


