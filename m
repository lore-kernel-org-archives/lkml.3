Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaK3LhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:37:15 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaK3Lft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:35:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
Date: Sun, 30 Nov 2014 12:35:36 +0100
Message-Id: <1417347340-6872-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417347340-6872-1-git-send-email-richard@nod.at>
References: <1417347340-6872-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to allocate new ones every time, we can reuse
the existing ones.
This makes the code cleaner and more easy to follow.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 31 +++++--------------------------
 drivers/mtd/ubi/wl.c      | 11 +++++++----
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index db3defd..9507702 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1446,19 +1446,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	new_fm->used_blocks = ubi->fm_size / ubi->leb_size;
-
-	for (i = 0; i < new_fm->used_blocks; i++) {
-		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
-		if (!new_fm->e[i]) {
-			while (i--)
-				kfree(new_fm->e[i]);
-
-			kfree(new_fm);
-			mutex_unlock(&ubi->fm_mutex);
-			return -ENOMEM;
-		}
-	}
-
 	old_fm = ubi->fm;
 	ubi->fm = NULL;
 
@@ -1494,12 +1481,9 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				ubi_err(ubi, "could not erase old fastmap PEB");
 				goto err;
 			}
-
-			new_fm->e[i]->pnum = old_fm->e[i]->pnum;
-			new_fm->e[i]->ec = old_fm->e[i]->ec;
+			new_fm->e[i] = old_fm->e[i];
 		} else {
-			new_fm->e[i]->pnum = tmp_e->pnum;
-			new_fm->e[i]->ec = tmp_e->ec;
+			new_fm->e[i] = tmp_e;
 
 			if (old_fm)
 				ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
@@ -1524,16 +1508,13 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 							  i, 0);
 				goto err;
 			}
-
-			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
+			new_fm->e[0] = old_fm->e[0];
 			new_fm->e[0]->ec = ret;
 		} else {
 			/* we've got a new anchor PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0,
 					  old_fm->to_be_tortured[0]);
-
-			new_fm->e[0]->pnum = tmp_e->pnum;
-			new_fm->e[0]->ec = tmp_e->ec;
+			new_fm->e[0] = tmp_e;
 		}
 	} else {
 		if (!tmp_e) {
@@ -1546,9 +1527,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			ret = -ENOSPC;
 			goto err;
 		}
-
-		new_fm->e[0]->pnum = tmp_e->pnum;
-		new_fm->e[0]->ec = tmp_e->ec;
+		new_fm->e[0] = tmp_e;
 	}
 
 	down_write(&ubi->work_sem);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 47b215f..523d8a4 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1014,9 +1014,6 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 		e = fm_e;
 		ubi_assert(e->ec >= 0);
 		ubi->lookuptbl[pnum] = e;
-	} else {
-		e->ec = fm_e->ec;
-		kfree(fm_e);
 	}
 
 	spin_unlock(&ubi->wl_lock);
@@ -2008,9 +2005,15 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	dbg_wl("found %i PEBs", found_pebs);
 
-	if (ubi->fm)
+	if (ubi->fm) {
 		ubi_assert(ubi->good_peb_count == \
 			   found_pebs + ubi->fm->used_blocks);
+
+		for (i = 0; i < ubi->fm->used_blocks; i++) {
+			e = ubi->fm->e[i];
+			ubi->lookuptbl[e->pnum] = e;
+		}
+	}
 	else
 		ubi_assert(ubi->good_peb_count == found_pebs);
 
-- 
1.8.4.5

