Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaJ2Ms1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:48:27 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbaJ2MqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:24 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 27/35] UBI: Fastmap: Locking updates
Date: Wed, 29 Oct 2014 13:45:50 +0100
Message-Id: <1414586758-9972-28-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) Rename ubi->fm_sem to ubi->fm_eba_sem as this semaphore
protects EBA changes.
b) Turn ubi->fm_mutex into a rw semaphore. It will still serialize
fastmap writes but also ensures that ubi_wl_put_peb() is not
interrupted by a fastmap write. We use a rw semaphore to allow
ubi_wl_put_peb() still to be executed in parallel if no fastmap
write is happening.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c   |  4 ++--
 drivers/mtd/ubi/eba.c     | 44 ++++++++++++++++++++++----------------------
 drivers/mtd/ubi/fastmap.c | 18 +++++++++---------
 drivers/mtd/ubi/ubi.h     |  9 +++++----
 drivers/mtd/ubi/wl.c      | 17 +++++++++++------
 5 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a047bb4..813143a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -969,8 +969,8 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	mutex_init(&ubi->ckvol_mutex);
 	mutex_init(&ubi->device_mutex);
 	spin_lock_init(&ubi->volumes_lock);
-	mutex_init(&ubi->fm_mutex);
-	init_rwsem(&ubi->fm_sem);
+	init_rwsem(&ubi->fm_protect);
+	init_rwsem(&ubi->fm_eba_sem);
 
 	ubi_msg("attaching mtd%d to ubi%d", mtd->index, ubi_num);
 
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 2f41e53..1d0b453 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -340,9 +340,9 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 
 	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);
 
-	down_read(&ubi->fm_sem);
+	down_read(&ubi->fm_eba_sem);
 	vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 	err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 0);
 
 out_unlock:
@@ -510,7 +510,7 @@ retry:
 	new_pnum = ubi_wl_get_peb(ubi);
 	if (new_pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		return new_pnum;
 	}
 
@@ -520,14 +520,14 @@ retry:
 	if (err && err != UBI_IO_BITFLIPS) {
 		if (err > 0)
 			err = -EIO;
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto out_put;
 	}
 
 	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
 	if (err) {
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
@@ -539,7 +539,7 @@ retry:
 	if (offset > 0) {
 		err = ubi_io_read_data(ubi, ubi->peb_buf, pnum, 0, offset);
 		if (err && err != UBI_IO_BITFLIPS) {
-			up_read(&ubi->fm_sem);
+			up_read(&ubi->fm_eba_sem);
 			goto out_unlock;
 		}
 	}
@@ -549,7 +549,7 @@ retry:
 	err = ubi_io_write_data(ubi, ubi->peb_buf, new_pnum, 0, data_size);
 	if (err) {
 		mutex_unlock(&ubi->buf_mutex);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
@@ -557,7 +557,7 @@ retry:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 
 	vol->eba_tbl[lnum] = new_pnum;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 	ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 
 	ubi_msg("data was successfully recovered");
@@ -652,7 +652,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		return pnum;
 	}
 
@@ -663,7 +663,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
@@ -672,13 +672,13 @@ retry:
 		if (err) {
 			ubi_warn("failed to write %d bytes at offset %d of LEB %d:%d, PEB %d",
 				 len, offset, vol_id, lnum, pnum);
-			up_read(&ubi->fm_sem);
+			up_read(&ubi->fm_eba_sem);
 			goto write_error;
 		}
 	}
 
 	vol->eba_tbl[lnum] = pnum;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -775,7 +775,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		return pnum;
 	}
 
@@ -786,7 +786,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
@@ -794,13 +794,13 @@ retry:
 	if (err) {
 		ubi_warn("failed to write %d bytes of data to PEB %d",
 			 len, pnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] < 0);
 	vol->eba_tbl[lnum] = pnum;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 
 	leb_write_unlock(ubi, vol_id, lnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
@@ -895,7 +895,7 @@ retry:
 	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		err = pnum;
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto out_leb_unlock;
 	}
 
@@ -906,7 +906,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
@@ -914,13 +914,13 @@ retry:
 	if (err) {
 		ubi_warn("failed to write %d bytes of data to PEB %d",
 			 len, pnum);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		goto write_error;
 	}
 
 	old_pnum = vol->eba_tbl[lnum];
 	vol->eba_tbl[lnum] = pnum;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 
 	if (old_pnum >= 0) {
 		err = ubi_wl_put_peb(ubi, vol_id, lnum, old_pnum, 0);
@@ -1173,9 +1173,9 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] == from);
-	down_read(&ubi->fm_sem);
+	down_read(&ubi->fm_eba_sem);
 	vol->eba_tbl[lnum] = to;
-	up_read(&ubi->fm_sem);
+	up_read(&ubi->fm_eba_sem);
 
 out_unlock_buf:
 	mutex_unlock(&ubi->buf_mutex);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index e563366..9a8cf45 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -874,7 +874,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	__be32 crc, tmp_crc;
 	unsigned long long sqnum = 0;
 
-	mutex_lock(&ubi->fm_mutex);
+	down_write(&ubi->fm_protect);
 	memset(ubi->fm_buf, 0, ubi->fm_size);
 
 	fmsb = kmalloc(sizeof(*fmsb), GFP_KERNEL);
@@ -1064,7 +1064,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	ubi_free_vid_hdr(ubi, vh);
 	kfree(ech);
 out:
