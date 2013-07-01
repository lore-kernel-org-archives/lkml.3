Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3GABMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:12:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45260 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752160Ab3GABMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:43 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] cdrom: Remove prototype for open_for_data
Date: Sun, 30 Jun 2013 18:11:59 -0700
Message-Id: <ec9c1e56de2309573a4ef455ee0183337d17b9a5.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move static function to the appropriate place to remove
the now unnecessary prototype.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 114 +++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e7efa99..72720d7 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -337,7 +337,6 @@ do {							\
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
 static void sanitize_format(union cdrom_addr *addr, 
@@ -957,63 +956,8 @@ static int cdrom_close_write(struct cdrom_device_info *cdi)
 #endif
 }
 
-/* We use the open-option O_NONBLOCK to indicate that the
- * purpose of opening is only for subsequent ioctl() calls; no device
- * integrity checks are performed.
- *
- * We hope that all cd-player programs will adopt this convention. It
- * is in their own interest: device control becomes a lot easier
- * this way.
- */
-int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t mode)
-{
-	int ret;
-
-	cd_dbg(CD_OPEN, "entering cdrom_open\n");
-
-	/* open is event synchronization point, check events first */
-	check_disk_change(bdev);
-
-	/* if this was a O_NONBLOCK open and we should honor the flags,
-	 * do a quick open without drive/disc integrity checks. */
-	cdi->use_count++;
-	if ((mode & FMODE_NDELAY) && (cdi->options & CDO_USE_FFLAGS)) {
-		ret = cdi->ops->open(cdi, 1);
-	} else {
-		ret = open_for_data(cdi);
-		if (ret)
-			goto err;
-		cdrom_mmc3_profile(cdi);
-		if (mode & FMODE_WRITE) {
-			ret = -EROFS;
-			if (cdrom_open_write(cdi))
-				goto err_release;
-			if (!CDROM_CAN(CDC_RAM))
-				goto err_release;
-			ret = 0;
-			cdi->media_written = 0;
-		}
-	}
-
-	if (ret)
-		goto err;
-
-	cd_dbg(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
-	       cdi->name, cdi->use_count);
-	return 0;
-err_release:
-	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
-		cdi->ops->lock_door(cdi, 0);
-		cd_dbg(CD_OPEN, "door unlocked\n");
-	}
-	cdi->ops->release(cdi);
-err:
-	cdi->use_count--;
-	return ret;
-}
-
 static
-int open_for_data(struct cdrom_device_info * cdi)
+int open_for_data(struct cdrom_device_info *cdi)
 {
 	int ret;
 	struct cdrom_device_ops *cdo = cdi->ops;
@@ -1119,6 +1063,62 @@ clean_up_and_return:
 	return ret;
 }
 
+/* We use the open-option O_NONBLOCK to indicate that the
+ * purpose of opening is only for subsequent ioctl() calls; no device
+ * integrity checks are performed.
+ *
+ * We hope that all cd-player programs will adopt this convention. It
+ * is in their own interest: device control becomes a lot easier
+ * this way.
+ */
+int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
+	       fmode_t mode)
+{
+	int ret;
+
+	cd_dbg(CD_OPEN, "entering cdrom_open\n");
+
+	/* open is event synchronization point, check events first */
+	check_disk_change(bdev);
+
+	/* if this was a O_NONBLOCK open and we should honor the flags,
+	 * do a quick open without drive/disc integrity checks. */
+	cdi->use_count++;
+	if ((mode & FMODE_NDELAY) && (cdi->options & CDO_USE_FFLAGS)) {
+		ret = cdi->ops->open(cdi, 1);
+	} else {
+		ret = open_for_data(cdi);
+		if (ret)
+			goto err;
+		cdrom_mmc3_profile(cdi);
+		if (mode & FMODE_WRITE) {
+			ret = -EROFS;
+			if (cdrom_open_write(cdi))
+				goto err_release;
+			if (!CDROM_CAN(CDC_RAM))
+				goto err_release;
+			ret = 0;
+			cdi->media_written = 0;
+		}
+	}
+
+	if (ret)
+		goto err;
+
+	cd_dbg(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
+	       cdi->name, cdi->use_count);
+	return 0;
+err_release:
+	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
+		cdi->ops->lock_door(cdi, 0);
+		cd_dbg(CD_OPEN, "door unlocked\n");
+	}
+	cdi->ops->release(cdi);
+err:
+	cdi->use_count--;
+	return ret;
+}
+
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
 */
-- 
1.8.1.2.459.gbcd45b4.dirty

