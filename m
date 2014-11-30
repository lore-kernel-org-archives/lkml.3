Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaK3MEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:04:55 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14391 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaK3MEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:04:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/6] UBI: Fastmap: Rework fastmap error paths
Date: Sun, 30 Nov 2014 13:04:30 +0100
Message-Id: <1417349070-8894-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349070-8894-1-git-send-email-richard@nod.at>
References: <1417349070-8894-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If UBI is unable to write the fastmap to the device
we have make sure that upon next attach UBI will fall
back to scanning mode.
In case we cannot ensure that they only thing we can do
is falling back to read-only mode.

The current error handling code is not powercut proof.
It could happen that a powercut while invalidating would
lead to a state where an too old fastmap could be used upon
attach.
This patch addresses the issue by writing a fake fastmap
super block to a fresh PEB instead of reerasing the existing one.
The fake fastmap super block will UBI case to do a full scan.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 162 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 114 insertions(+), 48 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 762e25c..db2625d 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1300,31 +1300,87 @@ out:
 /**
  * invalidate_fastmap - destroys a fastmap.
  * @ubi: UBI device object
- * @fm: the fastmap to be destroyed
  *
+ * This function ensures that upon next UBI attach a full scan
+ * is issued. We need this if UBI is about to write a new fastmap
+ * but is unable to do so. In this case we have two options:
+ * a) Make sure that the current fastmap will not be usued upon
+ * attach time and contine or b) fall back to RO mode to have the
+ * current fastmap in a valid state.
  * Returns 0 on success, < 0 indicates an internal error.
  */
-static int invalidate_fastmap(struct ubi_device *ubi,
-			      struct ubi_fastmap_layout *fm)
+static int invalidate_fastmap(struct ubi_device *ubi)
 {
 	int ret;
-	struct ubi_vid_hdr *vh;
+	struct ubi_fastmap_layout *fm;
+	struct ubi_wl_entry *e;
+	struct ubi_vid_hdr *vh = NULL;
 
-	ret = erase_block(ubi, fm->e[0]->pnum);
-	if (ret < 0)
-		return ret;
+	if (!ubi->fm)
+		return 0;
+
+	ubi->fm = NULL;
+
+	ret = -ENOMEM;
+	fm = kzalloc(sizeof(*fm), GFP_KERNEL);
+	if (!fm)
+		goto out;
 
 	vh = new_fm_vhdr(ubi, UBI_FM_SB_VOLUME_ID);
 	if (!vh)
-		return -ENOMEM;
+		goto out_free_fm;
+
+	ret = -ENOSPC;
+	e = ubi_wl_get_fm_peb(ubi, 1);
+	if (!e)
+		goto out_free_fm;
 
-	/* deleting the current fastmap SB is not enough, an old SB may exist,
-	 * so create a (corrupted) SB such that fastmap will find it and fall
-	 * back to scanning mode in any case */
+	/*
+	 * Create fake fastmap such that UBI will fall back
+	 * to scanning mode.
+	 */
 	vh->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
-	ret = ubi_io_write_vid_hdr(ubi, fm->e[0]->pnum, vh);
+	ret = ubi_io_write_vid_hdr(ubi, e->pnum, vh);
+	if (ret < 0) {
+		ubi_wl_put_fm_peb(ubi, e, 0, 0);
+		goto out_free_fm;
+	}
 
+	fm->used_blocks = 1;
+	fm->e[0] = e;
+
+	ubi->fm = fm;
+
+out:
+	ubi_free_vid_hdr(ubi, vh);
 	return ret;
+
+out_free_fm:
+	kfree(fm);
+	goto out;
+}
+
+/**
+ * return_fm_pebs - returns all PEBs used by a fastmap back to the
+ * WL sub-system.
+ * @ubi: UBI device object
+ * @fm: fastmap layout object
+ */
+static void return_fm_pebs(struct ubi_device *ubi,
+			   struct ubi_fastmap_layout *fm)
+{
+	int i;
+
+	if (!fm)
+		return;
+
+	for (i = 0; i < fm->used_blocks; i++) {
+		if (fm->e[i]) {
+			ubi_wl_put_fm_peb(ubi, fm->e[i], i,
+					  fm->to_be_tortured[i]);
+			fm->e[i] = NULL;
+		}
+	}
 }
 
 /**
@@ -1336,7 +1392,7 @@ static int invalidate_fastmap(struct ubi_device *ubi,
  */
 int ubi_update_fastmap(struct ubi_device *ubi)
 {
-	int ret, i;
+	int ret, i, j;
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
 
@@ -1376,34 +1432,40 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		tmp_e = ubi_wl_get_fm_peb(ubi, 0);
 		spin_unlock(&ubi->wl_lock);
 
-		if (!tmp_e && !old_fm) {
-			int j;
-			ubi_err(ubi, "could not get any free erase block");
-
-			for (j = 1; j < i; j++)
-				ubi_wl_put_fm_peb(ubi, new_fm->e[j], j, 0);
-
-			ret = -ENOSPC;
-			goto err;
-		} else if (!tmp_e && old_fm && old_fm->e[i]) {
-			ret = erase_block(ubi, old_fm->e[i]->pnum);
-			if (ret < 0) {
-				int j;
-
-				for (j = 1; j < i; j++)
-					ubi_wl_put_fm_peb(ubi, new_fm->e[j],
-							  j, 0);
+		if (!tmp_e) {
+			if (old_fm && old_fm->e[i]) {
+				ret = erase_block(ubi, old_fm->e[i]->pnum);
+				if (ret < 0) {
+					ubi_err(ubi, "could not erase old fastmap PEB");
+
+					for (j = 1; j < i; j++) {
+						ubi_wl_put_fm_peb(ubi, new_fm->e[j],
+								  j, 0);
+						new_fm->e[j] = NULL;
+					}
+					goto err;
+				}
+				new_fm->e[i] = old_fm->e[i];
+				old_fm->e[i] = NULL;
+			} else {
+				ubi_err(ubi, "could not get any free erase block");
+
+				for (j = 1; j < i; j++) {
+					ubi_wl_put_fm_peb(ubi, new_fm->e[j], j, 0);
+					new_fm->e[j] = NULL;
+				}
 
-				ubi_err(ubi, "could not erase old fastmap PEB");
+				ret = -ENOSPC;
 				goto err;
 			}
-			new_fm->e[i] = old_fm->e[i];
 		} else {
 			new_fm->e[i] = tmp_e;
 
-			if (old_fm && old_fm->e[i])
+			if (old_fm && old_fm->e[i]) {
 				ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
 						  old_fm->to_be_tortured[i]);
+				old_fm->e[i] = NULL;
+			}
 		}
 	}
 
@@ -1412,6 +1474,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		for (i = new_fm->used_blocks; i < old_fm->used_blocks; i++) {
 			ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
 					  old_fm->to_be_tortured[i]);
+			old_fm->e[i] = NULL;
 		}
 	}
 
