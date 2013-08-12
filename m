Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3HLL2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:28:13 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:41482 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755785Ab3HLL2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:28:09 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2013 07:28:09 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 7A7DF7F481
Authentication-Results: shelob.oktetlabs.ru/7A7DF7F481; dkim=none
	(no signature) header.i=unknown; dkim-adsp=none
From: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>
To: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>
Subject: [PATCH 1/1] ubi: remove and create MTD device back when UBI volume is resized
Date: Mon, 12 Aug 2013 15:17:45 +0400
Message-Id: <1376306265-8671-1-git-send-email-Andrew.Rybchenko@oktetlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If underlying MTD device size is simply corrected (as it was before),
MTD block device is not notified about MTD device size change. As the
result, for example, mount fails after create with zero size, resize,
write file system image.

Side effect of the patch is change of MTD device number on resize/update.

Signed-off-by: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>
---
 drivers/mtd/ubi/gluebi.c |   64 +++++-----------------------------------------
 1 file changed, 7 insertions(+), 57 deletions(-)

diff --git a/drivers/mtd/ubi/gluebi.c b/drivers/mtd/ubi/gluebi.c
index b93807b..fa4f764 100644
--- a/drivers/mtd/ubi/gluebi.c
+++ b/drivers/mtd/ubi/gluebi.c
@@ -403,60 +403,6 @@ static int gluebi_remove(struct ubi_volume_info *vi)
 }
 
 /**
- * gluebi_updated - UBI volume was updated notifier.
- * @vi: volume info structure
- *
- * This function is called every time an UBI volume is updated. It does nothing
- * if te volume @vol is dynamic, and changes MTD device size if the
- * volume is static. This is needed because static volumes cannot be read past
- * data they contain. This function returns zero in case of success and a
- * negative error code in case of error.
- */
-static int gluebi_updated(struct ubi_volume_info *vi)
-{
-	struct gluebi_device *gluebi;
-
-	mutex_lock(&devices_mutex);
-	gluebi = find_gluebi_nolock(vi->ubi_num, vi->vol_id);
-	if (!gluebi) {
-		mutex_unlock(&devices_mutex);
-		err_msg("got update notification for unknown UBI device %d volume %d",
-			vi->ubi_num, vi->vol_id);
-		return -ENOENT;
-	}
-
-	if (vi->vol_type == UBI_STATIC_VOLUME)
-		gluebi->mtd.size = vi->used_bytes;
-	mutex_unlock(&devices_mutex);
-	return 0;
-}
-
-/**
- * gluebi_resized - UBI volume was re-sized notifier.
- * @vi: volume info structure
- *
- * This function is called every time an UBI volume is re-size. It changes the
- * corresponding fake MTD device size. This function returns zero in case of
- * success and a negative error code in case of error.
- */
-static int gluebi_resized(struct ubi_volume_info *vi)
-{
-	struct gluebi_device *gluebi;
-
-	mutex_lock(&devices_mutex);
-	gluebi = find_gluebi_nolock(vi->ubi_num, vi->vol_id);
-	if (!gluebi) {
-		mutex_unlock(&devices_mutex);
-		err_msg("got update notification for unknown UBI device %d volume %d",
-			vi->ubi_num, vi->vol_id);
-		return -ENOENT;
-	}
-	gluebi->mtd.size = vi->used_bytes;
-	mutex_unlock(&devices_mutex);
-	return 0;
-}
-
-/**
  * gluebi_notify - UBI notification handler.
  * @nb: registered notifier block
  * @l: notification type
@@ -475,10 +421,14 @@ static int gluebi_notify(struct notifier_block *nb, unsigned long l,
 		gluebi_remove(&nt->vi);
 		break;
 	case UBI_VOLUME_RESIZED:
-		gluebi_resized(&nt->vi);
-		break;
 	case UBI_VOLUME_UPDATED:
-		gluebi_updated(&nt->vi);
+		/*
+		 * In theory it could be possible to simply change MTD device
+		 * size, but it would require a way to notify
+		 * corresponding block device as well.
+		 */
+		gluebi_remove(&nt->vi);
+		gluebi_create(&nt->di, &nt->vi);
 		break;
 	default:
 		break;
-- 
1.7.10.4

