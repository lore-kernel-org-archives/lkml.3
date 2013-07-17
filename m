Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428Ab3GQXhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab3GQWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/145] zram: destroy all devices on error recovery path in zram_init()
Date: Wed, 17 Jul 2013 15:45:43 -0700
Message-Id: <1374101277-7915-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 39a9b8ac9333e4268ecff7da6c9d1ab3823ff243 upstream.

On error recovery path of zram_init(), it leaks the zram device object
causing the failure. So change create_device() to free allocated
resources on error path.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 0113897..ff2228e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -628,7 +628,7 @@ static const struct block_device_operations zram_devops = {
 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -638,7 +638,6 @@ static int create_device(struct zram *zram, int device_id)
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -648,11 +647,9 @@ static int create_device(struct zram *zram, int device_id)
 	 /* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
-		blk_cleanup_queue(zram->queue);
 		pr_warn("Error allocating disk structure for device %d\n",
 			device_id);
-		ret = -ENOMEM;
-		goto out;
+		goto out_free_queue;
 	}
 
 	zram->disk->major = zram_major;
@@ -681,11 +678,17 @@ static int create_device(struct zram *zram, int device_id)
 				&zram_disk_attr_group);
 	if (ret < 0) {
 		pr_warn("Error creating sysfs group");
-		goto out;
+		goto out_free_disk;
 	}
 
 	zram->init_done = 0;
+	return 0;
 
+out_free_disk:
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
+out_free_queue:
+	blk_cleanup_queue(zram->queue);
 out:
 	return ret;
 }
-- 
1.8.1.2

