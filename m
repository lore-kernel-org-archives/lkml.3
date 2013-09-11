Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3IKFgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3IKE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:18 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=B2QDAs-ebCQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AZWWye9eAjYA:10 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=8SAKUi76_zsWZGGfOE4A:9 a=MSl-tDqOz04A:10 a=hPjdaMEvmhQA:10 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.812241843@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [147/251] zram: destroy all devices on error recovery path in zram_init()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0147-zram-destroy-all-devices-on-error-recovery-path-in-z.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

[ Upstream commit 39a9b8ac9333e4268ecff7da6c9d1ab3823ff243 ]

On error recovery path of zram_init(), it leaks the zram device object
causing the failure. So change create_device() to free allocated
resources on error path.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_drv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 4322baf..5047bfe 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -635,7 +635,7 @@ static const struct block_device_operations zram_devops = {
 
 static int create_device(struct zram *zram, int device_id)
 {
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
@@ -645,7 +645,6 @@ static int create_device(struct zram *zram, int device_id)
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -655,11 +654,9 @@ static int create_device(struct zram *zram, int device_id)
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
@@ -688,11 +685,17 @@ static int create_device(struct zram *zram, int device_id)
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
1.7.10.4


