Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaEEAFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:31 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:48634 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974AbaEEAFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1544:1605:1711:1730:1747:1777:1792:2393:2559:2562:2693:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6261:9592:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fire61_2ea7fa7920913
X-Filterd-Recvd-Size: 5070
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] cdrom: Remove prototype for open_for_data
Date: Sun,  4 May 2014 17:05:05 -0700
Message-Id: <6652632559434a6ffab9836f9217a664d0bd54c4.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
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
index 47dee5e..5a38b56 100644
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