-	mutex_unlock(&ubi->fm_mutex);
+	up_write(&ubi->fm_protect);
 	if (ret == UBI_BAD_FASTMAP)
 		ubi_err("Attach by fastmap failed, doing a full scan!");
 	return ret;
@@ -1432,24 +1432,24 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
 
-	mutex_lock(&ubi->fm_mutex);
+	down_write(&ubi->fm_protect);
 
 	ubi_refill_pools(ubi);
 
 	if (ubi->ro_mode || ubi->fm_disabled) {
-		mutex_unlock(&ubi->fm_mutex);
+		up_write(&ubi->fm_protect);
 		return 0;
 	}
 
 	ret = ubi_ensure_anchor_pebs(ubi);
 	if (ret) {
-		mutex_unlock(&ubi->fm_mutex);
+		up_write(&ubi->fm_protect);
 		return ret;
 	}
 
 	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
 	if (!new_fm) {
-		mutex_unlock(&ubi->fm_mutex);
+		up_write(&ubi->fm_protect);
 		return -ENOMEM;
 	}
 
@@ -1539,16 +1539,16 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	down_write(&ubi->work_sem);
-	down_write(&ubi->fm_sem);
+	down_write(&ubi->fm_eba_sem);
 	ret = ubi_write_fastmap(ubi, new_fm);
-	up_write(&ubi->fm_sem);
+	up_write(&ubi->fm_eba_sem);
 	up_write(&ubi->work_sem);
 
 	if (ret)
 		goto err;
 
 out_unlock:
-	mutex_unlock(&ubi->fm_mutex);
+	up_write(&ubi->fm_protect);
 	kfree(old_fm);
 	return ret;
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 0392366..9a37fe3 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -425,10 +425,11 @@ struct ubi_debug_info {
  * @fm_pool: in-memory data structure of the fastmap pool
  * @fm_wl_pool: in-memory data structure of the fastmap pool used by the WL
  *		sub-system
- * @fm_mutex: serializes ubi_update_fastmap() and protects @fm_buf
+ * @fm_protect: serializes ubi_update_fastmap(), protects @fm_buf and makes sure
+ * that critical sections cannot be interrupted by ubi_update_fastmap()
  * @fm_buf: vmalloc()'d buffer which holds the raw fastmap
  * @fm_size: fastmap size in bytes
- * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
+ * @fm_eba_sem: allows ubi_update_fastmap() to block EBA table changes
  * @fm_work: fastmap work queue
  * @fm_work_scheduled: non-zero if fastmap work was scheduled
  *
@@ -532,8 +533,8 @@ struct ubi_device {
 	struct ubi_fastmap_layout *fm;
 	struct ubi_fm_pool fm_pool;
 	struct ubi_fm_pool fm_wl_pool;
-	struct rw_semaphore fm_sem;
-	struct mutex fm_mutex;
+	struct rw_semaphore fm_eba_sem;
+	struct rw_semaphore fm_protect;
 	void *fm_buf;
 	size_t fm_size;
 	struct work_struct fm_work;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index fbe9b5c..ea3c79e 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -628,7 +628,7 @@ void ubi_refill_pools(struct ubi_device *ubi)
 
 /* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
  * the fastmap pool.
- * Returns with ubi->fm_sem held in read mode!
+ * Returns with ubi->fm_eba_sem held in read mode!
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
@@ -637,19 +637,19 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
 again:
-	down_read(&ubi->fm_sem);
+	down_read(&ubi->fm_eba_sem);
 	spin_lock(&ubi->wl_lock);
 	if (!pool->size || !wl_pool->size || pool->used >= pool->size ||
 	    wl_pool->used >= wl_pool->size) {
 		spin_unlock(&ubi->wl_lock);
-		up_read(&ubi->fm_sem);
+		up_read(&ubi->fm_eba_sem);
 		ret = ubi_update_fastmap(ubi);
 		if (ret) {
 			ubi_msg("Unable to write a new fastmap: %i", ret);
-			down_read(&ubi->fm_sem);
+			down_read(&ubi->fm_eba_sem);
 			return -ENOSPC;
 		}
-		down_read(&ubi->fm_sem);
+		down_read(&ubi->fm_eba_sem);
 		spin_lock(&ubi->wl_lock);
 	}
 
@@ -726,7 +726,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 		return err;
 	}
 
-	down_read(&ubi->fm_sem);
+	down_read(&ubi->fm_eba_sem);
 	return peb;
 }
 #endif
@@ -1602,6 +1602,8 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 	ubi_assert(pnum >= 0);
 	ubi_assert(pnum < ubi->peb_count);
 
+	down_read(&ubi->fm_protect);
+
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
@@ -1632,6 +1634,7 @@ retry:
 		ubi_assert(!ubi->move_to_put);
 		ubi->move_to_put = 1;
 		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_protect);
 		return 0;
 	} else {
 		if (in_wl_tree(e, &ubi->used)) {
@@ -1653,6 +1656,7 @@ retry:
 				ubi_err("PEB %d not found", pnum);
 				ubi_ro_mode(ubi);
 				spin_unlock(&ubi->wl_lock);
+				up_read(&ubi->fm_protect);
 				return err;
 			}
 		}
@@ -1666,6 +1670,7 @@ retry:
 		spin_unlock(&ubi->wl_lock);
 	}
 
+	up_read(&ubi->fm_protect);
 	return err;
 }
 
-- 
1.8.4.5

