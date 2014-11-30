Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaK3MEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:04:47 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaK3MEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:04:45 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] UBI: Fastmap: Fix race after ubi_wl_get_peb()
Date: Sun, 30 Nov 2014 13:04:26 +0100
Message-Id: <1417349070-8894-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349070-8894-1-git-send-email-richard@nod.at>
References: <1417349070-8894-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubi_wl_get_peb() returns a fresh PEB which can be used by
user of UBI. Due to the pool logic fastmap will correctly
map this PEB upon attach time because it will be scanned.

If a new fastmap is written (due to heavy parallel io)
while the before the fresh PEB is assigned to the EBA table
it will not be scanned as it is no longer in the pool.
So, the race window exists between ubi_wl_get_peb()
and the EBA table assignment.
We have to make sure that no new fastmap can be written
while that.

To ensure that ubi_wl_get_peb() will grab ubi->fm_sem in read mode
and the user of ubi_wl_get_peb() has to release it after the PEB
got assigned.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c | 24 ++++++++++++++++++------
 drivers/mtd/ubi/wl.c  |  7 +++++++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 4164a5c..e8e0565 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -510,6 +510,7 @@ retry:
 	new_pnum = ubi_wl_get_peb(ubi);
 	if (new_pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
+		up_read(&ubi->fm_sem);
 		return new_pnum;
 	}
 
@@ -520,13 +521,16 @@ retry:
 	if (err && err != UBI_IO_BITFLIPS) {
 		if (err > 0)
 			err = -EIO;
+		up_read(&ubi->fm_sem);
 		goto out_put;
 	}
 
 	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
-	if (err)
+	if (err) {
+		up_read(&ubi->fm_sem);
 		goto write_error;
+	}
 
 	data_size = offset + len;
 	mutex_lock(&ubi->buf_mutex);
@@ -535,8 +539,10 @@ retry:
 	/* Read everything before the area where the write failure happened */
 	if (offset > 0) {
 		err = ubi_io_read_data(ubi, ubi->peb_buf, pnum, 0, offset);
-		if (err && err != UBI_IO_BITFLIPS)
+		if (err && err != UBI_IO_BITFLIPS) {
+			up_read(&ubi->fm_sem);
 			goto out_unlock;
+		}
 	}
 
 	memcpy(ubi->peb_buf + offset, buf, len);
@@ -544,13 +550,13 @@ retry:
 	err = ubi_io_write_data(ubi, ubi->peb_buf, new_pnum, 0, data_size);
 	if (err) {
 		mutex_unlock(&ubi->buf_mutex);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
 	mutex_unlock(&ubi->buf_mutex);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 
-	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = new_pnum;
 	up_read(&ubi->fm_sem);
 	ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
@@ -647,6 +653,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
+		up_read(&ubi->fm_sem);
 		return pnum;
 	}
 
@@ -657,6 +664,7 @@ retry:
 	if (err) {
 		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -665,11 +673,11 @@ retry:
 		if (err) {
 			ubi_warn(ubi, "failed to write %d bytes at offset %d of LEB %d:%d, PEB %d",
 				 len, offset, vol_id, lnum, pnum);
+			up_read(&ubi->fm_sem);
 			goto write_error;
 		}
 	}
 
-	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
 
@@ -768,6 +776,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
+		up_read(&ubi->fm_sem);
 		return pnum;
 	}
 
@@ -778,6 +787,7 @@ retry:
 	if (err) {
 		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -785,11 +795,11 @@ retry:
 	if (err) {
 		ubi_warn(ubi, "failed to write %d bytes of data to PEB %d",
 			 len, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] < 0);
-	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
 
@@ -886,6 +896,7 @@ retry:
 	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		err = pnum;
+		up_read(&ubi->fm_sem);
 		goto out_leb_unlock;
 	}
 
@@ -896,6 +907,7 @@ retry:
 	if (err) {
 		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -903,10 +915,10 @@ retry:
 	if (err) {
 		ubi_warn(ubi, "failed to write %d bytes of data to PEB %d",
 			 len, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
-	down_read(&ubi->fm_sem);
 	old_pnum = vol->eba_tbl[lnum];
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7821342..f2ca6a0 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -644,6 +644,7 @@ void ubi_refill_pools(struct ubi_device *ubi)
 
 /* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
  * the fastmap pool.
+ * Returns with ubi->fm_sem held in read mode!
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
@@ -652,16 +653,20 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
 again:
+	down_read(&ubi->fm_sem);
 	spin_lock(&ubi->wl_lock);
 	/* We check here also for the WL pool because at this point we can
 	 * refill the WL pool synchronous. */
 	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
 		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_sem);
 		ret = ubi_update_fastmap(ubi);
 		if (ret) {
 			ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
+			down_read(&ubi->fm_sem);
 			return -ENOSPC;
 		}
+		down_read(&ubi->fm_sem);
 		spin_lock(&ubi->wl_lock);
 	}
 
@@ -673,6 +678,7 @@ again:
 			goto out;
 		}
 		retried = 1;
+		up_read(&ubi->fm_sem);
 		goto again;
 	}
 
@@ -728,6 +734,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	spin_lock(&ubi->wl_lock);
 	peb = wl_get_peb(ubi);
 	spin_unlock(&ubi->wl_lock);
+	down_read(&ubi->fm_sem);
 
 	if (peb < 0)
 		return peb;
-- 
1.8.4.5

