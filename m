Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3IKFgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:36:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3IKE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=soAccpzBKCgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=g8gM5mogDLoA:10 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=geoZPReg1UnzQyajuMYA:9 a=MSl-tDqOz04A:10 a=hPjdaMEvmhQA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=xzBpS61pBPIHkZr6:21 a=HP5eGXHrFAa8TZB6:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.643722187@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [146/251] zram: use zram->lock to protect zram_free_page() in swap free notify
 path
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0146-zram-use-zram-lock-to-protect-zram_free_page-in-swap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

[ Upstream commit 57ab048532c0d975538cebd4456491b5c34248f4 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_drv.c |    2 ++
 drivers/staging/zram/zram_drv.h |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 38a1b44..4322baf 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -622,7 +622,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 572c0b1..a6eb5d9 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -92,8 +92,9 @@ struct zram {
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
1.7.10.4


