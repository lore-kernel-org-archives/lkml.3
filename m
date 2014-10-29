Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaJ2Owc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:52:32 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaJ2Ow3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:52:29 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Subject: [PATCH 1/2] UBI: Implement UBI_METAONLY
Date: Wed, 29 Oct 2014 15:52:17 +0100
Message-Id: <1414594338-14695-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBI_METAONLY is a new open mode for UBI volumes, it indicates
that only meta data is being changed.
Meta data in terms of UBI volumes means data which is stored in the
UBI volume table but not on the volume itself.
While it does not interfere with UBI_READONLY and UBI_READWRITE
it is not allowed to use UBI_METAONLY together with UBI_EXCLUSIVE.

Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Andrew Murray <amurray@embedded-bits.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/cdev.c  |  8 +++++---
 drivers/mtd/ubi/kapi.c  | 15 +++++++++++++--
 drivers/mtd/ubi/ubi.h   |  5 ++++-
 include/linux/mtd/ubi.h |  4 +++-
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 59de69a..5f01edd 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -60,13 +60,13 @@ static int get_exclusive(struct ubi_volume_desc *desc)
 	struct ubi_volume *vol = desc->vol;
 
 	spin_lock(&vol->ubi->volumes_lock);
-	users = vol->readers + vol->writers + vol->exclusive;
+	users = vol->readers + vol->writers + vol->exclusive + vol->metaonly;
 	ubi_assert(users > 0);
 	if (users > 1) {
 		ubi_err("%d users for volume %d", users, vol->vol_id);
 		err = -EBUSY;
 	} else {
-		vol->readers = vol->writers = 0;
+		vol->readers = vol->writers = vol->metaonly = 0;
 		vol->exclusive = 1;
 		err = desc->mode;
 		desc->mode = UBI_EXCLUSIVE;
@@ -86,13 +86,15 @@ static void revoke_exclusive(struct ubi_volume_desc *desc, int mode)
 	struct ubi_volume *vol = desc->vol;
 
 	spin_lock(&vol->ubi->volumes_lock);
-	ubi_assert(vol->readers == 0 && vol->writers == 0);
+	ubi_assert(vol->readers == 0 && vol->writers == 0 && vol->metaonly == 0);
 	ubi_assert(vol->exclusive == 1 && desc->mode == UBI_EXCLUSIVE);
 	vol->exclusive = 0;
 	if (mode == UBI_READONLY)
 		vol->readers = 1;
 	else if (mode == UBI_READWRITE)
 		vol->writers = 1;
+	else if (mode == UBI_METAONLY)
+		vol->metaonly = 1;
 	else
 		vol->exclusive = 1;
 	spin_unlock(&vol->ubi->volumes_lock);
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 3aac1ac..8599690 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -137,7 +137,7 @@ struct ubi_volume_desc *ubi_open_volume(int ubi_num, int vol_id, int mode)
 		return ERR_PTR(-EINVAL);
 
 	if (mode != UBI_READONLY && mode != UBI_READWRITE &&
-	    mode != UBI_EXCLUSIVE)
+	    mode != UBI_EXCLUSIVE && mode != UBI_METAONLY)
 		return ERR_PTR(-EINVAL);
 
 	/*
@@ -182,10 +182,17 @@ struct ubi_volume_desc *ubi_open_volume(int ubi_num, int vol_id, int mode)
 		break;
 
 	case UBI_EXCLUSIVE:
-		if (vol->exclusive || vol->writers || vol->readers)
+		if (vol->exclusive || vol->writers || vol->readers ||
+		    vol->metaonly)
 			goto out_unlock;
 		vol->exclusive = 1;
 		break;
+
+	case UBI_METAONLY:
+		if (vol->metaonly || vol->exclusive)
+			goto out_unlock;
+		vol->metaonly = 1;
+		break;
 	}
 	get_device(&vol->dev);
 	vol->ref_count += 1;
@@ -343,6 +350,10 @@ void ubi_close_volume(struct ubi_volume_desc *desc)
 		break;
 	case UBI_EXCLUSIVE:
 		vol->exclusive = 0;
+		break;
+	case UBI_METAONLY:
+		vol->metaonly = 0;
+		break;
 	}
 	vol->ref_count -= 1;
 	spin_unlock(&ubi->volumes_lock);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 320fc38..c991a09 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -260,6 +260,7 @@ struct ubi_fm_pool {
  * @readers: number of users holding this volume in read-only mode
  * @writers: number of users holding this volume in read-write mode
  * @exclusive: whether somebody holds this volume in exclusive mode
+ * @metaonly: whether somebody is altering only meta data of this volume
  *
  * @reserved_pebs: how many physical eraseblocks are reserved for this volume
  * @vol_type: volume type (%UBI_DYNAMIC_VOLUME or %UBI_STATIC_VOLUME)
@@ -308,6 +309,7 @@ struct ubi_volume {
 	int readers;
 	int writers;
 	int exclusive;
+	int metaonly;
 
 	int reserved_pebs;
 	int vol_type;
@@ -389,7 +391,8 @@ struct ubi_debug_info {
  * @volumes_lock: protects @volumes, @rsvd_pebs, @avail_pebs, beb_rsvd_pebs,
  *                @beb_rsvd_level, @bad_peb_count, @good_peb_count, @vol_count,
  *                @vol->readers, @vol->writers, @vol->exclusive,
- *                @vol->ref_count, @vol->mapping and @vol->eba_tbl.
+ *                @vol->metaonly, @vol->ref_count, @vol->mapping and
+ *                @vol->eba_tbl.
  * @ref_count: count of references on the UBI device
  * @image_seq: image sequence number recorded on EC headers
  *
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index c3918a0..82b693f 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -34,11 +34,13 @@
  * UBI_READONLY: read-only mode
  * UBI_READWRITE: read-write mode
  * UBI_EXCLUSIVE: exclusive mode
+ * UBI_METAONLY: modify voulme meta data only
  */
 enum {
 	UBI_READONLY = 1,
 	UBI_READWRITE,
-	UBI_EXCLUSIVE
+	UBI_EXCLUSIVE,
+	UBI_METAONLY
 };
 
 /**
-- 
1.8.4.5

