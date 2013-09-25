Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3IYAvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:51:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3IYATt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jiang Liu <jiang.liu@huawei.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [ 007/117] zram: fix invalid memory access
Date: Tue, 24 Sep 2013 17:17:53 -0700
Message-Id: <20130925001741.663589370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit 2b86ab9cc29fcd435cde9378c3b9ffe8b5c76128 upstream.

[1] tried to fix invalid memory access on zram->disk but it didn't
fix properly because get_disk failed during module exit path.

Actually, we don't need to reset zram->disk's capacity to zero
in module exit path so that this patch introduces new argument
"reset_capacity" on zram_reset_divice and it only reset it when
reset_store is called.

[1] 6030ea9b,  zram: avoid invalid memory access in zram_exit()

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -522,7 +522,7 @@ static int zram_bvec_rw(struct zram *zra
 	return ret;
 }
 
-static void zram_reset_device(struct zram *zram)
+static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
 	struct zram_meta *meta;
@@ -551,7 +551,8 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	set_capacity(zram->disk, 0);
+	if (reset_capacity)
+		set_capacity(zram->disk, 0);
 	up_write(&zram->init_lock);
 }
 
@@ -635,7 +636,7 @@ static ssize_t reset_store(struct device
 	if (bdev)
 		fsync_bdev(bdev);
 
-	zram_reset_device(zram);
+	zram_reset_device(zram, true);
 	return len;
 }
 
@@ -902,10 +903,12 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
-		get_disk(zram->disk);
 		destroy_device(zram);
-		zram_reset_device(zram);
-		put_disk(zram->disk);
+		/*
+		 * Shouldn't access zram->disk after destroy_device
+		 * because destroy_device already released zram->disk.
+		 */
+		zram_reset_device(zram, false);
 	}
 
 	unregister_blkdev(zram_major, "zram");


