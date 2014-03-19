Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbaCSO6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:58:05 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964878AbaCSO6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:58:03 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: block: Avoid disk size integer overflow
Date: Wed, 19 Mar 2014 15:57:54 +0100
Message-Id: <1395241074-15506-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the issue that on very large UBI volumes
UBI block does not work correctly.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/block.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 9ef7df7..8887d4b 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -379,7 +379,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 {
 	struct ubiblock *dev;
 	struct gendisk *gd;
-	int disk_capacity;
+	u64 disk_capacity;
 	int ret;
 
 	/* Check that the volume isn't already handled */
@@ -413,7 +413,12 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	gd->first_minor = dev->ubi_num * UBI_MAX_VOLUMES + dev->vol_id;
 	gd->private_data = dev;
 	sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
-	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
+	disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
+	if ((sector_t)disk_capacity != disk_capacity) {
+		ubi_err("block: disk capacity %llu too large", disk_capacity);
+		ret = -E2BIG;
+		goto out_free_dev;
+	}
 	set_capacity(gd, disk_capacity);
 	dev->gd = gd;
 
@@ -500,7 +505,7 @@ int ubiblock_remove(struct ubi_volume_info *vi)
 static void ubiblock_resize(struct ubi_volume_info *vi)
 {
 	struct ubiblock *dev;
-	int disk_capacity;
+	u64 disk_capacity;
 
 	/*
 	 * Need to lock the device list until we stop using the device,
@@ -515,7 +520,13 @@ static void ubiblock_resize(struct ubi_volume_info *vi)
 	}
 
 	mutex_lock(&dev->dev_mutex);
-	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
+	disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
+	if ((sector_t)disk_capacity != disk_capacity) {
+		ubi_err("block: disk capacity %llu too large", disk_capacity);
+		mutex_unlock(&dev->dev_mutex);
+		mutex_unlock(&devices_mutex);
+		return;
+	}
 	set_capacity(dev->gd, disk_capacity);
 	ubi_msg("%s resized to %d LEBs", dev->gd->disk_name, vi->size);
 	mutex_unlock(&dev->dev_mutex);
-- 
1.8.1.4

