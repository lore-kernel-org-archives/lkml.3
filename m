Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbaJ2Mtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:49:33 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14401 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbaJ2MqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:23 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 25/35] UBI: Fastmap: Fix race after ubi_wl_get_peb()
Date: Wed, 29 Oct 2014 13:45:48 +0100
Message-Id: <1414586758-9972-26-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
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
 drivers/mtd/ubi/wl.c  |  6 ++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 04abe7f..2f41e53 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -510,6 +510,7 @@ retry:
 	new_pnum = ubi_wl_get_peb(ubi);
 	if (new_pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
+		up_read(&ubi->fm_sem);
 		return new_pnum;
 	}
 
@@ -519,13 +520,16 @@ retry:
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
@@ -534,8 +538,10 @@ retry:
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
@@ -543,13 +549,13 @@ retry:
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
@@ -646,6 +652,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
+		up_read(&ubi->fm_sem);
 		return pnum;
 	}
 
@@ -656,6 +663,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -664,11 +672,11 @@ retry:
 		if (err) {
 			ubi_warn("failed to write %d bytes at offset %d of LEB %d:%d, PEB %d",
 				 len, offset, vol_id, lnum, pnum);
+			up_read(&ubi->fm_sem);
 			goto write_error;
 		}
 	}
 
-	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
 
@@ -767,6 +775,7 @@ retry:
 	if (pnum < 0) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		leb_write_unlock(ubi, vol_id, lnum);
+		up_read(&ubi->fm_sem);
 		return pnum;
 	}
 
@@ -777,6 +786,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -784,11 +794,11 @@ retry:
 	if (err) {
 		ubi_warn("failed to write %d bytes of data to PEB %d",
 			 len, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
 	ubi_assert(vol->eba_tbl[lnum] < 0);
-	down_read(&ubi->fm_sem);
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
 
@@ -885,6 +895,7 @@ retry:
 	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
 		err = pnum;
+		up_read(&ubi->fm_sem);
 		goto out_leb_unlock;
 	}
 
@@ -895,6 +906,7 @@ retry:
 	if (err) {
 		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
@@ -902,10 +914,10 @@ retry:
 	if (err) {
 		ubi_warn("failed to write %d bytes of data to PEB %d",
 			 len, pnum);
+		up_read(&ubi->fm_sem);
 		goto write_error;
 	}
 
-	down_read(&ubi->fm_sem);
 	old_pnum = vol->eba_tbl[lnum];
 	vol->eba_tbl[lnum] = pnum;
 	up_read(&ubi->fm_sem);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 44ebefd..fbe9b5c 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -628,6 +628,7 @@ void ubi_refill_pools(struct ubi_device *ubi)
 
 /* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
  * the fastmap pool.
+ * Returns with ubi->fm_sem held in read mode!
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
@@ -636,15 +637,19 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
 again:
+	down_read(&ubi->fm_sem);
 	spin_lock(&ubi->wl_lock);
 	if (!pool->size || !wl_pool->size || pool->used >= pool->size ||
 	    wl_pool->used >= wl_pool->size) {
 		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_sem);
 		ret = ubi_update_fastmap(ubi);
 		if (ret) {
 			ubi_msg("Unable to write a new fastmap: %i", ret);
+			down_read(&ubi->fm_sem);
 			return -ENOSPC;
 		}
+		down_read(&ubi->fm_sem);
 		spin_lock(&ubi->wl_lock);
 	}
 
@@ -721,6 +726,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 		return err;
 	}
 
+	down_read(&ubi->fm_sem);
 	return peb;
 }
 #endif
-- 
1.8.4.5

