Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab3HICKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:10:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967489Ab3HIB7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [ 062/102] zram: destroy all devices on error recovery path in zram_init()
Date: Thu,  8 Aug 2013 18:57:38 -0700
Message-Id: <20130809015024.824968565@linuxfoundation.org>
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

commit 39a9b8ac9333e4268ecff7da6c9d1ab3823ff243 upstream.

On error recovery path of zram_init(), it leaks the zram device object
causing the failure. So change create_device() to free allocated
resources on error path.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -595,7 +595,7 @@ static const struct block_device_operati
 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -605,7 +605,6 @@ static int create_device(struct zram *zr
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -615,11 +614,9 @@ static int create_device(struct zram *zr
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
@@ -648,11 +645,17 @@ static int create_device(struct zram *zr
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