@@ -1424,29 +1487,33 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		if (!tmp_e) {
 			ret = erase_block(ubi, old_fm->e[0]->pnum);
 			if (ret < 0) {
-				int i;
 				ubi_err(ubi, "could not erase old anchor PEB");
 
-				for (i = 1; i < new_fm->used_blocks; i++)
+				for (i = 1; i < new_fm->used_blocks; i++) {
 					ubi_wl_put_fm_peb(ubi, new_fm->e[i],
 							  i, 0);
+					new_fm->e[i] = NULL;
+				}
 				goto err;
 			}
 			new_fm->e[0] = old_fm->e[0];
 			new_fm->e[0]->ec = ret;
+			old_fm->e[0] = NULL;
 		} else {
 			/* we've got a new anchor PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0,
 					  old_fm->to_be_tortured[0]);
 			new_fm->e[0] = tmp_e;
+			old_fm->e[0] = NULL;
 		}
 	} else {
 		if (!tmp_e) {
-			int i;
 			ubi_err(ubi, "could not find any anchor PEB");
 
-			for (i = 1; i < new_fm->used_blocks; i++)
+			for (i = 1; i < new_fm->used_blocks; i++) {
 				ubi_wl_put_fm_peb(ubi, new_fm->e[i], i, 0);
+				new_fm->e[i] = NULL;
+			}
 
 			ret = -ENOSPC;
 			goto err;
@@ -1469,19 +1536,18 @@ out_unlock:
 	return ret;
 
 err:
-	kfree(new_fm);
-
 	ubi_warn(ubi, "Unable to write new fastmap, err=%i", ret);
 
-	ret = 0;
-	if (old_fm) {
-		ret = invalidate_fastmap(ubi, old_fm);
-		if (ret < 0) {
-			ubi_err(ubi, "Unable to invalidiate current fastmap!");
-			ubi_ro_mode(ubi);
-		}
-		else if (ret)
-			ret = 0;
+	ret = invalidate_fastmap(ubi);
+	if (ret < 0) {
+		ubi_err(ubi, "Unable to invalidiate current fastmap!");
+		ubi_ro_mode(ubi);
+	} else {
+		return_fm_pebs(ubi, old_fm);
+		return_fm_pebs(ubi, new_fm);
+		ret = 0;
 	}
+
+	kfree(new_fm);
 	goto out_unlock;
 }
-- 
1.8.4.5

