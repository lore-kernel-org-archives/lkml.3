Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab3GKOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:53:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab3GKOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 03/98] zram: destroy all devices on error recovery path in zram_init()
Date: Thu, 11 Jul 2013 15:23:33 +0100
Message-Id: <1373552708-15235-4-git-send-email-luis.henriques@canonical.com>
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

commit 39a9b8ac9333e4268ecff7da6c9d1ab3823ff243 upstream.

On error recovery path of zram_init(), it leaks the zram device object
causing the failure. So change create_device() to free allocated
resources on error path.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 56797d9..7860762 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -705,7 +705,7 @@ static const struct block_device_operations zram_devops = {
 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -715,7 +715,6 @@ static int create_device(struct zram *zram, int device_id)
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -725,11 +724,9 @@ static int create_device(struct zram *zram, int device_id)
 	 /* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
-		blk_cleanup_queue(zram->queue);
 		pr_warning("Error allocating disk structure for device %d\n",
 			device_id);
-		ret = -ENOMEM;
-		goto out;
+		goto out_free_queue;
 	}
 
 	zram->disk->major = zram_major;
@@ -758,11 +755,17 @@ static int create_device(struct zram *zram, int device_id)
 				&zram_disk_attr_group);
 	if (ret < 0) {
 		pr_warning("Error creating sysfs group");
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

