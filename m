Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaHTJUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:20:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHTJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:20:05 -0400
From: Colin King <colin.king@canonical.com>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: ezequiel.garcia@free-electrons.com, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] UBI: block: fix dereference on uninitialized dev
Date: Wed, 20 Aug 2014 10:19:38 +0100
Message-Id: <1408526378-12972-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 4df38926f337 ("UBI: block: Avoid disk size integer overflow")
introduced a dereference on dev (which is not initialized at that
point) when printing a warning message.  Re-order disk_capacity check
after the dev is found.

Found by cppcheck:
 [drivers/mtd/ubi/block.c:509]: (error) Uninitialized variable: dev

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/mtd/ubi/block.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 33c6495..7a9805a 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -504,11 +504,6 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 	struct ubiblock *dev;
 	u64 disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
 
-	if ((sector_t)disk_capacity != disk_capacity) {
-		ubi_warn("%s: the volume is too big, cannot resize (%d LEBs)",
-			 dev->gd->disk_name, vi->size);
-		return -EFBIG;
-	}
 	/*
 	 * Need to lock the device list until we stop using the device,
 	 * otherwise the device struct might get released in
@@ -520,6 +515,12 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 		mutex_unlock(&devices_mutex);
 		return -ENODEV;
 	}
+	if ((sector_t)disk_capacity != disk_capacity) {
+		mutex_unlock(&devices_mutex);
+		ubi_warn("%s: the volume is too big, cannot resize (%d LEBs)",
+			dev->gd->disk_name, vi->size);
+		return -EFBIG;
+	}
 
 	mutex_lock(&dev->dev_mutex);
 	set_capacity(dev->gd, disk_capacity);
-- 
2.1.0

