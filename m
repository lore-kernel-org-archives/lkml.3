Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaCDKOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:14:40 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33825 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaCDKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:14:38 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] zram: move comp allocation out of init_lock
Date: Tue,  4 Mar 2014 13:10:56 +0300
Message-Id: <1393927856-23434-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.382.g7f3562c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing lockdep spew of ->init_lock reported by Sasha Levin [1], Minchan
Kim noted [2] that it's better to move compression backend allocation (using
GPF_KERNEL) out of the ->init_lock lock, same way as with zram_meta_alloc(),
in order to prevent the same lockdep spew.

[1] https://lkml.org/lkml/2014/2/27/337
[2] https://lkml.org/lkml/2014/3/3/32

Cc: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 15d46f2..e4d536b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -580,9 +580,10 @@ static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
+	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err;
+	int err = -EINVAL;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -593,30 +594,32 @@ static ssize_t disksize_store(struct device *dev,
 	if (!meta)
 		return -ENOMEM;
 
+	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
+	if (!comp) {
+		pr_info("Cannot initialise %s compressing backend\n",
+				zram->compressor);
+		goto out_cleanup;
+	}
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
+		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		err = -EBUSY;
-		goto out_free_meta;
-	}
-
-	zram->comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!zram->comp) {
-		pr_info("Cannot initialise %s compressing backend\n",
-				zram->compressor);
-		err = -EINVAL;
-		goto out_free_meta;
+		goto out_cleanup;
 	}
 
 	zram->meta = meta;
+	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
 
 	return len;
 
-out_free_meta:
-	up_write(&zram->init_lock);
+out_cleanup:
+	if (comp)
+		zcomp_destroy(comp);
 	zram_meta_free(meta);
 	return err;
 }
-- 
1.9.0.382.g7f3562c

